# RPG Maker VX Ace (RGSS3) translation patches

Source: Death=Blood DEMO Korean patch (2026-11-15). A game whose data sits in the encrypted archive `Game.rgss3a`.

## If an archive exists, Data and Scripts are read only from inside it
**Situation**: Put a translated `Scripts.rvdata2` outside and changed the `Scripts=` path in `Game.ini`, and got "Failed to load script.". Deleting the file gave the same error (= it was never read). Suspected the Korean path, but an English path failed the same way.
**Cause**: When `Game.rgss3a` exists, RGSS3 looks for Data and Scripts only in the archive (guess: graphics and audio are still read from outside files).
**Rule**: Back up the original archive as `.orig` and build a new `Game.rgss3a` with only the translated Data files swapped in. Unchanged entries can be copied as-is, still encrypted (each file has its own key, independent of position). Even a 239MB archive takes under a second. Implementation: Death=Blood `tools/rgss3a.py` (`rebuild`), Marshal read/write `tools/rbmarshal.py` (byte-exact round trip checked on all 176 original files).

## When inserting a script entry, mark the code string's encoding too
Each entry in Scripts.rvdata2 is `[id, name, zlib code]`, and in the original both the name and code strings carry the `E: true` (UTF-8) ivar. Build new entries the same way and keep ids unique.

## Korean text rendering small comes from the font's vertical metrics
**Situation**: After switching to Noto Sans KR, Korean came out much smaller than English (about 17px), and line width calculations were off.
**Cause**: GDI fits `winAscent + winDescent` to Font.size pixels. Noto KR is 1.45em, so the glyph body shrinks.
**Rule**: With fontTools, make a copy with the OS/2 and hhea ascent/descent cut to about 1.15em, and rename the family since it is a modified font (OFL). Compute line width as `advance * size / (winAscent+winDescent)` too. After the change, capture the game screen to check.

## Capture the game window with PrintWindow
Even when covered by other windows, `PrintWindow(hwnd, dc, 2)` can capture the game window and error dialogs separately (Death=Blood `tools/shot.ps1`). Key input: `keybd_event` (`tools/keys.ps1`).
