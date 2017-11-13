
> 让对象像数组一样操作  
[参考](http://blog.csdn.net/wh2691259/article/details/52882880)  

## ArrayAccess接口  

```php
<?php
ArrayAccess {
    // isset判断的时候自动调用
    abstract public boolean offsetExists ( mixed $offset )
    // 获取数组数据的时候自动调用
    abstract public mixed offsetGet ( mixed $offset )
    // 添加数据的时候自动调用
    abstract public void offsetSet ( mixed $offset , mixed $value )
    // unset的时候自动调用
    abstract public void offsetUnset ( mixed $offset )
}
```
实现上面的方法，下面举个实例
```php
<?php
/**
 * Created by PhpStorm.
 * User: wangHan
 * Date: 2016/10/21
 * Time: 14:07
 */
class Human implements ArrayAccess
{
    private $elements;

    public function __construct()
    {
        $this->elements = [
            "boy" => "male",
            "girl" => "female"
        ];
    }
    /**
     * isset判断的时候调用
     * @param {[type]} $offset key键
     */
    public function offsetExists($offset)
    {
        // TODO: Implement offsetExists() method.
        return isset($this->elements[$offset]);
    }
    /**
     * 获取值的时候调用
     * @param {[type]} $offset key键
     */
    public function offsetGet($offset)
    {
        // TODO: Implement offsetGet() method.
        return $this->elements[$offset];
    }
    /**
     * 存放值的时候调用
     * @param {[type]} $offset key键
     */
    public function offsetSet($offset, $value)
    {
        // TODO: Implement offsetSet() method.
        $this->elements[$offset] = $value;
    }
    /**
     * unset的时候调用
     * @param {[type]} $offset key键
     */
    public function offsetUnset($offset)
    {
        // TODO: Implement offsetUnset() method.
        unset($this->elements[$offset]);
    }
}

$human = new Human();
$human['people'] = "boyAndGirl"; // 自动调用offsetSet
if(isset($human['people'])) {   // 自动调用offsetExists
    echo $human['boy'];// 自动调用offsetGet
    echo '<br />';
    unset($human['boy']);// 自动调用offsetUnset
    var_dump($human['boy']);
}
// // 输出结果  male   null
```
