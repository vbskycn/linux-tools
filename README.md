# Linux Tools

## 功能说明

这个脚本提供了一个交互式菜单系统，用于执行各种系统相关的任务和脚本安装。功能包括：

1. **系统相关**
   - 更新系统
   - 安装常用工具
   - 安装 Docker
   - 安装开发工具
   - 安装网络工具
   - 安装常用数据库
   - 安装 Node.js 和 npm
   - 清理不再需要的软件包
   - 更改系统名

2. **脚本大全**
   - 安装 kejilion 脚本
   - 安装 勇哥的SB 脚本
   - 安装宝塔开行版脚本
   - 还原到宝塔官方版脚本

## linux-tools.sh 脚本信息

### Overview
Linux-Tools 是一个脚本工具箱，旨在简化 Linux 系统的使用。它提供了一个用户友好的界面，用于管理系统任务，并且与广泛的 Linux 发行版兼容。

### Version
当前版本：**1.25**

### Compatibility
兼容以下发行版：
- Ubuntu
- Debian
- CentOS
- Alpine
- Kali
- Arch
- RedHat
- Fedora
- Alma
- Rocky

### Installation
脚本会自动更新到 `/usr/local/bin/` 如果它不在那里。它从 GitHub 存储库获取最新版本，并安装更新。

### Usage
- 显示一个工具箱，带有美化的标题和版本信息。
- 快速启动可用通过输入 `v`。

### Package Management
脚本检测 Linux 发行版，并设置包管理器命令：
- **Debian-based**：使用 `apt` 进行更新和安装。
- **RedHat-based**：使用 `yum` 进行更新和安装。

### Features
- 自动更新，以确保始终使用最新版本。
- 与多个 Linux 发行版兼容，具有广泛的可用性。
- 简化包管理，基于检测到的发行版自动执行命令。

## 更新说明

- 所有 `https://raw.githubusercontent.com` 链接已更改为通过代理服务器 `https://github.zhoujie218.top/https://raw.githubusercontent.com` 访问，以提高网络可访问性。
- 脚本现在会下载到本地，并设置快捷键 `v` 来运行本地的 `linux-tools.sh`。

## 使用方法

要运行此脚本并访问菜单，请执行以下命令，这将下载脚本到本地并设置快捷键：


github 代理版本
```
curl -sS -O https://github.zhoujie218.top/https://raw.githubusercontent.com/vbskycn/linux-tools/main/zh/linux-tools.sh && chmod +x linux-tools.sh && ./linux-tools.sh
```
github 直连版本
```
curl -sS -O https://raw.githubusercontent.com/vbskycn/linux-tools/main/linux-tools.sh && chmod +x linux-tools.sh && ./linux-tools.sh
```

然后，您可以通过在终端中输入 `v` 来快速启动本地脚本。