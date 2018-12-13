---
title: Yii-轻松实现RESTful风格的接口
date: 2018-10-16 20:00:02
tags:
    - yii
    - RESTful
categories:
    - yii  
---

## Yii轻松实现RESTful风格的接口  
### 创建api模块  
我们可以直接复制一份其他的模块，如 `frontend` 模块，假设起名为 `restful`

### 修改配置  
首先我们修改一下配置，为了能够实现模块的自动加载    
```php
common\config\bootstrap.php

// 添加的模块要在这里设置一下别名,为了自动加载
Yii::setAlias('@restful', dirname(dirname(__DIR__)) . '/restful');
```  
然后修改 restful 模块的配置  
```php
restful/config/main.php

...
...

return [
    # 更改项目id
    'id' => 'app-restful',
    # 设置控制器命名空间  
    'controllerNamespace' => 'restful\controllers',
    'components' => [
        'request' => [
            'csrfParam' => '_csrf-restful',
            # 配置获取请求参数的格式，可以接收并解析json格式的数据
            'parsers' => [
                'application/json' => 'yii\web\JsonParser',
            ]
        ],
        'user' => [
            'identityClass' => 'common\models\User',
            // 不允许使用session
            'enableSession' => false,
        ],

        ...
        ...

        'urlManager' => [
            'enablePrettyUrl' => true,
            // 最好开启，如果如开启，在不满足配置的路由规则后或使用默认的路由规则进行解析  
            // 'enableStrictParsing' => true,
            'showScriptName' => false,
            'rules' => [
                /**
                 * 配置url解析规则类
                 * controller 配置的控制器id 配置的控制器访问的时候要用复数的形式
                 */
                ['class' => 'yii\rest\UrlRule', 'controller' => ['user']],
            ],
        ],
    ],
];
```
<!--more-->
### 创建控制器   
创建控制器就更简单了  
```php
namespace restful\controllers;

use Yii;
use yii\rest\ActiveController;

class UserController extends ActiveController
{
    // 对应的模型类
	public $modelClass = 'common\models\User';
}
```  
此时，一个简单的RESTful风格的接口已经创建好了，我们肯定不能止步于此，下面我们具体分析一下   

## 解析&&实战操作   
### 配置  
先看配置的 `Request` 组件，为了能够解析请求体数据为json格式  
```php
'request' => [
    'parsers' => [
        'application/json' => 'yii\web\JsonParser',
    ]
]
```
> info： 上述配置是可选的。若未按上述配置，API 将仅可以分辨 `application/x-www-form-urlencoded` 和 `multipart/form-data` 输入格式。也就是通过 `$_POST` 进行获取参数。

我们可以看一下 `Request` 类的 `getBodyParams` 方法，方法中会根据请求的 `Content-Type` 来用不同的解析器解析请求参数，这里配置的 `'application/json' => 'yii\web\JsonParser'` 就是为了能够在请求头参数为 `Content-Type:application/json` 时请求体的json数据能够很好的被解析  

#### 路由配置  
常用的参数如下  
```php
'urlManager' => [
    'enablePrettyUrl' => true,
    // 最好开启，如果不走rest的路由规则不满足就不用使用默认的了
    // 'enableStrictParsing' => true,
    'showScriptName' => false,
    // 配置url解析规则类
    'rules' => [
        /**
         * controller 配置的控制器id 配置的控制器访问的时候要用复数的形式
         * 如：GET users
         */
        ['class' => 'yii\rest\UrlRule', 'controller' => ['user']],
        /**
         * 配置控制器ID 的映射。
         * 访问格式如：GET u
         */
        // ['class' => 'yii\rest\UrlRule', 'controller' => ['u' => 'user']],
        /**
         * 其他常用的配置。
         *
         */
        [
            'class' => 'yii\rest\UrlRule',
            'controller' => 'product',
            // 用来禁止复数形式
            // 'pluralize' => false,
            // 只有delete允许请求，如果请求，将会返回404
            // 'only' => ['delete'],
            // 排除对index的请求，其他的都可以，如果请求，将会返回请求options的结果
            // 'except' => ['index'],
            // 排除对delete的请求，其他的都可以，如果请求，将会返回请求options的结果
            'except' => ['delete'],
            // 配置额外自定义的访问
            // 访问格式如 POST /products/search 可以支持新行为 search
            'extraPatterns' => [
                'POST search' => 'search',
            ],
        ],
    ],
]
```
其他的配置等详解Yii路由的文章的时候看一下就可以了   

