==Routing table management command==
路由表管理命令
The `route` command is a network utility used to view and manipulate the IP routing table on Unix-like and Windows systems.

作用：
1. 查看当前网络路径
2. 添加新的网络路线
3. 修改已有路线
4. 删除错误路线

路由表就是电脑保存的一张：
	目的地 → 下一跳 → 出口网卡

获得IP
 |
ipconfig

知道路线
 |
route

测试路线
 |
tracert

检查连接
 |
netstat

**route 就是电脑的“导航系统”，它决定数据包从哪里出发、经过哪个网关、最终走向哪里。掌握 route，是理解企业网络、VPN、内网通信和网络安全分析的基础工具。**