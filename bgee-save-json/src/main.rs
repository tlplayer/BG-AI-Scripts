use anyhow::{anyhow, bail, Context, Result};
use flate2::read::ZlibDecoder;
use flate2::write::ZlibEncoder;
use flate2::Compression;
use serde::{Deserialize, Serialize};
use std::env;
use std::fs::File;
use std::io::{Cursor, Read, Write};
use std::path::Path;
use zip::write::SimpleFileOptions;
use zip::{CompressionMethod, ZipArchive, ZipWriter};

const CRE_SIGNATURE: &[u8; 8] = b"CRE V1.0";
const MIN_CRE_HEADER_LEN: usize = 0x2d4;

const OFF_XP: usize = 0x0018;
const OFF_GOLD: usize = 0x001c;
const OFF_CURRENT_HP: usize = 0x0024;
const OFF_MAX_HP: usize = 0x0026;
const OFF_LEVEL_1: usize = 0x0234;
const OFF_LEVEL_2: usize = 0x0235;
const OFF_LEVEL_3: usize = 0x0236;
const OFF_CLASS: usize = 0x0273;
const OFF_DEATH_VARIABLE: usize = 0x0280;
const OFF_KIT: usize = 0x0244;

#[derive(Debug, Serialize, Deserialize)]
struct SaveDump {
    format: String,
    source: String,
    creatures: Vec<CreatureEdit>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct CreatureEdit {
    archive_path: String,
    cre_offset: usize,
    label: String,
    current_hp: u16,
    max_hp: u16,
    class_id: u8,
    level_1: u8,
    level_2: u8,
    level_3: u8,
    xp: u32,
    gold: u32,
    kit: u32,
}

#[derive(Debug, Clone, Copy)]
enum ArchiveKind {
    Zip,
    SavV1,
}

#[derive(Debug)]
struct SaveArchive {
    kind: ArchiveKind,
    entries: Vec<ArchiveEntry>,
}

#[derive(Debug)]
struct ArchiveEntry {
    name: String,
    bytes: Vec<u8>,
}

fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();
    match args.get(1).map(String::as_str) {
        Some("dump") if args.len() == 4 => dump_command(&args[2], &args[3]),
        Some("apply") if args.len() == 5 => apply_command(&args[2], &args[3], &args[4]),
        _ => {
            eprintln!(
                "Usage:\n  bgee-save-json dump <BALDUR.SAV> <out.json>\n  bgee-save-json apply <BALDUR.SAV> <edited.json> <out.SAV>"
            );
            std::process::exit(2);
        }
    }
}

fn dump_command(save_path: &str, json_path: &str) -> Result<()> {
    let archive = read_archive(save_path)?;
    let mut creatures = Vec::new();

    for entry in &archive.entries {
        for offset in find_cre_offsets(&entry.bytes) {
            if let Some(creature) = read_creature_edit(&entry.name, &entry.bytes, offset) {
                creatures.push(creature);
            }
        }
    }

    if creatures.is_empty() {
        bail!("no CRE V1.0 records found in {save_path}");
    }

    let dump = SaveDump {
        format: "bgee-save-json-v1".to_string(),
        source: save_path.to_string(),
        creatures,
    };

    let json = serde_json::to_string_pretty(&dump)?;
    std::fs::write(json_path, json).with_context(|| format!("writing {json_path}"))?;
    println!(
        "Wrote {json_path} with {} creature record(s).",
        dump.creatures.len()
    );
    Ok(())
}

fn apply_command(save_path: &str, json_path: &str, out_path: &str) -> Result<()> {
    if Path::new(save_path) == Path::new(out_path) {
        bail!("refusing to overwrite the input save; choose a different output path");
    }

    let mut archive = read_archive(save_path)?;
    let dump_bytes =
        std::fs::read_to_string(json_path).with_context(|| format!("reading {json_path}"))?;
    let dump: SaveDump =
        serde_json::from_str(&dump_bytes).with_context(|| format!("parsing {json_path}"))?;

    if dump.format != "bgee-save-json-v1" {
        bail!("unsupported JSON format '{}'", dump.format);
    }

    let mut patched = 0usize;
    for edit in &dump.creatures {
        let entry = archive
            .entries
            .iter_mut()
            .find(|entry| entry.name == edit.archive_path)
            .ok_or_else(|| anyhow!("archive member '{}' not found", edit.archive_path))?;
        patch_creature(&mut entry.bytes, edit)?;
        patched += 1;
    }

    write_archive(out_path, &archive)?;
    println!("Wrote {out_path} with {patched} patched creature record(s).");
    Ok(())
}

fn read_archive(path: &str) -> Result<SaveArchive> {
    let bytes = std::fs::read(path).with_context(|| format!("opening {path}"))?;
    if bytes.starts_with(b"SAV V1.0") {
        return read_sav_v1_archive(&bytes)
            .with_context(|| format!("reading SAV V1.0 archive {path}"));
    }

    read_zip_archive(Cursor::new(bytes)).with_context(|| format!("reading zip archive {path}"))
}

