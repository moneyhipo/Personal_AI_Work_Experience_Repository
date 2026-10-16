# AGENTS.md — Lobotomy Corporation BugFix_Vanilla

Codex 등 코딩 에이전트용 인수인계 문서입니다. 2026-10-16까지 Claude Code가 작업했습니다. 작업을 시작하기 전에 이 파일을 끝까지 읽으세요.

## 이 저장소가 하는 일
- Lobotomy Corporation(Unity, Mono, 게임 버전 1.0.2.13f1)의 **원본 게임 코드 버그**를 Harmony 패치로 고치는 BaseMod 모드입니다.
- 배포처:
  - Nexus: lobotomycorporation/mods/1448
  - GitHub: moneyhipo/Lobotomy-Corporation-Bug-fixes (태그 v1.0.0, v1.0.1, v1.0.2)
- 현재 버전: 1.0.2(`Mod/BugFix_Vanilla/Info/*/Info.xml`).
- 규모: 버그 수정 63건, 오류 로그 기능, 밸런스 스위치 26개(기본값 꺼짐, 게임 안에서 F8로 켜고 끔).

## 사용자와 일하는 규칙 (반드시 지킬 것)
1. **밸런스를 바꾸는 수정은 몰래 넣지 않습니다.**
   - 먼저 사용자에게 보여 줍니다. 승인되면 기본값이 꺼진 밸런스 스위치(`BalanceToggles.cs`)로 넣습니다.
   - 스위치 설명은 중립적으로 씁니다: "X를 Y로 바꿉니다. 바닐라는 Z입니다." 스위치를 "버그 수정"이라고 부르지 않습니다.
2. **설계 의도는 사용자가 판정합니다.** 버그인지 의도인지 애매하면(설정·로어 관련) 고치기 전에 묻습니다.
   - 위키는 참고만 하고, 판단 근거는 원본 코드입니다.
   - 위키만 보고 버그로 오해한 사례가 있습니다(어린 왕자 사망 스택, 별의 소리 즉사 등).
3. **git에는 모드 자체에 필요한 파일만 넣습니다.**
   - 넣는 것: 소스, Info, `Common.props`, README, LICENSE, 이 파일, `dev/`.
   - `dev/`: 작업 기록과 출시하지 않은 두 번째 모드입니다. 저장소가 비공개라서 함께 올렸습니다.
     - `CHANGELOG.md`, `HANDOFF.md`, `audit/`, `ModBugFix/`가 들어 있습니다.
     - 단, 디컴파일한 게임 코드(`dev/audit/decomp/`)는 올리지 않습니다.
   - 로컬에만 두고 커밋하지 않는 것(`.gitignore`): `package.ps1`, `nexus/`, `dist/`.
4. 커밋과 푸시는 사용자가 요청할 때만 합니다. Nexus 업로드는 사용자가 직접 합니다.
5. 사용자와는 한국어로 대화합니다. 모드 안에 들어가는 문구, 로그, Nexus 설명은 영어로 씁니다. README는 한국어로 씁니다.
6. 요청받은 버그와 관계없는 코드는 리팩터링하지 않습니다. 기존 수정 방식을 유지합니다.

## 과거 사고에서 나온 규칙
- **2026-10-14 세이브 손상 사고**
  - 무슨 일이 있었나: Harmony 1.0.9.1로 BaseMod의 `InventoryModel.CreateEquipment_Mod`를 패치했더니, 그 메서드가 다시 빌드되면서 안의 try/catch가 동작하지 않았습니다. 그 결과 `LoadGlobalData`가 중단됐고, 사용자의 장비 세이브가 날아갔습니다.
  - **정상 플레이 중에 try/catch에 의존하는 메서드(특히 로드·세이브 경로)는 패치하지 마세요.** 원본 본문을 아예 실행하지 않는 전체 대체 prefix를 쓰거나, 호출하는 쪽이나 호출되는 쪽에 거세요.
  - 수정한 뒤에는 로그의 `[TRY]` 줄을 확인합니다. 테스트는 세이브 사본으로 합니다.
- **Harmony 1.0.9.1의 제약**
  - `___field` 주입과 finalizer가 없습니다. private 필드는 `FieldRef<T>`나 리플렉션으로 접근합니다.
  - 다른 모드 DLL은 컴파일 타임에 참조하지 않습니다. BaseMod가 `Assembly.LoadFile`로 올리기 때문에 리플렉션으로만 다룹니다.
