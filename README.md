<div align="center">

<img src="https://download.alianblank.com/gameframex/gameframex_logo_320.png" alt="Game Frame X Logo" width="160" />

# GameFrameX.Protobuf

[![Version](https://img.shields.io/github/v/release/GameFrameX/GameFrameX.Protobuf?label=version&color=green)](https://github.com/GameFrameX/GameFrameX.Protobuf/releases)
[![License](https://img.shields.io/badge/license-MIT+Apache%202.0-orange.svg)](LICENSE.md)
[![Documentation](https://img.shields.io/badge/docs-gameframex-brightgreen.svg)](https://gameframex.doc.alianblank.com)

**All-in-One Solution for Indie Game Development · Empowering Indie Developers' Dreams**

<br />

[Documentation](https://gameframex.doc.alianblank.com) · [Quick Start](#quick-start) · QQ Group: 467608841 / 233840761

<br />

**English** | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

</div>

## Project Overview

GameFrameX.Protobuf is the unified network protocol definition repository for the GameFrameX framework. It uses Protocol Buffers 3 (`proto3`) and organizes message and error-code definitions by business module. Each `.proto` file is identified by a numeric module ID (the suffix in the filename), which is used for routing and error-code generation across client and server.

Full documentation is hosted at the [GameFrameX documentation site](https://gameframex.doc.alianblank.com/protobuf/require) — this README focuses on the repository map and export entry points.

## Protocol Modules

| Proto File | Module | Description |
|------------|--------|-------------|
| `Inner_Basic_2.proto` | 2 | Internal basic protocol |
| `Basic_10.proto` | 10 | Basic protocol |
| `Common_20.proto` | 20 | Common protocol (error codes, shared types) |
| `Bag_100.proto` | 100 | Inventory / bag protocol |
| `_120_Social.proto` | 120 | Social protocol |
| `_-120_InnerSocial_s.proto` | -120 | Internal social protocol (server-side) |
| `User_300.proto` | 300 | User / account protocol |
| `Attribute_310.proto` | 310 | Player attribute sync protocol |
| `Room_400.proto` | 400 | Room protocol |
| `RockPaperScissors_410.proto` | 410 | Rock-paper-scissors mini-game protocol |
| `Mail_500.proto` | 500 | Mail system protocol |

## Supported Export Languages

Proto definitions are code-generated to multiple target languages via the `Tools/ProtoExport` tool (.NET 10).

| Language | Script |
|----------|--------|
| C# (Client) | `Proto2CsExport_Client.sh` / `.bat` |
| C# (Server) | `Proto2CsExport_Server.sh` / `.bat` |
| C# (All) | `Proto2CsExport_All.bat` |
| C++ | `Proto2CppExport.sh` / `.bat` |
| Go | `Proto2GoExport.sh` / `.bat` |
| Lua | `Proto2LuaExport.sh` / `.bat` |
| TypeScript | `Proto2TsExport.sh` / `.bat` |
| TypeScript (LayaBox) | `Proto2TsExport_LayaBox.sh` |

## Dependencies

This repository depends on [GameFrameX.Tools](https://github.com/GameFrameX/GameFrameX.Tools), which provides the `ProtoExport` code generator used by all export scripts. Build the `Tools/ProtoExport` project from that repository before running any export.

## Quick Start

1. Ensure the `Tools/ProtoExport` project is built (requires .NET 10 SDK).
2. From the repository root, run the export script for your target language — for example, C# (server) or Go:

```bash
./Proto2CsExport_Server.sh
```

```bash
./Proto2GoExport.sh
```

Each script switches into the `Tools/ProtoExport` output directory and invokes `dotnet ProtoExport.dll` with language-specific options (`--mode`, `--isServer`, `--isGenerateDescription`, `--isGenerateErrorCode`, etc.). See the [export documentation](https://gameframex.doc.alianblank.com/protobuf/require) for details.

## Documentation

- [Protocol Specification](https://gameframex.doc.alianblank.com/protobuf/require)
- [GameFrameX Documentation](https://gameframex.doc.alianblank.com)
- [GitHub Repository](https://github.com/GameFrameX/GameFrameX.Protobuf)
- [Issue Tracker](https://github.com/GameFrameX/GameFrameX.Protobuf/issues)

## License

This project is licensed under [MIT License](LICENSE.md) + Apache 2.0.
