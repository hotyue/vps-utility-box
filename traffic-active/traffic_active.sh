#!/bin/bash

# --- 配置区 ---
MIN_SIZE=20
MAX_SIZE=50
TEST_URL="http://http.us.debian.org/debian/ls-lR.gz"
TEMP_FILE="/tmp/vps_traffic_test.tmp"
LOG_FILE="/var/log/vps_maintenance.log"

# --- 执行区 ---
TARGET_SIZE=$(( RANDOM % (MAX_SIZE - MIN_SIZE + 1) + MIN_SIZE ))

echo "[$(date)] [网络] 启动任务，目标下载量: ${TARGET_SIZE}MB" >> "$LOG_FILE" 2>&1

curl -L -s -o "$TEMP_FILE" --max-filesize "$((TARGET_SIZE * 1024 * 1024))" "$TEST_URL"
rm -f "$TEMP_FILE"

echo "[$(date)] [网络] 任务完成，已清理缓存。" >> "$LOG_FILE" 2>&1