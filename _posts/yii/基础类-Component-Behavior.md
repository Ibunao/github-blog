---
title: Component实现行为和事件    
date: 2018-11-09 00:00:02
tags:
    - yii
    - 行为Behavior
    - 事件Event
categories:
    - yii  
---

## 前言  
`Component` 算是yii最核心的基础类了，同时实现了事件和 Behavior
`Component` 虽然继承与 `Object` ，但为了实现 Behavior 对象的属性和方法的注入， `Component` 重写了 `Object` 中所有和调用属性和方法有关的方法。原理也很简单，就是在当前对象找不到的属性或方法，在绑定的行为里再找一遍  

例如调用不存在的方法的时候
```php
public function __call($name, $params)
{
    // 先确保注册的behaviors绑定
    $this->ensureBehaviors();
    // 检查绑定的behaviors中有没有要调用的方法  
    foreach ($this->_behaviors as $object) {
        if ($object->hasMethod($name)) {
            return call_user_func_array([$object, $name], $params);
        }
    }
    throw new UnknownMethodException('Calling unknown method: ' .
        get_class($this) . "::$name()");
}
```
<!-- more -->
## Event-事件功能  
> $handler 事件处理程序  

### 相关属性  
```php
//绑定的事件及事件处理程序存储
private $_events = [];
```
### 事件的绑定  
```php
/**
 * 给当前对象的事件绑定事件处理程序
 *
 * $handler 事件处理程序的格式
 *
 * function ($event) { ... }         // anonymous function
 * [$object, 'handleClick']          // $object->handleClick()
 * ['\Page', 'handleClick']           // \Page::handleClick()
 * 'handleClick'                     // global function handleClick()
 *
 *
 * 事件处理程序必须是下面的这种形式，$event 是 Event 对象
 *
 * function ($event){}
 *
 *  
 * @param string $name 事件名称
 * @param callable $handler 事件处理程序
 * @param mixed $data 传递的数据
 * @param bool $append 插入到事件处理数组的头部还是尾部
 * @see off()
 */
public function on($name, $handler, $data = null, $append = true)
{
    //确定行为已将绑定
    $this->ensureBehaviors();
    if ($append || empty($this->_events[$name])) {
        $this->_events[$name][] = [$handler, $data];
    } else {
        //在数组开头插入
        array_unshift($this->_events[$name], [$handler, $data]);
    }
}
```
### 事件的解除  
```php
/**
 * 解绑事件
 *
 * @param string $name 事件名称
 * @param callable $handler 要解除的事件处理程序
 * @return bool if a handler is found and detached
 */
public function off($name, $handler = null)
{
    //确定行为绑定
    $this->ensureBehaviors();
    if (empty($this->_events[$name])) {
        return false;
    }
    if ($handler === null) {
        unset($this->_events[$name]);
        return true;
    }

    $removed = false;
    foreach ($this->_events[$name] as $i => $event) {
        if ($event[0] === $handler) {
            unset($this->_events[$name][$i]);
            $removed = true;
        }
    }
    if ($removed) {
        //重新排序数组，将unset掉的位置补上
        $this->_events[$name] = array_values($this->_events[$name]);
    }
    return $removed;
}
```
### 事件的触发  
```php

/**
 * 触发事件
 * 事件发生时，触发事件处理程序
 *
 * @param string $name 事件名称
 * @param Event $event 事件对象，如果没有给，将会创建 Event 对象
 */
public function trigger($name, Event $event = null)
{
    //确定行为绑定
    $this->ensureBehaviors();
    if (!empty($this->_events[$name])) {
        if ($event === null) {
            $event = new Event;
        }
        if ($event->sender === null) {
            //设置发送者
            $event->sender = $this;
        }

        $event->handled = false;
        $event->name = $name;

        foreach ($this->_events[$name] as $handler) {
            // 赋值要传递的数据
            $event->data = $handler[1];
            //调用事件处理程序handler
            call_user_func($handler[0], $event);
            // 如果在某一事件处理程序handler中将$event->handled设为true，将会不再执行后面的handler
            if ($event->handled) {
                return;
            }
        }
    }
    // 触发类一级的事件，触发绑定到这个class以及父类和父接口的这个事件
    Event::trigger($this, $name, $event);
}
```
### 查看事件是否绑定绑定  
```php
/**
 * Returns a value indicating whether there is any handler attached to the named event.
 * @param string $name the event name
 * @return bool whether there is any handler attached to the event.
 */
public function hasEventHandlers($name)
{
    //确定行为绑定
    $this->ensureBehaviors();
    return !empty($this->_events[$name]) || Event::hasHandlers($this, $name);
}
```

## 行为功能  
所为的行为就是将注册到当前component中的行为类的属性和方法当做自己的使用  
行为需要行为类 Behavior 和 Component 类结合使用  

