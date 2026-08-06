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
| `InnerBasic_2.proto` | 2 | Internal basic protocol |
| `Basic_10.proto` | 10 | Basic protocol |
| `Common_20.proto` | 20 | Common protocol (error codes, shared types) |
| `Bag_100.proto` | 100 | Inventory / bag protocol |
| `Social_120.proto` | 120 | Social protocol |
| `Inner_Social_-120.proto` | -120 | Internal social protocol (server-side) |
| `User_300.proto` | 300 | User / account protocol |
| `Attribute_310.proto` | 310 | Player attribute sync protocol |
| `Room_400.proto` | 400 | Room protocol |
| `RockPaperScissors_410.proto` | 410 | Rock-paper-scissors mini-game protocol |
| `Mail_500.proto` | 500 | Mail system protocol |

## Protocol Conventions

New to protobuf? This section is a step-by-step tutorial. Read it top to bottom and you'll be able to add a new protocol module even if you've never written a `.proto` file. Each step comes with a plain-language explanation, a minimal example, and the rule behind it.

### Before You Start — Three Concepts in Plain Terms

- **Protobuf (`.proto`)** is a "form template" both sides agree on for exchanging data — like a printed order form where every field has a fixed name and box, so the client and server never misunderstand each other.
- **Module ID** is a "sorting number". Think of a courier's area codes: each business area (bag, mail, room…) gets one number, and every message is routed to the right handler by that number.
- **External vs Internal protocol** — External protocols are the "menu" the client can see and call; internal protocols are "back-kitchen signals" passed only between servers. The two must never mix, or the client could call something it shouldn't.

### Step 1 — Create the File

Every business area lives in its own file named `<Domain>_<ModuleID>.proto`. The filename itself tells you the domain and its routing number.

```protobuf
// File: Bag_100.proto
syntax = "proto3";      // always proto3 — the modern protobuf syntax
package Bag;            // the domain name (PascalCase)
option module = 100;    // the routing number; must match the _100 in the filename
```

Line by line:

- `syntax = "proto3";` — declares the modern protobuf syntax. Every file starts with this line.
- `package Bag;` — this file's domain is "Bag". PascalCase means the first letter is uppercase.
- `option module = 100;` — assigns routing number 100. **It must equal the `_100` in the filename.**

Rules:

- Filename: `<Domain>_<ModuleID>.proto`, e.g. `Mail_500.proto`.
- Positive number = external protocol (client ↔ server); negative = internal (server ↔ server), e.g. `Inner_Social_-120.proto`.
- Internal files start with `Inner`, e.g. `InnerBasic_2.proto`.

**Why** — Putting the module ID in the filename makes the filename itself the routing key: you can tell the domain at a glance, and two files can never quietly share one number. The `Inner` prefix tags internal protocols so they can be filtered out and never leak to the client.

### Step 2 — Define Your Data: Messages & Fields

A **message** is a "form" — a bundle of related fields. A **field** is one box on that form, with a name, a type, and a number.

```protobuf
message BagItem {
  int32 ItemId = 1; // item ID
  int64 Count = 2;  // item quantity
}
```

Line by line:

- `message BagItem { ... }` — defines a form named `BagItem`.
- `int32 ItemId = 1;` — a box named `ItemId`, type `int32` (a small integer), numbered `1`.
- `int64 Count = 2;` — a box named `Count`, type `int64` (a large integer), numbered `2`.
- The `// ...` at the end of a line is a comment that explains the field.

Rules:

- Field names are PascalCase; numbers start at 1 and go up without skipping.
- If you delete a field, block its number with `reserved` — never reuse a number.
- Every field needs a trailing comment.

How to pick a type (plain version):

| The value is… | Use | Example |
|---------------|-----|---------|
| A player / instance ID (can be huge) | `int64` | `PlayerId` |
| A config / item ID (small range) | `int32` | `ItemId` |
| A quantity (can stack up) | `int64` | `Count` |
| A timestamp | `int64` | `CreateTime` |
| Level / avatar (small, never negative) | `uint32` | `Level` |
| A status with fixed options | an enum (Step 4) | `RoomStatus` |
| A list / dictionary | `repeated` / `map` | `repeated RoomPlayerInfo` |

