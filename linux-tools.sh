#!/bin/bash

# 显示脚本工具箱信息
show_toolbox_info() {
#!/bin/bash

# 显示美化的标题信息
echo -e "\033[1;34m  _      _                          _____              _      \033[0m"
echo -e "\033[1;34m | |    (_) _ __   _   _ __  __    |_   _|___    ___  | | ___ \033[0m"
echo -e "\033[1;34m | |    | || '_ \ | | | |\ \/ /_____ | | / _ \  / _ \ | |/ __|\033[0m"
echo -e "\033[1;34m | |___ | || | | || |_| | >  <|_____|| || (_) || (_) || |\__ \ \033[0m"
echo -e "\033[1;34m |_____||_||_| |_| \__,_|/_/\_\      |_| \___/  \___/ |_||___/ \033[0m"
echo -e "\033[1;34m==============================\033[0m"
echo -e "\033[1;33mLinux-Tools 脚本工具箱 v1.29.81 只为更简单的Linux使用！\033[0m"
echo -e "\033[1;34m适配Ubuntu/Debian/CentOS/Alpine/Kali/Arch/RedHat/Fedora/Alma/Rocky系统\033[0m"
echo -e "\033[1;32m- 输入v可快速启动此脚本 -\033[0m"
echo -e "\033[1;34m==============================\033[0m"
}

# 自动更新脚本到 /usr/local/bin/
if [ "$0" != "/usr/local/bin/linux-tools" ]; then
    curl -sS -O https://raw.githubusercontent.com/vbskycn/linux-tools/main/linux-tools.sh
    chmod +x linux-tools.sh
    if ! diff linux-tools.sh /usr/local/bin/linux-tools > /dev/null 2>&1; then
        echo "脚本有更新，覆盖到 /usr/local/bin/..."
        sudo cp linux-tools.sh /usr/local/bin/linux-tools
        sudo chmod +x /usr/local/bin/linux-tools
        rm linux-tools.sh
        
        # 更新别名设置
        ALIAS_LINE='alias v="/usr/local/bin/linux-tools"'
        if [ -f "$HOME/.bashrc" ]; then
            sed -i '/^alias v=/d' "$HOME/.bashrc"
            echo "$ALIAS_LINE" >> "$HOME/.bashrc"
            source "$HOME/.bashrc" 2>/dev/null || true
        fi
    else
        echo "脚本已是最新版本。"
        rm linux-tools.sh
    fi
    exec /usr/local/bin/linux-tools "$@"
    exit
fi

show_toolbox_info

# 检查并复制脚本到系统程序目录
install_script() {
    # 获取脚本的绝对路径
    SCRIPT_PATH=$(readlink -f "$0")
    
    # 安静地修复主机名解析问题
    if ! grep -q "127.0.0.1.*$(hostname)" /etc/hosts 2>/dev/null; then
        echo "127.0.0.1 $(hostname)" | sudo tee -a /etc/hosts >/dev/null 2>&1
    fi
    
    # 只有当脚本不在系统目录或内容不同时才复制
    if [ "$SCRIPT_PATH" != "/usr/local/bin/linux-tools" ]; then
        sudo cp "$SCRIPT_PATH" /usr/local/bin/linux-tools >/dev/null 2>&1
        sudo chmod +x /usr/local/bin/linux-tools >/dev/null 2>&1
    fi
    
    # 设置别名
    ALIAS_LINE='alias v="/usr/local/bin/linux-tools"'
    
    # 更新 .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        # 移除旧的别名（如果存在）
        sed -i '/^alias v=/d' "$HOME/.bashrc"
        # 添加新的别名
        echo "$ALIAS_LINE" >> "$HOME/.bashrc"
    else
        # 如果 .bashrc 不存在，创建它
        echo "$ALIAS_LINE" > "$HOME/.bashrc"
    fi
    
    # 确保 .bash_profile 加载 .bashrc
    if [ -f "$HOME/.bash_profile" ]; then
        if ! grep -q "source.*\.bashrc" "$HOME/.bash_profile"; then
            echo '[[ -f ~/.bashrc ]] && . ~/.bashrc' >> "$HOME/.bash_profile"
        fi
    else
        echo '[[ -f ~/.bashrc ]] && . ~/.bashrc' > "$HOME/.bash_profile"
    fi
    
    # 立即生效别名
    source "$HOME/.bashrc" 2>/dev/null || true
    
    #echo "脚本安装完成！"
}

