# AI Experience Repository

Mistakes and lessons from doing projects together with AI (Claude and others).
**Meant for an AI to read before it starts a new project.** Only AIs read it, so it is written in English (user 2026-11-15); replies to the user are still in Korean.

## If this was shared with you (teammates and their AI)

This is moneyhipo's personal repository, shared as a reference for the team project (closet AI, `No_bulidname`).

- **Do not modify.** Do not edit, delete or push files. Do not create branches or PRs. If you want a lesson added, write it in the "Requests to AI" table in the team repository README and ask moneyhipo.
- **Read only the shared docs where you can**: `general/` (general) and, for Android app work, `mobile/`. `game/` and `handoff/` are personal project records; you may consult them but prefer not to.
- Step 4 of the reading order below (suggest adding new lessons here) is replaced, for shared readers, by the request method above.

## For AI: reading order

1. Always read the docs in `general/`, whatever the project type.
2. Read the category folder for the project type. Example: game mods or game dev `game/`, Android apps `mobile/`.
3. Each entry is ordered `Situation → Cause → Rules`. Follow the **Rules** when working.
4. When a new lesson comes up during work, suggest adding it to this repository to the user.
5. When starting a new project, create `CLAUDE.md` in the project folder and write "read this repository's README first, then work" and "reply in Korean". Example: `Fear-Hunger-2-Termina-multi-ATP/CLAUDE.md`.

## Contents

### general/ (general)
| Doc | Content |
|---|---|
| [collaboration.md](general/collaboration.md) | Talking with the user, status reports, handover, tidying status docs, when tools are blocked |
| [verification.md](general/verification.md) | No guessing, how to verify and debug |
| [windows-environment.md](general/windows-environment.md) | Windows, PowerShell, encoding, paths, git and gh |
| [release-and-packaging.md](general/release-and-packaging.md) | Releases, versions, packaging, copyright |
| [planning.md](general/planning.md) | Checking planning docs against each other, data sources, feature doc structure, doc links |
| [incident-index.md](general/incident-index.md) | Index of big incidents (save damage, test overconfidence, wrong releases); skim before work |

### mobile/ (mobile apps)
| Doc | Content |
|---|---|
| [android-play-release.md](mobile/android-play-release.md) | Google Play launch requirements (closed testing, target API), WebView spam policy |

### game/ (games)
| Doc | Content |
|---|---|
| [modding-common.md](game/modding-common.md) | Game modding in general: judging bugs, data analysis, turning a game multiplayer |
| [unity-mono-harmony.md](game/unity-mono-harmony.md) | Unity Mono games + Harmony/BaseMod C# mods |
| [rpgmaker-mv-nwjs.md](game/rpgmaker-mv-nwjs.md) | RPG Maker MV/MZ (NW.js) JS plugin mods, translation patches (Hendrix) |
| [rpgmaker-vxace-rgss3.md](game/rpgmaker-vxace-rgss3.md) | RPG Maker VX Ace (RGSS3) translation patches: rebuilding the archive, Korean font metrics |
| [ai-illustration.md](game/ai-illustration.md) | AI illustration for game assets (NovelAI): prompt rules, negative prompt traps, soft pastel style, character consistency, retouching upscales |

### handoff/ (project handover)
| Doc | Content |
|---|---|
| [handoff/README.md](handoff/README.md) | Per-project `AGENTS.md` for ongoing projects. Read when another AI takes over |

## Source projects

- Lobotomy Corporation vanilla bug fixes (Unity Mono, C#, Harmony 1, BaseMod)
- Fear & Hunger 2: Termina ATB battle + co-op multiplayer mod (RPG Maker MV 1.6, NW.js, Node)
- Courage and Death (勇者与亡灵之都) Korean patch (RPG Maker MV, Hendrix_Localization)
- Overseas shop translation + digital closet Android app plan (Kotlin, FastAPI, aiming for Google Play)

## Adding a new lesson

- Put it in the matching category folder. If none fits, create one and add it to the contents above (e.g. `web/`, `embedded/`).
- **Write in English.** Quote the user's words in Korean only when the exact wording matters.
- Format: under `### Title`, **Situation / Cause / Rules**. Make the rules concrete enough to follow next time (files, commands, tests to check, not "be careful").
- If the cause is not confirmed, add `(guess)` to the cause line. If a rule was not confirmed in the real game/environment, state how far it was checked, e.g. `(automated tests only)`, so the next AI does not take a guess as fact.
- Technical problems that only apply to one project go in that tech doc (`game/` etc.) or `handoff/`; only mistakes that repeated across projects go in `general/`. Do not copy the same content into several docs; write it once and link.
- For a big incident (data damage, a wrong public release, etc.), add a line to [incident-index.md](general/incident-index.md).
- This is a public repository: never include personal information (email, real name, local user folder name, tokens, login codes).

## When docs disagree

- Current files and run results win over past records. If a record and the current code differ, do not overwrite silently; note the date and why it changed.
- The user's direct instructions and approved decisions win over general AI practice. A project's `CLAUDE.md`/`AGENTS.md` applies only to that project.
- If you cannot decide which is right, do not pick one yourself; ask the user.
