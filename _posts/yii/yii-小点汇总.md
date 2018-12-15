---
title: Yii-小点汇总
date: 2018-07-03 11:56:02
tags:
	- yii-小点汇总  
categories:
    - yii
    - 小点汇总
---

## 关于异常输出  
在出现异常的时候，Yii的异常处理默认是要将之前的输出清空，也就是说通过 `echo` 或 `var_dump` 打印的内容将会被清掉不输出到页面，可以通过设置 `ErrorHandler` 类的 `discardExistingOutput = false` 属性来保证输出  
```php
'components' => [
    ...
    ...
    'errorHandler' => [
        'errorAction' => 'site/error',
        'discardExistingOutput' => false
    ],
    ...
    ...
]
```

## 开启debug，但是前端页面关闭debug导航条  
我们只需要在渲染视图之前解绑debug模块注册的事件就可以  
```php
# 解绑事件
Yii::$app->view->off(\yii\web\View::EVENT_END_BODY, [\yii\debug\Module::getInstance(), 'renderToolbar']);
```
<!-- more -->
