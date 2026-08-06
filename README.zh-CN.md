<div align="center">

<img src="https://download.alianblank.com/gameframex/gameframex_logo_320.png" alt="Game Frame X Logo" width="160" />

# GameFrameX.Protobuf

[![Version](https://img.shields.io/github/v/release/GameFrameX/GameFrameX.Protobuf?label=version&color=green)](https://github.com/GameFrameX/GameFrameX.Protobuf/releases)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE.md)
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
| `InnerBasic_2.proto` | 2 | 内部基础协议 |
| `Basic_10.proto` | 10 | 基础协议 |
| `Common_20.proto` | 20 | 通用协议（错误码、共享类型） |
| `Bag_100.proto` | 100 | 背包协议 |
| `Social_120.proto` | 120 | 社交协议 |
| `Inner_Social_-120.proto` | -120 | 内部社交协议（服务端） |
| `User_300.proto` | 300 | 用户 / 账号协议 |
| `Attribute_310.proto` | 310 | 玩家属性同步协议 |
| `Room_400.proto` | 400 | 房间协议 |
| `RockPaperScissors_410.proto` | 410 | 石头剪刀布小游戏协议 |
| `Mail_500.proto` | 500 | 邮件系统协议 |

## 协议规范

第一次接触 protobuf？本节是一个循序渐进的教程。从头读到尾，哪怕你从没写过 `.proto` 文件，也能学会新增一个协议模块。每一步都包含大白话说明、最小示例，以及背后的规则。

### 动手之前 —— 三个大白话概念

- **Protobuf（`.proto`）** 是双方约定好的"填表模板"——就像一张印好的订单，每个格子都有固定的名字和位置，客户端和服务端照着填，绝不会互相误会。
- **模块 ID** 是一个"分拣号"。可以想象快递公司的区域编号：每类业务（背包、邮件、房间……）各分一个号，消息就按这个号被投递到对应的处理人。
- **对外协议 vs 内部协议** —— 对外协议是客户端能看见、能调用的"菜单"；内部协议是只在服务端之间传递的"后厨暗号"。两者绝不能混，否则客户端可能调到不该调的东西。

### 第 1 步 —— 创建文件

每个业务域放在自己的文件里，文件名叫 `<Domain>_<ModuleID>.proto`。文件名本身就能告诉你这是哪个业务域、路由号是多少。

```protobuf
// 文件名：Bag_100.proto
syntax = "proto3";      // 永远用 proto3 —— 当前的 protobuf 语法
package Bag;            // 业务域名（PascalCase）
option module = 100;    // 路由号；必须和文件名里的 _100 对上
```

逐行解读：

- `syntax = "proto3";` —— 声明使用当前的 protobuf 语法。每个文件都以此开头。
- `package Bag;` —— 这个文件的业务域是"Bag"。PascalCase 指首字母大写。
- `option module = 100;` —— 分配路由号 100。**它必须和文件名里的 `_100` 完全一致。**

规则：

- 文件名：`<Domain>_<ModuleID>.proto`，如 `Mail_500.proto`。
- 正数 = 对外协议（客户端 ↔ 服务端）；负数 = 内部协议（服务端 ↔ 服务端），如 `Inner_Social_-120.proto`。
- 内部文件以 `Inner` 开头，如 `InnerBasic_2.proto`。

**为什么** —— 把模块 ID 写进文件名，文件名本身就是路由键：一眼能看出属于哪个业务域，两个文件也绝不可能悄悄占用同一个号。`Inner` 前缀给内部协议打了标记，方便导出时过滤掉，不会泄露给客户端。

### 第 2 步 —— 定义数据：消息与字段

**消息（message）** 是一张"表"——一组相关字段的集合。**字段（field）** 是表里的一个格子，有名字、有类型、有编号。

```protobuf
message BagItem {
  int32 ItemId = 1; // 道具 ID
  int64 Count = 2;  // 道具数量
}
```

逐行解读：

- `message BagItem { ... }` —— 定义了一张名叫 `BagItem` 的表。
- `int32 ItemId = 1;` —— 一个名叫 `ItemId` 的格子，类型 `int32`（小整数），编号 `1`。
- `int64 Count = 2;` —— 一个名叫 `Count` 的格子，类型 `int64`（大整数），编号 `2`。
- 行尾的 `// ...` 是注释，用来说明这个字段是什么意思。

规则：

- 字段名用 PascalCase；编号从 1 开始连续往上加，不要跳号。
- 如果删除了某个字段，要用 `reserved` 把它的编号占住——绝不能复用编号。
- 每个字段都要写行尾注释。

类型怎么选（大白话版）：

| 这个值是…… | 用 | 示例 |
|------------|-----|------|
| 玩家 / 实例 ID（可能很大） | `int64` | `PlayerId` |
| 配置 / 道具 ID（范围小） | `int32` | `ItemId` |
| 数量（可能堆很高） | `int64` | `Count` |
| 时间戳 | `int64` | `CreateTime` |
| 等级 / 头像（小、不会为负） | `uint32` | `Level` |
| 有固定几个选项的状态 | 枚举（见第 4 步） | `RoomStatus` |
| 列表 / 字典 | `repeated` / `map` | `repeated RoomPlayerInfo` |

**为什么** —— 编号必须连续，是因为字段编号就是它在传输时的身份标识：跳号会浪费空间，而复用已发布的编号，会让旧客户端的数据被塞进新字段，悄悄造成数据错乱。类型遵循"够用、不溢出"：大 ID 用 `int64`，小 ID 用 `int32` 省流量。

### 第 3 步 —— 让它们对话：请求 / 响应 / 通知

现在定义客户端和服务端怎么交互。一共有三种消息角色，靠名字前缀区分：

| 前缀 | 谁发起 | 大白话 |
|------|--------|--------|
| `Req<Name>` | 客户端 | "我问你个事" |
| `Resp<Name>` | 服务端回答 | "这是答案"（名字和请求一致） |
| `Notify<Name>` | 服务端推送 | "注意——有变化"（没有对应的请求） |

```protobuf
message ReqMailList { ... }        // 客户端要邮件列表
message RespMailList { ... }       // 服务端返回列表——注意名字是对上的
message NotifyMailChanged { ... }  // 服务端主动推送邮件变化
message MailInfo { ... }           // 一个可复用的数据块，上面几个都会用到
```

规则：

- 每个请求都要有一个同名的响应：`ReqMailList` ↔ `RespMailList`。
- `Notify` 只用于服务端主动推送。
- 把共用数据抽成 `<Name>Info`，定义一次、到处复用。

**为什么** —— 强制 Req/Resp 配对，保证每个问题都有答案；同名让人和代码生成器都能一眼看出谁和谁是一对。`<Name>Info` 避免在多个消息里重复定义同样的结构。

### 第 4 步 —— 用枚举表示状态

**枚举（enum）** 是一道多选题——比如订单状态只能是"待付款 / 已付款 / 已发货"，不能是别的。

```protobuf
enum RoomStatus {
  None = 0;     // 无状态 / 无效
  Waiting = 1;  // 等待开始
  Playing = 3;  // 游戏进行中
}
```

规则：

- 枚举名和枚举值都用 PascalCase。
- 第一个值永远是 `0`，留给默认 / 无状态（`None`、`Unknown`）。

**为什么** —— proto3 强制第一个值必须是 `0`。把它定为 `None` / `Unknown` 作为安全默认值：没赋值的字段读出来是"无状态"，而不是误命中某个真实状态——这样能避免一整类 bug。

### 第 5 步 —— 定义错误码

出错时给它一个编号，双方就能准确知道到底哪里错了。错误码分两层：

**通用错误码** —— 各模块都会遇到的常见失败（参数错误、消耗不足、不存在）。它们放在 `Common_20.proto` 的 `OperationStatusCode` 里，从 `0` 往上编号。

**业务错误码** —— 你这个模块特有的失败。编号按公式算：**`模块 ID × 1000 + 三位序号`**。

```protobuf
// 邮件是模块 500，所以它的错误码从 500001 开始
// 500001 = 500 × 1000 + 1
enum MailErrorCode {
  MailNotFound = 500001;        // 邮件不存在
  MailAlreadyDeleted = 500002;  // 邮件已被删除
}
```

规则：客户端把错误码当作普通 `int` 接收。成功时不赋值——proto3 的默认 `0` 就代表"成功"，所以大多数情况什么都不用传。

**为什么** —— 这个公式让编号自带身份：`500001` 一看就是邮件模块的，全局唯一不用协调，每个模块还预留了 1000 个号位可以扩展。成功当"什么都不传"，是因为成功占大多数，省下的流量很可观。

### 第 6 步 —— 写注释

注释是双方共用的唯一文档——`.proto` 文件没有上下文，不写注释，另一端只能靠猜。

- 消息前面：写它的用途。
- 字段或枚举值后面：写它代表什么。
- 如果一个 `int` 字段实际装的是枚举值，用括号标出枚举名，比如 `// 状态（RoomStatus）`，让读者知道合法值去哪查。

**为什么** —— 光一个 `int` 看不出它有哪些合法取值；标出枚举名，读者就能直接找到答案。

### 完整示例

以虚构的 `Quest_600`（任务系统）模块为例，覆盖上述所有规则：

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

### 待整改清单

此前列出的所有偏离项均已在本次规范化过程中解决——无遗留待办：

- ✅ 文件命名：`_120_Social.proto` → `Social_120.proto`、`_-120_InnerSocial_s.proto` → `Inner_Social_-120.proto`、`Inner_Basic` 包名 → `InnerBasic`。
- ✅ `RespItemChange` 已改名为 `RespSellItem`，与 `ReqSellItem` 配对。
- ✅ `Common_20.proto`：示例残留（`Person` / `AddressBook` / `PhoneNumber`）已移除。
- ✅ 字段注释与大括号、缩进风格已整理。

上述约定现已完整落实到代码库。

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

本项目采用 [Apache 2.0 协议](LICENSE.md) 授权。
