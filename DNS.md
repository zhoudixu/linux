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

```shell
1.服务器端
#保证named用户对地址库文件有读取权限
]# cp -p /var/named/named.localhost /var/named/tedu.cn.zone
]# ll /var/named/tedu.cn.zone
-rw-r-----. 1 root named 152 6月  21 2007 /var/named/tedu.cn.zone
]# vim /etc/named.conf
options {
        directory       "/var/named";	#定义地址库文件存放路径
};
zone "tedu.cn" IN {	#定义负责的解析tedu.cn域名
        type master;	#权威主DNS服务器
        file "tedu.cn.zone";	#地址库文件名称
};	

#所有的域名都要以点作为结尾，如果没有以点作为结尾，那么默认补全本地库文件负责的域名
]# vim /var/named/tedu.cn.zone
$TTL 1D	#Time To Live 生存时间
@       IN SOA  @ rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
tedu.cn.        NS      svr7	#NS 域名服务器记录
svr7            A       192.168.4.5	# A 地址address记录，仅用于正向解析
www             A       1.1.1.1
ftp             A       2.2.2.2
ppp             A       3.3.3.3

2.客户端
修改]# vim /etc/resolv.conf

```

#### 多区域的DNS服务器

```shell
1.服务器端
]# vim /etc/named.conf
options {
        //listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
};
zone "tedu.cn" IN {
        type master;
        file "tedu.cn.zone";
};
zone "lol.com" IN {
        type master;
        file "lol.com.zone";
};

]# cp -p /var/named/tedu.cn.zone /var/named/lol.com.zone
]# vim /var/named/lol.com.zone
$TTL 1D
@       IN SOA  @ rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
lol.com.        NS      svr7
svr7            A       192.168.4.5
www             A       11.1.1.1
xixi            A       22.2.2.2
haha            A       33.3.3.3

]# systemctl restart named


```



#### DNS轮询（负载均衡）

> 基于DNS的站点负载均衡
>
> - 一个域名---->多个不同IP地址
> - 每个IP提供镜像服务内容

```
1.服务器端
]# vim /var/named/tedu.cn.zone
$TTL 1D
@       IN SOA  @ rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
tedu.cn.        NS      svr7
svr7            A       192.168.4.5
www             A       1.1.1.1
www             A       1.1.1.2
www             A       1.1.1.3

```



#### 泛域名解析

> 匹配本域内未定义的任何主机i地址
>
> 直接以*条目匹配，一般指用在正向区域文件中

```shell
1.服务器端
]# vim /var/named/tedu.cn.zone
$TTL 1D
@       IN SOA  @ rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
tedu.cn.        NS      svr7
svr7            A       192.168.4.5
www             A       1.1.1.1
www             A       1.1.1.2
www             A       1.1.1.3
ftp             A       2.2.2.2
ppp             A       3.3.3.3
*               A       8.8.8.8
tedu.cn.        A       9.9.9.9


2.客户端
]# nslookup dkdkdfsk.tedu.cn
Server:         192.168.4.5
Address:        192.168.4.5#53

Name:   dkdkdfsk.tedu.cn
Address: 8.8.8.8


~]# nslookup tedu.cn
Server:         192.168.4.5
Address:        192.168.4.5#53

Name:   tedu.cn
Address: 9.9.9.9

```

#### 有规律的泛域名解析

```shell
**DNS****有规律的泛域名解析**

pc1.tedu.cn ---->192.168.10.1

pc2.tedu.cn ---->192.168.10.2

pc3.tedu.cn ---->192.168.10.3

pc4.tedu.cn ---->192.168.10.4

  ..........

pc50.tedu.cn ---->192.168.10.50

]# vim   /var/named/tedu.cn.zone
……此处省略一万字
$GENERATE  1-50     pc$      A     192.168.10.$

#$GENERATE内置函数（提供造数功能）

```



#### 别名

```
]# vim   /var/named/tedu.cn.zone
$TTL 1D
@       IN SOA  @ rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
tedu.cn.        NS      svr7
svr7            A       192.168.4.5
www             A       1.1.1.1
www             A       1.1.1.2
www             A       1.1.1.3
ftp             A       2.2.2.2
ppp             A       3.3.3.3
*               A       8.8.8.8
tedu.cn.        A       9.9.9.9
vip     CNAME           ftp	#vip解析结果与ftp解析结果一致


2.客户端
[root@localhost ~]# nslookup ftp.tedu.cn
Server:         192.168.4.5
Address:        192.168.4.5#53

Name:   ftp.tedu.cn
Address: 2.2.2.2

[root@localhost ~]# nslookup vip.tedu.cn
Server:         192.168.4.5
Address:        192.168.4.5#53

vip.tedu.cn     canonical name = ftp.tedu.cn.
Name:   ftp.tedu.cn
Address: 2.2.2.2


```



