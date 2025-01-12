#!/bin/bash

# 添加统计变量
TOTAL_CLEANED=0
PACKAGE_CACHE_CLEANED=0
LOGS_CLEANED=0
TEMP_CLEANED=0
USER_CACHE_CLEANED=0
DOCKER_CLEANED=0
SYSTEM_CLEANED=0

# 检查是否有自动执行参数
AUTO_CLEAN=0
if [ "$1" = "-y" ] || [ "$1" = "--yes" ]; then
    AUTO_CLEAN=1
fi

# 显示清理工具信息
show_banner() {
    echo -e "\033[1;34m====================================\033[0m"
    echo -e "\033[1;33m      Linux系统垃圾清理工具\033[0m"
    echo -e "\033[1;34m====================================\033[0m"
    echo -e "\033[1;32m支持: Ubuntu/Debian/CentOS/Fedora/Arch等\033[0m"
    echo -e "\033[1;34m====================================\033[0m"
}

# 检查root权限
check_root() {
    if [ "$(id -u)" != "0" ]; then
        echo -e "\033[1;31m错误: 此脚本需要root权限才能运行\033[0m"
        exit 1
    fi
}

# 获取系统信息
get_system_info() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif [ -f /etc/redhat-release ]; then
        OS="rhel"
    else
        OS="unknown"
    fi
}

# 显示进度条
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    
    printf "\r["
    printf "%${completed}s" | tr ' ' '#'
    printf "%${remaining}s" | tr ' ' '-'
    printf "] %d%%" $percentage
}

# 获取目录大小(以字节为单位)
get_size() {
    du -sb "$1" 2>/dev/null | cut -f1
}

# 格式化大小显示
format_size() {
    local size=$1
    if [ $size -ge 1073741824 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $size/1073741824}") GB"
    elif [ $size -ge 1048576 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $size/1048576}") MB"
    elif [ $size -ge 1024 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $size/1024}") KB"
    else
        echo "$size B"
    fi
}

# 修改清理包管理器缓存函数
clean_package_cache() {
    echo -e "\n\033[1;34m[1/7] 清理包管理器缓存...\033[0m"
    local before_size=0
    
    # 累加各个缓存目录的大小
    local apt_size=$(get_size /var/cache/apt 2>/dev/null || echo 0)
    local yum_size=$(get_size /var/cache/yum 2>/dev/null || echo 0)
    local pacman_size=$(get_size /var/cache/pacman 2>/dev/null || echo 0)
    
    before_size=$((apt_size + yum_size + pacman_size))
    
    case $OS in
        ubuntu|debian|kali)
            apt-get clean -y
            apt-get autoclean -y
            apt-get autoremove -y
            ;;
        centos|rhel|fedora|rocky|alma)
            yum clean all
            dnf clean all 2>/dev/null
            yum autoremove -y
            ;;
        arch|manjaro)
            pacman -Sc --noconfirm
            pacman -Rns $(pacman -Qtdq) --noconfirm 2>/dev/null
            ;;
        *)
            echo "未知的包管理器"
            ;;
    esac
    
    local after_size=0
    apt_size=$(get_size /var/cache/apt 2>/dev/null || echo 0)
    yum_size=$(get_size /var/cache/yum 2>/dev/null || echo 0)
    pacman_size=$(get_size /var/cache/pacman 2>/dev/null || echo 0)
    
    after_size=$((apt_size + yum_size + pacman_size))
    PACKAGE_CACHE_CLEANED=$((before_size - after_size))
    TOTAL_CLEANED=$((TOTAL_CLEANED + PACKAGE_CACHE_CLEANED))
}

# 修改清理日志函数
clean_logs() {
    echo -e "\n\033[1;34m[2/7] 清理系统日志...\033[0m"
    local before_size=$(get_size /var/log)
    
    find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;
    find /var/log -type f -name "*.gz" -delete
    find /var/log -type f -name "*.old" -delete
    
    if [ -d /var/log/journal ]; then
        journalctl --vacuum-time=3d
    fi
    
    truncate -s 0 /var/log/syslog 2>/dev/null
    truncate -s 0 /var/log/messages 2>/dev/null
    truncate -s 0 /var/log/kern.log 2>/dev/null
    truncate -s 0 /var/log/auth.log 2>/dev/null
    
    local after_size=$(get_size /var/log)
    LOGS_CLEANED=$((before_size - after_size))
    TOTAL_CLEANED=$((TOTAL_CLEANED + LOGS_CLEANED))
}

# 修改清理临时文件函数
clean_temp() {
    echo -e "\n\033[1;34m[3/7] 清理临时文件...\033[0m"
    local before_size=$(get_size /tmp)
    before_size=$((before_size + $(get_size /var/tmp)))
    
    find /tmp -type f -atime +10 -delete 2>/dev/null
    find /var/tmp -type f -atime +10 -delete 2>/dev/null
    find /home -type f -name "*.thumbnail" -delete 2>/dev/null
    find /home -type f -name "Thumbs.db" -delete 2>/dev/null
    
    local after_size=$(get_size /tmp)
    after_size=$((after_size + $(get_size /var/tmp)))
    TEMP_CLEANED=$((before_size - after_size))
    TOTAL_CLEANED=$((TOTAL_CLEANED + TEMP_CLEANED))
}