**Why** — Numbers must stay contiguous because a field number is its wire identifier: gaps waste space, and reusing a shipped number makes old clients' data land in the new field, silently corrupting it. Types follow "enough range, no overflow": big IDs use `int64`; small IDs use `int32` to save bytes.

### Step 3 — Make Them Talk: Request / Response / Notify

Now define how the client and server interact. There are three message roles, told apart by their name prefix:

| Prefix | Who starts it | Plain meaning |
|--------|---------------|---------------|
| `Req<Name>` | Client | "I'm asking you something" |
| `Resp<Name>` | Server replies | "Here's the answer" (same `<Name>` as the request) |
| `Notify<Name>` | Server pushes | "Heads up — something changed" (no prior request) |

```protobuf
message ReqMailList { ... }        // client asks for the mail list
message RespMailList { ... }       // server returns the list — note the matching name
message NotifyMailChanged { ... }  // server proactively pushes a mail update
message MailInfo { ... }           // a reusable data block used inside the above
```

Rules:

- Every request needs a same-named response: `ReqMailList` ↔ `RespMailList`.
- Use `Notify` only for server-initiated pushes.
- Pull shared data out into `<Name>Info` so it's defined once and reused.

**Why** — Pairing Req/Resp guarantees every question gets an answer; the matching name makes the pair obvious to people and code generators. `<Name>Info` avoids duplicating the same structure across multiple messages.

### Step 4 — Represent Status with Enums

An **enum** is a multiple-choice list — like an order status that can only be "pending / paid / shipped", nothing else.

```protobuf
enum RoomStatus {
  None = 0;     // no state / invalid
  Waiting = 1;  // waiting to start
  Playing = 3;  // game in progress
}
```

Rules:

- Enum names and values are PascalCase.
- The first value is always `0`, reserved for the default / none state (`None`, `Unknown`).

**Why** — proto3 forces the first value to be `0`. Keeping it as `None` / `Unknown` gives a safe default: an unset field reads as "no state" instead of accidentally matching a real one — preventing a whole class of bugs.

### Step 5 — Define Error Codes

When something fails, give it a number so both sides know exactly what went wrong. There are two layers:

**Generic codes** — common failures every module shares (bad parameters, insufficient cost, not found). They live in `Common_20.proto` as `OperationStatusCode`, numbered from `0` upward.

**Business codes** — failures specific to your module. The number is computed as **`ModuleID × 1000 + a 3-digit ordinal`**.

```protobuf
// Mail is module 500, so its codes start at 500001
// 500001 = 500 × 1000 + 1
enum MailErrorCode {
  MailNotFound = 500001;        // mail doesn't exist
  MailAlreadyDeleted = 500002;  // mail was already deleted
}
```

Rule: the client receives the code as a plain `int`. On success, leave it unset — proto3's default `0` then means "success", so the common case costs nothing to send.

**Why** — The formula makes a code self-describing: `500001` is obviously Mail's, it's globally unique with no coordination, and each module gets 1000 slots to grow. Sending success as "nothing" saves bytes because success is the majority of responses.

### Step 6 — Write Comments

Comments are the only documentation both sides share — a `.proto` file has no surrounding context, so without a comment the other end can only guess.

- Before a message: write its purpose.
- After a field or enum value: write what it means.
- If a field is an `int` that actually holds enum values, name the enum in parentheses, e.g. `// status (RoomStatus)`, so the reader knows where the valid values come from.

**Why** — An `int` alone doesn't reveal its valid set; naming the enum tells the reader exactly where to look.

### Full Example

A hypothetical `Quest_600` (quest system) module exercising every rule above:

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

### Pending Cleanup

All previously listed deviations have been resolved in this pass — nothing remains pending:

- ✅ File naming: `_120_Social.proto` → `Social_120.proto`, `_-120_InnerSocial_s.proto` → `Inner_Social_-120.proto`, `Inner_Basic` package → `InnerBasic`.
- ✅ `RespItemChange` renamed to `RespSellItem` to pair with `ReqSellItem`.
- ✅ `Common_20.proto`: leftover examples (`Person` / `AddressBook` / `PhoneNumber`) removed.
- ✅ Field comments and brace / indent style cleaned up.

The conventions above are now fully reflected in the codebase.

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
