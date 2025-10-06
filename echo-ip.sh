#!/bin/bash

# 获取本机IP地址的函数
get_ip() {
    # 尝试通过多种方式获取公网IP
    ip=""
    
    # 方法1: 使用ipinfo.io
    ip=$(curl -s ipinfo.io/ip 2>/dev/null)
    if [[ -n "$ip" && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "$ip"
        return 0
    fi
    
    # 方法2: 使用httpbin.org
    ip=$(curl -s httpbin.org/ip 2>/dev/null | grep -o '"origin":"[^"]*"' | cut -d'"' -f4 | cut -d',' -f1)
    if [[ -n "$ip" && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "$ip"
        return 0
    fi
    
    # 方法3: 使用ifconfig.me
    ip=$(curl -s ifconfig.me 2>/dev/null)
    if [[ -n "$ip" && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "$ip"
        return 0
    fi
    
    # 方法4: 使用icanhazip.com
    ip=$(curl -s icanhazip.com 2>/dev/null | tr -d '\n')
    if [[ -n "$ip" && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "$ip"
        return 0
    fi
    
    # 如果都失败了，返回错误信息
    echo "无法获取IP地址"
    return 1
}

# 主循环
echo "开始监控本机IP地址，每10分钟检查一次..."
echo "时间: $(date)"

while true; do
    current_time=$(date '+%Y-%m-%d %H:%M:%S')
    ip=$(get_ip)
    
    if [ $? -eq 0 ]; then
        echo "[$current_time] 本机公网IP: $ip"
    else
        echo "[$current_time] 获取IP失败: $ip"
    fi
    
    # 等待10分钟 (600秒)
    sleep 600
done