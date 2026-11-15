# Unity Mono games + Harmony C# mods

Source: Lobotomy Corporation bug-fix mod (Assembly-CSharp, Harmony 1.0.9.1, BaseMod, Mono with .NET 3.5 profile)

## The .NET SDK slips in other reference assemblies instead of the game's mscorlib (most fatal)

**Situation**: The build succeeded, but in the game the mod never reached its entry point, nothing applied, and no visible error.

**Cause**: The SDK used the net472 reference pack instead of the game's `Managed/mscorlib.dll`, so the DLL referenced mscorlib 4.0. The game's Mono (.NET 3.5 profile) cannot load `System.Func`1` etc. from that mscorlib.

**Rules**: Compile old Unity Mono game mods referencing only the DLLs in the game's `*_Data/Managed` folder.
```xml
<FrameworkPathOverride>$(GameManaged)</FrameworkPathOverride>
<NoStdLib>true</NoStdLib>
<DisableImplicitFrameworkReferences>true</DisableImplicitFrameworkReferences>
<AutomaticallyUseReferenceAssemblyPackages>false</AutomaticallyUseReferenceAssemblyPackages>
<LangVersion>7.3</LangVersion>
```
Always check which mscorlib version the build output references.

## Build reference DLLs only exist after installing the game and the mod loader

**Situation**: Building on a new PC gave 65 errors (`CodeInstruction` not found).

**Cause**: `0Harmony.dll` is not in the vanilla game; it appears in `Managed` only after installing the mod loader (BaseMod). Just running the mod manager does not install it.

**Rules**: Before building, check the needed reference DLLs exist. Whether the loader is installed can also be told from the modified time of `Assembly-CSharp.dll`. Keep the reference path overridable as a property like `-p:GameManaged=...`.

## Patching with Harmony 1 (Mono) can drop the original's try/catch (save damage)

**Situation**: Patching a method whose original swallows an exception with `catch(ArgumentNullException)` made the catch disappear at runtime. Save loading stopped and part of the saved equipment was lost.

**Rules**
- Do not put prefix/postfix on methods whose original relies on try/catch. Replace the whole method (prefix returns false) or hook a lower-level method.
- If an original with try/catch was patched, log a list of them for review.
- Suspect save-related paths first.

## Harmony 1.0.9.1 has no Unpatch

**Rules**: To drop our patch on conflict, edit PatchInfo directly. Run conflict checks after all mods load (first frame, scene load). Mods on other loaders using Harmony 2 (MelonLoader etc.) are invisible to this check.

## BaseMod instantiates every `Harmony_Patch` type

**Rules**: Put a static guard in the entry class to prevent double runs.

## NullReference every frame from destroyed objects

**Situation**: At the end of a day, child units threw NRE every frame and performance dropped. The cleanup function nulled only some references and kept animation objects running.

**Rules**: Prefer the minimal fix: a null guard in Update-type functions that skips.

## Unity UI modding traps

- The loader's option screen takes only static xml with no scroll or description, so only about 5 items fit. With many options, make your own IMGUI window.
- The IMGUI default font has no Korean. Specify a system font that has both Korean and English.
- Block clicks from leaking into the game while the window is open with a transparent full-screen uGUI image.
- Cache values so `OnGUI` does not build new strings every frame.
- Install optional patches always and check the switch at runtime, so they can be toggled mid-game. Save settings in ini etc.

## Decompiler tools

- Use the `ilspycmd` version matching the installed .NET runtime.
- Decompiled output is for finding causes. Do not put it in a public repository.