# 运行安装脚本
install_script

# Detect the Linux distribution
. /etc/os-release

# Set package manager commands based on distribution
case "$ID" in
    ubuntu|debian|kali)
        PKG_UPDATE="sudo apt update -y && sudo apt upgrade -y"
        PKG_INSTALL="sudo apt install -y"
        PKG_REMOVE="sudo apt autoremove -y"
        ;;
    centos|redhat|fedora|alma|rocky)
        PKG_UPDATE="sudo yum update -y"
        PKG_INSTALL="sudo yum install -y"
        PKG_REMOVE="sudo yum autoremove -y"
        ;;
    arch)
        PKG_UPDATE="sudo pacman -Syu --noconfirm"
        PKG_INSTALL="sudo pacman -S --noconfirm"
        PKG_REMOVE="sudo pacman -Rns --noconfirm"
        ;;
    alpine)
        PKG_UPDATE="sudo apk update"
        PKG_INSTALL="sudo apk add"
        PKG_REMOVE="sudo apk del"
        ;;
    *)
        echo "Unsupported distribution: $ID"
        exit 1
        ;;
esac

# 显示主菜单
show_main_menu() {
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m请选择一个选项：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;36m1. 系统相关 (sys)\033[0m"
    echo -e "\033[1;36m2. 基础工具 (tool)\033[0m"
    echo -e "\033[1;36m3. 脚本大全 (script)\033[0m"
    echo -e "\033[1;36m4. 应用市场 (app)\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m9. 更新脚本\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;31m0. 退出\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号或代码: " main_choice

    case $main_choice in
        01|sys) show_system_menu ;;
        02|tool) show_basic_tools_menu ;;
        03|script) show_script_menu ;;
        04|app) show_app_market ;;
        00) curl -sS -O https://raw.githubusercontent.com/vbskycn/linux-tools/main/linux-tools.sh && \
            chmod +x linux-tools.sh && \
            sudo mv linux-tools.sh /usr/local/bin/linux-tools && \
            /usr/local/bin/linux-tools ;;
        0) exit 0 ;;
        *) echo "无效选项，请重试。"; show_main_menu ;;
    esac
}

# 显示基础工具菜单
show_basic_tools_menu() {
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m基础工具选项：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m1. 安装常用工具\033[0m"
    echo -e "\033[1;37m2. 安装 Docker\033[0m"
    echo -e "\033[1;37m3. 安装开发工具\033[0m"
    echo -e "\033[1;37m4. 安装网络工具\033[0m"
    echo -e "\033[1;37m5. 安装常用数据库\033[0m"
    echo -e "\033[1;37m6. 安装 Node.js 和 npm\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m0. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号或代码: " tools_choice

    # 如果输入的是纯数字，自动添加tool前缀
    if [[ $tools_choice =~ ^[0-9]+$ ]]; then
        if [ "$tools_choice" = "0" ]; then
            show_main_menu
            return
        fi
        # 将个位数转换为两位数格式
        if [ ${#tools_choice} -eq 1 ]; then
            tools_choice="0$tools_choice"
        fi
        tools_choice="tool$tools_choice"
    fi

    case $tools_choice in
        tool1) 
            echo "安装常用工具..."
            if ! $PKG_INSTALL curl wget git vim unzip build-essential net-tools htop traceroute tmux; then
                echo "安装失败，请检查权限或网络连接"
            else
                echo "安装完成"
            fi
            show_basic_tools_menu 
            ;;
        tool2) 
            echo "安装 Docker..."
            if ! $PKG_INSTALL docker.io docker-compose; then
                echo "Docker 安装失败"
            else
                sudo systemctl enable docker
                sudo systemctl start docker
                echo "Docker 安装完成"
            fi
            show_basic_tools_menu 
            ;;
        tool3) echo "安装开发工具..."; $PKG_INSTALL python3 python3-pip python3-venv openjdk-11-jdk gcc g++ make cmake; show_basic_tools_menu ;;
        tool4) echo "安装网络工具..."; $PKG_INSTALL sshpass telnet nmap iperf3 dnsutils net-tools iputils-ping; show_basic_tools_menu ;;
        tool5) echo "安装常用数据库..."; $PKG_INSTALL mysql-server postgresql redis-server mongodb; show_basic_tools_menu ;;
        tool6) echo "安装 Node.js 和 npm..."; curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -; $PKG_INSTALL nodejs; show_basic_tools_menu ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_basic_tools_menu ;;
    esac
}

