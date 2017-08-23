---
title: Yii-安装advanced版本
date: 2017-07-02 11:56:02
tags:
	- yii安装
	- composer
categories:
    - yii
    - composer
---
## composer安装  
首先确保composer可用  
进入到  [php库](https://packagist.org/) 查找要安装的插件或项目  
如：`yii2-app-advanced`,  
点击进入查询出的条目，会显示安装的命令  
```
composer create-project yiisoft/yii2-app-advanced
```
进入终端,进入到要放置项目的目录执行此命令  

安装途中，由于安装文件较大需要使用github账号辅助，教程  
[github获取token教程](http://note.youdao.com/noteshare?id=f85ec1fbd8aa767ce29c7257f2527ceb)

**安装完成后**  
初始化:进入到项目中执行    
```
php init
```
配置站点  
`hosts` 文件添加站点  
`httpd-vhosts.conf` 配置站点  
```
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host2.example.com
    DocumentRoot "/Users/echo-ding/Documents/ding/www/ibunao"
    ServerName www.ibunao.me
    ErrorLog "/private/var/log/www.ibunao.me-error_log"
    CustomLog "/private/var/log/www.ibunao.me-access_log" common
</VirtualHost>
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host2.example.com
    DocumentRoot "/Users/echo-ding/Documents/ding/www/yii/first/frontend/web"
    ServerName www.yiifirst.com
    ErrorLog "/private/var/log/www.yiifirst.com-error_log"
    CustomLog "/private/var/log/www.yiifirst.com-access_log" common
</VirtualHost>
```

配置数据库  
在配置文件中的 `component` 组件下配置
```php
'db' => [
    'class' => 'yii\db\Connection',
    'dsn' => 'mysql:host=localhost;dbname=yiifirst',
    'username' => 'root',
    'password' => '******',
    'charset' => 'utf8',
],
```
此时数据库中只有  
```sql
mysql> show tables;
+--------------------+
| Tables_in_yiifirst |
+--------------------+
| test               |
+--------------------+
mysql> desc test;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(11)     | NO   | PRI | NULL    |       |
| test  | varchar(45) | NO   |     |         |       |
+-------+-------------+------+-----+---------+-------+
```
进入到安装目录执行 `php yii migrate` 命令生成user表  
```
ding:~ echo-ding$ cd Documents/ding/www/yii/first/
ding:first echo-ding$ php yii migrate
Yii Migration Tool (based on Yii v2.0.12)

Creating migration history table "migration"...Done.
Total 1 new migration to be applied:
	m130524_201442_init

Apply the above migration? (yes|no) [no]:y
*** applying m130524_201442_init
    > create table {{%user}} ... done (time: 0.036s)
*** applied m130524_201442_init (time: 0.044s)


1 migration was applied.

Migrated up successfully.
```
执行成功后查看数据库，将会多出两张表  
```sql
mysql> show tables;
+--------------------+
| Tables_in_yiifirst |
+--------------------+
| migration          |
| test               |
| user               |
+--------------------+
```
安装插件
和安装yii相似，先在网站上查找需要安装的插件，然后进入yii项目中执行安装命令  
```
composer require ibunao/yii2-weditor
```  
redis 、mongodb配置
```php
'redis' => [
    'class' => 'yii\redis\Connection',
    'hostname' => 'localhost',
    'port' => 6379,
    'database' => 0,
],
'mongodb' => [
    'class' => '\yii\mongodb\Connection',
    'dsn' => 'mongodb://ding:ding@localhost:27017/test',
],
```

## 归档安装  
在window下安装的  
1. 将php.exe所在文件夹配置到环境变量中
2. 进入到advanced版本的根目录init所在目录   导航栏cmd进入cmd窗口
3. 输入 `php init`  确认,一步一步选择执行就好了
4. 创建数据库，配置数据库
5. 输入     `php yii migrate`     将会创建两张表一张user表

## composer
window下的composer安装使用  

1. 手动下载安装    下载[composer.phar文件](http://www.phpcomposer.com/)
2. 配置环境变量：
在window中path配置php的全局变量  `php.exe`所在文件夹    `D:\wamp\bin\php\php5.5.12`  
配置composer的全局变量  `composer.phar`文件放置的文件夹    `D:\wamp\www\yii`
在cmd下 ***在git bash中还是找不到命令***   
输入 `composer -v` 会报没有这个命令这时需要进入放置 `composer.phar` 文件的文件夹内，
cmd中输入 `echo @php "%~dp0composer.phar" %*>composer.bat`     目录中会创建一个 `composer.bat` 批处理文件
这时就ok了，可以全局的使用composer命令了  
为了加快下载速度使用镜像网站，进行全局配置    cmd中输入  

```
composer config -g repo.packagist composer https://packagist.phpcomposer.com
```
可以在 https://packagist.org/    上输入yiisoft/yii2来搜索yii的扩展程序包  
**使用composer安装**
composer之 `require` 命令    安装
`require`命令   不需要 `json`文件   直接安装  
进到项目根目录里面有composer.json   然后`php  找到composer.phar文件所在    require    安装的包`      版本号
默认安装在项目的vendor目录中
```
D:\wamp\www\yii\test1\basic>php ../../composer.phar require yiisoft/yii2-gii 2.0.5
```
`install` 命令   根据 `json` 文件下载    当下载的比较多的时候可以根据json文件进行下载，会自动循环读出下载的插件中的json，然后继续下载所需依赖  

`create-project`     以项目的模式将文件下载到本地
