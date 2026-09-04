@echo off
chcp 65001 >nul
REM 今日计划·一键启动 (Windows)
cd /d "%~dp0"
title 今日计划
echo ================= 今日计划 =================
echo.
echo [1/4] 检查 Node.js
where node >nul 2>nul
if errorlevel 1 (
  echo   [X] 未检测到 Node.js！
  echo   请先安装 Node.js v18+：https://nodejs.org/zh-cn 下载 LTS 版安装
  echo   装完重启电脑后再双击本脚本
  echo.
  pause
  exit /b 1
)
for /f "tokens=*" %%v in ('node -v') do echo   [OK] Node %%v
echo.
echo [2/4] 初始化配置
call node scripts\init-env.cjs
if errorlevel 1 (
  echo   [X] 配置初始化失败
  echo.
  pause
  exit /b 1
)
echo.
echo [3/4] 安装依赖（首次约几分钟，请勿关闭窗口）
if not exist node_modules\@prisma (
  call npm install --include=dev
  if errorlevel 1 (
    echo   [X] 依赖安装失败，请检查网络后重试
    echo.
    pause
    exit /b 1
  )
)
echo [3b/4] 建表
call npx prisma migrate deploy --schema=prisma_database/schema.prisma
call npx prisma generate --schema=prisma_database/schema.prisma
echo.
echo [4/4] 启动服务
echo   启动后浏览器打开: http://localhost:8787
echo   手机同 WiFi 访问: http://本机内网IP:8787
echo   使用期间请勿关闭本窗口，关闭即停止服务
echo ==================================================
echo.
call npm start
echo.
echo 服务已停止。
pause