# 系统相关菜单
show_system_menu() {
    clear
    echo "=============================="
    echo "系统相关选项："
    echo "=============================="
    echo "1. 更新系统"
    echo "2. 清理不再需要的软件包"
    echo "3. 更改系统名"
    echo "4. 设置快捷键"
    echo "5. 设置虚拟内存"
    echo "6. 设置SSH端口"
    echo "7. 开放所有端口"
    echo "8. 设置时区"
    echo "9. 优化DNS"
    echo "10. 高性能优化模式"
    echo "11. 均衡优化模式"
    echo "12. 网站优化模式"
    echo "13. 还原默认设置"
    echo "0. 返回主菜单"
    echo "=============================="
    read -p "输入选项编号或代码: " choice

    # 如果输入的是纯数字，自动添加sys前缀
    if [[ $choice =~ ^[0-9]+$ ]]; then
        if [ "$choice" = "0" ]; then
            show_main_menu
            return
        fi
        # 将个位数转换为两位数格式
        if [ ${#choice} -eq 1 ]; then
            choice="0$choice"
        fi
        choice="sys$choice"
    fi

    case $choice in
        sys1) update_system ;;
        sys2) clean_packages ;;
        sys3) change_hostname ;;
        sys4) set_shortcut ;;
        sys5) set_swap ;;
        sys6) set_ssh_port ;;
        sys7) open_ports ;;
        sys8) set_timezone ;;
        sys9) optimize_dns ;;
        sys10) optimize_high_performance ;;
        sys11) optimize_balanced ;;
        sys12) optimize_web_server ;;
        sys13) restore_defaults ;;
        00) show_main_menu ;;
        *)
            echo "无效选项，请重试。"
            show_system_menu
            ;;
    esac
}

# 更新系统
update_system() {
    echo "正在更新系统..."
    if [ -f /etc/debian_version ]; then
        if ! (apt update && apt upgrade -y); then
            echo "系统更新失败，请检查权限或网络连接"
        else
            echo "系统更新完成！"
        fi
    elif [ -f /etc/redhat-release ]; then
        if ! yum update -y; then
            echo "系统更新失败，请检查权限或网络连接"
        else
            echo "系统更新完成！"
        fi
    elif [ -f /etc/alpine-release ]; then
        apk update && apk upgrade
    elif [ -f /etc/arch-release ]; then
        pacman -Syu --noconfirm
    fi
    show_system_menu
}

# 清理不再需要的软件包
clean_packages() {
    echo "正在清理不再需要的软件包..."
    if [ -f /etc/debian_version ]; then
        apt autoremove -y && apt clean
    elif [ -f /etc/redhat-release ]; then
        yum autoremove -y && yum clean all
    elif [ -f /etc/alpine-release ]; then
        apk cache clean
    elif [ -f /etc/arch-release ]; then
        pacman -Sc --noconfirm
    fi
    echo "清理完成！"
    show_system_menu
}

# 更改系统名
change_hostname() {
    read -p "请输入新的主机名: " new_hostname
    hostnamectl set-hostname $new_hostname
    echo "系统名已更改为: $new_hostname"
    show_system_menu
}

