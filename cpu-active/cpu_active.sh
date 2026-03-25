#!/bin/bash

# --- 配置区 ---
# CPU 负载范围 (%)
MIN_CPU=15
MAX_CPU=50
# 持续时间范围 (秒)
MIN_DURATION=100
MAX_DURATION=150
LOG_FILE="/var/log/vps_maintenance.log"

# --- 执行区 ---
# 1. 检查并安装依赖
if ! command -v stress-ng &> /dev/null; then
    echo "[$(date)] [系统] 正在安装必要依赖: stress-ng..." >> "$LOG_FILE" 2>&1
    apt-get update && apt-get install -y stress-ng > /dev/null 2>&1
fi

# 2. 生成随机负载和随机持续时间
CURRENT_CPU_LOAD=$(( RANDOM % (MAX_CPU - MIN_CPU + 1) + MIN_CPU ))
CURRENT_DURATION=$(( RANDOM % (MAX_DURATION - MIN_DURATION + 1) + MIN_DURATION ))

echo "[$(date)] [CPU] 启动模拟: 目标负载 ${CURRENT_CPU_LOAD}%，持续 ${CURRENT_DURATION}秒" >> "$LOG_FILE" 2>&1

# 3. 执行 stress-ng
stress-ng --cpu 1 --cpu-load "$CURRENT_CPU_LOAD" --timeout "${CURRENT_DURATION}"s --quiet

echo "[$(date)] [CPU] 任务完成，本轮维护结束。" >> "$LOG_FILE" 2>&1