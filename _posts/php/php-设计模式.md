---
title: php-设计模式
date: 2017-07-03 11:56:02
tags:
	- 设计模式
categories:
    - php
    - 设计模式
---

## 工厂模式  
> 工厂模式封装了类的声明过程，实例化对象不使用new声明了，可以解决 改类名需要去找到所有new此对象一个一个改的问题，  
通过将new对象封装在一个方法里，如果类名进行改动，可以在方法里直接改，而不影响其他地方   
工厂模式是一种良好的代码规范，是编写代码遵守的很好的一种习惯。使用工厂模式，可以使代码更简洁易懂，层次清晰。同时工厂模式也可以提高代码的可维护性。
### 第一个版本
> 只是省略了 new 的过程

```php
比如，我们有一些类，它们都继承自交通工具类：

interface Vehicle
{
    public function drive();
}

class Car implements Vehicle
{
    public function drive()
    {
        echo '汽车靠四个轮子滚动行走。';
    }
}

class Ship implements Vehicle
{
    public function drive()
    {
        echo '轮船靠螺旋桨划水前进。';
    }
}

class Aircraft implements Vehicle
{
    public function drive()
    {
        echo '飞机靠螺旋桨和机翼的升力飞行。';
    }
}
再创建一个工厂类，专门用作类的创建，：

class VehicleFactory
{
    public static function build($className = null)
    {
        $className = ucfirst($className);
        if ($className && class_exists($className)) {
            return new $className();
        }
        return null;
    }
}
工厂类用了一个静态方法来创建其他类，在客户端中就可以这样使用：

VehicleFactory::build('Car')->drive();
VehicleFactory::build('Ship')->drive();
VehicleFactory::build('Aircraft')->drive();
省去了每次都要new类的工作。
```
### 第二个版本
> 可以更换类名  

```php
/**
 * 工厂类
 */
class Factory
{
		static function createDatabase()
		{
				//这里的类名可以进行修改，而不影响其他代码
				$db = new Database;
				return $db;
		}
}

```

## 单例模式
> 单例模式：声明周期内，一个类只会实例化一次对象。主要用于防止多次创建数据库连接，造成资源浪费  

## 注册器模式  
> 创建一个注册器类，将创建的对象绑定到注册树上，之后可以在全局通过注册树类进行访问绑定过的类  
> 可以结合在工厂模式中结合使用，其实可以实现单利模式的目的，即创建一次，全局使用；  

```php
/**
* 注册树类
*/
class Register
{

	protected static $objects;
	//通过别名的方式，将对象绑定到注册树上
	static function set($alias, $object)
	{
		self::$objects[$alias] = $object;
	}
	//通过别名获取对象
	static function get($alias)
	{
		return self::$objects[$alias];
	}
	//销毁
	static function _unset($alias)
	{
		unset(self::$objects[$alias]);
	}
}
```

## 适配器模式  
> 多个相同功能目的的类，通过相同的方法来实现相同的功能目的  

1. 适配器模式，可以将截然不同的函数接口封装成同一的API
2. 实例应用举例，PHP的数据库操作有mysql、mysqli，pdo3种，可以用
适配器模式统一成一致，类似的场景还有cache适配器，将memcache、redis、file等不同的缓存函数，同一成一致

实现：
1. 定义一个定义了约定要实现的方法的接口
2. 不同的类实现这个接口，来各自完成自己的实现相应方法的逻辑
```php
//定义接口
interface IDatabase
{
    function connect($host, $user, $passwd, $dbname);
    function query($sql);
    function close();
}
//不同的数据库实现此接口  
#mysqli
class MySQLi implements IDatabase
{
    protected $conn;

    function connect($host, $user, $passwd, $dbname)
    {
        $conn = mysqli_connect($host, $user, $passwd, $dbname);
        $this->conn = $conn;
    }

    function query($sql)
    {
        return mysqli_query($this->conn, $sql);
    }

    function close()
    {
        mysqli_close($this->conn);
    }
}
#pdo
class PDO implements IDatabase
{
    protected $conn;
    function connect($host, $user, $passwd, $dbname)
    {
        $conn = new \PDO("mysql:host=$host;dbname=$dbname", $user, $passwd);
        $this->conn = $conn;
    }

    function query($sql)
    {
        return $this->conn->query($sql);
    }

    function close()
    {
        unset($this->conn);
    }
}
```
## 策略模式
**实现分支逻辑的处理**  
> 避免在 `if else` 中直接写实现的代码，将实现代码封装到不同的类(策略)中，有利于解耦，同时，也可以提高复用性  

1. 策略模式，将一组特定的行为和算法封装成类，以适应某些特定的上下文环境
2. 实际应用举例，加入一个电商网站系统，针对男性女性用户要各自跳转到不同的商品类目，并且所有广告位展示不同的广告

实现和适配器模式相似：
1. 定义一个定义了约定要实现的方法的接口
2. 不同的策略类实现这个接口，来各自完成自己的实现相应方法的逻辑
3. 在 `if else` 中调用不同的策略  

