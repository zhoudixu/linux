```shell
]# git init /var/lib/git/project --bare
# 初始化一个名为project的裸露的空仓库

]# git remote -v
# 查看仓库信息

# 客户端用标记用户信息(并非git账户和密码)
]# git config --global user.email "tim@tedu.cn"
]# git config --global user.name "tim"
]# cat ~/.gitconfig
[user]
        email = tim@tedu.cn
        name = tim

# push.default定义如何推送
]# git config --global push.default simple
]# cat ~/.gitconfig
[user]
        email = tim@tedu.cn
        name = tim
[push]
        default = simple

]# git log
]# git log --pretty=oneline
]# git log --oneline

]# git branch hotfix	#创建分支
]# git checkout hotfix	#切换分支
]# git branch -d hotfix	#删除分支
]# git merge hotfix		#合并分支
#注：合并前，一定要切换到master分支
#系统无法合并分支，产生了冲突，可以查看有冲突的文件，直接修改有冲突的文件为最终需要的内容，然后再add ,commmit，push
```

