# 今日 · 计划与日报（Todo 计划管理 · 纯前端单文件版）

一个极简的 Todo 计划管理工具：**记录零成本 + LLM 自动生成日报 + 一键复制到钉钉**。
纯前端单文件 HTML，无需后端、无需数据库、无需注册——双击打开即用，数据存在本浏览器。

## 为什么是纯前端版

云端工作空间的容器端口默认不对外暴露，外部浏览器连不到容器内跑的服务端。因此本版改为**纯前端单文件**：所有逻辑、数据、AI 调用都在浏览器本地完成，任意环境双击 HTML 即可使用。

## 功能

- 5 种日计划模板：四象限 / 优先级矩阵 / 九宫格日记 / 结构化计划 / 三列分类
- 计划与日报存浏览器 `localStorage`，按日期切换
- AI 日报生成（浏览器直连 OpenAI 兼容接口），未配置 AI 时自动退化为本地模板拼接
- 钉钉/飞书日报：复制内容兜底（纯前端无法安全持有机器人密钥）
- 开发者后台（口令门禁）：配置 AI 服务商 / Key / 模型，Key 仅存本浏览器
- 截止时间浏览器通知、语音输入

## 怎么用

**方式一（最简单）：直接双击文件**
把 `todo-plan.html` 下载到本机，双击用浏览器打开。

> 双击打开是 `file://` 协议，页面顶部会提示语音/AI 在 http 下更稳定。

**方式二（推荐，http 协议更稳定）：本地起个静态服务**
```bash
# 在 todo-plan.html 所在目录
python3 -m http.server 8080
# 浏览器访问 http://localhost:8080/todo-plan.html
```

## 使用流程

1. 打开页面 → 直接进主界面（无需注册登录）
2. 选模板添加任务、设截止时间、填九宫格
3. 点「生成日报」——未配置 AI 时用本地模板拼接，永远可用
4. 配置 AI：连点左上角「今日」logo 5 次（800ms 内）或「我的 → 开发者后台」，首次设置口令，填 AI 服务商 + Key
5. 「钉钉日报」→ 复制日报内容，去钉钉机器人/群粘贴

## 开发者后台

| 入口 | 操作 |
|---|---|
| 我的页面 | 滚到底部点「开发者后台」 |
| 隐藏入口 | 主界面连点左上角「今日」logo 5 次 |

首次进入设置一个口令（存本浏览器），之后输入口令进入。可配置：AI 服务商 / API Key / 模型 / 极速模式，还能测试连接、改口令。

## AI 服务商预设

| 服务商 | Base URL | 默认模型 | 说明 |
|---|---|---|---|
| 硅基流动（推荐） | api.siliconflow.cn/v1 | Qwen/Qwen3-8B | 新用户送 2000 万 token，自动关闭思考 |
| 智谱 GLM | open.bigmodel.cn | glm-4.7-flash | 跨域可能被拦，建议内网网关 |
| DeepSeek | api.deepseek.com/v1 | deepseek-chat | 准确但偏慢 |
| 阿里百炼 | dashscope | qwen-plus | — |
| 自定义 | 你填 | 你填 | 内网网关可避开 CORS |

> 跨域限制说明：浏览器直连 LLM 厂商 API 可能被 CORS 拦。若报跨域错，用「自定义」填一个加了 CORS 头的内网网关地址。

## 数据存哪

| 数据 | 存储位置 |
|---|---|
| 每日计划（5 模板） | localStorage `todo_plan_YYYY-MM-DD` |
| 每日日报 | localStorage `todo_report_YYYY-MM-DD` |
| 头像/颜色/昵称 | localStorage `todo_profile` |
| AI 配置/Key | localStorage `todo_key` 等 |
| 开发者口令 | localStorage `todo_devpin` |
| 调用记录 | localStorage `todo_apilog` |

- 「我的 → 导出全部数据」可备份为 JSON
- 「我的 → 清空全部数据」可清空所有计划与日报

> 数据存在本浏览器，换浏览器/清缓存会丢失。重要数据请定期导出。

## 关于后端版

仓库内保留了完整后端代码（`src/` + `prisma_database/` + `frontend/`）：
- Node.js + Express + Prisma + **SQLite**（零数据库依赖，数据落单文件 `prisma_database/app.db`）
- 账号鉴权（httpOnly Cookie + JWT）、服务端 AI 调用、钉钉 HMAC 加签发送
- 一键启动：`bash start-mac-linux.sh`（macOS/Linux/WSL）或 `start.bat`（Windows），首次自动装依赖、生成密钥、建表
- 访问 `http://localhost:8787`，注册即用；手机跨设备访问见《部署与跨设备使用.md》

后端版适合**数据多端同步、密钥不放前端、长期使用**的场景。
