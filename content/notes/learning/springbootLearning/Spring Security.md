
	                用户
                     │
                  登录 Login
                     │
                     ↓
              ┌──────────────┐
              │ 认证 Authentication │
              └───────┬──────┘
                      │
             username + password
                      │
                      ↓
                   MySQL
                      │
                用户是否存在？
                密码是否正确？
                      │
                      ↓
                生成 Token
                      │
          ┌───────────┴───────────┐
          ↓                       ↓
   Access Token             Refresh Token
     JWT短期                   JWT/随机Token
          │                       │
          ↓                       ↓
     访问业务接口             获取新的Access Token
          │
          ↓
 Spring Security FilterChain
          │
          ├── JWT是否合法？
          ├── 是否过期？
          ├── 是否Logout？
          ├── 用户是谁？
          ├── 用户有什么权限？
          │
          ↓
       RBAC权限模型
          │
    User → Role → Permission
          │
          ↓
     允许 / 拒绝访问
       │          │
       ↓          ↓
      200        401 / 403


### Session 到底是什么
![[ex_session.png]]

### Session 共享问题
![[Pasted image 20260909134043.png]]

### JWT 为什么出现
JWT 的思路非常漂亮：**不要让服务器保存每一个用户的登录状态**
Session：客户端
		  ↓
		Session ID
		  ↓
		服务器
		  ↓
		查Session
		  ↓
		得到用户
JWT：客户端
		↓
		JWT
		  ↓
		服务器
		  ↓
		验证JWT
		  ↓
		JWT自己携带身份信息

![[ex_jwtandsession.png]]

### 为什么说 JWT 是“无状态”的
所谓：
> **无状态 Stateless**
> 
不是说服务器什么都不保存。

而是：
> **服务器不需要保存“这个 Access Token 对应哪个登录会话”的状态。**

### 但是 JWT 有一个巨大问题
 JWT Logout 后为什么还有效？

JWT 天生不擅长“立即撤销”

	12:11
	张三拿旧JWT访问
        ↓
	JWT签名正确
	JWT没有过期
        ↓
	服务器认为有效
### Redis 黑名单到底解决什么：
解决 JWT 无法立即撤销的问题。

### JWT + Redis 还算不算无状态
纯 JWT 是无状态认证；JWT + Redis 黑名单属于“部分有状态”架构

为现在服务器又保存了一部分状态：
```
Redis
 ↓
哪些Token已经被撤销
```

### Token 的三个核心生命周期操作
你可以记成：
```
签发
续期
撤销
```

### JWT Filter 做什么？
我们自己的 JWT Filter，本质上做：
```
拿Token
  ↓
解析Token
  ↓
验证Token
  ↓
检查黑名单
  ↓
找到用户
  ↓
加载权限
  ↓
创建Authentication
  ↓
放入SecurityContext
```
可以理解为：
> **Filter负责把“Token”翻译成“Spring Security认识的用户身份”。**

### 401 和 403 到底有什么区别
## 401 Unauthorized
本质：
> **你是谁？我不知道。**
例如：
```
没有Token
Token过期
Token签名错误
Token无效
```
流程：
```
请求
 ↓
认证失败
 ↓
401
```
## 403 Forbidden
本质：
> **我知道你是谁，但你没资格干这个事情。**
例如：
```
张三
 ↓
普通员工
 ↓
请求 DELETE /api/user/100
 ↓
没有 USER:DELETE
 ↓
403
```
所以记忆：
```
401 = 你是谁？
403 = 我知道你是谁，但你不能做。
```

### RBAC完整权限模型
User → Role → Permission

### Access Token + Refresh Token
> **Access Token = 临时通行证**
> **Refresh Token = 去办新通行证的凭证**
> 
             ┌─────────────────┐
             │ Access Token    │
             │ 短期 JWT        │
             └────────┬────────┘
                      ↓
                 API 请求

             ┌─────────────────┐
             │ Refresh Token   │
             │ 长期凭证        │
             └────────┬────────┘
                      ↓
                    Redis
                      ↓
                服务端可撤销