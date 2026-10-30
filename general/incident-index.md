# 큰 사고 색인

작업 전에 빠르게 훑는 용도입니다. 자세한 내용과 규칙은 연결된 문서에 있습니다.

| 위험 | 있었던 일 | 볼 문서 |
|---|---|---|
| 세이브 손상 | Harmony 1 패치로 원본의 try/catch가 사라져 세이브 로딩이 중단, 장비 세이브가 날아감 | [unity-mono-harmony.md](../game/unity-mono-harmony.md), [modding-common.md](../game/modding-common.md) "세이브·설정을 건드리기 전에" |
| 원작 동작 오판 | 위키·체감만으로 버그라 단정하면 의도된 동작·밸런스를 바꿈 | [modding-common.md](../game/modding-common.md) |
| AI 도구 간 수정 충돌 | Claude 에이전트가 멈춘 사이 Codex가 같은 파일을 고쳐, 섞인 상태에서 테스트 실패와 새 버그 | [collaboration.md](collaboration.md) "다른 AI 도구가 같은 작업 트리를 고쳤으면" |
| 테스트 과신 | 빌드·자동 테스트 통과가 실제 게임·다른 PC에서의 동작을 보장하지 않음 | [verification.md](verification.md) |
| 잘못된 공개 버전 | 확인 없이 다른 버전으로 태그·릴리스를 올려 삭제·재릴리스 | [release-and-packaging.md](release-and-packaging.md) |
| 다른 패치가 설치를 덮음 | 한글패치가 `plugins.js`를 통째로 바꿔 모드 등록이 사라짐 | [release-and-packaging.md](release-and-packaging.md) |
| 기획 문서 충돌 | 기획 자료끼리 어긋나는데 AI가 임의로 골라 범위를 잘못 구현 | [planning.md](planning.md) |
| 환경 차이 | PATH·런타임·인코딩·경로가 달라 코드가 맞아도 실행 실패 | [windows-environment.md](windows-environment.md) |
