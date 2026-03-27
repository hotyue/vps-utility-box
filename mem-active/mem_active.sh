#!/bin/bash

# --- 配置区 ---
MIN_MEM=100
MAX_MEM=300
MIN_DURATION=100
MAX_DURATION=150
LOG_FILE="/var/log/vps_maintenance.log"

# --- 执行区 ---
if ! command -v stress-ng &> /dev/null; then
    echo "[$(date)] [系统] 正在安装必要依赖: stress-ng..." >> "$LOG_FILE" 2>&1
    apt-get update && apt-get install -y stress-ng > /dev/null 2>&1
fi

CURRENT_MEM=$(( RANDOM % (MAX_MEM - MIN_MEM + 1) + MIN_MEM ))
CURRENT_DURATION=$(( RANDOM % (MAX_DURATION - MIN_DURATION + 1) + MIN_DURATION ))

echo "[$(date)] [内存] 启动模拟: 目标占用 ${CURRENT_MEM}MB，持续 ${CURRENT_DURATION}秒 (低CPU模式)" >> "$LOG_FILE" 2>&1

# --- 核心修复点 ---
# --vm-hang 0 : 改为让它在分配内存后挂起，不进行循环读写
# 我们让它挂起的时间等于持续时间，这样它分配完就睡觉，直到被 timeout 杀死
stress-ng --vm 1 --vm-bytes "${CURRENT_MEM}M" --vm-keep --vm-hang "${CURRENT_DURATION}" --timeout "${CURRENT_DURATION}"s --quiet

echo "[$(date)] [内存] 任务完成，本轮维护结束。" >> "$LOG_FILE" 2>&1