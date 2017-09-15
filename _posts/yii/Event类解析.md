> 类级别事件，和对象界别的相似， 都是通过数组来实现的  
> 同时也是触发事件trigger时携带event对象(携带要传递的数据)的父类  
> 对象界别的事件是在 `component` 类中实现的
### 属性  

```php
public $name;               // 事件名
public $sender;             // 事件发布者，通常是调用了 trigger() 的对象或类。
public $handled = false;    // 是否终止事件的后续处理
public $data;               // 事件相关数据，事件绑定on时传递的数据
```
### 绑定事件

```php
/**
 * 绑定类级别的事件
 *
 * 实例，在插入数据后触发记录日志
 * ```php
 * Event::on(ActiveRecord::className(), ActiveRecord::EVENT_AFTER_INSERT, function ($event) {
 *     Yii::trace(get_class($event->sender) . ' is inserted.');
 * });
 * ```
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

    $classes = array_merge(
        [$class],
				//父类
        class_parents($class, true),
				//接口
        class_implements($class, true)
    );

    foreach ($classes as $class) {
        if (empty(self::$_events[$name][$class])) {
            continue;
        }

        foreach (self::$_events[$name][$class] as $handler) {
            $event->data = $handler[1];
						//执行事件处理程序
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
