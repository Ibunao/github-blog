---
title: mysql基础操作
date: 2017-07-01 11:56:02
tags:
	- mysql
categories: mysql
---

## 终端使用
**安装数据库**  
`brew` 安装  启动  

**连接数据库**  
```sql
mysql -uroot -p
```  

**数据库存放位置**  
`/usr/local/var/mysql/`
> 可以通过 `find / -name *.frm` 查找  

**创建数据库**  
```sql
create  database  数据库名  [charset  字符编码名] [collate  排序规则名];
```
> 查看mysql中的所有字符编码名(字符集)

```sql
show charset;
```
> 查看所有的排序规则名  

```sql
show collation;
```
创建数据库
```sql
CREATE DATABASE test CHARSET utf8;
```
**修改数据库**  
```sql
alter  database  数据库名  [charset  字符编码名] [collate  排序规则名];
```
**数据文件**  
![](/images/mysql/test-dababase-file.png)  
> test 数据库文件夹
> db.opt 数据库文件  
> myisam_1.frm 表结构文件
> myisam_1.MYD 数据文件  
> myisam_1.MYI 索引文件

**退出**  
`quit` 或者 `exit`  
**备份数据库**  
> mysqldump  -h要备份的数据库所在的服务器  -u用户名  -p  数据库名 >  完整目标文件名
> 不需要进入mysql服务执行

```
mysqldump -hlocalhost -uroot -p test > /Users/echo-ding/Documents/ding/test.sql
```
**恢复数据库**
```
先把原来的删除  
drop  database test;#删除数据库
show databases;#显示所有的数据库
CREATE DATABASE test CHARSET utf8;

还原  注意：先要创建还原的数据库test
mysql -hlocalhost -uroot -p test < /Users/echo-ding/Documents/ding/test.sql
```

**命名规则**  
> 本身并不区分大小写，但是由于在unix、linux上的文件名区分大小写，所以数据库名字和表名、视图是区分大小写的
> 对于可能用到系统关键词的 使用反撇号 ` ` ` 包裹  

**删除数据库**  
> `drop database 数据库名`  

**查看所有数据库**  
> `show databases;`  

**选择数据库**  
> `use 数据库名称;`  

### 表的一般操作  
**查看当前数据库下的表**  
```sql
show tables;
```
**删除表**  
```sql
drop 表名；
```
**查看表结构**  
```sql
desc 表名;
```
**查看表的创建语句**  
```sql
show create table 表名;
```
**复制表结构**
```sql
create table [if not exists] 新表名 like 原表名;
```
**清空一张表**  
```sql
truncate 表名;
```
> 相当于删除一张表重新创建  

**添加列**  
```sql
alter table 表名 add 字段 类型;
```
**更改表名**  
```sql
alter table oldtablename to newtablename;
```

**创建表**  
```sql
create table [if  not  exists] 表名(键名 类型 , ……)
```  
创建指定编码格式的表  
```sql
create table 表名(键名 类型 , ……) charset utf8;
```  
例子：  
```sql
create table msg(id int primary key auto_increment,title varchar(60)) charset utf8;
```

```sql
USE test; #选用数据库
CREATE TABLE myisam_1 (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	title VARCHAR(8) NOT NULL DEFAULT '',
	PRIMARY KEY (id)
) ENGINE = MYISAM CHARSET=utf8;#myisam引擎的
```
**字段属性**  
> 索引  

`primary key (fields1[,fields2,……])` :设定主键，每个表需要(必须,只能)有一个,字段值不能重复。可以多个字段共同组成一个主键。   
`unique  key (fields1[,fields2,……])` ：用于设定该字段的值，在这个表中，不可以重复（即是唯一的）  
`key (fields1[,fields2,……])`  : 普通索引，仅仅是建立了索引  
`fulltext key (fields1[,fields2,……])` ：全文索引，目前对中文支持不好  
`foreign (fields1[,fields2,……]) references 其他表(fields1[,fields2,……])`  : 设定外键，附加外键索引和外键约束  
>> 外键：  
>> 构建两个表之间的联系，表1中的外键和另表2的主键(只要是不重复的应该都可以)对应，这样通过表1的外键就可以在表2，查出对应的数据。表1的外键和表2的主键字段的类型必须一致。  
    一张表可以有多个外键指向不同的表  

> 创建索引可以加快查找的速度，但是添加的速度会变慢，但一般程序查的功能较多  

.
> 其它  

auto_increment ：用于设定一个字段值(整型的)的自动增长(自增)，而且，它设定后还必须同时设定在一个字段为一个“key”(比如:priamry key 或 unique key)
not  null： 用于设定一个字段的值不能为空值（null）——如果不设定，则就是可为空值；非空约束
null是一种类型,比较时,只能用专门的is null 和 is not null来比较.
碰到运算符,一律返回null,效率不高,影响提高索引效果  

default  XX值：用于设定某个字段的值，在插入数据的时候如果没有给值，就使用该默认值；  
comment  ‘说明文字’：就是一个说明字段含义的文字，备注  

**修改表的字段／属性／索引**
```sql
//添加字段(添加列)：
alter table 表名 add 新字段名 字段类型 [附加属性];
//删除字段(删除列):
alter table 表名 drop 字段名;
//修改字段:
alter table 表名 change 旧字段名 新字段名 新字段属性;
//修改表名:
alter table 表名 rename 新表名;
#操作索引
//添加普通索引
alter table xiugai_test add key (realname);
//添加唯一索引
alter table xiugai_test add unique key(realname);
//添加主键索引
alter table xiugai_test add primary key(id);
//添加外键索引
alter table xiugai_test add foreign key(xuehao) references students(id);
//添加字段默认值
alter table xiugai_test alter realname set default 0;
//删除字段默认值
alter table xiugai_test alter realname drop default;
//删除主键
alter table xiugai_test drop primary key;
	如果要删除主键，需要先删除自动增长  
	alter table xiugai_test modify column id int unsigned not null;
