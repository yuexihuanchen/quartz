主要用途：
1. 网络资产发现
2. 端口扫描
3. 服务识别
4. 操作系统识别
5. 漏洞检测
6. 网络安全评估

发现资产
	FOFA
	↓
	扫描端口

	Nmap
	↓
	发现Web
	↓
	Burp测试
	↓
	漏洞验证

![[ex_nmap.png]]

Nmap 常用扫描类型

	1. TCP SYN 扫描
		半连接扫描
		nmap -sS 目标IP
		TCP建立连接正常：               SYN扫描：
			客户端                     客户端 
			 |                             
			SYN                       发送 SYN
			 |                            ↓
			服务器                       服务器
			   
			服务器回复 SYN+ACK         回复 SYN+ACK 
			                            ↓
			客户端 ACK                客户端立即断开
			
			连接建立
			
	2. TCP Connect扫描
		nmap -sT IP
		完整建立TCP连接。
	3. UDP扫描
		nmap -sU IP