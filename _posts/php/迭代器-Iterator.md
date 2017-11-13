
> 迭代器是让对象可以像数组一样 foreach 遍历   

[PHP文档](http://php.net/manual/zh/class.iterator.php)
## Iterator接口  

```php
Iterator extends Traversable {  
    //重置索引游标  
    abstract public void rewind ( void )  
    //移动当前索引游标到下一元素  
    abstract public void next ( void )  
    //判断当前索引游标指向的元素是否有效  
    abstract public boolean valid ( void )  
    //返回当前索引游标指向的元素  
    abstract public mixed current ( void )  
    //返回当前索引游标指向的键  
    abstract public scalar key ( void )  
}  
```  
## 使用 Iterator 迭代器  

```php
class myIterator implements Iterator {
    // 记录数组的位置
    private $position = 0;
    // 要遍历的数组
    private $array = array(
        "firstelement",
        "secondelement",
        "lastelement",
    );  
    // foreach开始时执行一次，重置索引
    function rewind() {
        var_dump(__METHOD__);
        $this->position = 0;
    }
    // 返回下一个索引
    function next() {
        var_dump(__METHOD__);
        ++$this->position;
    }
    // 判断当前索引对应的值是否有效，返回false将会终止遍历
    function valid() {
        var_dump(__METHOD__);
        return isset($this->array[$this->position]);
    }
    // 每次循环获取当前索引对应的值
    function current() {
        var_dump(__METHOD__);
        return $this->array[$this->position];
    }
    // 返回当前的索引
    function key() {
        var_dump(__METHOD__);
        return $this->position;
    }
}

$it = new myIterator;

foreach($it as $key => $value) {
    var_dump($key, $value);
    echo "\n";
}
```
