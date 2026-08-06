<div align="center">

<img src="https://download.alianblank.com/gameframex/gameframex_logo_320.png" alt="Game Frame X Logo" width="160" />

# GameFrameX.Protobuf

[![Version](https://img.shields.io/github/v/release/GameFrameX/GameFrameX.Protobuf?label=version&color=green)](https://github.com/GameFrameX/GameFrameX.Protobuf/releases)
[![License](https://img.shields.io/badge/license-MIT+Apache%202.0-orange.svg)](LICENSE.md)
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
| `Inner_Basic_2.proto` | 2 | 내부 기본 프로토콜 |
| `Basic_10.proto` | 10 | 기본 프로토콜 |
| `Common_20.proto` | 20 | 공용 프로토콜(에러 코드, 공유 타입) |
| `Bag_100.proto` | 100 | 가방(인벤토리) 프로토콜 |
| `_120_Social.proto` | 120 | 소셜 프로토콜 |
| `_-120_InnerSocial_s.proto` | -120 | 내부 소셜 프로토콜(서버 측) |
| `User_300.proto` | 300 | 사용자 / 계정 프로토콜 |
| `Attribute_310.proto` | 310 | 플레이어 속성 동기화 프로토콜 |
| `Room_400.proto` | 400 | 룸 프로토콜 |
| `RockPaperScissors_410.proto` | 410 | 가위바위보 미니게임 프로토콜 |
| `Mail_500.proto` | 500 | 메일 시스템 프로토콜 |

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

이 프로젝트는 [MIT 라이선스](LICENSE.md) + Apache 2.0 이중 라이선스로 제공됩니다.
