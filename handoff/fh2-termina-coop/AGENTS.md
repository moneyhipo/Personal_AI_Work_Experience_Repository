# AGENTS.md — Fear & Hunger 2: Termina ATB + Co-op 모드

코딩 에이전트(Claude Code, Codex 등)용 인수인계 문서다. **규칙·경로·명령만** 적는다. 지금 상태·할 일·사용자에게 물어볼 것은 FH2 저장소 `docs/진행상황.md` **맨 위**에 있고, 이 파일에는 상태를 복사하지 않는다(2026-11-10 정리: 0.41 시절 상태와 최신 상태가 섞여 있었음 - 정리 전 원본은 `기록/AGENTS_2026-11-10_정리전.md`).

## 이 저장소가 하는 일
- F&H2 Termina(RPG Maker MV 1.6.0, NW.js 0.29, Node 9.7.1)에 **ATB 게이지 전투**와 **협동 멀티플레이(2~4명, IP 직접 연결·Steam 친구 초대)**를 더하는 플러그인 모드.
- 작업 저장소(비공개): `moneyhipo/Fear-Hunger-2-Termina-multi-ATB_only_work`(로컬 폴더 이름은 옛 이름 `Fear-Hunger-2-Termina-multi-ATP`), 브랜치 **`wip/0.38.3-duel-800hp`**(`main`은 옛 체크포인트).
- 공개 저장소: `moneyhipo/FH2T-Co-op-and-ATB`(게임 폴더에 들어가는 파일만, 릴리스엔 모드 zip만). Steam 헬퍼 소스·릴리스: `moneyhipo/FHSteamHelper-source-review`(v0.5.0).
- 게임 원본 파일은 저장소에 없다.

## 읽는 순서
1. FH2 저장소 `CLAUDE.md`(세션을 저장소 바깥 `C:\git_desk` 등에서 열면 자동으로 안 읽히니 직접 연다).
2. 이 파일.
3. FH2 `docs/인수인계.md`(PC를 바꿀 때) → `docs/진행상황.md` 맨 위.
4. 필요할 때: `docs/변경기록.md`(버전별, 최신이 위), `docs/기획_정리.md`(확정 기획·결정), 저장소 `README.md`(개요·폴더·테스트 명령). README와 진행상황이 다르면 진행상황이 맞다.

