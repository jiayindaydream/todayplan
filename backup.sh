#!/usr/bin/env bash
# 今日计划 · 数据库备份
# 把 SQLite 数据文件复制到 backups/ 目录，带日期戳。可挂到系统计划任务每日执行。
# 用法: bash backup.sh
set -e
cd "$(dirname "$0")"
SRC="prisma_database/app.db"
mkdir -p backups
DATE=$(date +%Y%m%d)
DST="backups/app-${DATE}.db"
if [ -f "$SRC" ]; then
  cp "$SRC" "$DST"
  echo "✓ 已备份到 $DST"
  # 只保留最近 30 份
  ls -t backups/app-*.db 2>/dev/null | tail -n +31 | while read -r f; do rm -f "$f"; done
else
  echo "✗ 未找到 $SRC（服务是否启动过？）"
  exit 1
fi
