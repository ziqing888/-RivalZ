#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'       # 绿色文本
YELLOW='\033[1;33m'      # 黄色文本
BLUE='\033[1;34m'        # 蓝色文本
CYAN='\033[0;36m'        # 青色文本
NC='\033[0m'             # 无颜色

# 显示 Logo 函数
display_logo() {
    # 从远程源获取并显示 Logo
    curl -s https://raw.githubusercontent.com/ziqing888/logo.sh/refs/heads/main/logo.sh | bash
}

# 显示主菜单
show_menu() {
    # 清屏并显示 Logo 和选项菜单
    clear
    display_logo
    echo -e "${CYAN}======================================${NC}"
    echo -e "${GREEN}       Rivalz CLI 自动化安装菜单      ${NC}"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW} 1.${NC} 一键安装所有依赖并配置环境"
    echo -e "${YELLOW} 2.${NC} 配置并运行 Rivalz CLI"
    echo -e "${YELLOW} 3.${NC} 退出"
    echo -e "${CYAN}======================================${NC}"
}

# 安装依赖和配置环境
install_all_dependencies() {
    # 更新系统，安装 curl、screen 和 Node.js 20
    echo -e "${BLUE}更新系统并安装 curl、screen 和 Node.js 20...${NC}"
    apt update && apt upgrade -y
    apt install -y curl screen
    # 检查 Node.js 20 版本是否安装
    if ! nodejs -v | grep -q "v20"; then
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        apt install -y nodejs
        echo -e "${GREEN}Node.js 20 安装完成！${NC}"
    else
        echo -e "${GREEN}Node.js 20 已安装${NC}"
    fi

    # 安装 Rivalz CLI 工具
    echo -e "${BLUE}安装 Rivalz CLI...${NC}"
    npm i -g rivalz-node-cli
    echo -e "${GREEN}所有依赖项和环境配置完成！${NC}"
}

# 配置并运行 Rivalz CLI
configure_rivalz() {
    # 启动 CLI 配置
    echo -e "${BLUE}启动 Rivalz 配置...${NC}"

    # 获取 /dev/sda3 的可用磁盘空间（单位为 GB）
    max_disk_size=$(df --output=avail -BG /dev/sda3 | tail -1 | grep -o '[0-9]*')

    # 启动一个新的 screen 会话来配置 CLI
    screen -S rivalz bash -c "
        echo -e '\033[1;34m进入 Rivalz 配置会话，请按照提示输入信息。\033[0m';
        rivalz update-version;
        rivalz run;
        echo -e '\033[1;32m配置完成后，节点将持续运行。使用 Ctrl+A+D 退出 screen 会话，保持节点运行。\033[0m';
        bash" # 保持 screen 打开状态

    echo -e "${GREEN}Rivalz CLI 配置会话已打开。${NC}"
    echo -e "${CYAN}使用 'screen -r rivalz' 进入会话，手动输入配置。${NC}"
}

# 主循环，显示菜单并根据选择执行操作
while true; do
    show_menu
    read -p "请选择一个操作 [1-3]: " choice
    case $choice in
        1)
            install_all_dependencies
            ;;
        2)
            configure_rivalz
            ;;
        3)
            echo -e "${GREEN}退出程序。${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选择，请输入 1 到 3 之间的数字。${NC}"
            ;;
    esac
done