### 相关属性  
```php

private $_behaviors;
```
### 注册行为的原理  
要使用行为肯定是先要进行注册的，component中大多数方法会调用 ensureBehaviors() 方法来先确认绑定，我们来看一下逻辑  
```php
/**
* 确保 [[behaviors()]] 绑定到这个component上
*/
public function ensureBehaviors()
{
   if ($this->_behaviors === null) {
       $this->_behaviors = [];
       foreach ($this->behaviors() as $name => $behavior) {
           $this->attachBehaviorInternal($name, $behavior);
       }
   }
}
/**
 * 将行为绑定到component对象
 * @param string|int $name 行为名字
 * @param string|array|Behavior $behavior the behavior to be attached
 * @return Behavior the attached behavior.
 */
private function attachBehaviorInternal($name, $behavior)
{
    // 不是 Behavior 实例，说是只是类名、配置数组，那么就创建出来
    if (!($behavior instanceof Behavior)) {
        $behavior = Yii::createObject($behavior);
    }
    // 匿名行为
    if (is_int($name)) {
        // 行为对象中定义的事件注册到当前对象
        $behavior->attach($this);
        $this->_behaviors[] = $behavior;
    } else {
        // 已经有一个同名的行为，要先解除，再将新的行为绑定上去。
        if (isset($this->_behaviors[$name])) {
            $this->_behaviors[$name]->detach();
        }
        // 行为对象中定义的事件注册到当前对象
        $behavior->attach($this);
        $this->_behaviors[$name] = $behavior;
    }

    return $behavior;
}
```
会发现在注册行为对象的时候，行为对象会把它里面定义的事件注册到当前对象  
### 使用行为的原理  
前面说了， `component` 为了实现行为，重写了 `Object` 中的属性以及其他方法，我们这里简单的看一下重写后的属性方法   
```php
/**
 * 重写了Object的 __get方法 为了兼用行为
 * Returns the value of a component property.
 * This method will check in the following order and act accordingly:
 *
 *  - a property defined by a getter: return the getter result
 *  - a property of a behavior: return the behavior property value
 *
 * Do not call this method directly as it is a PHP magic method that
 * will be implicitly called when executing `$value = $component->property;`.
 * @param string $name the property name
 * @return mixed the property value or the value of a behavior's property
 * @throws UnknownPropertyException if the property is not defined
 * @throws InvalidCallException if the property is write-only.
 * @see __set()
 */
public function __get($name)
{
    $getter = 'get' . $name;
    if (method_exists($this, $getter)) {
        // read property, e.g. getName()
        return $this->$getter();
    }
    /*
    检查绑定的behavior是否含有此属性
    */
    // 将behavior()中配置的behavior添加到_behaviors数组
    // behavior property
    $this->ensureBehaviors();
    foreach ($this->_behaviors as $behavior) {
        // 是否存在属性
        if ($behavior->canGetProperty($name)) {
            return $behavior->$name;
        }
    }

    if (method_exists($this, 'set' . $name)) {
        throw new InvalidCallException('Getting write-only property: ' . get_class($this) . '::' . $name);
    }

    throw new UnknownPropertyException('Getting unknown property: ' . get_class($this) . '::' . $name);
}

/**
 * 设置属性
 * Sets the value of a component property.
 * This method will check in the following order and act accordingly:
 *
 *  - a property defined by a setter: set the property value
 *  - an event in the format of "on xyz": attach the handler to the event "xyz"
 *  - a behavior in the format of "as xyz": attach the behavior named as "xyz"
 *  - a property of a behavior: set the behavior property value
 *
 * Do not call this method directly as it is a PHP magic method that
 * will be implicitly called when executing `$component->property = $value;`.
 * @param string $name the property name or the event name
 * @param mixed $value the property value
 * @throws UnknownPropertyException if the property is not defined
 * @throws InvalidCallException if the property is read-only.
 * @see __get()
 */
public function __set($name, $value)
{
    $setter = 'set' . $name;
    if (method_exists($this, $setter)) {
        // set property
        $this->$setter($value);

        return;
    /**
    下面这两个是在配置数组中有用到
    */
    // 如果以 on 开头，进行事件绑定
    } elseif (strncmp($name, 'on ', 3) === 0) {
        // on event: attach event handler
        $this->on(trim(substr($name, 3)), $value);

        return;
    // 如果以 as 开头 绑定行为
    } elseif (strncmp($name, 'as ', 3) === 0) {
        // as behavior: attach behavior
        $name = trim(substr($name, 3));
        $this->attachBehavior($name, $value instanceof Behavior ? $value : Yii::createObject($value));

        return;
    }
    // 看绑定的行为中是否存在此属性
    // behavior property
    $this->ensureBehaviors();
    foreach ($this->_behaviors as $behavior) {
        if ($behavior->canSetProperty($name)) {
            $behavior->$name = $value;
            return;
        }
    }

    if (method_exists($this, 'get' . $name)) {
        throw new InvalidCallException('Setting read-only property: ' . get_class($this) . '::' . $name);
    }

    throw new UnknownPropertyException('Setting unknown property: ' . get_class($this) . '::' . $name);
}
```
### 行为的绑定方式   
#### 静态的绑定  
##### 覆盖behaviors()
例如：
```php
class User extends ActiveRecord
{
    public function behaviors()
    {
        return [
            // 匿名的行为，仅直接给出行为的类名称
            MyBehavior::className(),

            // 名为myBehavior2的行为，也是仅给出行为的类名称
            'myBehavior2' => MyBehavior::className(),

            // 匿名行为，给出了MyBehavior类的配置数组
            [
                'class' => MyBehavior::className(),
                'prop1' => 'value1',
                'prop3' => 'value3',
            ],

            // 名为myBehavior4的行为，也是给出了MyBehavior类的配置数组
            'myBehavior4' => [
                'class' => MyBehavior::className(),
                'prop1' => 'value1',
                'prop3' => 'value3',
            ]
        ];
    }
}
```

