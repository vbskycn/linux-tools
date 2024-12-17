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
echo -e "\033[1;33mLinux-Tools 脚本工具箱 v1.29.3 只为更简单的Linux使用！\033[0m"
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
    
    # 复制脚本到系统目录
    echo "正在安装脚本到系统..."
    sudo cp "$SCRIPT_PATH" /usr/local/bin/linux-tools
    sudo chmod +x /usr/local/bin/linux-tools
    
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
    
    echo "脚本安装完成！"
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
    echo -e "\033[1;33m请选择一个选项：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;36m1. 系统相关\033[0m"
    echo -e "\033[1;36m2. 基础工具\033[0m"
    echo -e "\033[1;36m3. 脚本大全\033[0m"
    echo -e "\033[1;36m4. 应用市场\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m00. 更新脚本\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;31m0. 退出\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号: " main_choice

    case $main_choice in
        1) show_system_menu ;;
        2) show_basic_tools_menu ;;
        3) show_script_menu ;;
        4) show_app_market ;;
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
    read -p "输入选项编号: " tools_choice

    case $tools_choice in
        1) echo "安装常用工具..."; $PKG_INSTALL curl wget git vim unzip build-essential net-tools htop traceroute tmux; show_basic_tools_menu ;;
        2) echo "安装 Docker..."; $PKG_INSTALL docker.io docker-compose; sudo systemctl enable docker; sudo systemctl start docker; show_basic_tools_menu ;;
        3) echo "安装开发工具..."; $PKG_INSTALL python3 python3-pip python3-venv openjdk-11-jdk gcc g++ make cmake; show_basic_tools_menu ;;
        4) echo "安装网络工具..."; $PKG_INSTALL sshpass telnet nmap iperf3 dnsutils net-tools iputils-ping; show_basic_tools_menu ;;
        5) echo "安装常用数据库..."; $PKG_INSTALL mysql-server postgresql redis-server mongodb; show_basic_tools_menu ;;
        6) echo "安装 Node.js 和 npm..."; curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -; $PKG_INSTALL nodejs; show_basic_tools_menu ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_basic_tools_menu ;;
    esac
}

# 系统相关菜单
show_system_menu() {
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m系统相关选项：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m1. 更新系统\033[0m"
    echo -e "\033[1;37m2. 清理不再需要的软件包\033[0m"
    echo -e "\033[1;37m3. 更改系统名\033[0m"
    echo -e "\033[1;37m4. 设置快捷键 v\033[0m"
    echo -e "\033[1;37m5. 设置虚拟内存\033[0m"
    echo -e "\033[1;37m6. 设置SSH端口\033[0m"
    echo -e "\033[1;37m7. 开放所有端口\033[0m"
    echo -e "\033[1;37m8. 设置时区为上海\033[0m"
    echo -e "\033[1;37m9. 自动优化DNS地址\033[0m"
    echo -e "\033[1;37m10. 系统内核优化\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m0. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号: " system_choice

    case $system_choice in
        1) update_system ;;
        2) clean_packages ;;
        3) change_hostname ;;
        4) set_shortcut ;;
        5) set_swap ;;
        6) set_ssh_port ;;
        7) open_ports ;;
        8) set_timezone ;;
        9) optimize_dns ;;
        10) show_kernel_optimize ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_system_menu ;;
    esac
}

