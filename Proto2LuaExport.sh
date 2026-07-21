#!/bin/bash

# 切换目录，-P 选项是用来处理符号链接的
cd -P ../Tools/ProtoExport/bin/Debug/net10.0

# 启动应用程序
dotnet ProtoExport.dll --mode lua --importPath "./network/" --inputPath ./../../../../../Protobuf --outputPath ./../../../../../Defold/scripts/protobuf --isGenerateErrorCode true
