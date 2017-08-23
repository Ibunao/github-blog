---
title: Yii-module模块化
date: 2017-07-03 11:56:02
tags:
	- yii-module
categories:
    - yii
    - module
---

**模块化技术**
> 将项目分成若干个小项目，配合使用，每个模块都是一个mvc  
父模块下需要有相关 子模块的的开启和关闭功能的配置文件  

可以使用gii快速生成模块;  
例如：  
```php
class:  app\modules\article\Article           
module id:    article
```
再生成它的子模块article模块下的category模块  
```php
class:    app\modules\article\modules\category\Catejory   
module id:   catejory
```
在生成信息的下面会出现配置信息，需要复制到配置信息，来开启模块功能(全局模块)
```php
'modules' => [
    'article' => [
        'class'=>'app\modules\article\Article',
    ],
],
```
可以通过 `?r=article/controller/action` 来访问 `article` 下的控制器与方法  

父模块中开启子模块(局部模块)
父模块中的 `Article.php` 类中配置  
```php
public function init()
{
    parent::init();
    //配置子模块。
    $this->modules = [
        'category' => [
            'class' => 'app\modules\article\modules\category\Category'
            ],
    ];
}
```
在父模块中进行配置可以通过一下方式进行访问 `?r=article/category/controller/action` 进行访问

**通过模块，运行模块中控制器的方法**  
在父模块的控制器中可以获取子模块并操作子模块
```php
//获取子模块
$article = \\YII::$app->getModule('article');//通过模块的id获取
//调用子模块的操作
$article->runAction('default/index');//操作default控制器下的index操作
```
