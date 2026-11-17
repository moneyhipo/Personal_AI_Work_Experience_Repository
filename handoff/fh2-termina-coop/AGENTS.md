# AGENTS.md - Fear & Hunger 2: Termina ATB + Co-op mod

Handover for coding agents (Claude Code, Codex, etc.). **Rules, paths and commands only.** Current state, to-dos and questions for the user are at the **top** of the FH2 repository's `docs/진행상황.md`; state is not copied here (2026-11-10 cleanup: 0.41-era state and the latest were mixed; the original before cleanup is `기록/AGENTS_2026-11-10_정리전.md`).

## What this repository does
- A plugin mod adding **ATB gauge battles** and **co-op multiplayer (2-4 players, direct IP and Steam friend invites)** to F&H2 Termina (RPG Maker MV 1.6.0, NW.js 0.29, Node 9.7.1).
- Work repository (private): `moneyhipo/Fear-Hunger-2-Termina-multi-ATB_only_work` (local folder keeps the old name `Fear-Hunger-2-Termina-multi-ATP`), branch **`wip/0.38.3-duel-800hp`** (`main` is an old checkpoint).
- Public repository: `moneyhipo/FH2T-Co-op-and-ATB` (only files that go into the game folder; releases carry only the mod zip). Steam helper source and releases: `moneyhipo/FHSteamHelper-source-review` (v0.5.0).
- No original game files in the repository.

## Reading order
1. FH2 repository `CLAUDE.md` (if the session is opened outside the repository, e.g. `C:\git_desk`, it is not read automatically; open it yourself).
2. This file.
3. FH2 `docs/인수인계.md` (when switching PCs) → top of `docs/진행상황.md`.
4. When needed: `docs/변경기록.md` (per version, newest on top), `docs/기획_정리.md` (final plan and decisions), repository `README.md` (overview, folders, test commands). If README and 진행상황 differ, 진행상황 is right.

## User rules (must follow)
1. Text the mod shows on screen is **English** (for Nexus; Korean strings exist for the Korean patch). **Chat replies and the project's docs are Korean** (replies have leaked into English right after reading English code).
2. **Never edit original game data (`www/data/*.json`, original js).** All changes go in plugin code.
3. Base judgements on game data. The wiki (https://fearandhunger.wiki.gg/wiki/Fear_%26_Hunger_2:_Termina) is a reference.
4. The release must install by "unzip and overwrite" (the `www/js/main.js` loader appends plugins; `plugins.js` is not in the release - it clashes with the Korean patch).
5. **Commit/push:** when a fix is done and the filter tests pass, without asking: zip at the current version → drive bundle and guest zip → install to the game folder (only while the game is closed) → commit including dist and push (user 2026-11-03). Commit and push large work chunk by chunk. **Ask the user for a new version number and for public releases (public repository, GitHub release, Nexus).**
6. Do not refactor code unrelated to the request. The 6 plugins depend on each other's hook order (`mod/plugins_entries.txt` order).
7. **When a fix "sends it to the other side", re-audit right away (user 2026-11-09).** If a fix now sends information that was not sent before, compare both PCs of the same feature (values only one PC knows, values copied at start and never updated, values that only affect that PC's clock/events).
8. **Sub-agents only for work that can run in parallel** (user 2026-10-30, tokens). Write even large features in the main session, then reread the diff to review (every review found real bugs).
9. Record bug reports and fix requests right away (FH2 `docs/진행상황.md` or `docs/변경기록.md`).
10. Do not install into the game folder while the user is playing.
11. **Tidy the status docs every time a piece of work ends** (user 2026-11-15): finished items and answered questions go to `docs/기록(보관용)/`, used-up notes (task, done, diff) to `notes/old/`. Before reporting to-dos or questions, check `docs/변경기록.md` and `git log` that they are not already done. Details: `general/collaboration.md` "Tidy the .md files".

## Paths per PC
| | Laptop (2026-10-29~) | Main PC |
|---|---|---|
| Repository | `C:\git_desk\FH2\...` | `D:\git_desk\FH2\...` |
| Game | `C:\Program Files (x86)\Steam\steamapps\common\Fear & Hunger 2 Termina\` | `D:\steam\steamapps\common\Fear & Hunger 2 Termina\` |
| Test game copy (English original) | `FH2_GAME=C:/git_desk/FH2/FH2_dev_game` | `FH2_GAME=D:/git_desk/FH2/FH2_dev_game` |
| Machine | 16GB, i5-13420H, Node 26, .NET 10, python 3.12 | 16GB |

- The Steam game folder has the Korean patch, so English text checks fail if you test with it. Test with the copy.
- Debug logs: `<game folder>\fhcoop_logs\window_<pid>.log`. Look at bugs with every player's logs.
- (Old laptop `D:\github_desk`, 8GB: feature writing and filter tests only; full runs with `--max-old-space-size=1536`.)

## Install, build, test
- Dev install: close the game, `node tools/install.js "<game folder>"` (every time plugins change, and after the Korean patch overwrote things).
- Release zip: `node tools/make_release.js <version> --helper 0.5.0` → `dist/FH2_Coop_<version>.zip`. **Helper fixed at 0.5.0** (rebuilding changes its hash and triggers Defender false positives). PNP compat: `node tools/make_pnp_compat.js <version>`. Drive bundle, friend and guest zips: `tools/local_build/` (`bundle2.py`, `make_guest.py`, `python -I`). Do not bump the version on every fix (FH2 `docs/버전에 관한 내용.md`).
- Automated tests (real engine, plugins and data in Node, no game): **4 players by default** (host + 3 guests, 2026-11-10); `FH2_PLAYERS=2` for the old way. Tests whose meaning depends on player count: each tool's `EXACT_PLAYERS` table.
  - `node --expose-gc tools/test/run_tests.js [filter]` - unit (`FH_TEST_NAMES=1` adds test names to failures). Without forced GC it runs out of memory.
  - `node --expose-gc tools/test/flows.js [filter]`, `node tools/test/e2e_flow.js` - flows (`FH_PROF=1` measures frames and messages, `FLOW_SOAK_SEEDS=..` for soak seeds).
  - `node tools/test/e2e.js`, `e2e_sub.js` - real TCP.
  - Flows and e2e drop logs in the current folder, so run them in a temp folder. One at a time, output to a file. Do not edit `mod/` or `tools/test/` while a full run is going.
  - Normally only the changed feature's filters; the full suite (`sh tools/local_build/run_suite.sh <folder>`) before a version bump or after big game logic changes.
- Laptop 4-player full times: run_tests ~6 min, flows ~15 min, the 3 e2e ~1 min.
- Steam helper (C#): `tools/steam_helper`, `dotnet publish -c Release -o publish`, then copy the exe to `mod/fh_steam_helper/`.
- Testing with 2 windows on one PC: start the second with `tools/게스트창_실행.bat`.

## When first taking over
1. Read in the order above.
2. Run the filter tests for the feature you will change and see that they pass.
3. Report what you understood to the user briefly, in Korean.
