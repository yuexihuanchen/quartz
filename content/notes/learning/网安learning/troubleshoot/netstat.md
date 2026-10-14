**netstat** (network statistics) is a command-line tool used to display network connections, routing tables, and network interface statistics.

网络统计信息
	它是一个命令行工具，用于查看：
	1. 当前网络连接
	2. 开放端口
	3. 正在监听的服务
	4. TCP/UDP通信状态
	5. 路由表
	6. 网络接口状态

为什么需要 netstat？
	电脑每天都在偷偷进行大量网络通信：
	你打开浏览器：
		你的电脑
		  |
		  |
		  ↓
		Google服务器
		
	后台可能还有：
		微信
		 ↓
		腾讯服务器
		
		Steam
		 ↓
		游戏服务器

		Windows更新
		 ↓
		微软服务器
普通用户看不到。但是：netstat可以把这些隐藏连接显示出来。
