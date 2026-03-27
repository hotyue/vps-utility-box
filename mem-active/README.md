# 内存动态占用模块 (Memory Active)

用于模拟 VPS 的内存使用活跃度。通过分配指定范围的随机内存并在规定时间内保持，防止 VPS 因内存长期处于极低占用状态而被回收。

## 🛠 部署指令

在目标 VPS 上执行以下命令：

```bash
# 下载脚本并赋予权限
curl -sSO [https://raw.githubusercontent.com/hotyue/vps-utility-box/main/mem-active/mem_active.sh](https://raw.githubusercontent.com/hotyue/vps-utility-box/main/mem-active/mem_active.sh) && chmod +x mem_active.sh

# 添加到 Crontab 定时任务 (每10分钟运行一次)
(crontab -l ; echo "*/10 * * * * /bin/bash $(pwd)/mem_active.sh") | crontab -
```

⚙️ 运行参数
- 依赖工具: stress-ng (脚本会自动尝试安装)。

- 动态占用范围: 100MB ~ 300MB 随机分配。

- 动态持续时长: 100秒 ~ 150秒 随机持续。

- 内存回收: 任务结束后，stress-ng 进程会自动退出并释放所有占用的内存。

🔍 监控观察
```bash
# 查看内存占用变化
free -m

# 实时查看维护日志
tail -f /var/log/vps_maintenance.log | grep "[内存]"
```


