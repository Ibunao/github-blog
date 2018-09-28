---
title: Yii-开发第三方
date: 2017-07-07 11:56:02
tags:
	- 开发第三方
	- composer
	- packagist.org

categories:
    - yii
    - 开发第三方
---
[yii扩展文档](http://www.yiichina.com/doc/guide/2.0/structure-extensions)  

> 开发yii的第三方插件，放在 `packagist.org` 上供下载安装  
## 创建仓库  

![github创建仓库](/images/yii/kaifachajian1.png)
> 最好还是创建仓库的时候创建 readme.md ，这样就可以直接 clone 了

## 开发  
> 以 yii 的 advance 版本为例，开发富文本编辑器，富文本编辑器以 WangEidtor 为例  

在 `vendor` 文件夹下创建 一文件夹来放置 开发的插件，正常来表示开发人或机构，比如 `ibunao`  

进入到 `ibunao` 文件夹下，将 `github` 的仓库克隆到本地  
`ding:ibunao echo-ding$ git clone git@ibunao.github.com:Ibunao/yii-wangEditor.git
`
查看自己的推送权限  
```git
ding:yii-wangEditor echo-ding$ git remote -v
origin	git@ibunao.github.com:Ibunao/yii-wangEditor.git (fetch)
origin	git@ibunao.github.com:Ibunao/yii-wangEditor.git (push) 推送的权限
```

下载 [WangEditor](http://www.wangeditor.com) ，将文件夹改成 `vendor` 放置在 `yii-wangEditor`下  
> [WangEditor使用文档](https://www.kancloud.cn/wangfupeng/wangeditor) 翻墙查看  

创建 `composer.json` 文件  
```
{
    "name": "ibunao/yii2-weditor",
    "description": "wangEditor for yii",
    "type": "library",
    "keywords": ["wangEditor","yiieditor","editor","weditor"],
    "homepage": "https://github.com/echo-ding/yii2-wang-editor",
    "authors": [
        {
            "name": "丁冉",
            "email": "275122510@qq.com",
            "homepage": "http://www.bunao.me"
        }
    ],
    "require": {
        "php": ">=5.2"
    },
    "autoload": {
        "psr-4": { "weditor\\": "" }
    }
}
```
1. `name` 显示在 [PHP包管理网站](https://packagist.org/) 上的名称，composer安装的时候也是按照这个目录名创建的  
2. `require` 当前插件的依赖
3. `autoload` 自动加载 ，遵循 `psr-4` 规则，使用 `weditor` 可以直接访问到 `ibunao\yii2-weditor`下的文件类  

创建小部件 `InputWidget` 类型的小部件，可以作用在表单上  

创建接收上传图片的 独立动作  

> 详细代码查看  [插件源码](https://github.com/echo-ding/yii2-wang-editor)  

## 本地测试  
**引入自动加载**  
~~在 `/vendor/composer/autoload_psr4.php` 中添加 `'weditor\\' => array($vendorDir . '/ibunao/yii2-weditor'),` ;~~ 亲测不行    
> 表示用 `weditor` 来代替 `$vendorDir . '/ibunao/yii2-weditor`  命名空间   

在 `/vendor/yiisoft/extensions.php` 中添加
```php
'weditor' =>
array (
    'name' => '',
    'version' => '',
    'alias' =>
    array (
        '@weditor' => $vendorDir . '/ibunao/yii-wangEditor',
    ),
),
```
添加后就可以通过 `weditor` 命名空间来代替插件中 `ibunao/yii-wangEditor` ，并自动加载  

也可以通过配置文件 `/common/config/bootstrap.php` 进行配置自动加载  
```php
Yii::setAlias('@weditor', dirname(dirname(__DIR__)) . '/vendor/ibunao/yii-wangEditor');
```
> 这只是本地测试时这样写，上传之后通过composer安装就可以直接使用 插件的composer.json中配置的自动加载名来使用了  

本地测试成功后，写使用方法 readme.md ；上传到github  
```git
git add .
git commit -m 'test'
git push origin master
```

登陆到 [PHP包管理](https://packagist.org/packages/submit) ,提交github项目地址  
检查过之后提交  
![提交](/images/yii/kaifachajian2.png)   

此时还不能够使用composer进行安装，因为没有版本号  
**创建版本号**
```git
创建tag
git tag v0.0.1
推送到github
git push origin --tags
```
在 [packagist插件](https://packagist.org/packages/ibunao/yii2-weditor) 点击 `update` 进行更新，可以看到右下边显示出了版本号，之后就可以使用composer进行安装了  

composer安装了
> 本地项目删除自动加载，删除此插件  

进入到项目的个目录  
执行安装命令 `composer require ibunao/yii2-waneditor`

安装之后即可正常的使用(自动实现了自动加载)  

## 版本号自动更新（github和packagist之间）
访问：[配置](https://packagist.org/profile/)  
获取api token  

github配置  
![github添加配置](/images/yii/kaifachajian3.png)  
url格式  
`https://packagist.org/api/bitbucket?username=用户名&apiToken=xxxx`  

配置完成后， packagist上就不会再显示没有设置自动更新了，也可以添加tag进行测试  

测试完成，delete删除发布的
