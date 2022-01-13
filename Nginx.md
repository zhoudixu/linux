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

## Nginx状态页面

```shell
]# vim /usr/local/nginx/conf/nginx.conf
...
location /status {			# status自定义的网页路径
	stub_status on;			
	allow 192.168.4.0/24;	# 允许访问该网页的网段
	deny all;				# 拒绝谁访问该状态页面
}
```

## Nginx页面压缩处理

```shell
# 将服务器响应内容压缩后传输给客户端，可以节约服务器网络带宽
]# vim /usr/local/nginx/conf/nginx.conf
http {
.. ..
gzip on;                            //开启压缩
gzip_min_length 1000;                //小文件不压缩
gzip_comp_level 4;                //压缩比率
gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
                                    //对特定文件压缩，类型参考mime.types
.. ..
}
```

## Nginx服务器内存缓存

```shell
# 如果需要处理大量静态文件，可以将文件缓存在内存，下次访问会更快
http { 
open_file_cache          max=2000  inactive=20s;
        open_file_cache_valid    60s;
        open_file_cache_min_uses 5;
        open_file_cache_errors   off;
//设置服务器最大缓存2000个文件句柄，关闭20秒内无请求的文件句柄
//文件句柄的有效时间是60秒，60秒后过期
//只有访问次数超过5次会被缓存
} 
```

## Nginx隐藏版本号

```shell
# 请求头部信息中会显示Nginx的版本号
]# curl -I http://192.168.4.11/    # -I 只显示头部
HTTP/1.1 200 OK
Server: nginx/1.12.2
Date: Fri, 10 Dec 2021 07:51:08 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Fri, 10 Dec 2021 07:46:16 GMT
Connection: keep-alive
ETag: "61b305c8-264"
Accept-Ranges: bytes

# 隐藏版本信息
]# vim /usr/local/nginx/conf/nginx.conf
17 http {
18     server_tokens off;
... ...
再次访问不存在的路径，版本号消失
```

![image-20211012173446335](imgs/image-20211012173446335.png)

## 防止DOS,DDOS攻击

- 调整前

```shell
# 压力测试，每批次发送100个请求给web服务器，一共发200个
]# yum install -y httpd-tools
]# ab -c 100 -n 200 http://192.168.4.11/ 
... ...
Benchmarking 192.168.4.11 (be patient)
Completed 100 requests
Completed 200 requests
Finished 200 requests    # 发送200个请求完成
... ... 
Complete requests:      200   # 完成了200个请求
Failed requests:        0     # 0个失败
... ...
```

- 调整方法

```shell
# This is used to limit the request processing rate per a defined key, in particular, the processing rate of requests coming from a single IP address.
# 配置nginx连接共享内存为10M，每秒钟只接收一个请求，最多有5个请求排队，多余的拒绝
]# vim /usr/local/nginx/conf/nginx.conf
 17 http {
 18     limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;   # 添加
... ...
 37     server {
 38         listen       80;
 39         server_name  localhost;
 40         limit_req zone=one burst=5;  # 添加
[root@node1 ~]# /usr/local/nginx/sbin/nginx -s reload
```

![img](imgs/LINUXNSD_V01SECURITYDAY04_038.png)

- 验证

```shell
]# ab -c 100 -n 200 http://192.168.4.11/ 
... ...
Benchmarking 192.168.4.11 (be patient)
Completed 100 requests
Completed 200 requests
Finished 200 requests
... ...
Complete requests:      200
Failed requests:        194   # 失败了194个
... ...
```

## 拒绝某些类型的请求

- 用户使用HTTP协议访问服务器，一定是通过某种方法访问的。
- 最常用的HTTP方法
  - GET：在浏览器中输入网址、在页面中点击超链接、搜索表单。
  - POST：常用于登陆、提交数据的表单
- 其他HTTP方法不常用，如：
  - HEAD：获得报文首部。HEAD 方法和 GET 方法一样，只是不返回报文主体部分。
  - PUT：传输文件。要求在请求报文的主体中包含文件内容，然后保存到请求 URI 指定的位置。
  - DELETE：删除文件。DELETE 方法按请求 URI 删除指定的资源。

```shell
# 使用GET和HEAD方法访问nginx。两种方法都可以访问
[root@zzgrhel8 ~]# curl -i -X GET http://192.168.4.11/
[root@zzgrhel8 ~]# curl -i -X HEAD http://192.168.4.11/


# 配置nginx只接受GET和POST方法
[root@node1 ~]# vim /usr/local/nginx/conf/nginx.conf
... ...
 37     server {
 38         listen       80;
 39         if ($request_method !~ ^(GET|POST)$ ) {
 40             return 444;
 41         }
... ...
# $request_method是内置变量，表示请求方法。~表示正则匹配，!表示取反。^表示开头，$表示结尾，|表示或

[root@node1 ~]# /usr/local/nginx/sbin/nginx -s reload

# 使用GET和HEAD方法访问nginx。只有GET可以工作
[root@zzgrhel8 ~]# curl -i -X GET http://192.168.4.11/
[root@zzgrhel8 ~]# curl -i -X HEAD http://192.168.4.11/
```

## 防止缓冲区溢出

- 缓冲区溢出定义：程序企图在预分配的缓冲区之外写数据。
- 漏洞危害：用于更改程序执行流，控制函数返回值，执行任意代码。

```shell
# 配置nginx缓冲区大小，防止缓冲区溢出
[root@node1 ~]# vim /usr/local/nginx/conf/nginx.conf
... ...
 17 http {
 18     client_body_buffer_size     1k;
 19     client_header_buffer_size   1k;
 20     client_max_body_size        1k;
 21     large_client_header_buffers 2 1k;
... ...
[root@node1 ~]# /usr/local/nginx/sbin/nginx -s reload
```