//删除外键
alter table xiugai_test drop foreign key xuehao;
//删除索引
alter table xiugai_test drop key realname;
```
## 查
```sql
基本查询语句
select 字段 from 表名 where 条件;
```
###where字句###
**算数运算符**
```sql
+    -    *    /    %
例子：select * from 表名 where 字段名 + 100 < 200;//筛选出相应列加上100依旧小于200的数据    //最好不要字段参与运算，不利于索引
```
**比较运算符**  
```sql
>    >=    <    <=    =(等于)    <>或!=(不等于)             最常用
比较运算符可以在字段中使用，返回的值是0(不满足时)或1(满足时)
例如 SELECT goods_name ,cat_id<8 FROM goods; //cat_id<8列显示的是0或1
这样方便在用sum等函数统计，如sum(cat_id<8)
```
**逻辑运算符**  
```sql
and(与)    or(或)    not(非)    
例子：select * from 表    where    id<6 and c5>1;
```
**is运算符**
```sql
只能对特殊的几个数据进行判断
xx字段 is  true
xx字段 is  false
xx字段 is  null
xx字段 is  not  null
```
**between运算符**
```sql
用法： 字段x between 值1    and    值2;
值1    和    值2    范围之内的都符合条件
例如：    where id between 3 and 6; //id在3和6之间都符合要求
```
**in运算符**
```sql
用法： 字段x    in    (值1,值2,……)   // not in() 相反   
只要字段x的值满足括号中给定的任意的数值就算满足条件
```
**like运算符------模糊查找**
```sql
用法：字段x    like    '要查找的字符'
要查找的字符需要配合    %    _    才能完成模糊查询
%    匹配任意长度的任意字符
_     匹配一个长度的任意字符
如果要特意的匹配数据中包含    %    或    _    的数据，需要进行转义
例如：9_\%    表示匹配    9x%    (x为任意字符)
```
### group by 字句 ---分组
> `group by` 根据 `select` 查询语句查询出的结果进行分组

用法   
```sql
group by 字段名 [asc|desc]，字段名 [asc|desc] , ……
```

1，group by子句是用于将“前面”取得的数据，按某种标准（依据）——也就是字段——来进行分组的。分组，基本上就是，按给定字段的值，相同的值，分在相同的组中，不同的值分在不同的组中。  
2，asc表示分组后，按组的值的大小正序排列，desc是倒序——默认是正序，可以不写。  
3，一个最重要的理解（观念）：分组之后的结果，也是一行一行数据，只是每一行代表“一组”  
> 特别注意：  
分组之后，结果行中的数据，都只能出现“组信息”——描述该组的“应有信息”。  
具体来说，对于分组查询的结果数据（select子句部分），只能出现如下几类数据：  
1， 分组依据本身——即该字段；  
2， 原始字段信息中的数字类型的最大值，最小值，平均值，总和值；  
max(字段)：获得该字段的在组中的最大值；  
min(字段)：获得该字段的在组中的最小值；  
avg(字段)：获得该字段的在组中的平均值；    
sum(字段)：获得该字段的在组中的总和值；  
3， 每一组中所包含的原始数据行的行数，获得方式为：count(\*)

```sql
例子：select 字段1,max(字段2) as 最大值,min(字段3) as 最小值,avg(字段4)as 平均值,sum(字段5)as 总和,count(*)as 总条数,    from 表名    group by 字段1;
as    用来给查询出的字段设置别名，用来表头的显示，也可以在条件部分使用别名代替原字段
按照    字段1    进行分组，分别显示分组后对应字段的一组所有数据的最小值，最大值等等
```
> 如果没有使用聚合函数直接使用字段，默认显示该字段的第一个值  

### having字句  
> having条件语句和where条件语句的区别，使用的目标不一样，where是对原始数据(表数据)进行的筛选行为，而having是对group by分组后形成的数据进行的筛选(可以把group by分组后的结果当成一张表)，having能用的筛选条件只能是select子句中出现的字段

用法：  
```sql
having 条件判断
```
例子：
```sql
select  pinpai ，max(price) as 最高价 , min(price) as 最低价 , avg(price) as 平均价, sum(price) as 价格总和, count(*) as 数量 from 'product' group by pinpai having count(*)    > 2;
或条件用as别名：
select  pinpai ，max(price) as 最高价 , min(price) as 最低价 , avg(price) as 平均价, sum(price) as 价格总和, count(*) as 数量 from 'product' group by pinpai having  数量   > 2;  //和上面的一样
```
### order by排序子句
> 对查询结果进行排序  

用法：  
```sql
order by 字段名 [ [asc|desc]  , 字段名[asc|desc] ,……];
```
按照字段名进行顺序或倒序排序，多个字段名时，先按照第一个字段名排序，再按照第二个字段名进行排序……

### limit 子句

用法：  
```sql
limit [offset,]n
    offset:偏移量(跳过几行)    n取出的条目
    offset省略相当于 limit 0,n
