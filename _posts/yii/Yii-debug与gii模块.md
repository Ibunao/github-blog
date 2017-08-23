---
title: Yii-debug与gii模块
date: 2017-07-03 11:56:02
tags:
	- yii-debug
	- gii
categories:
    - yii
    - gii
    - debug
---
**开启两个模块**
```php
if (!YII_ENV_TEST) {
    // configuration adjustments for 'dev' environment
    $config['bootstrap'][] = 'debug';//启动加载debug模块
    $config['modules']['debug'] = [//定义debug模块
        'class' => 'yii\debug\Module',
    ];

    $config['bootstrap'][] = 'gii';
    $config['modules']['gii'] = [
        'class' => 'yii\gii\Module',
    ];
}
```
## debug模块  
> debug 模块可以很好的帮助调试和优化，可以查看执行过程所走的sql语句及时间  

**测试代码段执行的时间--profile**   
可以在debug页面请求中的profile选项查看运行情况  
```php
\YII::beginProfile('profile1');     #注意 YII 全大写和 Yii等效，最好不用全大写
echo "hello world";
sleep(1);
\YII::endProfile('profile1');
```

## gii模块  
> 自动生成代码  
