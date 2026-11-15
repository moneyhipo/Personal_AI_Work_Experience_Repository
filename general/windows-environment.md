# Windows environment and tools

## PowerShell 5.1 adds a UTF-8 BOM

**Situation**: A release notes file made with PowerShell 5.1 went up to a GitHub release with a BOM at the start.

**Cause**: In PowerShell 5.1, `Out-File` and `>` add a UTF-8 BOM.

**Rules**
- Write text that leaves the machine (release notes, scripts, data) without BOM.
  ```powershell
  [IO.File]::WriteAllText($path, $text, (New-Object Text.UTF8Encoding $false))
  ```
- After uploading, query the result again to check (e.g. `gh release view --json body`).

## Korean in Python output breaks (cp949)

**Cause**: The Windows console default encoding is cp949, and `python -I` ignores `PYTHONIOENCODING`.

**Rules**: Call `sys.stdout.reconfigure(encoding="utf-8")` in the script, or write results to a file with `encoding="utf-8"` and read it.

## Do not pass quote-heavy code through a heredoc

**Situation**: Passing a replace script with mixed quotes via `python - <<'EOF'` failed with "unexpected EOF".

**Rules**: Write long or quote-mixed scripts as `.py`/`.js` files in a temp folder and run them. Do code edits with the file edit tool where possible.

## Paths with spaces, `&`, Korean

**Situation**: Handled paths like `...\common\Fear & Hunger 2 Termina` and `새폴더`.

**Rules**
- Always wrap paths in double quotes. In bat use `set "GAME=..."`, `start "" /D "%GAME%" ...`.
- Do not hardcode install paths; search a list of candidates in turn, and allow overriding by argument or environment variable.

## Newly installed tool not found (PATH)

**Situation**: Right after `winget install GitHub.cli`, `gh` was not found in the same shell. A VS Code extension could not find .NET installed in the user folder.

**Rules**
- In the same shell, reload PATH.
  ```powershell
  $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
  ```
- For a permanent fix, register it in the user PATH (and `DOTNET_ROOT` if needed), and tell the user to fully restart apps like VS Code.

## Check tool version vs runtime compatibility

**Situation**: `ilspycmd` 8.2 needs the .NET 6 runtime and failed where only .NET 8 was installed.

**Rules**: When installing dotnet tools etc., pick the version matching the installed runtime.

## git "dubious ownership" error

**Situation**: git refused to work in a repository on a drive that does not record ownership (external, FAT/exFAT, etc.).

**Rules**: Do not change global config; add `git -c safe.directory='*' ...` per command. Change global config only with the user's consent.

## gh login: the device code does not come by email

**Situation**: The user was waiting, saying "the GitHub code isn't arriving".

**Rules**: The device code only shows in the terminal. This worked well:
1. Set `$env:GH_BROWSER='echo'` and run `gh auth login -h github.com -p https -w` in the background.
2. Pass the printed code and the `https://github.com/login/device` address to the user.

Note: a 404 from an unauthenticated GitHub API call may mean a private repository. Query with the logged-in `gh`.

## An image the user pasted may not be on disk

**Rules**: Before promising to save an image file, check that the file actually exists.

## Before deleting or overwriting, confirm the target and the way back

**Rules**
- Before `Remove-Item -Recurse`, `git clean`, forced checkout, mass replace, or overwriting a save, print the target list first.
- If there are uncommitted changes, decide how to keep them first; never reset without the user's approval.
- For files that are hard to recover, make a backup copy and write down its path.
- Bulk replaces like `sed -i` can change a file's line endings (CRLF). After replacing, check with `git diff --stat` that the number of changed lines matches the intent.
- In a Python string passed by heredoc through the Bash tool, `\'` (JS `\'`) loses its backslash and goes in as `'`. If JS code has escaped quotes, change that part with the Edit tool and run `node --check` afterwards.
