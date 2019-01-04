
## 前言  
上次已经介绍过了 `yii-apidoc` 扩展，但是根据备注生成接口文档感觉还不是我们真正需要的。也稍微查了一下 `apidoc` 是可以生成接口文档的，但是看到要装这装那也就没倒腾。之前看到过一个及其好用的生成接口文档并提供接口测试的项目，研究改动了一下做成一个包供大家使用。  
这个因为用到Yii框架，所以依赖于Yii，你也可以根据自己的框架改动部分代码  
## 使用说明  
[packagist地址](https://packagist.org/packages/ibunao/yii2-apidoc)  
### 安装  
```php
composer require ibunao/yii2-apidoc
```
### 配置  
#### 配置到模块数组  
假设我们要放到 `backend` 项目下  
```php
'modules' => [
    ...
    ...
    'document' => [
        'class' => 'ibunao\apidoc\Module',
        # 配置访问接口的host  通常配置 frontend 项目的域名
        'debugHost' => 'http://api.yiidoc.com',
        # 和配置时定义的模块名一致
        'moduleName' => 'document',
    ],
    ...
    ...
],
```
> 注意：如果访问的是其他域名，会存在跨域问题，需要在指向项目中添加header头,如 `header("Access-Control-Allow-Origin: *");` 允许所有  

<!-- more -->
#### 配置需要接口文档的控制器    

```php
return [
	'apiList' => [
		'test' => [
			'label' => '文档测试',
			'class' => 'frontend\controllers\ApidocController',
		],
		'test2' => [
			'label' => '文档测试2',
			'class' => 'frontend\controllers\Apidoc2Controller',
		],
	],
];
```
#### 表和静态资源  
剩下的需要设置的就是创建一个表用来存储文档编辑部分数据，还有就是将静态资源放到指定位置。相关文件放在 `vendor\ibunao\yii2-apidoc\source`
1. 需要创建表的sql看 `document_api.sql` 文件  
2. 以配在 `backend` 项目为例，把 `css` 和 `js` 文件夹放在 `backend\web` 下  

为什么不用资源发布和数据库迁移？  
不想费劲

### 生成文档的备注格式   

**@name表示接口名称，不注释则文档不显示该接口**

@uses表示接口简介/用途等，可空

@method表示请求方式，不注释默认为get

@param表示请求参数，可空可多个，后面分别跟类型、参数名，备注

@author表示接口作者/负责人，可空

```php
/**
 * 注册步骤一：手机号获取验证码
 *
 * @name	获取注册验证码
 * @uses	用户注册是拉取验证码
 * @method	post
 * @param	string $phone 手机号
 * @author	echoding
 */
public function actionIndex()
{
    Yii::$app->response->format = 'json';
	return Yii::$app->request->post();
}
```
![apidoc4](/images/yii/apidoc/apidoc4.png)  

### 示例  
首页  

![apidoc3](/images/yii/apidoc/apidoc3.png)  

可以编辑文档说明和示例  

![apidoc5](/images/yii/apidoc/apidoc5.png)  

接口调试

![apidoc6](/images/yii/apidoc/apidoc6.png)
