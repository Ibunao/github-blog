---
title: 网站优化-Mysql
date: 2017-7-2 9:00:02
tags:
	- mysql
categories: 网站优化
---

## 4个方向的优化  
* 其一：设计方面。存储引擎的选择，列类型的选择
* 其二：功能方面。索引，查询缓存，分区。
* 其三：架构层面。读写分离，负载均衡。
* 其四：SQL层面。经验。

## 设计方面  
### 存储引擎的选择
> 存储数据的格式，方式
> 常用的有两种，`innodb` 和 `MyISAM`  

**查看mysql支持的引擎情况**  
```mysql
show engines\G
```
![show engines](/images/webyouhua/show-engines.png)

#### MyISAM引擎  
> 记录按照顺序插入进行存储的  

```sql
USE test; #选用数据库
CREATE TABLE myisam_1 (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	title VARCHAR(8) NOT NULL DEFAULT '',
	PRIMARY KEY (id)
) ENGINE = MYISAM CHARSET=utf8;#myisam引擎的
INSERT INTO myisam_1 VALUES (23, '李牧');
INSERT INTO myisam_1 VALUES (12, '王翦');
INSERT INTO myisam_1 VALUES (34, '廉颇');
INSERT INTO myisam_1 VALUES (15, '白起');
```
**数据和索引分别存储**    
!['查看文件大小'](/images/mysql/test-dababase-file.png)  
> test 数据库文件夹
> db.opt 数据库文件  
> myisam_1.frm 表结构文件
> myisam_1.MYD 数据文件  
> myisam_1.MYI 索引文件

##### 表压缩  
myisam支持压缩存储  
制作一张大量数据的表，利用蠕虫复制(自身复制)技术，完成大量数据；
```sql
insert into myisam_1 select null,title from myisam_1;
```
多次执行后查看如果文件大小没有更新，可以刷新表写入到文件   
```sql
flush table myisam_1;
```
查看文件大小  
!['查看文件大小'](/images/mysql/myisam-size.png)  

工具压缩  
查找  
```
find / -name myisampack
发现工具目录  
/usr/local/Cellar/mysql/5.7.18_1/bin

myisampack 打包压缩
myisamchk 检测修复
```
进入到数据库目录中  
`/usr/local/var/mysql/test`  
> 可以通过 `find / -name *.frm` 查找  

执行
```
myisampack myisam_1     //myisam_1是带压缩的表名  
```
最后会显示  
```
Remember to run myisamchk -rq on compressed tables
```
!['查看文件大小'](/images/mysql/myisam-size-1.png)   
可以看出数据文件压缩，但是索引文件出问题了，需要重建  
修复索引  
```
myisamchk -rq myisam_1
```
修复后索引正常  
!['查看文件大小'](/images/mysql/myisam-size-1.png)   

> 压缩后为只读表，不能再进行插入操作，仅仅可以完成更快速的查询工作  

##### 表解压
如果需要对压缩过的表进行修改需要进行解压  
同样进入到要解压的数据库目录中  
```
myisamchk --unpack myisam_1
```
执行后即可,如果文件大小没变，需要进入到mysql中执行  
```sql
flush table
```
##### 修复表   
myisam新增数据时，都是在表末尾完成的插入   
如果存在被删除的记录。所占用的记录空间就会空下来，但是不会再存放记录。  
最好定时，完成修复表空间漏洞！  
删除数据后myisam表的大小并不会发生改变 ，需要进行修复  
进入到需要修复的数据库的目录中  
```sql
myisamchk -rq myisam_1    #修复索引  
myisamchk -r myisam_1     #修复数据  
```
> myisam 不支持行锁，支持表锁，导致并发性降低 ；提供高效的查询、插入操作；不擅长大量更新、删除业务；  

#### innodb引擎
mysql默认存储引擎  
支持事务，行级锁定，外键  

**存储机制**
数据按照主键顺序进行排序  
导致innodb的表的记录与逐渐索引存在一个结构中(聚簇)  
插入数据时，因为要额外的执行排序工作，导致插入速度相对较慢  

