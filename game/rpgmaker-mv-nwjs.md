# RPG Maker MV/MZ (NW.js) plugin mods

Source: Fear & Hunger 2: Termina ATB battle + co-op mod (RPG Maker MV 1.6.0, NW.js 0.29, Node 9.7)

## Check the engine version first

**Rules**
- `www/js/rpg_core.js` means MV; `rmmz_core.js` means MZ.
- Check NW.js/Node versions from `package.json` and the nw.exe version. On an old Node (e.g. 9.x) modern native modules (steamworks.js etc.) cannot be attached. Here it was worked around with a separate helper exe (C# etc.).

## Analyze the data files exhaustively

**Rules**: Tally `www/data/*.json` (Troops, CommonEvents, Maps, etc.) with Node scripts. Much of the battle, reward and AI logic is in event data. Searching by event command code (e.g. 129 change party member) shows the scope in numbers.

## Turn-based → ATB with a "global round clock"

**Situation**: With only personal gauges, "turn end" troop pages, `increaseTurn` and per-turn state durations do not run.

**Rules**
- Raising a virtual turn end every N ticks lets the original data be used unchanged.
- Turn off existing pseudo-ATB plugins (e.g. Galv_ExAgiTurn).
- YEP_BattleEngineCore's tick interface and Olivia_OctoBattle's OTB section can serve as reference implementations.

## Multi-part monsters share one gauge

**Situation**: Each part ran its own gauge and the enemy acted nonstop. Grouping parts then caused an infinite loop of parts calling each other.

**Rules**: Parts of one monster share one gauge, and a called part does not call other parts again. Do not group parts with different base AGI.

## When the gauge resets decides fairness

**Situation**: Resetting the gauge to 0 "after the action animation" cost the side with longer animations (the player) about 25%.

**Rules**: Reset to 0 at action start, and freeze all gauges during animations.

## F5 reload keeps Node state (ghost server)

**Situation**: After F5 the TCP server opened by the old code was still alive. The new server failed to open (EADDRINUSE) and guests connected to the old one.

**Cause**: F5 reloads only the page and game scripts; Node-side objects stay.

**Rules**: Keep sockets and servers in `global.__xxx`, and when the plugin starts, find and close the previous ones. Ghosts created before this handling only go away by fully killing the process. Tell the user too: "F5 won't do it, fully close and reopen the window".

## Key input

- F5 is the original's restart key.
- YEP_KeyboardConfig overwrites `Input.keyMapper`. Handle mod keys directly in a `document` keydown listener.

## Testing with two windows on one PC

**Situation**: Running Game.exe twice makes NW.js merge into the existing window.

**Rules**
- Put `"single-instance": false` in `package.json`.
- Start the second window with `--user-data-dir=<separate folder>`.
- Steam's Play button blocks duplicate runs, so run the exe directly.
- Show `[HOST]`/`[GUEST: name]` in the title bar.

## Install via a main.js loader instead of plugins.js

**Situation**: A Korean patch replaced `www/js/plugins.js` wholesale; the mod registration vanished and plugins that had been turned off came back on.

**Rules**: In `www/js/main.js`, append mod entries to `$plugins`, turn off unneeded plugins, then call `PluginManager.setup`. Installing is just unzip-and-overwrite; uninstalling restores `main.js.original`.

## Co-op sync details

- Build snapshots with `DataManager.makeSaveContents`, then send deltas about 10 times a second. They grew up to 1.8 MB, so they were compressed with LZString.
- New Game has no saved BGM, causing a `playBgm(null)` crash. The host sends the BGM currently playing.
- The original's running works by an event detecting Shift, so it does not work for guests.
- During a map transfer the event source is missing for 1 frame and YEP_SaveEventLocations crashed. Skip events without data, and turn off on the guest side original features the guest does not need.
- Chase AI like YEP_EventChasePlayer chases only `$gamePlayer`. In multiplayer the target selection has to change.

### In multiplayer, catch "the other PC is faster" with value logs
**Situation**: In FH2 co-op a report that guests moved faster went unsolved for three versions, because fixes assumed from reading code that "the engine dash (+1) is always on".
**Cause**: The original had dashing turned off by a plugin command (YEP_DashToggle `DisableDashing`). The guest-side replacement code did not look at this setting.
**Rules**: Log the real value (`realMoveSpeed`) on both PCs, and compare the same character running on original code (tutorial solo) vs on mod code. When writing code that replaces an original behavior, first grep for plugins that change that behavior (hooks like `isDashDisabled`).

### Put prototype hooks on the class that defines the method
**Situation**: In FH2 co-op duels, the rules "limb hits also cut the body, limbs don't heal, body/head broken = whole body falls" never worked for several versions. Tests passed too.
**Cause**: The hook was on `Game_BattlerBase.prototype.gainHp`, but MV's `gainHp` exists only on `Game_Battler.prototype`. The subclass definition is found first, so the hook was never called, and the saved original function variable was `undefined`. Tests did not check the result value (body HP).
**Rules**: Before hooking, find the class that really defines the method with `grep -n "prototype.<method> = " rpg_objects.js plugins/*.js`. Make the wrapper throw if the saved original is `undefined`, or keep one test that checks the hook's effect (value change).

### Rebuild the object when overwriting records used for causes/judgement
**Situation**: In FH2 co-op the abandoned house basement door would not open for host or guests. It started after a guest roamed alone, and cleared when the host left the map.
**Cause**: There was a record of "who last wrote this switch". On a new write only the id and time of the existing object were changed, so an `own: true` mark (that guest PC already ran the scene) from an old write carried into the next. The judgement had no expiry either, so the door's autorun page was skipped every frame.
**Rules**: Replace marks used for judgement with a whole new object on every write (`rec = { id, at }`). If a mark must live long, give it an expiry and clear it on load and on return to title.

### Measure time with the real clock, not `Graphics.frameCount`
**Situation**: FH2 co-op's "down for 60 seconds" ended in an instant.
**Cause**: MV's `Graphics.frameCount` counts drawn frames. Game logic runs fixed at 60 Hz, but on a 144 Hz monitor frameCount grows about 2.4× faster.
**Rules**: Measure times shown to players in seconds, and timeouts, with `performance.now()`. When sending to another PC, send remaining milliseconds, not absolute time (clocks differ per PC).

### MV applies damage before state effects
**Situation**: FH2 co-op judged "decapitation = instant death" by state 31 (Headless), but dying from a decapitation skill still gave a normal down.
**Cause**: `Game_Action.apply` applies damage first and state effects later. If the hit kills, the target is dead and the state is not added.
**Rules**: Judge "what attack killed it" by the action (skill ID), not the state, or compare before/after in an `apply` wrapper.

### In YEP battles "HP 0 = death" happens when the action ends
**Situation**: In FH2 co-op duels, cutting off every leg did not release the head lock. Tests passed.
**Cause**: YEP_BattleEngineCore's default action sequence sets `IMMORTAL: true` on the target at action start and removes it at the end. Meanwhile HP can reach 0 without the death state. The "if dead then X" logic judged by `isDead()` at `gainHp` time and was skipped every time. Tests called `action.apply()` directly, bypassing IMMORTAL.
**Rules**: Hang death-reacting logic on `refresh` or where the death state is actually added (or also check HP ≤ 0). Run battle tests through the `BattleManager` flow (including action sequences). YEP `_damagePopup` can be `false` until the sprite first reads it, so guarantee the array on paths that push directly.

### activate() on a closed choice window blocks message input forever
**Situation**: In FH2 co-op the host pressed OK on a dialogue window and it froze without advancing.
**Cause**: Shared dialogue sync code called `activate()` on the choice window (Window_ChoiceList) even for lines with no choices. MV's `Window_Message` ignores OK while a child window is active. Tests ran without a message window and missed it.
**Rules**: Activate child input windows (choice, number, item) only when `$gameMessage` actually requests that input and the window is open. Run message flow tests with a real `Window_Message` and child windows.

### Stubbing `SceneManager.push` in headless tests stops waiting for battles
**Situation**: In FH2 co-op a test of "undo the scene on battle loss" had the interpreter run straight past the battle (301) to the next command and judged it a win.
**Cause**: MV's `Game_Interpreter` waits for the battle scene change via `SceneManager.isSceneChanging()` (= `_nextScene` set). If the harness stubs `push` to do nothing, `_nextScene` never appears and it does not wait.
**Rules**: When running events that go through battles/scene changes headless, make `push` set `_nextScene`, have the test put in the battle result (win/lose/escape) itself, then clear `_nextScene`.

### Load/Options opened from the title are also `Scene_MenuBase`
**Situation**: In FH2 co-op, after a game over from everyone falling, the host opened Load from the title and the previous run's world started running again. A leftover enemy touched a guest and a battle appeared on the guest's screen, which was on the title.
**Cause**: The code "keep running the world in the background while a menu is open" only checked `SceneManager._scene instanceof Scene_MenuBase`. The title's Load/Options screens inherit the same class. Session state (connection, battle, map) stayed in memory after game over.
**Rules**: Gate background loops not just by scene inheritance but by an "in game now" flag and the scene stack (is Scene_Title in it). Explicitly end the session's game state on game over and going to title.

### Say "the original has no such feature" only after finding every place that calls it
**Situation**: In FH2 co-op, Codex looked only at the Moonscorch Osa (Map080 EV82) pages and concluded "the original has no field attack"; the user believed it and was about to drop the feature. Actually other events on the same map handled the attack: sight floor tiles turn on SW3772, a parallel event turns on SW3775 after an animation, and an autorun page calls CE420.
**Rules**: RPG Maker features are spread across switch/common event chains, not one enemy event. Before concluding something is missing, find related common events (search by name), and search every map for where they are called (117, scripts in move routes) and where their condition switches are turned on (121).

### "Per-player values" are not only switches: first look at what the original plugin really reads
**Situation**: In FH2 co-op a report came: "Abella chose weapon crafting in the tutorial but the crafting window has no weapons". At first the switch (SW1551) and skill (372) set by the history choice were suspected.
**Cause**: The crafting window (YEP_ItemSynthesis) looked at neither switch nor skill. It only checked whether that PC's bag had the blueprint item (248). Also the "already made" record lived in `$gameSystem._synthedWeapons`, so on guest PCs it was overwritten by the host's every time a host snapshot arrived.
**Rules**: When deciding "per-player values" in a multiplayer conversion, do not look only at switches and variables. Open the original plugin code that draws the feature (the window's list function etc.) and first check what it reads (bag, equipment, `$gameSystem` records, note tags). Build an audit script that pulls candidates from data and compares them automatically with the mod's current classification.

### A Steamworks.NET helper built with native AOT must touch callback structs by name
**Situation**: FH2 co-op's Steam helper (.NET compressed single file) was flagged by 2 engines (Bkav, VirIT) on VirusTotal. Without compression 1, built with native AOT 0. But the AOT build got Steam names and friend lists while the lobby creation reply (CallResult) never arrived.
**Cause**: Steamworks.NET reads callback/CallResult data with `Marshal.PtrToStructure(IntPtr, Type)`. Native AOT generates marshalling code only for structs it sees used in code. Build warning IL3053 was the signal.
**Rules**: In a function that never really runs, call `Marshal.PtrToStructure<T>(IntPtr.Zero)` once for every callback struct, and call that function from Main (actual execution blocked by a condition). After changing, test on real Steam: getting names, creating a lobby, joining a lobby. Two helpers on the same account can check up to joining; connection requests and messages need another account. Also, Nexus quarantines any upload containing an exe even with 0 detections. Keep the public source repository and build instructions updated alongside the exe.

### Removing the original's per-frame waste exposes code that relied on it
**Situation**: FH2 co-op lag reduction. (1) Original parallel events kept writing the same value, so `onChange` → full map refresh ran every frame. (2) The condition for using the nearest guest's fake `$gamePlayer` (stand-in) when updating events matched every event because of YEP "See Player" (enabled on all events by settings). Narrowing both cut frame time to 1/3, but narrowing the stand-in broke the doorless beast undo test.
**Cause**: Autorun pages `start()` during update, and several start wrappers decided whose start it was from `$gamePlayer._fhRemoteId` (is it a stand-in). "See Player" doesn't read the player, but the stand-in was used for this judgement as a side effect.
**Rules**: When removing per-frame waste (refreshing the same value, wide stand-ins): (a) grep every place that reads the side effects that path creates (`_fhRemoteId`, `_needsRefresh`, direct `_data` writes with no refresh after); (b) where something relied on the waste, do not bring the waste back; request it explicitly there (`requestRefresh`); (c) keep a list of exceptions (maps with pages that read mod state). Run the full tests per change to tell which fix broke what (toggle fixes one at a time). After loading a save the interpreter `_list` is a copy of the data list, so a "same object" comparison alone doesn't shrink it; add a content comparison and measure with a real save.

### Run multi-PC flow tests as "whole frames + real scene changes"
**Situation**: In FH2 co-op, 3000 tests calling one function each all passed, but the first flow tests where several PCs run frame by frame in turn (disconnect → reconnect, disconnect mid-dream, reconnect messages arriving at once) immediately found 3 real bugs (re-entering the dream map alone and the day passing twice, no picture name at the reconnect slot → exception in another PC's socket handler, waiting forever at the title).
**Cause**: Existing tests called handlers directly and only recorded scene changes, so "which scene receives which message when" was missing.
**Rules**
- Even in a headless harness, run the real `update()` of a picture-less scene (`Object.create(Scene_Map.prototype)` + sprite/window stand-ins) every frame. All the mod's frame hooks run.
- Do not replace `SceneManager.goto` wholesale (it skips the game over/retry wrappers the mod wraps around it). Promote the `_nextScene` created by the engine's goto **at the start of the next frame** (MV order is `changeScene` → `updateScene`; promoting at the end lets a disconnected PC's battle scene run one more frame and throw odd errors).
- Treat things that happen only once at boot (e.g. HIME_PreTitleEvents' first title = new game map) as "already happened".
- For disconnects make both sides see the close (host close handler + guest leave); for reconnects go for real from hello. Reproduce "messages after a big snapshot arrive in the same read" with a tool that holds messages and sends them at once (`hold/release`).
- V8 frees discarded vm contexts late and memory climbs to several GB. Run forced GC a few times per test (`v8.setFlagsFromString('--expose-gc')` + `vm.runInNewContext('gc')`).
- When a test finds a mod bug, do not fix it on the spot; leave a "known bug" mark so the suite passes, and write repro, location and fix plan in the report (once fixed, "now passes" shows).

### Do not imitate original staging; read the original event data and reuse it
**Situation**: FH2 co-op's betrayal tournament opening was built separately by the mod (one line in front of the door, darken + light at feet, a different heartbeat). Pose values were copied by hand from original seat events. The user said "use the original tower cutscene (Map111 EV617) as is" and it was changed (2026-11-03).
**Cause**: The original already had the same scene (companions turning Moonscorch), but a look-alike was built instead.
**Rules**: If a similar original scene exists, find it first. Read positions, directions and pictures from that event page at runtime (e.g. an event whose first page condition is switch S, where S comes from an "IF X in party → switch S" command = X's seat). For common events, copy the list, change only unwanted branches (e.g. a world-variable branch into script condition `false`) and run it in a local interpreter. Do not change world values (variables) for staging. In the headless harness FilterController falls over on the second `createFilter`, so tests make filter commands record only.

### Do not call other features inside processing that temporarily changes state
**Situation**: In FH2 co-op, "when a boss battle starts, pull in players in the same room" was hung on the host's world processing (`worldExtras`). Unit tests all passed, but in a flow test going through real battle scenes, when the host fought directly the pulled guest could not get into the battle (2026-11-03).
**Cause**: While the host is in battle, the background processing that runs the world sets `$gameParty._inBattle` to false. Requesting the join inside it made the host's join handler for itself see "battle still opening" and queue it; that queue was only flushed at battle start, which had already passed.
**Rules**: Inside processing that temporarily changes engine state (background world, guest context, stand-in player), do not call other features' entry points. If needed, call them outside (in the scene `update`). For such features, keep one flow test that goes through real scene changes besides unit tests.

### During `Game_Map.setupEvents` events are not yet in the map list
**Situation**: In FH2 co-op, after a guest watched the Pocketcat scene (Map036 EV239, autorun) on their own PC, the scene ran again for the host when the host entered that map, despite a check blocking "scenes already run on a guest PC" (2026-11-03).
**Cause**: The check ran only when `$gameMap.event(this.eventId()) === this` (to exclude copies made by snapshots). On map load, `new Game_Event` → `refresh` → `setupPage` → `checkEventTriggerAuto` → `start` is called before it is put into `_events[id]`, so the condition was false then and the whole check was skipped.
**Rules**: Judge "is this the map's real event" with `!slot || slot === this` (`slot = $gameMap._events[id]`). Test separately the path where an autorun starts right after map entry (a flow test that comes in from another map).

### Sweep all original data by bug type instead of reading map by map
**Situation**: A request to "audit what hasn't been looked at" had 76 maps left (2026-11-03).
**Rules**: Use the type of bug already found (e.g. switches turned on by map parallel pages stay only on that PC) as a condition and sweep all Map/CommonEvents/Troops JSON with a script. If there are many candidates, narrow them by properties like "never turned off anywhere in the game" to keep only story progress values. Keep the script that built the list in the repository's `tools/` so it can be rebuilt.

### Chase monster lag = pathfinding × event count (FH2 2026-11-04)
- MV's `findDirectionTo` (A*) scans every event on the map through `canPass` → `eventsXyNt` for every tile it tries. When the goal is the player's tile it is always blocked by an event and fills the search range to the end, so on a map with 900 events each step takes tens to 100 ms (in the original too). Nothing moves during the search, so building a "tile → events" table once at search start and having `eventsXyNt` use it only during the search gives the same answer, fast. Compare the changed search with the original function a few hundred random times to confirm the same direction.
- If a lag report says "near a certain monster", first look at that event's movement (YEP chase, custom route) and the map's event count. The harness (Node vm) has slow global access and inflates absolute times, so judge by ratio against the original.

## Translation patches (Hendrix_Localization + YEP_MessageCore)
Things that only showed up after actually running the game for the Courage and Death Korean patch (2026-11-15). Even when the patch has "0 lines with check problems", check the game screen separately.

### The original translation table (CSV) can be out of step with the game data
**Situation**: Translation was 99.6% filled, yet Chinese still showed here and there in the game. The user asked if a previously broken translation file was to blame.
**Cause**: The developer edited lines without re-exporting `game_messages.csv`, so the source column held old sentences (one different character breaks the exact match; 72 blocks). Scroll text (405) was not in the CSV at all (414 lines), nor were the battle message patterns in System.json `terms.messages` (`%1被击败了。`).
**Rules**: Do not count translation progress from the CSV source alone. Rebuild from the game data (Map, CommonEvents, Troops) the exact keys Hendrix looks up and compare with the CSV: 401 lines after a 101 joined by newlines (YEP `messageRows`, 4-line units), each 102 choice, 405 one line each. System patterns must be translated before `%1` is filled, so wrap `TextManager.message`. Append missing lines from a patch-side table (source<TAB>translation) to the end of the CSV.

### The saved config's language beats the default language setting
**Situation**: The plugin's default language was changed to ko, but the user's game still started in Chinese.
**Cause**: `config.rpgsave` held the previous language (zh) and `ConfigManager.applyData` used it.
**Rules**: Switch the language once only, the first time after the patch is installed. In `applyData`, if a marker key (`koPatchLangSet`) is missing, overwrite `config.language`, and have `makeData` save that key. After that, follow the language the user picks in options.

### A hook that turns on YEP WordWrap must not turn it on again while measuring word width
**Situation**: As soon as a dialogue window opened the game froze with `RangeError: Maximum call stack size exceeded` (drawTextEx → textWidthExCheck → checkWordWrap repeating).
**Cause**: The hook adding `<WordWrap>` in `Window_Message.convertEscapeCharacters` also added it inside `textWidthExCheck`, where YEP turns wrapping off to measure word width, turning wrapping back on.
**Rules**: Such hooks skip when `this._checkWordWrapMode` is true. Run any hook touching the dialogue window at least once in Node with a fake window before handing it over.

### Hendrix partial matching stops at short keys that translate to themselves
**Situation**: The item gain log `\I[296]\C[10][妨害]\C[0] 尸块 x1` came out in Chinese even though every piece was in the table.
**Cause**: Partial matching replaces only one place, longest source first, and keys like `[10]`→`[10]` (made by splitting multi-line rows per line) matched first, so the result stayed the same. Also Hendrix does not translate `drawTextEx`.
**Rules**: If Chinese characters remain, call Hendrix again per piece split by control codes and newlines, and if some still remain, per space-separated word. Strings stored in saves (gain and dialogue logs, `Game_Actor._name`) stay in the language at save time, so translate them when drawing (`drawTextEx`, `actorName`).
