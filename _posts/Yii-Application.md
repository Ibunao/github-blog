---
title: Yii-Application
date: 2017-07-03 11:56:02
tags:
	- yii
	- 应用主体
categories:
    - yii
    - 应用主体
---

## 应用主体声明周期  
![声明周期](/images/yii/application-lifecycle.png)  
当运行 `入口脚本` 处理请求时， 应用主体会经历以下生命周期:

1. 入口脚本加载应用主体配置数组。
2. 入口脚本创建一个应用主体实例：
    * 调用 preInit() 配置几个高级别应用主体属性， 比如yii\base\Application::basePath。
    * 注册 yii\base\Application::errorHandler 错误处理方法.
    * 配置应用主体属性.
    * 调用 init() 初始化， 该函数会调用 bootstrap() 运行引导启动组件.
3. 入口脚本调用 yii\base\Application::run() 运行应用主体:
    * 触发 EVENT_BEFORE_REQUEST 事件。
    * 处理请求：解析请求 路由 和相关参数； 创建路由指定的模块、控制器和动作对应的类，并运行动作。
    * 触发 EVENT_AFTER_REQUEST 事件。
    * 发送响应到终端用户.
4. 入口脚本接收应用主体传来的退出状态并完成请求的处理。

> 应用主体是一个服务定位器  

配置  
> 应用主体 `Application` 的属性都可以在配置文件中进行配置   

组件 `components` 和 `bootstrap` 属性配置  
```php
[
    'bootstrap' => [
        // 将 log 组件 ID 加入引导让它始终载入
        'log',
    ],
    'components' => [
        'log' => [
            // "log" 组件的配置
        ],
    ],
]
```
> `components` 就像全局属全局变量，配置的组件在使用到的时候才初始化,且只实例化一次  
> `bootstrap` 每次启动的时候自动就初始化，如非每次请求都需要的组件，最好别加，造成额外的开销  

默认控制器  
'defaultRoute' => 'main',
