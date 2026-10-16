# AGENTS.md — LTC-MULTI-Private (Mirror 멀티플레이 모드 포크)

Codex 등 코딩 에이전트용 인수인계 문서입니다. 할 일과 모드 구조는 `README.md`에 있으니 먼저 읽으세요. 이 파일은 README에 없는 규칙과 최신 정보만 담습니다.

## 상태
- **아직 코드 작업을 시작하지 않았습니다.** 저장소에는 다음만 있습니다.
  - 원본 Mirror v0.06ex1.1(Nexus #1182) zip과 DLL
  - 디컴파일한 소스
  - README의 할 일 4개
- 작업 순서는 README 순서(1 투표 → 2 독립 빌드 → 3 버그픽스 호환 → 4 원본 비교)를 따르되, 시작하기 전에 사용자에게 확인합니다.

## 규칙
1. **이 저장소는 비공개로 유지합니다.** 원작자의 코드가 들어 있습니다.
   - 공개 저장소, 이슈, gist 등 외부에 코드를 올리지 않습니다.
2. 게임 파일(`refs/`)은 커밋하지 않습니다(`.gitignore`에 등록돼 있음).
3. 커밋과 푸시는 사용자가 요청할 때만 합니다.
4. 사용자와는 한국어로 대화합니다.
5. Mirror는 호스트가 모든 판정을 내리는 구조입니다(`MatchmakingManager.IsHost`). 판정 로직을 바꿀 때는 호스트와 클라이언트 양쪽에서 어떻게 실행되는지 반드시 확인합니다.

## README 이후 바뀐 사실
- **할 일 3번(버그픽스 호환)의 겹치는 함수 목록 16개는 오래된 내용입니다.**
  - BugFix_Vanilla는 이제 1.0.2이고, 버그 수정 63건과 밸런스 스위치 26개가 있습니다.
  - 겹치는 함수를 다시 세야 합니다. 기준은 BugFix 저장소(moneyhipo/Lobotomy-Corporation-Bug-fixes)의 `VanillaBugFix/FixList.cs`와 `Fixes_*.cs`입니다.
  - 그 저장소의 `AGENTS.md`에 Harmony 1 제약과 세이브 사고 규칙이 있습니다.
- 게임 설치 위치: `D:\steam\steamapps\common\LobotomyCorp`
  - MelonLoader와 Mirror가 설치돼 있습니다(`Mods/`, `MelonLoader/`, `LobotomyCorp_Data/MirrorData`).
  - README "메인 PC에서 할 준비"의 `refs/` 파일은 여기서 복사합니다.
    - `LobotomyCorp_Data/Managed/*.dll`
    - `MelonLoader/net35/MelonLoader.dll`, `MelonLoader/net35/0Harmony.dll` (게임이 Mono라서 net35 쪽을 씁니다)
- 이 PC에는 `ilspycmd`와 .NET SDK가 설치돼 있습니다.

## 처음 받았을 때 할 일
코드를 고치기 전에 다음을 먼저 합니다.
1. 할 일 1번의 투표 서비스 6개를 읽고, 구조와 고칠 지점을 사용자에게 보고합니다.
2. 아직 빌드 프로젝트(csproj, 참조)가 정리돼 있지 않습니다. 디컴파일 소스를 다시 빌드할 수 있는지부터 확인합니다.
