#!/usr/bin/env bash
# 今日计划 · 一键启动 (macOS / Linux / WSL)
# 用法: bash start-mac-linux.sh
set -e
cd "$(dirname "$0")"

echo "================ 今日计划 ================"

# 1. 检查 Node
echo ">>> [1/4] 检查 Node.js"
if command -v node >/dev/null 2>&1; then
  echo "  ✓ Node $(node -v)"
else
  echo "  ✗ 未检测到 Node.js，请先安装 Node.js v18+ (https://nodejs.org/zh-cn)"
  exit 1
fi

# 2. .env 配置（init-env.cjs 负责：从 .env.example 生成 + 自动生成 JWT_SECRET）
echo ">>> [2/4] 初始化配置"
node scripts/init-env.cjs

# 3. 依赖 + 建表
echo ">>> [3/4] 安装依赖 & 建表"
if [ ! -d node_modules ] || [ ! -d node_modules/@prisma ]; then
  npm install --include=dev
fi
npx prisma migrate deploy --schema=prisma_database/schema.prisma
npx prisma generate --schema=prisma_database/schema.prisma

# 4. 启动
echo ">>> [4/4] 启动服务"
PORT=$(grep -E '^PORT=' .env | cut -d= -f2 | tr -d '"' || true)
PORT=${PORT:-8787}
echo "  浏览器打开: http://localhost:${PORT}"
echo "  手机同 WiFi 访问: http://本机内网IP:${PORT}"
echo "  按 Ctrl+C 停止"
echo "==================================================="
npm start
