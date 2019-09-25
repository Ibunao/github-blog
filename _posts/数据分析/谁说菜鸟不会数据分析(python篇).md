---
title: 谁说菜鸟不会数据分析（python篇）
date: 2019-09-24 23:20:02
tags:
    - 数据分析  
categories:   
    - 数据分析  
---
## 前言  
实现 《谁说菜鸟不会数据分析》 代码

## 数据处理

### 数据清洗

#### 数据排序

按照一定顺序排序，以便研究者通过浏览数据发现一些明显的特征、规律或趋势，找到解决问题的线索。有助于对数据检查纠错，以及为重新归类或分组等提供方便
<!-- more -->

```python
import pandas as pd
```


```python
data = pd.read_csv('../data/cnbook/第四章/4.2.1 数据排序/数据排序.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>用户ID</th>
      <th>性别</th>
      <th>年龄</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>100000</td>
      <td>男</td>
      <td>52</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100001</td>
      <td>男</td>
      <td>23</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100002</td>
      <td>男</td>
      <td>30</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100006</td>
      <td>男</td>
      <td>28</td>
    </tr>
    <tr>
      <th>4</th>
      <td>100010</td>
      <td>男</td>
      <td>28</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 根据年龄升序、性别降序
data.sort_values(
    ['年龄', '性别'],
    ascending = [True, False]
)
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>用户ID</th>
      <th>性别</th>
      <th>年龄</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>6</th>
      <td>100012</td>
      <td>男</td>
      <td>21</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100001</td>
      <td>男</td>
      <td>23</td>
    </tr>
    <tr>
      <th>7</th>
      <td>100013</td>
      <td>男</td>
      <td>24</td>
    </tr>
    <tr>
      <th>9</th>
      <td>100016</td>
      <td>男</td>
      <td>26</td>
    </tr>
    <tr>
      <th>5</th>
      <td>100011</td>
      <td>男</td>
      <td>27</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100006</td>
      <td>男</td>
      <td>28</td>
    </tr>
    <tr>
      <th>4</th>
      <td>100010</td>
      <td>男</td>
      <td>28</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100002</td>
      <td>男</td>
      <td>30</td>
    </tr>
    <tr>
      <th>10</th>
      <td>100017</td>
      <td>女</td>
      <td>30</td>
    </tr>
    <tr>
      <th>8</th>
      <td>100015</td>
      <td>男</td>
      <td>33</td>
    </tr>
    <tr>
      <th>0</th>
      <td>100000</td>
      <td>男</td>
      <td>52</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 重复数据处理

##### 重复数据查找


```python
data = pd.read_csv('../data/cnbook/第四章/4.2.2 重复数据处理/重复值.csv')
data
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>性别</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>男</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>刘一</td>
      <td>男</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>男</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>李四</td>
      <td>女</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>女</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>赵六</td>
      <td>男</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>孙七</td>
      <td>女</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>周八</td>
      <td>女</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>吴九</td>
      <td>男</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>郑十</td>
      <td>男</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 查找行重复的
data.duplicated()
```




    0    False
    1     True
    2    False
    3    False
    4    False
    5    False
    6    False
    7    False
    8    False
    9    False
    dtype: bool




```python
# 根据 性别 列，找出重复的位置
data.duplicated(['性别'])
```




    0    False
    1     True
    2     True
    3    False
    4     True
    5     True
    6     True
    7     True
    8     True
    9     True
    dtype: bool



##### 重复数据删除


```python
data.drop_duplicates()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>性别</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>男</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>男</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>李四</td>
      <td>女</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>女</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>赵六</td>
      <td>男</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>孙七</td>
      <td>女</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>周八</td>
      <td>女</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>吴九</td>
      <td>男</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>郑十</td>
      <td>男</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 缺失数据处理

处理方法：  
1. 填充，用平均值等方法进行填充
2. 删除有缺失值的行，如果数据量较小不适合
3. 不处理

##### 数据补齐


```python
data = pd.read_csv('../data/cnbook/第四章/4.2.3 缺失值处理/常见缺失值.csv')
data
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>256.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>陈二</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>282.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>李四</td>
      <td>245.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>162.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>赵六</td>
      <td>295.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>孙七</td>
      <td>173.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>周八</td>
      <td>197.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>吴九</td>
      <td>236.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>郑十</td>
      <td>311.0</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 使用平均值填充
data.fillna(data['消费'].mean())
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>256.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>陈二</td>
      <td>239.666667</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>282.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>李四</td>
      <td>245.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>162.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>赵六</td>
      <td>295.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>孙七</td>
      <td>173.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>周八</td>
      <td>197.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>吴九</td>
      <td>236.000000</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>郑十</td>
      <td>311.000000</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 删除缺失值


```python
data.dropna()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>256.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>282.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>李四</td>
      <td>245.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>162.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>赵六</td>
      <td>295.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>孙七</td>
      <td>173.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>周八</td>
      <td>197.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>吴九</td>
      <td>236.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>郑十</td>
      <td>311.0</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 空格数据处理

空格数据是指字符串型数据的前面或后面存在空格


```python
data = pd.read_csv('../data/cnbook/第四章/4.2.4 空格值处理/空格值.csv')
data
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>KEN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>JIMI</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>John</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data.name.str.strip()
```




    0     KEN
    1    JIMI
    2    John
    Name: name, dtype: object



### 数据转换

#### 数值转字符串


```python
data = pd.read_csv('../data/cnbook/第四章/4.3.1 数值转字符/数值转字符.csv')
data
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
      <th>电话号码</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>256.1</td>
      <td>166547114238</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>陈二</td>
      <td>239.5</td>
      <td>166423353436</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>282.6</td>
      <td>166556915853</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>李四</td>
      <td>245.8</td>
      <td>166434728749</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>162.3</td>
      <td>166544742252</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>赵六</td>
      <td>295.3</td>
      <td>166827395761</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>孙七</td>
      <td>173.6</td>
      <td>166917847616</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>周八</td>
      <td>197.9</td>
      <td>166528757061</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>吴九</td>
      <td>236.2</td>
      <td>166809774605</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>郑十</td>
      <td>311.1</td>
      <td>166434676621</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 查看类型
data.dtypes
```




    ID        int64
    姓名       object
    消费      float64
    电话号码      int64
    dtype: object




```python
data['电话号码'].dtype
```




    dtype('int64')




```python
# 把 电话号码 列转换为字符型
data['电话号码'] = data['电话号码'].astype(str)
data['电话号码'].dtype
```




    dtype('O')



#### 字符串转数值


```python
data['电话号码'] = data['电话号码'].astype(float)
data['电话号码'].dtype
```




    dtype('float64')



#### 字符串转时间

##### 时间转换


```python
data = pd.read_csv('../data/cnbook/第四章/4.3.3 字符转时间/字符转时间.csv')
data
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>电话</th>
      <th>注册时间</th>
      <th>是否微信</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166412894295</td>
      <td>2011/1/1</td>
      <td>否</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135416795207</td>
      <td>2012/2/3</td>
      <td>否</td>
    </tr>
    <tr>
      <th>2</th>
      <td>177423353436</td>
      <td>2013/3/2</td>
      <td>是</td>
    </tr>
    <tr>
      <th>3</th>
      <td>189424978309</td>
      <td>2014/4/11</td>
      <td>是</td>
    </tr>
    <tr>
      <th>4</th>
      <td>134450811715</td>
      <td>2015/5/18</td>
      <td>否</td>
    </tr>
    <tr>
      <th>5</th>
      <td>137450811771</td>
      <td>2016/6/12</td>
      <td>否</td>
    </tr>
    <tr>
      <th>6</th>
      <td>173450811789</td>
      <td>2017/7/15</td>
      <td>是</td>
    </tr>
    <tr>
      <th>7</th>
      <td>188450811792</td>
      <td>2018/8/17</td>
      <td>是</td>
    </tr>
    <tr>
      <th>8</th>
      <td>168450811840</td>
      <td>2019/9/16</td>
      <td>是</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data['注册时间'].dtype
```




    dtype('O')




```python
data['时间'] = pd.to_datetime(
    data.注册时间,
    format='%Y/%m/%d'
)
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>电话</th>
      <th>注册时间</th>
      <th>是否微信</th>
      <th>时间</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166412894295</td>
      <td>2011/1/1</td>
      <td>否</td>
      <td>2011-01-01</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135416795207</td>
      <td>2012/2/3</td>
      <td>否</td>
      <td>2012-02-03</td>
    </tr>
    <tr>
      <th>2</th>
      <td>177423353436</td>
      <td>2013/3/2</td>
      <td>是</td>
      <td>2013-03-02</td>
    </tr>
    <tr>
      <th>3</th>
      <td>189424978309</td>
      <td>2014/4/11</td>
      <td>是</td>
      <td>2014-04-11</td>
    </tr>
    <tr>
      <th>4</th>
      <td>134450811715</td>
      <td>2015/5/18</td>
      <td>否</td>
      <td>2015-05-18</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data.时间.dtype
```




    dtype('<M8[ns]')



##### 时间格式化


```python
data['年月'] = data.时间.dt.strftime('%Y-%m')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>电话</th>
      <th>注册时间</th>
      <th>是否微信</th>
      <th>时间</th>
      <th>年月</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166412894295</td>
      <td>2011/1/1</td>
      <td>否</td>
      <td>2011-01-01</td>
      <td>2011-01</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135416795207</td>
      <td>2012/2/3</td>
      <td>否</td>
      <td>2012-02-03</td>
      <td>2012-02</td>
    </tr>
    <tr>
      <th>2</th>
      <td>177423353436</td>
      <td>2013/3/2</td>
      <td>是</td>
      <td>2013-03-02</td>
      <td>2013-03</td>
    </tr>
    <tr>
      <th>3</th>
      <td>189424978309</td>
      <td>2014/4/11</td>
      <td>是</td>
      <td>2014-04-11</td>
      <td>2014-04</td>
    </tr>
    <tr>
      <th>4</th>
      <td>134450811715</td>
      <td>2015/5/18</td>
      <td>否</td>
      <td>2015-05-18</td>
      <td>2015-05</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



### 数据抽取

#### 字段分拆

##### 按照位置分拆


```python
data = pd.read_csv('../data/cnbook/第四章/4.4.1 字段拆分/字段拆分.csv')
data
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tel</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>18922254812</td>
    </tr>
    <tr>
      <th>1</th>
      <td>13522255003</td>
    </tr>
    <tr>
      <th>2</th>
      <td>13422259938</td>
    </tr>
    <tr>
      <th>3</th>
      <td>18822256753</td>
    </tr>
    <tr>
      <th>4</th>
      <td>18922253721</td>
    </tr>
    <tr>
      <th>5</th>
      <td>13422259313</td>
    </tr>
    <tr>
      <th>6</th>
      <td>13822254373</td>
    </tr>
    <tr>
      <th>7</th>
      <td>13322252452</td>
    </tr>
    <tr>
      <th>8</th>
      <td>18922257681</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 电话转换成字符串格式
data['tel'] = data['tel'].astype(str)
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tel</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>18922254812</td>
    </tr>
    <tr>
      <th>1</th>
      <td>13522255003</td>
    </tr>
    <tr>
      <th>2</th>
      <td>13422259938</td>
    </tr>
    <tr>
      <th>3</th>
      <td>18822256753</td>
    </tr>
    <tr>
      <th>4</th>
      <td>18922253721</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 运营商
