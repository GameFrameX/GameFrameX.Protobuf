<div align="center">

<img src="https://download.alianblank.com/gameframex/gameframex_logo_320.png" alt="Game Frame X Logo" width="160" />

# GameFrameX.Protobuf

[![Version](https://img.shields.io/github/v/release/GameFrameX/GameFrameX.Protobuf?label=version&color=green)](https://github.com/GameFrameX/GameFrameX.Protobuf/releases)
[![License](https://img.shields.io/badge/license-MIT+Apache%202.0-orange.svg)](LICENSE.md)
[![Documentation](https://img.shields.io/badge/docs-gameframex-brightgreen.svg)](https://gameframex.doc.alianblank.com)

**インディゲーム開発者向けオールインワンソリューション · インディ開発者の夢を支援**

<br />

[ドキュメント](https://gameframex.doc.alianblank.com) · [クイックスタート](#クイックスタート) · QQグループ: 467608841 / 233840761

<br />

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | **日本語** | [한국어](README.ko.md)

</div>

## プロジェクト概要

GameFrameX.Protobuf は、GameFrameX フレームワークの統一ネットワークプロトコル定義リポジトリです。Protocol Buffers 3（`proto3`）を採用し、メッセージとエラーコードの定義をビジネスモジュールごとに整理します。各 `.proto` ファイルは数値のモジュール ID（ファイル名の接尾辞）で識別され、クライアントとサーバー間のメッセージルーティングおよびエラーコード生成に使用されます。

完全なドキュメントは [GameFrameX ドキュメントサイト](https://gameframex.doc.alianblank.com/protobuf/require) で公開されています。本 README はリポジトリの構成とエクスポートのエントリポイントに焦点を当てます。

## プロトコルモジュール

| Proto ファイル | モジュール | 説明 |
|----------------|------------|------|
| `InnerBasic_2.proto` | 2 | 内部基礎プロトコル |
| `Basic_10.proto` | 10 | 基礎プロトコル |
| `Common_20.proto` | 20 | 共通プロトコル（エラーコード、共有型） |
| `Bag_100.proto` | 100 | バッグ（インベントリ）プロトコル |
| `Social_120.proto` | 120 | ソーシャルプロトコル |
| `Inner_Social_-120.proto` | -120 | 内部ソーシャルプロトコル（サーバー側） |
| `User_300.proto` | 300 | ユーザー / アカウントプロトコル |
| `Attribute_310.proto` | 310 | プレイヤー属性同期プロトコル |
| `Room_400.proto` | 400 | ルームプロトコル |
| `RockPaperScissors_410.proto` | 410 | じゃんけんミニゲームプロトコル |
| `Mail_500.proto` | 500 | メールシステムプロトコル |

## プロトコル規約

protobuf 初心者ですか？この節はステップ・バイ・ステップのチュートリアルです。上から順に読めば、`.proto` ファイルを書いたことがなくても、新しいプロトコルモジュールを追加できるようになります。各ステップには平易な説明、最小のサンプル、そしてその背後にあるルールが揃っています。

### はじめる前に —— 3 つの平易な概念

- **Protobuf（`.proto`）** は、双方が合意した「申込書のテンプレート」です——印刷された注文書のように、各欄の名前と位置が決まっており、クライアントとサーバーがその枠に沿って記入するため、誤解が起きません。
- **モジュール ID** は「仕分け番号」です。宅配業者のエリア番号を想像してください：バッグ、メール、ルーム……といった各業務に番号が割り当てられ、メッセージはその番号で正しい担当に振り分けられます。
- **外部プロトコル vs 内部プロトコル** —— 外部プロトコルはクライアントが見て呼べる「メニュー」、内部プロトコルはサーバー間だけでやり取りされる「厨房の合図」です。この 2 つは絶対に混ざってはいけません。混ざると、クライアントが呼んではいけないものを呼べてしまいます。

### ステップ 1 —— ファイルを作る

各業務ドメインは独自のファイルに置かれ、ファイル名は `<Domain>_<ModuleID>.proto` です。ファイル名だけで、どのドメインか、ルーティング番号がいくつか分かります。

```protobuf
// ファイル：Bag_100.proto
syntax = "proto3";      // 常に proto3 —— 現行の protobuf 構文
package Bag;            // ドメイン名（PascalCase）
option module = 100;    // ルーティング番号。ファイル名の _100 と一致必須
```

行ごとの解説:

- `syntax = "proto3";` —— 現行の protobuf 構文を宣言します。すべてのファイルはこの行で始まります。
- `package Bag;` —— このファイルのドメインは「Bag」。PascalCase は先頭が大文字であることを意味します。
- `option module = 100;` —— ルーティング番号 100 を割り当てます。**ファイル名の `_100` と完全に一致必須です。**

ルール:

- ファイル名：`<Domain>_<ModuleID>.proto`（例: `Mail_500.proto`）。
- 正の数 = 外部プロトコル（クライアント ↔ サーバー）、負の数 = 内部プロトコル（サーバー ↔ サーバー）。例: `Inner_Social_-120.proto`。
- 内部ファイルは `Inner` で始まる。例: `InnerBasic_2.proto`。

**なぜ** —— モジュール ID をファイル名に書き込むと、ファイル名自体がルーティングキーになります：ドメインが一目で分かり、2 つのファイルが同じ番号を黙って共有することもありません。`Inner` プレフィックスは内部プロトコルの目印となり、エクスポート時に除外でき、クライアントに漏れません。

### ステップ 2 —— データを定義する：メッセージとフィールド

**メッセージ（message）** は「フォーム」です——関連するフィールドの集まり。**フィールド（field）** はフォーム上の 1 つの枠で、名前・型・番号を持ちます。

```protobuf
message BagItem {
  int32 ItemId = 1; // アイテム ID
  int64 Count = 2;  // アイテム数量
}
```

行ごとの解説:

- `message BagItem { ... }` —— `BagItem` というフォームを定義します。
- `int32 ItemId = 1;` —— `ItemId` という枠、型 `int32`（小さい整数）、番号 `1`。
- `int64 Count = 2;` —— `Count` という枠、型 `int64`（大きい整数）、番号 `2`。
- 行末の `// ...` はコメントで、このフィールドの意味を説明します。

ルール:

- フィールド名は PascalCase。番号は 1 から連続して増やし、飛ばさない。
- フィールドを削除したら、`reserved` でその番号を抑える——番号を再利用してはいけない。
- すべてのフィールドに行末コメントを書く。

型の選び方（平易版）:

| この値は…… | 使う型 | 例 |
|------------|--------|----|
| プレイヤー / インスタンス ID（大きくなりうる） | `int64` | `PlayerId` |
| 設定 / アイテム ID（範囲が小さい） | `int32` | `ItemId` |
| 数量（積み上がりうる） | `int64` | `Count` |
| タイムスタンプ | `int64` | `CreateTime` |
| レベル / アバター（小さい、負にならない） | `uint32` | `Level` |
| 選択肢が決まっているステータス | 列挙型（ステップ 4） | `RoomStatus` |
| リスト / 辞書 | `repeated` / `map` | `repeated RoomPlayerInfo` |

**なぜ** —— 番号を連続させるのは、フィールド番号が通信時の識別子だからです：飛び番はスペースを無駄にし、リリース済みの番号を再利用すると旧クライアントのデータが新フィールドに入り込み、黙ってデータ破損を引き起こします。型は「十分な範囲、オーバーフローなし」に従います：大きい ID は `int64`、小さい ID は `int32` で転送量を節約。

### ステップ 3 —— 会話させる：リクエスト / レスポンス / 通知

次に、クライアントとサーバーがどうやり取りするかを定義します。メッセージの役割は 3 種類で、名前のプレフィックスで区別します:

| プレフィックス | 誰が始める | 平易な意味 |
|----------------|------------|------------|
| `Req<Name>` | クライアント | 「ちょっと聞きたいこと」 |
| `Resp<Name>` | サーバーが返答 | 「これが答え」（名前はリクエストと同じ） |
| `Notify<Name>` | サーバーがプッシュ | 「注意——変化があった」（対応するリクエストなし） |

```protobuf
message ReqMailList { ... }        // クライアントがメール一覧を要求
message RespMailList { ... }       // サーバーが一覧を返す——名前が対になっている点に注意
message NotifyMailChanged { ... }  // サーバーが能動的にメール更新をプッシュ
message MailInfo { ... }           // 再利用可能なデータブロック。上記のどこでも使われる
```

ルール:

- すべてのリクエストには同名のレスポンスを必ず用意する：`ReqMailList` ↔ `RespMailList`。
- `Notify` はサーバーからの能動的プッシュにのみ使う。
- 共通データは `<Name>Info` として切り出し、一度定義して使い回す。

**なぜ** —— Req/Resp のペアを必須にすると、すべての質問に答えが保証されます。同名により、人間にもコード生成器にもペアリングが一目で分かります。`<Name>Info` は、同じ構造を複数のメッセージで重複定義するのを防ぎます。

### ステップ 4 —— 列挙型でステータスを表す

**列挙型（enum）** は選択問題です——注文ステータスが「支払い待ち / 支払い済み / 発送済み」にしかならないのと同じです。

```protobuf
enum RoomStatus {
  None = 0;     // 状態なし / 無効
  Waiting = 1;  // 開始待ち
  Playing = 3;  // ゲーム進行中
}
```

ルール:

- 列挙型名と値は PascalCase。
- 最初の値は常に `0` で、デフォルト / 無状態（`None`、`Unknown`）に充てる。

**なぜ** —— proto3 は最初の値を `0` に強制します。それを `None` / `Unknown` にすれば安全なデフォルトになります：未設定のフィールドは「状態なし」と読まれ、うっかり本当の状態に一致することがなくなり、バグのクラス全体を防げます。

### ステップ 5 —— エラーコードを定義する

失敗したら番号を付け、双方が何が起きたか正確に分かるようにします。エラーコードは 2 階層です:

**汎用コード** —— どのモジュールでも起きるよくある失敗（パラメータ誤り、コスト不足、不存在）。これらは `Common_20.proto` の `OperationStatusCode` にあり、`0` から順に番号が付きます。

**業務コード** —— そのモジュール特有の失敗。番号は計算式で決まります：**`モジュール ID × 1000 + 3 桁の通番`**。

```protobuf
// メールはモジュール 500 なので、エラーコードは 500001 から始まる
// 500001 = 500 × 1000 + 1
enum MailErrorCode {
  MailNotFound = 500001;        // メールが存在しない
  MailAlreadyDeleted = 500002;  // メールは既に削除済み
}
```

ルール: クライアントはエラーコードを通常の `int` として受け取ります。成功時は未設定のままにし、proto3 のデフォルト `0` に「成功」を意味させることで、大半のケースでは何も送らなくて済みます。

**なぜ** —— この計算式により、番号は自ら所属を語ります：`500001` は一目でメールモジュールと分かり、調整なしでグローバルに一意で、モジュールごとに 1000 個の拡張枠も確保できます。成功を「何も送らない」とするのは、成功が大半を占めるため、節約できる転送量が大きいからです。

### ステップ 6 —— コメントを書く

コメントは双方が共有する唯一のドキュメントです——`.proto` ファイルには周囲のコンテキストがないため、コメントがないと他端は推測するしかありません。

- メッセージの前：その目的を書く。
- フィールドや列挙値の後：それが何を意味するか書く。
- もし `int` フィールドが実際には列挙値を保持しているなら、括弧で列挙型名を示す（例：`// 状態（RoomStatus）`）。読者がどこに有効な値があるか分かるようにします。

**なぜ** —— `int` だけでは有効な値の集合が分かりません。列挙型名を示せば、読者はすぐに答えを見つけられます。

### 完全な例

架空の `Quest_600`（クエストシステム）モジュールを例に、上記すべてのルールを適用します:

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

### 整理待ち一覧

以前に列挙された逸脱はすべて今回のパスで解決済みです——保留項目はありません:

- ✅ ファイル命名: `_120_Social.proto` → `Social_120.proto`、`_-120_InnerSocial_s.proto` → `Inner_Social_-120.proto`、`Inner_Basic` パッケージ → `InnerBasic`。
- ✅ `RespItemChange` は `RespSellItem` にリネームし、`ReqSellItem` とペア化。
- ✅ `Common_20.proto`: サンプル残留（`Person` / `AddressBook` / `PhoneNumber`）を削除。
- ✅ フィールドコメントと波括弧・インデントのスタイルを整理。

上記の規約はコードベースに完全に反映済みです。

## サポートするエクスポート言語

Proto 定義は `Tools/ProtoExport` ツール（.NET 10）により複数のターゲット言語にコード生成されます。

| 言語 | スクリプト |
|------|------------|
| C# (Client) | `Proto2CsExport_Client.sh` / `.bat` |
| C# (Server) | `Proto2CsExport_Server.sh` / `.bat` |
| C# (All) | `Proto2CsExport_All.bat` |
| C++ | `Proto2CppExport.sh` / `.bat` |
| Go | `Proto2GoExport.sh` / `.bat` |
| Lua | `Proto2LuaExport.sh` / `.bat` |
| TypeScript | `Proto2TsExport.sh` / `.bat` |
| TypeScript (LayaBox) | `Proto2TsExport_LayaBox.sh` |

## 依存関係

このリポジトリは [GameFrameX.Tools](https://github.com/GameFrameX/GameFrameX.Tools) に依存します。GameFrameX.Tools は、すべてのエクスポートスクリプトが使用する `ProtoExport` コードジェネレータを提供します。エクスポートを実行する前に、当該リポジトリから `Tools/ProtoExport` プロジェクトをビルドしてください。

## クイックスタート

1. `Tools/ProtoExport` プロジェクトがビルド済みであることを確認してください（.NET 10 SDK が必要）。
2. リポジトリルートから、ターゲット言語のエクスポートスクリプトを実行します。例：C#（サーバー）または Go：

```bash
./Proto2CsExport_Server.sh
```

```bash
./Proto2GoExport.sh
```

各スクリプトは `Tools/ProtoExport` の出力ディレクトリに移動し、言語固有のオプション（`--mode`、`--isServer`、`--isGenerateDescription`、`--isGenerateErrorCode` など）を指定して `dotnet ProtoExport.dll` を呼び出します。詳しくは[エクスポートドキュメント](https://gameframex.doc.alianblank.com/protobuf/require)を参照してください。

## ドキュメント

- [プロトコル仕様](https://gameframex.doc.alianblank.com/protobuf/require)
- [GameFrameX ドキュメント](https://gameframex.doc.alianblank.com)
- [GitHub リポジトリ](https://github.com/GameFrameX/GameFrameX.Protobuf)
- [Issue トラッカー](https://github.com/GameFrameX/GameFrameX.Protobuf/issues)

## ライセンス

このプロジェクトは [MIT License](LICENSE.md) + Apache 2.0 のデュアルライセンスです。