##### 配置方式
这个通过配置方式创建对象( `Yii::createObject()` )时，由于不存在的成员变量时会调用 `Component` 的 `__set()` 方法，方法中会进行注册    
例如：
```php
[
    'as myBehavior2' => MyBehavior::className(),

    'as myBehavior3' => [
        'class' => MyBehavior::className(),
        'prop1' => 'value1',
        'prop3' => 'value3',
    ],
]
```

#### 动态的绑定  
调用组件(Compoent)的 `attachBehavior()` 方法  
`yii\base\Compoent::attachBehaviors()`  
```php
// 和静态绑定原理一样  
/**
 * 绑定单个
 **/
public function attachBehavior($name, $behavior)
{
    $this->ensureBehaviors();
    return $this->attachBehaviorInternal($name, $behavior);
}
/**
 * 绑定多个
 **/
public function attachBehaviors($behaviors)
{
    $this->ensureBehaviors();
    foreach ($behaviors as $name => $behavior) {
        $this->attachBehaviorInternal($name, $behavior);
    }
}
```
### 获取绑定的行为  
```php
//获取绑定的单个行为对象
$behavior = $Component->getBehavior('myBehavior2');
//获取所有绑定的行为对象
$behaviors = $Component->getBehaviors();
```

### 解除行为  
**解除单个**  
例如：`$Component->detachBehavior('myBehavior2');`  
```php
public function detachBehavior($name)
{
    $this->ensureBehaviors();
    if (isset($this->_behaviors[$name])) {
        $behavior = $this->_behaviors[$name];
        unset($this->_behaviors[$name]);
        // 解绑事件
        $behavior->detach();
        return $behavior;
    }

    return null;
}

```
**解除所有**  
例如：`$Component->detachBehaviors();`  
```php

/**
 * 解绑所有
 */
public function detachBehaviors()
{
    $this->ensureBehaviors();
    foreach ($this->_behaviors as $name => $behavior) {
        $this->detachBehavior($name);
    }
}
```
### 行为类Behavior  
行为类就比较简单了，实现的两个方法就是对事件的注册和解绑  

```php
class Behavior extends Object
{
    // 指向行为本身所绑定的Component对象
    public $owner;

    /**
     * 子类可以覆盖这个方法，返回一个要绑定到 component 对象上的事件
     *
     * The callbacks can be any of the following:
     *
     * - method in this behavior: `'handleClick'`, equivalent to `[$this, 'handleClick']`
     * - object method: `[$object, 'handleClick']`
     * - static method: `['Page', 'handleClick']`
     * - anonymous function: `function ($event) { ... }`
     *
     * The following is an example:
     *
     * php
     * [
     *     Model::EVENT_BEFORE_VALIDATE => 'myBeforeValidate',
     *     Model::EVENT_AFTER_VALIDATE => 'myAfterValidate',
     * ]
     *
     *
     * @return array events (array keys) and the corresponding event handler methods (array values).
     */
    public function events()
    {
        return [];
    }

    /**
     * 将行为和component对象绑定起来，并且将事件event注册到component对象
     */
    public function attach($owner)
    {
        $this->owner = $owner;
        foreach ($this->events() as $event => $handler) {
            $owner->on($event, is_string($handler) ? [$this, $handler] : $handler);
        }
    }

    /**
     * 解绑
     */
    public function detach()
    {
        if ($this->owner) {
            foreach ($this->events() as $event => $handler) {
                $this->owner->off($event, is_string($handler) ? [$this, $handler] : $handler);
            }
            $this->owner = null;
        }
    }
}
```