fn read_zip_archive<R: Read + std::io::Seek>(reader: R) -> Result<SaveArchive> {
    let mut archive = ZipArchive::new(reader)?;
    let mut entries = Vec::with_capacity(archive.len());

    for index in 0..archive.len() {
        let mut file = archive.by_index(index)?;
        if file.is_dir() {
            continue;
        }
        let mut bytes = Vec::new();
        file.read_to_end(&mut bytes)?;
        entries.push(ArchiveEntry {
            name: file.name().to_string(),
            bytes,
        });
    }

    Ok(SaveArchive {
        kind: ArchiveKind::Zip,
        entries,
    })
}

fn read_sav_v1_archive(bytes: &[u8]) -> Result<SaveArchive> {
    let mut offset = 8usize;
    let mut entries = Vec::new();

    while offset < bytes.len() {
        let filename_len = read_u32_at(bytes, offset)? as usize;
        offset += 4;

        let filename_bytes = bytes
            .get(offset..offset + filename_len)
            .ok_or_else(|| anyhow!("truncated filename at offset 0x{offset:x}"))?;
        offset += filename_len;

        let unpacked_len = read_u32_at(bytes, offset)? as usize;
        offset += 4;
        let packed_len = read_u32_at(bytes, offset)? as usize;
        offset += 4;

        let packed = bytes
            .get(offset..offset + packed_len)
            .ok_or_else(|| anyhow!("truncated compressed data at offset 0x{offset:x}"))?;
        offset += packed_len;

        let name_end = filename_bytes
            .iter()
            .position(|byte| *byte == 0)
            .unwrap_or(filename_bytes.len());
        let name = String::from_utf8_lossy(&filename_bytes[..name_end]).to_string();

        let mut decoder = ZlibDecoder::new(packed);
        let mut unpacked = Vec::with_capacity(unpacked_len);
        decoder.read_to_end(&mut unpacked)?;
        if unpacked.len() != unpacked_len {
            bail!(
                "{name} decompressed to {} bytes, expected {unpacked_len}",
                unpacked.len()
            );
        }

        entries.push(ArchiveEntry {
            name,
            bytes: unpacked,
        });
    }

    Ok(SaveArchive {
        kind: ArchiveKind::SavV1,
        entries,
    })
}

fn write_archive(path: &str, archive: &SaveArchive) -> Result<()> {
    match archive.kind {
        ArchiveKind::Zip => write_zip_archive(path, &archive.entries),
        ArchiveKind::SavV1 => write_sav_v1_archive(path, &archive.entries),
    }
}

fn write_zip_archive(path: &str, entries: &[ArchiveEntry]) -> Result<()> {
    let file = File::create(path).with_context(|| format!("creating {path}"))?;
    let mut writer = ZipWriter::new(file);
    let options = SimpleFileOptions::default().compression_method(CompressionMethod::Deflated);

    for entry in entries {
        writer.start_file(&entry.name, options)?;
        writer.write_all(&entry.bytes)?;
    }

    writer.finish()?;
    Ok(())
}

fn write_sav_v1_archive(path: &str, entries: &[ArchiveEntry]) -> Result<()> {
    let mut out = File::create(path).with_context(|| format!("creating {path}"))?;
    out.write_all(b"SAV V1.0")?;

    for entry in entries {
        let mut encoder = ZlibEncoder::new(Vec::new(), Compression::default());
        encoder.write_all(&entry.bytes)?;
        let packed = encoder.finish()?;

        let filename_len = entry.name.len() + 1;
        out.write_all(&(filename_len as u32).to_le_bytes())?;
        out.write_all(entry.name.as_bytes())?;
        out.write_all(&[0])?;
        out.write_all(&(entry.bytes.len() as u32).to_le_bytes())?;
        out.write_all(&(packed.len() as u32).to_le_bytes())?;
        out.write_all(&packed)?;
    }

    Ok(())
}

fn find_cre_offsets(bytes: &[u8]) -> impl Iterator<Item = usize> + '_ {
    bytes
        .windows(CRE_SIGNATURE.len())
        .enumerate()
        .filter_map(|(offset, window)| (window == CRE_SIGNATURE).then_some(offset))
}

fn read_creature_edit(archive_path: &str, bytes: &[u8], cre_offset: usize) -> Option<CreatureEdit> {
    let cre = bytes.get(cre_offset..)?;
    if cre.len() < MIN_CRE_HEADER_LEN || cre.get(0..8)? != CRE_SIGNATURE {
        return None;
    }

    Some(CreatureEdit {
        archive_path: archive_path.to_string(),
        cre_offset,
        label: read_clean_string(cre, OFF_DEATH_VARIABLE, 32)
            .filter(|s| !s.is_empty())
            .unwrap_or_else(|| format!("{archive_path}@0x{cre_offset:x}")),
        current_hp: read_u16(cre, OFF_CURRENT_HP)?,
        max_hp: read_u16(cre, OFF_MAX_HP)?,
        class_id: *cre.get(OFF_CLASS)?,
        level_1: *cre.get(OFF_LEVEL_1)?,
        level_2: *cre.get(OFF_LEVEL_2)?,
        level_3: *cre.get(OFF_LEVEL_3)?,
        xp: read_u32(cre, OFF_XP)?,
        gold: read_u32(cre, OFF_GOLD)?,
        kit: read_u32(cre, OFF_KIT)?,
    })
}