```
### DISTINCT关键字   
**合并查询记过重复行**
合并查询字段结果的重复的行  
``` sql
SELECT DISTINCT mobile, nationality FROM `person`;
```
### 子查询
就是通过把查询语句的值作为条件进行查询的  
> 子查询方便，但是性能原因略低，一般也会回用，省略  
>>执行子查询时，MYSQL需要创建临时表，查询完毕后再删除这些临时表，所以，子查询的速度会受到一定的影响，这里多了一个创建和销毁临时表的过程。  

#### union 子查询
> 合并两个查询的结果

用法：
```sql
select 语句1
union  [distinct | all ]
select语句2
[order  by 子句]
[limit 子句] ;
```
说明：
1. distinct | all用于设定是否消除重复行，默认不写就是distinct，表示会消除重复行；
2. order by子句和limit子句，是对整个联合之后的数据结果进行排序和数量限定；
3. 这两个select语句，要求字段数量必须一致，对应字段类型最好一致；
4. 联合查询的结果数据中，字段名以第一个select语句中的字段名为准；
5. 第一个select语句中的字段名如果有别名，则后续的order by子句就必须使用该别名；  

将两个“字段一致”的查询语句所查询到的结果以“纵向堆叠”的方式合并到一起，成为一个新的结果集。  
结果集的行数是两个独立select查询语句的结果行数的和  
例子：
```sql