# 设置快捷键
set_shortcut() {
    echo "正在设置快捷键..."
    
    # 定义要添加的别名命令
    ALIAS_CMD='alias v="/usr/local/bin/linux-tools"'
    
    # 添加到系统级配置
    if [ -d "/etc/profile.d" ]; then
        echo "$ALIAS_CMD" | sudo tee /etc/profile.d/linux-tools-alias.sh > /dev/null
        sudo chmod +x /etc/profile.d/linux-tools-alias.sh
        echo "已添加到系统级配置，所有用户都可以使用此快捷键"
    fi
    
    show_system_menu
}

# 设置虚拟内存
set_swap() {
    echo "正在设置虚拟内存..."
    read -p "请输入要设置的虚拟内存大小(GB): " swap_size
    
    # 检查输入是否为数字
    if ! [[ "$swap_size" =~ ^[0-9]+$ ]]; then
        echo "请输入有效的数字！"
        show_system_menu
        return
    fi
    
    # 创建swap文件
    sudo dd if=/dev/zero of=/swapfile bs=1G count=$swap_size
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    
    # 添加到 fstab
    if ! grep -q "/swapfile" /etc/fstab; then
        echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
    fi
    
    echo "虚拟内存设置完成！"
    show_system_menu
}

# 设置SSH端口
set_ssh_port() {
    read -p "请输入新的SSH端口号(1-65535): " new_port
    
    # 检查端口号是否有效
    if ! [[ "$new_port" =~ ^[0-9]+$ ]] || [ "$new_port" -lt 1 ] || [ "$new_port" -gt 65535 ]; then
        echo "无效的端口号！端口号必须在 1-65535 之间"
        show_system_menu
        return
    fi
    
    # 检查是否有 root 权限
    if [ "$(id -u)" != "0" ]; then
        echo "需要 root 权限来修改 SSH 配置"
        show_system_menu
        return
    fi
    
    if ! sed -i "s/#Port 22/Port $new_port/" /etc/ssh/sshd_config || \
       ! sed -i "s/Port [0-9]*/Port $new_port/" /etc/ssh/sshd_config; then
        echo "修改 SSH 配置失败"
        show_system_menu
        return
    fi
    
    if ! systemctl restart sshd; then
        echo "重启 SSH 服务失败"
    else
        echo "SSH端口已更改为: $new_port"
    fi
    show_system_menu
}

# 开放所有端口
open_ports() {
    if [ "$(id -u)" != "0" ]; then
        echo "需要 root 权限来配置防火墙"
        show_system_menu
        return
    }
    
    if [ -f /etc/debian_version ]; then
        if ! apt update || ! apt install -y ufw; then
            echo "安装 ufw 失败"
            show_system_menu
            return
        fi
        ufw allow all
        ufw enable
    elif [ -f /etc/redhat-release ]; then
        if ! systemctl start firewalld; then
            echo "启动 firewalld 失败"
            show_system_menu
            return
        fi
        firewall-cmd --zone=public --add-port=1-65535/tcp --permanent
        firewall-cmd --zone=public --add-port=1-65535/udp --permanent
        firewall-cmd --reload
    fi
    echo "所有端口已开放"
    show_system_menu
}

# 设置时区为上海
set_timezone() {
    echo "正在设置时区为上海..."
    if ! sudo timedatectl set-timezone Asia/Shanghai; then
        echo "设置时区失败"
    else
        echo "时区已设置为上海"
    fi
    show_system_menu
}

# 优化DNS
optimize_dns() {
    echo "正在优化DNS设置..."
    # 备份原始文件
    cp /etc/resolv.conf /etc/resolv.conf.bak
    
    # 设置新的DNS服务器
    cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF
    
    echo "DNS���化完成！"
    show_system_menu
}