### 资源设置  
可以根据url上设置参数来获取指定的字段值, 看一下官方案例  
```
// 返回fields()方法中申明的所有字段，默认是所有字段
http://localhost/users

// 只返回fields()方法中申明的id和email字段
http://localhost/users?fields=id,email

// 返回fields()方法申明的所有字段，以及extraFields()方法中的profile字段
http://localhost/users?expand=profile

// 返回回fields()和extraFields()方法中提供的id, email 和 profile字段
http://localhost/users?fields=id,email&expand=profile
```
> fields() 方法默认返回的是表解析出来的所有字段  
> extraFields() 方法需要自己写，返回的是关联的属性  

#### 覆盖 fields() 方法  
官方案例  
```php
// 明确列出每个字段，适用于你希望数据表或
// 模型属性修改时不导致你的字段修改（保持后端API兼容性）
public function fields()
{
    return [
        // 字段名和属性名相同
        'id',
        // 字段名为"email", 对应的属性名为"email_address"
        'email' => 'email_address',
        // 字段名为"name", 值由一个PHP回调函数定义
        'name' => function ($model) {
            return $model->first_name . ' ' . $model->last_name;
        },
    ];
}

// 过滤掉一些字段，适用于你希望继承
// 父类实现同时你想屏蔽掉一些敏感字段
public function fields()
{
    $fields = parent::fields();

    // 删除一些包含敏感信息的字段
    unset($fields['auth_key'], $fields['password_hash'], $fields['password_reset_token']);

    return $fields;
}
```

#### 覆盖 extraFields() 方法  
要想返回关联属性，需要让 `extraFields()` 方法返回关联属性，如下
```php
restful\models\ProductModel

/**
 * 返回需要关联的属性 也就是getUser的缩写
 * @return [type] [description]
 */
public function extraFields()
{
    return ['user'];
}
/**
 * 关联
 * @return [type] [description]
 */
public function getUser()
{
    return $this->hasOne(User::className(), [ 'id' => 'order']);
}
```
请求 ：`GET rest.yiilearn.com/products?fields=product_id,purchase_id&expand=user`   
```json
[
    {
        "product_id": "2605",
        "purchase_id": "1",
        "user": {
            "id": 1,
            "username": "ibunao",
            "auth_key": "Ah5hD1y-TD0B3VUjoYufZhYoP1ayPTvP",
            "password_hash": "$2y$13$hgTMEkDth8QSY4DJoK30hu8Z282YhOR8pdGlXjIeVYORP3OkeODpi",
            "password_reset_token": "mfpKVvJ_QbX2fL0PI7Pyqtb-yqP0D0GZ_1539051580",
            "email": "******@qq.com",
            "status": 10,
            "created_at": 1539050271,
            "updated_at": 1539585374,
            "allowance": "0",
            "allowance_updated_at": "1539585374"
        }
    },
    {
        "product_id": "2606",
        "purchase_id": "1",
        "user": null
    }
]
```
可以看到，expand的参数生效了，但是返回的数据有太多，我们缩减一下  
```php
common\models\User

# 添加fields方法  
public function fields()
{
    return ['id', 'username'];
}
```
返回结果  
```json
[
    {
        "product_id": "2605",
        "purchase_id": "1",
        "user": {
            "id": 1,
            "username": "ibunao"
        }
    },
    {
        "product_id": "2606",
        "purchase_id": "1",
        "user": null
    }
]
```

> AR这种联表方式还是有点复杂的，不推荐。可以直接查返回数据  

