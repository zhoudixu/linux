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
tar tvf 压缩文件名 可以查看压缩文件中每个文件的详细信息
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

## 后台运行脚步和程序

```shell
&：		将当前命令以后台的形式运行；
ctrl+z：	将前台任务转后台并冻结；
bg：		将后台冻结的任务再次运行起来；
fg：		将后台任务重新转前台执行；
nohup：	隔离终端挂断信号，是命令的前缀；
disown：	隔离终端挂断信号，事后使用；
setsid：	重新创建一个会话进程来执行任务；
(cmd)：	创建一个独立shell来执行命令；
jobs：	查看当前终端后台运行的任务,切换了终端就看不到了（包括关闭终端再重新打开也看不到的）
ps：		用于查看全局所有后台进程的信息；
kill：	杀掉某个进程；

解释：
1. &加在一个命令的最后，可以把当前行的命令放在后台执行。当非正常退出当前shell终端时（包括直接叉掉、杀死、直接注销关机等），后台运行的程序也会结束。这是因为脚本在后台运行时，运行脚本的父进程是当前shell终端进程，关闭当前shell终端时，会发送hangup挂断信号给子进程，子进程收到hangup信号后也就退出了

2. 命令前加上nohup可以让你退出shell之后继续运行相应的进程。nohup就是忽略当前任务挂断信号的意思。这样就解决上面的问题了。nohup默认会把标准输出重定向到默认文件nohup.out中。当然也可以自定义该输出，
例如：
nohup 程序/脚本 > /路径/自定义文件 &
如果输入nohup后不想打回车，可以使用下述方法：
nohup 程序/脚本 > /路径/自定义文件 2>&1 &
2>&1 是将错误提示信息的输出 重定向到 标准输出，而这里的标准输出已经重定向到/路径/自定义文件，也就是说标准的错误提示也直接输出到/路径/自定义文件，所以就没有提示了，也就不用再打回车了.
如果你的后台任务没有输出，你可以直接重定向到/dev/null
nohup 程序/脚本 > /dev/null 2>&1 &

3. disown也是隔离终端挂断信号，但主要用于事后使用。常通过jobs查询到任务号，然后disown -h 任务号

4. setsid是重新创建一个会话进程来执行任务。setsid可以起到和nohup类似的效果，但是setsid更彻底，所以严格上说setsid不是忽略终端关闭信号，而是这个后台任务创建之后就与当前终端没有关系了，所以当前终端的关闭自然不会影响到它。
使用方法：setsid 程序/脚本 &
和nohup还有一个区别就是，不用多打一个回车，因为它没有提示信息。

jobs -l 选项可以多显示一个PID信息
[root@localhost github]# jobs -l
[3]+ 39919 运行中               nohup firefox &
任务号	PID	状态					任务名称
ps -elf | grep 程序关键字
ps -aux | grep 程序关键字
kill -9 %N	杀掉通过jobs命令查看到任务号的后台进程
kill -9 PID ps命令查看任务PID，然后通过PID杀掉进程
```

