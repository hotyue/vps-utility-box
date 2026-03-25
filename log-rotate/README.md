# 日志管理模块 (Log Rotate)

本模块专为管理 `/var/log/vps_maintenance.log` 运行日志而设计。通过系统自带的 `logrotate` 工具，实现日志的每日自动轮转、压缩及过期清理，防止长时间运行维护脚本产生的日志占满 VPS 磁盘空间。

## 🛠 部署指令

在目标 VPS 上执行以下命令，即可完成配置文件的下载与生效：

```bash
# 下载配置文件
curl -sSO [https://raw.githubusercontent.com/hotyue/vps-utility-box/main/log-rotate/vps_maintenance](https://raw.githubusercontent.com/hotyue/vps-utility-box/main/log-rotate/vps_maintenance)

# 移动到系统配置目录并设置权限
sudo mv vps_maintenance /etc/logrotate.d/vps_maintenance
sudo chown root:root /etc/logrotate.d/vps_maintenance
sudo chmod 644 /etc/logrotate.d/vps_maintenance
```

## ⚙️ 配置说明
该配置文件 (vps_maintenance) 的具体规则如下：

| 配置项 | 功能描述 |
| ---- | ---- |
| daily | 每天自动执行一次轮转检查。 |
| drotate 7 | 仅保留最近 7 份 历史日志，过期的日志会被自动物理删除。 |
| dcopytruncate | 先复制再清空。在备份当前日志的同时清空原文件，确保正在写入日志的脚本不会因文件被移除而中断记录。 |
| dcompress | 对旧日志进行 Gzip 压缩，极大地节省存储空间。 |
| dmissingok | 如果日志文件不存在，则忽略错误，不产生系统报警。 |
| dnotifempty | 如果日志文件为空（字节为 0），则不执行轮转操作。 |


## 🔍 验证与维护
配置完成后，你可以通过以下命令手动测试轮转效果：
```bash
# 强制执行一次轮转测试
sudo logrotate -f /etc/logrotate.d/vps_maintenance

# 查看日志目录，确认是否生成了 .gz 压缩包
ls -lh /var/log/vps_maintenance*
```