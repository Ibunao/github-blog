---
title: yii-apidoc的使用  
date: 2019-01-03 00:00:02
tags:
    - yii
    - yii-apidoc
categories:
    - yii  
---

## 前言  
我们可以通过 `yii-apidoc` 来通过反射拿取备注的方式生成类的说明文档，也可以根据md文件转换成说明文档，这里主要运用的是md来转换成使用文档，和 hexo 的原理一样    

## 安装apidoc  
[文档说明](https://github.com/yiisoft/yii2-apidoc)  

```php
composer require yiisoft/yii2-apidoc
```
安装的时候可能会进行报错  
```php
...
...

Your requirements could not be resolved to an installable set of packages.

  Problem 1
    - Conclusion: don't install yiisoft/yii2-apidoc 2.1.1
    - Conclusion: remove cebe/markdown 1.1.2
    - Installation request for yiisoft/yii2-apidoc ^2.1 -> satisfiable by yiisof
t/yii2-apidoc[2.1.0, 2.1.1].
    - Conclusion: don't install cebe/markdown 1.1.2
    - yiisoft/yii2-apidoc 2.1.0 requires cebe/markdown-latex ~1.0 -> satisfiable
 by cebe/markdown-latex[1.0.0, 1.1.0, 1.1.1, 1.1.2, 1.1.3, 1.1.4].

...
...
```
<!-- more -->
意思就是要删除 `cebe/markdown` 这个依赖包  
使用 `composer remove cebe/markdown` 删除，发现 **没用** 。 `composer.lock` 中依旧还有。好吧，我承认我的 composer 不太会用，直接在 `composer.lock` 中把 `cebe/markdown 1.1.2` 和 `phpdocumentor/reflection-docblock 3.3.2` 的包删除就可以进行安装了  

## 使用yii-apidoc  
`yii-apidoc` 有两个功能，一个是根据类的注释自动生成类的说明文档，生成结果可以参考 [yii-类参考文档](https://www.yiichina.com/doc/api/2.0/yii-base-arrayable) ，另一个就是根据 `md` 文档来生成文档，这个用处挺大我们主讲。

### 生成类的使用说明  
以项目的 `frontend` **文件夹下** 的类为列生成类说明文档
```
vendor/bin/apidoc api frontend classdoc
```
如果成功执行将会创建 `classdoc` 文件夹，里面存放着生成的类说明文档  
具体的注释格式可以参考 [apidoc 使用说明](https://www.jianshu.com/p/d324810d694d)

![图1](/images/yii/apidoc/apidoc1.png)


### 通过md文件生成文档  
将我们写的md文档生成html做成网站、也可以生成pdf，可以说非常方便 [参考](https://www.yiichina.com/tutorial/1097)  

我们举个例子以创建的 `sourcedocs` 文件加下的md文件为例
1. 首先我们要创建 `README.md` 文件，这个文件是一个目录文件  
```php
md文档测试
===============================
> 目录页 `===` 是必须要的

目录一
-----
*  [目录1.1](index.md)
*  [目录1.2](menu11.md)
*  [目录1.3](menu1/menu12.md)

balabala

目录二
-----
*  [目录2.1](menu2/menu21.md)
*  [目录2.2](menu2/menu22.md)
*  [目录2.3](menu2/menu23.md)

目录三
-----------
*  [目录3.1](menu3/menu31.md)
*  [目录3.2](menu3/menu32.md)

![图片](/images/apidoc1.png)
部署到站点才可以引用本地图片。
```
2. 创建链接对应的md文件  

3. 生成html  
```php
vendor/bin/apidoc guide sourcedocs mddoc
```

![图1](/images/yii/apidoc/apidoc1.png)

4. 生成pdf的自己测试，官方文档上有   


> 其实原理和hexo一样，将md按照模版转换成html，我们在熟悉之后可以对模版进行修改来更改外观  
> 有一点暇疵的是，根据目录归类后会导致点击目录的时候不选中当前，需要都放在一个目录下，如 `sourcedocs` 有时间可以看看改改  



### 千万别看  
[演示项目参考](https://github.com/Ibunao/yii-advance-learn)  

注意：
1. win平台的无法执行上面的命令，需要进入到 `vendor/bin` 内直接执行 `apidoc api @frontend classdoc`
2. linux和mac平台需要给 `apidoc` 文件赋予可执行权限  
