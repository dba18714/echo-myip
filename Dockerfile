# 使用轻量级的Alpine Linux作为基础镜像
FROM alpine:latest

# 设置维护者信息
LABEL maintainer="echo-myip-app"
LABEL description="A simple Docker container that prints the machine's IP address every 10 minutes"

# 安装必要的工具
# curl: 用于HTTP请求获取IP地址
# bash: 用于运行shell脚本
# tzdata: 用于时区设置
RUN apk add --no-cache \
    curl \
    bash \
    tzdata

# 设置时区为中国时区（可选）
ENV TZ=Asia/Shanghai

# 创建应用目录
WORKDIR /app

# 复制shell脚本到容器
COPY echo-ip.sh /app/echo-ip.sh

# 给脚本添加执行权限
RUN chmod +x /app/echo-ip.sh

# 创建非root用户以提高安全性
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# 切换到非root用户
USER appuser

# 设置容器启动时执行的命令
CMD ["/app/echo-ip.sh"]

# 健康检查（可选）
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://ipinfo.io/ip || exit 1