创建innodb表
```sql
USE test; #选用数据库
CREATE TABLE innodb_1 (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	title VARCHAR(8) NOT NULL DEFAULT '',
	PRIMARY KEY (id)
) ENGINE = innodb CHARSET=utf8;#innodb引擎的
INSERT INTO innodb_1 VALUES (23, '李牧');
INSERT INTO innodb_1 VALUES (12, '王翦');
INSERT INTO innodb_1 VALUES (34, '廉颇');
INSERT INTO innodb_1 VALUES (15, '白起');
```
查看文件  
!['查看文件'](/images/mysql/innodb-file.png)   
> innodb_1.frm innodb的结构文件  
> ibdata1 默认的innodb表空间文件，所有的innodb表的数据和索引都在该文件中(**最新的默认为每个表分开存储**)  
> innodb_1.ibd  innodb表空间文件(每个表单独存储的时候会有这个文件)  

如果默认为所有的表存储在一个文件中，可以进行配置来实现每个表分开存储  
```sql
show variables like 'innodb_file_per_table';
```
如果值为 `OFF` 则为所有表存在一个文件中，进行设置更改即可  
```sql
set global innodb_file_per_table = 1;
```
> innodb额外支持事务，外键约束，行级锁定  
> 擅长处理复杂数据完整性，一致性。擅长处理并发。

### 列类型的选择  
**在满足需求的情况下尽可能占用小的存储空间**
**尽可能使用整数类型**
整数行的运算速度最快，也可以考虑 `Enum枚举` 和 `Set集合` 类型，不过这两种也可以配合代码用数值型实现  
例如：  
存储 ipv4； `varchar(15)` 15+个字节
可以将ip转换为int型的 `int unsigned` 就只需要4个字节  
ip转整  
```sql
select inet_aton('192.168.1.234');
```
整数转ip  
```sql
select inet_ntoa(3232236010);
```
**尽可能使用 not null**  
Null值，特殊值，mysql需要额外的存储空间存储。  
无论在计算，存储上都需要消耗资源。  

**逆范式**   
>范式：规范的格式：  
	满足三范式：  
1NF：原子性。  
2NF：消除部分依赖。  
3NF：消除传递依赖。   
每张表，存储一类实体的信息。实体间通过关联字段进行联系。  

但 有时需要 打破规范，来提升某种操作的效率：
例如：
```sql
商品表：Goods
Goods_id, goods_name, cat_id

分类表：category
Cat_id, cat_title,

业务逻辑：分类列表
分类ID，分类标题，分类下商品数量
典型的实现：连接查询。
Select c.cat_id, c.cat_title, count(g.goods_id) as goods_count from category as c left join goods as g On c.cat_id=g.cat_id group by c.cat_id where Condition

如果 在查询分类列表时，通常需要 商品数量：
则可以采用下面的设计：
在分类表，增加商品数量的字段：
分类表：category
Cat_id, cat_title,goods_count
每当 商品 增，删，改的时候，修改相关分类的goods_count的值。

但是，如果执行查询分类列表了，就不需要 连接操作：
Select * from category;
```
> 优化根据具体的业务需求对表结构进行优化

## 功能方面  
### 索引  
在终端执行  `select` 语句的时候会显示执行时间   
例如：  
```
8388608 rows in set (2.79 sec)
执行了2.79秒
```
可以通过设置索引对查询进行优化  

> 索引就好比字典的目录，通过关键词获取记录所在位置
> 通过使用 数据中的部分数据作为关键字，建立该关键字与数据间位置的对应关系，称之为索引。

在没有索引的情况下，定位记录，需要采用的是全表扫描，从第一条记录扫描到最后一条记录，确定要找的数据  
而索引的关键词是排序过的，查找的时候先在索引中进行检索，快速的定位该关键词对应的记录位置  

**索引的增删改**
查看 [mysql基础 ](/mysql-mac/ "mysql基础")  

#### 执行计划
在执行sql之前，mysql会形成执行计划，内包含了当前的sql执行所采用的策略  