### 控制器设置  
控制器需要改变的比较少，无非就是添加一些路由配置的额外的要实现的 `action`，覆盖一些 `behavior` ，重写一下检查权限的方法 `checkAccess()`  
先看案例  
```php
namespace restful\controllers;

use Yii;
use yii\rest\ActiveController;
use yii\data\ActiveDataProvider;
use restful\models\ProductModel;
# 可以同时实现下面三种验证方法
use yii\filters\auth\CompositeAuth;
# 浏览器弹窗口输入获取token
use yii\filters\auth\HttpBasicAuth;
# 从head头获取验证的token
use yii\filters\auth\HttpBearerAuth;
# 从请求链接中获取验证的token
use yii\filters\auth\QueryParamAuth;

class ProductController extends ActiveController
{
	public $modelClass = 'restful\models\ProductModel';
	/**
	 * 覆盖behaviors方法
	 * @return [type] [description]
	 */
	public function behaviors()
	{
	    $behaviors = parent::behaviors();
	    // 重写验证过滤器的配置
	    $behaviors['authenticator'] = [
	        'class' => HttpBearerAuth::className(),
	        // 可以不验证的action
			'optional' => ['index']
	    ];
	    return $behaviors;
	}
	/**
	 * 添加额外配置的action
	 * @return [type] [description]
	 */
	public function actionSearch()
	{
		return Yii::$app->request->post();
	}
    /**
	 * 检查用户访问权限，可以参考rbac
	 * @param  [type] $action actionId
	 * @param  [type] $model  模型对象
	 * @param  array  $params
	 * @return [type]         [description]
	 */
	public function checkAccess($action, $model = null, $params = [])
	{
	    if ($action === 'update' || $action === 'delete') {
	        if ($model->order !== Yii::$app->user->id)
	        	// 不满足抛出异常
	            throw new \yii\web\ForbiddenHttpException(sprintf('You can only %s articles that you\'ve created.', $action));
	    }
	}
}
```
下面我们主要看一下 `behaviors` 部分  
```php
yii\rest\Controller 已经给我们配置好了四个

public function behaviors()
{
    return [
        // 根据请求设置响应格式和语言
        'contentNegotiator' => [
            'class' => ContentNegotiator::className(),
            'formats' => [
                // 这个顺序很重要，如果请求没有设置 Accept:application/json||xml 谁第一个用谁
                'application/json' => Response::FORMAT_JSON,
                'application/xml' => Response::FORMAT_XML,
            ],
        ],
        // 过滤action允许的请求方法
        'verbFilter' => [
            'class' => VerbFilter::className(),
            'actions' => $this->verbs(),
        ],
        // 验证的
        'authenticator' => [
            'class' => CompositeAuth::className(),
        ],
        // 限制速率的
        'rateLimiter' => [
            'class' => RateLimiter::className(),
        ],
    ];
}
```
#### 格式化响应  
这部分已经是写好的了，我们只需要在请求头中加入指定响应格式的参数即可  
```php
# 接收json格式的数据
Accept: application/json;
# 接收xml格式的数据
Accept: application/json;
```
#### 验证  
yii提供了多种验证方法，这里以 `HttpBearerAuth` 验证(head头获取token)为例  
```php
实现验证token的方法(通过token获取到对应的用户)
common\models\User

/**
 * api通过token登陆
 * {@inheritdoc}
 */
public static function findIdentityByAccessToken($token, $type = null)
{
    # 为了方便测试直接用的是已经有的 auth_key
    return static::findOne(['auth_key' => $token, 'status' => self::STATUS_ACTIVE]);
}
```
此时，我们就可以通过获取到的 `token` 进行请求了  
```php
GET rest.yiilearn.com/products  
请求头  
"Authorization":"Bearer Ah5hD1y-TD0B3VUjoYufZhYoP1ayPTvP"  
```
> 固定格式 `"Authorization":"Bearer " + $token `

#### 速率验证  
在实现了用户验证后速率验证才会有用，我们需要 `User` 实现几个方法，如下  
首先我们需要在 `user` 表添加两个字段用来存储剩余次数和访问时间 `allowance`, `allowance_updated_at`  
```php
common\models\User
实现接口
class User extends ActiveRecord implements IdentityInterface,RateLimitInterface

实现下面几个方法  
/**
 * 返回一段时间内允许请求的最大次数
 * @param  [type] $request [description]
 * @param  [type] $action  [description]
 * @return [type]          [description]
 */
public function getRateLimit($request, $action)
{
    // 每五秒可以访问2次
    return [2, 5];
}
/**
 * 获取允许请求的数量和最后的访问的时间戳
 * @param  [type] $request [description]
 * @param  [type] $action  [description]
 * @return [type]          [description]
 */
public function loadAllowance($request, $action)
{
    return [$this->allowance, $this->allowance_updated_at];
}
/**
 * 保存剩余的请求数量和最后的访问时间
 * @param  [type] $request   [description]
 * @param  [type] $action    [description]
 * @param  [type] $allowance [description]
 * @param  [type] $timestamp [description]
 * @return [type]            [description]
 */
public function saveAllowance($request, $action, $allowance, $timestamp)
{
    $this->allowance = $allowance;
    $this->allowance_updated_at = $timestamp;
    $this->save();
}
```
实现起来就是这么简单  
### 版本化 && 错误处理  
比较简单，直接看官方文档 [版本化](https://www.yiichina.com/doc/guide/2.0/rest-versioning) [错误处理](https://www.yiichina.com/doc/guide/2.0/rest-error-handling)
