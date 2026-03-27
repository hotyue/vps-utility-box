#!/bin/bash

# --- 基础配置 ---
BASE_PATH="/root"
LOG_FILE="/var/log/vps_maintenance.log"
GITHUB_RAW="https://raw.githubusercontent.com/hotyue/vps-utility-box/main"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}=== VPS 自动化维护工具箱 v2.0.0 ===${NC}"
echo "本脚本将引导您完成模块化部署"

# 1. 模块选择
echo -e "\n${GREEN}[1/3] 模块选择${NC}"
echo "请选择需要开启的模块 (多选请用逗号分隔，如 1,2,3):"
echo "1) CPU 负载模拟"
echo "2) 内存占用模拟"
echo "3) 网络流量增强"
read -p "您的选择: " SELECTED_MODULES

# 2. 参数收集与脚本生成
echo -e "\n${GREEN}[2/3] 参数配置${NC}"

# 处理 CPU 模块
if [[ $SELECTED_MODULES == *"1"* ]]; then
    echo -e "\n--- CPU 模块配置 ---"
    read -p "CPU 负载下限 (%): " cpu_min
    read -p "CPU 负载上限 (%): " cpu_max
    read -p "运行时长下限 (秒): " cpu_dur_min
    read -p "运行时长上限 (秒): " cpu_dur_max
    read -p "运行频率 (分钟/次，建议10): " cpu_cron
    
    cat << EOF > ${BASE_PATH}/cpu_active.sh
#!/bin/bash
if ! command -v stress-ng &> /dev/null; then apt-get update && apt-get install -y stress-ng > /dev/null 2>&1; fi
MIN_CPU=$cpu_min; MAX_CPU=$cpu_max; MIN_DURATION=$cpu_dur_min; MAX_DURATION=$cpu_dur_max
CURRENT_CPU_LOAD=\$(( RANDOM % (MAX_CPU - MIN_CPU + 1) + MIN_CPU ))
CURRENT_DURATION=\$(( RANDOM % (MAX_DURATION - MIN_DURATION + 1) + MIN_DURATION ))
echo "[\$(date)] [CPU] 启动: 负载 \${CURRENT_CPU_LOAD}%, 持续 \${CURRENT_DURATION}s" >> $LOG_FILE 2>&1
stress-ng --cpu 1 --cpu-load "\${CURRENT_CPU_LOAD}" --timeout "\${CURRENT_DURATION}"s --quiet
echo "[\$(date)] [CPU] 任务完成。" >> $LOG_FILE 2>&1
EOF
    chmod +x ${BASE_PATH}/cpu_active.sh
    CPU_READY=true
fi

# 处理内存模块
if [[ $SELECTED_MODULES == *"2"* ]]; then
    echo -e "\n--- 内存模块配置 ---"
    read -p "内存占用下限 (MB): " mem_min
    read -p "内存占用上限 (MB): " mem_max
    read -p "运行时长下限 (秒): " mem_dur_min
    read -p "运行时长上限 (秒): " mem_dur_max
    read -p "运行频率 (分钟/次，建议10): " mem_cron
    
    cat << EOF > ${BASE_PATH}/mem_active.sh
#!/bin/bash
if ! command -v stress-ng &> /dev/null; then apt-get update && apt-get install -y stress-ng > /dev/null 2>&1; fi
MIN_MEM=$mem_min; MAX_MEM=$mem_max; MIN_DURATION=$mem_dur_min; MAX_DURATION=$mem_dur_max
CURRENT_MEM=\$(( RANDOM % (MAX_MEM - MIN_MEM + 1) + MIN_MEM ))
CURRENT_DURATION=\$(( RANDOM % (MAX_DURATION - MIN_DURATION + 1) + MIN_DURATION ))
echo "[\$(date)] [内存] 启动: 目标占用 \${CURRENT_MEM}MB, 持续 \${CURRENT_DURATION}s" >> $LOG_FILE 2>&1
stress-ng --vm 1 --vm-bytes "\${CURRENT_MEM}M" --vm-keep --vm-hang "\${CURRENT_DURATION}" --timeout "\${CURRENT_DURATION}"s --quiet
echo "[\$(date)] [内存] 任务完成。" >> $LOG_FILE 2>&1
EOF
    chmod +x ${BASE_PATH}/mem_active.sh
    MEM_READY=true
fi

# 处理网络模块
if [[ $SELECTED_MODULES == *"3"* ]]; then
    echo -e "\n--- 网络流量模块配置 ---"
    read -p "单次下载下限 (MB): " net_min
    read -p "单次下载上限 (MB): " net_max
    read -p "运行频率 (分钟/次，建议10): " net_cron
    
    cat << EOF > ${BASE_PATH}/traffic_active.sh
#!/bin/bash
MIN_SIZE=$net_min; MAX_SIZE=$net_max; TEST_URL="http://http.us.debian.org/debian/ls-lR.gz"; TEMP_FILE="/tmp/vps_traffic_test.tmp"
TARGET_SIZE=\$(( RANDOM % (MAX_SIZE - MIN_SIZE + 1) + MIN_SIZE ))
echo "[\$(date)] [网络] 启动: 目标下载 \${TARGET_SIZE}MB" >> $LOG_FILE 2>&1
curl -L -s -o "\$TEMP_FILE" --max-filesize "\$((TARGET_SIZE * 1024 * 1024))" "\$TEST_URL"
rm -f "\$TEMP_FILE"
echo "[\$(date)] [网络] 任务完成。" >> $LOG_FILE 2>&1
EOF
    chmod +x ${BASE_PATH}/traffic_active.sh
    NET_READY=true
fi

# 3. 定时任务部署
echo -e "\n${GREEN}[3/3] 自动创建定时任务${NC}"

# 移除旧任务防止重复
crontab -l | grep -vE "cpu_active.sh|mem_active.sh|traffic_active.sh" | crontab -

if [ "$CPU_READY" = true ]; then
    (crontab -l ; echo "*/$cpu_cron * * * * /bin/bash ${BASE_PATH}/cpu_active.sh") | crontab -
    echo "CPU 模块定时任务已创建 (每 $cpu_cron 分钟)"
fi

if [ "$MEM_READY" = true ]; then
    (crontab -l ; echo "*/$mem_cron * * * * /bin/bash ${BASE_PATH}/mem_active.sh") | crontab -
    echo "内存模块定时任务已创建 (每 $mem_cron 分钟)"
fi

if [ "$NET_READY" = true ]; then
    (crontab -l ; echo "*/$net_cron * * * * /bin/bash ${BASE_PATH}/traffic_active.sh") | crontab -
    echo "网络模块定时任务已创建 (每 $net_cron 分钟)"
fi

echo -e "\n${GREEN}部署完成！所有日志将记录在: $LOG_FILE${NC}"