# 高性能优化模式
optimize_high_performance() {
    # 系统参数优化
    cat > /etc/sysctl.conf << EOF
# 系统级别的能打开的文件描述符数量
fs.file-max = 1000000
# 单个进程能够打开的文件描述符数量
fs.nr_open = 1000000

# 内核 panic 时如何处理
kernel.panic = 10
kernel.panic_on_oops = 1
# 允许更多的PIDs
kernel.pid_max = 65535
# 内核所允许的最大共享内存段的大小
kernel.shmmax = 68719476736
# 在任何给定时刻，系统上可以使用的共享内存的总量
kernel.shmall = 4294967296
# 设置消息队列
kernel.msgmnb = 65536
kernel.msgmax = 65536

# 设置最大线程数
kernel.threads-max = 30000

# 网络相关参数
# 允许更多的网络连接
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 65535
# 调整络缓冲区大小
net.core.wmem_max = 16777216
net.core.rmem_max = 16777216
net.core.wmem_default = 262144
net.core.rmem_default = 262144

# TCP参数优化
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_tw_buckets = 65535
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_wmem = 4096 87380 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_fastopen = 3

# 虚拟内存参数
vm.swappiness = 10
vm.dirty_ratio = 60
vm.dirty_background_ratio = 30
vm.max_map_count = 262144
EOF

    # 应用系统参数
    sysctl -p

    # 设置系统限制
    cat > /etc/security/limits.conf << EOF
* soft nofile 1000000
* hard nofile 1000000
* soft nproc 65535
* hard nproc 65535
* soft memlock unlimited
* hard memlock unlimited
EOF

    echo "高性能优化模式配置完成！"
    show_kernel_optimize
}

# 均衡优化模式
optimize_balanced() {
    # 系统参数优化（均衡模式）
    cat > /etc/sysctl.conf << EOF
# 文件描述符限制
fs.file-max = 500000
fs.nr_open = 500000

# 内核参数
kernel.panic = 10
kernel.pid_max = 32768
kernel.threads-max = 15000

# 网络参数
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.core.wmem_max = 8388608
net.core.rmem_max = 8388608
net.core.wmem_default = 131072
net.core.rmem_default = 131072

# TCP参数
net.ipv4.tcp_max_syn_backlog = 32768
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_tw_buckets = 32768
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_mem = 47250000 457500000 463500000
net.ipv4.tcp_wmem = 4096 65536 8388608
net.ipv4.tcp_rmem = 4096 65536 8388608

# 虚拟内存参数
vm.swappiness = 30
vm.dirty_ratio = 40
vm.dirty_background_ratio = 20
vm.max_map_count = 131072
EOF

    sysctl -p

    # 设置系统限制
    cat > /etc/security/limits.conf << EOF
* soft nofile 500000
* hard nofile 500000
* soft nproc 32768
* hard nproc 32768
EOF

    echo "均衡优化模式配置完成！"
    show_kernel_optimize
}

# 网站优化模式
optimize_web_server() {
    # 系统参数优化（网站服务器模式）
    cat > /etc/sysctl.conf << EOF
# 文件描述符限制
fs.file-max = 2000000
fs.nr_open = 2000000

# 网络参数
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 65535
net.core.wmem_max = 16777216
net.core.rmem_max = 16777216

# TCP参数
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_tw_buckets = 65535
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_wmem = 4096 87380 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_fastopen = 3

# 虚拟内存参数
vm.swappiness = 10
vm.dirty_ratio = 60
vm.dirty_background_ratio = 30
EOF

    sysctl -p

    # 设置系统限制
    cat > /etc/security/limits.conf << EOF
* soft nofile 2000000
* hard nofile 2000000
* soft nproc 65535
* hard nproc 65535
EOF

    echo "网站服务器优化模式配置完成！"
    show_kernel_optimize
}

