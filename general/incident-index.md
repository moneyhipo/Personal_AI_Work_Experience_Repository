# Big incident index

For a quick skim before work. Details and rules are in the linked docs.

| Risk | What happened | Doc |
|---|---|---|
| Save damage | A Harmony 1 patch removed the original try/catch, save loading stopped and the equipment save was lost | [unity-mono-harmony.md](../game/unity-mono-harmony.md), [modding-common.md](../game/modding-common.md) "Before touching saves or settings" |
| Misjudging original behavior | Calling something a bug from the wiki or a feeling changes intended behavior and balance | [modding-common.md](../game/modding-common.md) |
| Edits clashing between AI tools | While a Claude agent was stopped, Codex edited the same files; tests failed in the mixed state and new bugs appeared | [collaboration.md](collaboration.md) "If another AI tool edited the same working tree" |
| Trusting tests too much | Passing builds and automated tests do not guarantee behavior in the real game or on another PC | [verification.md](verification.md) |
| Wrong public version | A tag/release went up under the wrong version without checking; deleted and re-released | [release-and-packaging.md](release-and-packaging.md) |
| Another patch overwrote the install | A Korean patch replaced the whole `plugins.js` and the mod registration vanished | [release-and-packaging.md](release-and-packaging.md) |
| Conflicting planning docs | Planning materials disagreed, the AI picked one on its own and built the wrong scope | [planning.md](planning.md) |
| Environment differences | PATH, runtime, encoding or paths differed; correct code still failed to run | [windows-environment.md](windows-environment.md) |
| Stale status docs | A status doc full of finished work and answered questions; the AI re-asked done items | [collaboration.md](collaboration.md) "Tidy the .md files" |
