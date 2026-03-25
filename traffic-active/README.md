# 流量活跃模块 (Traffic Active)

本模块用于维持 VPS 的网络 IO 活跃度。脚本通过定期从官方镜像源下载随机大小的数据包，并在任务完成后立即清理，确保网络带宽有持续活动且不占用物理磁盘空间，防止因网络长期闲置被服务商判定为资源浪费。

## 🛠 部署指令

在目标 VPS 上执行以下命令，下载脚本并添加定时任务（建议每 10 分钟执行一次）：

```bash
# 下载脚本并赋予权限
curl -sSO [https://raw.githubusercontent.com/hotyue/vps-utility-box/main/traffic-active/traffic_active.sh](https://raw.githubusercontent.com/hotyue/vps-utility-box/main/traffic-active/traffic_active.sh) && chmod +x traffic_active.sh

# 添加到 Crontab 定时任务 (每10分钟运行一次)
(crontab -l ; echo "*/10 * * * * /bin/bash $(pwd)/traffic_active.sh") | crontab -
```

## ⚙️ 运行逻辑
脚本执行时将遵循以下规则进行流量模拟：

- 下载范围: 每次任务随机下载 20MB ~ 50MB 的数据量。

- 自动清理: 采用 /tmp/vps_traffic_test.tmp 作为临时缓存，下载完成后立即执行 rm 删除，实现 0 磁盘占用。

- 可靠流量源: 采用 Debian 官方镜像站的大文件作为下载源，模拟合法的系统更新/维护流量。

- 日志记录: 任务的启动时间、随机目标下载量及完成状态均同步至 /var/log/vps_maintenance.log。

## 🔍 日志核对与流量预估
可以通过以下方式监控网络活跃情况：
```bash
# 1. 实时查看网络活跃日志
tail -f /var/log/vps_maintenance.log | grep "[网络]"

# 2. 统计历史执行记录
grep "[网络] 任务完成" /var/log/vps_maintenance.log
```
流量消耗参考：
按每 10 分钟运行一次计算，每日约产生 4.3GB - 7.2GB 下行流量，月度累计流量约 130GB - 210GB。请确保您的 VPS 流量配额充足。