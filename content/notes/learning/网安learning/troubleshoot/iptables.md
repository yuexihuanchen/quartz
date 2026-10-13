iptables 是 Linux 系统中的防火墙规则管理工具，它负责检查每一个经过服务器的数据包，并根据规则决定：允许、拒绝还是丢弃。

IP数据包过滤表
它是 Linux 内核 Netfilter 框架的用户空间管理工具。
简单理解：
	用户输入iptables命令
          ↓
	iptables修改规则
          ↓
	Linux内核Netfilter执行规则
          ↓
	决定数据包命运

iptables 的核心思想：对网络数据包进行检查，然后执行规则。
![[ex_iptables.png]]

iptables -A INPUT -p tcp --dport 22 -j ACCEPT
	**-A** append 添加规则
	**INPUT**  进入流量
	**-p tcp**  TCP协议
	**--dport 22**  目标端口22
	**-j ACCEPT**  允许
	**允许别人通过TCP访问我的22端口。**
	
iptables -A INPUT -p tcp --dport 3306 -j DROP
	**禁止数据库3306公网访问**

iptables 就是 Linux 服务器的“智能门卫”，它检查每一个网络数据包，根据管理员制定的规则决定放行、拒绝还是丢弃，是 Linux 安全防护、服务器加固、SOC分析和网络安全工程师必须掌握的核心工具。


![[ex_iptablesANDsum.png]]