举例  
```php
/**
 * 策略接口
 */
interface OutputStrategy
{
    public function render($array);
}

/**
 * 策略类1：返回序列化字符串
 */
class SerializeStrategy implements OutputStrategy
{
    public function render($array)
    {
        return serialize($array);
    }
}

/**
 * 策略类2：返回JSON编码后的字符串
 */
class JsonStrategy implements OutputStrategy
{
    public function render($array)
    {
        return json_encode($array);
    }
}

/**
 * 策略类3：直接返回数组
 */
class ArrayStrategy implements OutputStrategy
{
    public function render($array)
    {
        return $array;
    }
}

/**
 * 环境角色类
 */
class Output
{
    private $outputStrategy;

    // 传入的参数必须是策略接口的子类或子类的实例
    public function __construct(OutputStrategy $outputStrategy)
    {
        $this->outputStrategy = $outputStrategy;
    }

    public function renderOutput($array)
    {
        return $this->outputStrategy->render($array);
    }
}

/**
 * 客户端代码
 */
$test = ['a', 'b', 'c'];

// 需要返回数组
$output = new Output(new ArrayStrategy());
$data = $output->renderOutput($test);

// 需要返回JSON
$output = new Output(new JsonStrategy());
$data = $output->renderOutput($test);
```



**依赖倒置、控制反转**
在一个类中的方法需要用到某个类的对象，如果在类的方法中直接创建，就导致了紧耦合，可以到要执行方法时，再将需要的对象创建出来赋值给所需此类的对象或方法。简单的理解就是，尽量不要再类中创建另一个类，而是通过传参的方式传递进去    

## 数据对象映射模式
> 类似于yii的AR模式，通过操作对象的属性和方法来完成对数据的增删改查

1. 数据对象映射模式，将对象和数据存储映射起来，对一个对象的操作会映射为对数据存储的操作

```php
class User
{
    protected $id;
    protected $data;
    protected $db;
    protected $change = false;

    function __construct($id)
    {
        $this->db = Factory::getDatabase();
        $res = $this->db->query("select * from user where id = $id limit 1");
        $this->data = $res->fetch_assoc();
        $this->id = $id;
    }
    //魔术方法获取对象不存在的属性时调用
    function __get($key)
    {
        if (isset($this->data[$key]))
        {
            return $this->data[$key];
        }
    }
    //魔术方法设置对象不存在的属性时调用
    function __set($key, $value)
    {
        $this->data[$key] = $value;
        $this->change = true;
    }
    //析构方法，对象销毁时调用
    function __destruct()
    {
        if ($this->change)
        {
            foreach ($this->data as $k => $v)
            {
                $fields[] = "$k = '{$v}'";
            }
            $this->db->query("update user set " . implode(', ', $fields) . "where
            id = {$this->id} limit 1");
        }
    }
}
```

## 观察者模式
1. 观察者模式(Observer)，当一个对象状态发生改变时，依赖他的对象全部会受到通知，并自动更新
2. 场景：一个事件发生后，要执行一连串更新操作，传统的编程方式，就是在事件的代码之后直接加入处理逻辑
当更新的逻辑增多之后，代码会变的难以维护。这种方式是耦合的，侵入式的，增加新的逻辑需要修改事件主体的代码
3. 观察者模式实现了低耦合，非侵入式的通知与更新机制

实现：
```php
//事件产生者 抽象类
EventGenerator.php
abstract class EventGenerator{
	private $obserers = array();
    //为事件添加观察者
	function addObsever(Observer $observer){
		$this->obserers[] = $observer;
	}
    //通知观察者 调用观察者响应的方法
	function ontify(){
		foreach ($this->obserers as $observer){
			$observer->update();
		}
	}
}
//事件
event.php
class Event extends EventGenerator{
	function trigger(){
		echo "Event <br>";
		$this->ontify();
	}
}
//观察者接口，定义要实现的被触发的方法  
Observer.php
interface Observer{
	function update($event_info = null);
}
//观察者1
Observer1.php
class Observer1 implements Observer{
	function update($event_info = null){
		echo "逻辑1";
	}
}
……
……

//使用
index.php
$event = new Event();
$event->addObsever(new Observer1());
$event->addObsever(new Observer2());
$event->addObsever(new Observer3());
$event->trigger();
```

## 原型模式
> 对与需要大量初始化的对象，多次创建比较耗费资源，即可将初始化后的对象当作原型，使用 `clone` 的方式创建多个不同的对象

1. 原型模式与工厂模式作用类似,都是用来创建对象
2. 与工厂模式的实现不同,原型模式是先创建好一个原型对象,然后通过clone原型对象来创建新的对象,这样就免去了类创建时重复的初始化操作
3. 原型模式适用于大对象的创建,创建一个大对象需要很大的开销,如果每次new就会消耗很大,原型模式仅需内存拷贝即可


