# 常规命令

[toc]

## 监控相关

```shell
free -m 		#查看内存信息
swapon -s		#查看交换分区
df -h			#查看磁盘信息
uptime			#查看CPU信息 load average: 0.14, 0.52, 0.70 5分钟、10分钟、15分钟平均负载。这个值不应长期大于1
ifconfig ethX	#查看网卡信息（需要net-tools软件包）
ss -ntulp		#查看端口信息
netstat -antpu	#查看端口信息

```

## Tar

```shell
tar命令压缩文件时，使用-p可保留文件的权限
```

## 查看内核

```shell
]# uname -r
4.18.0-193.el8.x86_64

]# cat /proc/version 
Linux version 4.18.0-193.el8.x86_64 (mockbuild@x86-vm-08.build.eng.bos.redhat.com) (gcc version 8.3.1 20191121 (Red Hat 8.3.1-5) (GCC)) #1 SMP Fri Mar 27 14:35:58 UTC 2020
```

