# 域名解析

[^正向解析]: 根据注册的域名查找对应的IP地址
[^反向解析]: 根据IP地址查找对应的注册域名

DNS服务器分类：根域名服务器、一级DNS服务器、二级DNS服务器、三级DNS服务器



[toc]

## 修改hosts

```shell
echo -e "ip_address\tFQDN" >> /etc/hosts
# \t转义字符 tab
# FQDN	域名
```



## DNS

### 安装软件

```shell
yum -y install bind bind-chroot
]# systemctl enable named --now
# DNS协议默认端口：TCP/UDP 53
```

### 配置

#### 基础配置

#### 多区域的DNS服务器

#### DNS轮询（负载均衡）

#### 泛域名解析

#### 别名

#### 递归查询和迭代查询

### 架构

#### 主从架构