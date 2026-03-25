# CPU 动态负载模块 (CPU Active)

用于模拟 VPS 的计算活跃度。通过在后台运行随机化的负载和持续时间，防止 VPS 因长期处于低负载闲置状态（如 CPU 利用率长期低于 10%）而被云服务商回收实例。

## 🛠 部署指令

在目标 VPS 上执行以下命令，下载脚本并添加定时任务（建议每 10 分钟执行一次）：

```bash
# 下载脚本并赋予权限
curl -sSO [https://raw.githubusercontent.com/hotyue/vps-utility-box/main/cpu-active/cpu_active.sh](https://raw.githubusercontent.com/hotyue/vps-utility-box/main/cpu-active/cpu_active.sh) && chmod +x cpu_active.sh

# 添加到 Crontab 定时任务 (每10分钟运行一次)
(crontab -l ; echo "*/10 * * * * /bin/bash $(pwd)/cpu_active.sh") | crontab -
```

## ⚙️ 运行参数
脚本运行时会根据以下区间随机生成任务目标，模拟真实的业务波动：

- 依赖工具: stress-ng (脚本检测到缺失时会自动尝试通过 apt 安装)。

- 动态负载范围: 15% ~ 50% CPU 占用率。

- 动态持续时长: 100秒 ~ 150秒 随机持续时间。

- 日志输出: 所有的启动与完成记录均追加至 /var/log/vps_maintenance.log。

##🔍 监控观察
你可以通过以下方式验证脚本的运行状态：
```bash
# 1. 观察 stress-ng 进程的实时 CPU 占比
top

# 2. 实时查看维护日志输出
tail -f /var/log/vps_maintenance.log

# 3. 过滤查看 CPU 模块的历史记录
grep "[CPU]" /var/log/vps_maintenance.log
```