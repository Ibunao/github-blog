---
title: 实现迭代器
date: 2018-10-11 00:00:02
tags:
    - 迭代器
categories:
    - php  
---

## 前言  
迭代器接口可以让对象像数组一样被遍历，如 `foreach` ，和数组的区别是数组一开始数据就是填充好的，也就是已经加载到内存的，如果数据量比较大甚至超过服务器内存，那将无法工作，而迭代器就可以通过一条一条数据的读取(从文件或数据库)进行操作     
## Iterator接口  
php提供的接口，我们看一下要实现的内容  

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
<!--more-->
## 实现一个简单的迭代器    

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
[PHP文档](http://php.net/manual/zh/class.iterator.php)
