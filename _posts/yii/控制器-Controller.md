---
title: Yii-controller
date: 2017-07-03 11:56:02
tags:
	- yii
	- controller
categories:
    - yii
    - controller
---

## 前言   
控制器作为最常用的一个类，也比较简单，这里只简单梳理一下  
因为常用的是web形式，这里就以 `yii\web\Controller` 为基础进行分析  
## 属性  
常用属性列表   
```php
$id  # 控制器id
$module # 如果有，则是该控制器所在的module模块对象  
$defaultAction # 默认的action，在请求没有指定控制器的action的时候默认请求这个  
$layout # 指定layout文件，如果不使用layout设置值为 false ，后面会详细分析  
$enableCsrfValidation # 是否验证csrf, 如果关闭，在beforeAction 中将不进行校验  
```

## 执行操作  
通过下面这两种方式执行action和正常的通过对象调用执行有什么区别？  
直接通过对象调用的方式执行某个方法，只是执行了这个方法；而通过下面这两种方式(通过路由)执行的方式会完整的执行所属modules、controller的 `beforeAction` 和 `afterAction`(动作过滤器)  
### runAction() 执行本控制器的action  
通过本控制器的 `actionId` 完整的执行(就是包含动作过滤器)对应的 独立action 或 内联action  

### run() 根据路由相应的动作  
看下面源码先有三种不同的情况  
1. 单独一个actionid    执行相对当前控制器下的action
2. controllerid/actionid || module/controllerid/actionid 执行相对当前module下的路由
3. /module/controllerid/actionid 执行绝对路由  

其中第三种就是我们发送请求的时候所要执行的操作，而第二种其实和第三种是一样的(`$app`也是module)，只不过使用当前module往后找  

```php
/**
 * 运行路由指向的action
 * 三种路由形式
 * 1. 单独一个actionid    执行相对当前控制器下的action
 * 2. controllerid/actionid 执行相对当前module
 * 3. /module/controllerid/actionid 绝对路由
 */
public function run($route, $params = [])
{
    $pos = strpos($route, '/');
    // route 不包含 / 执行本控制器的action
    if ($pos === false) {
        return $this->runAction($route, $params);
    // route 为 controller/action 的形式，执行本module下的控制器方法
    } elseif ($pos > 0) {
        return $this->module->runAction($route, $params);
    }
    // route 以 / 开头 和路由一样了
    return Yii::$app->runAction(ltrim($route, '/'), $params);
}
```
## 钩子方法||方法过滤器  
就是在执行动作之前 `beforeAction` 进行请求过滤,在请求之后 `afterAction` 进行结果过滤，基础控制器中这两个方法都会触发响应的事件    
看一下web在 `beforeAction` 进行的csrf验证  
```php
/**
 * 执行动作之前 ， 验证 csrf  csrf验证
 * @inheritdoc
 */
public function beforeAction($action)
{
    if (parent::beforeAction($action)) {
        if ($this->enableCsrfValidation && Yii::$app->getErrorHandler()->exception === null && !Yii::$app->getRequest()->validateCsrfToken()) {
            throw new BadRequestHttpException(Yii::t('yii', 'Unable to verify your data submission.'));
        }
        return true;
    }

    return false;
}
```  

## 视图相关  
### 设置 layout 布局文件    
根据 `findLayoutFile()` 方法可以知道根据 `layout` 属性值的不同获取 layout 的方法也不相同  
1. `$this->layout = false` 不使用layout  
2. `$this->layout = @abc/ad.php` 以别名的形式开头指定layout路径，直接用的就是这个文件  
3. `$this->layout = /ding.php` 以绝对路径指定layout路径，用的是 `$app` 模块下默认layout文件夹下的对应的文件  
4. `$this->layout = ding` 使用当前模块下layout文件夹下的对应的文件
5. `$this->layout = null` 默认情况，如果当前moudle设置了 `layout` 属性，则使用该模块下layout文件夹下的 `layout` 属性值所代表的文件，如果当前模块没有设置，则往上一级模块寻找，直到 `$app` 模块  