```
### 连表查询  
用法：  
```sql
select  XX1,  XX2,  ....  from   表1  [连接方式] join 表2  [ on 连接条件]  where ...
```
常用的两个连表查询

**内连接 inner join**  
```sql
from  表1  inner  join 表2  on 表1.字段1 = 表2.字段2
```
结果：是在交叉连接的结果(两表之间做全相乘的结果)中筛选出符合 on 后面条件的
也是左连接和右连接的交集

**左(外)连接 left [outer] join**  
```sql
from  表1  left [outer]  join 表2  on 表1.字段1 = 表2.字段2
```
假设A表在左，不动。B表在A表的右侧滑动，A表和B表通过一个关系(条件)来筛选B表的行，  
如果符合条件，则B表取出对应的行与A表对应的行组成新的一行数据，添加到结果集中，形成的结果集可以看成一张表，设为C，形成的结果集(表c)最少的行数为左边表(表A)的行数。  
也可以理解为 **内连接的结果
添加上没有匹配上的表A的没有匹配上数据的行(右边部分填充null)**
此时，可以对C表进行查询操作，where ，group，having，order by，limit依旧可以使用

### 视图  
和将查询出来的数据存放到一张新表里一样，不常用。略  
## 增
```sql
形式1：常用
insert [into] 表名 [(字段1,2,3，……)] values (值1,2,3，……)[,(2值1,2,3，……),……];   //插入多行时用逗号分开
形式2：
replace [into] 表名[(字段1,2,……)] values (值1,2,3，……)[,(2值1,2,3，……),……];    //和insert的区别是插入的数据的主键值在表中已存在时插入的将会替换这行数据，而insert将执行失败
形式3：
insert [into] 表名 [(字段1,2,3，……)] select 字段1,字段2,……from 其他表表名;    //插入select中查询到的数据
形式4：
insert [into] 表名 字段1=值表达式,字段2=值表达式,字段3=值表达式，……;
形式5：load data 导入数据     加载数据文件   
load data infile '完整的数据文件路径.文件格式后缀' into table 表名;
可以在txt中创建，数据与数据之间需要用tab进行隔开 ，注意需要使用utf-8格式的，还有与表的字段定义的类型保持一致(数据不用加引号)，路径中的\可以用/也可以进行转义\\使用
```
**插入数据**
```sql
INSERT INTO myisam_1 VALUES (23, '李牧');
INSERT INTO myisam_1 VALUES (12, '王翦');
INSERT INTO myisam_1 VALUES (34, '廉颇');
INSERT INTO myisam_1 VALUES (15, '白起');
```
## 删
```sql
delete from 表名 [where 属性=值(筛选条件)] [order by 排序设定] [limit 数量限定];    
1.where 几乎必须，如果省略将删除所有数据
2.order by 排序设定用于设定删除这些数据的时候指定的字段的顺序来删除，
3.limit 用于删除数据的时候指定只删除“前面的多少行”
```

## 改
```sql
update 表名 set 字段1=新值,字段2=新值,…… [where 属性=值(筛选条件)] [order by 排序设定] [limit 数量限定];
和删的用法相似
```

## 列类型

**整数类型**  

|名称 |字节|最小值(带符号／不带符号)|最大值(带符号／不带符号)|
|:- |:-:|:-|:-|
|tinyint  |1|-128/0                |127/255|
|smallint |2|-32768/0              |……|
|mediumint|3|-8388608/0            |……|
|int      |4|-2147483648/0         |……|
|bigint   |8|-9223372036854775808/0|……|

> 1字节(byte)有8位(bit),当显示负数的时候需要占用首位进行表示，所以表示数值的只有7位  

使用形式

`类型名 [M(长度)] [unsigned] [zerofill]`
* 其中M表示“显示长度”，**其需与zerofill结合使用才有效**，即不够该长度的会自动左侧补0，当然如果超出也不影响。长度，就是用来设定要显示的长度位数(数字个数)
* unsigned表示“无符号数”，表示其中的数值是“非负”数字
* 如果设置了zerofill，则自动也就表示同时具备了unsigned修饰
* 如果设置了zerofill但没有设定长度M，则其会默认将所有数的左边补0到该类型的最大位数  

**小数类型**  

|类型|名称|字节|精度|
|:-|:-|:-:|:-:|
|浮点型||||
|单精度|float(m,d) |4|6-7位|
|双精度|double(m,d)|8|15位|
|定点型||||
||decimal(m,d)|如果M>D，为M+2否则为D+2|总精度65位/小数部分精度30位|
> m叫“精度”，代表“总位数”， d表示“标度”，代表小数位  
> 浮点型的小数，内部是二进制形式，所以很可能是非精确的，基本多有语言都有的毛病  

**字符串类型**  

|  类型   | 大小(字节)    | 用途       |
|:-|:-|:-:|
|  CHAR   | 0-255(字符)   | 固定长度   |
| VARCHAR | 0-65535      | 变化长度   |
| TEXT    | 0-65535      | 长文本数据 |
| enum    | 最多65535选项 | 单选类型   |
| set     | 最多64选项    | 多选类型   |

* char(m)类型:  
**定长字符串，m表示设定的字符长度，存储内容和编码格式无关**，其存储的时候，就是该长度——不够就会自动补空格填满；
最大可设定为255，表示可存储255个 **字符**；
* varchar(m)类型：  
**变长字符串，m表示设定的字节数长度，存储内容和编码格式有关**，是可存储的最大长度，实际存储长度可以小于该长度；
该类型存储的时候，还需要在字段内的最前面额外存储该字段的实际长度；  
最大可设定为65533，表示最大可存储65533个 **字节**；  
因为考虑因素：**一行** 的总的存储空间限制是65535 **字节**，  
但有考虑字符编码的问题，又会出现：  
如果存储的是纯英文字符，则实际最多可存储65533个字符；  
如果存储的是纯gbk的中文字符，则实际最多可存储的是65533/2个字符；  
如果存储的是纯utf8的中文字符，则实际最多可存储的是65533/3个字符；  

* text类型：  
它通常用于存储“大文本”，因为其可存储65535个字节，并且， **不受行存储空间的限制**；不能设置默认值

> varchar和text存储结构上是有区别的，text是单独存储的，不受行存储空间限制;对于大文本的字段最好分拆成单独一个表
> 从存储上来讲大于255的varchar可以说是转换成了text.这也是为什么varchar大于65535了会转成mediumtext  

字段的额外开销  
- varchar 小于255byte  1byte overhead
- varchar 大于255byte  2byte overhead

- tinytext 0-255 1 byte overhead
- text 0-65535 byte 2 byte overhead
- mediumtext 0-16M  3 byte overhead

- longtext 0-4Gb 4byte overhead  

> 备注 overhead是指需要几个字节用于记录该字段的实际长度。  
> 在固定的长度下 `char` 类型比  `varchar` 占用空间更少，并且由于 `char` 是固定长度，所以更利于搜索速度

**.**
* enum类型：  
用于存储若干个“可选项之一”的一种字符类型。  
通常，是在字段定义时，预先设定多个选项，而且是作为单选项，实际存储数据的时候，就可以选择其中一个存入数据库。  
它适合于存储在网页中的“单选项”数据，比如：单选按钮，下拉列表选项值等等；  
形式：  
enum(‘单选项1’, ‘单选项2’, ‘单选项3’, ....... );		//最多65535个。  
说明：    
这些选项，在系统内部，实际对应的是如下这些数字值：1,  2,  3,  4,  5,  6,  ....

* set类型：  
用于存储若干个“多选项”的一种字符类型。  
通常，是在字段定义时，预先设定多个选项，而且是作为多选项，实际存储数据的时候，就可以选择其中若干个选项值存入数据库。  
它适合于存储在网页中的“多选项”数据，比如：多选按钮；  
形式：  
set(‘多选项1’, ‘多选项2’, ‘多选项3’, ....... );		//最多64个。  
说明：  
这些选项，在系统内部，实际对应的是如下这些数字值：1,  2,  4,  8,  16,  ....   **3表示选择类1和2**  

**时间类型**

  |  类型  | 大小(字节) | 范围 |
  |:-:|:-|:-|
  | DATE | 3 | 1000-01-01/9999-12-31   |
  | TIME      | 3 | -838:59:59/838:59:59    |
  | YEAR      | 1 | 1901/2155       |
  | DATETIME  | 8 | 1000-01-01 00:00:00/9999-12-31 23:59:59 |
  | TIMESTAMP | 8 | 1970-01-01 00:00:00/2037 年某时 |

timestamp和datetime基本相似  
timestamp额外特性：  
用于记录一个“当前时间”的精确的时间戳——也就是某个时刻的对应整数值；
该整数值，表示，从1970年1月1日0时0分0秒开始算起到该时候所经历的秒数；
而且，其有如下特征：  
**该字段的值，会在一个表的某行数据执行insert或update的时候，自动获取该时刻的时间戳值；**  
显示格式    YYYY-MM-DD  HH:MM:SS  
特性:不用赋值,该列会为自己赋当前的具体时间 ，但是要添加not null属性  
```sql
`update_time` timestamp NOT  NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',          //默认值为插入的时间   更新数据时也自动更新为当前时间
```
> 注意：  
作为时间日期类型的数据，如果是在代码中插入一个具体的字面数据值，则需要用单引号引起来——跟字符类型一样。

## 用户管理  
### 添加用户  
mysql中的用户数据，都存储在mysql的系统数据库“mysql”中的user表中  
```sql
create  user  ‘用户名’@’允许登录的网络位置’  identified  by  ‘密码’;
```
> “允许登录的网络位置”表示，该用户，在输入正确的用户名和密码的同时，也必须在“指定”的位置来登录该服务器。位置就是网络地址，通常是ip地址；其中，localhost表示只允许在本机（本地）登录。  
如果想远程登录的话，将"localhost"改为"%"，表示在任何一台电脑上都可以登录。也可以指定某台机器可以远程登录。

### 添加权限  
```sql
grant  权限名1，权限名2，....  on  某库．某下级单位  to  ‘用户名’@’允许登录的网络位置’  identified  by  ‘密码’
```
说明：
1. 权限名，就是上述那些单词或单词组合，比如：select，insert，delete，等等；
2. 某下级单位，指的是，一个数据库中的下级可操作对象，比如表，视图，  
    2.1 举例：shuangyuan.join1, 或者shuangyuan.tab1, mysql.user  
    2.2 特例1：\*.\*表示整个系统中的所有数据库的所有下级单位；  
    2.3 特例2：某库名.\*，表示该指定数据库的所有下级单位；  
3. identified 用于给现有的该用户改密码。如果不改密码，就可以不写；
4. 该grant语句，还可以给“不存在的用户”进行授权，此时实际上，会同时创建该用户。如果是这种情况，则此时，identified部分就不可以省略，而是必须给出密码；

例子：  
```sql
grant select,insert on test.test to 'test'@'localhost';
```
权限列表：  
!['权限列表'](/images/mysql/mysql-quanxian.png)
### 取消权限
```sql
revoke  权限名1，权限名2，....  on  某库．某下级单位  from  ‘用户名’@’允许登录的网络位置’
```
