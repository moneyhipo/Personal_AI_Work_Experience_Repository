# handoff/ — 프로젝트 인수인계

Claude Code가 작업하던 프로젝트를 다른 AI(Codex 등)가 이어받을 때 읽는 문서입니다(2026-10-16 기준).

(구버전, 2026-10-16 방식, 보관용) 각 폴더의 `AGENTS.md`를 해당 프로젝트 저장소 루트에 복사하면, Codex가 작업을 시작할 때 자동으로 읽습니다. 지금은 프로젝트 저장소에 복사하지 않고, 각 저장소의 `CLAUDE.md`가 이 폴더의 `AGENTS.md`를 직접 가리킵니다(사용자 2026-10-31).

| 폴더 | 프로젝트 | 저장소 |
|---|---|---|
| [lobotomy-bugfix/](lobotomy-bugfix/AGENTS.md) | Lobotomy Corporation 바닐라 버그픽스 (BaseMod, Harmony 1) | moneyhipo/Lobotomy-Corporation-Bug-fixes |
| [fh2-termina-coop/](fh2-termina-coop/AGENTS.md) | Fear & Hunger 2: Termina ATB + 코옵 | moneyhipo/Fear-Hunger-2-Termina-multi-ATP |
| [ltc-multi-private/](ltc-multi-private/AGENTS.md) | Mirror 멀티플레이 모드 포크 | 비공개 |

## 받는 쪽 AI가 지킬 순서
1. 이 저장소의 `general/`과 `game/` 교훈을 먼저 읽습니다.
2. 프로젝트의 `AGENTS.md`와, 거기서 가리키는 문서를 읽습니다.
3. 첫 작업은 코드 수정이 아닌 분석입니다. 구조와 남은 일을 파악해서 사용자에게 보고합니다.
4. 이후에는 작은 수정 하나씩 진행합니다. 바꾼 기능의 필터 테스트를 돌리고(전체 묶음은 버전을 올리기 직전에만), 게임 실행 확인은 사용자에게 요청합니다.
