# Postfix邮件服务

[toc]

## DNS服务

```shell
#虚拟机A：DNS服务器，添加邮件解析功能
]# vim /etc/named.conf
options {
        directory       "/var/named";
};
zone  "qq.com"   IN   {
         type   master;
         file   "qq.com.zone";
};

]# cd /var/named/
]# cp -p  named.localhost  qq.com.zone
]# vim   qq.com.zone
...
qq.com.   NS           	svr7
qq.com.   MX   10   	mail       #数字10为优先级，越小越优先
svr7      A             192.168.4.7
mail      A             192.168.4.7
www       A             1.1.1 


]# host  -t  MX  qq.com         #测试qq.com区域邮件交换记录
qq.com mail is handled by 10 mail.qq.com.
]# host mail.qq.com              #测试域名完整解析
mail.qq.com has address 192.168.4.7
```



## postfix设置

```shell
#邮件服务器
]# rpm -q postfix
]# vim  /etc/postfix/main.cf
99  myorigin = qq.com     #默认补全的域名后缀
116 inet_interfaces =  all #本机所有IP地址均提供邮件收发功能
164 mydestination = qq.com    #判断是否为本域邮件的依据
]# systemctl  restart  postfix
```

