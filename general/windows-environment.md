# Windows 환경과 도구

## PowerShell 5.1은 UTF-8 BOM을 붙인다

**상황**: PowerShell 5.1로 만든 릴리스 노트 파일 맨 앞에 BOM이 붙은 채 GitHub 릴리스에 올라갔습니다.

**원인**: PowerShell 5.1의 `Out-File`과 `>`는 UTF-8 BOM을 붙입니다.

**규칙**
- 외부로 보내는 텍스트(릴리스 노트, 스크립트, 데이터)는 BOM 없이 씁니다.
  ```powershell
  [IO.File]::WriteAllText($path, $text, (New-Object Text.UTF8Encoding $false))
  ```
- 올린 뒤에는 결과를 다시 조회해서 확인합니다(예: `gh release view --json body`).

## Python 출력의 한글이 깨진다 (cp949)

**원인**: Windows 콘솔 기본 인코딩은 cp949이고, `python -I`는 `PYTHONIOENCODING`을 무시합니다.

**규칙**: 스크립트 안에서 `sys.stdout.reconfigure(encoding="utf-8")`를 호출하거나, 결과를 `encoding="utf-8"` 파일로 쓴 뒤 읽습니다.

## 따옴표가 많은 코드를 헤레독으로 넘기지 않는다

**상황**: `python - <<'EOF'`로 따옴표가 섞인 치환 스크립트를 넘기다 "unexpected EOF" 오류로 실패했습니다.

**규칙**: 길거나 따옴표가 섞인 스크립트는 임시 폴더에 `.py`/`.js` 파일로 써서 실행합니다. 코드 수정은 가능하면 파일 편집 도구로 합니다.

## 공백, `&`, 한글이 섞인 경로

**상황**: `...\common\Fear & Hunger 2 Termina`, `새폴더` 같은 경로를 다뤘습니다.

**규칙**
- 경로는 항상 큰따옴표로 감쌉니다. bat에서는 `set "GAME=..."`, `start "" /D "%GAME%" ...` 형식을 씁니다.
- 설치 경로를 하드코딩하지 말고 후보 목록을 차례로 찾고, 인자나 환경변수로 덮어쓸 수 있게 합니다.

## 새로 설치한 도구가 인식되지 않는다 (PATH)

**상황**: `winget install GitHub.cli` 직후 같은 셸에서 `gh`가 인식되지 않았습니다. 사용자 폴더에 설치한 .NET을 VS Code 확장이 찾지 못했습니다.

**규칙**
- 같은 셸에서는 PATH를 다시 읽습니다.
  ```powershell
  $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
  ```
- 영구 적용은 사용자 PATH(필요하면 `DOTNET_ROOT`)에 등록하고, VS Code 같은 앱은 완전히 재시작하라고 안내합니다.

## 도구 버전과 런타임 호환을 확인한다

**상황**: `ilspycmd` 8.2는 .NET 6 런타임을 요구해서 .NET 8만 있는 환경에서 실패했습니다.

**규칙**: dotnet tool 등을 설치할 때는 설치된 런타임과 맞는 버전을 고릅니다.

## git "dubious ownership" 오류

**상황**: 소유권을 기록하지 않는 드라이브(외장·FAT/exFAT 등)의 저장소에서 git이 동작을 거부했습니다.

**규칙**: 전역 설정을 바꾸지 말고 명령마다 `git -c safe.directory='*' ...`를 붙입니다. 전역 설정 변경은 사용자 동의를 받은 뒤에만 합니다.

## gh 로그인: 장치 코드는 이메일로 오지 않는다

**상황**: 사용자가 "깃헙 코드가 안 온다"며 기다리고 있었습니다.

**규칙**: 장치 코드는 터미널에만 표시됩니다. 다음 방식이 잘 됐습니다.
1. `$env:GH_BROWSER='echo'`로 두고 `gh auth login -h github.com -p https -w`를 백그라운드로 실행합니다.
2. 출력된 코드와 `https://github.com/login/device` 주소를 사용자에게 전달합니다.

참고: 인증 없이 GitHub API를 호출해서 404가 나면 비공개 저장소일 수 있습니다. 조회는 로그인된 `gh`로 합니다.

## 사용자가 붙여 넣은 이미지가 디스크에 없을 수 있다

**규칙**: 이미지 파일을 저장하겠다고 약속하기 전에 파일이 실제로 있는지 확인합니다.
