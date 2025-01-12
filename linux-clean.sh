#!/bin/bash

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

# 清理包管理器缓存
clean_package_cache() {
    echo -e "\n\033[1;34m[1/7] 清理包管理器缓存...\033[0m"
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
}

# 清理日志文件
clean_logs() {
    echo -e "\n\033[1;34m[2/7] 清理系统日志...\033[0m"
    
    # 清理旧日志
    find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;
    find /var/log -type f -name "*.gz" -delete
    find /var/log -type f -name "*.old" -delete
    
    # 清理 journal 日志
    if [ -d /var/log/journal ]; then
        journalctl --vacuum-time=3d
    fi
    
    # 清理其他日志文件
    truncate -s 0 /var/log/syslog 2>/dev/null
    truncate -s 0 /var/log/messages 2>/dev/null
    truncate -s 0 /var/log/kern.log 2>/dev/null
    truncate -s 0 /var/log/auth.log 2>/dev/null
}

# 清理临时文件
clean_temp() {
    echo -e "\n\033[1;34m[3/7] 清理临时文件...\033[0m"
    
    # 清理 /tmp 目录
    find /tmp -type f -atime +10 -delete 2>/dev/null
    
    # 清理 /var/tmp 目录
    find /var/tmp -type f -atime +10 -delete 2>/dev/null
    
    # 清理缩略图缓存
    find /home -type f -name "*.thumbnail" -delete 2>/dev/null
    find /home -type f -name "Thumbs.db" -delete 2>/dev/null
}

# 清理用户缓存
clean_user_cache() {
    echo -e "\n\033[1;34m[4/7] 清理用户缓存...\033[0m"
    
    # 获取所有用户的主目录
    cat /etc/passwd | grep -v "nologin\|false" | cut -d: -f6 | while read user_home; do
        if [ -d "$user_home" ]; then
            # 清理浏览器缓存
            find "$user_home/.cache/google-chrome" -type f -delete 2>/dev/null
            find "$user_home/.cache/mozilla" -type f -delete 2>/dev/null
            find "$user_home/.cache/chromium" -type f -delete 2>/dev/null
            
            # 清理缩略图缓存
            find "$user_home/.cache/thumbnails" -type f -delete 2>/dev/null
            
            # 清理其他缓存
            find "$user_home/.cache" -type f -atime +30 -delete 2>/dev/null
        fi
    done
}

# 清理Docker缓存
clean_docker() {
    echo -e "\n\033[1;34m[5/7] 清理Docker缓存...\033[0m"
    
    if command -v docker >/dev/null 2>&1; then
        # 删除未使用的镜像
        docker image prune -af 2>/dev/null
        
        # 删除未使用的数据卷
        docker volume prune -f 2>/dev/null
        
        # 删除未使用的网络
        docker network prune -f 2>/dev/null
        
        # 清理构建缓存
        docker builder prune -af 2>/dev/null
    fi
}

# 清理系统垃圾
clean_system() {
    echo -e "\n\033[1;34m[6/7] 清理系统垃圾...\033[0m"
    
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
}

# 优化系统
optimize_system() {
    echo -e "\n\033[1;34m[7/7] 优化系统...\033[0m"
    
    # 清理内存缓存
    sync; echo 3 > /proc/sys/vm/drop_caches
    
    # 清理交换空间
    swapoff -a && swapon -a 2>/dev/null
    
    # 更新 updatedb
    updatedb 2>/dev/null
}

# 显示清理结果
show_results() {
    echo -e "\n\033[1;34m====================================\033[0m"
    echo -e "\033[1;32m清理完成！系统状态：\033[0m"
    echo -e "\033[1;34m====================================\033[0m"
    
    # 显示磁盘使用情况
    echo -e "\033[1;33m磁盘使用情况：\033[0m"
    df -h /
    
    # 显示内存使用情况
    echo -e "\n\033[1;33m内存使用情况：\033[0m"
    free -h
    
    echo -e "\n\033[1;32m系统清理完成！\033[0m"
}

# 主函数
main() {
    show_banner
    check_root
    get_system_info
    
    echo -e "\033[1;33m是否开始清理系统？[y/N]\033[0m"
    read -r response
    if [[ ! $response =~ ^[Yy]$ ]]; then
        echo "已取消清理"
        exit 0
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