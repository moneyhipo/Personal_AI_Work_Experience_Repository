# AGENTS.md - LTC-MULTI-Private (Mirror multiplayer mod fork)

Handover for coding agents (Codex etc.). To-dos and the mod's structure are in the repository's `README.md`; read it first. This file holds only rules and newer facts not in the README.

## State
- **No code work has started yet.** The repository only has:
  - the original Mirror v0.06ex1.1 (Nexus #1182) zip and DLL
  - decompiled source
  - 4 to-dos in the README
- Follow the README order (1 voting → 2 standalone build → 3 bug-fix compatibility → 4 compare with original), but confirm with the user before starting.

## Rules
1. **Keep this repository private.** It contains the original author's code.
   - Do not put code anywhere external: public repositories, issues, gists, etc.
2. Do not commit game files (`refs/`; listed in `.gitignore`).
3. Commit and push only when the user asks.
4. Talk with the user in Korean.
5. Mirror has the host make every judgement (`MatchmakingManager.IsHost`). When changing judgement logic, always check how it runs on both host and client.

## Facts that changed after the README
- **The list of 16 overlapping functions in to-do 3 (bug-fix compatibility) is outdated.**
  - BugFix_Vanilla has moved on (1.0.5 as of 2026-11, more fixes and balance switches); see that project's `AGENTS.md` for the current version.
  - Recount the overlapping functions. The source of truth is the BugFix repository (`moneyhipo/Vanilla-Bug-Fixes_only_work`, local `Lobotomy-Corporation-Bug-fixes`): `VanillaBugFix/FixList.cs` and `Fixes_*.cs`.
  - Harmony 1 limits and the save incident rules are in `handoff/lobotomy-bugfix/AGENTS.md`.
- Game install location: `D:\steam\steamapps\common\LobotomyCorp` (main PC)
  - MelonLoader and Mirror are installed (`Mods/`, `MelonLoader/`, `LobotomyCorp_Data/MirrorData`).
  - Copy the `refs/` files for README "prep on the main PC" from here:
    - `LobotomyCorp_Data/Managed/*.dll`
    - `MelonLoader/net35/MelonLoader.dll`, `MelonLoader/net35/0Harmony.dll` (the game is Mono, so use the net35 ones)
- That PC has `ilspycmd` and the .NET SDK installed.

## When first taking over
Before changing code:
1. Read the 6 voting services of to-do 1 and report the structure and the points to change to the user.
2. There is no build project (csproj, references) set up yet. First check whether the decompiled source can be rebuilt.
