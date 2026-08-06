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
| `Inner_Basic_2.proto` | 2 | 内部基礎プロトコル |
| `Basic_10.proto` | 10 | 基礎プロトコル |
| `Common_20.proto` | 20 | 共通プロトコル（エラーコード、共有型） |
| `Bag_100.proto` | 100 | バッグ（インベントリ）プロトコル |
| `_120_Social.proto` | 120 | ソーシャルプロトコル |
| `_-120_InnerSocial_s.proto` | -120 | 内部ソーシャルプロトコル（サーバー側） |
| `User_300.proto` | 300 | ユーザー / アカウントプロトコル |
| `Attribute_310.proto` | 310 | プレイヤー属性同期プロトコル |
| `Room_400.proto` | 400 | ルームプロトコル |
| `RockPaperScissors_410.proto` | 410 | じゃんけんミニゲームプロトコル |
| `Mail_500.proto` | 500 | メールシステムプロトコル |

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
