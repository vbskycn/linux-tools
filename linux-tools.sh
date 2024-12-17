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
echo -e "\033[1;33mLinux-Tools 脚本工具箱 v1.29.94 只为更简单的Linux使用！\033[0m"
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
    echo -e "\033[1;32m00. 更新脚本\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;34m--------------------\033[0m"
    echo -e "\033[1;32m0. 退出程序\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号或代码: " main_choice

    case $main_choice in
        1|sys) show_system_menu ;;
        2|tool) show_basic_tools_menu ;;
        3|script) show_script_menu ;;
        4|app) show_app_market ;;
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
    echo -e "\033[1;34m--------------------\033[0m"
    echo -e "\033[1;32m0. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号或代码: " tools_choice

    case $tools_choice in
        1|tool1) 
            echo "安装常用工具..."
            case "$ID" in
                ubuntu|debian|kali)
                    $PKG_INSTALL curl wget git vim unzip build-essential net-tools htop inetutils-traceroute tmux
                    ;;
                centos|redhat|fedora|alma|rocky)
                    $PKG_INSTALL curl wget git vim unzip gcc make net-tools htop traceroute tmux
                    ;;
                arch)
                    $PKG_INSTALL curl wget git vim unzip base-devel net-tools htop traceroute tmux
                    ;;
                alpine)
                    $PKG_INSTALL curl wget git vim unzip build-base net-tools htop traceroute tmux
                    ;;
            esac
            echo "安装完成"
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_basic_tools_menu 
            ;;
        2|tool2) 
            echo "安装 Docker..."
            case "$ID" in
                ubuntu|debian|kali)
                    curl -fsSL https://get.docker.com | sh
                    $PKG_INSTALL docker-compose
                    ;;
                centos|redhat|fedora|alma|rocky)
                    curl -fsSL https://get.docker.com | sh
                    $PKG_INSTALL docker-compose
                    ;;
                arch)
                    $PKG_INSTALL docker docker-compose
                    ;;
                alpine)
                    $PKG_INSTALL docker docker-compose
                    ;;
            esac
            sudo systemctl enable docker
            sudo systemctl start docker
            echo "Docker 安装完成"
            show_basic_tools_menu 
            ;;
        3|tool3) 
            echo "安装开发工具..."
            case "$ID" in
                ubuntu|debian|kali)
                    $PKG_INSTALL python3 python3-pip python3-venv openjdk-11-jdk gcc g++ make cmake
                    ;;
                centos|redhat|fedora|alma|rocky)
                    $PKG_INSTALL python3 python3-pip java-11-openjdk-devel gcc gcc-c++ make cmake
                    ;;
                arch)
                    $PKG_INSTALL python python-pip jdk11-openjdk gcc make cmake
                    ;;
                alpine)
                    $PKG_INSTALL python3 py3-pip openjdk11 gcc g++ make cmake
                    ;;
            esac
            echo "开发工具安装完成！"
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_basic_tools_menu 
            ;;
        4|tool4) 
            echo "安装网络工具..."
            case "$ID" in
                ubuntu|debian|kali)
                    $PKG_INSTALL sshpass telnet nmap iperf3 dnsutils net-tools iputils-ping
                    ;;
                centos|redhat|fedora|alma|rocky)
                    $PKG_INSTALL sshpass telnet nmap iperf3 bind-utils net-tools iputils
                    ;;
                arch)
                    $PKG_INSTALL sshpass telnet nmap iperf3 bind-tools net-tools iputils
                    ;;
                alpine)
                    $PKG_INSTALL sshpass busybox-extras nmap iperf3 bind-tools net-tools iputils
                    ;;
            esac
            echo "网络工具安装完成！"
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_basic_tools_menu 
            ;;
        5|tool5) 
            echo "安装常用数据库..."
            case "$ID" in
                ubuntu|debian|kali)
                    $PKG_INSTALL mysql-server postgresql redis-server
                    ;;
                centos|redhat|fedora|alma|rocky)
                    $PKG_INSTALL mysql-server postgresql-server redis
                    ;;
                arch)
                    $PKG_INSTALL mysql postgresql redis
                    ;;
                alpine)
                    $PKG_INSTALL mysql postgresql redis
                    ;;
            esac
            show_basic_tools_menu 
            ;;
        6|tool6) 
            echo "安装 Node.js 和 npm..."
            case "$ID" in
                ubuntu|debian|kali)
                    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
                    $PKG_INSTALL nodejs
                    ;;
                centos|redhat|fedora|alma|rocky)
                    curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
                    $PKG_INSTALL nodejs
                    ;;
                arch)
                    $PKG_INSTALL nodejs npm
                    ;;
                alpine)
                    $PKG_INSTALL nodejs npm
                    ;;
            esac
            show_basic_tools_menu 
            ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_basic_tools_menu ;;
    esac
}

