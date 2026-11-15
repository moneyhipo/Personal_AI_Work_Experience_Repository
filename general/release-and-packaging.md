# Releases and packaging

## Before going public, get version, notes and attachments confirmed in one go

**Situation**: The user said "올리셈" (upload it), and the AI put up the tag and release as its recommended v1.1.0; the user wanted v1.0.2. The tag had to be deleted, re-released and a fix commit made; the wrong commit stayed in history.

**Rules**
- Right before tagging, releasing or pushing, show the version number, release notes and attached files together and get confirmation.
- Even with an "upload it" instruction, ask again if the version is not set. If there are two candidates, make the user pick explicitly.
- `grep` every place that carries the version string (metadata files in each language, README, zip names) and change them together.

## Always build release artifacts fresh from the latest source

**Situation**: The user asked if the DLL from an old release zip could be reused. That would drop later commits.

**Rules**: Build artifacts fresh from HEAD. Use old zips only as a reference for folder structure. For packaging, unpack the previous release, compare structure, and match it. Automate with a script like `make_release` where possible.

## Installs that edit original files clash with other patches

**Situation**: The mod install edited the game's config file (`plugins.js`), and a Korean patch replaced that file wholesale, so the mod registration vanished.

**Rules**
- Install through an entry point other patches are unlikely to overwrite (a loader approach).
- When editing an original, always back it up (`.bak_original`, `.bak_<time>`) and write how to revert in the README.

## Do not put copyrighted files in the repository

**Rules**
- No original game files, decompiled output or screenshots. Only mod files, docs and tools.
- Put `dist/`, `bin/`, `obj/` and reference DLL folders (`refs/` etc.) in `.gitignore`.
- Keep decompiled output only in a private repository or locally.

## If the work folder and the repository differ, do not forget the copy step

**Situation**: Work happened directly in the game folder, with the repository elsewhere.

**Rules**: Write the step of copying changed files into the repository before committing in the README, and check it every time.

## Fit release page docs to the platform's format

**Situation**: A txt description for Nexus looked like one solid "brick".

**Rules**
- The Nexus editor supports rich paste. Make HTML and have the user copy from the browser; if that fails, make BBCode.
- The user preferred a simple layout grouped by topic ("bug fixes / options") over per-version sections.
- Check that the count in a heading matches the number of list items.
- Write the test environment (program version, loader version) and log file path in the README. If compatibility with other loaders or versions was not checked, state "not tested".

## Pre-release checklist

- [ ] Branch and working tree (`git status --short`) are as intended.
- [ ] Version string is the same across code, metadata, docs and archive names.
- [ ] Full test results, and the scope not checked in the real game/environment.
- [ ] Release files were freshly built from the latest source. Unpack the archive into a temp folder and check internal paths match the install guide.
- [ ] License/copyright files present; no secrets, personal paths or tokens inside.
- [ ] Version, change summary, attachments and audience were shown to the user and approved.
- [ ] After uploading, the actually published files, description and tag were queried again on the platform.
