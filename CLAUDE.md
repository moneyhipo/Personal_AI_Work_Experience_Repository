# Read first

Before starting work on any project, read in this order.

1. Read `Personal_AI_Work_Experience_Repository\README.md`. Following its reading order, read all of `general/` and the category folder for the project type (game mods: `game/`), and follow the rules.
2. Read the project handoff `Personal_AI_Work_Experience_Repository/handoff/<project>/AGENTS.md`. If the project folder has its own `AGENTS.md`, read that too.
3. When work produces a new lesson, add it to this repository.

## Always
- **Always reply to the user in Korean**, including progress and final reports. The "mod UI text is English" rule applies only to what shows on the game screen.
- **This repository is read only by AIs, so write it in English** (user 2026-11-15, fewer tokens). Project docs the user reads stay in Korean.
- **Use sub-agents only for work that can really run in parallel** (user 2026-10-30, tokens). Write even large features in the main session, then reread the whole diff in the main session (paths that cross disconnects, deaths, saves, wrapper order). After fixing what the review finds, rerun the related tests (name filters).
- **Run the full test suite only right before a version bump** (user 2026-10-30, time). Otherwise run only the filter tests for the changed feature and report the result.
- Commit and push only when the user asks.
- Before work, check existing changes with `git status --short` and `git diff --stat`; do not overwrite edits by the user or another AI tool.
- For saves, settings, public releases, mass deletes and mass replaces, first confirm the target and make a backup (a way back).
