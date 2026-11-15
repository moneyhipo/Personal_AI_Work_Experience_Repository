# Game modding in general

## Strictly separate bugs, intended behavior and balance changes

**Situation**: 5 items on a bug-fix list were actually original behavior. Some came from misreading the wiki. They had to be removed or moved to options in the next version.

**Rules**
- To claim "bug", cite both decompiled code (or data) and in-game text as evidence. The wiki or a guess is not evidence.
- Changes that alter behavior go in **options that are off by default**, worded neutrally, not "bug fix" or "restoring the original intent".
- Before release, check the whole fix list against the code again.

## Analyze game data before code

**Situation**: Most battle logic was in event data, not code (1,227 turn-end pages, enemy AI that counts turns with variables, rewards given by events instead of the DB, etc.).

**Rules**: Before designing, count game data files exhaustively with a script to know the scope in numbers. Run analysis in parallel with sub-agents and record results (IDs, locations, scale) in docs.

## Do not take the original's "in-between state" for a final state

**Situation**: The original turns on the default character switch first on the character select screen. The mod saw it and wrongly decided "that character was chosen".

**Rules**: Judge by the **moment it is final** (e.g. leaving the select screen), not the value itself.

## Do not judge by on-screen text

**Situation**: Code that judged situations by English sentences broke under a Korean patch.

**Rules**: Instead of text matching, judge by language-independent keys like IDs, positions, switch numbers.

## Do not clash with other mods

**Rules**
- Apply each fix in isolation. If one fails the rest still apply; log results as `[OK]/[SKIP]/[FAIL]/[CONFLICT]`.
- Find target functions by reflection etc.; if missing, SKIP instead of crashing. Safe even when the game or other mod versions differ.
- Consider conflict detection such as dropping our fix when another mod patches the same function. Mods on another loader or another patch library version may not be detected; state that in the README.
- Before binding a key, check that the original and other plugins don't already use it.

## Turning a single-player game multiplayer

**Situation**: "There is one protagonist" was baked in everywhere (about 13,900 character branches, 48+ paths to instant game over on protagonist death, about 1,468 unlosable battles, enemy AI chasing only the player, global unlock data recorded per PC).

**Rules**
- Before fixing the plan, survey every single-player assumption and show it as a list with numbers.
- Games with lots of randomness are hard to lockstep. Host-authoritative (host runs logic, guests are thin clients) is realistic.
- Cover what is lost when a guest only mirrors the screen: screen brightness/tint, weather, pictures, BGM, walking animation (teleporting only the position gives a "moonwalk"), original events reacting to guest input.
- Compress large snapshots (e.g. LZString).
- Write global records (unlocks etc.) only on the host.
- When a host-authoritative mod is used with single-player bug fixes, guard those patches with a condition like `IsHost` so they run only on the host.
- When making a standalone build that must not mix with the original multiplayer mod, change the version string, packet ID (salt) and assembly name.
- When making a rule that replaces an original command wholesale for multiplayer (e.g. "game over → that player goes down"), find every use of that command in the data and exclude uses that mean "normal end" (game over at the end of an ending etc.). Otherwise everyone freezes after watching an ending (FH2 co-op, 2026-10-29).

## Keep evidence for each fix candidate; change one place at a time

**Rules**
- For each candidate write `repro conditions / code-data evidence / original behavior / expected behavior / where to change / regression risk / how to check`.
- Do not change several places at once while the cause is unconfirmed. Narrow it down first with logs or a minimal repro test.

## Before touching saves or settings, build a way to recover

**Situation**: In the Lobotomy bug fixes, a Harmony patch stopped save loading and the user's equipment save was lost ([unity-mono-harmony.md](unity-mono-harmony.md)).

**Rules**
- Before touching the save format or load/save paths, back up the user's saves as a separate copy and experiment on the copy.
- Check compatibility of old-version saves with the new version.
- Write the way back (backup location, restore steps) in the handover doc.
