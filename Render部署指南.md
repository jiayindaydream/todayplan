# Render 免费部署指南（超详细 · 跟着点就行）

**目标**：拿到一个固定公网网址（如 `https://today-plan.onrender.com`），发给任何人、放进简历，随时点开就能体验你的项目。

**全程四步，约 20–30 分钟，免信用卡**。每一步都写了「点哪里」「会看到什么」「怎样算成功」。

> 卡住时：回到上一步检查是不是漏点/漏传了什么；实在不行把**报错截图**留下来问。

---

## 第 0 步 · 注册两个免费账号（约 10 分钟，已有可跳过）

### 0.1 注册 GitHub（代码仓库）

1. 浏览器打开 **https://github.com**
2. 首页中间表单：填 **邮箱**（QQ 邮箱可以）→ **密码** → **用户名**（英文+数字，如 `chenjiayi-plans`）→ 点绿色按钮 **Sign up for GitHub**
3. 过一个拼图/选图验证 → 按提示去**邮箱点验证链接**
4. 问卷页（What would you like to do）随便选或直接跳过（Skip）
5. **✅ 成功标志**：能进入 github.com 并看到自己的头像/首页

### 0.2 注册 Render（云托管平台）

1. 打开 **https://render.com** → 点右上角 **Get Started for Free**（或 Sign Up）
2. 登录方式选 **Sign in with GitHub**（强烈推荐，后面免输密码）
3. 弹出 GitHub 授权页 → 点 **Authorize Render**
4. **✅ 成功标志**：能打开 https://dashboard.render.com 并看到欢迎页（可能有新手引导，点 Skip/跳过没关系）

---

## 第 1 步 · 把代码上传到 GitHub（约 5 分钟）

### 1.1 下载并解压部署包

1. 在工作空间里找到 **`Plan-deploy.zip`**（17MB），下载到自己电脑
2. 解压：
   - **Windows**：右键 zip →「全部解压缩」
   - **Mac**：双击 zip
3. 解压后得到一个 `Plan` 文件夹，**双击进入这个文件夹**，里面应该能看到：
   `render.yaml`、`package.json`、`src`、`public`、`scripts`、`prisma_database`、`start.bat` 等约 20 项

> ⚠️ 记住：接下来上传的是 **Plan 文件夹里面的内容**，不是 Plan 文件夹本身。`render.yaml` 必须位于仓库根目录，传错了第 2 步会失败。

### 1.2 创建 GitHub 仓库

1. 登录 GitHub，点**右上角头像旁的 + 号** → **New repository**
2. 按下面填写：
   - **Repository name**：`today-plan`（小写英文，别用中文）
   - **Description**：可留空
   - 选 **Public**（Render 免费档要求公开仓库；代码里不含任何密钥和真实数据，放心公开）
   - 下面的 Add a README / .gitignore / license **全部不勾**
3. 点绿色按钮 **Create repository**

**✅ 成功标志**：进入新仓库页面，中间有一块「Quick setup」区域，里面有 **「uploading an existing file」** 这个蓝色超链接。

### 1.3 上传文件

1. 点 **uploading an existing file** 链接
2. 打开解压出的 `Plan` 文件夹，**进入文件夹内**：
   - **Windows**：`Ctrl + A` 全选 → 按住拖进浏览器页面的虚线框
   - **Mac**：`Cmd + A` 全选 → 拖进虚线框
   - （共约 80 个文件，低于网页单次 100 个上限，一次拖完）
3. 等下方文件列表全部加载完、进度条消失
4. 点页面下方绿色按钮 **Commit changes**（弹窗里标题默认即可）→ 等待上传完成

**✅ 成功标志**：回到仓库首页，能直接看到 `render.yaml`、`src`、`public`、`package.json`、`prisma_database` 等。逐个对照一遍。

> 💡 如果发现 `.env.example` 没出现在列表里——正常，网页上传常丢点开头的文件。代码里有兜底逻辑，不影响部署。
> 💡 如果漏传了某个文件夹（比如 `prisma_database` 不见了）：点仓库页面 **Add file → Upload files**，单独补传一次即可。

---

## 第 2 步 · 在 Render 创建服务（约 5 分钟 + 5–10 分钟等待）

1. 打开 **https://dashboard.render.com**，点**右上角 New +** → **Web Service**
2. 在 Git 仓库列表找到 `today-plan`，点它右边的 **Connect**
   - 如果列表里没有：点旁边的 **GitHub - Configure account** → 勾选你的 GitHub 账号 → **Install**，回来刷新
