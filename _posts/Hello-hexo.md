---
title: Hello Hexo
date: 2017-06-29 11:56:02
tags:
	- begin
categories: hello world
---


> 文章md头部设置

```
---
title: test	 #标题名称
date: 2017-06-29 11:56:02  #时间
tags: 		#创建标签
	- Testing	#标签名称
	- begin		#标签名称
categories: hello hexo #分类

---
```

> 添加图片

```
在source下创建images文件夹。

!['tupian'](/images/my.jpg)  
images 是source下的文件夹

也可以吧图片放在七牛进行引用。

```

## 使用

> **进入到目录**
> 没有权限的加 sudo  

```
/Users/echo-ding/Documents/ding/www/github-blog
```
创建文章  
```
hexo new "My New Post" #my new post 为文章名  
```
也可以直接在source中创建md文档  

启动服务  
```
hexo server
```
生成文件(md转成html)
```
hexo generate
```
推送到远端  
```
hexo deploy
```

> 写博客   

写完之后直接。
生成文件(md转成html)
```
hexo generate
```
推送到远端  
```
hexo deploy
```


本地测试(s 就是 server的缩写)  

```
hexo s --debug #默认以4000端口启动
sudo hexo s --debug -p 80 #以80端口启动
```

代码高亮

> 在代码块开头后添加php表示php代码，用来高亮显示。

!["高亮"](/images/hello/daimakuai.png)
```php
class ClassName extends AnotherClass
{

	public function FunctionName($value='')
	{
		echo "string";
	}
}

```
<!--
!['tupian'](/images/my.jpg)
-->
