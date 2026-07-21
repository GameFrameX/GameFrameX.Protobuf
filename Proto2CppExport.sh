#!/bin/bash

# 切换目录，-P 选项是用来处理符号链接的
cd -P ../Tools/ProtoExport/bin/Debug/net10.0

# 启动应用程序
dotnet ProtoExport.dll --mode cpp --usingStatements "#include <cstdint>|#include <string>|#include <vector>|#include <unordered_map>" --inputPath ./../../../../../Protobuf --outputPath ./../../../../../Unreal/Source/Proto --namespaceName GameFrameX.Proto --isGenerateErrorCode true
