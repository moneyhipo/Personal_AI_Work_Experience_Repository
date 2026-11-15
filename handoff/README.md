# handoff/ - project handover

Docs read when another AI (Codex etc.) takes over a project Claude Code was working on (as of 2026-10-16).

(Old way, 2026-10-16, kept for record) Copying a folder's `AGENTS.md` to the project repository root made Codex read it automatically at start. Now it is not copied; each repository's `CLAUDE.md` points straight at the `AGENTS.md` in this folder (user 2026-10-31).

| Folder | Project | Repository |
|---|---|---|
| [lobotomy-bugfix/](lobotomy-bugfix/AGENTS.md) | Lobotomy Corporation vanilla bug fixes (BaseMod, Harmony 1) | moneyhipo/Lobotomy-Corporation-Bug-fixes |
| [fh2-termina-coop/](fh2-termina-coop/AGENTS.md) | Fear & Hunger 2: Termina ATB + co-op | moneyhipo/Fear-Hunger-2-Termina-multi-ATP |
| [ltc-multi-private/](ltc-multi-private/AGENTS.md) | Mirror multiplayer mod fork | private |

## Order for the receiving AI
1. Read the lessons in this repository's `general/` and `game/` first.
2. Read the project's `AGENTS.md` and the docs it points to.
3. The first job is analysis, not code changes. Work out the structure and what is left, and report to the user.
4. After that, one small change at a time. Run the filter tests for the changed feature (full suite only right before a version bump), and ask the user to check it in the game.
