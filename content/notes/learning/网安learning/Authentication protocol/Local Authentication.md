本地认证 = 你登录一个系统时，由这个系统自己检查你的用户名和密码，而不是去问另外一个认证服务器。

例如你登录自己的 Windows 电脑：
	你
	 │
	 │ 用户名：Alice
	 │ 密码：123456
	 ↓
	Windows电脑
	 │
	 │ 检查本机保存的账号信息
	 ↓
	认证成功？
	 ├── 是 → 允许登录
	 └── 否 → 拒绝登录
	 
	这里：
	**Windows 电脑自己就是“认证中心”**
	这就是 Local Authentication。
	
Authentication ≠ Authorization
	 ***Authentication***
	**你是谁？**
	
	***Authorization***
	**你能干什么？**



![[ex_La_and_final.png]]
