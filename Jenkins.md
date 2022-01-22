# Jenkins

[toc]

# 环境准备

```shell
]# dnf -y install git
]# dnf -y install postfix
]# dnf -y install mailx
]# dnf -y install java-11-openjdk
]# systemctl enable postfix --now
# Git（版本控制软件）、postfix（邮件服务器软件）、mailx（邮件客户端软件）、openjdk（Java JDK工具）
```

## 初始化

```shell
安装Jenkins包，配置service服务
]# dnf -y install ./jenkins-2.263.1-1.1.noarch.rpm
]# systemctl enable jenkins
]# systemctl start jenkins
# 设置jenkins服务为开机自启动服务，并立刻启动该服务
# Jenkins默认端口为8080 所以浏览器访问的端口就是8080
]# netstat -antpu | grep :8080
tcp6       0      0 :::8080                 :::*                    LISTEN      14014/java 
```

## 插件

```shell
]# grep jenkins /etc/passwd
jenkins:x:994:991:Jenkins Automation Server:/var/lib/jenkins:/bin/false
Jenkins插件目录为插件目录：/var/lib/jenkins/plugins/
请注意插件文件的权限必须为jenkins
]# ll /var/lib/jenkins/plugins/
total 18120
drwxr-xr-x. 4 jenkins jenkins      56 Jan 22 16:03 apache-httpcomponents-client-4-api
-rw-r--r--. 1 jenkins jenkins 1761975 Dec  9  2020 apache-httpcomponents-client-4-api.jpi
drwxr-xr-x. 4 jenkins jenkins      56 Jan 22 16:03 command-launcher
-rw-r--r--. 1 jenkins jenkins   38820 Dec  9  2020 command-launcher.jpi
drwxr-xr-x. 6 jenkins jenkins      82 Jan 22 16:03 credentials
-rw-r--r--. 1 jenkins jenkins  977742 Dec  9  2020 credentials.jpi

```

