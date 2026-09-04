# 今日 · 计划与日报

> 多用户 Todo 计划管理与 AI 日报生成平台：记录零成本 + LLM 自动生成日报 + 一键推送钉钉。

![主界面](docs/ui-screenshots/ui_plan.png)

## 核心特性

- **多用户账号体系**：手机号注册 / 登录，JWT + httpOnly Cookie 鉴权，数据按账号隔离
- **5 种日计划模板**：四象限 / 优先级矩阵 / 九宫格日记 / 结构化计划 / 三列分类，一键切换
- **AI 日报生成**：服务端代理调用 OpenAI 兼容接口，API Key 不落前端；未配置 AI 时自动退化为本地模板拼接，永远可用
- **钉钉日报推送**：服务端 HMAC 加签发送，密钥不出服务器；同时支持复制兜底
- **历史与报表**：计划按日归档，统计报表可视化呈现
- **个性化**：头像上传与裁剪、昵称、主题色
- **开发者后台**：AI 服务商 / Key / 模型在线配置，连接测试
- **体验细节**：语音输入、截止时间浏览器通知、PWA 可添加到主屏幕

| 计划列表 | 统计报表 |
|---|---|
| ![计划列表](docs/ui-screenshots/ui_planlist.png) | ![统计报表](docs/ui-screenshots/ui_report_wide.png) |

## 技术栈

| 层 | 技术 |
|---|---|
| 前端 | Vue 3 · Element Plus · Vite |
| 后端 | Node.js · Express 5 |
| 数据 | Prisma ORM · SQLite（单文件，零数据库部署） |
| 鉴权 | JWT · httpOnly Cookie |
| AI | OpenAI 兼容接口（服务端代理调用） |

前后端同源部署：后端直接托管前端构建产物（`public/`），免 CORS、免第二个静态服务器。

## 快速开始

### 本地运行（需 Node.js v18+，无需安装任何数据库）

```bash
bash start-mac-linux.sh   # macOS / Linux / WSL
# Windows 双击 start.bat
```

首次启动自动完成：安装依赖 → 生成 `.env` 与 JWT 密钥 → 建表 → 启动。
浏览器打开 `http://localhost:8787`，注册即用。

### 云端部署（Render 免费档，一键）

仓库根目录已含 `render.yaml`：在 [Render](https://render.com) 新建 Web Service 连接本仓库即可，构建/启动命令与环境变量已全部预置。详细步骤见[《Render部署指南》](Render部署指南.md)。

> 🚀 **在线演示**：部署后把你的 onrender.com 网址填在这里

## 目录结构

```
├── src/                # Express 后端（路由：auth / plans / reports / ai / dingtalk）
├── prisma_database/    # Prisma schema + SQLite 数据文件（app.db）
├── public/             # 前端构建产物（由 frontend/ 构建生成，后端直接托管）
├── frontend/           # Vue 3 前端源码
├── docs/               # 文档与界面截图
├── render.yaml         # Render 云部署配置
├── start.bat / start-mac-linux.sh   # 本地一键启动
```

## 更多文档

- [部署与跨设备使用](部署与跨设备使用.md) —— 本机启动 / 局域网 / Tailscale / 隧道 / 数据备份
- [Render 部署指南](Render部署指南.md) —— 云端演示环境从零到上线
- [本地部署](本地部署.md)

## AI 服务商预设

| 服务商 | Base URL | 默认模型 |
|---|---|---|
| 硅基流动（推荐） | api.siliconflow.cn/v1 | Qwen/Qwen3-8B |
| 智谱 GLM | open.bigmodel.cn | glm-4.7-flash |
| DeepSeek | api.deepseek.com/v1 | deepseek-chat |
| 阿里百炼 | dashscope | qwen-plus |
| 自定义 | 你填 | 你填 |

> 服务端代理调用，不受浏览器 CORS 限制；「自定义」可填内网网关地址。
