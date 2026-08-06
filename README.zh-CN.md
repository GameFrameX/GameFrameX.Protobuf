<div align="center">

<img src="https://download.alianblank.com/gameframex/gameframex_logo_320.png" alt="Game Frame X Logo" width="160" />

# GameFrameX.Protobuf

[![Version](https://img.shields.io/github/v/release/GameFrameX/GameFrameX.Protobuf?label=version&color=green)](https://github.com/GameFrameX/GameFrameX.Protobuf/releases)
[![License](https://img.shields.io/badge/license-MIT+Apache%202.0-orange.svg)](LICENSE.md)
[![Documentation](https://img.shields.io/badge/docs-gameframex-brightgreen.svg)](https://gameframex.doc.alianblank.com)

**独立游戏前后端一体化解决方案 · 独立游戏开发者的圆梦大使**

<br />

[文档](https://gameframex.doc.alianblank.com) · [快速开始](#快速开始) · QQ群: 467608841 / 233840761

<br />

[English](README.md) | **简体中文** | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

</div>

## 项目简介

GameFrameX.Protobuf 是 GameFrameX 框架的统一网络协议定义仓库。采用 Protocol Buffers 3（`proto3`），按业务模块组织消息与错误码定义。每个 `.proto` 文件以数字模块 ID（文件名后缀）标识，用于客户端与服务端的消息路由和错误码生成。

完整文档托管在 [GameFrameX 文档站](https://gameframex.doc.alianblank.com/protobuf/require) —— 本 README 仅聚焦仓库构成与导出入口。

## 协议模块

| Proto 文件 | 模块 | 说明 |
|------------|------|------|
| `Inner_Basic_2.proto` | 2 | 内部基础协议 |
| `Basic_10.proto` | 10 | 基础协议 |
| `Common_20.proto` | 20 | 通用协议（错误码、共享类型） |
| `Bag_100.proto` | 100 | 背包协议 |
| `_120_Social.proto` | 120 | 社交协议 |
| `_-120_InnerSocial_s.proto` | -120 | 内部社交协议（服务端） |
| `User_300.proto` | 300 | 用户 / 账号协议 |
| `Attribute_310.proto` | 310 | 玩家属性同步协议 |
| `Room_400.proto` | 400 | 房间协议 |
| `RockPaperScissors_410.proto` | 410 | 石头剪刀布小游戏协议 |
| `Mail_500.proto` | 500 | 邮件系统协议 |

## 支持的导出语言

Proto 定义通过 `Tools/ProtoExport` 工具（.NET 10）代码生成到多种目标语言。

| 语言 | 脚本 |
|------|------|
| C# (Client) | `Proto2CsExport_Client.sh` / `.bat` |
| C# (Server) | `Proto2CsExport_Server.sh` / `.bat` |
| C# (All) | `Proto2CsExport_All.bat` |
| C++ | `Proto2CppExport.sh` / `.bat` |
| Go | `Proto2GoExport.sh` / `.bat` |
| Lua | `Proto2LuaExport.sh` / `.bat` |
| TypeScript | `Proto2TsExport.sh` / `.bat` |
| TypeScript (LayaBox) | `Proto2TsExport_LayaBox.sh` |

## 依赖

本仓库依赖 [GameFrameX.Tools](https://github.com/GameFrameX/GameFrameX.Tools)，它提供了所有导出脚本使用的 `ProtoExport` 代码生成器。运行任何导出前，请先从该仓库构建 `Tools/ProtoExport` 项目。

## 快速开始

1. 确保已构建 `Tools/ProtoExport` 项目（需要 .NET 10 SDK）。
2. 在仓库根目录运行目标语言的导出脚本，例如 C#（服务端）或 Go：

```bash
./Proto2CsExport_Server.sh
```

```bash
./Proto2GoExport.sh
```

每个脚本会切换到 `Tools/ProtoExport` 输出目录，并以语言相关参数（`--mode`、`--isServer`、`--isGenerateDescription`、`--isGenerateErrorCode` 等）调用 `dotnet ProtoExport.dll`。详见[导出文档](https://gameframex.doc.alianblank.com/protobuf/require)。

## 文档

- [协议规范](https://gameframex.doc.alianblank.com/protobuf/require)
- [GameFrameX 文档](https://gameframex.doc.alianblank.com)
- [GitHub 仓库](https://github.com/GameFrameX/GameFrameX.Protobuf)
- [Issue 跟踪](https://github.com/GameFrameX/GameFrameX.Protobuf/issues)

## 开源协议

本项目采用 [MIT 协议](LICENSE.md) + Apache 2.0 双协议授权。
