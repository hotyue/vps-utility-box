#!/bin/bash

# --- 配置区 ---
# 内存占用范围 (MB)
MIN_MEM=100
MAX_MEM=300
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

# 2. 生成随机占用量和随机持续时间
CURRENT_MEM=$(( RANDOM % (MAX_MEM - MIN_MEM + 1) + MIN_MEM ))
CURRENT_DURATION=$(( RANDOM % (MAX_DURATION - MIN_DURATION + 1) + MIN_DURATION ))

echo "[$(date)] [内存] 启动模拟: 目标占用 ${CURRENT_MEM}MB，持续 ${CURRENT_DURATION}秒" >> "$LOG_FILE" 2>&1

# 3. 执行 stress-ng (仅针对内存)
# --vm 1: 启动一个内存分配进程
# --vm-bytes: 分配的内存大小
# --vm-keep: 保持内存占用直到超时
stress-ng --vm 1 --vm-bytes "${CURRENT_MEM}M" --vm-keep --timeout "${CURRENT_DURATION}"s --quiet

echo "[$(date)] [内存] 任务完成，本轮维护结束。" >> "$LOG_FILE" 2>&1
