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

# 配置变量
CHECK_INTERVAL=180  # 检查间隔（秒）
INTERVAL_MINUTES=$((CHECK_INTERVAL / 60))  # 转换为分钟显示

# 主循环
echo "开始监控本机IP地址变动，每${INTERVAL_MINUTES}分钟检查一次..."
echo "时间: $(date)"

# 初始化变量来存储上一次的IP
previous_ip=""
first_check=true

while true; do
    current_time=$(date '+%Y-%m-%d %H:%M:%S')
    current_ip=$(get_ip)
    
    if [ $? -eq 0 ]; then
        # 检查IP是否有变动
        if [ "$first_check" = true ]; then
            echo "[$current_time] 🟢 初始IP地址: $current_ip"
            previous_ip="$current_ip"
            first_check=false
        elif [ "$current_ip" != "$previous_ip" ]; then
            echo "=================================================================================="
            echo "=================================================================================="
            echo "[$current_time] 🔄 IP地址发生变化!"
            echo "           旧IP: $previous_ip"
            echo "           新IP: $current_ip"
            echo "=================================================================================="
            echo "=================================================================================="
            previous_ip="$current_ip"
        else
            echo "[$current_time] ✅ IP地址无变化: $current_ip"
        fi
    else
        echo "[$current_time] ❌ 获取IP失败: $current_ip"
    fi

    # 单位: 秒
    sleep $CHECK_INTERVAL
done