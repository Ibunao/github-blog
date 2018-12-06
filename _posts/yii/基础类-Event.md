---
title: 类级别事件    
date: 2018-11-09 00:00:02
tags:
    - yii
    - 事件Event
categories:
    - yii  
---

## 前言  
Event类有两个作用，一个是作为触发事件时携带的一个事件对象，另一个就是定义类级别的事件，其实和对象级别( `Component` 中定义)的基本一致  

**类级别和对象级别的事件有什么区别呢？**
1. 注册对象级别的事件，只能通过所注册的对象进行触发  
2. 注册的类级别的事件，可以触发的情况就比较多；
    1. 对象触发事件的时候在最后是调用一下类级别的触发事件 `Event::trigger()` ，如果该对象的 所有继承的父类、所有实现接口上绑定了这个事件，将会触发  
    2. 也就是说通过对象或类进行触发事件，如果对象或类的父类中或实现的接口中包含了当前注册事件的类，如果这个类有这个事件，将都会导致触发这个类注册的这个事件  

## 解析    
### 属性  

```php
public $name;               // 事件名
public $sender;             // 事件发布者，通常是调用了 trigger() 的对象或类。
public $handled = false;    // 是否终止事件的后续处理
public $data;               // 事件相关数据，事件绑定on时传递的数据
```
### 绑定类级别事件

```php
/**
 * 绑定类级别的事件
 *
 * 实例，在插入数据后触发记录日志
 *
 * Event::on(ActiveRecord::className(), ActiveRecord::EVENT_AFTER_INSERT, function ($event) {
 *     Yii::trace(get_class($event->sender) . ' is inserted.');
 * });
 * 
 *
 * @param string $class 类全名()
 * @param string $name 事件名称
 * @param callable $handler 事件处理程序
 * @param mixed $data 绑定时要传递的数据
 * @param bool $append 插入到事件处理数组的头部还是尾部
 */
public static function on($class, $name, $handler, $data = null, $append = true)
{
    $class = ltrim($class, '\\');
    if ($append || empty(self::$_events[$name][$class])) {
        self::$_events[$name][$class][] = [$handler, $data];
    } else {
		//数组头部插入
        array_unshift(self::$_events[$name][$class], [$handler, $data]);
    }
}
```
### 解绑事件  
```php
/**
 * 解绑类级别的事件
 *
 *
 * @param string $class 类全名
 * @param string $name 事件名称
 * @param callable $handler 事件处理程序
 * @return bool whether a handler is found and detached.
 */
public static function off($class, $name, $handler = null)
{
    $class = ltrim($class, '\\');
    if (empty(self::$_events[$name][$class])) {
        return false;
    }
		//解绑 class 上事件名为 $name 的所有事件处理程序 handler
    if ($handler === null) {
        unset(self::$_events[$name][$class]);
        return true;
    }

    $removed = false;
    foreach (self::$_events[$name][$class] as $i => $event) {
        if ($event[0] === $handler) {
            unset(self::$_events[$name][$class][$i]);
            $removed = true;
        }
    }
    if ($removed) {
				//重新排序数组，将unset掉的位置补上
        self::$_events[$name][$class] = array_values(self::$_events[$name][$class]);
    }
    return $removed;
}
```
```php
/**
 * 解绑所有事件
 */
public static function offAll()
{
    self::$_events = [];
}
```
### 触发事件  

```php
/**
 * 触发一个类级别的事件，同时会触发父类的和实现接口的同样的事件
 * This method will cause invocation of event handlers that are attached to the named event
 * for the specified class and all its parent classes.
 * @param string|object $class 对象或类全名
 * @param string $name  事件名称
 * @param Event $event 事件对象，用来携带数据
 */
public static function trigger($class, $name, $event = null)
{
    if (empty(self::$_events[$name])) {
        return;
    }
    if ($event === null) {
        $event = new static;
    }
    $event->handled = false;
    $event->name = $name;

    if (is_object($class)) {
        if ($event->sender === null) {
			//设置发送者
            $event->sender = $class;
        }
		//获取对象类名
        $class = get_class($class);
    } else {
        $class = ltrim($class, '\\');
    }
    // 将会触发当前类、所有继承的父类、所有实现接口上绑定的同一事件  
    $classes = array_merge(
        [$class],
		// 所继承的所有父类--祖祖辈辈
        class_parents($class, true),
		// 所实现的所有接口--祖祖辈辈
        class_implements($class, true)
    );
    foreach ($classes as $class) {
        if (empty(self::$_events[$name][$class])) {
            continue;
        }

        foreach (self::$_events[$name][$class] as $handler) {
            $event->data = $handler[1];
			// 执行事件处理程序
            call_user_func($handler[0], $event);
            if ($event->handled) {
                return;
            }
        }
    }
}
```
### 查看是事件的绑定
> 查看一个类在某个事件上是否绑定事件处理程序   

```php
/**
 *
 *
 * @param string|object $class 对象或类全名
 * @param string $name 事件名
 * @return bool whether there is any handler attached to the event.
 */
public static function hasHandlers($class, $name)
{
    if (empty(self::$_events[$name])) {
        return false;
    }
    if (is_object($class)) {
        $class = get_class($class);
    } else {
        $class = ltrim($class, '\\');
    }

    $classes = array_merge(
        [$class],
        class_parents($class, true),
        class_implements($class, true)
    );

    foreach ($classes as $class) {
        if (!empty(self::$_events[$name][$class])) {
            return true;
        }
    }

    return false;
}
```
