#### 项目名称: DST-Server-OneClick

**描述:** DST-Server-OneClick 是一个为《饥荒：联机版》专用服务器提供的一键搭建解决方案。该项目简化了安装和配置过程，使任何人都能轻松托管自己的 DST 服务器。通过这个脚本，你可以快速启动并运行服务器，让你和你的朋友可以在最小的麻烦下进入《饥荒：联机版》的世界。

**功能:**

- 一键安装和设置
- 自动服务器更新
- 可自定义的服务器设置
- 支持 Master 和 Caves 分片
- 使用 `screen` 会话轻松管理

**要求:**

- 基于 Linux 的服务器或计算机
- 已安装 SteamCMD
- 基本的命令行知识

**使用方法:**

1. 将此存储库克隆到您的服务器。
2.  位置设置（可选）

   ```sh
   steamcmd_dir="$HOME/steamcmd"  # steamcmd保存位置
   install_dir="$HOME/dontstarvetogether_dedicated_server" # 饥荒服务器保存位置
   dontstarve_dir="$HOME/.klei/DoNotStarveTogether" # 存档保存位置
   ```
3. 运行安装脚本：`./setup_dst_server.sh`。
4. 按屏幕上的指示配置您的服务器。
5. 启动服务器，享受游戏！
