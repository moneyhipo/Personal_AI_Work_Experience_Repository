# Unity Mono 게임 + Harmony C# 모드

출처: Lobotomy Corporation 버그픽스 모드 (Assembly-CSharp, Harmony 1.0.9.1, BaseMod, .NET 3.5 프로필 Mono)

## .NET SDK가 게임의 mscorlib 대신 다른 참조 어셈블리를 끼워 넣는다 (가장 치명적)

**상황**: 빌드는 성공했는데 게임에서 모드 진입점까지 가지 못해 아무것도 적용되지 않았고, 눈에 띄는 오류도 없었습니다.

**원인**: SDK가 게임의 `Managed/mscorlib.dll` 대신 net472 참조 팩을 써서 DLL이 mscorlib 4.0을 참조했습니다. 게임 Mono(.NET 3.5 프로필)는 그 mscorlib에서 `System.Func`1` 등을 불러오지 못합니다.

**규칙**: 구형 Unity Mono 게임 모드는 게임의 `*_Data/Managed` 폴더 DLL만 참조해서 컴파일합니다.
```xml
<FrameworkPathOverride>$(GameManaged)</FrameworkPathOverride>
<NoStdLib>true</NoStdLib>
<DisableImplicitFrameworkReferences>true</DisableImplicitFrameworkReferences>
<AutomaticallyUseReferenceAssemblyPackages>false</AutomaticallyUseReferenceAssemblyPackages>
<LangVersion>7.3</LangVersion>
```
빌드 결과물이 어떤 mscorlib 버전을 참조하는지 반드시 확인합니다.

## 빌드 참조 DLL은 게임과 모드 로더를 설치해야 생긴다

**상황**: 새 PC에서 빌드하자 오류 65개(`CodeInstruction`을 찾을 수 없음)가 났습니다.

**원인**: `0Harmony.dll`은 순정 게임에 없고, 모드 로더(BaseMod)를 설치해야 `Managed`에 생깁니다. 모드 매니저를 실행만 해서는 설치되지 않습니다.

**규칙**: 빌드 전에 필요한 참조 DLL이 있는지 먼저 확인합니다. 로더 설치 여부는 `Assembly-CSharp.dll` 수정 시각으로도 판단할 수 있습니다. 참조 경로는 `-p:GameManaged=...`처럼 속성으로 바꿀 수 있게 둡니다.

## Harmony 1(Mono)로 패치하면 원본의 try/catch가 사라질 수 있다 (세이브 파손)

**상황**: 원본이 `catch(ArgumentNullException)`로 예외를 삼키는 메서드에 패치를 걸자 실행 중에 catch가 사라졌습니다. 그 결과 세이브 로딩이 중단되어 저장된 장비 일부가 날아갔습니다.

**규칙**
- 원본이 try/catch에 기대는 메서드에는 prefix/postfix를 걸지 않습니다. 메서드 전체를 대체(prefix가 false 반환)하거나 더 하위 메서드를 후킹합니다.
- try/catch가 있는 원본을 패치했다면 그 목록을 로그로 남겨 검토합니다.
- 세이브와 관련된 경로는 가장 먼저 의심합니다.

## Harmony 1.0.9.1에는 Unpatch가 없다

**규칙**: 충돌 시 우리 패치를 빼려면 PatchInfo를 직접 고쳐야 합니다. 충돌 검사는 모든 모드가 로드된 뒤(첫 프레임, 씬 로드 시점)에 합니다. Harmony 2를 쓰는 다른 로더(MelonLoader 등)의 모드는 이 검사에 보이지 않습니다.

## BaseMod는 `Harmony_Patch` 타입을 모두 인스턴스화한다

**규칙**: 진입점 클래스에 static 가드를 두어 중복 실행을 막습니다.

## 파괴된 객체에서 매 프레임 NullReference

**상황**: 하루가 끝날 때 자식 유닛에서 매 프레임 NRE가 나서 성능까지 떨어졌습니다. 정리 함수가 일부 참조만 null로 만들고 애니메이션 객체는 계속 돌렸습니다.

**규칙**: Update 계열 함수에 null 가드를 넣어 건너뛰는 최소 수정을 우선합니다.

## Unity UI 모딩 함정

- 로더가 제공하는 옵션 화면이 정적 xml만 받고 스크롤·설명이 없어서 항목이 5개 정도밖에 안 들어갔습니다. 옵션이 많으면 자체 IMGUI 창을 만듭니다.
- IMGUI 기본 폰트에는 한글이 없습니다. 한글과 영문을 모두 가진 시스템 폰트를 지정합니다.
- 창이 떠 있을 때 클릭이 게임으로 새지 않도록 투명한 전체 화면 uGUI 이미지로 막습니다.
- `OnGUI`에서 매 프레임 문자열을 새로 만들지 않도록 값을 캐시합니다.
- 옵션형 패치는 항상 설치해 두고 실행 시점에 스위치를 확인합니다. 그래야 게임 도중에도 켜고 끌 수 있습니다. 설정은 ini 등에 저장합니다.

## 디컴파일 도구

- `ilspycmd`는 설치된 .NET 런타임과 맞는 버전을 씁니다.
- 디컴파일 결과는 원인 확인용입니다. 공개 저장소에 올리지 않습니다.
