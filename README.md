# Audio Studio MCP 一键安装指南

> 第三方部署指南 · 非 Audio Studio MCP 官方仓库。官方项目：[kanaworksai-hue/audio-studio-mcp](https://github.com/kanaworksai-hue/audio-studio-mcp)
> 内容来自官方文档（2026-11-02）。项目迭代快，请以[官方文档](https://github.com/kanaworksai-hue/audio-studio-mcp#-quick-start)为准。

[![⚡ 一键安装](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键安装推荐用百度搭子)

## 一键安装（推荐：用百度搭子）

> [!TIP]
> 给游戏配一段 BGM，不该先注册云服务再充钱；本地跑模型就够了。

⚠️ Windows 需要 NVIDIA 显卡（8 GB 显存起）与较新驱动，磁盘约 14 GB；模型权重在 Hugging Face 上是 gated，必须先接受许可并登录。macOS 只支持 Apple Silicon，Linux 暂无安装器。首次安装要下载数 GB 模型，耗时取决于网速。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/audio-studio-mcp-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会按系统跑官方安装脚本，建好虚拟环境、拉取 Stable Audio 3 并下载模型，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:8765](http://127.0.0.1:8765)，按官方引导完成初始化配置。

## Audio Studio MCP 是什么？

Audio Studio MCP 是开源的让 agent 在本地生成背景音乐与音效，循环、响度、导出一次做完，不花 API 钱（协议：MIT，<img src="https://img.shields.io/github/stars/kanaworksai-hue/audio-studio-mcp?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

本地音频生成 MCP 服务：用 Stable Audio 3 按一句话生成背景音乐、乐器循环与音效，支持重绘、续写、无缝循环、淡入淡出、响度归一与 WAV/OGG/FLAC 导出。

- 本地生成：不上传、不按次计费、无需 API Key
- 三类产出：BGM、乐器循环、音效
- 后期处理：无缝循环、淡入淡出、LUFS 归一
- 可复现：每个文件带 prompt、seed 与参数 sidecar
- 自带 Web UI 与 MCP 两种用法
- MIT，可自用可二开

（来源：[官方仓库](https://github.com/kanaworksai-hue/audio-studio-mcp)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 561 stars 10 月新项目 | 名称搜索仅 4 条结果 |
| 本地生成 | 无 API Key、无按次费用 |
| 生成、编辑、后期处理一条链 | — |
| 每个产物带 prompt 与 seed | 可复现 |
| 同时提供 MCP 与 Web UI | — |
| MIT | 自用与二开都自由 |

| 需要注意 | 说明 |
|---|---|
| Windows 必须 NVIDIA 显卡 | 显存 8 GB 起 |
| 首次要下载数 GB 权重 | — |
| Hugging Face 权重需登录并接受许可 | — |
| Linux 没有安装器 | — |
| 生成速度受显卡限制 | — |

> 以上基于官方文档与社区反馈整理（2026-11-02），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/kanaworksai-hue/audio-studio-mcp.git
cd audio-studio-mcp
./install.sh
echo "安装完成：按脚本输出的命令注册 MCP"
```

启动后浏览器访问 [http://127.0.0.1:8765](http://127.0.0.1:8765)（管理面板）。（来源：[https://github.com/kanaworksai-hue/audio-studio-mcp#-quick-start](https://github.com/kanaworksai-hue/audio-studio-mcp#-quick-start)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 Windows/macOS 安装脚本、显存与磁盘要求 | 已核对 2026-11-02 |
| 确认 8765 网页端口与 `--http` 的 MCP 端点写法 | 已核对 2026-11-02 |
| 未实测安装、模型下载与生成 | 说明 2026-11-02 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-02 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-02 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身就是 MCP 服务器，提供生成、编辑、后期处理三类工具，可接入 Claude Code、Claude Desktop、Cursor 等；本仓库的 MCP 只提供安装步骤与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-02）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\audio-studio-mcp-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 装之前先确认

| 项目 | 要求 |
|---|---|
| Windows | 64 位 Win10/11 + NVIDIA 显卡，8 GB 显存起 |
| macOS | Apple Silicon（M1 及以上），建议 16 GB 内存 |
| 磁盘 | Windows 约 14 GB，macOS 约 6 GB |
| 依赖 | `git`、`ffmpeg` |
| 账号 | Windows 需 Hugging Face 登录并接受模型许可 |

Windows 装依赖：

```powershell
winget install Git.Git
winget install Gyan.FFmpeg
```

## 注册 MCP

安装脚本最后会打印注册命令。Windows 大致是：

```powershell
claude mcp add --scope user audio-studio -- "C:\\path\\to\\audio-studio-mcp\\.venv\\Scripts\\audio-studio-mcp.exe"
```

macOS 把路径换成 `.venv/bin/audio-studio-mcp`。

## 用网页界面

```powershell
.venv\Scripts\audio-studio-mcp.exe --web 8765
```

浏览器打开 `http://127.0.0.1:8765`（Web UI）。想让它以 HTTP 方式给 MCP 客户端用，加 `--http 8765 --preload`，再把客户端指向 8765 端口的 `/mcp` 路径。

## 模型与显存

默认下载 medium（1.4B）；`--model all` / `-Model all` 会再加小模型，Windows 多占约 7 GB。显存不够时先跑 small 档，或设 `AUDIO_STUDIO_DEVICE=cpu` 兜底，但会慢很多。

## 注意

- 模型权重受 Stability AI 社区许可约束，商用前先读条款
- 权重不在仓库里，首次安装必须联网
- Windows 的 gated 模型要先在网页上接受许可，否则下载会被拒
- Linux 只有手动路径，没有安装器
- 生成质量与速度取决于显卡，8 GB 显存是下限

## 常见坑

- 安装卡在模型下载：先在 Hugging Face 接受许可并 `hf auth login`
- 提示显存不足：换 small 档，或设 `AUDIO_STUDIO_DEVICE=cpu`
- macOS 装成 Intel 环境：用 `UV_PYTHON` 指向 arm64 的 Python 后重跑安装
- MCP 客户端连不上：用绝对路径注册，注册后重启客户端
- ffmpeg 找不到：先 `winget install Gyan.FFmpeg` 并重开终端
- 网页打不开：确认 `--web 8765` 已启动，端口没被占用
- 生成很慢：首次会加载模型，之后同进程内会快很多

## 免责声明

本仓库为第三方指南，与 Audio Studio MCP 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-02），项目迭代快，请以[官方文档](https://github.com/kanaworksai-hue/audio-studio-mcp#-quick-start)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