# 系统相关菜单
show_system_menu() {
    clear
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m系统相关选项：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m1. 更新系统\033[0m"
    echo -e "\033[1;37m2. 清理不再需要的软件包\033[0m"
    echo -e "\033[1;37m3. 更改系统名\033[0m"
    echo -e "\033[1;37m4. 设置快捷键V\033[0m"
    echo -e "\033[1;37m5. 设置虚拟内存\033[0m"
    echo -e "\033[1;37m6. 设置SSH端口\033[0m"
    echo -e "\033[1;37m7. 开放所有端口\033[0m"
    echo -e "\033[1;37m8. 设置时区\033[0m"
    echo -e "\033[1;37m9. 优化DNS\033[0m"
    echo -e "\033[1;37m10. linux内核优化-高性能优化模式\033[0m"
    echo -e "\033[1;37m11. linux内核优化-均衡优化模式\033[0m"
    echo -e "\033[1;37m12. linux内核优化-网站优化模式\033[0m"
    echo -e "\033[1;37m13. linux内核优化-还原默认设置\033[0m"
    echo -e "\033[1;37m14. 开启root密码登入\033[0m"
    echo -e "\033[1;37m15. 开启root密钥登入\033[0m"
    echo -e "\033[1;34m--------------------\033[0m"
    echo -e "\033[1;32m0. 返回上级\033[0m"
    echo -e "\033[1;34m--------------------\033[0m"
    read -p "输入选项编号或代码: " choice

    case $choice in
        1|sys1) update_system ;;
        2|sys2) clean_packages ;;
        3|sys3) change_hostname ;;
        4|sys4) set_shortcut ;;
        5|sys5) set_swap ;;
        6|sys6) set_ssh_port ;;
        7|sys7) open_ports ;;
        8|sys8) set_timezone ;;
        9|sys9) optimize_dns ;;
        10|sys10) optimize_high_performance ;;
        11|sys11) optimize_balanced ;;
        12|sys12) optimize_web_server ;;
        13|sys13) restore_defaults ;;
        14|sys14) enable_root_password ;;
        15|sys15) enable_root_key ;;
        0) show_main_menu ;;
        *) 
            echo "无效选项，请重试。"
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
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
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
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
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 更改系统名
change_hostname() {
    read -p "请输入新的主机名: " new_hostname
    hostnamectl set-hostname $new_hostname
    echo "系统名已更改为: $new_hostname"
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 设置快捷键V
set_shortcut() {
    echo "正在设置快捷键V..."
    
    # 设置系统级别的别名
    if [ -d "/etc/profile.d" ]; then
        echo 'alias v="/usr/local/bin/linux-tools"' | sudo tee /etc/profile.d/linux-tools-alias.sh > /dev/null
        sudo chmod +x /etc/profile.d/linux-tools-alias.sh
    fi
    
    # 设置当前用户的别名
    if [ -f "$HOME/.bashrc" ]; then
        sed -i '/^alias v=/d' "$HOME/.bashrc"
        echo 'alias v="/usr/local/bin/linux-tools"' >> "$HOME/.bashrc"
        source "$HOME/.bashrc" 2>/dev/null || true
    fi
    
    echo "快捷键V设置完成！现在可以使用 v 命令快速启动脚本"
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 设置虚拟内存
set_swap() {
    echo "正在设置虚拟内存..."
    
    # 显示当前内存和swap使用情况
    echo "当前内存使用情况:"
    free -h
    echo "------------------------"
    
    # 提示用户输入新的swap大小，默认为2GB
    read -p "请输入要设置的虚拟内存大小(GB) [默认: 2]: " swap_size
    swap_size=${swap_size:-2}  # 如果用户直接回车，使用默认值2
    
    # 检查输入是否为数字
    if ! [[ "$swap_size" =~ ^[0-9]+$ ]]; then
        echo "请输入有效的数字！"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 检查可用磁盘空间
    available_space=$(df -BG / | awk 'NR==2 {print $4}' | tr -d 'G')
    if [ "$available_space" -lt "$swap_size" ]; then
        echo "错误: 磁盘空间不足！"
        echo "可用空间: ${available_space}GB"
        echo "需要空间: ${swap_size}GB"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 检查是否已存在swap
    if swapon -s | grep -q "/swapfile"; then
        echo "检测到已存在虚拟内存，正在关闭..."
        sudo swapoff /swapfile
        sudo rm -f /swapfile
    fi
    
    echo "正在创建 ${swap_size}GB 虚拟内存..."
    
    # 使用fallocate创建swap文件（更快且更可靠）
    if ! sudo fallocate -l ${swap_size}G /swapfile; then
        echo "使用fallocate创建失败，尝试使用dd命令..."
        # 如果fallocate失败，使用dd作为备选方案
        if ! sudo dd if=/dev/zero of=/swapfile bs=1024K count=$((swap_size * 1024)) status=progress; then
            echo "创建虚拟内存文件失败"
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_system_menu
            return
        fi
    fi
    
    # 设置权限
    if ! sudo chmod 600 /swapfile; then
        echo "设置权限失败"
        sudo rm -f /swapfile
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 创建swap
    if ! sudo mkswap /swapfile; then
        echo "初始化虚拟内存失败"
        sudo rm -f /swapfile
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 启用swap
    if ! sudo swapon /swapfile; then
        echo "启用虚拟内存失败"
        sudo rm -f /swapfile
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 添加到 fstab
    if ! grep -q "/swapfile" /etc/fstab; then
        echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
    fi
    
    echo "虚拟内存设置完成！"
    echo "------------------------"
    echo "当前内存和虚拟内存使用情况:"
    free -h
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 设置SSH端口
set_ssh_port() {
    # 显示当前SSH端口
    current_port=$(grep -E "^Port\s+[0-9]+" /etc/ssh/sshd_config | awk '{print $2}')
    if [ -z "$current_port" ]; then
        current_port="22 (默认)"
    fi
    echo "当前SSH端口: $current_port"
    
    # 提示用户输入新端口，默认为5522
    read -p "请输入新的SSH端口号(1-65535) [默认: 5522]: " new_port
    new_port=${new_port:-5522}  # 如果用户直接回车，使用默认值5522
    
    # 检查端口号是否有效
    if ! [[ "$new_port" =~ ^[0-9]+$ ]] || [ "$new_port" -lt 1 ] || [ "$new_port" -gt 65535 ]; then
        echo "无效的端口号！端口号必须在 1-65535 之间"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 检查是否有 root 权限
    if [ "$(id -u)" != "0" ]; then
        echo "需要 root 权限来修改 SSH 配置"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 备份SSH配置文件
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    
    # 修改SSH端口
    sudo sed -i "s/^#*Port .*/Port $new_port/" /etc/ssh/sshd_config
    
    # 检查配置文件语法
    if ! sudo sshd -t; then
        echo "SSH配置文件语法检查失败，正在还原备份..."
        sudo mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 重启SSH服务
    if ! sudo systemctl restart sshd; then
        echo "重启SSH服务失败，正在还原备份..."
        sudo mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
        sudo systemctl restart sshd
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    echo "SSH端口已成功更改！"
    echo "原端口: $current_port"
    echo "新端口: $new_port"
    echo -e "\033[33m请确保在防火墙中开放新端口，并记住新的端口号\033[0m"
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 开放所有端口
open_ports() {
    echo "正在配置防火墙规则..."
    
    # 检查是否有 root 权限
    if [ "$(id -u)" != "0" ]; then
        echo "需要 root 权限来配置防火墙"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    if [ -f /etc/debian_version ]; then
        echo "检测到 Debian/Ubuntu 系统，使用 ufw..."
        
        # 安装 ufw
        if ! command -v ufw >/dev/null 2>&1; then
            apt update && apt install -y ufw
        fi
        
        # 配置 ufw 规则
        ufw default allow outgoing
        ufw default deny incoming
        ufw allow ssh
        
        # 允许所有端口
        for port in {1..65535}; do
            ufw allow $port/tcp
            ufw allow $port/udp
        done
        
        # 启用 ufw
        echo "y" | ufw enable
        
        echo "ufw 防火墙规则配置完成"
        ufw status numbered
        
    elif [ -f /etc/redhat-release ]; then
        echo "检测到 RHEL/CentOS 系统，使用 firewalld..."
        
        # 确保 firewalld 已安装并运行
        if ! systemctl is-active --quiet firewalld; then
            systemctl start firewalld
            systemctl enable firewalld
        fi
        
        # 配置 firewalld 规则
        firewall-cmd --zone=public --add-port=1-65535/tcp --permanent
        firewall-cmd --zone=public --add-port=1-65535/udp --permanent
        firewall-cmd --reload
        
        echo "firewalld 防火墙规则配置完成"
        firewall-cmd --list-all
    fi
    
    echo "所有端口已开放完成！"
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 设置时区为上海
set_timezone() {
    echo "正在自动设置时区为上海..."
    if ! sudo timedatectl set-timezone Asia/Shanghai; then
        echo "设置时区失败"
    else
        echo "时区已自动设置为上海"
        echo "当前时间: $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 优化DNS
optimize_dns() {
    echo "正在优化DNS设置..."
    
    # 备份原始文件
    sudo cp /etc/resolv.conf /etc/resolv.conf.bak
    
    # 检查IP是否在中国
    local ip_info=$(curl -s https://ipapi.co/json/)
    local country=$(echo "$ip_info" | grep -o '"country": "[^"]*' | cut -d'"' -f4)
    
    # 根据地理位置设置DNS
    if [ "$country" = "CN" ]; then
        echo "检测到服务器在中国，使用国内DNS..."
        cat > /etc/resolv.conf << EOF
nameserver 223.5.5.5
nameserver 114.114.114.114
EOF
    else
        echo "检测到服务器在国外，使用国际DNS..."
        cat > /etc/resolv.conf << EOF
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF
    fi
    
    echo "DNS优化完成！"
    echo "当前DNS服务器:"
    cat /etc/resolv.conf | grep nameserver
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
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
# 内核所允许的最大共享内存段的小
kernel.shmmax = 68719476736
# 在任何给时刻，系统上可以使用的共享内存的总量
kernel.shmall = 4294967296
# 置消息队列
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
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 均衡优化模式
optimize_balanced() {
    # 系统参数优化（均模式）
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
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
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
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 还原默认设置
restore_defaults() {
    # 还原 sysctl.conf
    cat > /etc/sysctl.conf << EOF
# 保持系统默认值
EOF

    sysctl -p

    # ��原 limits.conf
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
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 内核优化菜单
show_kernel_optimize() {
    clear
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33mLinux系统内核参数优化\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m1. 高性能优化模式：     大化系���性能，优化文件描述符、虚拟内存、网络置、缓存管理和CPU设置。\033[0m"
    echo -e "\033[1;37m2. 均衡化模式：       性能与资源消耗之间取得平衡，适合日常使用。\033[0m"
    echo -e "\033[1;37m3. 网站优化模式：       针对站服务器进行优化，提高并发连接处理能力、响应速度和整体性。\033[0m"
    echo -e "\033[1;37m4. 直播优化模式：       针对直播推流的特需求进行优化，减少延迟，提高传输性能。\033[0m"
    echo -e "\033[1;37m5. 游戏服优化模式：     针对游戏服务器进行优化，提高并发处理能力和响应速度。\033[0m"
    echo -e "\033[1;37m6. 还原默认设置：       将系统设置还原为默认配置。\033[0m"
    echo -e "\033[1;34m--------------------\033[0m"
    echo -e "\033[1;32m0. 返回上级\033[0m"
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
    echo -e "\033[1;37m1. 安装 kejilion 脚本\033[0m"
    echo -e "\033[1;37m2. 安装 勇哥的SB 脚本\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;34m--------------------\033[0m"
    echo -e "\033[1;32m0. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号或代码: " choice

    case $choice in
        1|script1) 
            echo "安装 kejilion 脚本..."
            curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_script_menu 
            ;;
        2|script2) 
            echo "安装 勇哥的SB 脚本..."
            bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh)
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_script_menu 
            ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_script_menu ;;
    esac
}

# 应用市场菜单
show_app_market() {
    clear
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m应用市场：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m1. 宝塔面板官方版\033[0m"
    echo -e "\033[1;37m2. aaPanel宝塔国际版\033[0m"
    echo -e "\033[1;37m3. 1Panel新一代管理面板\033[0m"
    echo -e "\033[1;37m4. 安装宝塔开心版\033[0m"
    echo -e "\033[1;37m5. 还原到宝塔官方版\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;34m--------------------\033[0m"
    echo -e "\033[1;32m0. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -e -p "输入选项编号或代码: " choice

    case $choice in
        1|app1) 
            echo "安装宝塔面板官方版..."
            wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && echo y | bash install.sh ed8484bec
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_app_market 
            ;;
        2|app2) 
            echo "安装aaPanel宝塔国际版..."
            wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && echo y | bash install.sh aapanel
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_app_market 
            ;;
        3|app3) 
            echo "安装1Panel新一代管理面板..."
            curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_app_market 
            ;;
        4|app4) 
            echo "安装宝塔开心版..."
            curl http://io.bt.sy/install/update6.sh|bash
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_app_market 
            ;;
        5|app5) 
            echo "还原到宝塔官方版..."
            curl http://download.bt.cn/install/update6.sh|bash
            echo -e "\033[1;32m按任意键返回...\033[0m"
            read -n 1
            show_app_market 
            ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_app_market ;;
    esac
}

# 开启root密码登入
enable_root_password() {
    echo "正在配置root密码登入..."
    
    # 检查是否有root权限
    if [ "$(id -u)" != "0" ]; then
        echo "需要root权限来修改配置"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 修改 SSH 配置允许 root 登录
    if ! sed -i 's/#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config || \
       ! sed -i 's/#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config; then
        echo "修改SSH配置失败"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 重启 SSH 服务
    if ! systemctl restart sshd; then
        echo "重启SSH服务失败"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 设置root密码
    echo -e "\033[33m请设置root用户密码...\033[0m"
    if ! passwd root; then
        echo "设置root密码失败"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    echo -e "\033[32mroot密码登入已成功启用！\033[0m"
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 开启root密钥登入
enable_root_key() {
    echo "正在配置root密钥登入..."
    
    # 检查是否有root权限
    if [ "$(id -u)" != "0" ]; then
        echo "需要root权限来修改配置"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 生成密钥对
    KEY_FILE="$HOME/id_rsa_root"
    if ! ssh-keygen -t rsa -b 4096 -f "$KEY_FILE" -N "" -q; then
        echo "���成SSH密钥对失败"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 配置root的SSH目录
    if ! mkdir -p /root/.ssh || ! chmod 700 /root/.ssh; then
        echo "创建root的SSH目录失败"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 添加公钥到authorized_keys
    if ! cp "$KEY_FILE.pub" /root/.ssh/authorized_keys || ! chmod 600 /root/.ssh/authorized_keys; then
        echo "配置authorized_keys失败"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 修改SSH配置
    if ! sed -i 's/#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config || \
       ! sed -i 's/#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config; then
        echo "修改SSH配置失败"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 重启SSH服务
    if ! systemctl restart sshd; then
        echo "重启SSH服务失败"
        echo -e "\033[1;32m按任意键返回...\033[0m"
        read -n 1
        show_system_menu
        return
    fi
    
    # 设置私钥权限
    chmod 600 "$KEY_FILE"
    
    echo -e "\033[32mroot密钥登入配置成功！\033[0m"
    echo -e "\033[33m私钥文件已保存到: $KEY_FILE\033[0m"
    echo -e "\033[33m请妥善保管私钥文件，建议下载后删除服务器上的私钥\033[0m"
    echo -e "\033[1;32m按任意键返回...\033[0m"
    read -n 1
    show_system_menu
}

# 启动菜单
show_main_menu