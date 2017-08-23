---
title: Yii-设计模式
date: 2017-07-03 11:56:02
tags:
	- 设计模式
	- Behavior
	- 依赖注入
	- DI容器
	- 服务定位器
categories:
    - yii
    - 设计模式
---
[Yii深入理解](http://www.digpage.com/di.html)  

## Behavior
> 行为是 `yii\base\Behavior` 或其子类的实例。 行为，也称为 `mixins`， 可以无须改变类继承关系即可增强一个已有的 `组件component` 类功能。 当行为附加到组件后，它将“注入”它的方法和属性到组件，然后可以像访问组件内定义的方法和属性一样访问它们。 此外，行为通过组件能响应被触发的事件， 从而自定义或调整组件正常执行的代码。

### 类混合
>  行为类最好定义在 `behaviors` 文件夹内

将行为类结合放置进其他类中，让其他类直接使用它的方法和属性,实现对类的扩展    
![类混合](/images/yii/mixin1.png)  

### 对象混合
和类的混合相似，不过绑定的是对象
![事件](/images/yii/event2.png)  

## 依赖注入(DI)容器
> 用来解决依赖关系的

> 程序=算法+数据   算法就是方法;  数据就是方法中调用的对象;  
> 好的程序需要尽可能的进行解耦，所以需要将算法和数据进行剥离  

> 原理就是将要用到的对象通过参数的形式传递进去    

```php
<?php
namespace app\controllers;
use yii\web\Controller;
//使用容器
use yii\di\Container;
/**
* 依赖注入
*/
class DependencyController extends Controller
{
    public function actionIndex()
    {
        //需要使用容器类
        $container =new Container;
        //set，当发现是接口无法实例化时，指定接口的要实例化的类
        //实例化这个类作为参数
        $container->set('app\controllers\Dirver','app\controllers\ManDirver');
        //依赖注入
        $car=$container->get('app\controllers\Car');
        $car->run();
    }
}
/**
* 通过接口实现消除强依赖
*/
interface Dirver{
    public function dirve();
}
/**
* 要注入的类
*/
class ManDirver implements Dirver
{
    public function dirve()
    {
        echo "i am an old man";
    }
}
/**
* 要被注入的类
*/
class Car
{
    // 通常通过构造方法方式进行注入的
    private $dirver = null;
    //通过接口实现消除强依赖 容器在使用get方法是会将实例化参数前面的类型
    public function __construct(Dirver $dirver)
    {
        $this->dirver =$dirver;
    }
    public function run()
    {
        $this->dirver->dirve();
    }
}
```
为了加深理解，以官方文档上的例子来说明DI容器解析依赖的过程。假设有以下代码:
```php
namespace app\models;

use yii\base\Object;
use yii\db\Connection;

// 定义接口
interface UserFinderInterface
{
    function findUser();
}

// 定义类，实现接口
class UserFinder extends Object implements UserFinderInterface
{
    public $db;

    // 从构造函数看，这个类依赖于 Connection
    public function __construct(Connection $db, $config = [])
    {
        $this->db = $db;
        parent::__construct($config);
    }

    public function findUser(){}
}

class UserLister extends Object{
    public $finder;

    // 从构造函数看，这个类依赖于 UserFinderInterface接口
    public function __construct(UserFinderInterface $finder, $config = [])
    {
        $this->finder = $finder;
        parent::__construct($config);
    }
}
```
从依赖关系看，这里的 `UserLister` 类依赖于接口 `UserFinderInterface` ， 而接口有一个实现就是 `UserFinder` 类，但这类又依赖于 `Connection` 。  

那么，按照一般常规的作法，要实例化一个 `UserLister` 通常这么做:
```php
$db = new \yii\db\Connection(['dsn' => '...']);
$finder = new UserFinder($db);
$lister = new UserLister($finder);
```

就是逆着依赖关系，从最底层的 `Connection` 开始实例化，接着是 `UserFinder` 最后是 `UserLister` 。 在写代码的时候，这个前后顺序是不能乱的。而且，需要用到的单元，你要自己一个一个提前准备好。 对于自己写的可能还比较清楚，对于其他团队成员写的，你还要看他的类究竟是依赖了哪些，并一一实例化。 这种情况，如果是个别的、少量的还可以接受，如果有个10－20个的，那就麻烦了。 估计光实例化的代码，就可以写满一屏幕了。  

而且，如果是团队开发，有些单元应当是共用的，如邮件投递服务。 不能说你写个模块，要用到邮件服务了，就自己实例化一个邮件服务吧？那样岂不是有N模块就有N个邮件服务了？ 最好的方式是使邮件服务成为一个单例，这样任何模块在需要邮件服务时，使用的其实是同一个实例。 用传统的这种实例化对象的方法来实现的话，就没那么直接了。  

那么改成 `DI容器` 的话，应该是怎么样呢？他是这样的:
```php
use yii\di\Container;

// 创建一个DI容器
$container = new Container;

// 为Connection指定一个数组作为依赖，当需要Connection的实例时，使用这个数组进行创建
$container->set('yii\db\Connection', ['dsn' => '...',]);

// 在需要使用接口 UserFinderInterface 时，采用UserFinder类实现
$container->set('app\models\UserFinderInterface', [
    'class' => 'app\models\UserFinder',]);

// 为UserLister定义一个别名
$container->set('userLister', 'app\models\UserLister');

// 获取这个UserList的实例
$lister = $container->get('userLister');
```
采用DI容器的办法，首先各 `set()` 语句没有前后关系的要求， `set()` 只是写入特定的数据结构， 并未涉及具体依赖关系的解析。所以，前后关系不重要，先定义什么依赖，后定义什么依赖没有关系。  

其次，上面根本没有在DI容器中定义 `UserFinder` 对于 `Connection` 的依赖。 但是DI容器通过对 `UserFinder` 构造函数的分析，能了解到这个类会对 `Connection` 依赖。这个过程是自动的。

在Yii.php中会创建一个DI 容器，并由 `Yii::$container` 引用 `Yii::$container = new yii\di\Container`;
，创建了一个DI容器，并由 `Yii::$container` 引用。 也就是说， Yii 类维护了一个DI容器，这是DI容器开始介入整个应用的标志。 同时，这也意味着，在Yii应用中，我们可以随时使用 Yii::$container 来访问DI容器。 一般情况下，如无必须的理由，不要自己创建DI容器，使用 `Yii::$container` 完全足够。

## 服务定位器
> 服务定位器使用了 `DI容器` 来解决依赖关系，服务定位器是一个了解如何提供各种应用所需的服务（或组件）的对象。 在服务定位器中，每个组件都只有一个单独的实例，并通过ID 唯一地标识。 用这个 ID 就能从服务定位器中得到这个组件。

> 服务定位器就像 `注册树模式` 一样。


```php
<?php
namespace app\controllers;
use yii\web\Controller;
//使用容器
use yii\di\Container;

use yii\di\ServiceLocator;
/**
* 依赖注入
*/
class DependencyController extends Controller
{
    public function actionIndex()
    {
        //需要使用容器类
        $container =new Container;
        //set，当发现是接口无法实例化时，指定接口的要实例化的类
        //实例化这个类作为参数
        $container->set('app\controllers\Dirver','app\controllers\ManDirver');
        //服务定位器
        $sl = new ServiceLocator;
        $sl->set('car', ['class'=>'app\controllers\Car'])

        $car=$sl->get('car');
        $car->run();
    }
}
```

> `\YII::$app`     就是一个服务定位器，如果将服务定位器中的 `set` 配置在配置文件中的 `component`中就可以直接使用 `\YII::$app->car->run()`