## 装饰器模式
> 扩展类的原有方法，不需要继承重写，在方法的开始和结尾增加预处理方法  

1. 装饰模式,可以动态的添加修改类的功能
2. 一个类提供了一项功能,如果要在修改并添加额外的功能,传统的编程模式,需要写一个之类继承它,并重新实现类的方法
3. 使用装饰模式,仅需在运行时添加一个装饰对象即可实现,可以实现最大的灵活性  

实现：
1. 定义一个装饰器接口，定义要实现的方法  
2. 创建一个对象实现装饰器的接口
3. 在指定类中使用装饰器  
```php
//定义装饰器接口  
interface DrawDecorator
{
    function beforeDraw();
    function afterDraw();
}
//创建装饰器，实现装饰器接口  
class ColorDrawDecorator implements DrawDecorator
{
    protected $color;
    function __construct($color = 'red')
    {
        $this->color = $color;
    }
    function beforeDraw()
    {
        echo "<div style='color: {$this->color};'>";
    }
    function afterDraw()
    {
        echo "</div>";
    }
}
//使用装饰器
class Canvas
{
    protected $decorators = array();
    //添加装饰器
    function addDecorator(DrawDecorator $decorator)
    {
        $this->decorators[] = $decorator;
    }
    //调用方法之前先调用装饰器的方法
    function beforeDraw()
    {
        foreach($this->decorators as $decorator)
        {
            $decorator->beforeDraw();
        }
    }
    //调用方法之后调用装饰器的方法
    function afterDraw()
    {
        $decorators = array_reverse($this->decorators);
        foreach($decorators as $decorator)
        {
            $decorator->afterDraw();
        }
    }
    //此方法使用装饰器的方法
    function draw()
    {
        $this->beforeDraw();
        foreach($this->data as $line)
        {
            foreach($line as $char)
            {
                echo $char;
            }
            echo "<br />\n";
        }
        $this->afterDraw();
    }
}
```
## 迭代器模式  
> 遍历对象，迭代器实现遍历的细节与输出数据  

1. 迭代器模式，在不需要了解内部实现的前提下，遍历一个聚合对象的内部元素。
2. 相比传统的编程模式，迭代器模式可以隐藏遍历元素的所需操作。

实现：  
实现php自带的 `Iterator` 接口，分别实现接口5个方法
spl迭代器执行顺序：  
1. rewind，将索引重置到数组第一个元素；
2. valid，验证数据有效性；
3. current，获取当前数据；
4. next，将索引值向下移动；
5. key，获取当前索引

```php
//遍历表中所有的数据
//实现迭代器
class AllUser implements \Iterator
{
    protected $ids;
    protected $data = array();
    protected $index;
    //查询出所有用户的id
    function __construct()
    {
        $db = Factory::getDatabase();
        $result = $db->query("select id from user");
        $this->ids = $result->fetch_all(MYSQLI_ASSOC);
    }
    //3. 获取当前索引的值(id的记录)  
    function current()
    {
        $id = $this->ids[$this->index]['id'];
        return Factory::getUser($id);
    }
    //4. 将索引值向下移动
    function next()
    {
        $this->index ++;
    }
    //2. 验证当前索引是否合理  
    function valid()
    {
        return $this->index < count($this->ids);
    }
    //1. 遍历开始，重置索引到第一个数组的元素
    function rewind()
    {
        $this->index = 0;
    }
    //5. 获取当前索引
    function key()
    {
        return $this->index;
    }

}
//遍历  ,遍历到的就是 current() 返回的值
$users = new AllUser;
foreach ($users as $user) {
    var_dump($user->user)
}
```
> AR模式遍历所有记录对象应该比这个高明，应该是开销比这个小，不用每遍历一个就请求一次mysql获取数据，***有待查阅***  


## 代理模式
> 对于多个服务(myql主从之类的)只管正常的使用，代理类中帮助实现选用和实现具体的细节  

1. 在客户端与实体之间建立一个代理对象(proxy)，客户端对实体进行操作全部委派给代理对象，隐藏实体的具体细节

典型的应用：mysql读写分离  
```php
//代理类
class Proxy
{
    //获取数据时，使用从库
    function getUserName($id)
    {
        $db = Factory::getDatabase('slave');
        $db->query("select name from user where id =$id limit 1");
    }
    //修改数据时，使用主库
    function setUserName($id, $name)
    {
        $db = Factory::getDatabase('master');
        $db->query("update user set name = $name where id =$id limit 1");
    }
}
//通过代理对象，正常的实现读写功能，而不用手动的切换库了  
$proxy = new Proxy;
$proxy->getUserName($id);
$proxy->setUserName($id, $name);
```

> **[歪麦博客](https://www.awaimai.com/patterns)(UML类图的使用，php设计模式)**  
> **[慕课网-php设计模式](http://www.imooc.com/learn/236)**  
> **[参考资料](http://design-patterns.readthedocs.io/zh_CN/latest/index.html)**