# 更新系统
update_system() {
    echo "正在更新系统..."
    if [ -f /etc/debian_version ]; then
        apt update && apt upgrade -y
    elif [ -f /etc/redhat-release ]; then
        yum update -y
    elif [ -f /etc/alpine-release ]; then
        apk update && apk upgrade
    elif [ -f /etc/arch-release ]; then
        pacman -Syu --noconfirm
    fi
    echo "系统更新完成！"
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
    
    # 首先确保脚本已经被正确安装到系统目录
    if [ ! -f "/usr/local/bin/linux-tools" ]; then
        sudo cp "$(readlink -f "$0")" /usr/local/bin/linux-tools
        sudo chmod +x /usr/local/bin/linux-tools
    fi
    
    # 设置用户级别的别名
    if [ -f "$HOME/.bashrc" ]; then
        # 移除旧的别名配置
        sed -i '/^alias.*v=.*linux-tools.*/d' "$HOME/.bashrc"
        # 添加新的别名
        echo "$ALIAS_CMD" >> "$HOME/.bashrc"
        echo "已在 $HOME/.bashrc 中设置快捷键"
    fi
    
    # 确保 .bash_profile 加载 .bashrc
    if [ -f "$HOME/.bash_profile" ]; then
        if ! grep -q "source.*\.bashrc" "$HOME/.bash_profile"; then
            echo '[[ -f ~/.bashrc ]] && . ~/.bashrc' >> "$HOME/.bash_profile"
        fi
        echo "已在 $HOME/.bash_profile 中设置快捷键"
    fi
    
    # 设置系统级别的别名（如果是root用户）
    if [ "$(id -u)" = "0" ]; then
        # 在 /etc/profile.d/ 创建一个专门的别名文件
        echo "$ALIAS_CMD" | sudo tee /etc/profile.d/linux-tools-alias.sh > /dev/null
        sudo chmod +x /etc/profile.d/linux-tools-alias.sh
        echo "已添加到系统级配置，所有用户都可以使用此快捷键"
    fi
    
    # 立即生效别名
    eval "$ALIAS_CMD"
    
    echo -e "\033[32m快捷键设置完成！\033[0m"
    echo "请执行以下命令使快捷键立即生效："
    echo -e "\033[33msource ~/.bashrc\033[0m"
    
    read -n 1 -s -r -p "按任意键继续..."
    echo
    show_system_menu
}

# 设置虚拟内存
set_swap() {
    echo "正在设置虚拟内存..."
    read -p "请输入要设置的虚拟内存大小（GB）: " swap_size
    
    # 检查是否已存在swap
    swapoff -a
    rm -f /swapfile
    
    # 创建新的swap
    fallocate -l ${swap_size}G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    
    echo "虚拟内存设置完成！大小为 ${swap_size}GB"
    show_system_menu
}

# 设置SSH端口
set_ssh_port() {
    read -p "请输入新的SSH端口号: " new_port
    sed -i "s/#Port 22/Port $new_port/" /etc/ssh/sshd_config
    sed -i "s/Port [0-9]*/Port $new_port/" /etc/ssh/sshd_config
    systemctl restart sshd
    echo "SSH端口已更改为: $new_port"
    show_system_menu
}

# 开放所有端口
open_ports() {
    if [ -f /etc/debian_version ]; then
        apt update
        apt install -y ufw
        ufw allow all
        ufw enable
    elif [ -f /etc/redhat-release ]; then
        systemctl start firewalld
        firewall-cmd --zone=public --add-port=1-65535/tcp --permanent
        firewall-cmd --zone=public --add-port=1-65535/udp --permanent
        firewall-cmd --reload
    fi
    echo "所有端口已开放！"
    show_system_menu
}

# 设置时区
set_timezone() {
    timedatectl set-timezone Asia/Shanghai
    echo "时区已设置为上海时区"
    show_system_menu
}

# 优化DNS
optimize_dns() {
    echo "正在优化DNS设置..."
    # 备份原始文件
    cp /etc/resolv.conf /etc/resolv.conf.bak
    
    # 写入新的DNS配置
    cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF
    
    # 防止文件被覆盖
    chattr +i /etc/resolv.conf
    echo "DNS设置已完成并已防止自动修改"
    show_system_menu
}