# 修改清理用户缓存函数
clean_user_cache() {
    echo -e "\n\033[1;34m[4/7] 清理用户缓存...\033[0m"
    local total_before_size=0
    local total_after_size=0
    
    cat /etc/passwd | grep -v "nologin\|false" | cut -d: -f6 | while read user_home; do
        if [ -d "$user_home" ]; then
            local before_size=$(get_size "$user_home/.cache" 2>/dev/null)
            total_before_size=$((total_before_size + before_size))
            
            find "$user_home/.cache/google-chrome" -type f -delete 2>/dev/null
            find "$user_home/.cache/mozilla" -type f -delete 2>/dev/null
            find "$user_home/.cache/chromium" -type f -delete 2>/dev/null
            find "$user_home/.cache/thumbnails" -type f -delete 2>/dev/null
            find "$user_home/.cache" -type f -atime +30 -delete 2>/dev/null
            
            local after_size=$(get_size "$user_home/.cache" 2>/dev/null)
            total_after_size=$((total_after_size + after_size))
        fi
    done
    
    USER_CACHE_CLEANED=$((total_before_size - total_after_size))
    TOTAL_CLEANED=$((TOTAL_CLEANED + USER_CACHE_CLEANED))
}

# 修改清理Docker缓存函数
clean_docker() {
    echo -e "\n\033[1;34m[5/7] 清理Docker缓存...\033[0m"
    if command -v docker >/dev/null 2>&1; then
        local before_size=$(docker system df -v 2>/dev/null | grep "Total Space" | awk '{print $3}' | sed 's/[A-Za-z]//g')
        before_size=${before_size:-0}
        before_size=$(echo "$before_size * 1024 * 1024 * 1024" | bc)
        
        docker image prune -af 2>/dev/null
        docker volume prune -f 2>/dev/null
        docker network prune -f 2>/dev/null
        docker builder prune -af 2>/dev/null
        
        local after_size=$(docker system df -v 2>/dev/null | grep "Total Space" | awk '{print $3}' | sed 's/[A-Za-z]//g')
        after_size=${after_size:-0}
        after_size=$(echo "$after_size * 1024 * 1024 * 1024" | bc)
        
        DOCKER_CLEANED=$((before_size - after_size))
        TOTAL_CLEANED=$((TOTAL_CLEANED + DOCKER_CLEANED))
    fi
}

# 修改清理系统垃圾函数
clean_system() {
    echo -e "\n\033[1;34m[6/7] 清理系统垃圾...\033[0m"
    local before_size=0
    
    # 清理旧的内核
    if [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
        dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs apt-get -y purge 2>/dev/null
    fi
    
    # 清理 crash 报告
    rm -rf /var/crash/*
    
    # 清理备份文件
    find / -type f -name "*.bak" -delete 2>/dev/null
    find / -type f -name "*~" -delete 2>/dev/null
    
    # 清理 core dumps
    find / -type f -name "core" -delete 2>/dev/null
    
    # 计算清理的大小
    local after_size=0
    SYSTEM_CLEANED=$((before_size - after_size))
    TOTAL_CLEANED=$((TOTAL_CLEANED + SYSTEM_CLEANED))
}

# 优化系统
optimize_system() {
    echo -e "\n\033[1;34m[7/7] 优化系统...\033[0m"
    
    # 清理内存缓存
    sync
    echo 3 > /proc/sys/vm/drop_caches
    
    # 清理交换空间
    if [ -n "$(swapon --show)" ]; then
        swapoff -a && swapon -a 2>/dev/null
    fi
    
    # 更新 updatedb
    if command -v updatedb >/dev/null 2>&1; then
        updatedb 2>/dev/null
    fi
}

# 修改显示清理结果函数
show_results() {
    echo -e "\n\033[1;34m====================================\033[0m"
    echo -e "\033[1;32m清理完成！清理详情：\033[0m"
    echo -e "\033[1;34m====================================\033[0m"
    
    echo -e "\033[1;33m包管理器缓存：\033[0m$(format_size $PACKAGE_CACHE_CLEANED)"
    echo -e "\033[1;33m系统日志：\033[0m$(format_size $LOGS_CLEANED)"
    echo -e "\033[1;33m临时文件：\033[0m$(format_size $TEMP_CLEANED)"
    echo -e "\033[1;33m用户缓存：\033[0m$(format_size $USER_CACHE_CLEANED)"
    echo -e "\033[1;33mDocker缓存：\033[0m$(format_size $DOCKER_CLEANED)"
    echo -e "\033[1;33m系统垃圾：\033[0m$(format_size $SYSTEM_CLEANED)"
    echo -e "\033[1;32m总计清理：\033[0m$(format_size $TOTAL_CLEANED)"
    
    echo -e "\n\033[1;33m当前系统状态：\033[0m"
    echo -e "\033[1;33m磁盘使用情况：\033[0m"
    df -h /
    echo -e "\n\033[1;33m内存使用情况：\033[0m"
    free -h
    
    echo -e "\n\033[1;32m系统清理完成！\033[0m"
}

# 主函数
main() {
    show_banner
    check_root
    get_system_info
    
    # 如果不是自动模式,则询问用户
    if [ $AUTO_CLEAN -eq 0 ]; then
        echo -e "\033[1;33m是否开始清理系统？[y/N]\033[0m"
        read -r response
        if [[ ! $response =~ ^[Yy]$ ]]; then
            echo "已取消清理"
            exit 0
        fi
    fi
    
    # 开始清理
    clean_package_cache
    clean_logs
    clean_temp
    clean_user_cache
    clean_docker
    clean_system
    optimize_system
    
    # 显示结果
    show_results
}

# 执行主函数
main 