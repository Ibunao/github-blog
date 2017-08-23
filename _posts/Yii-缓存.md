---
title: Yii-缓存
date: 2017-07-03 11:56:02
tags:
	- 缓存
	- http缓存
	- 页面缓存  
	- 片段缓存  

categories:
    - yii
    - 缓存
---
```php
/**
 * 行为方法 钩子函数 在请求其他方法时，会先执行这个方法
 * 可以在里面配置页面缓存
 * 配置后访问将会进行页面缓存
 * @return [type] [description]
 */
public function behaviors()
{
	return [
		//页面缓存
		[
			'class'=>'yii\filters\PageCache',//页面缓存类
			'duration'=>1000,//缓存时间
			'only'=>['cache'],//缓存的页面(方法actionCache中加载的页面)
			'dependency'=>[//缓存依赖
				'class'=>'yii\caching\FileDependency',
				'fileName'=>'hw.txt'
			]
		],
		//http缓存，通过http请求体来告诉浏览器使用缓存情况
		[
			'class'=>'yii\filters\HttpCache',
			'lastModified'=>function(){//每次请求会比对这个值来告诉浏览器是否进行过修改，是否要使用缓存，更倾向于文件修改时间是否改变
				return filemtime('hw.txt');
			},
			'etagSeed'=>function(){//同样是进行比对，更倾向于文件内容是否改变，etag如果不变，lastModified变了也没用
				//简单判断文件是否变化
				$fp=fopen('hw.txt','r');
				$title=fgets($fp);//读取第一行的数据
				fclose($fp);
				return $title;
			}
		]
	];
}
/**
 * 使用缓存
 * 使用缓存类型可以在配置在basic\config\web.php中进行配置
 * components组件下的cache中进行配置
 * @return [type] [description]
 */
public function actionCache()
{
	//获取缓存组件
	$cache = \YII::$app->cache;

	/*//往缓存中写数据，如果对应的key存在则不会进行写入	可以添加第三个参数，表示缓存的时间
	$cache->add('key1','hello world!');

	//修改数据			可以添加第三个参数，表示缓存的时间
	$cache->set('key1','hello world2');

	//删除数据
	$cache->delete('key1');

	//清空所有的数据
	$cache->flush();

	//读取缓存	如果读取不出来则会返回false
	$data = $cache->get('key1');
	var_dump($data);*/

	//依赖，如果依赖的……进行改变或修改时间进行改变则会导致缓存的数据进行失效
	//文件依赖
	/*$dependency = new \yii\caching\FileDependency(['fileName'=>'hw.txt']);
	$cache->add('file_key','hello world!',3000,$dependency);
	var_dump($cache->get('file_key'));*/

	//表达式的依赖 依赖于表达式的结果，如果结果发生变化，则缓存失效
	//get("name")如果改变缓存失效
	/*$dependency = new \yii\caching\ExpressionDependency(
		['expression'=>'YII::$app->request->get("name")']
	);
	$cache->add('expression_key','hello world!',3000,$dependency);
	var_dump($cache->get('expression_key'));*/

	//DB依赖		依赖于查询语句的结果，如果结果发生变化则缓存失效
	/*$dependency = new \yii\caching\DbDependency(
		['sql'=>'SELECT count(*) FROM yiitest1.order']
	);
	$cache->add('db_key','hello world!',3000,$dependency);
	var_dump($cache->get('db_key'));*/

	//片段缓存	在模板页设置
	//片段缓存介绍(主要负责把前端界面的一些区域[不会经常变动的区域：如京东商品分类]缓存起来[缓存到内存或文件中]，下次访问时直接从缓存里把数据拿出来，而不用再从数据库抓取信息，提高了程序的执行效率)
	//显示方法如下,需要使用return进行返回,参数为需要显示的视图名，不需要加后缀，文件后缀名统一为php
	return $this->renderPartial('cache');
}

## cache.php
<?php
	//缓存时间
	$duration=15;
	//缓存依赖
	$dependency=[
		'class'=>'yii\caching\FileDependency',//使用文件依赖
		'fileName'=>'hw.txt'
	];
	//缓存开关
	$enabled=true;
 ?>
 <!-- $this->beginCache()会检查当前是否缓存，如果缓存了将会直接从缓存中读取 -->
 <?php if ($this->beginCache('cache_div',['duration'=>$duration,'dependency'=>$dependency,'enabled'=>$enabled])) { ?>
<div>
	<div>这里是会被缓存的abc</div>
</div>
 <?php $this->endCache();
 } ?>

 <div>
 	<div>这里不会被缓存</div>
 </div>
```
