Certificates, also known as digital certificates or SSL/TLS certificates, are electronic documents used to establish trust and secure communication over networks.

根 CA（最高信任源）
   └── 中间 CA（由根 CA 授权）
          └── 网站证书（最终用户证书）
          
数字证书是网络信任的基石。
	它把三样东西绑在一起：
	1. **身份**：你是谁？
	2. **公钥**：你的公开锁是什么？
	3. **可信第三方 CA**：谁为你担保？
	有了数字证书，我们才能在看不到对方的网络上，放心地登录、支付、传输数据、更新软件、连接设备。
	
- 你去银行开户 → 出示身份证 → 银行确认你是谁
- 网站登录 → 浏览器检查数字证书 → 确认这个网站是真的