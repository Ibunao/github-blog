
---
title: Yii-assets
date: 2017-07-05 11:56:02
tags:
	- yii
	- assets  
	- 视图注册资源  
categories:
    - yii
    - assets
---
### 资源包
Yii在资源包中管理资源，资源包简单的说就是放在一个目录下的资源集合， 当在视图中注册一个资源包， 在渲染Web页面时会包含包中的CSS和JavaScript文件。

### 定义资源包
资源包指定为继承 `yii\web\AssetBundle` 的PHP类， 包名为可自动加载的PHP类名， 在资源包类中，要指定资源所在位置， 包含哪些CSS和JavaScript文件以及和其他包的依赖关系。

如下代码定义基础应用模板使用的主要资源包：
```php
<?php

namespace app\assets;

use yii\web\AssetBundle;

class AppAsset extends AssetBundle
{
    public $basePath = '@webroot';
    public $baseUrl = '@web';
    public $css = [
        'css/site.css',
    ];
    public $js = [
    ];
    public $depends = [
        'yii\web\YiiAsset',
        'yii\bootstrap\BootstrapAsset',
    ];
}
```
如上AppAsset 类指定资源文件放在 `@webroot(……/web)` 目录下，对应的URL为 `@web`，资源包中包含一个CSS文件 `css/site.css`，没有JavaScript文件， 依赖其他两个包 `yii\web\YiiAsset` 和 `yii\bootstrap\BootstrapAsset`  

**`yii\web\AssetBundle` 的属性的详述：**

1. `basePath` 和 `baseUrl` 属性，是在引用放置在 `……/web` 目录下的资源，这些资源不需要 **资源管理器发布**， 如果你的资源文件在一个Web可访问目录下，应设置该属性，这样就不用再发布了。如果指定了 `basePath`，则会直接引用源文件，不会把文件复制到 `@webroot/asset` 目录。  
2. `sourcePath` 属性， `资源管理器` 会发布包的资源到一个可Web访问并覆盖该属性(web目录下资源文件夹内生成随机的文件);光指定sourcePath，然后把js或者css放到非web目录，YII就会自动在 `@webroot/asset` 目录生成一个随机文件夹，然后复制js和css文件进去；
3. `depends` 属性，依赖关系，即先引入 `depends` 里的资源，在引入 自定义的资源  
4. jsOptions: 当调用 `yii\web\View::registerJsFile()`注册该包 每个 JavaScript文件时， 指定传递到该方法的选项。
5. cssOptions: 当调用 `yii\web\View::registerCssFile()`注册该包 每个 css文件时， 指定传递到该方法的选项。指定传递到该方法的选项， 仅在指定了 `sourcePath` 属性时使用。  

> 后两个定义的就是注册方法的第二个参数，表示插入的位置  

```php
    //注册js文件时会调用\yii\web\View::registerJsFile()方法，
    //这个属性是用来定义registerJsFile方法的第二个参数配置，
    //可以填写的配置可以去看registerJsFile方法。这个属性为数组
    public $jsOptions = [
        //定义js在页面的位置在head标签内部。
       'position' => \yii\web\View::POS_HEAD,
    ];
```


### 资源位置
资源根据它们的位置可以分为：

**源资源:**   
资源文件和PHP源代码放在一起，不能被Web直接访问， 为了使用这些源资源，它们要拷贝到一个可Web访问的Web目录中 成为发布的资源，这个过程称为发布资源。  
**发布资源:**   
资源文件放在可通过Web直接访问的Web目录中；  
**外部资源:**   
资源文件放在与你的Web应用不同的 Web服务器上；  

> 当定义资源包类时候，如果你指定了sourcePath 属性， 就表示任何使用相对路径的资源会被当作源资源；如果没有指定该属性， 就表示这些资源为发布资源（因此应指定basePath 和 baseUrl 让Yii知道它们的位置）。

