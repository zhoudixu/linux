[toc]

# rpm-build

## 安装rpm-build

```shell
]# yum -y install rpm-build
]# rpmbuild -ba test.spec //生成rpmbuild目录
```

## 准备源码软件

```shell
]# cp lnmp_soft/nginx-1.12.2.tar.gz rpmbuild/SOURCES/
```

## 编写编译配置文件

```shell
以nginx为例
]# yum -y install  gcc  make  pcre-devel  openssl-devel
vim  rpmbuild/SPECS/nginx.spec  //编写将nginx转换为rpm包的配置文件
Name:nginx     //软件名
Version:1.17.6    //版本
Release:1       //发布的rpm包的版本
Summary:test~    //简单描述
#Group:
License:GPL    //授权协议 ，GPL表示自由软件
URL:www.abc.com    //网址
Source0:nginx-1.17.6.tar.gz     //源码包 
#BuildRequires:   
#Requires:
%description    //详细描述
test~ test~ 
%post      //可以添加安装rpm包之后执行的命令，不是必须
useradd  nginx
%prep
%setup -q
%build
./configure  //配置，如果要添加选项或者模块可以继续写
make %{?_smp_mflags}     //编译
%install
make install DESTDIR=%{buildroot}    //安装
%files
%doc
/usr/local/nginx/*     //将改路径下文件打包成rpm
%changelog
```

## 编译RPM包

```shell
]# rpmbuild  -ba  rpmbuild/SPECS/nginx.spec  //根据上述文件制作rpm包
ls  rpmbuild/RPMS/x86_64/nginx-1.17.6-1.x86_64.rpm  //查看最终结果，已经产生nginx的rpm包则成功
```