# 还原默认设置
restore_defaults() {
    # 还原 sysctl.conf
    cat > /etc/sysctl.conf << EOF
# 保持系统默认值
EOF

    sysctl -p

    # 还原 limits.conf
    cat > /etc/security/limits.conf << EOF
# /etc/security/limits.conf
#
#Each line describes a limit for a user in the form:
#
#<domain>        <type>  <item>  <value>
#
#Where:
#<domain> can be:
#        - a user name
#        - a group name, with @group syntax
#        - the wildcard *, for default entry
#        - the wildcard %, can be also used with %group syntax,
#                 for maxlogin limit
#        - NOTE: group and wildcard limits are not applied to root.
#          To apply a limit to the root user, <domain> must be
#          the literal username root.
#
#<type> can have the two values:
#        - "soft" for enforcing the soft limits
#        - "hard" for enforcing hard limits
#
#<item> can be one of the following:
#        - core - limits the core file size (KB)
#        - data - max data size (KB)
#        - fsize - maximum filesize (KB)
#        - memlock - max locked-in-memory address space (KB)
#        - nofile - max number of open files
#        - rss - max resident set size (KB)
#        - stack - max stack size (KB)
#        - cpu - max CPU time (MIN)
#        - nproc - max number of processes
#        - as - address space limit (KB)
#        - maxlogins - max number of logins for this user
#        - maxsyslogins - max number of logins on the system
#        - priority - the priority to run user process with
#        - locks - max number of file locks the user can hold
#        - sigpending - max number of pending signals
#        - msgqueue - max memory used by POSIX message queues (bytes)
#        - nice - max nice priority allowed to raise to values: [-20, 19]
#        - rtprio - max realtime priority
#        - chroot - change root to directory (Debian-specific)
#
#<domain>      <type>  <item>         <value>
#

#*               soft    core            0
#root            hard    core            100000
#*               hard    rss             10000
#@student        hard    nproc           20
#@faculty        soft    nproc           20
#@faculty        hard    nproc           50
#ftp             hard    nproc           0
#ftp             -       chroot          /ftp
#@student        -       maxlogins       4

# End of file
EOF

    echo "系统设置已还原为默认值！"
    show_kernel_optimize
}

# 内核优化菜单
show_kernel_optimize() {
    clear
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33mLinux系统内核参数优化\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m1. 高性能优化模式：     最大化系统性能，优化文件描述符、虚拟内存、网络设置、缓存管理和CPU设置。\033[0m"
    echo -e "\033[1;37m2. 均衡优化模式：       在性能与资源消耗之间取得平衡，适合日常使用。\033[0m"
    echo -e "\033[1;37m3. 网站优化模式：       针对网站服务器进行优化，提高并发连接处理能力、响应速度和整体性能。\033[0m"
    echo -e "\033[1;37m4. 直播优化模式：       针对直播推流的特殊需求进行优化，减少延迟，提高传输性能。\033[0m"
    echo -e "\033[1;37m5. 游戏服优化模式：     针对游戏服务器进行优化，提高并发处理能力和响应速度。\033[0m"
    echo -e "\033[1;37m6. 还原默认设置：       将系统设置还原为默认配置。\033[0m"
    echo -e "\033[1;34m--------------------\033[0m"
    echo -e "\033[1;32m0. 返回上一级\033[0m"
    echo -e "\033[1;34m--------------------\033[0m"
    read -e -p "请输入你的选择: " kernel_choice

    case $kernel_choice in
        01)
            optimize_high_performance
            ;;
        02)
            optimize_balanced
            ;;
        03)
            optimize_web_server
            ;;
        04)
            optimize_high_performance
            ;;
        05)
            optimize_high_performance
            ;;
        06)
            restore_defaults
            ;;
        00)
            return
            ;;
        *)
            echo "无效选项，请重试。"
            ;;
    esac

    read -n 1 -p "按任意键继续..."
}

# 脚本大全菜单
show_script_menu() {
    clear
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m脚本大全：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m01. 安装 kejilion 脚本\033[0m"
    echo -e "\033[1;37m02. 安装 勇哥的SB 脚本\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m00. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号或代码: " choice

    # 如输入的是纯数字，自动添加script前缀
    if [[ $choice =~ ^[0-9]+$ ]]; then
        if [ "$choice" = "00" ]; then
            show_main_menu
            return
        fi
        # 将个位数转换为两位数格式
        if [ ${#choice} -eq 1 ]; then
            choice="0$choice"
        fi
        choice="script$choice"
    fi

    case $choice in
        script01) echo "安装 kejilion 脚本..."; curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh; show_script_menu ;;
        script02) echo "安装 勇哥的SB 脚本..."; bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh); show_script_menu ;;
        00) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_script_menu ;;
    esac
}

