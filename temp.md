hostnamectl set-hostname sql
nmcli connection modify eth1 ipv4.method manual ipv4.addresses 192.168.2.21/24
nmcli connection down eth1
nmcli connection up eth1

[10-Jan-2022 08:55:35 UTC] PHP Parse error:  syntax error, unexpected 'class' (T_CLASS), expecting identifier (T_STRING) or variable (T_VARIABLE) or '{' or '$' in /usr/local/nginx/html/wp-content/themes/hello-elementor/includes/elementor-functions.php on line 19



9. 启动nginx程序时，其命令选项( )可用于查看版本信息？

   A. -s

   B. -V

   C. -t

   D. -c

   **解析：**

   ```shell
   [root@web1 nginx]# sbin/nginx -h
   nginx version: nginx/1.17.6
   Usage: nginx [-?hvVtTq] [-s signal] [-c filename] [-p prefix] [-g directives]
   
   Options:
     -?,-h         : this help
     -v            : show version and exit
     -V            : show version and configure options then exit
     -t            : test configuration and exit
     -T            : test configuration, dump it and exit
     -q            : suppress non-error messages during configuration testing
     -s signal     : send signal to a master process: stop, quit, reopen, reload
     -p prefix     : set prefix path (default: /usr/local/nginx/)
     -c filename   : set configuration file (default: conf/nginx.conf)
     -g directives : set global directives out of configuration file
   
   1. ]# ./sbin/nginx -v
   nginx version: nginx/1.17.6
   
   2.]# ./sbin/nginx -V
   nginx version: nginx/1.17.6
   built by gcc 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC) 
   built with OpenSSL 1.0.2k-fips  26 Jan 2017
   TLS SNI support enabled
   configure arguments: --with-http_ssl_module --with-http_stub_status_module
   
   3.]# ./sbin/nginx -t
   nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
   nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
   
   4.]# ./sbin/nginx -T
   nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
   nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
   # configuration file /usr/local/nginx/conf/nginx.conf:
   ...
   # configuration file /usr/local/nginx/conf/mime.types:
   ...
   # configuration file /usr/local/nginx/conf/fastcgi.conf:
   ...
   5.]# ./sbin/nginx -s quit #优雅的停止Nginx服务（既处理完所有请求后在停止服务）
     ]# ./sbin/nginx -s stop #强制停止Nginx服务
     ]# ./sbin/nginx -s reopen #重新打开Nginx日志文件
     ]# ./sbin/nginx -s reload #程序加载配置文件（nginx.conf）
   ```

   

10. 在命令行中执行如下命令 #sed -i '1~2d' a.txt ，关于最后的执行结果，以下描述正确的是( )

    A. 删除文件中的第2行

    B. 删除文件中的前2行

    C. 删除文件中的第1行和第2行

    D. 删除文件中的奇数行

    解析：

    ```shell
    Sed commands can be given with no addresses, in which case the command will be executed for all input lines; 
    with one address, in which case the command  will only  be  executed for input lines which match that address; 
    or with two addresses, in which case the command will be executed for all input lines which match the inclusive range of lines starting from the first address and continuing to the second address. The  syntax  is addr1,addr2  (i.e.,  the addresses are separated by a comma);
    comma:逗号 colon: 冒号  单引号: single quotation marks  双引号: double quotation marks
    question mark: 问号
    quotation [kwoʊˈteɪʃn]
    question [ˈkwestʃən]
    
    first~step
    Match  every  step\'th  line  starting with line first.  For example, sed -n ‘1~2p’ will print all the odd-numbered lines in the input stream, and the address 2~5 will match every fifth line, starting with the second.  first can be zero; in this case, sed operates as if it were equal to  step.  
    Odd number 奇数
    even number 偶数
    
    
    ```

    