# 高性能优化模式
optimize_high_performance() {
    # 系统参数优化
    cat > /etc/sysctl.conf << EOF
# 系统级别的能够打开的文件描述符数量
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
# 调整网络缓冲区大小
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
    echo -e "\033[1;37m视频介绍: https://www.bilibili.com/video/BV1Kb421J7yg?t=0.1\033[0m"
    echo -e "\033[1;34m------------------------------------------------\033[0m"
    echo -e "\033[1;37m提供多种系统参数调优模式，用户可以根据自身使用场景进行选择切换。\033[0m"
    echo -e "\033[1;33m提示: \033[1;37m生产环境请谨慎使用！\033[0m"
    echo -e "\033[1;34m--------------------\033[0m"
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
        1)
            optimize_high_performance
            ;;
        2)
            optimize_balanced
            ;;
        3)
            optimize_web_server
            ;;
        4)
            optimize_high_performance
            ;;
        5)
            optimize_high_performance
            ;;
        6)
            restore_defaults
            ;;
        0)
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
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m脚本大全：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m1. 安装 kejilion 脚本\033[0m"
    echo -e "\033[1;37m2. 安装 勇哥的SB 脚本\033[0m"
    echo -e "\033[1;37m3. 安装宝塔开心版脚本\033[0m"
    echo -e "\033[1;37m4. 还原到宝塔官方版脚本\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m0. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号: " script_choice

    case $script_choice in
        1) echo "安装 kejilion 脚本..."; curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh; show_script_menu ;;
        2) echo "安装 勇哥的SB 脚本..."; bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh); show_script_menu ;;
        3) echo "安装宝塔开心版脚本..."; curl http://io.bt.sy/install/update6.sh|bash; show_script_menu ;;
        4) echo "还原到宝塔官方版脚本..."; curl http://download.bt.cn/install/update6.sh|bash; show_script_menu ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_script_menu ;;
    esac
}

# 应用市场菜单
show_app_market() {
    clear
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m应用市场\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m1. 宝塔面板官方版\033[0m"
    echo -e "\033[1;37m2. aaPanel宝塔国际版\033[0m"
    echo -e "\033[1;37m3. 1Panel新一代管理面板\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m0. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -e -p "请输入你的选择: " sub_choice

    case $sub_choice in
        1)
            # 宝塔面板官方版
            docker_app_install "baota" \
                "宝塔面板官方版" \
                "8888" \
                "wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && echo y | bash install.sh ed8484bec" \
                "宝塔面板是一款简单好用的服务器运维管理面板" \
                "https://www.bt.cn" \
                "echo \"" \
                "如果安装失败，大概率是因为系统太新，目前官方还不支持。\""
            show_app_market
            ;;
        2)
            # aaPanel宝塔国际版
            docker_app_install "aapanel" \
                "aaPanel宝塔国际版" \
                "7800" \
                "wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && echo y | bash install.sh aapanel" \
                "aaPanel是宝塔面板的国际版，没有广告，界面更简洁" \
                "https://www.aapanel.com/" \
                "echo \"" \
                "如果安装失败，大概率是因为系统太新，目前官方还不支持。\""
            show_app_market
            ;;
        3)
            # 1Panel新一代管理面板
            docker_app_install "1panel" \
                "fit2cloud/1panel" \
                "38282" \
                "curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh" \
                "1Panel是一个现代化、开源的 Linux 服务器运维管理面板" \
                "https://1panel.cn/" \
                "" \
                ""
            show_app_market
            ;;
        0)
            show_main_menu
            ;;
        *)
            echo "无效选项，请重试。"
            show_app_market
            ;;
    esac
}

# 通用Docker应用安装函数
docker_app_install() {
    local name=$1
    local image=$2
    local port=$3
    local run_cmd=$4
    local description=$5
    local url=$6
    local use_cmd=$7
    local passwd_cmd=$8

    while true; do
        check_docker_app
        check_docker_image_update $name
        clear
        echo -e "$description $check_docker $update_status"
        echo "官网介绍: $url"
        
        if docker inspect "$name" &>/dev/null; then
            check_docker_app_ip
        fi
        echo ""

        echo "------------------------"
        echo "1. 安装           2. 更新           3. 卸载"
        echo "------------------------"
        echo "5. 域名访问"
        echo "------------------------"
        echo "0. 返回上一级"
        echo "------------------------"
        read -e -p "请输入你的选择: " choice

        case $choice in
            1)
                install_docker
                eval "$run_cmd"
                if [ ! -z "$use_cmd" ]; then
                    eval "$use_cmd"
                fi
                if [ ! -z "$passwd_cmd" ]; then
                    eval "$passwd_cmd"
                fi
                ;;
            2)
                docker rm -f $name
                docker rmi -f $image
                eval "$run_cmd"
                ;;
            3)
                docker rm -f $name
                docker rmi -f $image
                rm -rf /home/docker/$name
                echo "应用已卸载"
                ;;
            5)
                echo "${name}域名访问设置"
                add_yuming
                ldnmp_Proxy ${yuming} ${ipv4_address} ${port}
                ;;
            *)
                break
                ;;
        esac
        break_end
    done
}

# 启动菜单
show_main_menu