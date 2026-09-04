#!/usr/bin/env bash
# 今日计划·后端版 —— 本机一键部署脚本 (macOS / Linux / WSL)
# 用法: bash setup.sh
set -e

echo "================ 今日计划·本机部署 ================"

# 1. 依赖检查
echo ">>> [1/5] 检查依赖"
command -v node >/dev/null || { echo "✗ 未安装 Node.js (需 v18+)，请先装 Node"; exit 1; }
command -v psql >/dev/null || { echo "✗ 未安装 psql (PostgreSQL 客户端)，请先装 PostgreSQL"; exit 1; }
echo "✓ Node $(node -v)  /  psql $(psql --version | awk '{print $3}')"

# 2. .env 配置
echo ">>> [2/5] 生成 .env"
if [ ! -f .env ]; then
  cp .env.example .env
  echo "  已从 .env.example 复制，默认连本机 localhost:5432，账号 todo/todo，库 todo"
  echo "  如需改密码/库，现在编辑 .env 后再继续。"
else
  echo "  .env 已存在，跳过"
fi

# 3. 数据库 & 账号 (用 postgres 超级账创建)
echo ">>> [3/5] 创建数据库与账号"
PGPASSWORD_LOCAL="${PGPASSWORD:-}"  # 如需非交互登录 postgres，可 export PGPASSWORD
DB_URL=$(grep '^DATABASE_URL' .env | sed -E 's/.*\/\/([^:]+):([^@]+)@([^:]+):([0-9]+)\/([^?]+).*/\1 \2 \3 \4 \5/')
DB_USER=$(echo "$DB_URL" | awk '{print $1}')
DB_PASS=$(echo "$DB_URL" | awk '{print $2}')
DB_HOST=$(echo "$DB_URL" | awk '{print $3}')
DB_PORT=$(echo "$DB_URL" | awk '{print $4}')
DB_NAME=$(echo "$DB_URL" | awk '{print $5}')
echo "  目标: ${DB_USER}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
PSQL_SUPER="psql -U postgres -h ${DB_HOST} -p ${DB_PORT}"
if $PSQL_SUPER -c "SELECT 1" >/dev/null 2>&1; then
  $PSQL_SUPER -tc "SELECT 1 FROM pg_roles WHERE rolname='${DB_USER}'" | grep -q 1 || \
    $PSQL_SUPER -c "CREATE USER \"${DB_USER}\" WITH PASSWORD '${DB_PASS}';"
  $PSQL_SUPER -tc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | grep -q 1 || \
    $PSQL_SUPER -c "CREATE DATABASE \"${DB_NAME}\" OWNER \"${DB_USER}\";"
  $PSQL_SUPER -c "GRANT ALL PRIVILEGES ON DATABASE \"${DB_NAME}\" TO \"${DB_USER}\";" >/dev/null
  echo "  ✓ 账号/库就绪 (若已存在则跳过)"
else
  echo "  ! 无法用 postgres 账号登录，请手动执行以下 SQL 后重跑本脚本："
  echo "    CREATE USER \"${DB_USER}\" WITH PASSWORD '${DB_PASS}';"
  echo "    CREATE DATABASE \"${DB_NAME}\" OWNER \"${DB_USER}\";"
  echo "    GRANT ALL PRIVILEGES ON DATABASE \"${DB_NAME}\" TO \"${DB_USER}\";"
  exit 1
fi

# 4. 安装依赖 + 迁移
echo ">>> [4/5] 安装依赖 & 建表"
npm install --include=dev
npx prisma migrate deploy --schema=prisma_database/schema.prisma
npx prisma generate  --schema=prisma_database/schema.prisma

# 5. 启动
echo ">>> [5/5] 启动服务"
echo "  浏览器打开: http://localhost:8787"
echo "  按 Ctrl+C 停止"
echo "==================================================="
npm start
