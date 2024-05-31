#!/bin/bash
export LANG=en_US.UTF-8

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'

# 定义颜色显示函数
red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}

green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}

# 获取客户端 CPU 架构
getCPUArch(){
    case "$(uname -m)" in
        x86_64 | amd64 ) echo 'amd64' ;;
        armv8 | arm64 | aarch64 ) echo 'arm64' ;;
        * ) red "不支持的CPU架构!" && exit 1 ;;
    esac
}

# 优化 WARP Endpoint IP
optimizeWARPIP(){
    # 删除之前的优选结果文件，以避免出错
    rm -f result.csv

    # 下载 WARP 优选工具
    wget https://gitlab.com/Misaka-blog/warp-script/-/raw/main/files/warp-yxip/warp-darwin-$(getCPUArch) -O warp

    # 设置文件权限并取消 Linux 自带的线程限制
    chmod +x warp
    ulimit -n 102400

    # 启动 WARP Endpoint IP 优选工具
    if [[ $1 == 6 ]]; then
        ./warp -ipv6
    else
        ./warp
    fi

    # 显示并保存前十个优选 Endpoint IP 及使用方法
    green "当前最优 Endpoint IP 结果如下，并已保存至 result.csv 中："
    awk -F, '$3!="timeout ms" {print} ' result.csv | sort -t, -nk2 -nk3 | uniq | head -11 | awk -F, '{print "端点 "$1" 丢包率 "$2" 平均延迟 "$3}'
    echo ""
    yellow "优选 IP 使用方法如下："
    yellow "1. 将 WARP 的 WireGuard 节点的默认的 Endpoint IP：engage.cloudflareclient.com:2408 替换成本地网络最优的 Endpoint IP"
    echo "设置方法命令行执行: warp-cli tunnel endpoint set 优选IP+端口"

    # 自动设置第一个最优 IP
    best_ip=$(awk -F, 'NR==2{print $1}' result.csv)
    if warp-cli settings | grep -q "Organization"; then
        sudo warp-cli tunnel endpoint set $best_ip
        echo "已经成功自动设置为第一个最优IP"
    else
        warp-cli tunnel endpoint set $best_ip
        echo "已经成功自动设置为第一个最优IP"
    fi

    # 删除 WARP 优选工具
    rm -f warp
}

# 显示菜单并处理用户输入
displayMenu(){
    echo "#############################################################"
    echo -e "#               ${RED}WARP Endpoint IP 一键优选脚本${PLAIN}               #"
    echo "#############################################################"
    echo ""
    echo -e " ${GREEN}1.${PLAIN} WARP IPv4 Endpoint IP 优选 ${YELLOW}(默认)${PLAIN}"
    echo -e " ${GREEN}2.${PLAIN} WARP IPv6 Endpoint IP 优选"
    echo " -------------"
    echo -e " ${GREEN}0.${PLAIN} 退出脚本"
    echo ""
    read -rp "请输入选项 [0-2]: " menuInput
    case $menuInput in
        2 ) optimizeWARPIP 6 ;;
        0 ) exit 0 ;;
        * ) optimizeWARPIP ;;
    esac
}

displayMenu
