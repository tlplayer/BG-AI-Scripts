# bgee-save-json

Tiny JSON-first save editor for Baldur's Gate Enhanced Edition saves.

It treats `BALDUR.SAV` as either an Enhanced Edition zip archive or the older
`SAV V1.0` zlib archive, scans every archive member for embedded `CRE V1.0`
records, dumps a small editable JSON view, and can patch changed values back into
a new save file.

## Build

```sh
cargo build --release
```

## Usage

Dump editable creature records:

```sh
cargo run -- dump /path/to/BALDUR.SAV save.json
```

Edit `save.json`, then write a new save:

```sh
cargo run -- apply /path/to/BALDUR.SAV save.json /path/to/BALDUR-edited.SAV
```

Copy the new `.SAV` into a new save slot folder. Keep the original save until
the edited one has loaded correctly in-game.

## Editable Fields

- `current_hp`
- `max_hp`
- `class_id`
- `level_1`, `level_2`, `level_3`
- `xp`
- `gold`
- `kit`

The `archive_path` and `cre_offset` fields identify the exact creature bytes to
patch and should not be changed.
