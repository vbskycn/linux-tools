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

## 更新说明

- 所有 `https://raw.githubusercontent.com` 链接已更改为通过代理服务器 `https://ghp.ci/raw.githubusercontent.com` 访问，以提高网络可访问性。
- 脚本现在会下载到本地，并设置快捷键 `v` 来运行本地的 `linux.sh`。

## 使用方法

要运行此脚本并访问菜单，请执行以下命令，这将下载脚本到本地并设置快捷键：

```bash
curl -sS -O https://ghp.ci/raw.githubusercontent.com/vbskycn/linux-tools/main/linux.sh && chmod +x linux.sh && ./linux.sh
```

然后，您可以通过在终端中输入 `v` 来快速启动本地脚本。