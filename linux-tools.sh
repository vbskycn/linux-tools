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


# 分割线与脚本信息
echo -e "\033[1;34m==============================\033[0m"
echo -e "\033[1;33mLinux-Tools 脚本工具箱 v1.25 只为更简单的Linux使用！\033[0m"
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
        sudo mv linux-tools.sh /usr/local/bin/linux-tools
    else
        echo "脚本已是最新版本。"
        rm linux-tools.sh
    fi
    exec /usr/local/bin/linux-tools "$@"
    exit
fi

show_toolbox_info

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
    echo -e "\033[1;37m1. 系统相关\033[0m"
    echo -e "\033[1;37m2. 脚本大全\033[0m"
    echo -e "\033[1;37m3. 应用市场\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m00. 更新脚本\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;31m0. 退出\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号: " main_choice

    case $main_choice in
        1) show_system_menu ;;
        2) show_script_menu ;;
        3) show_app_market ;;
        00) curl -sS -O https://raw.githubusercontent.com/vbskycn/linux-tools/main/linux-tools.sh && \
            chmod +x linux-tools.sh && \
            sudo mv linux-tools.sh /usr/local/bin/linux-tools && \
            /usr/local/bin/linux-tools ;;
        0) exit 0 ;;
        *) echo "无效选项，请重试。"; show_main_menu ;;
    esac
}

# 系统相关菜单
show_system_menu() {
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m系统相关选项：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;32m1. 更新系统\033[0m"
    echo -e "\033[1;37m2. 安装常用工具\033[0m"
    echo -e "\033[1;37m3. 安装 Docker\033[0m"
    echo -e "\033[1;37m4. 安装开发工具\033[0m"
    echo -e "\033[1;37m5. 安装网络工具\033[0m"
    echo -e "\033[1;37m6. 安装常用数据库\033[0m"
    echo -e "\033[1;37m7. 安装 Node.js 和 npm\033[0m"
    echo -e "\033[1;32m8. 清理不再需要的软件包\033[0m"
    echo -e "\033[1;32m9. 更改系统名\033[0m"
    echo -e "\033[1;32m10. 设置快捷键 v\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;31m0. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号: " system_choice

    case $system_choice in
        1) echo "更新系统..."; $PKG_UPDATE ;;
        2) echo "安装常用工具..."; $PKG_INSTALL curl wget git vim unzip build-essential net-tools htop traceroute tmux ;;
        3) echo "安装 Docker..."; $PKG_INSTALL docker.io docker-compose; sudo systemctl enable docker; sudo systemctl start docker ;;
        4) echo "安装开发工具..."; $PKG_INSTALL python3 python3-pip python3-venv openjdk-11-jdk gcc g++ make cmake ;;
        5) echo "安装网络工具..."; $PKG_INSTALL sshpass telnet nmap iperf3 dnsutils net-tools iputils-ping ;;
        6) echo "安装常用数据库..."; $PKG_INSTALL mysql-server postgresql redis-server mongodb ;;
        7) echo "安装 Node.js 和 npm..."; curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -; $PKG_INSTALL nodejs ;;
        8) echo "清理不再需要的软件包..."; $PKG_REMOVE ;;
        9) read -p "输入新的系统名: " new_hostname; sudo hostnamectl set-hostname "$new_hostname"; echo "系统名已更改为 $new_hostname" ;;
        10) echo "设置快捷键 v..."; echo "alias v='/usr/local/bin/linux-tools'" >> ~/.bashrc; source ~/.bashrc; echo "快捷键 'v' 已设置为 'source ~/.bashrc'" ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_system_menu ;;
    esac
}

# 脚本大全菜单
show_script_menu() {
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;33m脚本大全：\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;37m1. 安装 kejilion 脚本\033[0m"
    echo -e "\033[1;37m2. 安装 勇哥的SB 脚本\033[0m"
    echo -e "\033[1;37m3. 安装宝塔开行版脚本\033[0m"
    echo -e "\033[1;37m4. 还原到宝塔官方版脚本\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    echo -e "\033[1;31m0. 返回主菜单\033[0m"
    echo -e "\033[1;34m==============================\033[0m"
    read -p "输入选项编号: " script_choice

    case $script_choice in
        1) echo "安装 kejilion 脚本..."; curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh ;;
        2) echo "安装 勇哥的SB 脚本..."; bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh) ;;
        3) echo "安装宝塔开心版脚本..."; curl http://io.bt.sy/install/update6.sh|bash ;;
        4) echo "还原到宝塔官方版脚本..."; curl http://download.bt.cn/install/update6.sh|bash ;;
        0) show_main_menu ;;
        *) echo "无效选项，请重试。"; show_script_menu ;;
    esac
}

# 应用市场菜单
show_app_market() {
    while true; do
        clear
        echo -e "\033[1;33m应用市场\033[0m"
        echo -e "\033[1;34m==============================\033[0m"
        echo -e "\033[1;37m1. 宝塔面板官方版\033[0m"
        echo -e "\033[1;37m2. aaPanel宝塔国际版\033[0m"
        echo -e "\033[1;37m3. 1Panel新一代管理面板\033[0m"
        echo -e "\033[1;34m==============================\033[0m"
        echo -e "\033[1;31m0. 返回主菜单\033[0m"
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
                ;;
            0)
                break
                ;;
            *)
                echo "无效选项，请重试。"
                ;;
        esac
    done
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
        read -e -p "输入你的选择: " choice

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

# 检查并复制脚本到系统程序目录
install_script() {
    if [ ! -f /usr/local/bin/linux-tools ]; then
        sudo cp $(realpath $0) /usr/local/bin/linux-tools
        sudo chmod +x /usr/local/bin/linux-tools
    fi
    if ! grep -q "alias v='/usr/local/bin/linux-tools'" ~/.bashrc; then
        echo "alias v='/usr/local/bin/linux-tools'" >> ~/.bashrc
    fi
    if [ ! -f ~/.bash_profile ]; then
        touch ~/.bash_profile
    fi
    if ! grep -q "source ~/.bashrc" ~/.bash_profile; then
        echo "if [ -f ~/.bashrc ]; then source ~/.bashrc; fi" >> ~/.bash_profile
    fi
    source ~/.bashrc
}

# 运行安装脚本
install_script

# 启动菜单
show_main_menu