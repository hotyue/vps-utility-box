# 杂货铺 (vps-utility-box) 🏪

这是一个模块化、轻量级的 VPS 自动化维护工具箱。主要通过模拟 CPU 计算负载与网络 IO 活跃度，防止 VPS 因长期闲置而被云服务商（如 Oracle Cloud、华为云等）判定为资源浪费并回收实例。

## 📦 货架清单 (快速部署)

所有脚本均经过 Debian 12 环境测试，支持通过 `curl` 一键拉取。

| 模块名称 | 功能描述 | 一键部署指令 (curl) |
| :--- | :--- | :--- |
| **CPU 活跃模拟** | 15%~50% 动态负载，100~150s 随机时长 | `curl -sSO https://raw.githubusercontent.com/hotyue/vps-utility-box/main/cpu-active/cpu_active.sh && chmod +x cpu_active.sh` |
| **内存活跃模拟** | 100~300MB 随机占用，100~150s 随机时长 | `curl -sSO https://raw.githubusercontent.com/hotyue/vps-utility-box/main/mem-active/mem_active.sh && chmod +x mem_active.sh` |
| **网络流量增强** | 随机下载 20~50MB 流量，自动清理缓存 | `curl -sSO https://raw.githubusercontent.com/hotyue/vps-utility-box/main/traffic-active/traffic_active.sh && chmod +x traffic_active.sh` |
| **日志自动轮转** | 每日轮转、压缩并保留 7 天维护日志 | `curl -sSO https://raw.githubusercontent.com/hotyue/vps-utility-box/main/log-rotate/vps_maintenance` |

---

## 🛠 模块详情

点击下方链接查看各模块的详细参数、流量预估及手动配置指南：

1.  **[CPU-Active](./cpu-active)**: 引入 `stress-ng` 模拟计算压力，负载与时长双维度随机化。
2.  **[Traffic-Active](./traffic-active)**: 模拟下行带宽占用，采用官方镜像源，确保流量合法稳定。
3.  **[Log-Rotate](./log-rotate)**: 专为本工具箱设计的日志滚动策略，确保磁盘空间不被 `/var/log/vps_maintenance.log` 撑爆。

---

## ⏰ 自动化建议 (Crontab)

建议通过 `crontab -e` 配置每 10 分钟执行一次，以达到最佳的活跃效果：

```cron
# 每10分钟执行一次 CPU 模拟
*/10 * * * * /bin/bash /path/to/cpu_active.sh

# 每10分钟执行一次 内存 模拟
*/10 * * * * /bin/bash /path/to/mem_active.sh

# 每10分钟执行一次流量模拟
*/10 * * * * /bin/bash /path/to/traffic_active.sh
```

## ⚖️ 开源协议
本项目采用 MIT License 开源协议。您可以自由地使用、修改和分发本仓库中的脚本。

项目地址: https://github.com/hotyue/vps-utility-box