**mysql执行计划获取**  
通过 `explain select` 语法  
```sql
explain select * from test where id = 123456\G
```
```sql
mysql> explain select * from myisam_1 where id = 123456\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: myisam_1
   partitions: NULL
         type: const        #这是重要的列，显示连接使用了何种类型。从最好到最差的连接类型为const、eq_reg、ref、range、 indexhe和ALL，all为全表扫描
possible_keys: PRIMARY      #查询可能会使用到索引
          key: PRIMARY      #实际使用的索引
      key_len: 4            #使用的索引的长度。在不损失精确性的情况下，长度越短越好
          ref: const
         rows: 1            #MYSQL认为必须检查的用来返回请求数据的行数
     filtered: 100.00
        Extra: NULL         #关于MYSQL如何解析查询的额外信息
1 row in set, 1 warning (0.00 sec)
```
### 索引使用场景  
#### 条件检索 where
where 后的字段如果有索引是可以使用索引的  
#### 排序 order by
order by 后的字段如果有索引是可以使用索引的
#### 联表join 关联字段
联接查询是，关联字段 (`on`后面的条件) 可以使用索引  
两个表的关联字段都要创建索引  

### 索引使用语法细节
#### 字段独立  
字段需要使用索引时，要求，字段独立存在于表达式的一侧。不能参与表达式运算。函数调用。
例如：
```sql
where id = 123456;      #字段独立
where id+1 = 123455;    #字段未独立
```
#### 左原则  
##### like模糊查询
匹配字符串，左侧必须要固定才可以使用索引。即 `like abc%`  
##### 复合索引  
创建复合索引时，在使用索引的时候  
左边的字段才能直接使用该索引。  
左边字段确定时，右边字段的索引才可以使用。  
> 原因：复合索引的关键字顺序，先按照左边字段排序，如果左边字段相同，则按照右边字段排，以此类推。

#### or原则  
要保证 OR两侧的条件表达式中的字段都有索引可以使用，才会用到索引。

#### mysql自动判断  
当搜索的记录数比较多时，mysql可能会放弃使用索引来减少大量的随机io开销，而选择使用顺序开销来代替    
例如：
```sql
where empno > 1121212;
```
如果查询的记录数太多，会放弃索引  

### 前缀索引

> 可以使用 某个字段的前一部分（左边）数据，作为索引的关键字，而不是使用全部的字段内容。称之为前缀索引。  
字段 32 字节长度。只使用前10个长度，作为索引关键字。  
目的：减少 关键字的长度，索引的速度就会提升！  
实际中，前缀 具有 足够的标识度，才可以使用前缀索引。  

例如：  
以 密码为例：  

首先需要计算当前缀达到多长时，标识度就够了。

1. 先计算整体的标识度
```sql
select 总记录条数／count(distinct epassword) from emp;  #计算总条数除以不重复密码的比值
```
2. 计算使用不同的前缀是的标识度的值，找到最接近的即可  
```sql
select 总记录条数／count(distinct substring(epassword, 1, n)) from emp;
```
	随着 `n` 的不断增大，将会越来越接近整体标识度，并且随着增大标识度将会不变，这时去不变时的最小值最为前缀长度  
3. 建立前缀索引  
```sql
alter table emp add index 'index_password' (epassword(n));  #n为计算出的长度  
```

### 查询缓存  
mysql服务器提供的可以缓存查询结果的缓存区  
```sql
mysql> show variables like 'query_cache_%';
+------------------------------+---------+
| Variable_name                | Value   |
+------------------------------+---------+
| query_cache_limit            | 1048576 |
| query_cache_min_res_unit     | 4096    |
| query_cache_size             | 1048576 |#缓存大小
| query_cache_type             | OFF     |#开关
| query_cache_wlock_invalidate | OFF     |
+------------------------------+---------+
```
看出默认是开着的  

设置配置变量：  
```sql
set global query_cache_type = 1;#打开
set global query_cache_size = 1024*1024*64;--64M
```
> 注意：  
一旦开启查询缓存，则只要执行的时Select操作，通常结果都会被缓存。无论客户端是否要求。