data['bands'] = data['tel'].str.slice(0, 3)
# 地区
data['areas'] = data['tel'].str.slice(3, 7)
# 号码段
data['nums'] = data['tel'].str.slice(7, 11)
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tel</th>
      <th>bands</th>
      <th>areas</th>
      <th>nums</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>18922254812</td>
      <td>189</td>
      <td>2225</td>
      <td>4812</td>
    </tr>
    <tr>
      <th>1</th>
      <td>13522255003</td>
      <td>135</td>
      <td>2225</td>
      <td>5003</td>
    </tr>
    <tr>
      <th>2</th>
      <td>13422259938</td>
      <td>134</td>
      <td>2225</td>
      <td>9938</td>
    </tr>
    <tr>
      <th>3</th>
      <td>18822256753</td>
      <td>188</td>
      <td>2225</td>
      <td>6753</td>
    </tr>
    <tr>
      <th>4</th>
      <td>18922253721</td>
      <td>189</td>
      <td>2225</td>
      <td>3721</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 按照分隔符拆分


```python
data = pd.read_csv('../data/cnbook/第四章/4.4.1 字段拆分/分隔符.csv')
data
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Apple iPad mini</td>
    </tr>
    <tr>
      <th>1</th>
      <td>华为 MediaPad 7Vogue</td>
    </tr>
    <tr>
      <th>2</th>
      <td>昂达（ONDA） V975四核</td>
    </tr>
    <tr>
      <th>3</th>
      <td>华为（HUAWEI） 荣耀X1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>酷比魔方（CUBE） TALK7X四核</td>
    </tr>
    <tr>
      <th>5</th>
      <td>惠普（HP） Slate 7</td>
    </tr>
    <tr>
      <th>6</th>
      <td>酷比魔方（ACUBE) TALK97</td>
    </tr>
    <tr>
      <th>7</th>
      <td>三星（SAMSUNG） GALAXY NotePro</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 按照 空格 分割，从 第一个 开始，使用 数据框 返回结果
newData = data['name'].str.split(' ', 1, True)
newData.columns = ['band', 'name']
newData.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>band</th>
      <th>name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Apple</td>
      <td>iPad mini</td>
    </tr>
    <tr>
      <th>1</th>
      <td>华为</td>
      <td>MediaPad 7Vogue</td>
    </tr>
    <tr>
      <th>2</th>
      <td>昂达（ONDA）</td>
      <td>V975四核</td>
    </tr>
    <tr>
      <th>3</th>
      <td>华为（HUAWEI）</td>
      <td>荣耀X1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>酷比魔方（CUBE）</td>
      <td>TALK7X四核</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 时间属性抽取


```python
data = pd.read_csv('../data/cnbook/第四章/4.4.1 字段拆分/时间属性.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>电话</th>
      <th>注册时间</th>
      <th>是否微信</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166412894295</td>
      <td>2011/1/1 12:13:24</td>
      <td>否</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135416795207</td>
      <td>2012/2/3 1:15:38</td>
      <td>否</td>
    </tr>
    <tr>
      <th>2</th>
      <td>177423353436</td>
      <td>2013/3/2 13:54:55</td>
      <td>是</td>
    </tr>
    <tr>
      <th>3</th>
      <td>189424978309</td>
      <td>2014/4/11 11:00:03</td>
      <td>是</td>
    </tr>
    <tr>
      <th>4</th>
      <td>134450811715</td>
      <td>2015/5/18 10:02:23</td>
      <td>否</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data['时间'] = pd.to_datetime(
    data.注册时间,
    format='%Y/%m/%d'
)
```


```python
data['时间.年'] = data['时间'].dt.year
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>电话</th>
      <th>注册时间</th>
      <th>是否微信</th>
      <th>时间</th>
      <th>时间.年</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166412894295</td>
      <td>2011/1/1 12:13:24</td>
      <td>否</td>
      <td>2011-01-01 12:13:24</td>
      <td>2011</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135416795207</td>
      <td>2012/2/3 1:15:38</td>
      <td>否</td>
      <td>2012-02-03 01:15:38</td>
      <td>2012</td>
    </tr>
    <tr>
      <th>2</th>
      <td>177423353436</td>
      <td>2013/3/2 13:54:55</td>
      <td>是</td>
      <td>2013-03-02 13:54:55</td>
      <td>2013</td>
    </tr>
    <tr>
      <th>3</th>
      <td>189424978309</td>
      <td>2014/4/11 11:00:03</td>
      <td>是</td>
      <td>2014-04-11 11:00:03</td>
      <td>2014</td>
    </tr>
    <tr>
      <th>4</th>
      <td>134450811715</td>
      <td>2015/5/18 10:02:23</td>
      <td>否</td>
      <td>2015-05-18 10:02:23</td>
      <td>2015</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



### 记录抽取


```python
data = pd.read_csv('../data/cnbook/第四章/4.4.2 记录抽取/记录抽取.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>ptime</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1197453</td>
      <td>10071</td>
      <td>华为（HUAWEI） 荣耀平板</td>
      <td>2015-05-26</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1192330</td>
      <td>16879</td>
      <td>Apple iPad平板</td>
      <td>2012-01-26</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1225995</td>
      <td>2218</td>
      <td>小米（MI）7.9英寸平板</td>
      <td>2013-06-16</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1308557</td>
      <td>12605</td>
      <td>Apple IPad mini平板</td>
      <td>2013-05-26</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1185287</td>
      <td>11836</td>
      <td>微软（Microsoft） Surface Pro 3</td>
      <td>2016-08-21</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 关键词抽取


```python
fdata = data[data.title.str.contains('台电', na=False)]
fdata
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>ptime</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>7</th>
      <td>1150612</td>
      <td>5857</td>
      <td>台电（Teclast） P98</td>
      <td>2015-05-14</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1285329</td>
      <td>2482</td>
      <td>台电（Teclast）X98 Air</td>
      <td>2015-08-21</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 空值抽取


```python
fdata = data[data.title.isnull()]
fdata
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>ptime</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5</th>
      <td>1197789</td>
      <td>2084</td>
      <td>NaN</td>
      <td>2015-03-03</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 数值范围抽取


```python
# 单条件比较运算
fdata = data[data['comments'] > 10000]
fdata
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>ptime</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1197453</td>
      <td>10071</td>
      <td>华为（HUAWEI） 荣耀平板</td>
      <td>2015-05-26</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1192330</td>
      <td>16879</td>
      <td>Apple iPad平板</td>
      <td>2012-01-26</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1308557</td>
      <td>12605</td>
      <td>Apple IPad mini平板</td>
      <td>2013-05-26</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1185287</td>
      <td>11836</td>
      <td>微软（Microsoft） Surface Pro 3</td>
      <td>2016-08-21</td>
    </tr>
    <tr>
      <th>6</th>
      <td>996957</td>
      <td>11123</td>
      <td>Apple iPad Air</td>
      <td>2015-02-10</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 之间
fdata = data[data['comments'].between(1000, 10000)]
fdata
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>ptime</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>1225995</td>
      <td>2218</td>
      <td>小米（MI）7.9英寸平板</td>
      <td>2013-06-16</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1197789</td>
      <td>2084</td>
      <td>NaN</td>
      <td>2015-03-03</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1150612</td>
      <td>5857</td>
      <td>台电（Teclast） P98</td>
      <td>2015-05-14</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1285329</td>
      <td>2482</td>
      <td>台电（Teclast）X98 Air</td>
      <td>2015-08-21</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 组合条件抽取


```python
# 多条件
fdata = data[(data['comments'] > 1000) & (data['comments'] < 10000)]
fdata
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>ptime</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>1225995</td>
      <td>2218</td>
      <td>小米（MI）7.9英寸平板</td>
      <td>2013-06-16</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1197789</td>
      <td>2084</td>
      <td>NaN</td>
      <td>2015-03-03</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1150612</td>
      <td>5857</td>
      <td>台电（Teclast） P98</td>
      <td>2015-05-14</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1285329</td>
      <td>2482</td>
      <td>台电（Teclast）X98 Air</td>
      <td>2015-08-21</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 时间范围抽取


```python
data.ptime.dtype
```




    dtype('O')




```python
data.ptime = pd.to_datetime(data.ptime)
```


```python
from datetime import datetime
# 定义时间
dt1 = datetime(
    year = 2015,
    month = 1,
    day = 1
)
dt2 = datetime(
    year = 2015,
    month = 12,
    day = 1
)
fdata = data[(data.ptime >= dt1) & (data.ptime <= dt2)]
fdata
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>ptime</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1197453</td>
      <td>10071</td>
      <td>华为（HUAWEI） 荣耀平板</td>
      <td>2015-05-26</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1197789</td>
      <td>2084</td>
      <td>NaN</td>
      <td>2015-03-03</td>
    </tr>
    <tr>
      <th>6</th>
      <td>996957</td>
      <td>11123</td>
      <td>Apple iPad Air</td>
      <td>2015-02-10</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1150612</td>
      <td>5857</td>
      <td>台电（Teclast） P98</td>
      <td>2015-05-14</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1285329</td>
      <td>2482</td>
      <td>台电（Teclast）X98 Air</td>
      <td>2015-08-21</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 随机抽样

##### 按个数抽样


```python
data = pd.read_csv('../data/cnbook/第四章/4.4.3 随机抽样/随机抽样.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>256</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>陈二</td>
      <td>239</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>282</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>李四</td>
      <td>245</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>162</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
sdata = data.sample(n=3)
sdata
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>256</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>孙七</td>
      <td>173</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>陈二</td>
      <td>239</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 按照百分比抽样


```python
sdata = data.sample(frac=0.2)
sdata
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>282</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>陈二</td>
      <td>239</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 是否放回抽样


```python
# replace=True 为放回抽样
sdata = data.sample(n=3, replace=True)
sdata
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>周八</td>
      <td>197</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>162</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>陈二</td>
      <td>239</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



### 数据合并

#### 记录合并


```python
data1 = pd.read_csv('../data/cnbook/第四章/4.5.1 记录合并/台电.csv')
data1.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1235465</td>
      <td>3256</td>
      <td>台电（Teclast）X98 Air Ⅱ</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1312660</td>
      <td>342</td>
      <td>台电（Teclast）X10HD 3G</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1192758</td>
      <td>1725</td>
      <td>台电（Teclast）P98 Air</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1312671</td>
      <td>279</td>
      <td>台电（Teclast）X89</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1094550</td>
      <td>2563</td>
      <td>台电（Teclast） P19HD</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data2 = pd.read_csv('../data/cnbook/第四章/4.5.1 记录合并/小米.csv')
data2.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1134006</td>
      <td>13231</td>
      <td>小米（MI） MIX</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1192330</td>
      <td>6879</td>
      <td>小米（MI） MIX 2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1225995</td>
      <td>2218</td>
      <td>小米（MI） MAX</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1225988</td>
      <td>1336</td>
      <td>小米（MI） MAX 2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1284247</td>
      <td>578</td>
      <td>小米（MI） 7</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data3 = pd.read_csv('../data/cnbook/第四章/4.5.1 记录合并/苹果.csv')
data3.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>996961</td>
      <td>62014</td>
      <td>Apple iPad Air</td>
    </tr>
    <tr>
      <th>1</th>
      <td>996967</td>
      <td>59503</td>
      <td>Apple iPad mini</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1246836</td>
      <td>8791</td>
      <td>Apple iPhone 7</td>
    </tr>
    <tr>
      <th>3</th>
      <td>996964</td>
      <td>9332</td>
      <td>Apple iPhone X</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1250967</td>
      <td>4932</td>
      <td>Apple iPad Air 2</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
pd.concat([data1, data2, data3])
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1235465</td>
      <td>3256</td>
      <td>台电（Teclast）X98 Air Ⅱ</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1312660</td>
      <td>342</td>
      <td>台电（Teclast）X10HD 3G</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1192758</td>
      <td>1725</td>
      <td>台电（Teclast）P98 Air</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1312671</td>
      <td>279</td>
      <td>台电（Teclast）X89</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1094550</td>
      <td>2563</td>
      <td>台电（Teclast） P19HD</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1327452</td>
      <td>207</td>
      <td>台电（Teclast）P80 3G</td>
    </tr>
    <tr>
      <th>0</th>
      <td>1134006</td>
      <td>13231</td>
      <td>小米（MI） MIX</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1192330</td>
      <td>6879</td>
      <td>小米（MI） MIX 2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1225995</td>
      <td>2218</td>
      <td>小米（MI） MAX</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1225988</td>
      <td>1336</td>
      <td>小米（MI） MAX 2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1284247</td>
      <td>578</td>
      <td>小米（MI） 7</td>
    </tr>
    <tr>
      <th>0</th>
      <td>996961</td>
      <td>62014</td>
      <td>Apple iPad Air</td>
    </tr>
    <tr>
      <th>1</th>
      <td>996967</td>
      <td>59503</td>
      <td>Apple iPad mini</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1246836</td>
      <td>8791</td>
      <td>Apple iPhone 7</td>
    </tr>
    <tr>
      <th>3</th>
      <td>996964</td>
      <td>9332</td>
      <td>Apple iPhone X</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1250967</td>
      <td>4932</td>
      <td>Apple iPad Air 2</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 字段合并


```python
data = pd.read_csv('../data/cnbook/第四章/4.5.2 字段合并/字段合并.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>band</th>
      <th>area</th>
      <th>num</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>189</td>
      <td>2225</td>
      <td>4812</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135</td>
      <td>2225</td>
      <td>5003</td>
    </tr>
    <tr>
      <th>2</th>
      <td>134</td>
      <td>2225</td>
      <td>9938</td>
    </tr>
    <tr>
      <th>3</th>
      <td>188</td>
      <td>2225</td>
      <td>6753</td>
    </tr>
    <tr>
      <th>4</th>
      <td>189</td>
      <td>2225</td>
      <td>3721</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 用 + 号进行合并，因为如果是数值型的会进行计算，所以需要先转换成字符串型的
data = data.astype(str)
# 将 band、area、num 列合并为一个新的列
data['tel'] = data['band'] + data['area'] + data['num']
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>band</th>
      <th>area</th>
      <th>num</th>
      <th>tel</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>189</td>
      <td>2225</td>
      <td>4812</td>
      <td>18922254812</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135</td>
      <td>2225</td>
      <td>5003</td>
      <td>13522255003</td>
    </tr>
    <tr>
      <th>2</th>
      <td>134</td>
      <td>2225</td>
      <td>9938</td>
      <td>13422259938</td>
    </tr>
    <tr>
      <th>3</th>
      <td>188</td>
      <td>2225</td>
      <td>6753</td>
      <td>18822256753</td>
    </tr>
    <tr>
      <th>4</th>
      <td>189</td>
      <td>2225</td>
      <td>3721</td>
      <td>18922253721</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



### 字段匹配


```python
items = pd.read_csv('../data/cnbook/第四章/4.5.3 字段匹配/商品名称.csv')
items.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>996955</td>
      <td>2412</td>
      <td>Apple iPad Air</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1251208</td>
      <td>2061</td>
      <td>Apple iPad Air 2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1197453</td>
      <td>10071</td>
      <td>华为（HUAWEI） 荣耀平板</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1192330</td>
      <td>6879</td>
      <td>小米（MI） 平板</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1225995</td>
      <td>2218</td>
      <td>小米（MI） MAX 2</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
prices = pd.read_csv('../data/cnbook/第四章/4.5.3 字段匹配/商品价格.csv')
prices.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>oldPrice</th>
      <th>nowPrice</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>996955</td>
      <td>3099</td>
      <td>4299</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1251208</td>
      <td>4288</td>
      <td>4289</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1197453</td>
      <td>799</td>
      <td>1000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1192330</td>
      <td>1699</td>
      <td>1799</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1225995</td>
      <td>1299</td>
      <td>1599</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 内链接 inner
pd.merge(
    items,
    prices,
    left_on='id',
    right_on='id'
)
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>oldPrice</th>
      <th>nowPrice</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>996955</td>
      <td>2412</td>
      <td>Apple iPad Air</td>
      <td>3099</td>
      <td>4299</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1251208</td>
      <td>2061</td>
      <td>Apple iPad Air 2</td>
      <td>4288</td>
      <td>4289</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1197453</td>
      <td>10071</td>
      <td>华为（HUAWEI） 荣耀平板</td>
      <td>799</td>
      <td>1000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1192330</td>
      <td>6879</td>
      <td>小米（MI） 平板</td>
      <td>1699</td>
      <td>1799</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1225995</td>
      <td>2218</td>
      <td>小米（MI） MAX 2</td>
      <td>1299</td>
      <td>1599</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1308557</td>
      <td>1605</td>
      <td>华为（HUAWEI） Mate 2</td>
      <td>999</td>
      <td>1099</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1185287</td>
      <td>836</td>
      <td>微软（Microsoft） Surface Pro 3</td>
      <td>7388</td>
      <td>7588</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1197789</td>
      <td>2084</td>
      <td>小米（MI） MAX 1</td>
      <td>1299</td>
      <td>1500</td>
    </tr>
    <tr>
      <th>8</th>
      <td>996957</td>
      <td>11123</td>
      <td>Apple iPad Air 2</td>
      <td>2788</td>
      <td>2899</td>
    </tr>
    <tr>
      <th>9</th>
      <td>1150612</td>
      <td>5857</td>
      <td>台电（Teclast） P98</td>
      <td>999</td>
      <td>1499</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 左链接 left
pd.merge(
    items,
    prices,
    left_on='id',
    right_on='id',
    how='left'
)
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>oldPrice</th>
      <th>nowPrice</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>996955</td>
      <td>2412</td>
      <td>Apple iPad Air</td>
      <td>3099.0</td>
      <td>4299</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1251208</td>
      <td>2061</td>
      <td>Apple iPad Air 2</td>
      <td>4288.0</td>
      <td>4289</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1197453</td>
      <td>10071</td>
      <td>华为（HUAWEI） 荣耀平板</td>
      <td>799.0</td>
      <td>1000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1192330</td>
      <td>6879</td>
      <td>小米（MI） 平板</td>
      <td>1699.0</td>
      <td>1799</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1225995</td>
      <td>2218</td>
      <td>小米（MI） MAX 2</td>
      <td>1299.0</td>
      <td>1599</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1308557</td>
      <td>1605</td>
      <td>华为（HUAWEI） Mate 2</td>
      <td>999.0</td>
      <td>1099</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1185287</td>
      <td>836</td>
      <td>微软（Microsoft） Surface Pro 3</td>
      <td>7388.0</td>
      <td>7588</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1197789</td>
      <td>2084</td>
      <td>小米（MI） MAX 1</td>
      <td>1299.0</td>
      <td>1500</td>
    </tr>
    <tr>
      <th>8</th>
      <td>996957</td>
      <td>11123</td>
      <td>Apple iPad Air 2</td>
      <td>2788.0</td>
      <td>2899</td>
    </tr>
    <tr>
      <th>9</th>
      <td>1150612</td>
      <td>5857</td>
      <td>台电（Teclast） P98</td>
      <td>999.0</td>
      <td>1499</td>
    </tr>
    <tr>
      <th>10</th>
      <td>0</td>
      <td>0</td>
      <td>左边才有的</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 右链接 right
pd.merge(
    items,
    prices,
    left_on='id',
    right_on='id',
    how='right'
)
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>oldPrice</th>
      <th>nowPrice</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>996955</td>
      <td>2412.0</td>
      <td>Apple iPad Air</td>
      <td>3099</td>
      <td>4299</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1251208</td>
      <td>2061.0</td>
      <td>Apple iPad Air 2</td>
      <td>4288</td>
      <td>4289</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1197453</td>
      <td>10071.0</td>
      <td>华为（HUAWEI） 荣耀平板</td>
      <td>799</td>
      <td>1000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1192330</td>
      <td>6879.0</td>
      <td>小米（MI） 平板</td>
      <td>1699</td>
      <td>1799</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1225995</td>
      <td>2218.0</td>
      <td>小米（MI） MAX 2</td>
      <td>1299</td>
      <td>1599</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1308557</td>
      <td>1605.0</td>
      <td>华为（HUAWEI） Mate 2</td>
      <td>999</td>
      <td>1099</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1185287</td>
      <td>836.0</td>
      <td>微软（Microsoft） Surface Pro 3</td>
      <td>7388</td>
      <td>7588</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1197789</td>
      <td>2084.0</td>
      <td>小米（MI） MAX 1</td>
      <td>1299</td>
      <td>1500</td>
    </tr>
    <tr>
      <th>8</th>
      <td>996957</td>
      <td>11123.0</td>
      <td>Apple iPad Air 2</td>
      <td>2788</td>
      <td>2899</td>
    </tr>
    <tr>
      <th>9</th>
      <td>1150612</td>
      <td>5857.0</td>
      <td>台电（Teclast） P98</td>
      <td>999</td>
      <td>1499</td>
    </tr>
    <tr>
      <th>10</th>
      <td>1</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>1</td>
      <td>右边才有的</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 外链接 outer
pd.merge(
    items,
    prices,
    left_on='id',
    right_on='id',
    how='outer'
)
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>comments</th>
      <th>title</th>
      <th>oldPrice</th>
      <th>nowPrice</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>996955</td>
      <td>2412.0</td>
      <td>Apple iPad Air</td>
      <td>3099.0</td>
      <td>4299</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1251208</td>
      <td>2061.0</td>
      <td>Apple iPad Air 2</td>
      <td>4288.0</td>
      <td>4289</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1197453</td>
      <td>10071.0</td>
      <td>华为（HUAWEI） 荣耀平板</td>
      <td>799.0</td>
      <td>1000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1192330</td>
      <td>6879.0</td>
      <td>小米（MI） 平板</td>
      <td>1699.0</td>
      <td>1799</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1225995</td>
      <td>2218.0</td>
      <td>小米（MI） MAX 2</td>
      <td>1299.0</td>
      <td>1599</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1308557</td>
      <td>1605.0</td>
      <td>华为（HUAWEI） Mate 2</td>
      <td>999.0</td>
      <td>1099</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1185287</td>
      <td>836.0</td>
      <td>微软（Microsoft） Surface Pro 3</td>
      <td>7388.0</td>
      <td>7588</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1197789</td>
      <td>2084.0</td>
      <td>小米（MI） MAX 1</td>
      <td>1299.0</td>
      <td>1500</td>
    </tr>
    <tr>
      <th>8</th>
      <td>996957</td>
      <td>11123.0</td>
      <td>Apple iPad Air 2</td>
      <td>2788.0</td>
      <td>2899</td>
    </tr>
    <tr>
      <th>9</th>
      <td>1150612</td>
      <td>5857.0</td>
      <td>台电（Teclast） P98</td>
      <td>999.0</td>
      <td>1499</td>
    </tr>
    <tr>
      <th>10</th>
      <td>0</td>
      <td>0.0</td>
      <td>左边才有的</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>11</th>
      <td>1</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>1.0</td>
      <td>右边才有的</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



### 数据计算

#### 简单计算


```python
data = pd.read_csv('../data/cnbook/第四章/4.6.1 简单计算/单价数量.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>name</th>
      <th>price</th>
      <th>num</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>A</td>
      <td>6058</td>
      <td>408</td>
    </tr>
    <tr>
      <th>1</th>
      <td>B</td>
      <td>1322</td>
      <td>653</td>
    </tr>
    <tr>
      <th>2</th>
      <td>C</td>
      <td>7403</td>
      <td>400</td>
    </tr>
    <tr>
      <th>3</th>
      <td>D</td>
      <td>4911</td>
      <td>487</td>
    </tr>
    <tr>
      <th>4</th>
      <td>E</td>
      <td>3320</td>
      <td>56</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data['total'] = data.price * data.num
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>name</th>
      <th>price</th>
      <th>num</th>
      <th>total</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>A</td>
      <td>6058</td>
      <td>408</td>
      <td>2471664</td>
    </tr>
    <tr>
      <th>1</th>
      <td>B</td>
      <td>1322</td>
      <td>653</td>
      <td>863266</td>
    </tr>
    <tr>
      <th>2</th>
      <td>C</td>
      <td>7403</td>
      <td>400</td>
      <td>2961200</td>
    </tr>
    <tr>
      <th>3</th>
      <td>D</td>
      <td>4911</td>
      <td>487</td>
      <td>2391657</td>
    </tr>
    <tr>
      <th>4</th>
      <td>E</td>
      <td>3320</td>
      <td>56</td>
      <td>185920</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 时间计算


```python
data = pd.read_csv('../data/cnbook/第四章/4.6.2 时间计算/时间计算.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>电话</th>
      <th>注册时间</th>
      <th>是否微信</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166412894295</td>
      <td>2011/1/1</td>
      <td>否</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135416795207</td>
      <td>2012/2/3</td>
      <td>否</td>
    </tr>
    <tr>
      <th>2</th>
      <td>177423353436</td>
      <td>2013/3/2</td>
      <td>是</td>
    </tr>
    <tr>
      <th>3</th>
      <td>189424978309</td>
      <td>2014/4/11</td>
      <td>是</td>
    </tr>
    <tr>
      <th>4</th>
      <td>134450811715</td>
      <td>2015/5/18</td>
      <td>否</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data['时间'] = pd.to_datetime(
    data.注册时间,
    format='%Y/%m/%d'
)
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>电话</th>
      <th>注册时间</th>
      <th>是否微信</th>
      <th>时间</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166412894295</td>
      <td>2011/1/1</td>
      <td>否</td>
      <td>2011-01-01</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135416795207</td>
      <td>2012/2/3</td>
      <td>否</td>
      <td>2012-02-03</td>
    </tr>
    <tr>
      <th>2</th>
      <td>177423353436</td>
      <td>2013/3/2</td>
      <td>是</td>
      <td>2013-03-02</td>
    </tr>
    <tr>
      <th>3</th>
      <td>189424978309</td>
      <td>2014/4/11</td>
      <td>是</td>
      <td>2014-04-11</td>
    </tr>
    <tr>
      <th>4</th>
      <td>134450811715</td>
      <td>2015/5/18</td>
      <td>否</td>
      <td>2015-05-18</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
from datetime import datetime
# 计算注册天数
data['注册天数'] = datetime.now() - data.时间
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>电话</th>
      <th>注册时间</th>
      <th>是否微信</th>
      <th>时间</th>
      <th>注册天数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166412894295</td>
      <td>2011/1/1</td>
      <td>否</td>
      <td>2011-01-01</td>
      <td>3188 days 18:19:05.434942</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135416795207</td>
      <td>2012/2/3</td>
      <td>否</td>
      <td>2012-02-03</td>
      <td>2790 days 18:19:05.434942</td>
    </tr>
    <tr>
      <th>2</th>
      <td>177423353436</td>
      <td>2013/3/2</td>
      <td>是</td>
      <td>2013-03-02</td>
      <td>2397 days 18:19:05.434942</td>
    </tr>
    <tr>
      <th>3</th>
      <td>189424978309</td>
      <td>2014/4/11</td>
      <td>是</td>
      <td>2014-04-11</td>
      <td>1992 days 18:19:05.434942</td>
    </tr>
    <tr>
      <th>4</th>
      <td>134450811715</td>
      <td>2015/5/18</td>
      <td>否</td>
      <td>2015-05-18</td>
      <td>1590 days 18:19:05.434942</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data['注册天数'] = data['注册天数'].dt.days
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>电话</th>
      <th>注册时间</th>
      <th>是否微信</th>
      <th>时间</th>
      <th>注册天数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166412894295</td>
      <td>2011/1/1</td>
      <td>否</td>
      <td>2011-01-01</td>
      <td>3188</td>
    </tr>
    <tr>
      <th>1</th>
      <td>135416795207</td>
      <td>2012/2/3</td>
      <td>否</td>
      <td>2012-02-03</td>
      <td>2790</td>
    </tr>
    <tr>
      <th>2</th>
      <td>177423353436</td>
      <td>2013/3/2</td>
      <td>是</td>
      <td>2013-03-02</td>
      <td>2397</td>
    </tr>
    <tr>
      <th>3</th>
      <td>189424978309</td>
      <td>2014/4/11</td>
      <td>是</td>
      <td>2014-04-11</td>
      <td>1992</td>
    </tr>
    <tr>
      <th>4</th>
      <td>134450811715</td>
      <td>2015/5/18</td>
      <td>否</td>
      <td>2015-05-18</td>
      <td>1590</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 数据标准化

数据标准化是指对数据按照比例进行缩放，使之落入特定区域，数据标准化的作用就是消除单位量纲的影响，方便进行不同变量间的对比分析

0-1标准化：  
x' = (x - min) / (max -min)


```python
data = pd.read_csv('../data/cnbook/第四章/4.6.3 数据标准化/标准化.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>256</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>陈二</td>
      <td>239</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>282</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>李四</td>
      <td>245</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>162</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 实现 0-1 标准化
data['消费标准化'] = (data['消费'] - data['消费'].min())/(data['消费'].max() - data['消费'].min())
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>姓名</th>
      <th>消费</th>
      <th>消费标准化</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>刘一</td>
      <td>256</td>
      <td>0.630872</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>陈二</td>
      <td>239</td>
      <td>0.516779</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>张三</td>
      <td>282</td>
      <td>0.805369</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>李四</td>
      <td>245</td>
      <td>0.557047</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>王五</td>
      <td>162</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



#### 数据分组


```python
data = pd.read_csv('../data/cnbook/第四章/4.6.4 数据分组/数据分组.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tel</th>
      <th>cost</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166424556600</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>166424557199</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>166424561768</td>
      <td>75.3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>166424569696</td>
      <td>20.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>166424569924</td>
      <td>97.3</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 分组的数组


```python
# 查看最大值最小值
data.cost.min()
```




    2.0




```python
data.cost.max()
```




    100.0




```python
# 定义分组
bins = [0, 20, 40, 60, 80, 100]
data['cut'] = pd.cut(data.cost, bins)
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tel</th>
      <th>cost</th>
      <th>cut</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166424556600</td>
      <td>2.0</td>
      <td>(0, 20]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>166424557199</td>
      <td>5.0</td>
      <td>(0, 20]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>166424561768</td>
      <td>75.3</td>
      <td>(60, 80]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>166424569696</td>
      <td>20.0</td>
      <td>(0, 20]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>166424569924</td>
      <td>97.3</td>
      <td>(80, 100]</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 区间的闭合

默认是使用 左开右闭 的  
right = True 表示 左开右闭  
right = False 表示 左闭右开


```python
bins = [0, 20, 40, 60, 80, 100, 120]
data['cut'] = pd.cut(data.cost, bins, right=False)
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tel</th>
      <th>cost</th>
      <th>cut</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166424556600</td>
      <td>2.0</td>
      <td>[0, 20)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>166424557199</td>
      <td>5.0</td>
      <td>[0, 20)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>166424561768</td>
      <td>75.3</td>
      <td>[60, 80)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>166424569696</td>
      <td>20.0</td>
      <td>[20, 40)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>166424569924</td>
      <td>97.3</td>
      <td>[80, 100)</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 自定义标签


```python
bins = [0, 20, 40, 60, 80, 100, 120]
customLabels = ['0-20', '20-40', '40-60', '60-80', '80-100', '100-120']
data['cut'] = pd.cut(data.cost, bins, right=False, labels=customLabels)
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tel</th>
      <th>cost</th>
      <th>cut</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166424556600</td>
      <td>2.0</td>
      <td>0-20</td>
    </tr>
    <tr>
      <th>1</th>
      <td>166424557199</td>
      <td>5.0</td>
      <td>0-20</td>
    </tr>
    <tr>
      <th>2</th>
      <td>166424561768</td>
      <td>75.3</td>
      <td>60-80</td>
    </tr>
    <tr>
      <th>3</th>
      <td>166424569696</td>
      <td>20.0</td>
      <td>20-40</td>
    </tr>
    <tr>
      <th>4</th>
      <td>166424569924</td>
      <td>97.3</td>
      <td>80-100</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



## 数据分析

### 对比分析

概念，无案例

### 基本统计分析

描述性统计分析，主要包括数据的集中趋势分析、数据的离散程度分析、数据的频数分布分析等，常用的统计指标有：计数、求和、平均数、
方差、标准差等


```python
data = pd.read_csv('../data/cnbook/第五章/5.2 基本统计分析/描述性统计分析.csv')
data
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>area</th>
      <th>sales</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>越秀区</td>
      <td>1250</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>天河区</td>
      <td>1253</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>番禺区</td>
      <td>1280</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>南沙区</td>
      <td>1260</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>增城区</td>
      <td>1310</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>花都区</td>
      <td>1190</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>海珠区</td>
      <td>1288</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>黄埔区</td>
      <td>1310</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>白云区</td>
      <td>1220</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>从化市</td>
      <td>1380</td>
    </tr>
    <tr>
      <th>10</th>
      <td>11</td>
      <td>萝岗区</td>
      <td>1256</td>
    </tr>
    <tr>
      <th>11</th>
      <td>12</td>
      <td>荔湾区</td>
      <td>1220</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 描述性统计分析
data.sales.describe()
```




    count      12.000000
    mean     1268.083333
    std        50.510950
    min      1190.000000
    25%      1242.500000
    50%      1258.000000
    75%      1293.500000
    max      1380.000000
    Name: sales, dtype: float64



获取百分位值


```python
# 获取 30% 分位数最近的值
data.sales.quantile(0.3, interpolation='nearest')
```




    1250



### 分组分析


```python
data = pd.read_csv('../data/cnbook/第五章/5.3 分组分析/分组分析.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>reg_date</th>
      <th>id_num</th>
      <th>gender</th>
      <th>birthday</th>
      <th>age</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>100000</td>
      <td>2011/1/1</td>
      <td>15010219621116401I</td>
      <td>男</td>
      <td>1962/11/16</td>
      <td>52</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100001</td>
      <td>2011/1/1</td>
      <td>45092319910527539E</td>
      <td>男</td>
      <td>1991/5/27</td>
      <td>23</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100002</td>
      <td>2011/1/1</td>
      <td>35010319841017421J</td>
      <td>男</td>
      <td>1984/10/17</td>
      <td>30</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100006</td>
      <td>2011/1/1</td>
      <td>37110219860824751B</td>
      <td>男</td>
      <td>1986/8/24</td>
      <td>28</td>
    </tr>
    <tr>
      <th>4</th>
      <td>100010</td>
      <td>2011/1/1</td>
      <td>53042219860714031J</td>
      <td>男</td>
      <td>1986/7/14</td>
      <td>28</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 按照性别分组，对年龄求平均值
data.groupby(
    by=['gender']
).age.agg('mean')
```




    gender
    女    30.392493
    男    26.979629
    Name: age, dtype: float64




```python
# 分组不做索引
data.groupby(
    by=['gender'],
    as_index=False
).age.agg('mean')
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gender</th>
      <th>age</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>女</td>
      <td>30.392493</td>
    </tr>
    <tr>
      <th>1</th>
      <td>男</td>
      <td>26.979629</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



### 结构分析

在分组的基础上，计算各组成部分所占的比重


```python
data = pd.read_csv('../data/cnbook/第五章/5.4 结构分析/结构分析.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>reg_date</th>
      <th>id_num</th>
      <th>gender</th>
      <th>birthday</th>
      <th>age</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>100000</td>
      <td>2011/1/1</td>
      <td>15010219621116401I</td>
      <td>男</td>
      <td>1962/11/16</td>
      <td>52</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100001</td>
      <td>2011/1/1</td>
      <td>45092319910527539E</td>
      <td>男</td>
      <td>1991/5/27</td>
      <td>23</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100002</td>
      <td>2011/1/1</td>
      <td>35010319841017421J</td>
      <td>男</td>
      <td>1984/10/17</td>
      <td>30</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100006</td>
      <td>2011/1/1</td>
      <td>37110219860824751B</td>
      <td>男</td>
      <td>1986/8/24</td>
      <td>28</td>
    </tr>
    <tr>
      <th>4</th>
      <td>100010</td>
      <td>2011/1/1</td>
      <td>53042219860714031J</td>
      <td>男</td>
      <td>1986/7/14</td>
      <td>28</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
ga = data.groupby(
    by='gender'
).id.agg('count')
ga
```




    gender
    女     4316
    男    54785
    Name: id, dtype: int64




```python
# 计算各分组的比例
ga/ga.sum()
```




    gender
    女    0.073028
    男    0.926972
    Name: id, dtype: float64



### 分布分析


```python
data = pd.read_csv('../data/cnbook/第五章/5.5 分布分析/分布分析.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>用户ID</th>
      <th>注册日期</th>
      <th>身份证号码</th>
      <th>性别</th>
      <th>出生日期</th>
      <th>年龄</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>100000</td>
      <td>2011/1/1</td>
      <td>15010219621116401I</td>
      <td>男</td>
      <td>1962/11/16</td>
      <td>52</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100001</td>
      <td>2011/1/1</td>
      <td>45092319910527539E</td>
      <td>男</td>
      <td>1991/5/27</td>
      <td>23</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100002</td>
      <td>2011/1/1</td>
      <td>35010319841017421J</td>
      <td>男</td>
      <td>1984/10/17</td>
      <td>30</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100006</td>
      <td>2011/1/1</td>
      <td>37110219860824751B</td>
      <td>男</td>
      <td>1986/8/24</td>
      <td>28</td>
    </tr>
    <tr>
      <th>4</th>
      <td>100010</td>
      <td>2011/1/1</td>
      <td>53042219860714031J</td>
      <td>男</td>
      <td>1986/7/14</td>
      <td>28</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 根据年龄段分组
bins = [0, 20, 30, 40, 100]
data['年龄分层'] = pd.cut(
    data.年龄,
    bins
)
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>用户ID</th>
      <th>注册日期</th>
      <th>身份证号码</th>
      <th>性别</th>
      <th>出生日期</th>
      <th>年龄</th>
      <th>年龄分层</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>100000</td>
      <td>2011/1/1</td>
      <td>15010219621116401I</td>
      <td>男</td>
      <td>1962/11/16</td>
      <td>52</td>
      <td>(40, 100]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100001</td>
      <td>2011/1/1</td>
      <td>45092319910527539E</td>
      <td>男</td>
      <td>1991/5/27</td>
      <td>23</td>
      <td>(20, 30]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100002</td>
      <td>2011/1/1</td>
      <td>35010319841017421J</td>
      <td>男</td>
      <td>1984/10/17</td>
      <td>30</td>
      <td>(20, 30]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100006</td>
      <td>2011/1/1</td>
      <td>37110219860824751B</td>
      <td>男</td>
      <td>1986/8/24</td>
      <td>28</td>
      <td>(20, 30]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>100010</td>
      <td>2011/1/1</td>
      <td>53042219860714031J</td>
      <td>男</td>
      <td>1986/7/14</td>
      <td>28</td>
      <td>(20, 30]</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
aggResult = data.groupby(
    by='年龄分层',
).用户ID.agg('count')
aggResult
```




    年龄分层
    (0, 20]       2061
    (20, 30]     46858
    (30, 40]      8729
    (40, 100]     1453
    Name: 用户ID, dtype: int64




```python
# 计算各分组百分比
temp = round(aggResult/aggResult.sum(), 4)*100
temp.map('{:,.2f}%'.format)
```




    年龄分层
    (0, 20]       3.49%
    (20, 30]     79.28%
    (30, 40]     14.77%
    (40, 100]     2.46%
    Name: 用户ID, dtype: object



### 交叉分析

pandas 实现透视表功能
```python
pandas.DataFrame.pivot_table(values, index, columns, aggfunc='mean', fill_value=None)
values: 透视表中的值
index: 透视表中的行
columns: 透视表中的列
aggfuc: 统计函数
fill_value: NA 值统一的替换值
```


```python
data = pd.read_csv('../data/cnbook/第五章/5.6 交叉分析/交叉分析.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>用户ID</th>
      <th>注册日期</th>
      <th>身份证号码</th>
      <th>性别</th>
      <th>出生日期</th>
      <th>年龄</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>100000</td>
      <td>2011/1/1</td>
      <td>15010219621116401I</td>
      <td>男</td>
      <td>1962/11/16</td>
      <td>52</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100001</td>
      <td>2011/1/1</td>
      <td>45092319910527539E</td>
      <td>男</td>
      <td>1991/5/27</td>
      <td>23</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100002</td>
      <td>2011/1/1</td>
      <td>35010319841017421J</td>
      <td>男</td>
      <td>1984/10/17</td>
      <td>30</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100006</td>
      <td>2011/1/1</td>
      <td>37110219860824751B</td>
      <td>男</td>
      <td>1986/8/24</td>
      <td>28</td>
    </tr>
    <tr>
      <th>4</th>
      <td>100010</td>
      <td>2011/1/1</td>
      <td>53042219860714031J</td>
      <td>男</td>
      <td>1986/7/14</td>
      <td>28</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
bins = [0, 20, 30, 40, 100]
data['年龄分层'] = pd.cut(data.年龄, bins)
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>用户ID</th>
      <th>注册日期</th>
      <th>身份证号码</th>
      <th>性别</th>
      <th>出生日期</th>
      <th>年龄</th>
      <th>年龄分层</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>100000</td>
      <td>2011/1/1</td>
      <td>15010219621116401I</td>
      <td>男</td>
      <td>1962/11/16</td>
      <td>52</td>
      <td>(40, 100]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100001</td>
      <td>2011/1/1</td>
      <td>45092319910527539E</td>
      <td>男</td>
      <td>1991/5/27</td>
      <td>23</td>
      <td>(20, 30]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100002</td>
      <td>2011/1/1</td>
      <td>35010319841017421J</td>
      <td>男</td>
      <td>1984/10/17</td>
      <td>30</td>
      <td>(20, 30]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100006</td>
      <td>2011/1/1</td>
      <td>37110219860824751B</td>
      <td>男</td>
      <td>1986/8/24</td>
      <td>28</td>
      <td>(20, 30]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>100010</td>
      <td>2011/1/1</td>
      <td>53042219860714031J</td>
      <td>男</td>
      <td>1986/7/14</td>
      <td>28</td>
      <td>(20, 30]</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 进行交叉分析
data.pivot_table(
    values='用户ID',
    index='年龄分层',
    columns='性别',
    aggfunc='count'
)
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>性别</th>
      <th>女</th>
      <th>男</th>
    </tr>
    <tr>
      <th>年龄分层</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>(0, 20]</th>
      <td>111</td>
      <td>1950</td>
    </tr>
    <tr>
      <th>(20, 30]</th>
      <td>2903</td>
      <td>43955</td>
    </tr>
    <tr>
      <th>(30, 40]</th>
      <td>735</td>
      <td>7994</td>
    </tr>
    <tr>
      <th>(40, 100]</th>
      <td>567</td>
      <td>886</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



### RFM 分析


```python
data = pd.read_csv('../data/cnbook/第五章/5.7 RFM分析/RFM分析.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>OrderID</th>
      <th>CustomerID</th>
      <th>DealDateTime</th>
      <th>Sales</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>4529</td>
      <td>34858</td>
      <td>2014-05-14</td>
      <td>807</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4532</td>
      <td>14597</td>
      <td>2014-05-14</td>
      <td>160</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4533</td>
      <td>24598</td>
      <td>2014-05-14</td>
      <td>418</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4534</td>
      <td>14600</td>
      <td>2014-05-14</td>
      <td>401</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4535</td>
      <td>24798</td>
      <td>2014-05-14</td>
      <td>234</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data['DealDateTime'] = pd.to_datetime(data.DealDateTime, format='%Y/%m/%d')
data.DealDateTime.dtype
```




    dtype('<M8[ns]')




```python
# 计算时间差
data['DateDiff'] = datetime.now() - data['DealDateTime']
data['DateDiff'] = data['DateDiff'].dt.days
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>OrderID</th>
      <th>CustomerID</th>
      <th>DealDateTime</th>
      <th>Sales</th>
      <th>DateDiff</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>4529</td>
      <td>34858</td>
      <td>2014-05-14</td>
      <td>807</td>
      <td>1959</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4532</td>
      <td>14597</td>
      <td>2014-05-14</td>
      <td>160</td>
      <td>1959</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4533</td>
      <td>24598</td>
      <td>2014-05-14</td>
      <td>418</td>
      <td>1959</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4534</td>
      <td>14600</td>
      <td>2014-05-14</td>
      <td>401</td>
      <td>1959</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4535</td>
      <td>24798</td>
      <td>2014-05-14</td>
      <td>234</td>
      <td>1959</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 计算最近时间距离
R_Agg = data.groupby(
    by='CustomerID',
    as_index=False
).DateDiff.agg('min')
R_Agg.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>CustomerID</th>
      <th>DateDiff</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>14568</td>
      <td>1468</td>
    </tr>
    <tr>
      <th>1</th>
      <td>14569</td>
      <td>1558</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14570</td>
      <td>1488</td>
    </tr>
    <tr>
      <th>3</th>
      <td>14571</td>
      <td>1528</td>
    </tr>
    <tr>
      <th>4</th>
      <td>14572</td>
      <td>1552</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 计算频率
F_Agg = data.groupby(
    by='CustomerID',
    as_index=False
).OrderID.agg('count')
F_Agg.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>CustomerID</th>
      <th>OrderID</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>14568</td>
      <td>15</td>
    </tr>
    <tr>
      <th>1</th>
      <td>14569</td>
      <td>12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14570</td>
      <td>15</td>
    </tr>
    <tr>
      <th>3</th>
      <td>14571</td>
      <td>15</td>
    </tr>
    <tr>
      <th>4</th>
      <td>14572</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 计算金额
M_Agg = data.groupby(
    by='CustomerID',
    as_index=False
).Sales.agg('sum')
M_Agg.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>CustomerID</th>
      <th>Sales</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>14568</td>
      <td>6255</td>
    </tr>
    <tr>
      <th>1</th>
      <td>14569</td>
      <td>5420</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14570</td>
      <td>8261</td>
    </tr>
    <tr>
      <th>3</th>
      <td>14571</td>
      <td>8124</td>
    </tr>
    <tr>
      <th>4</th>
      <td>14572</td>
      <td>3334</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 合并数据
aggData = R_Agg.merge(F_Agg).merge(M_Agg)
aggData.columns = ['CustomerID', 'RecencyAgg', 'FrequencyAgg', 'MonetaryAgg']
aggData.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>CustomerID</th>
      <th>RecencyAgg</th>
      <th>FrequencyAgg</th>
      <th>MonetaryAgg</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>14568</td>
      <td>1468</td>
      <td>15</td>
      <td>6255</td>
    </tr>
    <tr>
      <th>1</th>
      <td>14569</td>
      <td>1558</td>
      <td>12</td>
      <td>5420</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14570</td>
      <td>1488</td>
      <td>15</td>
      <td>8261</td>
    </tr>
    <tr>
      <th>3</th>
      <td>14571</td>
      <td>1528</td>
      <td>15</td>
      <td>8124</td>
    </tr>
    <tr>
      <th>4</th>
      <td>14572</td>
      <td>1552</td>
      <td>8</td>
      <td>3334</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 对 R、F、M 三个统计量进行得分计算
# 按照大小顺序分成五组 
# 1. 获取分割点，指定分组的百分位点，获取百分位点的值
bins = aggData.RecencyAgg.quantile(
    q=[0, 0.2, 0.4, 0.6, 0.8, 1],
    interpolation='nearest'
)
bins
```




    0.0    1460
    0.2    1467
    0.4    1479
    0.6    1494
    0.8    1513
    1.0    1725
    Name: RecencyAgg, dtype: int64




```python
# 2. 根据百分位数对数据进行分段,指定每组对应的分数
# 因为 cut 默认左开右闭，为了包含第一个数，设置为 0 
bins[0] = 0
# 用户越久没消费 R 值就越小，分之就越小
rLabels = [5, 4, 3, 2, 1]
R_S = pd.cut(
    aggData.RecencyAgg,
    bins=bins,
    labels=rLabels
)
R_S.head()
```




    0    4
    1    1
    2    3
    3    1
    4    1
    Name: RecencyAgg, dtype: category
    Categories (5, int64): [5 < 4 < 3 < 2 < 1]




```python
# 同样的原理求的 F 值
bins = aggData.FrequencyAgg.quantile(
    q=[0, 0.2, 0.4, 0.6, 0.8, 1],
    interpolation='nearest'
)
bins[0] = 0
# 用户消费频次越高 F 值就越大，分之就越大
fLabels = [1, 2, 3, 4, 5]
F_S = pd.cut(
    aggData.FrequencyAgg,
    bins=bins,
    labels=fLabels
)
F_S.head()
```




    0    4
    1    2
    2    4
    3    4
    4    1
    Name: FrequencyAgg, dtype: category
    Categories (5, int64): [1 < 2 < 3 < 4 < 5]




```python
# 同样的原理求的 M 值
bins = aggData.MonetaryAgg.quantile(
    q=[0, 0.2, 0.4, 0.6, 0.8, 1],
    interpolation='nearest'
)
bins[0] = 0
# 用户消费金额越高 M 值就越大，分之就越大
mLabels = [1, 2, 3, 4, 5]
M_S = pd.cut(
    aggData.MonetaryAgg,
    bins=bins,
    labels=mLabels
)
M_S.head()
```




    0    3
    1    2
    2    4
    3    4
    4    1
    Name: MonetaryAgg, dtype: category
    Categories (5, int64): [1 < 2 < 3 < 4 < 5]




```python
aggData['R_S'] = R_S
aggData['F_S'] = F_S
aggData['M_S'] = M_S
aggData.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>CustomerID</th>
      <th>RecencyAgg</th>
      <th>FrequencyAgg</th>
      <th>MonetaryAgg</th>
      <th>R_S</th>
      <th>F_S</th>
      <th>M_S</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>14568</td>
      <td>1468</td>
      <td>15</td>
      <td>6255</td>
      <td>4</td>
      <td>4</td>
      <td>3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>14569</td>
      <td>1558</td>
      <td>12</td>
      <td>5420</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14570</td>
      <td>1488</td>
      <td>15</td>
      <td>8261</td>
      <td>3</td>
      <td>4</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>14571</td>
      <td>1528</td>
      <td>15</td>
      <td>8124</td>
      <td>1</td>
      <td>4</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>14572</td>
      <td>1552</td>
      <td>8</td>
      <td>3334</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 计算 RFM 得分，然后使用分为 八个 分组
aggData['RFM'] = 100*R_S.astype(int) + 10*F_S.astype(int) + 1*M_S.astype(int)
```


```python
aggData.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>CustomerID</th>
      <th>RecencyAgg</th>
      <th>FrequencyAgg</th>
      <th>MonetaryAgg</th>
      <th>R_S</th>
      <th>F_S</th>
      <th>M_S</th>
      <th>RFM</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>14568</td>
      <td>1468</td>
      <td>15</td>
      <td>6255</td>
      <td>4</td>
      <td>4</td>
      <td>3</td>
      <td>443</td>
    </tr>
    <tr>
      <th>1</th>
      <td>14569</td>
      <td>1558</td>
      <td>12</td>
      <td>5420</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>122</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14570</td>
      <td>1488</td>
      <td>15</td>
      <td>8261</td>
      <td>3</td>
      <td>4</td>
      <td>4</td>
      <td>344</td>
    </tr>
    <tr>
      <th>3</th>
      <td>14571</td>
      <td>1528</td>
      <td>15</td>
      <td>8124</td>
      <td>1</td>
      <td>4</td>
      <td>4</td>
      <td>144</td>
    </tr>
    <tr>
      <th>4</th>
      <td>14572</td>
      <td>1552</td>
      <td>8</td>
      <td>3334</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>111</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
bins = aggData.RFM.quantile(
    q=[0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1],
    interpolation='nearest'
)
bins[0] = 0
# RFM 值越大，得分越高
rfmLabels = [1, 2, 3, 4, 5, 6, 7, 8]
aggData['level'] = pd.cut(
    aggData.RFM,
    bins,
    labels = rfmLabels
)
aggData.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>CustomerID</th>
      <th>RecencyAgg</th>
      <th>FrequencyAgg</th>
      <th>MonetaryAgg</th>
      <th>R_S</th>
      <th>F_S</th>
      <th>M_S</th>
      <th>RFM</th>
      <th>level</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>14568</td>
      <td>1468</td>
      <td>15</td>
      <td>6255</td>
      <td>4</td>
      <td>4</td>
      <td>3</td>
      <td>443</td>
      <td>6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>14569</td>
      <td>1558</td>
      <td>12</td>
      <td>5420</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>122</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14570</td>
      <td>1488</td>
      <td>15</td>
      <td>8261</td>
      <td>3</td>
      <td>4</td>
      <td>4</td>
      <td>344</td>
      <td>5</td>
    </tr>
    <tr>
      <th>3</th>
      <td>14571</td>
      <td>1528</td>
      <td>15</td>
      <td>8124</td>
      <td>1</td>
      <td>4</td>
      <td>4</td>
      <td>144</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>14572</td>
      <td>1552</td>
      <td>8</td>
      <td>3334</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>111</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



至此， RFM 分析的计算就完成了，求解得到的 level 和客户类型的对应关系如下

| R 值 | F 值     | M 值     | 客户类型 | level  |
| :--  | :----| :----| :----| :----|
| 高  | 高 | 高 | 高价值客户 | 8 |
| 低  | 高 | 高 | 重点保持客户 | 7 |
| 高  | 低 | 高 | 重点发展客户 | 6 |
| 低  | 低 | 高 | 重点挽留客户 | 5 |
| 高  | 高 | 低 | 一般价值客户 | 4 |
| 低  | 高 | 低 | 一般保持客户 | 3 |
| 高  | 低 | 低 | 一般发展客户 | 2 |
| 低  | 低 | 低 | 潜在客户 | 1 |

最后我们看一下每个等级的人数


```python
aggData.groupby(
    by='level',
)['CustomerID'].agg('count')
```




    level
    1    153
    2    164
    3    135
    4    153
    5    154
    6    142
    7    151
    8    148
    Name: CustomerID, dtype: int64



### 矩阵分析


```python
data = pd.read_csv('../data/cnbook/第五章/5.8 矩阵分析/矩阵分析.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>号码</th>
      <th>省份</th>
      <th>手机品牌</th>
      <th>通信品牌</th>
      <th>手机操作系统</th>
      <th>月消费（元）</th>
      <th>月流量（MB）</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166547114238</td>
      <td>河北</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>298.9</td>
      <td>318.6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>166423353436</td>
      <td>河南</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>272.8</td>
      <td>1385.9</td>
    </tr>
    <tr>
      <th>2</th>
      <td>166556915853</td>
      <td>福建</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>68.8</td>
      <td>443.6</td>
    </tr>
    <tr>
      <th>3</th>
      <td>166434728749</td>
      <td>湖南</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>4.6</td>
      <td>817.3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>166544742252</td>
      <td>北京</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>113.2</td>
      <td>837.4</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 按照省份分组，对月平均消费进行统计
costAgg = data.groupby(
    by='省份',
    as_index=False
)['月消费（元）'].agg('mean')
costAgg.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>省份</th>
      <th>月消费（元）</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>上海</td>
      <td>152.927748</td>
    </tr>
    <tr>
      <th>1</th>
      <td>云南</td>
      <td>148.100832</td>
    </tr>
    <tr>
      <th>2</th>
      <td>内蒙古</td>
      <td>154.427736</td>
    </tr>
    <tr>
      <th>3</th>
      <td>北京</td>
      <td>148.895912</td>
    </tr>
    <tr>
      <th>4</th>
      <td>台湾</td>
      <td>146.081277</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 按照省份分组，对月平均流量进行统计
dataAgg = data.groupby(
    by='省份',
    as_index=False
)['月流量（MB）'].agg('mean')
dataAgg.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>省份</th>
      <th>月流量（MB）</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>上海</td>
      <td>1025.075667</td>
    </tr>
    <tr>
      <th>1</th>
      <td>云南</td>
      <td>985.382830</td>
    </tr>
    <tr>
      <th>2</th>
      <td>内蒙古</td>
      <td>997.965655</td>
    </tr>
    <tr>
      <th>3</th>
      <td>北京</td>
      <td>1010.642977</td>
    </tr>
    <tr>
      <th>4</th>
      <td>台湾</td>
      <td>1014.620346</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
aggData = costAgg.merge(dataAgg)
aggData.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>省份</th>
      <th>月消费（元）</th>
      <th>月流量（MB）</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>上海</td>
      <td>152.927748</td>
      <td>1025.075667</td>
    </tr>
    <tr>
      <th>1</th>
      <td>云南</td>
      <td>148.100832</td>
      <td>985.382830</td>
    </tr>
    <tr>
      <th>2</th>
      <td>内蒙古</td>
      <td>154.427736</td>
      <td>997.965655</td>
    </tr>
    <tr>
      <th>3</th>
      <td>北京</td>
      <td>148.895912</td>
      <td>1010.642977</td>
    </tr>
    <tr>
      <th>4</th>
      <td>台湾</td>
      <td>146.081277</td>
      <td>1014.620346</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 画矩阵图
from matplotlib import font_manager
import matplotlib.pyplot as plt

# 生成字体属性，用来显示中文
font = font_manager.FontProperties(
    fname='../data/cnbook/SourceHanSansCN-Light.otf',
    size=10
)
labelFont = font_manager.FontProperties(
    fname='../data/cnbook/SourceHanSansCN-Light.otf',
    size=15
)
# 蓝色，作为点的颜色
mainColor = (91/255, 155/255, 213/255, 1)
# 灰色，作为文本的颜色
fontColor = (110/255, 110/255, 110/255, 1)

# 新建一个绘图窗口
fig = plt.figure()
# 设置坐标轴的最大值最小值
gap = 0.01
xMin = aggData['月消费（元）'].min()*(1-gap)
xMax = aggData['月消费（元）'].max()*(1+gap)
yMin = aggData['月流量（MB）'].min()*(1-gap)
yMax = aggData['月流量（MB）'].max()*(1+gap)

# 设置 x 轴和 y 轴的坐标轴范围
plt.xlim(xMin, xMax)
plt.ylim(yMin, yMax)

# 设置刻度，这里设置为空
plt.xticks([])
plt.yticks([])

# 绘制散点图
plt.scatter(
    aggData['月消费（元）'],
    aggData['月流量（MB）'],
    s=100, # 设置点的大小
    marker='o', # 设置点的样式
    color=mainColor # 设置点的颜色
)

# 设置坐标轴的标签
plt.xlabel(
    '人均月消费（元）',
    color=fontColor,
    fontproperties=labelFont
)
plt.ylabel(
    '人均月流量（MB）',
    color=fontColor,
    fontproperties=labelFont
)

# 绘制分割线
# 竖线
plt.vlines(
    x=data['月消费（元）'].mean(),
    ymin=yMin,
    ymax=yMax,
    linewidth=1,
    color=mainColor
)
# 横线
plt.hlines(
    y=data['月流量（MB）'].mean(),
    xmin=xMin,
    xmax=xMax,
    linewidth=1,
    color=mainColor
)

# 标记象限
plt.text(xMax-0.5, yMax-5, 'I', color=fontColor, fontsize=15)
plt.text(xMin, yMax-5, 'II', color=fontColor, fontsize=15)
plt.text(xMin, yMin, 'III', color=fontColor, fontsize=15)
plt.text(xMax-0.6, yMin, 'IV', color=fontColor, fontsize=15)

# 添加省标签
for i, r in aggData.iterrows():
    plt.text(
        r['月消费（元）'] + 0.25,
        r['月流量（MB）'] - 1,
        r['省份'],
        color=fontColor,
        fontproperties=font
    )
plt.show()
```


![png](/images/shuju/output_170_0.png)


### 相关分析

研究的是两个变量之间的相互关系，计算相关系数


```python
data = pd.read_csv('../data/cnbook/第五章/5.9 相关分析/相关分析.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>小区ID</th>
      <th>人口</th>
      <th>平均收入</th>
      <th>文盲率</th>
      <th>超市购物率</th>
      <th>网上购物率</th>
      <th>本科毕业率</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>3615</td>
      <td>3624</td>
      <td>2.1</td>
      <td>15.1</td>
      <td>84.9</td>
      <td>41.3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>365</td>
      <td>6315</td>
      <td>1.5</td>
      <td>11.3</td>
      <td>88.7</td>
      <td>66.7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>2212</td>
      <td>4530</td>
      <td>1.8</td>
      <td>7.8</td>
      <td>92.2</td>
      <td>58.1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>2110</td>
      <td>3378</td>
      <td>1.9</td>
      <td>10.1</td>
      <td>89.9</td>
      <td>39.9</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>21198</td>
      <td>5114</td>
      <td>1.1</td>
      <td>10.3</td>
      <td>89.7</td>
      <td>62.6</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 计算人口和文盲率的相关性
data['人口'].corr(data['文盲率'])
```




    0.10762237339473261




```python
# 计算 超市购物率、网上购物率、文盲率、人口 之间的相关性
data[['超市购物率', '网上购物率', '文盲率', '人口']].corr()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>超市购物率</th>
      <th>网上购物率</th>
      <th>文盲率</th>
      <th>人口</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>超市购物率</th>
      <td>1.000000</td>
      <td>-1.000000</td>
      <td>0.702975</td>
      <td>0.343643</td>
    </tr>
    <tr>
      <th>网上购物率</th>
      <td>-1.000000</td>
      <td>1.000000</td>
      <td>-0.702975</td>
      <td>-0.343643</td>
    </tr>
    <tr>
      <th>文盲率</th>
      <td>0.702975</td>
      <td>-0.702975</td>
      <td>1.000000</td>
      <td>0.107622</td>
    </tr>
    <tr>
      <th>人口</th>
      <td>0.343643</td>
      <td>-0.343643</td>
      <td>0.107622</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



### 回归分析

#### 简单线性回归分析

一元线性回归  
`Y = a + bX + e` e 为误差


```python
data = pd.read_csv('../data/cnbook/第五章/5.10.2 简单线性回归分析/线性回归.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>月份</th>
      <th>广告费用(万元)</th>
      <th>销售额(万元)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>201601</td>
      <td>29.7</td>
      <td>802.4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>201602</td>
      <td>25.7</td>
      <td>725.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>201603</td>
      <td>20.6</td>
      <td>620.5</td>
    </tr>
    <tr>
      <th>3</th>
      <td>201604</td>
      <td>17.0</td>
      <td>587.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>201605</td>
      <td>10.9</td>
      <td>505.0</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 1. 根据预测目标，确定自变量因变量


```python
# 自变量  
x = data[['广告费用(万元)']]
# 因变量
y = data[['销售额(万元)']]
```

##### 2. 绘制散点图，确定回归模型类型


```python
# 绘制散点图
data.plot('广告费用(万元)', '销售额(万元)', kind='scatter')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x11942fe10>




![png](/images/shuju/output_183_1.png)



```python
# 计算相关系数
data['广告费用(万元)'].corr(data['销售额(万元)'])
```




    0.9377748050928367



##### 3. 估计模型参数，建立回归模型

从散点图中可以看出两者有明显的线性关系，但是这些数据点不在一条直线上，只能尽可能拟合出一条直线，使得尽可能多的数据点落在
或者更加靠近这条拟合出来的直线上，也就是让它们拟合的误差尽量小，最小二乘法就是一个较好的计算方法。


```python
from sklearn.linear_model import LinearRegression
# 建立模型
lrModel = LinearRegression()
# 使用自变量 x 和因变量 y 训练模型
lrModel.fit(x, y)
# 查看 回归系数、截距
lrModel.coef_, lrModel.intercept_
```




    (array([[17.31989665]]), array([291.90315808]))



##### 4. 对回归模型进行检验

精度，就是用来表示点和回归模型的拟合程度的指标，一般使用判定系数 R^2 来度量回归模型拟合精度，也称拟合优度或决定系数，在
简单线性回归模型中，它的值等于 y 值和模型计算出来的 y' 值的相关系数 R 的平方，用来表示拟合得到的模型能够解释因变量变化的百分比
，R^2 越接近 1， 表示回归模型拟合效果越好。


```python
# 计算模型的精度
lrModel.score(x, y)
```




    0.8794215850669082



可以看到拟合效果还是非常不错的

##### 5. 利用回归模型进行预测


```python
# 生成预测需要的自变量
pX = pd.DataFrame({'广告费':[20]})
lrModel.predict(pX)
```




    array([[638.30109101]])



#### 多重线性回归分析

就是多个自变量的线性回归，分析方法和简单线性相似


```python
data = pd.read_csv('../data/cnbook/第五章/5.10.3 多重线性回归分析/线性回归.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>月份</th>
      <th>广告费用(万元)</th>
      <th>客流量(万人次)</th>
      <th>销售额(万元)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>201601</td>
      <td>29.7</td>
      <td>14.8</td>
      <td>802.4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>201602</td>
      <td>25.7</td>
      <td>12.6</td>
      <td>725.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>201603</td>
      <td>20.6</td>
      <td>9.9</td>
      <td>620.5</td>
    </tr>
    <tr>
      <th>3</th>
      <td>201604</td>
      <td>17.0</td>
      <td>7.6</td>
      <td>587.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>201605</td>
      <td>10.9</td>
      <td>5.1</td>
      <td>505.0</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



##### 根据预测目标，确定自变量和因变量


```python
# 定义自变量
x = data[['广告费用(万元)', '客流量(万人次)']]
# 定义因变量
y = data[['销售额(万元)']]
```

##### 绘制散点图，确定回归模型类型


```python
data.plot('广告费用(万元)', '销售额(万元)', kind='scatter')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x125e2fe10>




![png](/images/shuju/output_200_1.png)



```python
data['广告费用(万元)'].corr(data['销售额(万元)'])
```




    0.9377748050928367




```python
data.plot('客流量(万人次)', '销售额(万元)', kind='scatter')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x12654ac18>




![png](/images/shuju/output_202_1.png)



```python
data['客流量(万人次)'].corr(data['销售额(万元)'])
```




    0.9213105695705346



##### 估计模型参数，建立线性回归模型


```python
from sklearn.linear_model import LinearRegression
# 创建线性回归模型
lrModel = LinearRegression()
lrModel.fit(x, y)
# 查看 回归系数、截距
lrModel.coef_, lrModel.intercept_
```




    (array([[10.80453641, 13.97256004]]), array([285.60371828]))



##### 对回归模型进行检验


```python
lrModel.score(x, y)
```




    0.9026563046475117



拟合效果非常不错

##### 利用回归模型进行预测


```python
# 生成预测需要的自变量
pX = pd.DataFrame({
    '广告费':[20],
    '客流量':[5]
})
pX
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>广告费</th>
      <th>客流量</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>20</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 用模型进行预测
lrModel.predict(pX)
```




    array([[571.55724658]])



## 数据可视化

### 散点图


```python
data = pd.read_csv('../data/cnbook/第六章/6.2 散点图/散点图.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>日期</th>
      <th>购买用户数</th>
      <th>广告费用</th>
      <th>促销</th>
      <th>渠道数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2014/1/1</td>
      <td>2496</td>
      <td>9.14</td>
      <td>否</td>
      <td>6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2014/1/2</td>
      <td>2513</td>
      <td>9.47</td>
      <td>否</td>
      <td>8</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2014/1/3</td>
      <td>2228</td>
      <td>6.31</td>
      <td>是</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2014/1/4</td>
      <td>2336</td>
      <td>6.41</td>
      <td>否</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2014/1/5</td>
      <td>2508</td>
      <td>9.05</td>
      <td>是</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
import matplotlib
import matplotlib.pyplot as plt
plt.scatter(data['广告费用'], data['购买用户数'])
```




    <matplotlib.collections.PathCollection at 0x12652dd68>




![png](/images/shuju/output_215_1.png)


#### 颜色设置


```python
# 设置 rgb
mainColor = (91/255, 155/255, 213/255, 1)
plt.scatter(
    data['广告费用'], 
    data['购买用户数'],
    color=mainColor
)
```




    <matplotlib.collections.PathCollection at 0x129083080>




![png](/images/shuju/output_217_1.png)


#### 坐标轴设置


```python
# 创建字体，用来显示中文
font = matplotlib.font_manager.FontProperties(
    fname='../data/cnbook/SourceHanSansCN-Light.otf',
    size=10
)
# 设置坐标轴标签以及颜色和字体
plt.xlabel(
    '广告费用',
    color=mainColor,
    fontproperties=font
)
plt.ylabel(
    '购买用户数',
    color=mainColor,
    fontproperties=font
)
```




    Text(0, 0.5, '购买用户数')




![png](/images/shuju/output_219_1.png)



```python
# 设置刻度样式
plt.xticks(
    color=mainColor,
    fontproperties=font
)
plt.yticks(
    color=mainColor,
    fontproperties=font
)
```




    (array([0. , 0.2, 0.4, 0.6, 0.8, 1. ]), <a list of 6 Text yticklabel objects>)




![png](/images/shuju/output_220_1.png)


#### 散点样式设置


```python
# 打开一个新的绘图窗口
plt.figure()
# 粉色，作为促销的点的颜色
pinkColor = (255/255, 0/255, 102/255, 1)
# 蓝色，作为不促销的点的颜色
blueColor = (91/255, 155/255, 213/255, 1)
# 绘制促销的点
plt.scatter(
    data[data['促销'] == '是']['广告费用'],
    data[data['促销'] == '是']['购买用户数'],
    color=pinkColor,
    marker='o' # 点样式
)
# 绘制不促销的点
plt.scatter(
    data[data['促销'] == '否']['广告费用'],
    data[data['促销'] == '否']['购买用户数'],
    color=blueColor,
    marker='x' # 点样式
)
```




    <matplotlib.collections.PathCollection at 0x1291f04a8>




![png](/images/shuju/output_222_1.png)


#### 添加图例


```python
plt.legend(labels=['促销', '不促销'], prop=font)
```




    <matplotlib.legend.Legend at 0x129474a90>




![png](/images/shuju/output_224_1.png)


#### 完整绘图示例


```python
# 打开一个新的绘图窗口
plt.figure()
# 创建字体，用来显示中文
font = matplotlib.font_manager.FontProperties(
    fname='../data/cnbook/SourceHanSansCN-Light.otf',
    size=10
)
# 粉色，作为促销的点的颜色
pinkColor = (255/255, 0/255, 102/255, 1)
# 蓝色，作为不促销的点的颜色
blueColor = (91/255, 155/255, 213/255, 1)
# 绘制促销的点
plt.scatter(
    data[data['促销'] == '是']['广告费用'],
    data[data['促销'] == '是']['购买用户数'],
    color=pinkColor,
    marker='o' # 点样式
)
# 绘制不促销的点
plt.scatter(
    data[data['促销'] == '否']['广告费用'],
    data[data['促销'] == '否']['购买用户数'],
    color=blueColor,
    marker='x' # 点样式
)
# 设置坐标轴标签以及颜色和字体
plt.xlabel(
    '广告费用',
    color=mainColor,
    fontproperties=font
)
plt.ylabel(
    '购买用户数',
    color=mainColor,
    fontproperties=font
)
# 设置刻度样式
plt.xticks(
    color=mainColor,
    fontproperties=font
)
plt.yticks(
    color=mainColor,
    fontproperties=font
)
# 添加图例
plt.legend(labels=['促销', '不促销'], prop=font)
```




    <matplotlib.legend.Legend at 0x12951bc88>




![png](/images/shuju/output_226_1.png)


### 矩阵图

参考之前的矩阵分析绘图部分

### 折线图


```python
data = pd.read_csv('../data/cnbook/第六章/6.4 折线图/折线图.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>reg_date</th>
      <th>id_num</th>
      <th>gender</th>
      <th>birthday</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>109899</td>
      <td>2011-02-01</td>
      <td>35042519920219007J</td>
      <td>男</td>
      <td>1992/2/19</td>
    </tr>
    <tr>
      <th>1</th>
      <td>109903</td>
      <td>2011-02-01</td>
      <td>43048119891223411D</td>
      <td>男</td>
      <td>1989/12/23</td>
    </tr>
    <tr>
      <th>2</th>
      <td>109904</td>
      <td>2011-02-01</td>
      <td>42010219880201313H</td>
      <td>男</td>
      <td>1988/2/1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>109905</td>
      <td>2011-02-01</td>
      <td>44030619840213001E</td>
      <td>男</td>
      <td>1984/2/13</td>
    </tr>
    <tr>
      <th>4</th>
      <td>109906</td>
      <td>2011-02-01</td>
      <td>43070219870502103H</td>
      <td>男</td>
      <td>1987/5/2</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
data['reg_date'] = pd.to_datetime(
    data['reg_date']
)

# 按照注册日期进行分组，按照 id 列进行计数统计
ga =data.groupby(
    by='reg_date',
    as_index=False
)['id'].agg('count')
ga.columns = ['注册日期', '注册用户数']
ga.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>注册日期</th>
      <th>注册用户数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2011-02-01</td>
      <td>282</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2011-02-02</td>
      <td>272</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2011-02-03</td>
      <td>264</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2011-02-04</td>
      <td>256</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2011-02-05</td>
      <td>256</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
import matplotlib
from matplotlib import pyplot as plt
mainColor = (91/255, 155/255, 213/255, 1)
# 坐标轴刻度的字体
font = matplotlib.font_manager.FontProperties(
    fname='../data/cnbook/SourceHanSansCN-Light.otf',
    size=10
)
# 坐标轴标签的字体
labelFont = matplotlib.font_manager.FontProperties(
    fname='../data/cnbook/SourceHanSansCN-Light.otf',
    size=20
)
# 设置 y 轴显示的范围
plt.ylim(0, 500)
# 设置标题
plt.title('注册用户数', color=mainColor, fontproperties=labelFont)
# 设置 x、y 轴的标签
plt.xlabel('注册日期', color=mainColor, fontproperties=labelFont)
plt.xlabel('注册用户数', color=mainColor, fontproperties=labelFont)

# 设置坐标轴刻度样式
plt.xticks(color=mainColor, fontproperties=font)
plt.yticks(color=mainColor, fontproperties=font)

# 绘制折线图 lw 设置线的宽度
plt.plot(ga['注册日期'], ga['注册用户数'], '-', lw=5, color=mainColor)
```




    [<matplotlib.lines.Line2D at 0x12a557438>]




![png](/images/shuju/output_232_1.png)


### 饼图


```python
ga = pd.Series({'男':54785, '女':4316})
```


```python
ga
```




    男    54785
    女     4316
    dtype: int64




```python
import matplotlib
from matplotlib import pyplot as plt
femaleColor = (91/255, 155/255, 213/255, 0.5)
maleColor = (91/255, 155/255, 213/255, 1)
# 坐标轴刻度的字体
font = matplotlib.font_manager.FontProperties(
    fname='../data/cnbook/SourceHanSansCN-Light.otf',
    size=10
)
# 设置为圆形的饼图
plt.axis('equal')
plt.pie(
    ga,
    labels=['男', '女'],
    colors=[maleColor, femaleColor],
    autopct='%.1f%%', # 设置百分号
    textprops={'fontproperties':font}
)
```




    ([<matplotlib.patches.Wedge at 0x1484e9748>,
      <matplotlib.patches.Wedge at 0x1484e9e48>],
     [Text(-1.0711775990020538, 0.25015705346081196, '男'),
      Text(1.0711775814360058, -0.2501571286789748, '女')],
     [Text(-0.5842786903647565, 0.1364493018877156, '92.7%'),
      Text(0.5842786807832758, -0.13644934291580443, '7.3%')])




![png](/images/shuju/output_236_1.png)


### 柱状图


```python
data = pd.read_csv('../data/cnbook/第六章/6.6 柱形图/柱形图.csv')
data.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>号码</th>
      <th>省份</th>
      <th>手机品牌</th>
      <th>通信品牌</th>
      <th>手机操作系统</th>
      <th>月消费（元）</th>
      <th>月流量（MB）</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>166547114238</td>
      <td>河北</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>298.9</td>
      <td>318.6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>166423353436</td>
      <td>河南</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>272.8</td>
      <td>1385.9</td>
    </tr>
    <tr>
      <th>2</th>
      <td>166556915853</td>
      <td>福建</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>68.8</td>
      <td>443.6</td>
    </tr>
    <tr>
      <th>3</th>
      <td>166434728749</td>
      <td>湖南</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>4.6</td>
      <td>817.3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>166544742252</td>
      <td>北京</td>
      <td>HTC</td>
      <td>神州行</td>
      <td>Android</td>
      <td>113.2</td>
      <td>837.4</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
# 统计每个品牌的消费总额
result = data.groupby(
    by='手机品牌',
    as_index=False
)['月消费（元）'].agg('sum')
result.head()
```



{% raw %}
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>手机品牌</th>
      <th>月消费（元）</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>HTC</td>
      <td>458171.6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>三星</td>
      <td>1009290.8</td>
    </tr>
    <tr>
      <th>2</th>
      <td>华为</td>
      <td>25696.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>摩托罗拉</td>
      <td>117623.1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>联想</td>
      <td>89443.7</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}




```python
import matplotlib
from matplotlib import pyplot as plt

plt.figure()
# 生成 x 轴的位置, 赋值给 index
index = [1, 2, 3, 4, 5, 6, 7, 8]
# 配置颜色
mainColor = (91/255, 155/255, 213/255, 1)
# 设置字体
font = matplotlib.font_manager.FontProperties(
    fname='../data/cnbook/SourceHanSansCN-Light.otf',
    size=10
)
# 排序
sgb = result.sort_values(by='月消费（元）', ascending=False)
plt.bar(
    index,
    sgb['月消费（元）'],
    color=mainColor
)
# 设置 x 轴刻度
plt.xticks(index, sgb.手机品牌, fontproperties=font)
```




    ([<matplotlib.axis.XTick at 0x148504470>,
      <matplotlib.axis.XTick at 0x129caaa20>,
      <matplotlib.axis.XTick at 0x129caada0>,
      <matplotlib.axis.XTick at 0x129cce630>,
      <matplotlib.axis.XTick at 0x1484fcac8>,
      <matplotlib.axis.XTick at 0x129cce828>,
      <matplotlib.axis.XTick at 0x129cd1390>,
      <matplotlib.axis.XTick at 0x129cd4198>],
     <a list of 8 Text xticklabel objects>)




![png](/images/shuju/output_240_1.png)


### 条形图


```python
import matplotlib
from matplotlib import pyplot as plt

plt.figure()
# 生成 y 轴的位置, 赋值给 index
index = [1, 2, 3, 4, 5, 6, 7, 8]
# 配置颜色
mainColor = (91/255, 155/255, 213/255, 1)
# 设置字体
font = matplotlib.font_manager.FontProperties(
    fname='../data/cnbook/SourceHanSansCN-Light.otf',
    size=10
)
# 排序
sgb = result.sort_values(by='月消费（元）', ascending=True)
plt.barh(
    index,
    sgb['月消费（元）'],
    color=mainColor
)
# 设置 x 轴刻度
plt.yticks(index, sgb.手机品牌, fontproperties=font)
```




    ([<matplotlib.axis.YTick at 0x14872aeb8>,
      <matplotlib.axis.YTick at 0x14872a828>,
      <matplotlib.axis.YTick at 0x14873beb8>,
      <matplotlib.axis.YTick at 0x148761940>,
      <matplotlib.axis.YTick at 0x148761e10>,
      <matplotlib.axis.YTick at 0x1487cc320>,
      <matplotlib.axis.YTick at 0x1487cc7f0>,
      <matplotlib.axis.YTick at 0x148761a20>],
     <a list of 8 Text yticklabel objects>)




![png](/images/shuju/output_242_1.png)



```python

```
