# Haproxy

[toc]

## 软件

```shell
yum -y install haproxy
```

## 负载均衡配置

```shell
vim /etc/haproxy/haproxy.cfg
]# vim /etc/haproxy/haproxy.cfg 
# 删除63行到结尾，然后追加以下内容
listen wordpress *:80
    balance roundrobin
    server web1 192.168.2.11:80 check inter 2000 rise 2 fall 3
    server web2 192.168.2.12:80 check inter 2000 rise 2 fall 3
    server web3 192.168.2.13:80 check inter 2000 rise 2 fall 3
[root@proxy ~]# systemctl enable haproxy.service --now
[root@proxy ~]# ss -tlnp | grep :80
LISTEN     0      128          *:80
```

## 监控页面

```shell
]# vim /etc/haproxy/haproxy.cfg 
# 在结尾追加以下内容
listen mon *:1080
    stats refresh 30s
    stats uri /mon
    stats realm Haproxy Manager
    stats auth admin:admin
[root@proxy ~]# systemctl restart haproxy
# 访问http://192.168.4.5:1080/mon。不断访问http://192.168.4.5，在监控页可以看到不同的服务器有连接数。
```