> 推荐将资源文件放到Web目录以避免不必要的发布资源过程， 这就是之前的例子：指定 basePath 而不是 sourcePath.

> **对于 扩展来说**， 由于它们的资源和源代码都在不能Web访问的目录下， 在定义资源包类时必须指定sourcePath属性。

### 视图加载资源  
[灵活使用AssetBundle管理CSS样式及JS脚本](http://www.yiichina.com/tutorial/387)  

控制器动作的视图（view）渲染顺序是优先于我们的模板页（layout）的，所以要保证视图中的 js、css 能够争取的使用，需要使用下面几种方法  

**注册代码段**
1. 巧用 `数据块`   
    在视图中定义数据块 `block`   

    ```php
    //视图文件定义数据块  
    <?php $this->beginBlock('block1'); ?>
    css………………
    <?php $this->endBlock(); ?>

    //布局文件 <head> 标签内使用数据块，以达到注册css的效果  
    <head>  
    <?php if (isset($this->blocks['block1'])): ?>
        <?= $this->blocks['block1'] ?>
    <?php else: ?>
        ... default content for block1 ...
    <?php endif; ?>
    </head>
    ```

2. 可以使用自带方法注册  
    2.1  在页面中单独写样式
    ```php
    $cssString = ".gray-bg{color:red;}";  
    $this->registerCss($cssString);
    ```
    2.2在页面中单独写JS(使用数据块)  

    ```php
    <div id="mybutton">点我弹出OK</div>  

    <?php $this->beginBlock('test') ?>  
        $(function($) {  
          $('#mybutton').click(function() {  
            alert('OK');  
          });  
        });  
    <?php $this->endBlock() ?>  
    <?php $this->registerJs($this->blocks['test'], \yii\web\View::POS_END); ?>
    ```
    或者：
    ```php
    <?php
    $this->registerJs(
       '$("document").ready(function(){
            $("#login-form").validate({
                errorElement : "small",
                errorClass : "error",
                rules: {
                         "AgNav[nav_cn]": {
                             required: true,
                         },
                },
                messages:{
                       "AgNav[nav_cn]" : {  
                            required : "此字段不能为空.",
                        },
                }
            });
        });'
    );
    ?>
    ```

**视图中引入CSS/JS文件**
> 引入的文件可能需要依赖与 layout 中注册的文件，所以应该放在它们的后面  

在视图 view 中引入分别有两种方法：

**方法1：**  
在 **资源包管理器 `AssetBundle`** 里面定义一个方法，然后在视图 view 中注册即可(推荐使用这种)
```php
//定义按需加载JS方法，注意加载顺序在最后  
public static function addScript($view, $jsfile) {  
    $view->registerJsFile($jsfile, [AppAsset::className(), 'depends' => 'backend\assets\AppAsset']);  
}
视图中使用如下

AppAsset::register($this);  
//只在该视图中使用非全局的jui   
AppAsset::addScript($this,'@web/js/jquery-ui.custom.min.js');  
//AppAsset::addCss($this,'@web/css/font-awesome/css/font-awesome.min.css');
```

> 此外注意：在上面的addScript方法中，如果没有 ’depends‘=>’xxx‘ ,此处加载的顺序将会颠倒。

**方法2:**  
不需要在资源包管理器中定义方法，只要在视图页面直接引入即可  
```php
AppAsset::register($this);  
//css定义一样  
$this->registerCssFile('@web/css/font-awesome.min.css',['depends'=>['backend\assets\AppAsset']]);  
//$this->registerCssFile('@web/css/index-css.css');

 $this->registerJsFile('@web/js/jquery-ui.custom.min.js',['depends'=>['backend\assets\AppAsset']]);
//$this->registerJsFile('@web/js/jquery-2.1.1.js');

//如下position是让定义CSS/JS出现的位置
//$this->registerJsFile('@web/js/jquery-ui.custom.min.js',['depends'=>['backend\assets\AppAsset'],'position'=>$this::POS_HEAD]);
```  
