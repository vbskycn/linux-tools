#!/bin/bash

# 显示主菜单
show_main_menu() {
    echo "请选择一个选项："
    echo "1. 系统相关"
    echo "2. 脚本大全"
    echo "0. 退出"
    read -p "输入选项编号: " main_choice

    case $main_choice in
        1) show_system_menu ;;
        2) show_script_menu ;;
        0) exit 0 ;;
        *) echo "无效选项，请重试。"; show_main_menu ;;
    esac
}

# 系统相关菜单
show_system_menu() {
    echo "系统相关选项："
    echo "1. 更新系统"
    echo "2. 安装常用工具"
    echo "3. 安装 Docker"
    echo "4. 安装开发工具"
    echo "5. 安装网络工具"
    echo "6. 安装常用数据库"
    echo "7. 安装 Node.js 和 npm"
    echo "8. 清理不再需要的软件包"
    echo "9. 更改系统名"
    echo "0. 返回主菜单"
    read -p "输入选项编号: " system_choice

    case $system_choice in
        1) echo "更新系统..."; sudo apt update -y && sudo apt upgrade -y ;;
        2) echo "安装常用工具..."; sudo apt install -y curl wget git vim unzip build-essential net-tools htop traceroute tmux ;;
        3) echo "安装 Docker..."; sudo apt install -y docker.io docker-compose; sudo systemctl enable docker; sudo systemctl start docker ;;
        4) echo "安装开发工具..."; sudo apt install -y python3 python3-pip python3-venv openjdk-11-jdk gcc g++ make cmake ;;
        5) echo "安装网络工具..."; sudo apt install -y sshpass telnet nmap iperf3 dnsutils net-tools iputils-ping ;;
        6) echo "安装常用数据库..."; sudo apt install -y mysql-server postgresql redis-server mongodb ;;
        7) echo "安装 Node.js 和 npm..."; curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -; sudo apt install -y nodejs ;;
        8) echo "清理不再需要的软件包..."; sudo apt autoremove -y ;;
        9) read -p "输入新的系统名: " new_hostname; sudo hostnamectl set-hostname "$new_hostname"; echo "系统名已更改为 $new_hostname" ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_system_menu ;;
    esac
}

# 脚本大全菜单
show_script_menu() {
    echo "脚本大全选项："
    echo "1. 安装 kejilion 脚本"
    echo "2. 安装 勇哥的SB 脚本"
    echo "3. 安装宝塔开行版脚本"
    echo "4. 还原到宝塔官方版脚本"
    echo "0. 返回主菜单"
    read -p "输入选项编号: " script_choice

    case $script_choice in
        1) echo "安装 kejilion 脚本..."; curl -sS -O https://ghp.ci/raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh ;;
        2) echo "安装 勇哥的SB 脚本..."; bash <(curl -Ls https://ghp.ci/raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh) ;;
        3) echo "安装宝塔开行版脚本..."; curl http://io.bt.sy/install/update6.sh|bash ;;
        4) echo "还原到宝塔官方版脚本..."; curl http://download.bt.cn/install/update6.sh|bash ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_script_menu ;;
    esac
}

# 将脚本复制到系统程序目录
install_script() {
    sudo cp $(realpath $0) /usr/local/bin/linux-tools
    sudo chmod +x /usr/local/bin/linux-tools
    echo "alias v='/usr/local/bin/linux-tools'" >> ~/.bashrc
    source ~/.bashrc
    echo "脚本已安装到 /usr/local/bin 并设置快捷命令 'v'。"
}

# 运行安装脚本
install_script

# 启动菜单
show_main_menu