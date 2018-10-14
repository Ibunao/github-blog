

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
### 创建控制器   
创建控制器就更简单了  
```php
<?php
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
先看配置的 `Request` 组件  
```php
'request' => [
    'parsers' => [
        'application/json' => 'yii\web\JsonParser',
    ]
]
```
> info： 上述配置是可选的。若未按上述配置，API 将仅可以分辨 `application/x-www-form-urlencoded` 和 `multipart/form-data` 输入格式。

我们可以看一下 `Request` 类的 `getBodyParams` 方法，方法中会根据请求的 `Content-Type` 来用不同的解析器解析请求参数，这里配置的 `'application/json' => 'yii\web\JsonParser'` 就是为了能够在请求参数为 `Content-Type:application/json` 能够很好的获取到数据   

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
            // 访问格式如 GET /products/search 可以支持新行为 search
            'extraPatterns' => [
                'GET search' => 'search',
            ],
        ],
    ],
]
```
其他的配置等详解Yii路由的文章的时候看一下就可以了   
