<div align="center">

<img src="https://download.alianblank.com/gameframex/gameframex_logo_320.png" alt="Game Frame X Logo" width="160" />

# GameFrameX.Protobuf

[![Version](https://img.shields.io/github/v/release/GameFrameX/GameFrameX.Protobuf?label=version&color=green)](https://github.com/GameFrameX/GameFrameX.Protobuf/releases)
[![License](https://img.shields.io/badge/license-MIT+Apache%202.0-orange.svg)](LICENSE.md)
[![Documentation](https://img.shields.io/badge/docs-gameframex-brightgreen.svg)](https://gameframex.doc.alianblank.com)

**獨立遊戲前後端一體化解決方案 · 獨立遊戲開發者的圓夢大使**

<br />

[文檔](https://gameframex.doc.alianblank.com) · [快速開始](#快速開始) · QQ群: 467608841 / 233840761

<br />

[English](README.md) | [简体中文](README.zh-CN.md) | **繁體中文** | [日本語](README.ja.md) | [한국어](README.ko.md)

</div>

## 項目簡介

GameFrameX.Protobuf 是 GameFrameX 框架的統一網路協議定義倉庫。採用 Protocol Buffers 3（`proto3`），按業務模組組織訊息與錯誤碼定義。每個 `.proto` 檔案以數字模組 ID（檔名後綴）標識，用於客戶端與伺服器端的訊息路由和錯誤碼生成。

完整文件託管於 [GameFrameX 文檔站](https://gameframex.doc.alianblank.com/protobuf/require) —— 本 README 僅聚焦倉庫構成與匯出入口。

## 協議模組

| Proto 檔案 | 模組 | 說明 |
|------------|------|------|
| `InnerBasic_2.proto` | 2 | 內部基礎協議 |
| `Basic_10.proto` | 10 | 基礎協議 |
| `Common_20.proto` | 20 | 通用協議（錯誤碼、共享類型） |
| `Bag_100.proto` | 100 | 背包協議 |
| `Social_120.proto` | 120 | 社交協議 |
| `Inner_Social_-120.proto` | -120 | 內部社交協議（伺服器端） |
| `User_300.proto` | 300 | 使用者 / 帳號協議 |
| `Attribute_310.proto` | 310 | 玩家屬性同步協議 |
| `Room_400.proto` | 400 | 房間協議 |
| `RockPaperScissors_410.proto` | 410 | 猜拳小遊戲協議 |
| `Mail_500.proto` | 500 | 郵件系統協議 |

## 協議規範

第一次接觸 protobuf？本節是一個循序漸進的教學。從頭讀到尾，哪怕你從沒寫過 `.proto` 檔案，也能學會新增一個協議模組。每一步都包含大白話說明、最小範例，以及背後的規則。

### 動手之前 —— 三個大白話概念

- **Protobuf（`.proto`）** 是雙方約定好的「填表範本」——就像一張印好的訂單，每個格子都有固定的名稱和位置，客戶端和伺服器照著填，絕不會互相誤會。
- **模組 ID** 是一個「分揀號」。可以想像快遞公司的區域編號：每類業務（背包、郵件、房間……）各分一個號，訊息就按這個號被投遞到對應的處理人。
- **對外協議 vs 內部協議** —— 對外協議是客戶端能看見、能呼叫的「菜單」；內部協議是只在伺服器之間傳遞的「後廚暗號」。兩者絕不能混，否則客戶端可能呼叫到不該呼叫的東西。

### 第 1 步 —— 建立檔案

每個業務域放在自己的檔案裡，檔名叫 `<Domain>_<ModuleID>.proto`。檔名本身就能告訴你這是哪個業務域、路由號是多少。

```protobuf
// 檔名：Bag_100.proto
syntax = "proto3";      // 永遠用 proto3 —— 當前的 protobuf 語法
package Bag;            // 業務域名（PascalCase）
option module = 100;    // 路由號；必須和檔名裡的 _100 對上
```

逐行解讀：

- `syntax = "proto3";` —— 宣告使用當前的 protobuf 語法。每個檔案都以此開頭。
- `package Bag;` —— 這個檔案的業務域是「Bag」。PascalCase 指首字母大寫。
- `option module = 100;` —— 分配路由號 100。**它必須和檔名裡的 `_100` 完全一致。**

規則：

- 檔名：`<Domain>_<ModuleID>.proto`，如 `Mail_500.proto`。
- 正數 = 對外協議（客戶端 ↔ 伺服器）；負數 = 內部協議（伺服器 ↔ 伺服器），如 `Inner_Social_-120.proto`。
- 內部檔案以 `Inner` 開頭，如 `InnerBasic_2.proto`。

**為什麼** —— 把模組 ID 寫進檔名，檔名本身就是路由鍵：一眼能看出屬於哪個業務域，兩個檔案也絕不可能悄悄佔用同一個號。`Inner` 前綴給內部協議打了標記，方便匯出時過濾掉，不會洩露給客戶端。

### 第 2 步 —— 定義資料：訊息與欄位

**訊息（message）** 是一張「表」——一組相關欄位的集合。**欄位（field）** 是表裡的一個格子，有名稱、有型別、有編號。

```protobuf
message BagItem {
  int32 ItemId = 1; // 道具 ID
  int64 Count = 2;  // 道具數量
}
```

逐行解讀：

- `message BagItem { ... }` —— 定義了一張名叫 `BagItem` 的表。
- `int32 ItemId = 1;` —— 一個名叫 `ItemId` 的格子，型別 `int32`（小整數），編號 `1`。
- `int64 Count = 2;` —— 一個名叫 `Count` 的格子，型別 `int64`（大整數），編號 `2`。
- 行尾的 `// ...` 是註釋，用來說明這個欄位是什麼意思。

規則：

- 欄位名用 PascalCase；編號從 1 開始連續往上加，不要跳號。
- 如果刪除了某個欄位，要用 `reserved` 把它的編號佔住——絕不能重複使用編號。
- 每個欄位都要寫行尾註釋。

型別怎麼選（大白話版）：

| 這個值是…… | 用 | 範例 |
|------------|-----|------|
| 玩家 / 實例 ID（可能很大） | `int64` | `PlayerId` |
| 設定 / 道具 ID（範圍小） | `int32` | `ItemId` |
| 數量（可能堆很高） | `int64` | `Count` |
| 時間戳記 | `int64` | `CreateTime` |
| 等級 / 頭像（小、不會為負） | `uint32` | `Level` |
| 有固定幾個選項的狀態 | 列舉（見第 4 步） | `RoomStatus` |
| 列表 / 字典 | `repeated` / `map` | `repeated RoomPlayerInfo` |

**為什麼** —— 編號必須連續，是因為欄位編號就是它在傳輸時的身份識別：跳號會浪費空間，而重複使用已發布的編號，會讓舊客戶端的資料被塞進新欄位，悄悄造成資料錯亂。型別遵循「夠用、不溢出」：大 ID 用 `int64`，小 ID 用 `int32` 省流量。

### 第 3 步 —— 讓它們對話：請求 / 回應 / 通知

現在定義客戶端和伺服器怎麼互動。一共有三種訊息角色，靠名稱前綴區分：

| 前綴 | 誰發起 | 大白話 |
|------|--------|--------|
| `Req<Name>` | 客戶端 | 「我問你個事」 |
| `Resp<Name>` | 伺服器回答 | 「這是答案」（名稱和請求一致） |
| `Notify<Name>` | 伺服器推送 | 「注意——有變化」（沒有對應的請求） |

```protobuf
message ReqMailList { ... }        // 客戶端要郵件列表
message RespMailList { ... }       // 伺服器返回列表——注意名稱是對上的
message NotifyMailChanged { ... }  // 伺服器主動推送郵件變化
message MailInfo { ... }           // 一個可重複使用的資料區塊，上面幾個都會用到
```

規則：

- 每個請求都要有一個同名的回應：`ReqMailList` ↔ `RespMailList`。
- `Notify` 只用於伺服器主動推送。
- 把共用資料抽成 `<Name>Info`，定義一次、到處重用。

**為什麼** —— 強制 Req/Resp 配對，保證每個問題都有答案；同名讓人和程式碼產生器都能一眼看出誰和誰是一對。`<Name>Info` 避免在多個訊息裡重複定義同樣的結構。

### 第 4 步 —— 用列舉表示狀態

**列舉（enum）** 是一道多選題——比如訂單狀態只能是「待付款 / 已付款 / 已出貨」，不能是別的。

```protobuf
enum RoomStatus {
  None = 0;     // 無狀態 / 無效
  Waiting = 1;  // 等待開始
  Playing = 3;  // 遊戲進行中
}
```

規則：

- 列舉名和列舉值都用 PascalCase。
- 第一個值永遠是 `0`，留給預設 / 無狀態（`None`、`Unknown`）。

**為什麼** —— proto3 強制第一個值必須是 `0`。把它定為 `None` / `Unknown` 作為安全預設值：沒賦值的欄位讀出來是「無狀態」，而不是誤命中某個真實狀態——這樣能避免一整類 bug。

### 第 5 步 —— 定義錯誤碼

出錯時給它一個編號，雙方就能準確知道到底哪裡錯了。錯誤碼分兩層：

**通用錯誤碼** —— 各模組都會遇到的常見失敗（參數錯誤、消耗不足、不存在）。它們放在 `Common_20.proto` 的 `OperationStatusCode` 裡，從 `0` 往上編號。

**業務錯誤碼** —— 你這個模組特有的失敗。編號按公式算：**`模組 ID × 1000 + 三位序號`**。

```protobuf
// 郵件是模組 500，所以它的錯誤碼從 500001 開始
// 500001 = 500 × 1000 + 1
enum MailErrorCode {
  MailNotFound = 500001;        // 郵件不存在
  MailAlreadyDeleted = 500002;  // 郵件已被刪除
}
```

規則：客戶端把錯誤碼當作普通 `int` 接收。成功時不賦值——proto3 的預設 `0` 就代表「成功」，所以大多數情況什麼都不用傳。

**為什麼** —— 這個公式讓編號自帶身份：`500001` 一看就是郵件模組的，全域唯一不用協調，每個模組還預留了 1000 個號位可以擴充。成功當「什麼都不傳」，是因為成功佔大多數，省下的流量很可觀。

### 第 6 步 —— 寫註釋

註釋是雙方共用的唯一文件——`.proto` 檔案沒有上下文，不寫註釋，另一端只能靠猜。

- 訊息前面：寫它的用途。
- 欄位或列舉值後面：寫它代表什麼。
- 如果一個 `int` 欄位實際裝的是列舉值，用括號標出列舉名，比如 `// 狀態（RoomStatus）`，讓讀者知道合法值去哪查。

**為什麼** —— 光一個 `int` 看不出它有哪些合法取值；標出列舉名，讀者就能直接找到答案。

### 完整範例

以虛構的 `Quest_600`（任務系統）模組為例，涵蓋上述所有規則：

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

### 待整改清單

此前列出的所有偏離項均已在本次規範化過程中解決——無遺留待辦：

- ✅ 檔名：`_120_Social.proto` → `Social_120.proto`、`_-120_InnerSocial_s.proto` → `Inner_Social_-120.proto`、`Inner_Basic` 包名 → `InnerBasic`。
- ✅ `RespItemChange` 已更名為 `RespSellItem`，與 `ReqSellItem` 配對。
- ✅ `Common_20.proto`：範例殘留（`Person` / `AddressBook` / `PhoneNumber`）已移除。
- ✅ 欄位註釋與大括號、縮排風格已整理。

上述約定現已完整落實到程式庫。

## 支援的匯出語言

Proto 定義透過 `Tools/ProtoExport` 工具（.NET 10）程式碼生成到多種目標語言。

| 語言 | 腳本 |
|------|------|
| C# (Client) | `Proto2CsExport_Client.sh` / `.bat` |
| C# (Server) | `Proto2CsExport_Server.sh` / `.bat` |
| C# (All) | `Proto2CsExport_All.bat` |
| C++ | `Proto2CppExport.sh` / `.bat` |
| Go | `Proto2GoExport.sh` / `.bat` |
| Lua | `Proto2LuaExport.sh` / `.bat` |
| TypeScript | `Proto2TsExport.sh` / `.bat` |
| TypeScript (LayaBox) | `Proto2TsExport_LayaBox.sh` |

## 依賴

本倉庫依賴 [GameFrameX.Tools](https://github.com/GameFrameX/GameFrameX.Tools)，它提供了所有匯出腳本使用的 `ProtoExport` 程式碼生成器。執行任何匯出前，請先從該倉庫建置 `Tools/ProtoExport` 專案。

## 快速開始

1. 確保已建置 `Tools/ProtoExport` 專案（需要 .NET 10 SDK）。
2. 在倉庫根目錄執行目標語言的匯出腳本，例如 C#（伺服器端）或 Go：

```bash
./Proto2CsExport_Server.sh
```

```bash
./Proto2GoExport.sh
```

每個腳本會切換到 `Tools/ProtoExport` 輸出目錄，並以語言相關參數（`--mode`、`--isServer`、`--isGenerateDescription`、`--isGenerateErrorCode` 等）調用 `dotnet ProtoExport.dll`。詳見[匯出文件](https://gameframex.doc.alianblank.com/protobuf/require)。

## 文檔

- [協議規範](https://gameframex.doc.alianblank.com/protobuf/require)
- [GameFrameX 文檔](https://gameframex.doc.alianblank.com)
- [GitHub 倉庫](https://github.com/GameFrameX/GameFrameX.Protobuf)
- [Issue 追蹤](https://github.com/GameFrameX/GameFrameX.Protobuf/issues)

## 開源協議

本專案採用 [MIT 協議](LICENSE.md) + Apache 2.0 雙協議授權。