- **컴파일 대상:** 게임의 Mono 프로필(mscorlib 2.0, System.Core 3.5)로 컴파일합니다. .NET 4.x 참조 어셈블리를 쓰면 `System.Func`1` 로드 실패가 납니다. `Common.props`에 설정돼 있으니 바꾸지 마세요.

## 구조
- `Common/FixCore.cs`
  - `Patcher`: 수정을 하나씩 적용합니다. 하나가 실패해도 나머지는 계속 적용합니다.
  - `FieldRef<T>`, `ModTypes`, `FixLog`도 여기 있습니다.
- `Common/ConflictGuard.cs`: 다른 BaseMod가 같은 함수를 다시 쓰면 우리 수정을 빼고 로그에 `[CONFLICT]`를 남깁니다.
- `VanillaBugFix/`
  - `FixList.cs`: 모든 수정을 등록하는 곳입니다.
  - `Fixes_*.cs`: 수정 하나가 정적 클래스 하나입니다(`Apply(Patcher p)`와 훅 메서드).
  - `BalanceToggles.cs`, `BalanceUI.cs`: F8 창과 `BugFix_Vanilla_Balance.ini`.
  - `ErrorLogger.cs`: `BaseMods/BugFix_ErrorLogs/Error_*.txt`에 오류를 즉시 기록합니다.
- 수정을 추가하는 법: `Fixes_XXX.cs`에 정적 클래스를 쓰고 `FixList.cs`에 한 줄 등록합니다.

## 빌드와 설치
게임은 `D:\steam\steamapps\common\LobotomyCorp`에 있습니다.

`Common.props`의 `GameManaged` 기본값은 `..\LobotomyCorp_Data\Managed\`입니다. 이 저장소가 게임 폴더 밖에 있으면(예: `C:\git_desk`) 경로를 직접 줘야 합니다.

```
dotnet build VanillaBugFix -c Release -p:GameManaged=D:\steam\steamapps\common\LobotomyCorp\LobotomyCorp_Data\Managed\
```

- 설치: `VanillaBugFix\bin\Release\BugFix_Vanilla.dll`을 `D:\steam\steamapps\common\LobotomyCorp\LobotomyCorp_Data\BaseMods\BugFix_Vanilla\`에 복사합니다.
- 배포 zip: `.\package.ps1 -Version x.y.z -GameManaged <위 경로>`. 로컬 전용 파일이라 git에는 없습니다. 없으면 빌드한 DLL과 `Mod/BugFix_Vanilla/Info/`를 `BugFix_Vanilla/` 폴더에 넣어 zip으로 묶습니다(경로 구분자는 `/`).
- 변경 기록은 `dev/CHANGELOG.md`에 적습니다.
- 게임을 실행한 뒤 볼 로그는 `LobotomyCorp_Data\BaseMods\` 아래에 있습니다.
  - `BugFix_Vanilla_log.txt`: `[FAIL]`, `[WARN]`, `[CONFLICT]`, `[TRY]`를 확인합니다.
  - `BugFix_ErrorLogs\`
- 게임 실행 테스트는 자동화돼 있지 않습니다. 동작 확인은 사용자가 직접 게임에서 합니다.
- 원본 코드 참고용 디컴파일: `ilspycmd -p -o <out> -r <Managed> <Managed>\BaseMod\BackUp.dll`
  - `BackUp.dll`이 원본 바닐라입니다.
  - `Managed\Assembly-CSharp.dll`은 BaseMod가 적용된 버전입니다.

## 같은 게임 폴더에 있는 다른 모드
- **Mirror 멀티플레이 모드**: MelonLoader와 Harmony 2를 쓰고, 호스트가 모든 판정을 합니다.
  - 사용자가 따로 고치는 비공개 포크가 있습니다: moneyhipo/LTC-MULTI-Private.
  - 그 저장소의 할 일 중 하나가 이 모드와의 호환입니다. 이 모드가 원래 함수를 통째로 대신하는 prefix는 클라이언트에서도 실행되기 때문에, 호스트와 클라이언트 상태가 어긋날 수 있습니다.

## 현재 상태와 남은 일
1. **1.0.1 이후 수정은 게임에서 테스트했다는 기록이 없습니다.** 사용자가 게임을 실행하면 로그를 함께 확인합니다.
   - B3과 B5 트랜스파일러가 적용됐는지, F8 창이 동작하는지도 봅니다.
2. 감사(전체 코드 검토)에서 아직 안 한 범위:
   - E.G.O. 장비 스크립트 전체
   - 환상체 A–L 재점검
   - 자세한 내용은 `dev/audit/PROGRESS.md`, `dev/audit/VERIFIED.md`에 있습니다.
3. 세이브 복구 방법은 사용자 결정을 기다리고 있습니다.
   - 선택지: Steam 클라우드 확인 / 기억으로 재입력 / 일괄 지급
   - 백업 위치: `%USERPROFILE%\AppData\LocalLow\Project_Moon\Lobotomy\_backup_2026-10-14\`
4. `dev/ModBugFix/`(BugFix_Mods)는 설치된 다른 모드와 BaseMod의 버그를 고치는 두 번째 모드입니다. 출시하지 않았습니다. 내용은 `dev/HANDOFF.md`에 있습니다.
   - 빌드: `dotnet build dev/ModBugFix -c Release -p:GameManaged=<위 경로>`
   - 설치: `BaseMods\BugFix_Mods\`에 복사합니다.
5. 보류 중인 수정 후보(BigBadWolf 등 밸런스 관련) 목록은 `dev/HANDOFF.md`와 `dev/audit/BALANCE_HOLD.md`에 있습니다.

## 처음 받았을 때 할 일
코드를 고치기 전에 다음을 먼저 합니다.
1. README와 `FixList.cs`를 읽고 수정 목록을 파악합니다.
2. 빌드가 되는지 확인합니다.
3. 파악한 내용을 사용자에게 요약해서 보고합니다.
