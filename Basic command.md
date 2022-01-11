# 常规命令

[toc]

## 监控相关

```shell
free -m 		#查看内存信息
swapon -s		#查看交换分区
df -h			#查看磁盘信息
uptime			#查看CPU信息 load average: 0.14, 0.52, 0.70 5分钟、10分钟、15分钟平均负载
ifconfig ethX	#查看网卡信息（需要net-tools软件包）
ss -ntulp		#查看端口信息
netstat -antpu	#查看端口信息

```

## Tar

```shell
tar命令压缩文件时，使用-p可保留文件的权限
```

