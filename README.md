# BG-AI-Scripts
AI Scripts for BG 1 &amp; 2

AI script names cannot be > 8 characters otherwise the game can't find the scripts.

Keep the scripts in a seperate directory from where you compile otherwise comments will be removed

Add 1 code block at a time. Make globals at the top and do advanced conditionals there. Makes the code cleaner/easier to debug. 

Why all the ActionListEmpty()? From what I've seen, when the game starts the THEN block responses, it will start evaluating IFs in parallel.
Meaning, if you use lastseenby as the target in your checks, those checks will clear, the action will not start before the lastseenby changes to the next target
Cure light wounds on ally, blind ally, attack allies etc. Not great for RP. 
