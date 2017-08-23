---
title: Yii-view
date: 2017-07-03 11:56:02
tags:
	- yii-view
categories:
    - yii
---

视图中访问数据  
1. 通过控制器的 `render()` 方法传递给视图层  
2. 在视图层通过  `$this->context` 来获取所对应的控制器对象，可以访问对象中的属性值  
3. 在 `控制器 controller` 中 使用 `$this->view->params['menu']` ;在布局中可以使用 `$this->params['menu']` 访问;
> 控制器中 `$this->view` 获取到的就是 视图层中的 `$this`  
> 视图和布局文件中共享 `$this` 只要是 `$this` 添加属性，两个里面都可以访问到    

视图键共享数据  
布局文件和视图之间的数据共享  
1. 布局文件和视图都可以通过 `$this->context` 来获取所对应的控制器对象，来使用属性值  
2. view component视图组件提供 `params` 参数 属性来让不同视图共享数据。

例如：
```php
index.php 视图文件
<?php
$this->params['ding']='ran'
 ?>
layout 布局文件
<?php
echo $this->params['ding'];
 ?>
```

## 布局  
> 不使用布局文件 `$this->layout = false`,通过 `$this->layout` 来指定布局文件；也可以直接声明 `layout` 属性进行设置整个控制器的。

```php
<?php
use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $content string 字符串 */
?>
<?php $this->beginPage() ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <?= Html::csrfMetaTags() ?>
    <title><?= Html::encode($this->title) ?></title>
    <?php $this->head() ?>
</head>
<body>
<?php $this->beginBody() ?>
    <header>My Company</header>
    <?= $content ?>
    <footer>&copy; 2014 by My Company</footer>
<?php $this->endBody() ?>
</body>
</html>
<?php $this->endPage() ?>
```
如上所示，布局生成每个页面通用的HTML标签，在<body>标签中，打印 `$content` 变量， `$content`变量代表当 `yii\base\Controller::render()` 控制器渲染方法调用时传递到布局的内容视图渲染结果。

大多数视图应调用上述代码中的如下方法， 这些方法触发关于渲染过程的事件， 这样其他地方注册的脚本和标签会添加到这些方法调用的地方。  

1. 它触发表明页面开始的 `EVENT_BEGIN_PAGE` 事件。
2. 它触发表明页面结尾的 `EVENT_END_PAGE` 时间。
3. **它生成一个占位符，在页面渲染结束时会被注册的头部HTML代码 （如，link标签, meta标签）替换。**
4. 它触发 `EVENT_BEGIN_BODY` 事件并生成一个占位符， 会被注册的HTML代码（如JavaScript）在页面主体开始处替换。
5. 它触发 `EVENT_END_BODY` 事件并生成一个占位符， 会被注册的HTML代码（如JavaScript）在页面主体结尾处替换。

### 嵌套布局  
> 一个布局嵌套在另一个布局内，可以实现多层嵌套布局  

```php
content.php 子布局文件
//嵌套方法
//@app/views/layouts/main.php 表示要嵌套在main.php布局内，填充父布局的 $content 变量  
<?php $this->beginContent('@app/views/layouts/main.php'); ?>
<hr>
<?=$content ;?>
<hr>
<?php $this->endContent(); ?>
//main.php yii默认布局，不用动  

控制器修改布局为子布局  
$this->loayout = 'content';
```
### 使用数据块  
> 视图文件中定义数据块，布局文件根据逻辑判断使用数据块，用来做网页布局部分不相同的视图部分  

```php
//视图文件定义数据块  
<?php $this->beginBlock('block1'); ?>

...content of block1...

<?php $this->endBlock(); ?>
//布局文件使用数据块  
<?php if (isset($this->blocks['block1'])): ?>
    <?= $this->blocks['block1'] ?>
<?php else: ?>
    ... default content for block1 ...
<?php endif; ?>
```

## 设置标题  
```php
<?php
$this->title = 'My page title';
?>
```
然后在视图中，确保在 `<head>` 段中有如下代码：
```php
<title><?= Html::encode($this->title) ?></title>
```
## 注册Meta元标签
Web页面通常需要生成各种元标签提供给不同的浏览器，如 `<head>` 中的页面标题， 元标签通常在布局中生成。  
如果想在内容视图中生成元标签，可在内容视图中调用 `yii\web\View::registerMetaTag()` 方法， 如下所示：  
```php
<?php
$this->registerMetaTag(['name' => 'keywords', 'content' => 'yii, framework, php']);
?>
```
以上代码会在视图组件中注册一个 `"keywords"` 元标签， 在布局渲染后会渲染该注册的元标签， 然后，如下HTML代码会插入到布局中调用 **`yii\web\View::head()`** 方法处：
```php
<meta name="keywords" content="yii, framework, php">
```
## 注册链接标签
和 Meta标签 类似，链接标签有时很实用， 如自定义网站图标，指定Rss订阅，或授权OpenID到其他服务器。 可以和元标签相似的方式调用 `yii\web\View::registerLinkTag()`，例如，在内容视图中注册链接标签如下所示：
```php
$this->registerLinkTag([
    'title' => 'Live News for Yii',
    'rel' => 'alternate',
    'type' => 'application/rss+xml',
    'href' => 'http://www.yiiframework.com/rss.xml/',
]);
```
上述代码会转换成
```php
<link title="Live News for Yii" rel="alternate" type="application/rss+xml" href="http://www.yiiframework.com/rss.xml/">
```

## 视图事件
`View components` 视图组件会在视图渲染过程中触发几个事件， 可以在内容发送给终端用户前，响应这些事件来添加内容到视图中或调整渲染结果。  
该事件可设置 `yii\base\ViewEvent::$isValid` 为 `false` 取消视图渲染。  

1. `EVENT_AFTER_RENDER`: 在布局中调用 `yii\base\View::beginPage()` 时触发， 该事件可获取 `yii\base\ViewEvent::$output` 的渲染结果， 可修改该属性来修改渲染结果。
2. `EVENT_BEGIN_PAGE`: 在布局调用 `yii\base\View::beginPage()` 时触发；
3. `EVENT_END_PAGE`: 在布局调用 `yii\base\View::endPage()` 是触发；
4. `EVENT_BEGIN_BODY`: 在布局调用 `yii\web\View::beginBody()` 时触发；
5. `EVENT_END_BODY`: 在布局调用 `yii\web\View::endBody()` 时触发。

例如，如下代码将当前日期添加到页面结尾处：
```php
\Yii::$app->view->on(View::EVENT_END_BODY, function () {
    echo date('Y-m-d');
});
```
