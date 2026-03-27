# 杂货铺 (vps-utility-box) 🏪

![License](https://img.shields.io/github/license/hotyue/vps-utility-box)
![Release](https://img.shields.io/github/v/release/hotyue/vps-utility-box)
![Last Commit](https://img.shields.io/github/last-commit/hotyue/vps-utility-box)
![Repo Size](https://img.shields.io/github/repo-size/hotyue/vps-utility-box)
![Installer](https://img.shields.io/badge/installer-bash-blue)
![Installer Mode](https://img.shields.io/badge/installer-interactive-brightgreen)

这是一个模块化、轻量级的 VPS 自动化维护工具箱。主要通过按需模拟 CPU 计算负载、内存占用与网络 IO 活跃度，防止 VPS 因长期闲置而被云服务商（如 Oracle Cloud 等）判定为资源浪费并回收实例。

## 🚀 一键运行 (部署 / 无痕卸载)

在您的 VPS (推荐 Debian/Ubuntu 环境) 上直接运行以下交互式指令：

```bash
curl -sSO https://raw.githubusercontent.com/hotyue/vps-utility-box/main/deploy.sh && bash deploy.sh
```

## ✨ v2.1.0 核心特性

- 交互式菜单: 自由选择开启 CPU、内存或网络模块，支持多选组合。

- 全自定义参数: 部署过程中可实时设定负载区间（如 CPU 15%-50%）、运行时长及 Cron 执行频率。

- 无痕清理机制: 菜单内置“一键卸载”功能，自动清理守护任务、物理删除脚本并可选销毁历史日志。

- 动态防检测: 告别死板的满载运行，利用随机数生成业务级波动，安全且隐蔽。

## 📦 模块详情指引

如果您希望了解底层逻辑或手动独立部署某个模块，请点击下方链接查看各模块的详细参数说明：

- 1. **[CPU-Active](./cpu-active)**: 引入 `stress-ng` 模拟计算压力，负载与时长双维度随机化。
- 2. **[Mem-Active](./mem-active)**: 利用 `--vm-hang` 实现纯净的物理内存挂起，不产生高频读写，CPU 零负担。
- 3. **[Traffic-Active](./traffic-active)**: 模拟下行带宽占用，采用官方镜像源，下载后秒删，0 磁盘占用。
- 4. **[Log-Rotate](./log-rotate)**: 专为本工具箱设计的日志滚动策略，确保磁盘空间不被运行日志撑爆。

## ⚖️ 开源协议

本项目采用 MIT License 开源协议。您可以自由地使用、修改和分发本仓库中的代码。

## 📈 Stargazers over time

[![Stargazers over time](https://starchart.cc/hotyue/vps-utility-box.svg?variant=adaptive)](https://starchart.cc/hotyue/vps-utility-box)
