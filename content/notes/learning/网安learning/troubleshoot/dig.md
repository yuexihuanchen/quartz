`dig` = DNS 的“查询仪器

## 1. 查询域名
dig example.com
## 2. 简洁查询
dig example.com +shor
## 3. IPv4
dig example.com A
## 4. IPv6
dig example.com AAAA
## 5. 邮件服务器
dig example.com MX
## 6. DNS服务器
dig example.com NS
## 7. TXT
dig example.com TXT
## 8. 反向DNS
dig -x 8.8.8.8



                         DNS
                          │
                          ↓
                         dig
                          │
       ┌──────────────────┼──────────────────┐
       ↓                  ↓                  ↓
    查域名              查记录             查DNS
       │                  │                  │
       ↓                  ↓                  ↓
 example.com          A / AAAA             NS
                       CNAME                MX
                       TXT                  SOA
                       PTR
       │
       ↓
 ┌───────────────┐
 │ IP地址         │
 │ 邮件服务器     │
 │ DNS服务器      │
 │ 别名           │
 │ TXT信息        │
 │ TTL            │
 └───────────────┘


![[ex_dig.png]]