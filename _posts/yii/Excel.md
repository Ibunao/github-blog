---
title: Yii-Excel
date: 2018-11-09 00:00:02
tags:
    - yii
    - excel
categories:
    - yii  
---
## 说明  
对excel的操作常用的操作一般还是比较简单的，如果直接去看 `phpexcel` 可能会感觉方法太多而无从下手，我们这里直接用经过封装过的 `yii-excel` 来进行学习就相对简单的多，最后也提供了一个更简单的写excel的和读写csv的两个类供参考学习  
用到的两张表放在最后附件了，自行下载，用到的两个模型类是通过 `gii` 直接创建的  
## 开始  
### 安装 `yii-excel`  
直接进项目执行  
```php
composer require --prefer-dist moonlandsoft/yii2-phpexcel "*"
```
安装后 `vendor` 目录下将会多两个文件夹 `moonlandsoft/yii-phpexcel` 和 `phpoffice/phpexcel`  

### 下载excel   
#### 一表单sheet  
看代码吧，注释已经很清楚了  
```php
/**
 * 一表单sheet下载
 * @return [type] [description]
 */
public function actionIndex()
{
	$models = LevelModel::find()->all();
	Excel::widget([
		'models' => $models,
		'fileName' => '下载', // 设置下载文件名
		// 'savePath' => 'D:\ding\wamp64\www\yii\advance\yii-learn\backend\runtime', // 生成在服务器  
		'mode' => 'export', // 导出
		'columns' => ['level_id','level_name','p_order'], // 列，通过 $model['level_id'] 来取对应的值
		'headers' => ['level_id' => 'Header Column 1','level_name' => 'Header Column 2', 'p_order' => 'Header Column 3'], // 列对应的header ，title行的数据
	]);
}
```
level 表结构  

![](/images/yii/excel/biao1.png)  

下载的 excel 结果  

![](/images/yii/excel/excel1.png)

#### 一表多sheet  
```php
/**
 * 一表多sheet 下载
 * @param  string $value [description]
 * @return [type]        [description]
 */
public function actionMultiple()
{
	$model1 = LevelModel::find()->all();
	$model2 = ColorModel::find()->all();
	Excel::widget([
		'isMultipleSheet' => true,
		'models' => [
			'sheet1' => $model1,
			'sheet2' => $model2,
		],
		'mode' => 'export', //default value as 'export'
		'columns' => [
			'sheet1' => ['level_id','level_name','p_order'],
			'sheet2' => ['color_no','color_name','scheme_id'],
		],
		'headers' => [
			'sheet1' => ['level_id' => 'Header Column 1','level_name' => 'Header Column 2', 'p_order' => 'Header Column 3'],
			'sheet2' => ['color_no' => 'Header Column 1','color_name' => 'Header Column 2', 'scheme_id' => 'Header Column 3'],
		],
	]);
}
```
color 表结构  

![](/images/yii/excel/biao2.png)  

下载的 excel 结果  

![](/images/yii/excel/excel2.png)

#### 下载数组格式的  
使用已经准备好的数据，下载成excel而不依赖model  

```php
/**
 * 一表单sheet下载
 * @return [type] [description]
 */
public function actionData()
{
	$models = [
		['level_id' => 1, 'level_name' => 'ding', 'p_order' => 21],
		['level_id' => 2, 'level_name' => 'ding', 'p_order' => 21],
		// 生成空行
		['level_id' => '', 'level_name' => '', 'p_order' => ''],
		// 巧妙设置统计信息
		['level_id' => '总额：', 'level_name' => '128'],
	];
	Excel::widget([
		'models' => $models,
		'fileName' => '下载', // 设置下载文件名
		// 'savePath' => 'D:\ding\wamp64\www\yii\advance\yii-learn\backend\runtime', // 生成在服务器  
		'mode' => 'export', // 导出
		'columns' => ['level_id','level_name','p_order'], // 列，通过 $model['level_id'] 来取对应的值
		'headers' => ['level_id' => 'Header Column 1','level_name' => 'Header Column 2', 'p_order' => 'Header Column 3'], // 列对应的header ，title行的数据
	]);
}
```
下载的 excel 结果  

![](/images/yii/excel/excel3.png)  

### 读取excel文件数据  
为了方便测试，直接把excel放在了 `web` 目录下  

#### 读取单文件  
可以开启 `getOnlySheet` 注释进行自行测试  
```php
/**
 * 读取单文件
 * @return [type] [description]
 */
public function actionImport()
{
	$fileName = 'exports2.xls';
	$data = Excel::widget([
		'mode' => 'import', // 导入模式
		'fileName' => $fileName, // 文件名
		'setFirstRecordAsKeys' => true, // 是否使用第一行的title字段作为行数据的key
		'setIndexSheetByName' => true, // 是否使用sheet名作为sheet数组的key
		// 'getOnlySheet' => '单元1', // 读取那个sheet的name ，如果不设置则读取所有的sheet
	]);
	echo json_encode($data);
}
```
excel 文件结构  

![](/images/yii/excel/excel4.png)  

读取的数据结构  

![](/images/yii/excel/result1.png)  

#### 读取多文件  
一次读取多个文件的数据  
```php
/**
 * 读取多文件
 * @return [type] [description]
 */
public function actionImporttwo()
{
	$fileName1 = 'exports2.xls';
	$fileName2 = 'exports1.xls';
	$data = Excel::widget([
		'mode' => 'import', // 导入模式
		'fileName' => [
			'file1' => $fileName1,
			'file2' => $fileName2,
		],
		'setFirstRecordAsKeys' => true,
		'setIndexSheetByName' => true,
		// 'getOnlySheet' => '单元1', // 读取那个sheet的name ，如果不设置则读取所有的sheet
	]);
	echo json_encode($data);
}
```
读取的数据结构  