## 사용자 규칙 (반드시 지킬 것)
1. 모드가 화면에 띄우는 문구는 **영어**(넥서스 배포용, 한글패치면 한국어 문구도 있음). **채팅 답변과 문서는 한국어**(영어 코드를 읽은 직후 답이 영어로 새는 일이 있었음).
2. **게임 원본 데이터(`www/data/*.json`, 원본 js)는 고치지 않는다.** 모든 변경은 플러그인 코드로.
3. 판단 근거는 게임 데이터. 위키(https://fearandhunger.wiki.gg/wiki/Fear_%26_Hunger_2:_Termina)는 참고.
4. 배포판은 "압축 풀고 덮어쓰기"로 설치돼야 한다(`www/js/main.js` 로더가 플러그인을 덧붙임, `plugins.js`는 배포판에 안 넣음 - 한글패치와 충돌).
5. **커밋·푸시:** 수정이 끝나고 필터 테스트를 통과하면 묻지 않고 지금 버전으로 zip → 드라이브 합본·게스트 zip → 게임 폴더 설치(게임이 꺼져 있을 때) → dist 포함 커밋·푸시(사용자 2026-11-03). 큰 작업은 덩어리마다 커밋·푸시. **새 버전 번호와 공개 배포(공개 저장소·GitHub 릴리스·넥서스)는 사용자에게 묻는다.**
6. 요청과 관계없는 코드는 리팩터링하지 않는다. 플러그인 6개는 서로의 훅 순서에 의존한다(`mod/plugins_entries.txt` 순서).
7. **"상대에게 보내서"가 나오면 바로 재검수(사용자 2026-11-09).** 안 보내던 정보를 이제 보내는 수정이면, 같은 기능의 양쪽 PC를 대조한다(한 PC만 아는 값, 시작할 때 복사하고 갱신 안 하는 값, 그 PC의 시계·이벤트에만 영향을 주는 값).
8. **서브 에이전트는 병렬로 동시에 돌릴 수 있는 작업에만**(사용자 2026-10-30, 토큰). 큰 기능도 메인 세션에서 쓰고, 끝나면 diff를 다시 읽어 검수한다(검수 때마다 진짜 버그가 나왔음).
9. 버그 제보·수정 요청을 받으면 바로 기록한다(FH2 `docs/진행상황.md` 또는 `docs/변경기록.md`).
10. 사용자가 게임 중일 때는 게임 폴더에 설치하지 않는다.

## PC별 경로
| | 노트북(2026-10-29~) | 메인 PC |
|---|---|---|
| 저장소 | `C:\git_desk\...` | `D:\git_desk\...` |
| 게임 | `C:\Program Files (x86)\Steam\steamapps\common\Fear & Hunger 2 Termina\` | `D:\steam\steamapps\common\Fear & Hunger 2 Termina\` |
| 테스트 게임 사본(영어 원본) | `FH2_GAME=C:/git_desk/FH2_dev_game` | `FH2_GAME=D:/git_desk/FH2_dev_game` |
| 메모리 | 16GB, i5-13420H, Node 26, .NET 10, python 3.12 | 16GB |

- 스팀 게임 폴더는 한글패치라, 그것으로 테스트하면 영어 문구 검사가 틀린다. 테스트는 사본으로.
- 디버그 로그: `<게임 폴더>\fhcoop_logs\window_<pid>.log`. 버그는 모든 플레이어 로그로 본다.
- (옛 노트북 `D:\github_desk`, 8GB: 기능 작성·필터 테스트만, 전체는 `--max-old-space-size=1536`.)

## 설치·빌드·테스트
- 개발 설치: 게임을 끄고 `node tools/install.js "<게임 폴더>"`(플러그인을 바꿀 때마다, 한글패치를 덮은 뒤에도).
- 배포 zip: `node tools/make_release.js <버전> --helper 0.5.0` → `dist/FH2_Coop_<버전>.zip`. **헬퍼는 0.5.0 고정**(다시 만들면 해시가 바뀌어 디펜더 오진). PNP 호환 `node tools/make_pnp_compat.js <버전>`. 드라이브 합본·친구용·게스트용은 `tools/local_build/`(`bundle2.py`, `make_guest.py`, `python -I`). 버전은 고칠 때마다 올리지 않는다(FH2 `docs/버전에 관한 내용.md`).
- 자동 테스트(게임 없이 실제 엔진·플러그인·데이터를 Node로): **기본 4인**(호스트 + 게스트 3, 2026-11-10), `FH2_PLAYERS=2`면 예전 방식. 인원이 뜻인 테스트는 각 도구의 `EXACT_PLAYERS` 표.
  - `node --expose-gc tools/test/run_tests.js [필터]` - 단위(`FH_TEST_NAMES=1`이면 실패에 테스트 이름). 강제 GC 없이는 메모리 부족.
  - `node --expose-gc tools/test/flows.js [필터]`, `node tools/test/e2e_flow.js` - 흐름(`FH_PROF=1`이면 프레임·메시지 측정, `FLOW_SOAK_SEEDS=..`로 소크 시드).
  - `node tools/test/e2e.js`, `e2e_sub.js` - 실제 TCP.
  - 흐름·e2e는 로그가 현재 폴더에 쌓이니 임시 폴더에서. 한 번에 하나씩, 출력은 파일로. 전체가 도는 동안 `mod/`·`tools/test/`를 고치지 않는다.
  - 평소에는 바꾼 기능의 필터만, 전체 묶음(`sh tools/local_build/run_suite.sh <폴더>`)은 버전을 올리기 전·게임 로직을 크게 바꿨을 때.
- 노트북 4인 전체 시간: run_tests 약 6분, flows 약 15분, e2e 3종 약 1분.
- Steam 헬퍼(C#): `tools/steam_helper`, `dotnet publish -c Release -o publish` 후 exe를 `mod/fh_steam_helper/`로.
- 한 PC에서 창 2개로 시험: 두 번째 창은 `tools/게스트창_실행.bat`.

## 처음 받았을 때 할 일
1. 위 읽는 순서대로 읽는다.
2. 바꿀 기능의 필터 테스트를 돌려 통과하는지 본다.
3. 파악한 것을 사용자에게 한국어로 짧게 보고한다.