#### 递归查询和迭代查询

> 递归查询：客户端发送请求给首选DNS服务器，首选DNS服务器与其他的DNS服务器交互，最终将解析结果带回来过程
>
> 迭代查询: 客户端发送请求给首选DNS服务器，首选DNS服务器告知下一个DNS服务器地址

```shell
1.虚拟机A:子域授权

$TTL 1D
@       IN SOA  @ rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
tedu.cn.        NS      svr7
bj.tedu.cn.     NS      svr8
svr7            A       192.168.4.5
svr8            A       192.168.4.6
www             A       1.1.1.1
www             A       1.1.1.2
www             A       1.1.1.3
ftp             A       2.2.2.2
ppp             A       3.3.3.3
*               A       8.8.8.8
tedu.cn.        A       9.9.9.9
vip     CNAME           ftp

2.虚拟机B

]# vim /etc/named.conf
options {
        directory       "/var/named";
};
zone "bj.youku.com" IN {
        type master;
        file "bj.tedu.cn.zone";
};

]# cp -p /var/named/named.localhost /var/named/bj.tedu.cn.zone
]# vim /var/named/bj.tedu.cn.zone
$TTL 1D
@       IN SOA  @ rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
bj.youku.com.   NS      svr8
svr8            A       192.168.4.6
www             A       5.5.5.5
nnn             A       6.6.6.6


3.客户机
]# nslookup www.bj.tedu.cn
Server:         192.168.4.5
Address:        192.168.4.5#53

Non-authoritative answer:	#非权威解答
Name:   www.bj.tedu.cn
Address: 5.5.5.5


虚拟机A:禁止递归查询

options {
        directory       "/var/named";
        recursion no;    #禁止递归查询
};


```

### 缓存DNS

```shell
#全局转发式缓存，
#以转发至202.106.0.20; 8.8.8.8为例，前提是缓存DNS和上述DNS之间网络畅通
]# vim /etc/named.conf	#该配置文件只需要以下内容即可实现DNS缓存
options {
        directory       "/var/named";
        forwarders { 202.106.0.20; 8.8.8.8; };
};

#客户端机器的DNS指向缓存DNS服务器的IP即可
]# nslookup www.baidu.com
Server:         192.168.4.5
Address:        192.168.4.5#53

Non-authoritative answer:
www.baidu.com   canonical name = www.a.shifen.com.
www.a.shifen.com        canonical name = www.wshifen.com.
Name:   www.wshifen.com
Address: 103.235.46.39
```

### 主从DNS

- 主DNS

  ```shell
  ]# /etc/named.conf
  options {
       directory       "/var/named";
       allow-transfer  {  192.168.4.207;   }; #允许谁进行传输数据
  };
  zone "lol.com" IN {
          type master;
          file "lol.com.zone";
  };
  
  
  ]# /var/named/lol.com.zone
   ……此处省略一万字
  lol.com.   NS   svr7
  lol.com.   NS   pc207            #声明从DNS服务器
  svr7         A     192.168.4.7
  pc207      A     192.168.4.207
  www        A     4.4.4.4
  
  ```

  

- 从DNS

  ```shell
  ]# vim   /etc/named.conf
  options  {
          directory       "/var/named";
  };
  zone  "lol.com"  IN  {
    type   slave;               #类型为从服务器
    file "/var/named/slaves/lol.com.slave";  #确保named用户有读写执行权限
    masters { 192.168.4.7; };   #指定主DNS服务器
    masterfile-format text;     #地址库文件明文存储
  };
  ```

- 主从数据同步

  ```shell
  2021111601     ; serial  #数据的版本号，由10个数字组成
         1D      ; refresh #每隔1天主从进行交流
         1H      ; retry  #失效之后的时间间隔每一个1小时
         1W      ; expire #真正的失效时间，1周
         3H )    ; minimum  #失效记录的记忆时间3小时
  #修改主DNS的版本serial号，然后重启named，可以实现主从数据立刻同步
  ```

  