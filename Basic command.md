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

## Grep

```shell
用法: grep [选项]... PATTERN [FILE]...
-E, --extended-regexp     PATTERN is an extended regular expression
-G, --basic-regexp        PATTERN is a basic regular expression (default)
-i, --ignore-case         忽略大小写
-w, --word-regexp         强制PATTERN仅完全匹配字词,严格匹配
文件控制:
  -B, --before-context=NUM  打印文本及其前面NUM 行
  -A, --after-context=NUM   打印文本及其后面NUM 行
  -C, --context=NUM         打印NUM 行输出文本
#显示包含匹配chrony的前后5行
]# grep -i "chrony" /etc/passwd -C 5

#显示包含匹配chrony的前3行和后2行
]# grep -i "chrony" /etc/passwd -A 2 -B 3
qemu:x:107:107:qemu user:/:/sbin/nologin
usbmuxd:x:113:113:usbmuxd user:/:/sbin/nologin
rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
chrony:x:992:987::/var/lib/chrony:/sbin/nologin
setroubleshoot:x:991:985::/var/lib/setroubleshoot:/sbin/nologin
saslauth:x:990:76:Saslauthd user:/run/saslauthd:/sbin/nologin


```

## chage

更改用户密码过期信息

```shell
# 查看账号信息
]# chage -l root
最近一次密码修改时间					：从不
密码过期时间					：从不
密码失效时间					：从不
帐户过期时间						：从不
两次改变密码之间相距的最小天数		：0
两次改变密码之间相距的最大天数		：99999
在密码过期之前警告的天数	：7

# 设置账号过期日期
]# chage -E 2022-1-1 tom
]# chage -l tom
最近一次密码修改时间					：10月 12, 2021
密码过期时间					：从不
密码失效时间					：从不
帐户过期时间						：1月 01, 2022
两次改变密码之间相距的最小天数		：0
两次改变密码之间相距的最大天数		：99999
在密码过期之前警告的天数	：7
# EXPIRE_DATE 设置为 -1 会移除账户的过期日期
```

## Passwd

```shell
# 锁定tom账号
[root@node1 ~]# passwd -l tom
锁定用户 tom 的密码 。
passwd: 操作成功

[root@node1 ~]# passwd -S tom   # 查看状态
tom LK 2021-10-12 0 99999 7 -1 (密码已被锁定。)

# 解锁tom账号
[root@node1 ~]# passwd -u tom
解锁用户 tom 的密码。
passwd: 操作成功
[root@node1 ~]# passwd -S tom
tom PS 2021-10-12 0 99999 7 -1 (密码已设置，使用 SHA512 算法。)
```

## Chattr

```shell
# chattr changes the file attributes on a Linux file system
# 修改属性
chattr +i 文件    # 不允许对文件做任何操作，只能看
chattr -i 文件    # 去除i属性
chattr +a 文件    # 文件只允许追加
chattr -a 文件    # 去除a属性
```

## Lsattr

```shell
# lsattr lists the file attributes on a second extended file  system
]# lsattr /etc/passwd
-------------------- /etc/passwd	# 没有特殊属性
]# chattr +i /etc/passwd
]# lsattr /etc/passwd
----i----------- /etc/passwd
]# useradd zhangsan
useradd：无法打开 /etc/passwd
]# rm -f /etc/passwd
rm: 无法删除"/etc/passwd": 不允许的操作
```