# 应用市场菜单
show_app_market() {
    clear
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m应用市场：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m01. 宝塔面板官方版\033[0m"
    echo -e "\033[1;37m02. aaPanel宝塔国际版\033[0m"
    echo -e "\033[1;37m03. 1Panel新一代管理面板\033[0m"
    echo -e "\033[1;37m04. 安装宝塔开心版\033[0m"
    echo -e "\033[1;37m05. 还原到宝塔官方版\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m00. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -e -p "请输入选项编号或代码: " choice

    # 如果输入的是纯数字，自动添加app前缀
    if [[ $choice =~ ^[0-9]+$ ]]; then
        if [ "$choice" = "00" ]; then
            show_main_menu
            return
        fi
        # 将个位数转换为两位数格式
        if [ ${#choice} -eq 1 ]; then
            choice="0$choice"
        fi
        choice="app$choice"
    fi

    case $choice in
        app01)
            echo "安装宝塔面板官方版..."
            wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && echo y | bash install.sh ed8484bec
            show_app_market
            ;;
        app02)
            echo "安装aaPanel宝塔国际版..."
            wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && echo y | bash install.sh aapanel
            show_app_market
            ;;
        app03)
            echo "安装1Panel新一代管理面板..."
            curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
            show_app_market
            ;;
        app04)
            echo "安装宝塔开心版..."
            curl http://io.bt.sy/install/update6.sh|bash
            show_app_market
            ;;
        app05)
            echo "还原到宝塔官方版..."
            curl http://download.bt.cn/install/update6.sh|bash
            show_app_market
            ;;
        00)
            show_main_menu
            ;;
        *)
            echo "无效选项，请重试。"
            show_app_market
            ;;
    esac
}

# 开启root密码登入
enable_root_password() {
    echo "正在配置root密码登入..."
    
    # 修改 SSH 配置允许 root 登录
    sudo sed -i 's/#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo sed -i 's/#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    
    # 重启 SSH 服务
    sudo systemctl restart sshd
    
    # 提示用户修改root密码
    echo -e "\033[33m请设置root用户密码...\033[0m"
    sudo passwd root
    
    echo -e "\033[32mroot密码登入已开启！\033[0m"
    read -n 1 -s -r -p "按任意键继续..."
    echo
    show_system_menu
}

# 开启root密钥登入
enable_root_key() {
    echo "正在配置root密钥登入..."
    
    # 生成密钥对
    KEY_FILE="$HOME/id_rsa_root"
    ssh-keygen -t rsa -b 4096 -f "$KEY_FILE" -N "" -q
    
    # 确保root的.ssh目录存在
    sudo mkdir -p /root/.ssh
    sudo chmod 700 /root/.ssh
    
    # 添加公钥到authorized_keys
    sudo cp "$KEY_FILE.pub" /root/.ssh/authorized_keys
    sudo chmod 600 /root/.ssh/authorized_keys
    
    # 修改 SSH 配置
    sudo sed -i 's/#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    sudo sed -i 's/#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    
    # 重启 SSH 服务
    sudo systemctl restart sshd
    
    # 复制私钥到当前用户目录
    cp "$KEY_FILE" "$HOME/"
    chmod 600 "$HOME/id_rsa_root"
    
    echo -e "\033[32mroot密钥登入已配置完成！\033[0m"
    echo -e "\033[33m私钥文件已保存到$HOME/id_rsa_root\033[0m"
    echo -e "\033[33m请妥善保管私钥文件，建议下载后删除服务器上的私钥\033[0m"
    read -n 1 -s -r -p "按任意键继续..."
    echo
    show_system_menu
}

# 启动菜单
show_main_menu