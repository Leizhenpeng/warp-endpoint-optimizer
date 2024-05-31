# WARP Endpoint IP 优选工具

## 介绍

一个用于优化 WARP Endpoint IP 的脚本，帮助用户通过 Cloudflare 的 WARP 服务获得更好的网络性能。

该脚本会自动选择最优的 Endpoint IP 并配置到 WARP 中，使您的网络连接更加稳定和快速。

## 特性

- 支持 IPv4 和 IPv6 的 Endpoint IP 优选
- 自动检测客户端的 CPU 架构并下载相应的工具
- 显示并保存前十个最优的 Endpoint IP
- 自动配置最优的 Endpoint IP 到 WARP

## 使用方法

### 前提条件

- 安装并配置好 WARP
- 确保您的系统已安装 `wget` 和 `awk` 工具

### 步骤

1. 克隆本仓库到本地：

   ```bash
   git clone https://github.com/leizhenpeng/warp-endpoint-optimizer.git
   cd warp-endpoint-optimizer
   ```

2. 赋予脚本执行权限：

   ```bash
   chmod +x warp_optimizer.sh
   ```

3. 运行脚本：

   ```bash
   ./warp_optimizer.sh
   ```

4. 脚本将显示一个菜单，您可以选择以下选项：
   - `1`: 进行 WARP IPv4 Endpoint IP 优选（默认）
   - `2`: 进行 WARP IPv6 Endpoint IP 优选
   - `0`: 退出脚本

5. 脚本将下载并运行 WARP Endpoint IP 优选工具，并显示前十个最优的 Endpoint IP。第一个最优的 IP 将被自动配置到 WARP 中。


### 设置别名以便快速启动

您可以通过在 `.bashrc` 或 `.zshrc` 文件中添加别名来快速启动脚本：

1. 打开 `.bashrc` 或 `.zshrc` 文件并添加以下内容：

   ```bash
   echo 'alias optimize-warp="/Users/river/dev/scriptPool/cloudfalre-warp/warp-endpoint-optimizer/warp_optimizer.sh"' >> ~/.zshrc && source ~/.zshrc
   ```

   请将 `~/path/to/warp-endpoint-optimizer/` 替换为实际路径。

2. 现在您可以通过以下命令快速启动脚本：

   ```bash
   optimize-warp
   ```

## 注意事项

- 该脚本仅支持 x86_64 和 arm64 架构的 CPU。
- 请确保在运行脚本前，已安装并配置好 WARP 客户端。
- 如果在运行过程中遇到问题，请检查是否已正确安装所有依赖工具。

## 贡献

欢迎提交问题和功能请求！您可以通过 GitHub Issues 提交问题，或者 Fork 本仓库并提交 Pull Request。

## 许可证

本项目基于 MIT 许可证开源，详细信息请参阅 LICENSE 文件。
