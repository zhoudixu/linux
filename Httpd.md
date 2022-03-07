[toc]

# Httpd基本配置

## 虚拟web主机

```shell
]# vim /etc/httpd/conf.d/*.conf
#一旦使用虚拟Web主机功能，所有的网站都必须使用虚拟Web进行呈现，所以默认站点需要配置虚拟web主机
<VirtualHost *:80>
        ServerName server0.example.com
        DocumentRoot /var/www/html
</VirtualHost>

#基于域名的虚拟主机
<VirtualHost *:80>
        ServerName www0.example.com
        DocumentRoot /var/www/virtual
</VirtualHost>

#基于端口的虚拟主机
Listen 8888
<VirtualHost *:8888>
        ServerName www0.example.com
        DocumentRoot /var/www/lol
</VirtualHost>

```