fn patch_creature(bytes: &mut [u8], edit: &CreatureEdit) -> Result<()> {
    let cre = bytes.get_mut(edit.cre_offset..).ok_or_else(|| {
        anyhow!(
            "{} offset 0x{:x} is outside the archive member",
            edit.archive_path,
            edit.cre_offset
        )
    })?;

    if cre.len() < MIN_CRE_HEADER_LEN || cre.get(0..8) != Some(CRE_SIGNATURE.as_slice()) {
        bail!(
            "{} offset 0x{:x} no longer points to a CRE V1.0 record",
            edit.archive_path,
            edit.cre_offset
        );
    }

    write_u16(cre, OFF_CURRENT_HP, edit.current_hp)?;
    write_u16(cre, OFF_MAX_HP, edit.max_hp)?;
    write_u32(cre, OFF_XP, edit.xp)?;
    write_u32(cre, OFF_GOLD, edit.gold)?;
    write_u32(cre, OFF_KIT, edit.kit)?;
    write_u8(cre, OFF_CLASS, edit.class_id)?;
    write_u8(cre, OFF_LEVEL_1, edit.level_1)?;
    write_u8(cre, OFF_LEVEL_2, edit.level_2)?;
    write_u8(cre, OFF_LEVEL_3, edit.level_3)?;
    Ok(())
}

fn read_u16(bytes: &[u8], offset: usize) -> Option<u16> {
    let raw = bytes.get(offset..offset + 2)?;
    Some(u16::from_le_bytes([raw[0], raw[1]]))
}

fn read_u32(bytes: &[u8], offset: usize) -> Option<u32> {
    let raw = bytes.get(offset..offset + 4)?;
    Some(u32::from_le_bytes([raw[0], raw[1], raw[2], raw[3]]))
}

fn read_u32_at(bytes: &[u8], offset: usize) -> Result<u32> {
    read_u32(bytes, offset).ok_or_else(|| anyhow!("expected u32 at offset 0x{offset:x}"))
}

fn write_u8(bytes: &mut [u8], offset: usize, value: u8) -> Result<()> {
    *bytes
        .get_mut(offset)
        .ok_or_else(|| anyhow!("offset 0x{offset:x} is outside the CRE header"))? = value;
    Ok(())
}

fn write_u16(bytes: &mut [u8], offset: usize, value: u16) -> Result<()> {
    let target = bytes
        .get_mut(offset..offset + 2)
        .ok_or_else(|| anyhow!("offset 0x{offset:x} is outside the CRE header"))?;
    target.copy_from_slice(&value.to_le_bytes());
    Ok(())
}

fn write_u32(bytes: &mut [u8], offset: usize, value: u32) -> Result<()> {
    let target = bytes
        .get_mut(offset..offset + 4)
        .ok_or_else(|| anyhow!("offset 0x{offset:x} is outside the CRE header"))?;
    target.copy_from_slice(&value.to_le_bytes());
    Ok(())
}

fn read_clean_string(bytes: &[u8], offset: usize, len: usize) -> Option<String> {
    let raw = bytes.get(offset..offset + len)?;
    let end = raw.iter().position(|byte| *byte == 0).unwrap_or(raw.len());
    let text = String::from_utf8_lossy(&raw[..end]).trim().to_string();
    Some(text)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn reads_and_patches_cre_fields() {
        let mut bytes = vec![0u8; MIN_CRE_HEADER_LEN];
        bytes[..8].copy_from_slice(CRE_SIGNATURE);
        bytes[OFF_DEATH_VARIABLE..OFF_DEATH_VARIABLE + 4].copy_from_slice(b"CH01");
        write_u16(&mut bytes, OFF_CURRENT_HP, 7).unwrap();
        write_u16(&mut bytes, OFF_MAX_HP, 12).unwrap();
        write_u32(&mut bytes, OFF_XP, 345).unwrap();
        write_u32(&mut bytes, OFF_GOLD, 67).unwrap();
        write_u32(&mut bytes, OFF_KIT, 0x4001_0000).unwrap();
        write_u8(&mut bytes, OFF_CLASS, 2).unwrap();
        write_u8(&mut bytes, OFF_LEVEL_1, 3).unwrap();

        let mut edit = read_creature_edit("BALDUR.GAM", &bytes, 0).unwrap();
        assert_eq!(edit.label, "CH01");
        assert_eq!(edit.current_hp, 7);
        assert_eq!(edit.max_hp, 12);
        assert_eq!(edit.class_id, 2);

        edit.current_hp = 99;
        edit.class_id = 11;
        patch_creature(&mut bytes, &edit).unwrap();

        let patched = read_creature_edit("BALDUR.GAM", &bytes, 0).unwrap();
        assert_eq!(patched.current_hp, 99);
        assert_eq!(patched.class_id, 11);
    }
}
