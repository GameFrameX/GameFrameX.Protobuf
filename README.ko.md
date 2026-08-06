<div align="center">

<img src="https://download.alianblank.com/gameframex/gameframex_logo_320.png" alt="Game Frame X Logo" width="160" />

# GameFrameX.Protobuf

[![Version](https://img.shields.io/github/v/release/GameFrameX/GameFrameX.Protobuf?label=version&color=green)](https://github.com/GameFrameX/GameFrameX.Protobuf/releases)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE.md)
[![Documentation](https://img.shields.io/badge/docs-gameframex-brightgreen.svg)](https://gameframex.doc.alianblank.com)

**인디 게임 개발자를 위한 올인원 솔루션 · 인디 개발자의 꿈을 실현**

<br />

[문서](https://gameframex.doc.alianblank.com) · [빠른 시작](#빠른-시작) · QQ 그룹: 467608841 / 233840761

<br />

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | **한국어**

</div>

## 프로젝트 개요

GameFrameX.Protobuf는 GameFrameX 프레임워크의 통일된 네트워크 프로토콜 정의 리포지토리입니다. Protocol Buffers 3(`proto3`)를 채택하여, 메시지와 에러 코드 정의를 비즈니스 모듈별로 정리합니다. 각 `.proto` 파일은 숫자 모듈 ID(파일명 접미사)로 식별되며, 클라이언트와 서버 간의 메시지 라우팅 및 에러 코드 생성에 사용됩니다.

전체 문서는 [GameFrameX 문서 사이트](https://gameframex.doc.alianblank.com/protobuf/require)에서 제공됩니다. 이 README는 리포지토리 구성과 내보내기 진입점에만 중점을 둡니다.

## 프로토콜 모듈

| Proto 파일 | 모듈 | 설명 |
|------------|------|------|
| `InnerBasic_2.proto` | 2 | 내부 기본 프로토콜 |
| `Basic_10.proto` | 10 | 기본 프로토콜 |
| `Common_20.proto` | 20 | 공용 프로토콜(에러 코드, 공유 타입) |
| `Bag_100.proto` | 100 | 가방(인벤토리) 프로토콜 |
| `Social_120.proto` | 120 | 소셜 프로토콜 |
| `Inner_Social_-120.proto` | -120 | 내부 소셜 프로토콜(서버 측) |
| `User_300.proto` | 300 | 사용자 / 계정 프로토콜 |
| `Attribute_310.proto` | 310 | 플레이어 속성 동기화 프로토콜 |
| `Room_400.proto` | 400 | 룸 프로토콜 |
| `RockPaperScissors_410.proto` | 410 | 가위바위보 미니게임 프로토콜 |
| `Mail_500.proto` | 500 | 메일 시스템 프로토콜 |

## 프로토콜 규칙

protobuf가 처음이신가요? 이 절은 단계별 튜토리얼입니다. 위에서부터 아래로 읽어나가면, `.proto` 파일을 한 번도 작성해 본 적이 없어도 새 프로토콜 모듈을 추가할 수 있게 됩니다. 각 단계에는 알기 쉬운 설명, 최소 예시, 그리고 그 배경의 규칙이 담겨 있습니다.

### 시작하기 전에 — 세 가지 쉬운 개념

- **Protobuf(`.proto`)** 는 양측이 합의한 '주문서 양식'입니다——인쇄된 주문서처럼 각 칸의 이름과 위치가 정해져 있어, 클라이언트와 서버가 같은 양식에 맞춰 채우므로 오해가 생기지 않습니다.
- **모듈 ID** 는 '분류 번호'입니다. 택배 회사의 지역 번호를 상상해 보세요: 각 업무(가방, 메일, 룸……)마다 번호가 하나씩 할당되고, 메시지는 그 번호로 올바른 담당자에게 배달됩니다.
- **외부 프로토콜 vs 내부 프로토콜** —— 외부 프로토콜은 클라이언트가 볼 수 있고 호출할 수 있는 '메뉴'이고, 내부 프로토콜은 서버 사이에서만 오가는 '주방 암호'입니다. 이 둘은 절대 섞여서는 안 되며, 섞이면 클라이언트가 호출하면 안 되는 것을 호출할 수 있게 됩니다.

### 1단계 — 파일 만들기

각 비즈니스 도메인은 자신만의 파일에 들어 있고, 파일명은 `<Domain>_<ModuleID>.proto` 입니다. 파일명만 봐도 어느 도메인인지, 라우팅 번호가 몇인지 알 수 있습니다.

```protobuf
// 파일명: Bag_100.proto
syntax = "proto3";      // 항상 proto3 —— 현행 protobuf 문법
package Bag;            // 도메인명(PascalCase)
option module = 100;    // 라우팅 번호. 파일명의 _100 과 일치해야 함
```

한 줄씩 설명:

- `syntax = "proto3";` —— 현행 protobuf 문법을 선언합니다. 모든 파일이 이 줄로 시작합니다.
- `package Bag;` —— 이 파일의 도메인은 'Bag'. PascalCase는 첫 글자가 대문자임을 뜻합니다.
- `option module = 100;` —— 라우팅 번호 100을 할당합니다.**파일명의 `_100` 과 완전히 일치해야 합니다.**

규칙:

- 파일명: `<Domain>_<ModuleID>.proto`(예: `Mail_500.proto`).
- 양수 = 외부 프로토콜(클라이언트 ↔ 서버), 음수 = 내부 프로토콜(서버 ↔ 서버). 예: `Inner_Social_-120.proto`.
- 내부 파일은 `Inner` 로 시작. 예: `InnerBasic_2.proto`.

**이유** —— 모듈 ID를 파일명에 넣으면 파일명 자체가 라우팅 키가 됩니다: 도메인을 한눈에 알 수 있고, 두 파일이 몰래 같은 번호를 공유할 수도 없습니다. `Inner` 접두사는 내부 프로토콜에 표시를 붙여 내보낼 때 걸러지게 하고, 클라이언트에 유출되지 않게 합니다.

### 2단계 — 데이터 정의하기: 메시지와 필드

**메시지(message)** 는 '양식'입니다——관련 필드들의 묶음. **필드(field)** 는 양식 위의 한 칸으로, 이름·타입·번호를 가집니다.

```protobuf
message BagItem {
  int32 ItemId = 1; // 아이템 ID
  int64 Count = 2;  // 아이템 수량
}
```

한 줄씩 설명:

- `message BagItem { ... }` —— `BagItem` 이라는 양식을 정의합니다.
- `int32 ItemId = 1;` —— `ItemId` 라는 칸, 타입 `int32`(작은 정수), 번호 `1`.
- `int64 Count = 2;` —— `Count` 라는 칸, 타입 `int64`(큰 정수), 번호 `2`.
- 줄 끝의 `// ...` 는 주석으로, 이 필드가 무엇인지 설명합니다.

규칙:

- 필드명은 PascalCase. 번호는 1부터 연속적으로 올리고 건너뛰지 않는다.
- 필드를 삭제하면 `reserved` 로 그 번호를 묶어둔다——번호를 재사용하면 안 된다.
- 모든 필드에는 줄 끝 주석을 붙인다.

타입 고르기(쉬운 버전):

| 이 값은…… | 사용 | 예 |
|-----------|------|----|
| 플레이어 / 인스턴스 ID(커질 수 있음) | `int64` | `PlayerId` |
| 설정 / 아이템 ID(범위가 작음) | `int32` | `ItemId` |
| 수량(많이 쌓일 수 있음) | `int64` | `Count` |
| 타임스탬프 | `int64` | `CreateTime` |
| 레벨 / 아바타(작고 음수가 아님) | `uint32` | `Level` |
| 선택지가 정해진 상태 | 열거형(4단계 참고) | `RoomStatus` |
| 리스트 / 사전 | `repeated` / `map` | `repeated RoomPlayerInfo` |

**이유** —— 번호를 연속으로 유지하는 이유는, 필드 번호가 통신 시의 식별자이기 때문입니다: 빈 번호는 공간을 낭비하고, 출시된 번호를 재사용하면 이전 클라이언트의 데이터가 새 필드로 들어가 조용히 데이터 훼손을 일으킵니다. 타입은 '충분한 범위, 오버플로우 없음'을 따릅니다: 큰 ID는 `int64`, 작은 ID는 `int32` 로 전송량을 절약.

### 3단계 — 대화하게 만들기: 요청 / 응답 / 알림

이제 클라이언트와 서버가 어떻게 소통할지 정의합니다. 메시지 역할은 세 가지이고, 이름 접두사로 구분합니다:

| 접두사 | 누가 시작 | 쉬운 의미 |
|--------|----------|-----------|
| `Req<Name>` | 클라이언트 | '하나 물어볼게' |
| `Resp<Name>` | 서버가 답 | '이게 답이야'(이름은 요청과 동일) |
| `Notify<Name>` | 서버가 푸시 | '주의——변동 있음'(대응하는 요청 없음) |

```protobuf
message ReqMailList { ... }        // 클라이언트가 메일 목록을 요청
message RespMailList { ... }       // 서버가 목록을 반환——이름이 짝인 점에 주목
message NotifyMailChanged { ... }  // 서버가 능동적으로 메일 변화를 푸시
message MailInfo { ... }           // 재사용 가능한 데이터 블록, 위 셋 모두에서 쓰임
```

규칙:

- 모든 요청에는 같은 이름의 응답이 있어야 한다: `ReqMailList` ↔ `RespMailList`.
- `Notify` 는 서버 주도 푸시에만 쓴다.
- 공용 데이터는 `<Name>Info` 로 빼내어 한 번 정의하고 곳곳에서 재사용한다.

**이유** —— Req/Resp 페어를 필수로 하면 모든 질문에 답이 보장됩니다. 같은 이름 덕분에 사람과 코드 생성기 모두 누가 짝인지 한눈에 압니다. `<Name>Info` 는 같은 구조를 여러 메시지에서 반복 정의하는 일을 막아 줍니다.

### 4단계 — 열거형으로 상태 표현하기

**열거형(enum)** 은 객관식 문제입니다——주문 상태가 '결제 대기 / 결제 완료 / 배송됨'만 될 수 있는 것과 같습니다.

```protobuf
enum RoomStatus {
  None = 0;     // 상태 없음 / 무효
  Waiting = 1;  // 시작 대기
  Playing = 3;  // 게임 진행 중
}
```

규칙:

- 열거형명과 값은 모두 PascalCase.
- 첫 번째 값은 항상 `0`, 기본 / 없음 상태(`None`, `Unknown`)에 쓴다.

**이유** —— proto3 는 첫 값을 `0` 으로 강제합니다. 이를 `None` / `Unknown` 으로 정하면 안전한 기본값이 됩니다: 설정하지 않은 필드는 '상태 없음'으로 읽히고, 실제 상태에 잘못 들어맞지 않아 버그의 부류 전체를 막아 줍니다.

### 5단계 — 에러 코드 정의하기

실패하면 번호를 붙여, 양측이 정확히 무엇이 잘못되었는지 알 수 있게 합니다. 에러 코드는 두 계층입니다:

**공용 코드** —— 어느 모듈에서나 일어나는 흔한 실패(잘못된 파라미터, 비용 부족, 부재). 이들은 `Common_20.proto` 의 `OperationStatusCode` 에 있으며, `0` 부터 번호가 매겨집니다.

**비즈니스 코드** —— 그 모듈 특유의 실패. 번호는 공식으로 정해집니다: **`모듈 ID × 1000 + 세 자리 일련번호`**.

```protobuf
// 메일은 모듈 500 이므로, 에러 코드는 500001 부터 시작
// 500001 = 500 × 1000 + 1
enum MailErrorCode {
  MailNotFound = 500001;        // 메일이 존재하지 않음
  MailAlreadyDeleted = 500002;  // 메일이 이미 삭제됨
}
```

규칙: 클라이언트는 에러 코드를 일반 `int` 로 받습니다. 성공 시에는 설정하지 않고, proto3 의 기본값 `0` 이 '성공'을 의미하게 하여, 대부분의 경우 아무것도 보내지 않아도 됩니다.

**이유** —— 이 공식 덕에 번호는 스스로 소속을 드러냅니다: `500001` 은 한눈에 메일 모듈임이 드러나고, 조정 없이 전역 고유하며, 모듈마다 1000개의 확장 슬롯도 확보됩니다. 성공을 '아무것도 보내지 않음'으로 처리하는 것은 성공이 대부분이라 절약되는 전송량이 크기 때문입니다.

### 6단계 — 주석 달기

주석은 양측이 공유하는 유일한 문서입니다——`.proto` 파일에는 주변 컨텍스트가 없어서, 주석이 없으면 다른 쪽은 추측할 수밖에 없습니다.

- 메시지 앞: 그 용도를 적는다.
- 필드나 열거값 뒤: 무엇을 뜻하는지 적는다.
- 만약 `int` 필드가 실제로는 열거값을 담고 있다면, 괄호로 열거형명을 표시한다(예: `// 상태(RoomStatus)`). 독자가 유효한 값을 어디서 찾아야 할지 알게 한다.

**이유** —— `int` 만으로는 유효한 값의 집합을 알 수 없습니다. 열거형명을 표시하면 독자가 바로 답을 찾을 수 있습니다.

### 전체 예시

가상의 `Quest_600`(퀘스트 시스템) 모듈을 예로, 위의 모든 규칙을 적용합니다:

```protobuf
syntax = "proto3";
package Quest;
option module = 600;

// Quest business error codes (6 digits = module 600 + 3-digit ordinal)
enum QuestErrorCode {
  QuestNotFound = 600001;             // quest not found
  QuestNotCompleted = 600002;         // quest not completed
  QuestRewardAlreadyClaimed = 600003; // reward already claimed
}

// Quest status
enum QuestStatus {
  None = 0;        // no state
  Accepted = 1;    // accepted
  Completable = 2; // ready to complete
  Completed = 3;   // completed
  Claimed = 4;     // reward claimed
}

// Quest data view
message QuestInfo {
  int64 QuestId = 1;            // quest config ID
  QuestStatus Status = 2;       // quest status (QuestStatus)
  int64 Progress = 3;           // current progress
  int64 TargetProgress = 4;     // target progress
}

// Request quest list
message ReqQuestList {
}

// Response quest list
message RespQuestList {
  repeated QuestInfo Quests = 1; // quest list
}

// Request claim quest reward
message ReqClaimQuestReward {
  int64 QuestId = 1; // quest config ID
}

// Response claim quest reward
message RespClaimQuestReward {
  int64 QuestId = 1;       // quest config ID
  QuestStatus Status = 2;  // status after claim (QuestStatus)
}

// Quest change notification (server push)
message NotifyQuestChanged {
  repeated QuestInfo Quests = 1; // changed quests
}
```

### 보완 대상 목록

이전에 나열된 모든 이탈 항목은 이번 점검에서 해결되었습니다——남은 항목이 없습니다:

- ✅ 파일 명명: `_120_Social.proto` → `Social_120.proto`, `_-120_InnerSocial_s.proto` → `Inner_Social_-120.proto`, `Inner_Basic` 패키지 → `InnerBasic`.
- ✅ `RespItemChange` 를 `RespSellItem` 로 변경해 `ReqSellItem` 과 페어화.
- ✅ `Common_20.proto`: 샘플 잔재(`Person` / `AddressBook` / `PhoneNumber`) 제거.
- ✅ 필드 주석과 중괄호·들여쓰기 스타일 정리.

위 규칙은 코드베이스에 완전히 반영되었습니다.

## 지원하는 내보내기 언어

Proto 정의는 `Tools/ProtoExport` 도구(.NET 10)를 통해 여러 대상 언어로 코드 생성됩니다.

| 언어 | 스크립트 |
|------|----------|
| C# (Client) | `Proto2CsExport_Client.sh` / `.bat` |
| C# (Server) | `Proto2CsExport_Server.sh` / `.bat` |
| C# (All) | `Proto2CsExport_All.bat` |
| C++ | `Proto2CppExport.sh` / `.bat` |
| Go | `Proto2GoExport.sh` / `.bat` |
| Lua | `Proto2LuaExport.sh` / `.bat` |
| TypeScript | `Proto2TsExport.sh` / `.bat` |
| TypeScript (LayaBox) | `Proto2TsExport_LayaBox.sh` |

## 의존성

이 리포지토리는 [GameFrameX.Tools](https://github.com/GameFrameX/GameFrameX.Tools)에 의존합니다. GameFrameX.Tools는 모든 내보내기 스크립트가 사용하는 `ProtoExport` 코드 생성기를 제공합니다. 내보내기를 실행하기 전에 해당 리포지토리에서 `Tools/ProtoExport` 프로젝트를 빌드하세요.

## 빠른 시작

1. `Tools/ProtoExport` 프로젝트가 빌드되어 있는지 확인하세요(.NET 10 SDK 필요).
2. 리포지토리 루트에서 대상 언어의 내보내기 스크립트를 실행합니다. 예: C#(서버) 또는 Go:

```bash
./Proto2CsExport_Server.sh
```

```bash
./Proto2GoExport.sh
```

각 스크립트는 `Tools/ProtoExport` 출력 디렉터리로 이동한 뒤, 언어별 옵션(`--mode`, `--isServer`, `--isGenerateDescription`, `--isGenerateErrorCode` 등)을 지정해 `dotnet ProtoExport.dll`을 호출합니다. 자세한 내용은 [내보내기 문서](https://gameframex.doc.alianblank.com/protobuf/require)를 참조하세요.

## 문서

- [프로토콜 사양](https://gameframex.doc.alianblank.com/protobuf/require)
- [GameFrameX 문서](https://gameframex.doc.alianblank.com)
- [GitHub 리포지토리](https://github.com/GameFrameX/GameFrameX.Protobuf)
- [이슈 트래커](https://github.com/GameFrameX/GameFrameX.Protobuf/issues)

## 라이선스

이 프로젝트는 [Apache 2.0 라이선스](LICENSE.md)로 제공됩니다.
