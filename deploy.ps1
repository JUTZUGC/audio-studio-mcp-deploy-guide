# Audio Studio MCP 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/kanaworksai-hue/audio-studio-mcp#-quick-start
# 更新日期：2026-11-02
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/kanaworksai-hue/audio-studio-mcp.git
Set-Location audio-studio-mcp
powershell -ExecutionPolicy Bypass -File install.ps1
Write-Host "安装完成：按脚本输出的命令注册 MCP"

Write-Host ''
$url = 'http://127.0.0.1:8765'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成，浏览器访问 http://127.0.0.1:8765'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/kanaworksai-hue/audio-studio-mcp#-quick-start'
