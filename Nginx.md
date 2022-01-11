# Nginx

[toc]

## Nginx自动启动配置

### 配置为service服务

```shell
[root@centos7 ~]# vim /usr/lib/systemd/system/nginx.service
[Unit]
Description=The Nginx HTTP Server	#描述信息
After=network.target remote-fs.target nss-lookup.target
#指定启动nginx之前需要其他的其他服务，如network.target等
[Service]
Type=forking	#Type为服务的类型，仅启动一个主进程的服务为simple，需要启动若干子进程的服务为forking
ExecStart=/usr/local/nginx/sbin/nginx	#设置执行systemctl start nginx后需要启动的具体命令.
ExecReload=/usr/local/nginx/sbin/nginx -s reload
#设置执行systemctl reload nginx后需要执行的具体命令.
ExecStop=/bin/kill -s QUIT ${MAINPID}
#设置执行systemctl stop nginx后需要执行的具体命令.
[Install]
WantedBy=multi-user.target
```

### 加入开机自启动项目

```shell
echo "/usr/local/nginx/sbin/nginx" >> rc.d/rc.local
```

## Apache

​		动态网站运行过程中，php脚本需要对网站目录有读写权限，而php-fpm默认启动用户为apache。 php程序是由php-fpm处理的，php-fpm以apache身份运行。为了让php-fpm程序能对html目录进行读写操作，需要为他授予权限。

```shell
]# ps aux | grep php-fpm
root       476  0.0  0.7 329944 10224 ?        Ss   08:58   0:00 php-fpm: master process (/etc/php-fpm.conf)
apache     648  0.0  2.5 361384 36956 ?        S    08:58   0:06 php-fpm: pool www
apache     649  0.0  3.0 368556 44244 ?        S    08:58   0:07 php-fpm: pool www
apache     650  0.0  0.9 337828 13328 ?        S    08:58   0:06 php-fpm: pool www
apache     651  0.0  2.3 359100 34564 ?        S    08:58   0:07 php-fpm: pool www
apache     652  0.0  3.1 370380 46088 ?        S    08:58   0:06 php-fpm: pool www
apache     902  0.0  2.5 361888 37008 ?        S    09:22   0:07 php-fpm: pool www
apache    2349  0.0  3.0 369384 44644 ?        S    13:07   0:02 php-fpm: pool www

```

