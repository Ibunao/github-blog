---
title: Hello Hexo
date: 2017-06-29 11:56:02
tags:
	- hexo
categories: hexo
---

## 特别声明
### 文章md头部设置

```
---
title: test	 #标题名称
date: 2017-06-29 11:56:02  #时间
tags: 		#创建标签
	- Testing	#标签名称
	- begin		#标签名称
categories: hello hexo #分类

---

# 多级分类格式示例  
categories: 
    - 工具  
    - Atom  
```

### 添加图片

```
在source下创建images文件夹。

!['tupian'](/images/my.jpg)  
images 是source下的文件夹

也可以吧图片放在七牛进行引用。

```
<!-- more -->
## 使用
详细操作请转到 [hexo官方文档](https://hexo.io/zh-cn/docs/commands)  
下面只用到一些基础的操作  

第一步：先进入到博客目录  

> 没有权限的加 sudo  

```
/Users/echo-ding/Documents/ding/www/github-blog
```
第二步：创建文章  
```
hexo new "My New Post" #my new post 为文章名  
```
> **也可以直接在source中创建md文档(一般用这个)**  

第三步：启动服务(为了先本地预览)  
```
hexo server
```
简写&带参数
```
hexo s --debug #默认以4000端口启动
sudo hexo s --debug -p 80 #以80端口启动
```
第四部：生成文件(md转成html)
```
hexo generate
```
第五部：推送到远端  
```
hexo deploy
```

> 如果不需要本地预览，就可以省略第三步了，直接生成、上传


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
