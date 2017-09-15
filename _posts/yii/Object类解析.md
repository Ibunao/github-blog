## class
> `yii\base\Object`
> `implements Configurable` 实现一个空接口
## 方法解析

### 构造函数--配置对象
> 可以通过配置来实现  

```php
public function __construct($config = [])
{
    if (!empty($config)) {
        Yii::configure($this, $config);
    }
    $this->init();    //调用初始化方法
}
//Yii::configure($this, $config); 给对象的属性赋值
yii\Yii extends yii\BaseYii;
public static function configure($object, $properties)
{
    foreach ($properties as $name => $value) {
        $object->$name = $value;
    }
    return $object;
}
```
### 获取类名  
> 获取当前类的类名包含命名空间  

```php
public static function className()
{
    //后期绑定的类的名称，也就是继承Object类的子类调用此方法是获取的是子类的类名
    return get_called_class();
}
```
示例
```php
namespace app\controllers;

use Yii;
use yii\web\Controller;

class TestController extends Controller
{
  	public function actionTest()
  	{
  		  echo $this->className();
  	}
}

输出
app\controllers\TestController
```
### 魔术方法  
> 属性和成员变量的区别，简单的来理解成员变量是反应结构的(也就是代码实体)，而属性来反应概念的(成员变量的含义)
[详解](http://www.digpage.com/property.html#)    

> 在读取和写入对象的一个不存在的成员变量时，` __get() __set() `会被自动调用。 Yii正是利用这点，提供对属性的支持的。  

> 可以实现成员变量的只读或只写功能



#### `__get()`  
当成员变量不存在或者为私有的时候，**获取** 值时调用这个方法  
> 可以实现一个好处是，如果需要对输出的成员变量的值做一定的处理可以在对应的 `getXXX()` 方法中实现  

```php
public function __get($name)
    {
        $getter = 'get' . $name;
        if (method_exists($this, $getter)) {
            return $this->$getter();
        } elseif (method_exists($this, 'set' . $name)) {
            throw new InvalidCallException('Getting write-only property: ' . get_class($this) . '::' . $name);
        } else {
            throw new UnknownPropertyException('Getting unknown property: ' . get_class($this) . '::' . $name);
        }
    }
```
#### `__set()`  
当成员变量不存在或者为私有的时候，**设置** 值时调用这个方法  
> 可以实现一个好处是，如果需要对赋值的成员变量的值做一定的处理可以在对应的 `setXXX()` 方法中实现，比如用 `trim()`去除空格  

```php
public function __set($name, $value)
{
    $setter = 'set' . $name;
    if (method_exists($this, $setter)) {
        $this->$setter($value);
    } elseif (method_exists($this, 'get' . $name)) {
        throw new InvalidCallException('Setting read-only property: ' . get_class($this) . '::' . $name);
    } else {
        throw new UnknownPropertyException('Setting unknown property: ' . get_class($this) . '::' . $name);
    }
}
```  
#### `__isset()`
测试属性是否存在且值不为 null ，在 `isset($object->property)` 时被自动调用。   
```php
public function __isset($name)
{
    $getter = 'get' . $name;
    if (method_exists($this, $getter)) {
        return $this->$getter() !== null;
    } else {
        return false;
    }
}
```
#### `__unset()`
将属性设置成 `null` 时调用  
```php
public function __unset($name)
{
    $setter = 'set' . $name;
    if (method_exists($this, $setter)) {
        $this->$setter(null);
    } elseif (method_exists($this, 'get' . $name)) {
        throw new InvalidCallException('Unsetting read-only property: ' . get_class($this) . '::' . $name);
    }
}
```
#### `__call()`
当调用类中的 方法 不存在的时候调用
```php
public function __call($name, $params)
{
    throw new UnknownMethodException('Calling unknown method: ' . get_class($this) . "::$name()");
}
```
### 检查是否存在成员变量
```php
public function hasProperty($name, $checkVars = true)
{
    return $this->canGetProperty($name, $checkVars) || $this->canSetProperty($name, false);
}


public function canGetProperty($name, $checkVars = true)
{
    return method_exists($this, 'get' . $name) || $checkVars && property_exists($this, $name);
    //  检查对象或类是否具有该属性
}

public function canSetProperty($name, $checkVars = true)
{
    return method_exists($this, 'set' . $name) || $checkVars && property_exists($this, $name);
}
```
### 检查是否对象是否存在某方法  
```php
public function hasMethod($name)
{
    return method_exists($this, $name);
}
```