### 渲染视图相关  
渲染视图功能其实是通过 `view` 组件实现的，这里先简单说一下, 下面的四个方法其实极其的相似    
#### render 方法  
`render()` 方法会根据传入 `$view` 值的形式不同而去找相对应的文件   
1. `@abc/efg.php` 以别名 `@` 形式，直接通过别名找到对应的文件  
2. `//abc/ding.php` 以 `//` 开头的，直接从 `$app` 模块的 views 目录下开始找对应的文件  
3. `/abc/ding.php` 以 `/` 开头的，从 **当前模块** 的 views 目录下开始找对应的文件  
4. `ding` 这种就是我们最长用的，就是找当前模块视图文件夹下控制器对应的文件夹下的视图文件  
```php
public function render($view, $params = [])
{
    // 视图文件经过变量替换后的内容  
    $content = $this->getView()->render($view, $params, $this);
    return $this->renderContent($content);
}
```

#### renderPartial 不使用layout  
这个就更简单了，和 `render()` 方法的唯一区别就是不使用layout了  
```php
public function renderPartial($view, $params = [])
{
    return $this->getView()->render($view, $params, $this);
}
```
#### renderContent 将字符串填充到layout    
就是将 `$content` 填充到layout文件中，上面的 `render()` 方法就用到了  
```php
public function renderContent($content)
{
    $layoutFile = $this->findLayoutFile($this->getView());
    if ($layoutFile !== false) {
        // 渲染layout
        return $this->getView()->renderFile($layoutFile, ['content' => $content], $this);
    }
    return $content;
}
```

#### renderFile 直接指定要渲染的文件路径  
上面的三个方法，最终都需要通过 `View::renderFile()` 方法来获取文件数据的，只不过 `render()` 方法有找对应文件的规则罢了  
```php
public function renderFile($file, $params = [])
{
    return $this->getView()->renderFile($file, $params, $this);
}
```
## 独立动作 action  
使用场景：多个控制器都用到同样的方法，或者是作为第三方扩展方便引入。只需要在控制器中配置一下，指定一下动作id，即可通过该控制器进行访问。

比较简单但又常用到，偷个懒直接 [引用一下官方文档](https://www.yiichina.com/doc/guide/2.0/structure-controllers) 内容    
独立操作通过继承 `yii\base\Action` 或它的子类来定义。 例如Yii发布的 `yii\web\ViewAction` 和 `yii\web\ErrorAction ` 都是独立操作。

要使用独立操作，需要通过控制器中覆盖 `yii\base\Controller::actions()` 方法在中申明， 如下例所示：
```php
public function actions()
{
    return [
        // 用类来申明"error" 动作
        'error' => 'yii\web\ErrorAction',

        // 用配置数组申明 "view" 动作
        'view' => [
            'class' => 'yii\web\ViewAction',
            'viewPrefix' => '',
        ],
    ];
}
```
## 页面跳转  
作为方便，这里封装了四个跳转相关的方法，其中用到的一些其他类的方法，请跳转到对应的文章查看    
### redirect 页面跳转  
[Url 帮助类]()  
```php
public function redirect($url, $statusCode = 302)
{
    return Yii::$app->getResponse()->redirect(Url::to($url), $statusCode);
}
```
### goHome 跳转到首页  
```php
public function goHome()
{
    return Yii::$app->getResponse()->redirect(Yii::$app->getHomeUrl());
}
```

### goBack 返回上一页(上一个记录的链接)  
这个依赖于 `cookie` 因为用的 `session` 进行保存访问记录的  
首先在访问的时候记录一下访问的路由    
```php
// 记录访问路由
Yii::$app->getUser()->setReturnUrl(['admin/index', 'ref' => 1]);
// 记录访问路由，和上面一样。方便一点  
Url::remember(['admin/index', 'ref' => 1]);

// 控制器中跳转到上一个记录点  
$this->goBack();
```   
通过下面的方法进行跳转上个记录点  
```php
public function goBack($defaultUrl = null)
{
    return Yii::$app->getResponse()->redirect(Yii::$app->getUser()->getReturnUrl($defaultUrl));
}
```
### refresh 刷新当前页  
```php
public function refresh($anchor = '')
{
    return Yii::$app->getResponse()->redirect(Yii::$app->getRequest()->getUrl() . $anchor);
}
```
