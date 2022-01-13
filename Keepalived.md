# Keepalived

- VRRP-高可用
- LVS-DR搭建

## 软件

```shell
yum -y install haproxy
```

## 配置

```shell
12    router_id proxy2 		# 修改route_id
13    vrrp_iptables 		# 增加iptables放行

20 vrrp_instance VI_1 {
21     state BACKUP  		# MASTER为主，BACKUP为副
22     interface eth0 		# 注意网卡名
23     virtual_router_id 51
24     priority 50			# VRRP优先级
25     advert_int 1
26     authentication {
27         auth_type PASS
28         auth_pass 1111
29     }
30     virtual_ipaddress {
31         192.168.4.80/24	# VIP地址
32     }
33 } 
```

## 验证

```shell
]# ip a s eth0 | grep '4.80'
    inet 192.168.4.80/24 scope global secondary eth0
```

