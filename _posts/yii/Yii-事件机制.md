---
title: Yii-事件机制
date: 2017-07-03 11:56:02
tags:
	- yii事件
categories:
    - yii
    - 事件
---

> 观察者模式的升级版吧，通过维护一个事件数组，来实现事件的绑定和通知的  

## 事件机制
> 一个对象抛出事件，另一个对象监听到事件后执行相应的动作  

实现方法：
1. 扫描式：一个对象发生事件，存入数组，然后另一个对象不断进行扫描
2. 绑定式 ：在一个数组中进行事件绑定，当一个事件发生时，直接触发对应的事件

yii用的绑定式  

绑定事件使用 `on()` 方法
触发事件使用 `trigger()` 方法      
**基本使用方法**  
![事件](/images/yii/event1.png)  

**触发事件时带有参数数据的情况**    
![事件](/images/yii/event2.png)  
```php
<?php
namespace *****;
use yii\base\Event;
/**
* event类，用来作为事件传递的参数
* 需要继承Event类
*/
class MyEvent extends Event
{
	//定义属性，用来传递值
	public $message;
}

```
**类级别的绑定**
![事件](/images/yii/event3.png)  

> 触发的方法都可以改为一个匿名函数  
