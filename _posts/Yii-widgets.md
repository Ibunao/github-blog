---
title: Yii-widgets
date: 2017-07-03 11:56:02
tags:
	- yii
	- widgets
	- 小部件
categories:
    - yii
    - widgets
---

> 可以当作是一个动作 action 加载视图   

## 创建小部件
继承 `yii\base\Widget` 类并覆盖 `yii\base\Widget::init()` 和/或 `yii\base\Widget::run()` 方法可创建小部件。通常 `init()` 方法处理小部件属性， `run()` 方法包含小部件生成渲染结果的代码。 渲染结果可在`run()`方法中直接"echoed"输出或以字符串返回。

如下代码中HelloWidget编码并显示赋给message 属性的值， 如果属性没有被赋值，默认会显示"Hello World"。
```php
namespace app\components;

use yii\base\Widget;
use yii\helpers\Html;

class HelloWidget extends Widget
{
    public $message;

    public function init()
    {
        parent::init();
        if ($this->message === null) {
            $this->message = 'Hello World';
        }
    }

    public function run()
    {
        return Html::encode($this->message);
    }
}
```
使用这个小部件只需在视图中简单使用如下代码:
```php
<?php
use app\components\HelloWidget;
?>
<?= HelloWidget::widget(['message' => 'Good morning']) ?>
```

**以下是另一种可在begin() 和 end()调用中使用的HelloWidget**， HTML编码内容然后显示。
```php
namespace app\components;

use yii\base\Widget;
use yii\helpers\Html;

class HelloWidget extends Widget
{
    public function init()
    {
        parent::init();
        ob_start();
    }

    public function run()
    {
        $content = ob_get_clean();
        return Html::encode($content);
    }
}
```
如上所示，PHP输出缓冲在 `init()` 启动，所有在 `init()` 和 `run()` 方法之间的输出内容都会被获取， 并在 `run()` 处理和返回。

> 注意: 当你调用 `yii\base\Widget::begin()` 时会创建一个 **新的小部件实例** 并在构造结束时调用 `init()` 方法， 在 `end()` 时会调用 `run()` 方法并输出返回结果。  

如下代码显示如何使用这种 HelloWidget:
```php
<?php
use app\components\HelloWidget;
?>
<?php HelloWidget::begin(); ?>

    content that may contain <tag>'s

<?php HelloWidget::end(); ?>
```

有时小部件需要渲染很多内容，一种更好的办法 是将内容放入一个视图文件， 然后调用 `yii\base\Widget::render()` 方法渲染该视图文件，例如：
```php
public function run()
{
    return $this->render('hello');
}
```
小部件的视图文件默认存储在 `WidgetPath/views` 目录，`WidgetPath` 代表小部件类文件所在的目录。 假如上述示例小部件类文件在 `@app/components` 下， 会渲染 `@app/components/views/hello.php` 视图文件。 You may override 可以覆盖 `yii\base\Widget::getViewPath()` 方法自定义视图文件所在路径。
