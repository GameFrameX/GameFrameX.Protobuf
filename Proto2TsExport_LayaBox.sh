#!/bin/bash
cd "$(dirname "$0")" || exit 1
# 自动选择对应平台的 ProtoExport 预编译二进制（self-contained，无需安装 .NET）
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64) PROTO_EXPORT_BIN=./Tools/osx-arm64/ProtoExport;;
  Darwin-*)     PROTO_EXPORT_BIN=./Tools/osx-x64/ProtoExport;;
  *) echo "[ERROR] 暂仅提供 macOS (arm64/x64) 与 Windows 预编译二进制"; exit 1;;
esac
xattr -cr "$PROTO_EXPORT_BIN" 2>/dev/null  # 清除 macOS quarantine 标记
chmod +x "$PROTO_EXPORT_BIN"
"$PROTO_EXPORT_BIN"  \
    --mode typescript \
    --inputPath ./ \
    --outputPath ../LayaBox/assets/scripts/protobuf \
    --isGenerateErrorCode true \
    --importPath "../../../src/gameframex/network/"

echo "TypeScript 导出完成: LayaBox/assets/scripts/protobuf/"