实际使用时：有些数据仅仅需要使用一次。数据很大。不希望数据被缓存。
通过 `SQL_NO_CACHE` 语法，进行提示 MySQL 该select不需要缓存
```sql
select sql_no_cache from emp where empno = 12345;
```
**动态数据不能缓存**    
```sql
select * ,now() from emp where empno=12345;
```
**缓存是基于 `select` 语句的**
如果多打了空格或字母大小写不一样都会导致不会使用缓存

#### 索引的状态的查看  
```sql
mysql> show status like 'handler_read_%';
+-----------------------+----------+
| Variable_name         | Value    |
+-----------------------+----------+
| Handler_read_first    | 4        |
| Handler_read_key      | 5        |#该选项值高 则证明系统高效使用了索引
| Handler_read_last     | 0        |
| Handler_read_next     | 0        |
| Handler_read_prev     | 0        |#上面的数量越高，索引利用率越高
| Handler_read_rnd      | 0        |#下面两项数值高的需要优化，执行全表扫面的
| Handler_read_rnd_next | 27264190 |
+-----------------------+----------+
```


#### 管理查询缓存
```sql
mysql> show status like 'Qcache_%';
+-------------------------+---------+
| Variable_name           | Value   |
+-------------------------+---------+
| Qcache_free_blocks      | 1       |
| Qcache_free_memory      | 1031832 |
| Qcache_hits             | 0       | #查询命中数
| Qcache_inserts          | 0       | #缓存项数量
| Qcache_lowmem_prunes    | 0       |
| Qcache_not_cached       | 30      |
| Qcache_queries_in_cache | 0       |
| Qcache_total_blocks     | 1       |
+-------------------------+---------+
```
**重置／清空缓存**
```sql
reset query cache;
```
**缓存失效**
如果对数据表进行更改操作(增、删、改)，则会删除该表对应的所有的缓存；

### 分表分区
当表中的记录数很多时，采用多张表进行存储，策略就是分表策略  
> 将大量数据按照算法分开存储，可以提高查询的效率和io开销吧  

mysql服务器可以实现表的分区  
分区后mysql服务器将会根据分区算法和数量创建多个表，然后像普通正常使用就行  

#### 分区  
将一个表分成多个区(partition),将数据分散到不同的区中。就是横向分表    
区：就是一个物理表，
![分区](/images/mysql/fenqu.png)

**4种分区算法**
key、hash、range、list

##### hash分区  
分区的字段要求是整数类型的   
如果是要对非整型字段进行hash分区，需要自己用表达式将非整形转换成整形
```sql
create table student (
    id int unsigned not null auto_increment,
    name varchar(32) not null default '',
    birethday date not null default '0000-00-00',
    primary key (id)  --primary key(id, birthday)  分区的字段要包含在主键中
) engine=myisam charset=utf8
--通过id将分区划分成10个
partition by hash(id) partition 10;
--或通过 birthday 划分成10个  ,要将date转换成int类型的
partition by hash(YEAR(birthday)) partition 10;
```
##### key分区
针对任意类型字段  
与hash相似，只不过转成 int 的函数不是用户指定，而是由mysql指定  
```sql
create table student (
    id int unsigned not null auto_increment,
    name varchar(32) not null default '',
    birethday date not null default '0000-00-00',
    primary key (id)    --primary key(id, birthday)  分区的字段要包含在主键中
) engine=myisam charset=utf8
--通过id将分区划分成10个
partition by key(id) partition 10;
--或通过 birthday 划分成10个
partition by key(birthday) partition 10;
```
##### range范围分区  
为每一个分区的条件指定一个范围
```sql
create table student (
    id int unsigned not null auto_increment,
    name varchar(32) not null default '',
    birethday date not null default '0000-00-00',
    primary key (id, birthday) --primary key(id, birthday)  分区的字段要包含在主键中
) engine=myisam charset=utf8
--或通过 birthday 根据年代划分
partition by key(YEAR(birthday)) (
    partition p_old values less than (1970), -- 小于 < (value)
    partition p_70 values less than (1980),
    partition p_80 values less than (1990),
    partition p_90 values less than (2000),
    partition p_new values less than MAXVALUE, -- 最大值

);
```
##### list 列表值条件分区
```sql
create table student (
    id int unsigned not null auto_increment,
    name varchar(32) not null default '',
    birethday date not null default '0000-00-00',
    primary key (id, birthday) --primary key(id, birthday)  分区的字段要包含在主键中
) engine=myisam charset=utf8
--或通过 birthday 根据月份划分
partition by key(month(birthday)) (
    partition p_chun values in (3,4),
    partition p_xia values in (5,6,7,8),
    partition p_80 values in (9,10),
    partition p_90 values in (11,12,1,2),
);
```
#### 分区管理  
##### 求余类型的 hash和key分区类型
**减少分区**  
将原来的10个分区减少至7个分区  
```sql
alter table student coalesce partition 3;
--查看  
show create table student\G
```
**增加分区**
```sql
alter table add partition partitions 5;
--查看  
show create table student\G
```
##### 条件类型的 range和list分区类型  
**添加具体的条件分区**
```sql
alter table student_list add partition(
    partition p_undefined values in (0);
)
```
**删除具体的条件分区**
```sql
alter table student_list drop partition p_qiu;
```

