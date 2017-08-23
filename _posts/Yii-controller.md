---
title: Yii-controller
date: 2017-07-03 11:56:02
tags:
	- yii
	- controller
categories:
    - yii
    - controller
---


## 控制器生命周期
处理一个请求时， 应用主体 会根据请求路由创建一个控制器， 控制器经过以下生命周期来完成请求：

在控制器创建和配置后，yii\base\Controller::init() 方法会被调用。
控制器根据请求动作ID创建一个操作对象:
如果动作ID没有指定，会使用default action ID默认操作ID；
如果在action map找到动作ID， 会创建一个独立动作；
如果动作ID对应操作方法，会创建一个内联操作；
否则会抛出yii\base\InvalidRouteException异常。
控制器按顺序调用应用主体、模块（如果控制器属于模块）、 控制器的 beforeAction() 方法；
如果任意一个调用返回false，后面未调用的beforeAction()会跳过并且动作执行会被取消； action execution will be cancelled.
默认情况下每个 beforeAction() 方法会触发一个 beforeAction 事件，在事件中你可以追加事件处理动作；
控制器执行动作:
请求数据解析和填入到动作参数；
控制器按顺序调用控制器、模块（如果控制器属于模块）、 应用主体的 afterAction() 方法；
默认情况下每个 afterAction() 方法会触发一个 afterAction 事件，在事件中你可以追加事件处理动作；
应用主体获取动作结果并赋值给响应.

设置默认动作  
public $defaultAction = 'home';

跳转  
return $this->redirect('http://example.com');

独立动作
> 渲染静态页面的时候使用它会方便一点  

独立动作通过继承yii\base\Action或它的子类来定义。 例如Yii发布的yii\web\ViewAction和yii\web\ErrorAction 都是独立动作。

要使用独立动作，需要通过控制器中覆盖yii\base\Controller::actions()方法在action map中申明， 如下例所示：

public function actions()
{
    return [
        // 用类来申明"error" 动作
        'error' => 'yii\web\ErrorAction',

        // 用配置数组申明 "view" 动作
        'view' => [
            'class' => 'yii\web\ViewAction',
            'viewPrefix' => '',
        ],
    ];
}
如上所示， actions() 方法返回键为动作ID、值为对应操作类名或数组configurations 的数组。 和内联动作不同，独立动作ID可包含任意字符， 只要在actions() 方法中申明.

为创建一个独立动作类，需要继承yii\base\Action 或它的子类，并实现公有的名称为run()的方法, run() 方法的角色和动作方法类似，例如：

<?php
namespace app\components;

use yii\base\Action;

class HelloWorldAction extends Action
{
    public function run()
    {
        return "Hello World";
    }
}
动作结果
动作方法或独立操作的run()方法的返回值非常重要， 它表示对应动作结果。

> Action类中有两个属性  `id` 和 `controller` 可以分别获取所在控制器的 `id` 和 此控制器对象  
