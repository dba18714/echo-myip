# Echo My IP

一个简单的Docker应用，每隔10分钟打印一次本机的公网IP地址。

## 功能特性

- 🕒 每10分钟自动检查并打印IP地址
- 🌐 支持多种IP获取服务，提高可靠性
- 🐳 使用轻量级Alpine Linux镜像
- 🔒 以非root用户运行，提高安全性
- ⏰ 支持时区设置（默认为Asia/Shanghai）
- 💚 包含健康检查机制

## 文件结构

```
echo-myip/
├── Dockerfile          # Docker镜像构建文件
├── echo-ip.sh         # IP获取脚本
└── README.md          # 项目说明文档
```

## 快速开始

### 1. 构建Docker镜像

```bash
docker build -t echo-myip .
```

### 2. 运行容器

```bash
# 前台运行（可以看到输出）
docker run --rm echo-myip

# 后台运行
docker run -d --name my-ip-monitor echo-myip

# 查看后台运行的日志
docker logs -f my-ip-monitor
```

### 3. 自定义时区

如果需要使用其他时区，可以在运行时设置环境变量：

```bash
docker run --rm -e TZ=America/New_York echo-myip
```

## 使用的IP获取服务

脚本会依次尝试以下服务来获取IP地址，提高获取成功率：

1. [ipinfo.io](https://ipinfo.io/ip)
2. [httpbin.org](https://httpbin.org/ip)
3. [ifconfig.me](https://ifconfig.me)
4. [icanhazip.com](https://icanhazip.com)

## 输出示例

```
开始监控本机IP地址，每10分钟检查一次...
时间: Mon Oct  7 14:30:00 CST 2025
[2025-10-07 14:30:00] 本机公网IP: 203.0.113.45
[2025-10-07 14:40:00] 本机公网IP: 203.0.113.45
[2025-10-07 14:50:00] 本机公网IP: 203.0.113.45
```

## 停止容器

```bash
# 停止并删除容器
docker stop my-ip-monitor
docker rm my-ip-monitor

# 或者直接强制删除运行中的容器
docker rm -f my-ip-monitor
```

## 自定义间隔时间

如果想修改检查间隔时间，可以编辑 `echo-ip.sh` 文件中的 `sleep 600` 行：

- `sleep 300` = 5分钟
- `sleep 600` = 10分钟（默认）
- `sleep 1800` = 30分钟
- `sleep 3600` = 1小时

修改后重新构建镜像即可。

## 故障排除

### 无法获取IP地址

如果出现"无法获取IP地址"的错误，可能是由于：

1. 网络连接问题
2. 防火墙阻止外网访问
3. 所有IP服务都不可用

可以手动测试网络连接：

```bash
# 进入容器
docker exec -it my-ip-monitor sh

# 手动测试
curl ipinfo.io/ip
```

### 容器无法启动

检查Docker镜像是否构建成功：

```bash
docker images | grep echo-myip
```

查看详细错误信息：

```bash
docker logs my-ip-monitor
```

## 许可证

MIT License