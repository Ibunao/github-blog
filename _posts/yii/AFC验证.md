---
title: Yii-AFC验证
date: 2018-10-11 00:00:02
tags:
    - yii
    - AFC验证
categories:
    - yii  
---


## 实例  
```
use yii\web\Controller;
use yii\filters\AccessControl;

class SiteController extends Controller
{
    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                'only' => ['login', 'logout', 'signup'],
                'except' => ['login'],
                'rules' => [
                    [
                        'allow' => true,
                        'actions' => ['login', 'signup'],
                        'roles' => ['?'],
                    ],
                    [
                        'allow' => true,
                        'actions' => ['logout'],
                        'roles' => ['@'],
                    ],
                ],
            ],
        ];
    }
    // ...
}
```
## 验证流程    
### AccessControl过滤器   
> 注意，如果AccessControll配置的需要验证的action，在配置的rules中如果验证没有通过或者没有rule来验证当前请求的action(也就是不符合所有rule需要验证的action)都会拒绝访问  

####  `only` 和 `except` 配置  
`only` 表示需要验证的 `actionId` ,如果为空，这个控制器的所有action都将会向下进行验证逻辑  

`except` 表示过滤掉的 `actionId` 这些action将不会走校验， `except` 的优先级更高，如果同时属于 `only` 和 `except` 那么这个action将不会走验证  

#### denyCallback 配置  
这个是配置一个匿名函数，一般也不用配置，在 rule 被拒绝的时候如果 rule 没有配置 `denyCallback` 将会执行这个，通常用来抛出异常的，可以参考 yii的兜底方法 `denyAccess`  

### AccessRule 验证规则  
#### 配置  
```php
# 必填，如果为false表示不管通过不通过验证，都为false拒绝  
'allow' => true,
# 选填，判断当前action是否属于验证的范围，如果为空，表示所有action都要验证  
'actions' => ['login', 'signup'],
# 选填，判断当前controller是否属于验证的范围，如果为空，表示所有controller都要验证  
'controllers' => ['site'],
# 选填，判断当前 ip 是否属于验证的范围，如果为空，表示所有 ip 都要验证  
'ips' => ['192.168.*'],
# 选填，判断当前 请求方式 是否属于验证的范围，如果为空，表示所有 请求方式 都要验证
'verbs' => ['post'],  
# 选填，添加额外的自定义验证方法，如果不设置role参数，也就意味着只验证此方法  
'matchCallback' => function ($rule, $action){},  
# 选填，一般也不用配置，当验证失败时执行   
'denyCallback' => function ($rule, $action){},  
```
最后两个参数也是验证的关键  
```
role => ['@', '?', 'otherRole']

? : 表示允许未登录的访问  
@ : 表示未登录才能访问
otherRole : 其他的都是对应的权限/角色 详见RBAC   

roleParams => function($rule){} || String || Array # （算出来的）值将会作为权限的参数  
```