![](/images/yii/excel/result2.png)    

### 其他  
#### 简单的下载Excel的类  
看dome比较简单  
```php
<?php
/**
 *
 * // dome  
 * // 下载的文件名
 * $filename = 'test';
 * // title行
 * $titles = ['title1'];
 * SimpleExcel::echoBegin($filename, $titles);
 * $data = [
 *     ['1a'], // 第一行
 *     ['2a', '2b'], // 第二行
 * ];
 * SimpleExcel::echoRows($data);
 * // 追加行
 * SimpleExcel::echoRows($data);
 * // 输出
 * SimpleExcel::echoFinish();
 *
 * 注意不要下载数据量太大的，会非常慢，而且excel有行数限制
 */
class SimpleExcel
{
    /**
     * 设置请求头
     * @param string $filename [description]
     */
    private static function setHeaders($filename = 'data')
    {
        // 检验header头是否已经发送
        if (headers_sent($file, $line)) {
            echo 'Header already sent @ ' . $file . ':' . $line;
            return;
        }

        //header('Cache-Control: no-cache;must-revalidate'); //fix ie download bug
        header('Pragma: no-cache, no-store');
        header("Expires: Wed, 26 Feb 1997 08:21:57 GMT");
        header('Content-type: application/force-download;charset=utf-8');
        header("Content-Disposition: attachment; filename=\"" . $filename . '"');
    }

    /**
     *
     * @param  [type] $filename [description]
     * @param  array  $titles   [description]
     * @return [type]           [description]
     */
    public static function echoBegin($filename = '', $titles = [])
    {
        if (empty($filename)) {
            $filename = date("Y-m-d");
        }
        self::setHeaders($filename . '.xls');
        echo '
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <style>
                td{vnd.ms-excel.numberformat:@}
            </style>
        </head>';
        echo '<table width="100%" border="1">';
        echo '<tr><th filter=all>' . implode('</th><th filter=all>', $titles) . "</th></tr>\r\n";
        flush();
    }

    public static function echoRows($rows)
    {

        foreach ($rows as $row) {
            echo '<tr><td>' . implode('</td><td>', $row) . "</td></tr>\r\n";
        }
        flush();
    }

    public static function echoFinish()
    {
        echo '</table>';
        flush();
    }

}

```
#### csv文件的读取和下载   
读取csv格式文件和将数据生成csv格式文件  
```php  
<?php
/**
 *
 * // dome  
 * // 下载的文件名
 * $filename = 'test.csv';
 * // title行
 * $titles = ['title1', 'title2'];
 * $data = [
 *     ['1a', '1b'], // 第一行
 *     ['2a', '2b'], // 第二行
 *     # 加前引号，表示字符串格式的数据  
 *     ["'".'123456789999.00', '1234567899990000000.00'],
 * ];
 *
 * SimpleCsv::exportCsv($titles, $data, $filename);

 * // 上传数据
 * // 上传文件的文件名
 * $filename = './test.csv';
 * var_dump(SimpleCsv::importCsv($filename));
 *
 * csv 格式可以突破excel行数的限制，而且速度也相对较快  
 * 缺点就是如果需要excel的其他操作需要另存为excel
 */
class SimpleCsv
{
    /**
     * 导出csv文件
     * @param  Array  $csv_header title行
     * @param  Array  $data       数据
     * @param  string $filename   文件名 以 .csv 结尾
     * @return [type]             [description]
     */
    public static function exportCsv(Array $csv_header, Array $data, $filename='')
    {
        $filename =$filename?$filename:date('Ymd').'.csv'; //设置文件名
        header("Content-type:text/csv");
        header("Content-Disposition:attachment;filename=".$filename);
        header('Cache-Control:must-revalidate,post-check=0,pre-check=0');
        header('Expires:0');
        header('Pragma:public');
        foreach ($csv_header as $k => $v) {
            $csv_header[$k] = iconv('utf-8','gb2312',$v);
        }
        echo implode(',', $csv_header) . "\n";
        $str = '';
        foreach($data as $v){
            foreach ($v as $key => $col){
                $v[$key] = iconv('utf-8','gb2312//IGNORE',$col);
            }
            $abc = implode(',',$v);
            $str .= $abc. "\n";
        }
        echo $str;
        flush();
    }

    /**
     * 导入csv
     * @param $file
     * @internal param $filename
     * @return array|bool
     */
    public static function importCsv($file)
    {
        $handle = fopen($file, 'r');
        $result = self::inputCsv($handle); //解析csv
        fclose($handle);                                                //关闭指针
        return $result;
    }
    /**
     * 处理导入数据
     * @param $handle 	fopen($file, 'r')
     * @return array
     */
    private static function inputCsv($handle) {
        $out = array ();
        $n = 0;
        while ($data = fgetcsv($handle)) {
            $num = count($data);
            for ($i = 0; $i < $num; $i++) {
                $out[$n][$i] = mb_convert_encoding($data[$i],'UTF-8','GBK');
            }
            $n++;
        }
        return $out;
    }

}
```
## 附件  

[level表](/images/yii/excel/meet_level.sql)  
[color表](/images/yii/excel/meet_color.sql)
