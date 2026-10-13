### Redis 不只是缓存
	① 缓存
	② 登录 Token / Session 辅助
	③ 验证码
	④ 限流
	⑤ 分布式锁
	⑥ Agent短期上下文
	⑦ 设备实时状态

冷热数据分离思路。
	MySQL
	↓
	保存设备档案

	Redis
	↓
	保存热点状态


Cache Aside
             查询
              ↓
           Redis？
         ↙       ↘
       有          没有
       ↓            ↓
    返回状态      MySQL
                    ↓
                 得到状态
                    ↓
                写Redis
                    ↓
                  返回


Redis 缓存一致性
Cache Update
	修改设备状态
      ↓
     MySQL
      ↓
	更新 Redis
      ↓
	返回成功
同时给 Redis 设置 **TTL**
	Redis
	 ↓
	300秒
	 ↓
	自动过期
	 ↓
	重新从 MySQL 获取
