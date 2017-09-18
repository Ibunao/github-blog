> component组件类是yii的核心基础类，`extends Object`   
> 实现了事件功能    

------
> 为了实现 行为 Behavior 对象的属性和方法的注入， component 重写了 object 中所有和 调用属性以及方法有关的方法  ，
原理很简单，就是在本 类 找不到的属性和方法，在绑定的行为里再找一遍  

例如：
```php
public function __call($name, $params)
{
    $this->ensureBehaviors();
    foreach ($this->_behaviors as $object) {
        if ($object->hasMethod($name)) {
            return call_user_func_array([$object, $name], $params);
        }
    }
    throw new UnknownMethodException('Calling unknown method: ' .
        get_class($this) . "::$name()");
}
```

## 事件
> $handler 事件处理程序  

### 相关属性  
```php
//绑定的事件及事件处理程序存储
private $_events = [];
```
### 事件的绑定  
```php
/**
 * 给事件绑定事件处理程序
 *
 * $handler 事件处理程序的格式
 *
 *
 * function ($event) { ... }         // anonymous function
 * [$object, 'handleClick']          // $object->handleClick()
 * ['\Page', 'handleClick']           // \Page::handleClick()
 * 'handleClick'                     // global function handleClick()
 *
 *
 * 事件处理程序必须是下面的这种形式，$event 是 Event 对象
 *
 *
 * function ($event)
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
## 行为  
> 将行为类中的属性和方法当做自己的使用  

> 行为需要行为类 Behavior 和 Component 类结合使用  

### 行为类Behavior
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
### 相关属性  
```php

private $_behaviors;
```

### 行为的绑定  
#### 静态方法绑定  
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
实现原理：  
component中大多数方法会调用 ensureBehaviors() 方法来确认绑定  
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
        $behavior->attach($this);
        $this->_behaviors[] = $behavior;
    } else {
        // 已经有一个同名的行为，要先解除，再将新的行为绑定上去。
        if (isset($this->_behaviors[$name])) {
            $this->_behaviors[$name]->detach();
        }
        $behavior->attach($this);
        $this->_behaviors[$name] = $behavior;
    }

    return $behavior;
}
```
##### 配置文件配置  
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

#### 动态方法绑定  
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
