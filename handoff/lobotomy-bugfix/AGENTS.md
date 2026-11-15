# AGENTS.md - Lobotomy Corporation BugFix_Vanilla

Handover for coding agents (Codex etc.). Claude Code worked on it up to 2026-10-16. **Rules, structure and commands only.** Current version, state and to-dos are in the project repository's own `AGENTS.md` (top), `dev/HANDOFF.md` and `dev/CHANGELOG.md`; they are not copied here (2026-11-15 cleanup: this file still carried the 1.0.2-era state).

## What this repository does
- A BaseMod mod that fixes **bugs in the original game code** of Lobotomy Corporation (Unity, Mono, game version 1.0.2.13f1) with Harmony patches.
- Work repository (private): `moneyhipo/Vanilla-Bug-Fixes_only_work` (local folder `Lobotomy-Corporation-Bug-fixes`). Distribution: Nexus only (lobotomycorporation/mods/1448), uploaded by the user. The public release repository was removed by the user (2026-11).
- Size: bug fixes, an error log feature, and balance switches (off by default, toggled in game with F8).

## Rules for working with the user (must follow)
1. **Never slip in balance-changing fixes.**
   - Show the user first. If approved, add it as a balance switch that is off by default (`BalanceToggles.cs`).
   - Word switch descriptions neutrally: "Changes X to Y. Vanilla is Z." Do not call a switch a "bug fix".
   - Detailed fix criteria (switch vs bug fix, cut abnormalities, official names): the project's `CLAUDE.md`.
2. **The user judges design intent.** If it is unclear whether something is a bug or intended (setting/lore), ask before fixing.
   - The wiki is only a reference; the original code is the evidence.
   - There were cases misread as bugs from the wiki alone (Little Prince death stacks, Sound of a Star instant kill, etc.).
3. **Put in git only the files the mod itself needs.**
   - Included: source, Info, `Common.props`, README, LICENSE, AGENTS.md, `dev/`.
   - `dev/`: work records and an unreleased second mod, committed because the repository is private (`CHANGELOG.md`, `HANDOFF.md`, `audit/`, `ModBugFix/`). Never commit decompiled game code (`dev/audit/decomp/`).
   - Local only, not committed (`.gitignore`): `package.ps1`, `nexus/`, `dist/`.
4. Commit and push only when the user asks. The user uploads to Nexus.
5. Talk with the user in Korean. Text inside the mod, logs and the Nexus description are English. README is Korean.
6. Do not refactor code unrelated to the requested bug. Keep the existing fix style.

## Rules from past incidents
- **2026-10-14 save damage incident**
  - What happened: patching BaseMod's `InventoryModel.CreateEquipment_Mod` with Harmony 1.0.9.1 rebuilt the method and its try/catch stopped working. `LoadGlobalData` aborted and the user's equipment save was lost.
  - **Do not patch methods that rely on try/catch during normal play (especially load/save paths).** Use a full replacement prefix that never runs the original body, or hook the caller or callee instead.
  - After fixing, check the `[TRY]` lines in the log. Test with a copy of the save.
- **Harmony 1.0.9.1 limits**
  - No `___field` injection and no finalizers. Access private fields with `FieldRef<T>` or reflection.
  - Do not reference other mod DLLs at compile time. BaseMod loads them with `Assembly.LoadFile`, so handle them only via reflection.
- **Compile target:** compile against the game's Mono profile (mscorlib 2.0, System.Core 3.5). Using .NET 4.x reference assemblies gives a `System.Func`1` load failure. It is set in `Common.props`; do not change it.

## Structure
- `Common/FixCore.cs`
  - `Patcher`: applies fixes one by one. If one fails, the rest still apply.
  - `FieldRef<T>`, `ModTypes`, `FixLog` are here too.
- `Common/ConflictGuard.cs`: if another BaseMod rewrites the same function, drops our fix and logs `[CONFLICT]`.
- `VanillaBugFix/`
  - `FixList.cs`: where every fix is registered.
  - `Fixes_*.cs`: one fix = one static class (`Apply(Patcher p)` and hook methods).
  - `BalanceToggles.cs`, `BalanceUI.cs`: the F8 window and `BugFix_Vanilla_Balance.ini`.
  - `ErrorLogger.cs`: writes errors immediately to `BaseMods/BugFix_ErrorLogs/Error_*.txt`.
- To add a fix: write a static class in `Fixes_XXX.cs` and register one line in `FixList.cs`.

## Build and install
The game is at `D:\steam\steamapps\common\LobotomyCorp` on the main PC (check the project `CLAUDE.md` for the laptop path).

`Common.props` defaults `GameManaged` to `..\LobotomyCorp_Data\Managed\`. If this repository is outside the game folder (e.g. `C:\git_desk`), pass the path:

```
dotnet build VanillaBugFix -c Release -p:GameManaged=<game>\LobotomyCorp_Data\Managed\
```

- Install: copy `VanillaBugFix\bin\Release\BugFix_Vanilla.dll` to `<game>\LobotomyCorp_Data\BaseMods\BugFix_Vanilla\`.
- Release zip: `.\package.ps1 -Version x.y.z -GameManaged <path above>`. It is local only, not in git. If missing, put the built DLL and `Mod/BugFix_Vanilla/Info/` into a `BugFix_Vanilla/` folder and zip it (path separator `/`).
- Write changes in `dev/CHANGELOG.md`.
- Logs to check after running the game are under `LobotomyCorp_Data\BaseMods\`:
  - `BugFix_Vanilla_log.txt`: check `[FAIL]`, `[WARN]`, `[CONFLICT]`, `[TRY]`.
  - `BugFix_ErrorLogs\`
- Game run tests are not automated. The user checks behavior in the game.
- Decompile for reading the original: `ilspycmd -p -o <out> -r <Managed> <Managed>\BaseMod\BackUp.dll`
  - `BackUp.dll` is the original vanilla.
  - `Managed\Assembly-CSharp.dll` is the BaseMod-applied version.

## Other mods in the same game folder
- **Mirror multiplayer mod**: MelonLoader and Harmony 2, the host makes every judgement.
  - The user has a private fork: moneyhipo/LTC-MULTI-Private.
  - One of its to-dos is compatibility with this mod. Prefixes in this mod that replace an original function wholesale also run on clients, so host and client state can drift.

## When first taking over
Before changing code:
1. Read the project `CLAUDE.md`, `AGENTS.md` and `FixList.cs` to know the fix list and current state.
2. Check that it builds.
3. Report a summary to the user.