> 删除分区时会导致分区内的数据同时被删除  

#### 垂直分表  
可以根据表的字段使用情况将一张表垂直拆分成几个表  
常用信息一个表，不常用信息一个表    

## 架构优化
### 读写分离
web项目，读写比例大概 7:1，配置一台住服务器负责写，多台从服务器负责读  
### 负载均衡  
将访问数据均匀的分配到不同的读服务器，nginx反向代理    

### mysql配置优化
my.ini
**最大连接数**
```
max_connections = 100;
```
**myisam键缓存**  
```
key_buffer_size = 55M
```
**innodb的缓冲池**  
```
innodb_buffer_pool_size = 107M
```
**表文件句柄缓存**
可以缓存打开的table的句柄  
```
table_cache=256
```


## sql优化

找到执行慢的sql  
将执行超过多久的sql记录下来  

```sql
mysql> show variables like 'slow_query_%';
+---------------------+------------------------------------+
| Variable_name       | Value                              |
+---------------------+------------------------------------+
| slow_query_log      | OFF                                |#慢查询开关,默认打开
| slow_query_log_file | /usr/local/var/mysql/ding-slow.log |#慢查询日志位置
+---------------------+------------------------------------+
```
```sql
mysql> show variables like 'long_query_%';
+-----------------+-----------+
| Variable_name   | Value     |
+-----------------+-----------+
| long_query_time | 10.000000 | #记录 慢 的临界值
+-----------------+-----------+
```
```
set global slow_query_log = 1；#开启慢查询  
set long_query_time = 1; #设置记录慢查询时间临界值,超过的将都会记录下来  
```
通过查询慢查询日志，找到需要优化的sql

### 插入大量数据
建议将索引关闭(每条记录维护索引，相比一起维护索引，一起维护更容易)
也可以现将索引删除，插入数据后再创建索引  

### order by null
禁止排序  
group by的时候，默认的按照分组字段排序；  
执行explain计划可以看到 `extra: useing filesort`  
如果排序没有意义，可以通过添加 `order by null` 来禁用排序  

### select
查询的字段尽可能是自己需要的，尽量不要使用 `*` 会导致数量变大，拖慢速度  

### 单表查询
一次操作仅仅操作一张表，当数据量较大的时候使用连表操作将会导致内存不够  
**单表查询的好处**  
1. 一次占用一个表，减少并发  
2. 消耗内存少  
3. 提高查询缓存的利用率  
**缺点**
由于多次执行sql会多次向mysql服务器进行联接，联接响应也是影响速度的重要原因

> 能用join的尽量不要用子查询，mysql对子查询的支持不是太好，效率略低  
