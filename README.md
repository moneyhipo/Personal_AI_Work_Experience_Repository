# AI Experience Repository

AI(Claude 등)와 함께 프로젝트를 하면서 겪은 실수와 교훈을 모아 둔 저장소입니다.
**AI가 새 프로젝트를 시작하기 전에 읽는 용도**로 씁니다.

## AI에게: 읽는 순서

1. `general/`의 문서는 **프로젝트 종류와 상관없이 항상** 읽습니다.
2. 프로젝트 종류에 맞는 카테고리 폴더를 읽습니다. 예: 게임 모드나 게임 개발이면 `game/`, 안드로이드 앱이면 `mobile/`.
3. 각 항목은 `상황 → 원인 → 규칙` 순서입니다. 작업할 때는 **규칙**을 따릅니다.
4. 작업 중 새 교훈이 생기면 이 저장소에 추가하자고 사용자에게 제안합니다.
5. 새 프로젝트를 시작하면 프로젝트 폴더에 `CLAUDE.md`를 만들고, "이 저장소의 README부터 읽고 일한다"와 "채팅 답변은 한국어"를 적어 둡니다. 예시: `Fear-Hunger-2-Termina-multi-ATP/CLAUDE.md`.

## 목차

### general/ (범용)
| 문서 | 내용 |
|---|---|
| [collaboration.md](general/collaboration.md) | 사용자와 소통하는 방식, 진행 상태 보고, 인수인계, 도구가 막혔을 때 |
| [verification.md](general/verification.md) | 추측하지 않기, 검증과 디버깅 방법 |
| [windows-environment.md](general/windows-environment.md) | Windows, PowerShell, 인코딩, 경로, git·gh |
| [release-and-packaging.md](general/release-and-packaging.md) | 릴리스, 버전, 패키징, 저작권 |
| [planning.md](general/planning.md) | 기획 자료 대조, 데이터 출처 확인, 기능 문서 구조, 문서 링크 |
| [incident-index.md](general/incident-index.md) | 세이브 손상·테스트 과신·잘못된 릴리스 등 큰 사고 색인(작업 전 빠르게 훑기) |

### mobile/ (모바일 앱)
| 문서 | 내용 |
|---|---|
| [android-play-release.md](mobile/android-play-release.md) | Google Play 출시 조건(비공개 테스트, 타깃 API), WebView 스팸 정책 |

### game/ (게임)
| 문서 | 내용 |
|---|---|
| [modding-common.md](game/modding-common.md) | 게임 모딩 공통: 버그 판정, 데이터 분석, 멀티플레이 개조 |
| [unity-mono-harmony.md](game/unity-mono-harmony.md) | Unity Mono 게임 + Harmony/BaseMod C# 모드 |
| [rpgmaker-mv-nwjs.md](game/rpgmaker-mv-nwjs.md) | RPG Maker MV/MZ (NW.js) JS 플러그인 모드 |

### handoff/ (프로젝트 인수인계)
| 문서 | 내용 |
|---|---|
| [handoff/README.md](handoff/README.md) | 진행 중인 프로젝트별 `AGENTS.md`. 다른 AI가 이어받을 때 읽기 |

## 출처 프로젝트

- Lobotomy Corporation 바닐라 버그픽스 (Unity Mono, C#, Harmony 1, BaseMod)
- Fear & Hunger 2: Termina ATB 전투 + 코옵 멀티 모드 (RPG Maker MV 1.6, NW.js, Node)
- 해외 쇼핑몰 번역 + 디지털 옷장 안드로이드 앱 기획 (Kotlin, FastAPI, Google Play 출시 목표)

## 새 교훈 추가 규칙

- 알맞은 카테고리 폴더에 넣습니다. 맞는 폴더가 없으면 새로 만들고 위 목차에 추가합니다(예: `web/`, `embedded/`).
- 형식: `### 제목` 아래에 **상황 / 원인 / 규칙**. 규칙은 다음에 그대로 따라 할 수 있게 구체적으로 씁니다("주의한다" 대신 확인할 파일·명령·테스트).
- 원인이 확정되지 않았으면 원인 줄에 `(추정)`을 붙입니다. 규칙이 게임(실제 환경)에서 확인된 것이 아니면 `(자동 테스트만)`처럼 확인 정도를 적어, 다음 AI가 추측을 사실로 받아들이지 않게 합니다.
- 한 프로젝트에서만 통하는 기술 문제는 그 기술 문서(`game/` 등)나 `handoff/`에, 여러 프로젝트에서 되풀이된 실수만 `general/`에 둡니다. 같은 내용을 여러 문서에 복사하지 말고 한 곳에 쓰고 링크합니다.
- 큰 사고(데이터 손상, 잘못된 공개 등)면 [incident-index.md](general/incident-index.md)에 한 줄 추가합니다.
- 공개 저장소이므로 개인 정보(이메일, 실명, 로컬 사용자 폴더명, 토큰, 로그인 코드)는 넣지 않습니다.

## 문서끼리 어긋날 때

- 지금 파일·실행 결과가 과거 기록보다 우선합니다. 기록과 현재 코드가 다르면 조용히 덮지 말고 날짜와 바뀐 이유를 남깁니다.
- 사용자가 직접 한 지시와 승인한 결정이 일반적인 AI 관행보다 우선합니다. 프로젝트 `CLAUDE.md`·`AGENTS.md`는 그 프로젝트에만 적용됩니다.
- 어느 쪽인지 정할 수 없으면 임의로 고르지 말고 사용자에게 묻습니다.
