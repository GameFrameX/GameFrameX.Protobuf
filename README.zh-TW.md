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
| `Inner_Basic_2.proto` | 2 | 內部基礎協議 |
| `Basic_10.proto` | 10 | 基礎協議 |
| `Common_20.proto` | 20 | 通用協議（錯誤碼、共享類型） |
| `Bag_100.proto` | 100 | 背包協議 |
| `_120_Social.proto` | 120 | 社交協議 |
| `_-120_InnerSocial_s.proto` | -120 | 內部社交協議（伺服器端） |
| `User_300.proto` | 300 | 使用者 / 帳號協議 |
| `Attribute_310.proto` | 310 | 玩家屬性同步協議 |
| `Room_400.proto` | 400 | 房間協議 |
| `RockPaperScissors_410.proto` | 410 | 猜拳小遊戲協議 |
| `Mail_500.proto` | 500 | 郵件系統協議 |

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
