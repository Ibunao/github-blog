> component组件类是yii的核心基础类，`extends Object`   
> 实现了事件功能    

## 事件
> $handler 事件处理程序  

### 事件的绑定  
```php
/**
 * 给事件绑定事件处理程序
 *
 * $handler 事件处理程序的格式
 *
 * ```
 * function ($event) { ... }         // anonymous function
 * [$object, 'handleClick']          // $object->handleClick()
 * ['\Page', 'handleClick']           // \Page::handleClick()
 * 'handleClick'                     // global function handleClick()
 * ```
 *
 * 事件处理程序必须是下面的这种形式，$event 是 Event 对象
 *
 * ```
 * function ($event)
 * ```
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
     * ```php
     * [
     *     Model::EVENT_BEFORE_VALIDATE => 'myBeforeValidate',
     *     Model::EVENT_AFTER_VALIDATE => 'myAfterValidate',
     * ]
     * ```
     *
     * @return array events (array keys) and the corresponding event handler methods (array values).
     */
    public function events()
    {
        return [];
    }

    /**
     * 将行为和component对象绑定起来，并且将事件注册到component对象
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
