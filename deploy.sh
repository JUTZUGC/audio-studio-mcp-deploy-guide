#!/usr/bin/env bash
set -euo pipefail
# Audio Studio MCP 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/kanaworksai-hue/audio-studio-mcp#-quick-start
# 更新日期：2026-11-02
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/kanaworksai-hue/audio-studio-mcp.git
cd audio-studio-mcp
./install.sh
echo "安装完成：按脚本输出的命令注册 MCP"

echo ""
if command -v curl >/dev/null 2>&1; then
  echo "等待服务启动：http://127.0.0.1:8765"
  ready=0
  for _ in $(seq 1 30); do
    if curl -sS -o /dev/null "http://127.0.0.1:8765" 2>/dev/null; then ready=1; break; fi
    sleep 2
  done
  if [ "$ready" = "1" ]; then
    echo "服务已就绪"
  else
    echo "警告：60 秒内未探测到 http://127.0.0.1:8765，请手动打开确认或查看日志"
    exit 1
  fi
else
  echo "未检测到 curl，跳过启动探测；请手动访问 http://127.0.0.1:8765 确认"
fi
echo "部署完成，浏览器访问 http://127.0.0.1:8765"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/kanaworksai-hue/audio-studio-mcp#-quick-start"