3. 进入配置页，逐项检查：
   | 配置项 | 填什么 |
   |---|---|
   | **Name** | `today-plan`（决定网址前缀，小写英文） |
   | **Language** | 应显示 `Node`（若空着也没关系） |
   | **Build Command** | 若没自动填，粘贴：<br>`npm install --include=dev && node scripts/init-env.cjs && npx prisma migrate deploy --schema=prisma_database/schema.prisma && npx prisma generate --schema=prisma_database/schema.prisma` |
   | **Start Command** | 若没自动填，粘贴：`node src/server.js` |
   | **Instance Type** | **必须选 `Free`**（最左边那个 $0/月）⚠️ 选错会扣费 |
4. 点最下方绿色按钮 **Create Web Service**
5. 页面开始自动滚动部署日志，依次出现：
   ```
   => Installing dependencies（npm install，最慢，几分钟）
   => 运行 init-env / prisma（很快）
   => Starting service
   => Server running on http://localhost:xxxx
   ```
6. 等顶部状态从黄色 **Deploying** 变成绿色 **Live**

**✅ 成功标志**：状态为绿色 **Live**，日志末尾有 `Server running`。

> ❌ 如果是红色 **Build Failed**：日志里找第一条 `error`。最常见原因：
> - GitHub 上漏传了文件夹（回 1.3 检查补传）
> - 免费档/区域问题导致 build 命令没读到 → 手动粘贴上面的两条命令再来一次（Render 服务页 **Settings → Build Command / Start Command** 可改，改完点 **Manual Deploy → Deploy latest commit**）

---

## 第 3 步 · 打开网址、验收（约 3 分钟）

1. 服务页面**左上角**服务名下方有一个网址（形如 `https://today-plan-xxxx.onrender.com`），点击打开
2. **首次打开会等约 30–60 秒**（免费档休眠唤醒，转圈是正常的）→ 之后出现登录页
3. 按下面清单验收：
   - [ ] 点「注册」：手机号随便填 11 位演示号 + 密码 → 注册成功进入主界面
   - [ ] 加 2–3 条计划任务，试试切换模板（四象限/九宫格等）
   - [ ] 点「生成日报」
   - [ ] 「我的」页换个头像和昵称
4. 全部通过 → **这个网址就是你的项目展示网址了**，收藏它

### （可选）定制网址

服务页 **Settings → Custom Domains** 区域可改子域名前缀（如 `jiayi-plan.onrender.com`）。绑定自己的域名也在这里，但域名要花钱，先用免费子域名足够。

---

## 第 4 步 · 发出去

- **发给别人**：直接发网址，附一句「首次打开需等约 1 分钟唤醒」
- **放简历/README**：

> **今日 · 计划与日报** —— 多用户 Todo 计划管理与 AI 日报生成平台
> 技术栈：Vue 3 · Element Plus · Express · Prisma · SQLite
> 在线演示：https://today-plan-xxxx.onrender.com （免费实例，首次访问需约 1 分钟唤醒）

---

## 长期使用须知

| 事项 | 说明 |
|---|---|
| 休眠 | 15 分钟无人访问自动休眠，下次点开等约 1 分钟。演示场景可接受 |
| **数据会重置** | 免费档磁盘不持久，重启/重新部署后所有账号和数据清空。**只放演示数据，真实计划请用本机版**（见《部署与跨设备使用.md》） |
| 更新代码 | GitHub 仓库 **Add file → Upload files** 重新上传改动 → Render 检测到变化自动重新部署 |
| AI Key 安全 | Key 在「开发者后台」按账号存数据库，数据库重置时一并清空，不会泄露 |
| 免费档变化 | 若 Render 取消免费档：备选 Render Starter（$7/月）或 Railway；代码不用改 |

## 常见问题速查

| 现象 | 原因/处理 |
|---|---|
| 打开网址一直转圈 | 休眠唤醒中，等 1 分钟刷新 |
| 打开显示 502 | 刚部署完还在启动，等 30 秒刷新 |
| Build Failed | 看 1.3 / 第 2 步的排查说明 |
| 登录态老掉/需重登 | 正常现象（免费档重启重建服务），重新登录即可 |
| 想改端口/配置 | 一般不用动；要动就改 `render.yaml` 后重新上传 GitHub |
