
## 说明  
可以先参看 [中文官方文档](https://www.yiichina.com/doc/guide/2.0/security-authorization)  
yii 为我们提供的两种存储方式一种是文件方式一种是数据库方式，这里我们直接使用数据库的方式，yii 文档给的是直接写代码执行的方式，这种虽然更灵活，但是不够直观，而且最常用到的地方就是后台，所以我们使用可视化的模块 `yii-admin`  

> `yii-admin` 扩展过的rbac 和 yii 自带的有一点区别的是权限，yii以权限为基础，而 `yii-admin` 是以路由为基础的，这一点会在验证的时候进行体现, yii的是`Yii::$app->user->can(role||permission, params)` ，而 yii-admin 的是 `Yii::$app->user->can(route, params)`  

## 准备  
首先安装 `yii-admin` 扩展，[github地址](https://github.com/mdmsoft/yii2-admin)   
### 创建表  
两条命令，首先创建yii自带的rbac相关表  
```
yii migrate --migrationPath=@yii/rbac/migrations
```
将会创建四张表  
itemTable： 该表存放授权条目（译者注：即角色和权限）。默认表名为 "auth_item" 。
itemChildTable： 该表存放授权条目的层次关系。默认表名为 "auth_item_child"。
assignmentTable： 该表存放授权条目对用户的指派情况。默认表名为 "auth_assignment"。
ruleTable： 该表存放规则。默认表名为 "auth_rule"。  

执行yii-admin带的menu表  
```
yii migrate --migrationPath=@mdm/admin/migrations
```
将会得到一个menu表

### 配置  
```php
// 配置成中文，配置这个后将会根据国际化功能把英文映射成对应的中文  
'language' => 'zh-CN',  

// 配置模块
'modules' => [
	'admin' => [
		'class' => 'mdm\admin\Module',
		'layout' => 'left-menu', // yii2-admin的导航菜单
	]
	...
],
// 配置权限
'components' => [
	...
	'authManager' => [
		'class' => 'yii\rbac\DbManager', // or use 'yii\rbac\PhpManager'
	]
],
// 为app注册行为 这个是检验用户是否有权限进行访问的
'as access' => [
	'class' => 'mdm\admin\components\AccessControl',
    # 配置不检查权限的路由
	'allowActions' => [
		'site/*',
		'admin/*', //允许所有人访问admin节点及其子节点
	]
],
```
## 应用  
先感受一下配置好后进入admin模块的样子  

![初始图](/images/yii/rbac/admin1.png)  

### 路由 Route  
路由相当于一个资源,最小单位  
使用很简单， `1`、`2` 通过 `3` 添加到 `5` ，其中 `1` 是自己输入路由（以 `/` 开头），`2` 为自动检测出来的路由， `5` 为添加到数据库的路由资源， `4` 为移除 `5` 的操作  
添加的路由会添加到 `auth_item` 表 ，如下  

![auth_item](/images/yii/rbac/admin-route1.png)  
### 权限 permission  
一个权限可以包含多个路由，和一个规则rule  
#### 添加权限  
先创建一个权限

![permission](/images/yii/rbac/admin-permission1.png)

对应表的变化  

![auth_item](/images/yii/rbac/admin-permission2.png)  

然后增加路由  

![permission](/images/yii/rbac/admin-permission3.png)  

对应表的变化  

![auth_item_child](/images/yii/rbac/admin-permission4.png)  

### 角色 role  
一个角色可以包含多个权限，多个路由和一个规则rule  
#### 添加角色  
先创建一个角色

![role](/images/yii/rbac/admin-role1.png)

对应表的变化  

![auth_item](/images/yii/rbac/admin-role2.png)  

然后增加权限或者路由  

![role](/images/yii/rbac/admin-role3.png)  

对应表的变化  

![auth_item_child](/images/yii/rbac/admin-role4.png)  

### 分配角色权限  
一个用户可以包含多个角色和权限，不能增加路由和规则rule了  
首先我们会看到用户列表  

![assignment](/images/yii/rbac/admin-assignment1.png)  

进行权限分配  

![assignment](/images/yii/rbac/admin-assignment2.png)  

对应表的变化  

![assignment](/images/yii/rbac/admin-assignment3.png)  

#### 测试结果  
![test](/images/yii/rbac/admin-test3.png)

![test](/images/yii/rbac/admin-test3.png)

<<<<<<< HEAD
![test](/images/yii/rbac/admin-test3.png)  
=======
![test](/images/yii/rbac/admin-test3.png)
### 规则 rule  
规则是对权限的补充，算是细分的权限，一般权限是对应这路由的，而规则可以更细一点，比方说一个角色没有更新文章的权限，但是可以有更新自己文章的权限，这个时候就用到rule了  


首先创建 rule 类, 如下    
```php
```

添加rule  

![rule](/images/yii/rbac/admin-rule1.png)

对应表的变化  

![rule](/images/yii/rbac/admin-rule2.png)  

为权限或者角色添加rule  

![rule](/images/yii/rbac/admin-rule3.png)

对应表的变化  

![rule](/images/yii/rbac/admin-rule4.png)

#### 发现错误  
添加完了我们验证一下   
![rule](/images/yii/rbac/admin-rule5.png)  
发现无权限(正常)，并且没有走rule，这是因为什么呢？  
还记得 文章开头 **说明** 部分将的yii、yii-admin验证的区别么？  
yii-admin 验证的时候验证的是 route ，也就是 `/goods/index`，验证的rule当然也就是 `/goods/index` 绑定的 rule  
而我错误的将 rule 设置到了 权限 test1 上了，但是这个先不用改，我们来验证一下 yii验证 和 yii-admin验证的区别  
为了使用 yii 的验证，我们需要改动两个地方  
```php
配置文件 config/main.php 注释掉 使用 yii-admin 验证的部分  
// 'as access' => [
//     'class' => 'mdm\admin\components\AccessControl',
//     'allowActions' => [
//         'site/*',//允许访问的节点，可自行添加
//         'admin/*',//允许所有人访问admin节点及其子节点
//     ]
// ],

在 GoodsController 控制器添加验证，这个忘记的可以参看 AFC验证 部分    
public function behaviors()
{
    return [
        'access' => [
            'class' => AccessControl::className(),
            'rules' => [
                [
                    'actions' => ['index'],
                    'allow' => true,
                    'roles' => ['role1'],
                    'roleParams' => ['a', 'b', 'c'],
                ],
            ],
        ],
    ];
}
```
你会发现很自然的通过了，因为这个检验的逻辑是判断当前用户是访问 `goods/index` 时，用户的角色是否是 `role1`,符合也就很自然的通过了  

#### 更正  
将代码改回 yii-admin 验证  
首先我们要添加

>>>>>>> 8124fc1b1c91734b1ae78a0f99b4606eba765757
### 用户列表  
`yii-admin` 为后台也提供了一系列的用户操作功能（注册、改密码等），但是默认是没有显示的，需要自己根据自己的需要添加按钮  

![user](/images/yii/rbac/admin-user1.png)  

如果你的没有显示上面红框的内容可以参考我的代码   
```php  
找到action对应的视图  
    ...
    ...
    # 增加的创建用户按钮
    <p>
        <?= Html::a(Yii::t('rbac-admin', 'Create User'), ['signup'], ['class' => 'btn btn-success']) ?>
    </p>

    ...
    ...

    <?=
    GridView::widget([
        ...
        ...
            [
                'class' => 'yii\grid\ActionColumn',
                // 这个原始的有问题，直接上下面那行
                // 'template' => Helper::filterActionColumn(['view', 'activate', 'delete']),
                'template' => '{view} {activate} {delete}',
                'buttons' => [
        ...
        ...
</div>
```

### 目录 menu  

`yii-admin` 增加了目录功能，可以设置目录，然后根据用户的权限来显示目录  

增加目录，数据的作用会在后面说  

![menu](/images/yii/rbac/admin-menu1.png)  

增加子目录，注意排序  

![menu](/images/yii/rbac/admin-menu2.png)  

增加子目录，注意排序  

![menu](/images/yii/rbac/admin-menu3.png)  

对应表的变化    

![menu](/images/yii/rbac/admin-menu5.png)

目录显示  

![menu](/images/yii/rbac/admin-menu4.png)  

目录显示的代码  
```php
views\layout\main.php

...
...

<!-- 增加yii-admin设置的目录 -->
<?php
use mdm\admin\components\MenuHelper;
// 这个匿名函数可以根据设置menu时的数据，将英文转成中文
$callback = function($menu){
    $data = $menu['data'];
    return [
        // 显示改成设置的数据
        'label' => $data ? $data : $menu['name'],
        'url' => [$menu['route']],
        'items' => $menu['children']
    ];
};
// 获取用户权限能看到的菜单，这个是关键
$items = MenuHelper::getAssignedMenu(Yii::$app->user->id, null, $callback);
 ?>
...
...
    // 合并权限目录
    $menuItems = array_merge($items, $menuItems);
    echo Nav::widget([
        'options' => ['class' => 'navbar-nav navbar-right'],
        'items' => $menuItems,
    ]);
    NavBar::end();
    ?>
...
...
```










也可以参考以下不错的文章  
[北哥这篇文讲解yii2权限扩展（yii2-admin） - 上部 ](https://www.yiichina.com/topic/7080)  
[北哥这篇文讲解yii2权限扩展（yii2-admin） - 中部](https://www.yiichina.com/topic/7082)  
[北哥这篇文讲解yii2权限扩展（yii2-admin） - 下部](https://www.yiichina.com/topic/7086)  
[Yii2项目后台整合yii2-admin模块](https://www.kancloud.cn/curder/yii/247759)   
[Yii2基于角色的权限控制（RBAC）](http://www.yii-china.com/doc/rbac/157.html)  
