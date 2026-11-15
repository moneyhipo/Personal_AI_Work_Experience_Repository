# Verification and debugging

## Confirm versions and environments from files before stating them

**Situation**: The first reply stated the game engine was "RPG Maker MZ"; it was actually MV 1.6.0. The engine version decides which libraries are usable (e.g. no modern native modules on an old Node), so the design changes.

**Cause**: Relied on memory before reading files.

**Rules**: Confirm engine, runtime and framework versions from real files (`package.json`, core script names, DLL versions, etc.) before designing.

## "Build succeeded" is not "it works"

**Situation**: A C# mod built fine, but in the game not even its entry point ran, with no visible error.

**Rules**: Log at the entry point and confirm the log appears in the real runtime. If not confirmed, report it as unverified.

## Measure before guessing

**Situation**: A felt bug "enemy turns come too fast" was fixed by guessing from the code alone, which created another bug (an infinite loop).

**Rules**: For felt problems, first add measurement logs that record numbers (frame, target name, speed values, multipliers) and measure. Separate feel from logic with numbers, then fix. Before fixing, also check whether the implementation differs from the planning doc (sometimes the answer was already written there).

## Build substitute checks for things a human must operate

**Situation**: The AI cannot play the game, so the loop of the user testing and sending "doesn't work" screenshots was slow.

**Rules** (what helped most)
- Connect to the real protocol with a fake client script to check the server side.
- Leave a log file per running instance so that when the user says "look at the log" the AI can read it directly.
- Build an automated test harness that runs the real engine and data headless.
- After implementation, keep a separate review step that rereads the diff from the start (in the main session, `collaboration.md` "Sub-agents only when running in parallel"). Each round found a fair number of defects.
- When testing with several windows, mark the role in the window title like `[HOST]`/`[GUEST]`. Once the user operated the wrong window and took it for a bug.

## Write error logs immediately, without duplicates

**Situation**: The original program's log was saved only on exit, so nothing remained after a crash, and the same error was written hundreds of times.

**Rules**: Write to file the moment an error happens. Count repeats of the same error (one line at 10, 100, 1000). Cap file count and size (e.g. latest 5, 5 MB each).

## For a strange error, check where environment variables came from first

**Situation**: An unrelated tool gave "MSys/Mingw is not supported". VS Code had been started from a Git Bash-type shell and inherited `MSYSTEM=MINGW64`.

**Rules**: Before editing config files, check which environment variables the process inherited. Here the fix was relaunching VS Code from the Start menu.

## Parallel sub-agents use separate temp files

**Situation**: Sub-agents running in parallel used the same file names in the same scratch folder and overwrote each other.

**Rules**: Tell each agent to use its own subfolder or unique file names.

## Write test results so they can be rerun

**Rules**
- Write the command, where it ran, pass/fail counts, failing test names, and what the tests do not cover.
- If the full suite was not run, write "full suite not run" (and the filter names if only related filters ran).
- After fixing a failure, always rerun the failed test. Deleting a failing test or weakening its condition to pass is not a fix.

## For regressions, look at feature boundaries and state changes

**Rules**
- Look not just at the new feature but at the existing flows it touches. In games/multiplayer, review whichever apply: normal progress → cancel/fail → death/quit → disconnect/reconnect → save/load.
- Test state-changing code split into before request / in progress / after success / after failure or cancel.
- For network messages, think about duplicate delivery, late messages, disconnects, and host vs guest authority.
- A bug-fix test must reproduce at least one of the conditions under which the bug happened.
- If an event is changed to wait for player input (a choice box etc.), find the existing tests that run that event to the end (not just filter tests but flow/e2e suites) and make them answer that input. Otherwise the next full run fails with "event still running", and you must separately work out whether the test or the code is at fault (FH2 0.6.0: flows G-1, G-2 after the soul text wait). First check whether it fails the same way on the code before the fix (stash).
