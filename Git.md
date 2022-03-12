```shell
# 客户端用标记用户信息(并非git账户和密码)
]# git config --global user.email "tim@tedu.cn"
]# git config --global user.name "tim"
]# cat /root/.gitconfig
[user]
        email = tim@tedu.cn
        name = tim

# push.default定义如何推送
]# git config --global push.default simple

]# git branch hotfix	#创建分支
]# git checkout hotfix	#切换分支
]# git branch -d hotfix	#删除分支
]# git merge hotfix		#合并分支
#注：合并前，一定要切换到master分支
#系统无法合并分支，产生了冲突，可以查看有冲突的文件，直接修改有冲突的文件为最终需要的内容，然后再add ,commmit，push
```

