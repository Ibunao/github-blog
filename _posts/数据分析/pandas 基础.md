---
title: pandas 基础
date: 2019-05-07 20:20:02
tags:
    - pandas  
categories:   
    - 数据分析  
    - pandas  
---

[《利用 python 进行数据分析*第二版》](https://seancheney.gitbook.io/python-for-data-analysis-2nd/)


```python
import pandas as pd
from pandas import Series, DataFrame
import numpy as np
from numpy import nan as NA
import sqlite3
import re
```

# 基础部分

## 数据结构

### Series 数据结构

Series 数据结构就是列表和字典的结合体，下面看一下具体演示


```python
# 创建
obj = pd.Series([4, 7, -5, 3])
obj
```




    0    4
    1    7
    2   -5
    3    3
    dtype: int64

<!-- more -->


```python
# 获取索引
obj.index
```




    RangeIndex(start=0, stop=4, step=1)




```python
# 获取值
obj.values
```




    array([ 4,  7, -5,  3], dtype=int64)




```python
# 创建的同时制定索引
obj2 = pd.Series([4, 7, -5, 3], index=['d', 'b', 'a', 'c'])
obj2
```




    d    4
    b    7
    a   -5
    c    3
    dtype: int64




```python
obj2.index
```




    Index(['d', 'b', 'a', 'c'], dtype='object')




```python
obj2.values
```




    array([ 4,  7, -5,  3], dtype=int64)




```python
# 通过字典进行创建
sdata = {'Ohio': 35000, 'Texas': 71000, 'Oregon': 16000, 'Utah': 5000}
obj3 = pd.Series(sdata)
obj3
```




    Ohio      35000
    Texas     71000
    Oregon    16000
    Utah       5000
    dtype: int64



可以传入排好序的字典的键以改变顺序  
sdata 中跟 states 索引相匹配的那3个值会被找出来并放到相应的位置上，但由于"California"所对应的 sdata 值找不到，所以其结果就为 NaN（即“非数字”（not a number），在 pandas 中，它用于表示缺失或 NA 值）。因为‘Utah’不在 states 中，它被从结果中除去。


```python
states = ['California', 'Ohio', 'Oregon', 'Texas']
obj4 = pd.Series(sdata, index=states)
obj4
```




    California        NaN
    Ohio          35000.0
    Oregon        16000.0
    Texas         71000.0
    dtype: float64




```python
# 判断索引是否存在
'ding' in obj4
```




    False




```python
'Ohio' in obj4
```




    True



Series 对象本身及其索引都有一个 name 属性，该属性跟pandas其他的关键功能关系非常密切：


```python
obj4.name = 'population'
obj4.index.name = 'state'
obj4
```




    state
    California        NaN
    Ohio          35000.0
    Oregon        16000.0
    Texas         71000.0
    Name: population, dtype: float64



Series 的索引可以通过赋值的方式就地修改


```python
obj4.index = ['Bob', 'Steve', 'Jeff', 'Ryan']
obj4
```




    Bob          NaN
    Steve    35000.0
    Jeff     16000.0
    Ryan     71000.0
    Name: population, dtype: float64



### DataFrame 数据结构

DataFrame是一个表格型的数据结构，它含有一组有序的列，每列可以是不同的值类型（数值、字符串、布尔值等）。DataFrame既有行索引也有列索引，它可以被看做由Series组成的字典（共用同一个索引）。DataFrame中的数据是以一个或多个二维块存放的（而不是列表、字典或别的一维数据结构）。

columns 相当于 sql 中的字段， index 相当于 sql 中的索引

建DataFrame的办法有很多，最常用的一种是直接传入一个由等长列表或NumPy数组组成的字典


```python
data = {'state': ['Ohio', 'Ohio', 'Ohio', 'Nevada', 'Nevada', 'Nevada'],
        'year': [2000, 2001, 2002, 2001, 2002, 2003],
        'pop': [1.5, 1.7, 3.6, 2.4, 2.9, 3.2]}
frame = pd.DataFrame(data)
frame
```




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
      <th>state</th>
      <th>year</th>
      <th>pop</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Ohio</td>
      <td>2000</td>
      <td>1.5</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Ohio</td>
      <td>2001</td>
      <td>1.7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Ohio</td>
      <td>2002</td>
      <td>3.6</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Nevada</td>
      <td>2001</td>
      <td>2.4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Nevada</td>
      <td>2002</td>
      <td>2.9</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Nevada</td>
      <td>2003</td>
      <td>3.2</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 读取前 5 行，数据量大的时候非常有用
frame.head()
```




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
      <th>state</th>
      <th>year</th>
      <th>pop</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Ohio</td>
      <td>2000</td>
      <td>1.5</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Ohio</td>
      <td>2001</td>
      <td>1.7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Ohio</td>
      <td>2002</td>
      <td>3.6</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Nevada</td>
      <td>2001</td>
      <td>2.4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Nevada</td>
      <td>2002</td>
      <td>2.9</td>
    </tr>
  </tbody>
</table>
</div>



如果指定了列序列，则DataFrame的列就会按照指定顺序进行排列


```python
# 制定列顺序
pd.DataFrame(data, columns=['year', 'state', 'pop'])
```




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
      <th>year</th>
      <th>state</th>
      <th>pop</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2000</td>
      <td>Ohio</td>
      <td>1.5</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2001</td>
      <td>Ohio</td>
      <td>1.7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2002</td>
      <td>Ohio</td>
      <td>3.6</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2001</td>
      <td>Nevada</td>
      <td>2.4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2002</td>
      <td>Nevada</td>
      <td>2.9</td>
    </tr>
    <tr>
      <th>5</th>
      <td>2003</td>
      <td>Nevada</td>
      <td>3.2</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 同时制定 列名 和 索引名
frame2 = pd.DataFrame(data, columns=['year', 'state', 'pop', 'debt'],index=['one', 'two', 'three', 'four', 'five', 'six'])
frame2
```




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
      <th>year</th>
      <th>state</th>
      <th>pop</th>
      <th>debt</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>2000</td>
      <td>Ohio</td>
      <td>1.5</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>two</th>
      <td>2001</td>
      <td>Ohio</td>
      <td>1.7</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>three</th>
      <td>2002</td>
      <td>Ohio</td>
      <td>3.6</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>four</th>
      <td>2001</td>
      <td>Nevada</td>
      <td>2.4</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>five</th>
      <td>2002</td>
      <td>Nevada</td>
      <td>2.9</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>six</th>
      <td>2003</td>
      <td>Nevada</td>
      <td>3.2</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 获取 列名
frame2.columns
```




    Index(['year', 'state', 'pop', 'debt'], dtype='object')




```python
# 获取某一列
frame2['state']
```




    one        Ohio
    two        Ohio
    three      Ohio
    four     Nevada
    five     Nevada
    six      Nevada
    Name: state, dtype: object




```python
frame2.state
```




    one        Ohio
    two        Ohio
    three      Ohio
    four     Nevada
    five     Nevada
    six      Nevada
    Name: state, dtype: object




```python
# 选取某一行
frame2.loc['one']
```




    year     2000
    state    Ohio
    pop       1.5
    debt      NaN
    Name: one, dtype: object




```python
# 赋值
frame2['debt'] = 16.5
frame2
```




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
      <th>year</th>
      <th>state</th>
      <th>pop</th>
      <th>debt</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>2000</td>
      <td>Ohio</td>
      <td>1.5</td>
      <td>16.5</td>
    </tr>
    <tr>
      <th>two</th>
      <td>2001</td>
      <td>Ohio</td>
      <td>1.7</td>
      <td>16.5</td>
    </tr>
    <tr>
      <th>three</th>
      <td>2002</td>
      <td>Ohio</td>
      <td>3.6</td>
      <td>16.5</td>
    </tr>
    <tr>
      <th>four</th>
      <td>2001</td>
      <td>Nevada</td>
      <td>2.4</td>
      <td>16.5</td>
    </tr>
    <tr>
      <th>five</th>
      <td>2002</td>
      <td>Nevada</td>
      <td>2.9</td>
      <td>16.5</td>
    </tr>
    <tr>
      <th>six</th>
      <td>2003</td>
      <td>Nevada</td>
      <td>3.2</td>
      <td>16.5</td>
    </tr>
  </tbody>
</table>
</div>



将列表或数组赋值给某个列时，其长度必须跟DataFrame的长度相匹配。如果赋值的是一个Series，就会精确匹配DataFrame的索引，所有的空位都将被填上缺失值：


```python
val = pd.Series([-1.2, -1.5, -1.7], index=['two', 'four', 'five'])
frame2['debt'] = val
frame2
```




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
      <th>year</th>
      <th>state</th>
      <th>pop</th>
      <th>debt</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>2000</td>
      <td>Ohio</td>
      <td>1.5</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>two</th>
      <td>2001</td>
      <td>Ohio</td>
      <td>1.7</td>
      <td>-1.2</td>
    </tr>
    <tr>
      <th>three</th>
      <td>2002</td>
      <td>Ohio</td>
      <td>3.6</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>four</th>
      <td>2001</td>
      <td>Nevada</td>
      <td>2.4</td>
      <td>-1.5</td>
    </tr>
    <tr>
      <th>five</th>
      <td>2002</td>
      <td>Nevada</td>
      <td>2.9</td>
      <td>-1.7</td>
    </tr>
    <tr>
      <th>six</th>
      <td>2003</td>
      <td>Nevada</td>
      <td>3.2</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



为不存在的列赋值会创建出一个新列。关键字del用于删除列。


```python
# 创建一个新列
frame2['test'] = frame2.state == 'Ohio'
frame2
```




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
      <th>year</th>
      <th>state</th>
      <th>pop</th>
      <th>debt</th>
      <th>test</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>2000</td>
      <td>Ohio</td>
      <td>1.5</td>
      <td>NaN</td>
      <td>True</td>
    </tr>
    <tr>
      <th>two</th>
      <td>2001</td>
      <td>Ohio</td>
      <td>1.7</td>
      <td>-1.2</td>
      <td>True</td>
    </tr>
    <tr>
      <th>three</th>
      <td>2002</td>
      <td>Ohio</td>
      <td>3.6</td>
      <td>NaN</td>
      <td>True</td>
    </tr>
    <tr>
      <th>four</th>
      <td>2001</td>
      <td>Nevada</td>
      <td>2.4</td>
      <td>-1.5</td>
      <td>False</td>
    </tr>
    <tr>
      <th>five</th>
      <td>2002</td>
      <td>Nevada</td>
      <td>2.9</td>
      <td>-1.7</td>
      <td>False</td>
    </tr>
    <tr>
      <th>six</th>
      <td>2003</td>
      <td>Nevada</td>
      <td>3.2</td>
      <td>NaN</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 删除一列
del frame2['test']
frame2
```




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
      <th>year</th>
      <th>state</th>
      <th>pop</th>
      <th>debt</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>2000</td>
      <td>Ohio</td>
      <td>1.5</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>two</th>
      <td>2001</td>
      <td>Ohio</td>
      <td>1.7</td>
      <td>-1.2</td>
    </tr>
    <tr>
      <th>three</th>
      <td>2002</td>
      <td>Ohio</td>
      <td>3.6</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>four</th>
      <td>2001</td>
      <td>Nevada</td>
      <td>2.4</td>
      <td>-1.5</td>
    </tr>
    <tr>
      <th>five</th>
      <td>2002</td>
      <td>Nevada</td>
      <td>2.9</td>
      <td>-1.7</td>
    </tr>
    <tr>
      <th>six</th>
      <td>2003</td>
      <td>Nevada</td>
      <td>3.2</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



另一种常见的数据形式是嵌套字典：  
如果嵌套字典传给DataFrame，pandas就会被解释为：外层字典的键作为列，内层键则作为行索引：  


```python
pop = {'Nevada': {2001: 2.4, 2002: 2.9}, 'Ohio': {2000: 1.5, 2001: 1.7, 2002: 3.6}}
frame3 = pd.DataFrame(pop)
frame3
```




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
      <th>Nevada</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000</th>
      <td>NaN</td>
      <td>1.5</td>
    </tr>
    <tr>
      <th>2001</th>
      <td>2.4</td>
      <td>1.7</td>
    </tr>
    <tr>
      <th>2002</th>
      <td>2.9</td>
      <td>3.6</td>
    </tr>
  </tbody>
</table>
</div>



如果设置了 DataFrame 的 index 和 columns 的 name 属性，则这些信息也会被显示出来：


```python
frame3.index.name = 'year'; frame3.columns.name = 'state'
frame3
```




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
      <th>state</th>
      <th>Nevada</th>
      <th>Ohio</th>
    </tr>
    <tr>
      <th>year</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000</th>
      <td>NaN</td>
      <td>1.5</td>
    </tr>
    <tr>
      <th>2001</th>
      <td>2.4</td>
      <td>1.7</td>
    </tr>
    <tr>
      <th>2002</th>
      <td>2.9</td>
      <td>3.6</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 获取值 
frame3.values
```




    array([[nan, 1.5],
           [2.4, 1.7],
           [2.9, 3.6]])



### 索引对象

pandas的索引对象负责管理轴标签和其他元数据（比如轴名称等）。构建Series或DataFrame时，所用到的任何数组或其他序列的标签都会被转换成一个Index：   
DataFrame 的 index 和 columns 都是索引对象  


```python
obj = pd.Series(range(3), index=['a', 'b', 'c'])
obj.index
```




    Index(['a', 'b', 'c'], dtype='object')




```python
frame3
```




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
      <th>state</th>
      <th>Nevada</th>
      <th>Ohio</th>
    </tr>
    <tr>
      <th>year</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000</th>
      <td>NaN</td>
      <td>1.5</td>
    </tr>
    <tr>
      <th>2001</th>
      <td>2.4</td>
      <td>1.7</td>
    </tr>
    <tr>
      <th>2002</th>
      <td>2.9</td>
      <td>3.6</td>
    </tr>
  </tbody>
</table>
</div>




```python
frame3.columns
```




    Index(['Nevada', 'Ohio'], dtype='object', name='state')




```python
frame3.index
```




    Int64Index([2000, 2001, 2002], dtype='int64', name='year')



与python的集合不同，pandas的Index可以包含重复的标签：


```python
dup_labels = pd.Index(['foo', 'foo', 'bar', 'bar'])
dup_labels
```




    Index(['foo', 'foo', 'bar', 'bar'], dtype='object')



Index 索引对象有一些方法和属性，不怎么用 


```python
dup_labels.unique()
```




    Index(['foo', 'bar'], dtype='object')



![Index 方法和属性](http://upload-images.jianshu.io/upload_images/7178691-5499d14f0e2cd639.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

## 基本功能

### 重新索引 reindex

pandas对象的一个重要方法是reindex，其作用是创建一个新对象，它的数据符合新的索引。


```python
obj = pd.Series([4.5, 7.2, -5.3, 3.6], index=['d', 'b', 'a', 'c'])
obj
```




    d    4.5
    b    7.2
    a   -5.3
    c    3.6
    dtype: float64



用该Series的reindex将会根据新索引进行重排。如果某个索引值当前不存在，就引入缺失值：


```python
obj2 = obj.reindex(['a', 'b', 'c', 'd', 'e'])
obj2
```




    a   -5.3
    b    7.2
    c    3.6
    d    4.5
    e    NaN
    dtype: float64



重新索引时可能需要做一些插值处理。method选项即可达到此目的，例如，使用 ffill 可以实现前向值填充


```python
obj3 = pd.Series(['blue', 'purple', 'yellow'], index=[0, 2, 4])
obj3
```




    0      blue
    2    purple
    4    yellow
    dtype: object




```python
obj3.reindex(range(6), method='ffill')
```




    0      blue
    1      blue
    2    purple
    3    purple
    4    yellow
    5    yellow
    dtype: object



借助 DataFrame，reindex 可以修改（行）索引和列。只传递一个序列时，会重新索引结果的行：


```python
frame = pd.DataFrame(np.arange(9).reshape((3, 3)), index=['a', 'c', 'd'], columns=['Ohio', 'Texas', 'California'])
frame
```




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
      <th>Ohio</th>
      <th>Texas</th>
      <th>California</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>c</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th>d</th>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 重建行索引  
frame.reindex(['a', 'b', 'c', 'd'])
```




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
      <th>Ohio</th>
      <th>Texas</th>
      <th>California</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.0</td>
      <td>1.0</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>b</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>c</th>
      <td>3.0</td>
      <td>4.0</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>d</th>
      <td>6.0</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 重建列索引
frame.reindex(columns = ['Texas', 'Utah', 'California'])
```




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
      <th>Texas</th>
      <th>Utah</th>
      <th>California</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>1</td>
      <td>NaN</td>
      <td>2</td>
    </tr>
    <tr>
      <th>c</th>
      <td>4</td>
      <td>NaN</td>
      <td>5</td>
    </tr>
    <tr>
      <th>d</th>
      <td>7</td>
      <td>NaN</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>



reindex函数的各参数及说明  
![](http://upload-images.jianshu.io/upload_images/7178691-efa3dbd4b83c61ec.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### 丢弃指定轴上的项 drop

丢弃某条轴上的一个或多个项很简单，只要有一个索引数组或列表即可。由于需要执行一些数据整理和集合逻辑，所以drop方法返回的是一个在指定轴上删除了指定值的新对象：


```python
obj = pd.Series(np.arange(5.), index=['a', 'b', 'c', 'd', 'e'])
obj
```




    a    0.0
    b    1.0
    c    2.0
    d    3.0
    e    4.0
    dtype: float64




```python
obj.drop('c')
```




    a    0.0
    b    1.0
    d    3.0
    e    4.0
    dtype: float64



对于DataFrame，可以删除任意轴上的索引值。 drop 默认会从行标签（axis 0）删除值(删除行), 通过传递 `axis=1` 或 `axis='columns'` 可以删除列的值


```python
data = pd.DataFrame(np.arange(16).reshape((4, 4)), index=['Ohio', 'Colorado', 'Utah', 'New York'], columns=['one', 'two', 'three', 'four'])
data
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
    <tr>
      <th>New York</th>
      <td>12</td>
      <td>13</td>
      <td>14</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.drop(['Ohio', 'Utah'])
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Colorado</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>New York</th>
      <td>12</td>
      <td>13</td>
      <td>14</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.drop('two', axis=1)
```




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
      <th>one</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>4</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>8</td>
      <td>10</td>
      <td>11</td>
    </tr>
    <tr>
      <th>New York</th>
      <td>12</td>
      <td>14</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>



许多函数，如drop，会修改Series或DataFrame的大小或形状，可以就地修改对象，不会返回新的对象：


```python
obj.drop('c', inplace=True)
```


```python
obj
```




    a    0.0
    b    1.0
    d    3.0
    e    4.0
    dtype: float64



### 索引、选取和过滤

Series索引的工作方式类似于NumPy数组的索引，只不过Series的索引值不只是整数。  


```python
obj = pd.Series(np.arange(4.), index=['a', 'b', 'c', 'd'])
obj
```




    a    0.0
    b    1.0
    c    2.0
    d    3.0
    dtype: float64




```python
obj['a']
```




    0.0




```python
obj[0]
```




    0.0




```python
obj[:2]
```




    a    0.0
    b    1.0
    dtype: float64




```python
# 利用标签的切片运算与普通的Python切片运算不同，其末端是包含的：
obj['a':'c']
```




    a    0.0
    b    1.0
    c    2.0
    dtype: float64




```python
obj[['a', 'b', 'd']]
```




    a    0.0
    b    1.0
    d    3.0
    dtype: float64




```python
obj[[1, 3]]
```




    b    1.0
    d    3.0
    dtype: float64




```python
obj[obj < 2]
```




    a    0.0
    b    1.0
    dtype: float64



用一个值或序列对DataFrame进行索引其实就是获取一个或多个列：  
用切片 `[:]` 切的是行  


```python
data = pd.DataFrame(np.arange(16).reshape((4, 4)), index=['Ohio', 'Colorado', 'Utah', 'New York'], columns=['one', 'two', 'three', 'four'])
data
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
    <tr>
      <th>New York</th>
      <td>12</td>
      <td>13</td>
      <td>14</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>




```python
data['two']
```




    Ohio         1
    Colorado     5
    Utah         9
    New York    13
    Name: two, dtype: int32




```python
data[['three', 'one']]
```




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
      <th>three</th>
      <th>one</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>6</td>
      <td>4</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>10</td>
      <td>8</td>
    </tr>
    <tr>
      <th>New York</th>
      <td>14</td>
      <td>12</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 切行
data["Ohio":"Utah"]
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>




```python
data[:2]
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>



### 用 loc 和 iloc 进行选取

特殊的标签运算符loc和iloc。它们可以让你用类似NumPy的标记，使用轴标签（loc）或整数索引（iloc），从DataFrame选择行和列的子集。  


```python
data
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
    <tr>
      <th>New York</th>
      <td>12</td>
      <td>13</td>
      <td>14</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 通过标签进行选择
data.loc['Ohio', ['one', 'two']]
```




    one    0
    two    1
    Name: Ohio, dtype: int32




```python
data.loc['Ohio':'Utah', ['one', 'two']]
```




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
      <th>one</th>
      <th>two</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>8</td>
      <td>9</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 通过 整数 进行选择
data.iloc[2, [0, 1]]
```




    one    8
    two    9
    Name: Utah, dtype: int32




```python
data.iloc[2:4, [0, 1]]
```




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
      <th>one</th>
      <th>two</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Utah</th>
      <td>8</td>
      <td>9</td>
    </tr>
    <tr>
      <th>New York</th>
      <td>12</td>
      <td>13</td>
    </tr>
  </tbody>
</table>
</div>



pandas可以勉强进行整数索引，但是会导致小bug。我们有包含0,1,2的索引，但这会引起歧义，为了进行统一，如果轴索引含有整数，数据选取总会使用标签。为了更准确，请使用loc（标签）或iloc（整数）：


```python
ser = pd.Series(np.arange(3.))
ser
```




    0    0.0
    1    1.0
    2    2.0
    dtype: float64



```
# 下面这个将会出错，因为整数索引中没有 -1 这个值, 不知道基于位置索引还是整数索引，导致歧义
ser[-1]
```

对于非整数索引，不会产生歧义


```python
ser2 = pd.Series(np.arange(3.), index=['a', 'b', 'c'])
ser2[-1]
```




    2.0



### 算术运算和数据对齐、在算术方法中填充值

pandas最重要的一个功能是，它可以对不同索引的对象进行算术运算。在将对象相加时，如果存在不同的索引对，则结果的索引就是该索引对的并集。对于有数据库经验的用户，这就像在索引标签上进行自动外连接。


```python
s1 = pd.Series([7.3, -2.5, 3.4, 1.5], index=['a', 'c', 'd', 'e'])
s2 = pd.Series([-2.1, 3.6, -1.5, 4, 3.1],index=['a', 'c', 'e', 'f', 'g'])
s1
```




    a    7.3
    c   -2.5
    d    3.4
    e    1.5
    dtype: float64




```python
s2
```




    a   -2.1
    c    3.6
    e   -1.5
    f    4.0
    g    3.1
    dtype: float64




```python
# 索引对齐相加，自动的数据对齐操作在不重叠的索引处引入了NA值
s1 + s2
```




    a    5.2
    c    1.1
    d    NaN
    e    0.0
    f    NaN
    g    NaN
    dtype: float64



对于DataFrame，对齐操作会同时发生在行和列上


```python
df1 = pd.DataFrame(np.arange(9.).reshape((3, 3)), columns=list('bcd'), index=['Ohio', 'Texas', 'Colorado'])
df2 = pd.DataFrame(np.arange(12.).reshape((4, 3)), columns=list('bde'), index=['Utah', 'Ohio', 'Texas', 'Oregon'])
df1
```




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
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0.0</td>
      <td>1.0</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>3.0</td>
      <td>4.0</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>6.0</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
df2
```




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
      <th>b</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Utah</th>
      <td>0.0</td>
      <td>1.0</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>Ohio</th>
      <td>3.0</td>
      <td>4.0</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>6.0</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>Oregon</th>
      <td>9.0</td>
      <td>10.0</td>
      <td>11.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
df1 + df2
```




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
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Colorado</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>Ohio</th>
      <td>3.0</td>
      <td>NaN</td>
      <td>6.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>Oregon</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>9.0</td>
      <td>NaN</td>
      <td>12.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



在对不同索引的对象进行算术运算时，你可能希望当一个对象中某个轴标签在另一个对象中找不到时填充一个特殊值（比如0）


```python
df1.add(df2, fill_value=0)
```




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
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Colorado</th>
      <td>6.0</td>
      <td>7.0</td>
      <td>8.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>Ohio</th>
      <td>3.0</td>
      <td>1.0</td>
      <td>6.0</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>Oregon</th>
      <td>9.0</td>
      <td>NaN</td>
      <td>10.0</td>
      <td>11.0</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>9.0</td>
      <td>4.0</td>
      <td>12.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>0.0</td>
      <td>NaN</td>
      <td>1.0</td>
      <td>2.0</td>
    </tr>
  </tbody>
</table>
</div>



其他算数方法：  
以字母r开头，它会翻转参数。  
![](http://upload-images.jianshu.io/upload_images/7178691-16857a1021f98d1f.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)


```python
test1 = Series([1, 1, 1])
test2 = Series([2, 2, 2])
test1.div(test2)
```




    0    0.5
    1    0.5
    2    0.5
    dtype: float64




```python
test1.rdiv(test2)
```




    0    2.0
    1    2.0
    2    2.0
    dtype: float64



### DataFrame和Series之间的运算

DataFrame和Series之间的运算,默认是横向进行广播的，如果需要在列上进行广播，就必须使用算数方法计算指定 `axis='index'`


```python
frame = pd.DataFrame(np.arange(12.).reshape((4, 3)), columns=list('bde'), index=['Utah', 'Ohio', 'Texas', 'Oregon'])
frame
```




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
      <th>b</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Utah</th>
      <td>0.0</td>
      <td>1.0</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>Ohio</th>
      <td>3.0</td>
      <td>4.0</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>6.0</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>Oregon</th>
      <td>9.0</td>
      <td>10.0</td>
      <td>11.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
series = frame.iloc[0]
series
```




    b    0.0
    d    1.0
    e    2.0
    Name: Utah, dtype: float64




```python
# 行上进行广播计算
frame + series
```




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
      <th>b</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Utah</th>
      <td>0.0</td>
      <td>2.0</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>Ohio</th>
      <td>3.0</td>
      <td>5.0</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>6.0</td>
      <td>8.0</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>Oregon</th>
      <td>9.0</td>
      <td>11.0</td>
      <td>13.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 列上进行广播计算 , 这里出现了问题，因为计算会根据索引进行匹配导致的
frame.add(series, axis = 'index')
```




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
      <th>b</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>Oregon</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>Utah</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>b</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>d</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>e</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>




```python
# series2 = frame['b']
series2 = frame.loc[:, 'b']
series2
```




    Utah      0.0
    Ohio      3.0
    Texas     6.0
    Oregon    9.0
    Name: b, dtype: float64




```python
frame.add(series2, axis = 'index')
```




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
      <th>b</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Utah</th>
      <td>0.0</td>
      <td>1.0</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>Ohio</th>
      <td>6.0</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>12.0</td>
      <td>13.0</td>
      <td>14.0</td>
    </tr>
    <tr>
      <th>Oregon</th>
      <td>18.0</td>
      <td>19.0</td>
      <td>20.0</td>
    </tr>
  </tbody>
</table>
</div>



### 函数应用和映射

将函数应用到由各列或行所形成的一维数组上。DataFrame的apply方法即可实现此功能：


```python
frame = pd.DataFrame(np.random.randn(4, 3), columns=list('bde'), index=['Utah', 'Ohio', 'Texas', 'Oregon'])
frame
```




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
      <th>b</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Utah</th>
      <td>-0.618453</td>
      <td>0.743194</td>
      <td>-1.467120</td>
    </tr>
    <tr>
      <th>Ohio</th>
      <td>0.272335</td>
      <td>0.542511</td>
      <td>-0.458843</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>-0.762976</td>
      <td>0.330646</td>
      <td>0.988022</td>
    </tr>
    <tr>
      <th>Oregon</th>
      <td>-0.207557</td>
      <td>0.425898</td>
      <td>0.783251</td>
    </tr>
  </tbody>
</table>
</div>




```python
f = lambda x: x.max() - x.min()
# 没一列的最大值减去最小值
frame.apply(f)
```




    b    1.035311
    d    0.412548
    e    2.455142
    dtype: float64



如果传递 `axis='columns'` 到 apply ，这个函数会在每行执行：


```python
frame.apply(f, axis='columns')
```




    Utah      2.210314
    Ohio      1.001354
    Texas     1.750998
    Oregon    0.990809
    dtype: float64



传递到apply的函数不是必须返回一个标量，还可以返回由多个值组成的Series：


```python
def f1(x):
    return pd.Series([x.min(), x.max()], index=['min', 'max'])
frame.apply(f1)
```




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
      <th>b</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>min</th>
      <td>-0.762976</td>
      <td>0.330646</td>
      <td>-1.467120</td>
    </tr>
    <tr>
      <th>max</th>
      <td>0.272335</td>
      <td>0.743194</td>
      <td>0.988022</td>
    </tr>
  </tbody>
</table>
</div>



元素级的Python函数也是可以用的。假如你想得到frame中各个浮点值的格式化字符串，使用applymap即可：


```python
format = lambda x: '%.2f' % x
frame.applymap(format)
```




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
      <th>b</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Utah</th>
      <td>-0.62</td>
      <td>0.74</td>
      <td>-1.47</td>
    </tr>
    <tr>
      <th>Ohio</th>
      <td>0.27</td>
      <td>0.54</td>
      <td>-0.46</td>
    </tr>
    <tr>
      <th>Texas</th>
      <td>-0.76</td>
      <td>0.33</td>
      <td>0.99</td>
    </tr>
    <tr>
      <th>Oregon</th>
      <td>-0.21</td>
      <td>0.43</td>
      <td>0.78</td>
    </tr>
  </tbody>
</table>
</div>



Series 有一个用于应用元素级函数的 map 方法


```python
series = pd.Series([1, 2, 3])
series.map(format)
```




    0    1.00
    1    2.00
    2    3.00
    dtype: object



### 排序和排名

根据条件对数据集排序（sorting）也是一种重要的内置运算。要对行或列索引进行排序（按字典顺序），可使用 sort_index 方法，它将返回一个已排序的新对象：


```python
obj = pd.Series(range(4), index=['d', 'a', 'b', 'c'])
obj
```




    d    0
    a    1
    b    2
    c    3
    dtype: int64



#### 按照索引排序 sort_index


```python
obj.sort_index()
```




    a    1
    b    2
    c    3
    d    0
    dtype: int64




```python
frame = pd.DataFrame(np.arange(8).reshape((2, 4)), index=['three', 'one'], columns=['d', 'a', 'b', 'c'])
frame
```




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
      <th>d</th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>three</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>one</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 按照 0 轴排序
frame.sort_index()
```




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
      <th>d</th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>three</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 按照 1 轴排序
frame.sort_index(axis = 1)
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>three</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>one</th>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>



数据默认是按升序排序的，但也可以降序排序：


```python
frame.sort_index(axis=1, ascending=False)
```




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
      <th>d</th>
      <th>c</th>
      <th>b</th>
      <th>a</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>three</th>
      <td>0</td>
      <td>3</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>one</th>
      <td>4</td>
      <td>7</td>
      <td>6</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>



#### 按照值排序 sort_values


```python
obj
```




    d    0
    a    1
    b    2
    c    3
    dtype: int64




```python
obj = pd.Series([4, 7, -3, 2])
obj.sort_values()
```




    2   -3
    3    2
    0    4
    1    7
    dtype: int64



当排序一个DataFrame时，你可能希望根据一个或多个列中的值进行排序。将一个或多个列的名字传递给 sort_values 的 by 选项即可达到该目的：


```python
frame = pd.DataFrame({'b': [4, 7, -3, 2], 'a': [0, 1, 0, 1]})
frame
```




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
      <th>b</th>
      <th>a</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>4</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>7</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
frame.sort_values(by='b')
```




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
      <th>b</th>
      <th>a</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>-3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>0</th>
      <td>4</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>7</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
frame.sort_values(by=['a', 'b'])
```




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
      <th>b</th>
      <th>a</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>-3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>0</th>
      <td>4</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>7</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



默认情况下，rank是通过“为各组分配一个平均排名”的方式破坏平级关系的：


```python
obj = pd.Series([7, -5, 7, 4, 2, 0, 4])
obj
```




    0    7
    1   -5
    2    7
    3    4
    4    2
    5    0
    6    4
    dtype: int64




```python
obj.rank()
```




    0    6.5
    1    1.0
    2    6.5
    3    4.5
    4    3.0
    5    2.0
    6    4.5
    dtype: float64



也可以根据值在原数据中出现的顺序给出排名：


```python
obj.rank(method='first')
```




    0    6.0
    1    1.0
    2    7.0
    3    4.0
    4    3.0
    5    2.0
    6    5.0
    dtype: float64



你也可以按降序进行排名：


```python
obj.rank(ascending=False, method='first')
```




    0    1.0
    1    7.0
    2    2.0
    3    3.0
    4    5.0
    5    6.0
    6    4.0
    dtype: float64



rank 方法在 DataFrame 可以在行或列上计算排名：


```python
frame = pd.DataFrame({'b': [4.3, 7, -3, 2], 'a': [0, 1, 0, 1], 'c': [-2, 5, 8, -2.5]})
frame
```




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
      <th>b</th>
      <th>a</th>
      <th>c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>4.3</td>
      <td>0</td>
      <td>-2.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>7.0</td>
      <td>1</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-3.0</td>
      <td>0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2.0</td>
      <td>1</td>
      <td>-2.5</td>
    </tr>
  </tbody>
</table>
</div>




```python
frame.rank(axis='columns')
```




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
      <th>b</th>
      <th>a</th>
      <th>c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3.0</td>
      <td>2.0</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3.0</td>
      <td>1.0</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.0</td>
      <td>2.0</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3.0</td>
      <td>2.0</td>
      <td>1.0</td>
    </tr>
  </tbody>
</table>
</div>



排名时用于破坏平级关系的方法  
![](http://upload-images.jianshu.io/upload_images/7178691-7edfab5b4a147581.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### 带有重复标签的轴索引

重复的标签会导致获取数据是数据结构复杂，不建议使用


```python
obj = pd.Series(range(5), index=['a', 'a', 'b', 'b', 'c'])
obj
```




    a    0
    a    1
    b    2
    b    3
    c    4
    dtype: int64




```python
obj.index.is_unique
```




    False




```python
obj['a']
```




    a    0
    a    1
    dtype: int64



## 汇总和计算描述统计

pandas对象拥有一组常用的数学和统计方法。它们大部分都属于约简和汇总统计，用于从Series中提取单个值（如sum或mean）或从DataFrame的行或列中提取一个Series。跟对应的NumPy数组方法相比，它们都是基于没有缺失数据的假设而构建的。


```python
df = pd.DataFrame([[1.4, np.nan], [7.1, -4.5], [np.nan, np.nan], [0.75, -1.3]], index=['a', 'b', 'c', 'd'], columns=['one', 'two'])
df
```




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
      <th>one</th>
      <th>two</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>1.40</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>b</th>
      <td>7.10</td>
      <td>-4.5</td>
    </tr>
    <tr>
      <th>c</th>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>d</th>
      <td>0.75</td>
      <td>-1.3</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 和 Numpy 不同的是，nan将会忽略掉继续进行计算
df.sum()
```




    one    9.25
    two   -5.80
    dtype: float64




```python
# 在 1 周方向计算
df.sum(axis=1)
```




    a    1.40
    b    2.60
    c    0.00
    d   -0.55
    dtype: float64



NA值会自动被排除，除非整个切片（这里指的是行或列）都是NA。通过skipna选项可以禁用该功能：


```python
df.sum(axis=1, skipna = False)
```




    a     NaN
    b    2.60
    c     NaN
    d   -0.55
    dtype: float64



所有与描述统计相关的方法  
![](http://upload-images.jianshu.io/upload_images/7178691-11fa967f658ac314.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### 相关系数与协方差

有些汇总统计（如相关系数和协方差）是通过参数对计算出来的。我们来看几个DataFrame，它们的数据来自 Yahoo!Finance 的股票价格和成交量，使用的是 pandas-datareader 包（可以用conda或pip安装）：  
```
conda install pandas-datareader
```
使用pandas_datareader模块下载了一些股票数据：  


```python
import pandas_datareader.data as web
all_data = {ticker: web.get_data_yahoo(ticker)
            for ticker in ['AAPL', 'IBM', 'MSFT', 'GOOG']}

price = pd.DataFrame({ticker: data['Adj Close']
                     for ticker, data in all_data.items()})
volume = pd.DataFrame({ticker: data['Volume']
                      for ticker, data in all_data.items()})
```


```python
returns = price.pct_change()
returns.tail()
```




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
      <th>AAPL</th>
      <th>IBM</th>
      <th>MSFT</th>
      <th>GOOG</th>
    </tr>
    <tr>
      <th>Date</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2019-04-11</th>
      <td>-0.008324</td>
      <td>0.005314</td>
      <td>0.001165</td>
      <td>0.002046</td>
    </tr>
    <tr>
      <th>2019-04-12</th>
      <td>-0.000402</td>
      <td>0.003964</td>
      <td>0.005152</td>
      <td>0.010999</td>
    </tr>
    <tr>
      <th>2019-04-15</th>
      <td>0.001810</td>
      <td>-0.003118</td>
      <td>0.000827</td>
      <td>0.002652</td>
    </tr>
    <tr>
      <th>2019-04-16</th>
      <td>0.000100</td>
      <td>0.008617</td>
      <td>-0.002313</td>
      <td>0.004938</td>
    </tr>
    <tr>
      <th>2019-04-17</th>
      <td>0.019473</td>
      <td>-0.041546</td>
      <td>0.008280</td>
      <td>0.007505</td>
    </tr>
  </tbody>
</table>
</div>



Series 的 corr 方法用于计算两个 Series 中重叠的、非NA的、按索引对齐的值的相关系数。与此类似， cov 用于计算协方差：


```python
returns['MSFT'].corr(returns['IBM'])
```




    0.4865732693083368




```python
returns['MSFT'].cov(returns['IBM'])
```




    8.677797505286974e-05



DataFrame 的 corr 和 cov 方法将以 DataFrame 的形式分别返回完整的相关系数或协方差矩阵：


```python
returns.corr()
```




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
      <th>AAPL</th>
      <th>IBM</th>
      <th>MSFT</th>
      <th>GOOG</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>AAPL</th>
      <td>1.000000</td>
      <td>0.370756</td>
      <td>0.452098</td>
      <td>0.458110</td>
    </tr>
    <tr>
      <th>IBM</th>
      <td>0.370756</td>
      <td>1.000000</td>
      <td>0.486573</td>
      <td>0.407424</td>
    </tr>
    <tr>
      <th>MSFT</th>
      <td>0.452098</td>
      <td>0.486573</td>
      <td>1.000000</td>
      <td>0.537616</td>
    </tr>
    <tr>
      <th>GOOG</th>
      <td>0.458110</td>
      <td>0.407424</td>
      <td>0.537616</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>




```python
returns.cov()
```




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
      <th>AAPL</th>
      <th>IBM</th>
      <th>MSFT</th>
      <th>GOOG</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>AAPL</th>
      <td>0.000269</td>
      <td>0.000075</td>
      <td>0.000107</td>
      <td>0.000116</td>
    </tr>
    <tr>
      <th>IBM</th>
      <td>0.000075</td>
      <td>0.000152</td>
      <td>0.000087</td>
      <td>0.000077</td>
    </tr>
    <tr>
      <th>MSFT</th>
      <td>0.000107</td>
      <td>0.000087</td>
      <td>0.000209</td>
      <td>0.000120</td>
    </tr>
    <tr>
      <th>GOOG</th>
      <td>0.000116</td>
      <td>0.000077</td>
      <td>0.000120</td>
      <td>0.000236</td>
    </tr>
  </tbody>
</table>
</div>



利用DataFrame的corrwith方法，你可以计算其列或行跟另一个Series或DataFrame之间的相关系数。传入一个Series将会返回一个相关系数值Series（针对各列进行计算）：


```python
returns.corrwith(returns.IBM)
```




    AAPL    0.370756
    IBM     1.000000
    MSFT    0.486573
    GOOG    0.407424
    dtype: float64



传入一个DataFrame则会计算按列名配对的相关系数。这里，我计算百分比变化与成交量的相关系数：


```python
volume.head()
```




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
      <th>AAPL</th>
      <th>IBM</th>
      <th>MSFT</th>
      <th>GOOG</th>
    </tr>
    <tr>
      <th>Date</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2009-12-31</th>
      <td>88102700.0</td>
      <td>4223400.0</td>
      <td>31929700.0</td>
      <td>2455400.0</td>
    </tr>
    <tr>
      <th>2010-01-04</th>
      <td>123432400.0</td>
      <td>6155300.0</td>
      <td>38409100.0</td>
      <td>3937800.0</td>
    </tr>
    <tr>
      <th>2010-01-05</th>
      <td>150476200.0</td>
      <td>6841400.0</td>
      <td>49749600.0</td>
      <td>6048500.0</td>
    </tr>
    <tr>
      <th>2010-01-06</th>
      <td>138040000.0</td>
      <td>5605300.0</td>
      <td>58182400.0</td>
      <td>8009000.0</td>
    </tr>
    <tr>
      <th>2010-01-07</th>
      <td>119282800.0</td>
      <td>5840600.0</td>
      <td>50559700.0</td>
      <td>12912000.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
returns.corrwith(volume)
```




    AAPL   -0.061663
    IBM    -0.156416
    MSFT   -0.089665
    GOOG   -0.018289
    dtype: float64




```python
returns.corrwith(returns)
```




    AAPL    1.0
    IBM     1.0
    MSFT    1.0
    GOOG    1.0
    dtype: float64



> 传入 `axis='columns'` 即可按行进行计算。无论如何，在计算相关系数之前，所有的数据项都会按标签对齐。

### 唯一值、值计数以及成员资格

unique 可以得到Series中的唯一值数组：


```python
obj = pd.Series(['c', 'a', 'd', 'a', 'a', 'b', 'b', 'c', 'c'])
obj.unique()
```




    array(['c', 'a', 'd', 'b'], dtype=object)



value_counts 用于计算一个 Series 中各值出现的频率：


```python
obj.value_counts()
```




    c    3
    a    3
    b    2
    d    1
    dtype: int64



为了便于查看，结果Series是按值频率降序排列的。value_counts还是一个顶级pandas方法，可用于任何数组或序列：


```python
pd.value_counts(obj.values, sort=False)
```




    b    2
    d    1
    a    3
    c    3
    dtype: int64



isin用于判断矢量化集合的成员资格，可用于过滤Series中或DataFrame列中数据的子集：


```python
obj
```




    0    c
    1    a
    2    d
    3    a
    4    a
    5    b
    6    b
    7    c
    8    c
    dtype: object




```python
mask = obj.isin(['b', 'c'])
mask
```




    0     True
    1    False
    2    False
    3    False
    4    False
    5     True
    6     True
    7     True
    8     True
    dtype: bool




```python
obj[mask]
```




    0    c
    5    b
    6    b
    7    c
    8    c
    dtype: object



# 数据加载、存储与文件格式

## 读写文本格式的数据

pandas提供了一些用于将表格型数据读取为DataFrame对象的函数。表6-1对它们进行了总结，其中read_csv和read_table可能会是你今后用得最多的。  
![](http://upload-images.jianshu.io/upload_images/7178691-958f849e6067b19b.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)  

其中一些函数，比如pandas.read_csv，有类型推断功能，因为列数据的类型不属于数据类型。也就是说，你不需要指定列的类型到底是数值、整数、布尔值，还是字符串。其它的数据格式，如HDF5、Feather和msgpack，会在格式中存储数据类型。

### 读取 csv 文件


```python
!cat data/examples/ex1.csv
```

    a,b,c,d,message
    1,2,3,4,hello
    5,6,7,8,world
    9,10,11,12,foo

由于该文件以逗号分隔，所以我们可以使用read_csv将其读入一个DataFrame：


```python
df = pd.read_csv('data/examples/ex1.csv')
df
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>hello</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



我们还可以使用read_table，并指定分隔符：


```python
pd.read_table('data/examples/ex1.csv', sep = ',')
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>hello</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



并不是所有文件都有标题行。看看下面这个文件：


```python
!cat data/examples/ex2.csv
```

    1,2,3,4,hello
    5,6,7,8,world
    9,10,11,12,foo

读入没有标题行的办法有两个。你可以让pandas为其分配默认的列名，也可以自己定义列名：


```python
pd.read_csv('data/examples/ex2.csv', header=None)
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>hello</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.read_csv('data/examples/ex2.csv', names=['a', 'b', 'c', 'd', 'message'])
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>hello</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



指定某一列作为列索引


```python
pd.read_csv('data/examples/ex2.csv', names=['a', 'b', 'c', 'd', 'message'], index_col='message')
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
    <tr>
      <th>message</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>hello</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
    </tr>
    <tr>
      <th>world</th>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th>foo</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
    </tr>
  </tbody>
</table>
</div>



如果希望将多个列做成一个层次化索引，只需传入由列编号或列名组成的列表即可：


```python
!cat data/examples/csv_mindex.csv
```

    key1,key2,value1,value2
    one,a,1,2
    one,b,3,4
    one,c,5,6
    one,d,7,8
    two,a,9,10
    two,b,11,12
    two,c,13,14
    two,d,15,16



```python
pd.read_csv('data/examples/csv_mindex.csv', index_col=['key1', 'key2'])
```




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
      <th></th>
      <th>value1</th>
      <th>value2</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="4" valign="top">one</th>
      <th>a</th>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>b</th>
      <td>3</td>
      <td>4</td>
    </tr>
    <tr>
      <th>c</th>
      <td>5</td>
      <td>6</td>
    </tr>
    <tr>
      <th>d</th>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th rowspan="4" valign="top">two</th>
      <th>a</th>
      <td>9</td>
      <td>10</td>
    </tr>
    <tr>
      <th>b</th>
      <td>11</td>
      <td>12</td>
    </tr>
    <tr>
      <th>c</th>
      <td>13</td>
      <td>14</td>
    </tr>
    <tr>
      <th>d</th>
      <td>15</td>
      <td>16</td>
    </tr>
  </tbody>
</table>
</div>



有些表格可能不是用固定的分隔符去分隔字段的（比如空白符或其它模式）。看看下面这个文本文件：


```python
list(open('data/examples/ex3.txt'))
```




    ['            A         B         C\n',
     'aaa -0.264438 -1.026059 -0.619500\n',
     'bbb  0.927272  0.302904 -0.032399\n',
     'ccc -0.264273 -0.386314 -0.217601\n',
     'ddd -0.871858 -0.348382  1.100491\n']



虽然可以手动对数据进行规整，这里的字段是被数量不同的空白字符间隔开的。这种情况下，你可以传递一个正则表达式作为read_table的分隔符。可以用正则表达式表达为 `\s+`，于是有：


```python
pd.read_table('data/examples/ex3.txt', sep='\s+')
```




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
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>aaa</th>
      <td>-0.264438</td>
      <td>-1.026059</td>
      <td>-0.619500</td>
    </tr>
    <tr>
      <th>bbb</th>
      <td>0.927272</td>
      <td>0.302904</td>
      <td>-0.032399</td>
    </tr>
    <tr>
      <th>ccc</th>
      <td>-0.264273</td>
      <td>-0.386314</td>
      <td>-0.217601</td>
    </tr>
    <tr>
      <th>ddd</th>
      <td>-0.871858</td>
      <td>-0.348382</td>
      <td>1.100491</td>
    </tr>
  </tbody>
</table>
</div>



可以用skiprows跳过文件的第一行、第三行和第四行：


```python
!cat data/examples/ex4.csv
```

    # hey!
    a,b,c,d,message
    # just wanted to make things more difficult for you
    # who reads CSV files with computers, anyway?
    1,2,3,4,hello
    5,6,7,8,world
    9,10,11,12,foo


```python
pd.read_csv('data/examples/ex4.csv', skiprows=[0, 2, 3])
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>hello</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



缺失值处理是文件解析任务中的一个重要组成部分。缺失数据经常是要么没有（空字符串），要么用某个标记值表示。默认情况下，pandas会用一组经常出现的标记值进行识别，比如NA及NULL：


```python
!cat data/examples/ex5.csv
```

    something,a,b,c,d,message
    one,1,2,3,4,NA
    two,5,6,,8,world
    three,9,10,11,12,foo


```python
pd.read_csv('data/examples/ex5.csv')
```




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
      <th>something</th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>one</td>
      <td>1</td>
      <td>2</td>
      <td>3.0</td>
      <td>4</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>two</td>
      <td>5</td>
      <td>6</td>
      <td>NaN</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>three</td>
      <td>9</td>
      <td>10</td>
      <td>11.0</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



na_values 可以用一个列表或集合的字符串表示缺失值：(把指定的值填充成 Nan)


```python
# 把 Null 填充成空缺值
pd.read_csv('data/examples/ex5.csv', na_values=['NULL'])
```




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
      <th>something</th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>one</td>
      <td>1</td>
      <td>2</td>
      <td>3.0</td>
      <td>4</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>two</td>
      <td>5</td>
      <td>6</td>
      <td>NaN</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>three</td>
      <td>9</td>
      <td>10</td>
      <td>11.0</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



字典的各列可以对不同的值用NA进行标记：


```python
sentinels = {'message': ['foo', 'NA'], 'something': ['two']}
pd.read_csv('data/examples/ex5.csv', na_values=sentinels)
```




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
      <th>something</th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>one</td>
      <td>1</td>
      <td>2</td>
      <td>3.0</td>
      <td>4</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>NaN</td>
      <td>5</td>
      <td>6</td>
      <td>NaN</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>three</td>
      <td>9</td>
      <td>10</td>
      <td>11.0</td>
      <td>12</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



pandas.read_csv和pandas.read_table常用的选项。  
![](http://upload-images.jianshu.io/upload_images/7178691-082daf4a00ed9494.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)
![](http://upload-images.jianshu.io/upload_images/7178691-f2bcc0a703c7236f.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)
![](http://upload-images.jianshu.io/upload_images/7178691-597327ade3e94c7a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### 逐块读取文本文件

在处理很大的文件时，或找出大文件中的参数集以便于后续处理时，你可能只想读取文件的一小部分或逐块对文件进行迭代。

在看大文件之前，我们先设置pandas显示地更紧些：


```python
# 最多显示 10 行
pd.options.display.max_rows = 10
```


```python
pd.read_csv('data/examples/ex6.csv')
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
      <th>key</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.467976</td>
      <td>-0.038649</td>
      <td>-0.295344</td>
      <td>-1.824726</td>
      <td>L</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.358893</td>
      <td>1.404453</td>
      <td>0.704965</td>
      <td>-0.200638</td>
      <td>B</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-0.501840</td>
      <td>0.659254</td>
      <td>-0.421691</td>
      <td>-0.057688</td>
      <td>G</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.204886</td>
      <td>1.074134</td>
      <td>1.388361</td>
      <td>-0.982404</td>
      <td>R</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.354628</td>
      <td>-0.133116</td>
      <td>0.283763</td>
      <td>-0.837063</td>
      <td>Q</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>9995</th>
      <td>2.311896</td>
      <td>-0.417070</td>
      <td>-1.409599</td>
      <td>-0.515821</td>
      <td>L</td>
    </tr>
    <tr>
      <th>9996</th>
      <td>-0.479893</td>
      <td>-0.650419</td>
      <td>0.745152</td>
      <td>-0.646038</td>
      <td>E</td>
    </tr>
    <tr>
      <th>9997</th>
      <td>0.523331</td>
      <td>0.787112</td>
      <td>0.486066</td>
      <td>1.093156</td>
      <td>K</td>
    </tr>
    <tr>
      <th>9998</th>
      <td>-0.362559</td>
      <td>0.598894</td>
      <td>-1.843201</td>
      <td>0.887292</td>
      <td>G</td>
    </tr>
    <tr>
      <th>9999</th>
      <td>-0.096376</td>
      <td>-1.012999</td>
      <td>-0.657431</td>
      <td>-0.573315</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>10000 rows × 5 columns</p>
</div>



如果只想读取几行（避免读取整个文件），通过nrows进行指定即可：


```python
pd.read_csv('data/examples/ex6.csv', nrows=5)
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
      <th>key</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.467976</td>
      <td>-0.038649</td>
      <td>-0.295344</td>
      <td>-1.824726</td>
      <td>L</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.358893</td>
      <td>1.404453</td>
      <td>0.704965</td>
      <td>-0.200638</td>
      <td>B</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-0.501840</td>
      <td>0.659254</td>
      <td>-0.421691</td>
      <td>-0.057688</td>
      <td>G</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.204886</td>
      <td>1.074134</td>
      <td>1.388361</td>
      <td>-0.982404</td>
      <td>R</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.354628</td>
      <td>-0.133116</td>
      <td>0.283763</td>
      <td>-0.837063</td>
      <td>Q</td>
    </tr>
  </tbody>
</table>
</div>



要逐块读取文件，可以指定chunksize（行数）：


```python
chunker = pd.read_csv('data/examples/ex6.csv', chunksize=2)
chunker
```




    <pandas.io.parsers.TextFileReader at 0xa1a9710>




```python
tot = pd.Series([])
for piece in chunker:
    tot = tot.add(piece['key'].value_counts(), fill_value=0)
print(piece)
```

               one       two     three      four key
    9998 -0.362559  0.598894 -1.843201  0.887292   G
    9999 -0.096376 -1.012999 -0.657431 -0.573315   0
    

### 将数据写出到文本格式


```python
data = pd.read_csv('data/examples/ex5.csv')
data
```




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
      <th>something</th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>one</td>
      <td>1</td>
      <td>2</td>
      <td>3.0</td>
      <td>4</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>two</td>
      <td>5</td>
      <td>6</td>
      <td>NaN</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>three</td>
      <td>9</td>
      <td>10</td>
      <td>11.0</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 输出到文件
data.to_csv('data/examples/out.csv')
```


```python
!cat data/examples/out.csv
```

    ,something,a,b,c,d,message
    0,one,1,2,3.0,4,
    1,two,5,6,,8,world
    2,three,9,10,11.0,12,foo


当然，还可以使用其他分隔符（由于这里直接写出到sys.stdout，所以仅仅是打印出文本结果而已）：


```python
import sys
```


```python
# 设置分割符 | 
data.to_csv(sys.stdout, sep='|')
```

    |something|a|b|c|d|message
    0|one|1|2|3.0|4|
    1|two|5|6||8|world
    2|three|9|10|11.0|12|foo
    

禁止输出行和列的标签(索引)


```python
data.to_csv(sys.stdout, index=False, header=False)
```

    one,1,2,3.0,4,
    two,5,6,,8,world
    three,9,10,11.0,12,foo
    

输出部分列


```python
data.to_csv(sys.stdout, index=False, columns=['a', 'b', 'c'])
```

    a,b,c
    1,2,3.0
    5,6,
    9,10,11.0
    

### JSON数据


```python
obj = """
{"name": "Wes",
 "places_lived": ["United States", "Spain", "Germany"],
 "pet": null,
 "siblings": [{"name": "Scott", "age": 30, "pets": ["Zeus", "Zuko"]},
              {"name": "Katie", "age": 38,
               "pets": ["Sixes", "Stache", "Cisco"]}]
}
"""
import json
result = json.loads(obj)
result
```




    {'name': 'Wes',
     'places_lived': ['United States', 'Spain', 'Germany'],
     'pet': None,
     'siblings': [{'name': 'Scott', 'age': 30, 'pets': ['Zeus', 'Zuko']},
      {'name': 'Katie', 'age': 38, 'pets': ['Sixes', 'Stache', 'Cisco']}]}




```python
siblings = pd.DataFrame(result['siblings'], columns=['name', 'age'])
siblings
```




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
      <th>age</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Scott</td>
      <td>30</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Katie</td>
      <td>38</td>
    </tr>
  </tbody>
</table>
</div>



pandas.read_json可以自动将特别格式的JSON数据集转换为Series或DataFrame。例如：


```python
!cat data/examples/example.json
```

    [{"a": 1, "b": 2, "c": 3},
     {"a": 4, "b": 5, "c": 6},
     {"a": 7, "b": 8, "c": 9}]



```python
data = pd.read_json('data/examples/example.json')
data
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
    </tr>
    <tr>
      <th>2</th>
      <td>7</td>
      <td>8</td>
      <td>9</td>
    </tr>
  </tbody>
</table>
</div>



将数据从pandas输出到JSON，可以使用to_json方法：


```python
data.to_json()
```




    '{"a":{"0":1,"1":4,"2":7},"b":{"0":2,"1":5,"2":8},"c":{"0":3,"1":6,"2":9}}'




```python
data.to_json(orient='records')
```




    '[{"a":1,"b":2,"c":3},{"a":4,"b":5,"c":6},{"a":7,"b":8,"c":9}]'



## 二进制数据格式

实现数据的高效二进制格式存储最简单的办法之一是使用Python内置的pickle序列化。pandas对象都有一个用于将数据以pickle格式保存到磁盘上的to_pickle方法：


```python
frame = pd.read_csv('data/examples/ex1.csv')
frame
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>hello</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>




```python
frame.to_pickle('data/examples/frame_pickle')
```

通过pickle直接读取被pickle化的数据，或是使用更为方便的pandas.read_pickle：


```python
pd.read_pickle('data/examples/frame_pickle')
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>hello</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



> 注意：pickle仅建议用于短期存储格式。其原因是很难保证该格式永远是稳定的；今天pickle的对象可能无法被后续版本的库unpickle出来。虽然我尽力保证这种事情不会发生在pandas中，但是今后的某个时候说不定还是得“打破”该pickle格式。

### 使用HDF5格式

HDF5是一种存储大规模科学数组数据的非常好的文件格式。它可以被作为C标准库，带有许多语言的接口，如Java、Python和MATLAB等。HDF5中的HDF指的是层次型数据格式（hierarchical data format）。每个HDF5文件都含有一个文件系统式的节点结构，它使你能够存储多个数据集并支持元数据。与其他简单格式相比，HDF5支持多种压缩器的即时压缩，还能更高效地存储重复模式数据。对于那些非常大的无法直接放入内存的数据集，HDF5就是不错的选择，因为它可以高效地分块读写。  

虽然可以用PyTables或h5py库直接访问HDF5文件，pandas提供了更为高级的接口，可以简化存储Series和DataFrame对象。HDFStore类可以像字典一样，处理低级的细节：



```python
frame = pd.DataFrame({'a': np.random.randn(100)})
frame.head()
```




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
      <th>a</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.863684</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.743116</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-0.656781</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.349087</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-0.772184</td>
    </tr>
  </tbody>
</table>
</div>




```python
store = pd.HDFStore('data/examples/mydata.h5')
```


```python
# 存储数据
store['obj1'] = frame
```


```python
store['obj1_col'] = frame['a']
```


```python
store
```




    <class 'pandas.io.pytables.HDFStore'>
    File path: data/examples/mydata.h5




```python
store.close()
```


```python
store1 = pd.HDFStore('data/examples/mydata.h5')
```


```python
# 获取数据
store1['obj1'].head()
```




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
      <th>a</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.863684</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.743116</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-0.656781</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.349087</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-0.772184</td>
    </tr>
  </tbody>
</table>
</div>



### 读取Microsoft Excel文件


pandas的ExcelFile类或pandas.read_excel函数支持读取存储在Excel 2003（或更高版本）中的表格型数据。这两个工具分别使用扩展包xlrd和openpyxl读取XLS和XLSX文件。你可以用pip或conda安装它们。


```python
xlsx = pd.ExcelFile('data/examples/ex1.xlsx')
pd.read_excel(xlsx, 'Sheet1')
```




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
      <th>Unnamed: 0</th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>hello</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



如果要读取一个文件中的多个表单，创建ExcelFile会更快，但你也可以将文件名传递到pandas.read_excel：


```python
frame = pd.read_excel('data/examples/ex1.xlsx', 'Sheet1')
frame
```




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
      <th>Unnamed: 0</th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>message</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>hello</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
      <td>world</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



如果要将pandas数据写入为Excel格式，你必须首先创建一个ExcelWriter，然后使用pandas对象的to_excel方法将数据写入到其中：


```python
writer = pd.ExcelWriter('data/examples/ex2.xlsx')
frame.to_excel(writer, 'Sheet1')
writer.save()
```

你还可以不使用ExcelWriter，而是传递文件的路径到to_excel：


```python
frame.to_excel('data/examples/ex2.xlsx')
```

### 数据库交互

将数据从SQL加载到DataFrame的过程很简单，此外pandas还有一些能够简化该过程的函数。  
例如，我将使用SQLite数据库（通过Python内置的sqlite3驱动器）：


```python
import sqlite3

# 创建表
query = """
CREATE TABLE test
(a VARCHAR(20), b VARCHAR(20),
 c REAL,        d INTEGER
);"""
con = sqlite3.connect('mydata.sqlite')
con.execute(query)
con.commit()

# 写入数据  批量写入
data = [('Atlanta', 'Georgia', 1.25, 6),
('Tallahassee', 'Florida', 2.6, 3),
('Sacramento', 'California', 1.7, 5)]
stmt = "INSERT INTO test VALUES(?, ?, ?, ?)"
con.executemany(stmt, data)
con.commit()

# 查询数据
cursor = con.execute('select * from test')
rows = cursor.fetchall()
rows
```




    [('Atlanta', 'Georgia', 1.25, 6),
     ('Tallahassee', 'Florida', 2.6, 3),
     ('Sacramento', 'California', 1.7, 5)]




```python
# 获取列名(字段名称)
cursor.description
```




    (('a', None, None, None, None, None, None),
     ('b', None, None, None, None, None, None),
     ('c', None, None, None, None, None, None),
     ('d', None, None, None, None, None, None))




```python
# 创建 dataframe
pd.DataFrame(rows, columns=[x[0] for x in cursor.description])
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Atlanta</td>
      <td>Georgia</td>
      <td>1.25</td>
      <td>6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Tallahassee</td>
      <td>Florida</td>
      <td>2.60</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Sacramento</td>
      <td>California</td>
      <td>1.70</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>



pandas 有一个 read_sql 函数，可以直接通过 sql 进行读取数据


```python
db = sqlite3.connect('mydata.sqlite')
```


```python
pd.read_sql('select * from test', db)
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Atlanta</td>
      <td>Georgia</td>
      <td>1.25</td>
      <td>6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Tallahassee</td>
      <td>Florida</td>
      <td>2.60</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Sacramento</td>
      <td>California</td>
      <td>1.70</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>



# 数据清洗和准备

## 处理缺失数据

缺失数据在pandas中呈现的方式有些不完美，但对于大多数用户可以保证功能正常。对于数值数据，pandas使用浮点值NaN（Not a Number）表示缺失数据。我们称其为哨兵值，可以方便的检测出来：


```python
string_data = pd.Series(['aardvark', 'artichoke', np.nan, 'avocado'])
string_data
```




    0     aardvark
    1    artichoke
    2          NaN
    3      avocado
    dtype: object




```python
# 判断是否是空值
string_data.isnull()
```




    0    False
    1    False
    2     True
    3    False
    dtype: bool



Python内置的None值在对象数组中也可以作为NA


```python
string_data[0] = None
string_data
```




    0         None
    1    artichoke
    2          NaN
    3      avocado
    dtype: object




```python
string_data.isnull()
```




    0     True
    1    False
    2     True
    3    False
    dtype: bool



一些关于缺失数据处理的函数。  
![](http://upload-images.jianshu.io/upload_images/7178691-1a0f73e5bb26ea21.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### 滤除缺失数据

对于一个Series，dropna返回一个仅含非空数据和索引值的Series：


```python
data = pd.Series([1, np.nan, 3.5, np.nan, 7])
data
```




    0    1.0
    1    NaN
    2    3.5
    3    NaN
    4    7.0
    dtype: float64




```python
data.dropna()
```




    0    1.0
    2    3.5
    4    7.0
    dtype: float64




```python
# 等价于
data[data.notnull()]
```




    0    1.0
    2    3.5
    4    7.0
    dtype: float64



而对于DataFrame对象，事情就有点复杂了。你可能希望丢弃全NA或含有NA的行或列。dropna默认丢弃任何含有缺失值的行：


```python
data = pd.DataFrame([[1., 6.5, 3.], [1., NA, NA], [NA, NA, NA], [NA, 6.5, 3.]])
data
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>6.5</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>6.5</td>
      <td>3.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.dropna()
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>6.5</td>
      <td>3.0</td>
    </tr>
  </tbody>
</table>
</div>



传入 `how='all'` 将只丢弃全为NA的那些行：


```python
data.dropna(how='all')
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>6.5</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>6.5</td>
      <td>3.0</td>
    </tr>
  </tbody>
</table>
</div>



丢弃列，只需传入axis=1即可：


```python
data[4] = NA
data
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>6.5</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>6.5</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.dropna(axis=1, how='all')
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>6.5</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>6.5</td>
      <td>3.0</td>
    </tr>
  </tbody>
</table>
</div>



`thresh` 参数 删除 行、列 空值超过指定数字的 


```python
data
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>6.5</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>6.5</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 删除 行 方向 nan 大于 2 的行
data.dropna(thresh=2)
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>6.5</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>6.5</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



### 填充缺失数据

对于大多数情况而言，fillna方法是最主要的函数。通过一个常数调用fillna就会将缺失值替换为那个常数值：


```python
df = pd.DataFrame(np.random.randn(7, 3))
df.iloc[:4, 1] = NA
df.iloc[:2, 2] = NA
df
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.187550</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.903578</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.142988</td>
      <td>NaN</td>
      <td>-1.629844</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.346151</td>
      <td>NaN</td>
      <td>-0.806237</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.125914</td>
      <td>-0.188009</td>
      <td>-1.067930</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-1.181948</td>
      <td>0.289074</td>
      <td>-0.852676</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.568097</td>
      <td>-0.950069</td>
      <td>-2.165337</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 填充成 0 
df.fillna(0)
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.187550</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.903578</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.142988</td>
      <td>0.000000</td>
      <td>-1.629844</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.346151</td>
      <td>0.000000</td>
      <td>-0.806237</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.125914</td>
      <td>-0.188009</td>
      <td>-1.067930</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-1.181948</td>
      <td>0.289074</td>
      <td>-0.852676</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.568097</td>
      <td>-0.950069</td>
      <td>-2.165337</td>
    </tr>
  </tbody>
</table>
</div>



若是通过一个字典调用fillna，就可以实现对不同的列填充不同的值：


```python
# 1 列填充 0.5 ；2 列填充 0
df.fillna({1: 0.5, 2: 0})
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.187550</td>
      <td>0.500000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.903578</td>
      <td>0.500000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.142988</td>
      <td>0.500000</td>
      <td>-1.629844</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.346151</td>
      <td>0.500000</td>
      <td>-0.806237</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.125914</td>
      <td>-0.188009</td>
      <td>-1.067930</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-1.181948</td>
      <td>0.289074</td>
      <td>-0.852676</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.568097</td>
      <td>-0.950069</td>
      <td>-2.165337</td>
    </tr>
  </tbody>
</table>
</div>



fillna默认会返回新对象，但也可以对现有对象进行就地修改：


```python
df.fillna(0, inplace=True)
df
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.187550</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.903578</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.142988</td>
      <td>0.000000</td>
      <td>-1.629844</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.346151</td>
      <td>0.000000</td>
      <td>-0.806237</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.125914</td>
      <td>-0.188009</td>
      <td>-1.067930</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-1.181948</td>
      <td>0.289074</td>
      <td>-0.852676</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.568097</td>
      <td>-0.950069</td>
      <td>-2.165337</td>
    </tr>
  </tbody>
</table>
</div>



对 reindex 有效的那些插值方法也可用于fillna：


```python
df = pd.DataFrame(np.random.randn(6, 3))
df.iloc[2:, 1] = NA
df.iloc[4:, 2] = NA
df
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-2.190504</td>
      <td>-1.963825</td>
      <td>-1.545763</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.306294</td>
      <td>-1.290580</td>
      <td>-1.274680</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.535840</td>
      <td>NaN</td>
      <td>0.219375</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.938590</td>
      <td>NaN</td>
      <td>-1.277384</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.747602</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-0.113758</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>




```python
# ffill 使用 前值填充
df.fillna(method='ffill')
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-2.190504</td>
      <td>-1.963825</td>
      <td>-1.545763</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.306294</td>
      <td>-1.290580</td>
      <td>-1.274680</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.535840</td>
      <td>-1.290580</td>
      <td>0.219375</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.938590</td>
      <td>-1.290580</td>
      <td>-1.277384</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.747602</td>
      <td>-1.290580</td>
      <td>-1.277384</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-0.113758</td>
      <td>-1.290580</td>
      <td>-1.277384</td>
    </tr>
  </tbody>
</table>
</div>




```python
# limit 限制填充的条数
df.fillna(method='ffill', limit=2)
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-2.190504</td>
      <td>-1.963825</td>
      <td>-1.545763</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.306294</td>
      <td>-1.290580</td>
      <td>-1.274680</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.535840</td>
      <td>-1.290580</td>
      <td>0.219375</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.938590</td>
      <td>-1.290580</td>
      <td>-1.277384</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.747602</td>
      <td>NaN</td>
      <td>-1.277384</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-0.113758</td>
      <td>NaN</td>
      <td>-1.277384</td>
    </tr>
  </tbody>
</table>
</div>



可以传入Series的平均值或中位数：


```python
data = pd.Series([1., NA, 3.5, NA, 7])
data
```




    0    1.0
    1    NaN
    2    3.5
    3    NaN
    4    7.0
    dtype: float64




```python
data.fillna(data.mean())
```




    0    1.000000
    1    3.833333
    2    3.500000
    3    3.833333
    4    7.000000
    dtype: float64



fillna函数参数 
![](http://upload-images.jianshu.io/upload_images/7178691-0bf235386a64c3b5.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)
![](http://upload-images.jianshu.io/upload_images/7178691-4edd39e68f4dc530.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

## 数据转换

### 移除重复数据


```python
data = pd.DataFrame({'k1': ['one', 'two'] * 3 + ['two'], 'k2': [1, 1, 2, 3, 3, 4, 4]})
data
```




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
      <th>k1</th>
      <th>k2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>one</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>two</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>one</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>two</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>one</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>two</td>
      <td>4</td>
    </tr>
    <tr>
      <th>6</th>
      <td>two</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>



duplicated 方法返回一个布尔型 Series，表示各行是否是重复行（前面出现过的行）：


```python
data.duplicated()
```




    0    False
    1    False
    2    False
    3    False
    4    False
    5    False
    6     True
    dtype: bool



drop_duplicates 方法，它会返回一个DataFrame，重复的数据会被删除


```python
data.drop_duplicates()
```




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
      <th>k1</th>
      <th>k2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>one</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>two</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>one</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>two</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>one</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>two</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>



这两个方法默认会判断全部列，你也可以指定部分列进行重复项判断。


```python
data.drop_duplicates(['k1'])
```




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
      <th>k1</th>
      <th>k2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>one</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>two</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



duplicated 和 drop_duplicates 默认保留的是第一个出现的值组合。传入 `keep='last'` 则保留最后一个：


```python
data.drop_duplicates(['k1', 'k2'], keep='last')
```




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
      <th>k1</th>
      <th>k2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>one</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>two</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>one</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>two</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>one</td>
      <td>3</td>
    </tr>
    <tr>
      <th>6</th>
      <td>two</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>



利用函数或映射进行数据转换

### 利用函数或映射进行数据转换

我们来看看下面这组有关肉类的数据：


```python
data = pd.DataFrame({'food': ['bacon', 'pulled pork', 'bacon', 'Pastrami', 'corned beef', 'Bacon','pastrami', 'honey ham', 'nova lox'],
        'ounces': [4, 3, 12, 6, 7.5, 8, 3, 5, 6]})
data
```




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
      <th>food</th>
      <th>ounces</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>bacon</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>pulled pork</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>bacon</td>
      <td>12.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Pastrami</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>corned beef</td>
      <td>7.5</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Bacon</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>pastrami</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>honey ham</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>nova lox</td>
      <td>6.0</td>
    </tr>
  </tbody>
</table>
</div>



假设你想要添加一列表示该肉类食物来源的动物类型。我们先编写一个不同肉类到动物的映射：


```python
meat_to_animal = {
  'bacon': 'pig',
  'pulled pork': 'pig',
  'pastrami': 'cow',
  'corned beef': 'cow',
  'honey ham': 'pig',
  'nova lox': 'salmon'
}
```

列字符转换成小写


```python
lowercased = data['food'].str.lower()
lowercased
```




    0          bacon
    1    pulled pork
    2          bacon
    3       pastrami
    4    corned beef
    5          bacon
    6       pastrami
    7      honey ham
    8       nova lox
    Name: food, dtype: object




```python
lowercased.map(meat_to_animal)
```




    0       pig
    1       pig
    2       pig
    3       cow
    4       cow
    5       pig
    6       cow
    7       pig
    8    salmon
    Name: food, dtype: object




```python
data['animal'] = lowercased.map(meat_to_animal)
data
```




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
      <th>food</th>
      <th>ounces</th>
      <th>animal</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>bacon</td>
      <td>4.0</td>
      <td>pig</td>
    </tr>
    <tr>
      <th>1</th>
      <td>pulled pork</td>
      <td>3.0</td>
      <td>pig</td>
    </tr>
    <tr>
      <th>2</th>
      <td>bacon</td>
      <td>12.0</td>
      <td>pig</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Pastrami</td>
      <td>6.0</td>
      <td>cow</td>
    </tr>
    <tr>
      <th>4</th>
      <td>corned beef</td>
      <td>7.5</td>
      <td>cow</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Bacon</td>
      <td>8.0</td>
      <td>pig</td>
    </tr>
    <tr>
      <th>6</th>
      <td>pastrami</td>
      <td>3.0</td>
      <td>cow</td>
    </tr>
    <tr>
      <th>7</th>
      <td>honey ham</td>
      <td>5.0</td>
      <td>pig</td>
    </tr>
    <tr>
      <th>8</th>
      <td>nova lox</td>
      <td>6.0</td>
      <td>salmon</td>
    </tr>
  </tbody>
</table>
</div>



我们也可以使用下面的这种方式


```python
data['food'].map(lambda x: meat_to_animal[x.lower()])
```




    0       pig
    1       pig
    2       pig
    3       cow
    4       cow
    5       pig
    6       cow
    7       pig
    8    salmon
    Name: food, dtype: object



### 替换值


```python
data = pd.Series([1., -999., 2., -999., -1000., 3.])
data
```




    0       1.0
    1    -999.0
    2       2.0
    3    -999.0
    4   -1000.0
    5       3.0
    dtype: float64



-999这个值可能是一个表示缺失数据的标记值。要将其替换为pandas能够理解的NA值，我们可以利用replace来产生一个新的Series（除非传入inplace=True）：


```python
data.replace(-999, np.nan)
```




    0       1.0
    1       NaN
    2       2.0
    3       NaN
    4   -1000.0
    5       3.0
    dtype: float64



如果你希望一次性替换多个值，可以传入一个由待替换值组成的列表以及一个替换值：


```python
data.replace([-999, -1000], np.nan)
```




    0    1.0
    1    NaN
    2    2.0
    3    NaN
    4    NaN
    5    3.0
    dtype: float64



要让每个值有不同的替换值，可以传递一个替换列表：


```python
data.replace([-999, -1000], [np.nan, 0])
```




    0    1.0
    1    NaN
    2    2.0
    3    NaN
    4    0.0
    5    3.0
    dtype: float64



传入的参数也可以是字典：


```python
data.replace({-999: np.nan, -1000: 0})
```




    0    1.0
    1    NaN
    2    2.0
    3    NaN
    4    0.0
    5    3.0
    dtype: float64



### 重命名轴索引


```python
data = pd.DataFrame(np.arange(12).reshape((3, 4)), index=['Ohio', 'Colorado', 'New York'], columns=['one', 'two', 'three', 'four'])
data
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>New York</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



跟Series一样，轴索引也有一个map方法：


```python
transform = lambda x: x[:4].upper()
data.index.map(transform)
```




    Index(['OHIO', 'COLO', 'NEW '], dtype='object')



将其赋值给index，这样就可以对DataFrame进行就地修改：


```python
data.index = data.index.map(transform)
data
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>OHIO</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>COLO</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>NEW</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



如果想要创建数据集的转换版（而不是修改原始数据），比较实用的方法是rename：


```python
data.rename(index=str.title, columns=str.upper)
```




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
      <th>ONE</th>
      <th>TWO</th>
      <th>THREE</th>
      <th>FOUR</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Colo</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>New</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



rename可以结合字典型对象实现对部分轴标签的更新：


```python
data.rename(index={'OHIO': 'INDIANA'}, columns={'three': 'peekaboo'})
```




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
      <th>one</th>
      <th>two</th>
      <th>peekaboo</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>INDIANA</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>COLO</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>NEW</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



rename可以实现复制DataFrame并对其索引和列标签进行赋值。如果希望就地修改某个数据集，传入 `inplace=True` 即可：


```python
data.rename(index={'OHIO': 'INDIANA'}, inplace=True)
data
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>INDIANA</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>COLO</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>NEW</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



### 离散化和面元划分

为了便于分析，连续数据常常被离散化或拆分为“面元”（bin）。假设有一组人员数据，而你希望将它们划分为不同的年龄组：


```python
ages = [20, 22, 25, 27, 21, 23, 37, 31, 61, 45, 41, 32]
```

接下来将这些数据划分为“18到25”、“26到35”、“35到60”以及“60以上”几个面元。要实现该功能，你需要使用pandas的cut函数：


```python
bins = [18, 25, 35, 60, 100]
cats = pd.cut(ages, bins)
cats
```




    [(18, 25], (18, 25], (18, 25], (25, 35], (18, 25], ..., (25, 35], (60, 100], (35, 60], (35, 60], (25, 35]]
    Length: 12
    Categories (4, interval[int64]): [(18, 25] < (25, 35] < (35, 60] < (60, 100]]



pandas返回的是一个特殊的Categorical对象。结果展示了pandas.cut划分的面元。你可以将其看做一组表示面元名称的字符串。它的底层含有一个表示不同分类名称的类型数组，以及一个codes属性中的年龄数据的标签：


```python
# 统计值所在的元面
cats.codes
```




    array([0, 0, 0, 1, 0, 0, 2, 1, 3, 2, 2, 1], dtype=int8)




```python
# 获得分组
cats.categories
```




    IntervalIndex([(18, 25], (25, 35], (35, 60], (60, 100]]
                  closed='right',
                  dtype='interval[int64]')




```python
# pd.value_counts(cats)是pandas.cut结果的面元计数。
pd.value_counts(cats)
```




    (18, 25]     5
    (35, 60]     3
    (25, 35]     3
    (60, 100]    1
    dtype: int64



跟“区间”的数学符号一样，圆括号表示开端，而方括号则表示闭端（包括）。哪边是闭端可以通过right=False进行修改：


```python
pd.cut(ages, [18, 26, 36, 61, 100], right=False)
```




    [[18, 26), [18, 26), [18, 26), [26, 36), [18, 26), ..., [26, 36), [61, 100), [36, 61), [36, 61), [26, 36)]
    Length: 12
    Categories (4, interval[int64]): [[18, 26) < [26, 36) < [36, 61) < [61, 100)]



通过传递一个列表或数组到labels，设置自己的面元名称：


```python
group_names = ['Youth', 'YoungAdult', 'MiddleAged', 'Senior']
pd.cut(ages, bins, labels=group_names)
```




    [Youth, Youth, Youth, YoungAdult, Youth, ..., YoungAdult, Senior, MiddleAged, MiddleAged, YoungAdult]
    Length: 12
    Categories (4, object): [Youth < YoungAdult < MiddleAged < Senior]



如果向cut传入的是面元的数量而不是确切的面元边界，则它会根据数据的最小值和最大值计算等长面元。


```python
data = np.random.rand(20)
# 等分成 4 份， 选项precision=2，限定小数只有两位。
pd.cut(data, 4, precision=2)
```




    [(0.49, 0.72], (0.015, 0.25], (0.49, 0.72], (0.49, 0.72], (0.25, 0.49], ..., (0.25, 0.49], (0.25, 0.49], (0.72, 0.96], (0.015, 0.25], (0.25, 0.49]]
    Length: 20
    Categories (4, interval[float64]): [(0.015, 0.25] < (0.25, 0.49] < (0.49, 0.72] < (0.72, 0.96]]



qcut是一个非常类似于cut的函数，它可以根据样本分位数对数据进行面元划分。根据数据的分布情况，cut可能无法使各个面元中含有相同数量的数据点。而qcut由于使用的是样本分位数，因此可以得到大小基本相等的面元：


```python
data = np.random.randn(1000)
cats = pd.qcut(data, 4)
cats
```




    [(-0.694, -0.0168], (-3.589, -0.694], (0.638, 3.369], (-0.0168, 0.638], (-3.589, -0.694], ..., (-0.694, -0.0168], (-3.589, -0.694], (-0.694, -0.0168], (-3.589, -0.694], (-0.0168, 0.638]]
    Length: 1000
    Categories (4, interval[float64]): [(-3.589, -0.694] < (-0.694, -0.0168] < (-0.0168, 0.638] < (0.638, 3.369]]




```python
pd.value_counts(cats)
```




    (0.638, 3.369]       250
    (-0.0168, 0.638]     250
    (-0.694, -0.0168]    250
    (-3.589, -0.694]     250
    dtype: int64



### 检测和过滤异常值

过滤或变换异常值在很大程度上就是运用数组运算。来看一个含有正态分布数据的DataFrame：


```python
data = pd.DataFrame(np.random.randn(1000, 4))
data.describe()
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>1000.000000</td>
      <td>1000.000000</td>
      <td>1000.000000</td>
      <td>1000.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>-0.064053</td>
      <td>-0.005447</td>
      <td>0.038026</td>
      <td>0.024811</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.999489</td>
      <td>0.948043</td>
      <td>0.953395</td>
      <td>1.021102</td>
    </tr>
    <tr>
      <th>min</th>
      <td>-3.105504</td>
      <td>-2.844008</td>
      <td>-2.760611</td>
      <td>-4.492430</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>-0.718899</td>
      <td>-0.656214</td>
      <td>-0.597055</td>
      <td>-0.646600</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>-0.020346</td>
      <td>-0.019434</td>
      <td>0.058547</td>
      <td>-0.003166</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>0.578055</td>
      <td>0.649719</td>
      <td>0.661221</td>
      <td>0.690373</td>
    </tr>
    <tr>
      <th>max</th>
      <td>3.106261</td>
      <td>2.717680</td>
      <td>3.289203</td>
      <td>3.243883</td>
    </tr>
  </tbody>
</table>
</div>



假设你想要找出某列中绝对值大小超过3的值


```python
col = data[2]
col[np.abs(col) > 3]
```




    308    3.289203
    Name: 2, dtype: float64



要选出全部含有“超过3或－3的值”的行，你可以在布尔型DataFrame中使用any方法：


```python
data[(np.abs(data) > 3).any(1)]
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>8</th>
      <td>-3.105504</td>
      <td>-0.094313</td>
      <td>-0.186817</td>
      <td>0.461499</td>
    </tr>
    <tr>
      <th>96</th>
      <td>0.522268</td>
      <td>-0.201284</td>
      <td>0.145961</td>
      <td>3.151065</td>
    </tr>
    <tr>
      <th>121</th>
      <td>3.106261</td>
      <td>-2.029135</td>
      <td>-0.179609</td>
      <td>-0.478008</td>
    </tr>
    <tr>
      <th>148</th>
      <td>0.019824</td>
      <td>0.115120</td>
      <td>1.005103</td>
      <td>-4.492430</td>
    </tr>
    <tr>
      <th>308</th>
      <td>0.770344</td>
      <td>-0.635648</td>
      <td>3.289203</td>
      <td>-0.151866</td>
    </tr>
    <tr>
      <th>434</th>
      <td>-0.594539</td>
      <td>-0.124445</td>
      <td>0.535540</td>
      <td>3.243883</td>
    </tr>
    <tr>
      <th>454</th>
      <td>0.196540</td>
      <td>0.002230</td>
      <td>1.150842</td>
      <td>-3.098229</td>
    </tr>
    <tr>
      <th>475</th>
      <td>1.327124</td>
      <td>0.532669</td>
      <td>-0.285367</td>
      <td>3.095290</td>
    </tr>
    <tr>
      <th>604</th>
      <td>1.154687</td>
      <td>0.336886</td>
      <td>-0.767514</td>
      <td>3.229107</td>
    </tr>
    <tr>
      <th>659</th>
      <td>-3.076200</td>
      <td>-0.979556</td>
      <td>0.653771</td>
      <td>0.559905</td>
    </tr>
  </tbody>
</table>
</div>



### 排列和随机采样

利用 `numpy.random.permutation` 函数可以轻松实现对Series或DataFrame的列的排列工作（permuting，随机重排序）。通过需要排列的轴的长度调用 permutation，可产生一个表示新顺序的整数数组：


```python
df = pd.DataFrame(np.arange(5 * 4).reshape((5, 4)))
df
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
    <tr>
      <th>3</th>
      <td>12</td>
      <td>13</td>
      <td>14</td>
      <td>15</td>
    </tr>
    <tr>
      <th>4</th>
      <td>16</td>
      <td>17</td>
      <td>18</td>
      <td>19</td>
    </tr>
  </tbody>
</table>
</div>




```python
sampler = np.random.permutation(5)
sampler
```




    array([2, 1, 4, 3, 0])



然后就可以在基于iloc的索引操作或take函数中使用该数组了：


```python
df.take(sampler)
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>4</th>
      <td>16</td>
      <td>17</td>
      <td>18</td>
      <td>19</td>
    </tr>
    <tr>
      <th>3</th>
      <td>12</td>
      <td>13</td>
      <td>14</td>
      <td>15</td>
    </tr>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



选取随机子集（不重复的）


```python
df.sample(n=3)
```




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>3</th>
      <td>12</td>
      <td>13</td>
      <td>14</td>
      <td>15</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



选取随机子集（允许重复）,不能操作 DateFrame


```python
choices = pd.Series([5, 7, -1, 6, 4])
choices.sample(n=10, replace=True)
```




    0    5
    4    4
    0    5
    0    5
    2   -1
    3    6
    3    6
    3    6
    3    6
    0    5
    dtype: int64




```python
choices
```




    0    5
    1    7
    2   -1
    3    6
    4    4
    dtype: int64



### 计算指标/哑变量

另一种常用于统计建模或机器学习的转换方式是：将分类变量（categorical variable）转换为“哑变量”或“指标矩阵”。  

如果DataFrame的某一列中含有k个不同的值，则可以派生出一个k列矩阵或DataFrame（其值全为1和0）。pandas有一个get_dummies函数可以实现该功能（其实自己动手做一个也不难）。使用之前的一个DataFrame例子：


```python
df = pd.DataFrame({'key': ['b', 'b', 'a', 'c', 'a', 'b'], 'data1': range(6)})
df
```




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
      <th>key</th>
      <th>data1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>b</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>a</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>c</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>a</td>
      <td>4</td>
    </tr>
    <tr>
      <th>5</th>
      <td>b</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.get_dummies(df['key'])
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



有时候，你可能想给指标DataFrame的列加上一个前缀，以便能够跟其他数据进行合并。get_dummies的prefix参数可以实现该功能：


```python
dummies = pd.get_dummies(df['key'], prefix='key')
dummies
```




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
      <th>key_a</th>
      <th>key_b</th>
      <th>key_c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 拼接
df_with_dummy = df[['data1']].join(dummies)
df_with_dummy
```




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
      <th>data1</th>
      <th>key_a</th>
      <th>key_b</th>
      <th>key_c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>5</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



如果DataFrame中的某行同属于多个分类，则事情就会有点复杂。看一下MovieLens 1M数据集


```python
mnames = ['movie_id', 'title', 'genres']
movies = pd.read_table('data/movielens/movies.dat', sep='::', header=None, names=mnames)
movies.head()
```

    C:\ProgramData\Anaconda3\lib\site-packages\ipykernel_launcher.py:2: ParserWarning: Falling back to the 'python' engine because the 'c' engine does not support regex separators (separators > 1 char and different from '\s+' are interpreted as regex); you can avoid this warning by specifying engine='python'.
      
    




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
      <th>movie_id</th>
      <th>title</th>
      <th>genres</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>Toy Story (1995)</td>
      <td>Animation|Children's|Comedy</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>Jumanji (1995)</td>
      <td>Adventure|Children's|Fantasy</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>Grumpier Old Men (1995)</td>
      <td>Comedy|Romance</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>Waiting to Exhale (1995)</td>
      <td>Comedy|Drama</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>Father of the Bride Part II (1995)</td>
      <td>Comedy</td>
    </tr>
  </tbody>
</table>
</div>



要为每个genre添加指标变量就需要做一些数据规整操作。首先，我们从数据集中抽取出不同的genre值：


```python
all_genres = []

for x in movies.genres:
    all_genres.extend(x.split('|'))

genres = pd.unique(all_genres)
genres
```




    array(['Animation', "Children's", 'Comedy', 'Adventure', 'Fantasy',
           'Romance', 'Drama', 'Action', 'Crime', 'Thriller', 'Horror',
           'Sci-Fi', 'Documentary', 'War', 'Musical', 'Mystery', 'Film-Noir',
           'Western'], dtype=object)



构建指标DataFrame的方法之一是从一个全零DataFrame开始：


```python
zero_matrix = np.zeros((len(movies), len(genres)))
zero_matrix
```




    array([[0., 0., 0., ..., 0., 0., 0.],
           [0., 0., 0., ..., 0., 0., 0.],
           [0., 0., 0., ..., 0., 0., 0.],
           ...,
           [0., 0., 0., ..., 0., 0., 0.],
           [0., 0., 0., ..., 0., 0., 0.],
           [0., 0., 0., ..., 0., 0., 0.]])




```python
dummies = pd.DataFrame(zero_matrix, columns=genres)
dummies.head()
```




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
      <th>Animation</th>
      <th>Children's</th>
      <th>Comedy</th>
      <th>Adventure</th>
      <th>Fantasy</th>
      <th>Romance</th>
      <th>Drama</th>
      <th>Action</th>
      <th>Crime</th>
      <th>Thriller</th>
      <th>Horror</th>
      <th>Sci-Fi</th>
      <th>Documentary</th>
      <th>War</th>
      <th>Musical</th>
      <th>Mystery</th>
      <th>Film-Noir</th>
      <th>Western</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
</div>



现在，迭代每一部电影，并将dummies各行的条目设为1。要这么做，我们使用dummies.columns来计算每个类型的列索引：


```python
gen = movies.genres[0]
gen
```




    "Animation|Children's|Comedy"




```python
gen.split('|')
```




    ['Animation', "Children's", 'Comedy']




```python
# 获取值对应的下标
dummies.columns.get_indexer(gen.split('|'))
```




    array([0, 1, 2], dtype=int64)



根据索引，使用.iloc设定值：


```python
for i, gen in enumerate(movies.genres):
    indices = dummies.columns.get_indexer(gen.split('|'))
    dummies.iloc[i, indices] = 1
```

将其与movies合并起来：


```python
movies_windic = movies.join(dummies.add_prefix('Genre_'))
movies_windic.head()
```




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
      <th>movie_id</th>
      <th>title</th>
      <th>genres</th>
      <th>Genre_Animation</th>
      <th>Genre_Children's</th>
      <th>Genre_Comedy</th>
      <th>Genre_Adventure</th>
      <th>Genre_Fantasy</th>
      <th>Genre_Romance</th>
      <th>Genre_Drama</th>
      <th>...</th>
      <th>Genre_Crime</th>
      <th>Genre_Thriller</th>
      <th>Genre_Horror</th>
      <th>Genre_Sci-Fi</th>
      <th>Genre_Documentary</th>
      <th>Genre_War</th>
      <th>Genre_Musical</th>
      <th>Genre_Mystery</th>
      <th>Genre_Film-Noir</th>
      <th>Genre_Western</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>Toy Story (1995)</td>
      <td>Animation|Children's|Comedy</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>Jumanji (1995)</td>
      <td>Adventure|Children's|Fantasy</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>Grumpier Old Men (1995)</td>
      <td>Comedy|Romance</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>Waiting to Exhale (1995)</td>
      <td>Comedy|Drama</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>Father of the Bride Part II (1995)</td>
      <td>Comedy</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 21 columns</p>
</div>



## 字符串操作

### pandas 的矢量化字符串函数


```python
data = {'Dave': 'dave@google.com', 'Steve': 'steve@gmail.com', 'Rob': 'rob@gmail.com', 'Wes': np.nan}
data = pd.Series(data)
data
```




    Dave     dave@google.com
    Steve    steve@gmail.com
    Rob        rob@gmail.com
    Wes                  NaN
    dtype: object




```python
data.isnull()
```




    Dave     False
    Steve    False
    Rob      False
    Wes       True
    dtype: bool



通过 `data.map`，所有字符串和正则表达式方法都能被应用于（传入lambda表达式或其他函数）各个值，但是如果存在 `NA（null）` 就会报错。为了解决这个问题，Series有一些能够跳过NA值的面向数组方法，进行字符串操作。通过Series的 `str` 属性即可访问这些方法。例如，我们可以通过 `str.contains` 检查各个电子邮件地址是否含有"gmail"：


```python
data.str.contains('gmail')
```




    Dave     False
    Steve     True
    Rob       True
    Wes        NaN
    dtype: object



也可以使用正则表达式，还可以加上任意re选项（如IGNORECASE）：


```python
pattern = '([A-Z0-9._%+-]+)@([A-Z0-9.-]+)\\.([A-Z]{2,4})'
temp = data.str.findall(pattern, flags=re.IGNORECASE)
temp
```




    Dave     [(dave, google, com)]
    Steve    [(steve, gmail, com)]
    Rob        [(rob, gmail, com)]
    Wes                        NaN
    dtype: object



对字符串进行截取


```python
data.str[:5]
```




    Dave     dave@
    Steve    steve
    Rob      rob@g
    Wes        NaN
    dtype: object



更多的pandas字符串方法  
![](http://upload-images.jianshu.io/upload_images/7178691-a634364ed6d5d5c5.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

# 数据规整：聚合、合并和重塑

## 层次化索引

层次化索引（hierarchical indexing）是pandas的一项重要功能，它使你能在一个轴上拥有多个（两个以上）索引级别。


```python
data = pd.Series(np.random.randn(9), index=[['a', 'a', 'a', 'b', 'b', 'c', 'c', 'd', 'd'], [1, 2, 3, 1, 3, 1, 2, 2, 3]])
data
```




    a  1    1.280879
       2   -0.233278
       3    0.700301
    b  1    0.115678
       3    0.390445
    c  1   -0.816532
       2   -0.972933
    d  2    2.053691
       3    1.166844
    dtype: float64




```python
data.index
```




    MultiIndex(levels=[['a', 'b', 'c', 'd'], [1, 2, 3]],
               labels=[[0, 0, 0, 1, 1, 2, 2, 3, 3], [0, 1, 2, 0, 2, 0, 1, 1, 2]])



对于一个层次化索引的对象，可以使用所谓的部分索引，使用它选取数据子集的操作更简单：


```python
data['b']
```




    1    0.115678
    3    0.390445
    dtype: float64




```python
data['b':'c']
```




    b  1    0.115678
       3    0.390445
    c  1   -0.816532
       2   -0.972933
    dtype: float64




```python
data[['b','c']]
```




    b  1    0.115678
       3    0.390445
    c  1   -0.816532
       2   -0.972933
    dtype: float64



在“内层”中进行选取


```python
data.loc[:, 2]
```




    a   -0.233278
    c   -0.972933
    d    2.053691
    dtype: float64



unstack方法将这段数据重新安排到一个DataFrame中：


```python
data.unstack()
```




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
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>1.280879</td>
      <td>-0.233278</td>
      <td>0.700301</td>
    </tr>
    <tr>
      <th>b</th>
      <td>0.115678</td>
      <td>NaN</td>
      <td>0.390445</td>
    </tr>
    <tr>
      <th>c</th>
      <td>-0.816532</td>
      <td>-0.972933</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>d</th>
      <td>NaN</td>
      <td>2.053691</td>
      <td>1.166844</td>
    </tr>
  </tbody>
</table>
</div>



unstack的逆运算是stack：


```python
data.unstack().stack()
```




    a  1    1.280879
       2   -0.233278
       3    0.700301
    b  1    0.115678
       3    0.390445
    c  1   -0.816532
       2   -0.972933
    d  2    2.053691
       3    1.166844
    dtype: float64



对于一个DataFrame，每条轴都可以有分层索引：


```python
frame = pd.DataFrame(np.arange(12).reshape((4, 3)), index=[['a', 'a', 'b', 'b'], [1, 2, 1, 2]], 
        columns=[['Ohio', 'Ohio', 'Colorado'], ['Green', 'Red', 'Green']])
frame
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th colspan="2" halign="left">Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th></th>
      <th></th>
      <th>Green</th>
      <th>Red</th>
      <th>Green</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">a</th>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">b</th>
      <th>1</th>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



各层都可以有名字（可以是字符串，也可以是别的Python对象）。如果指定了名称，它们就会显示在控制台输出中：


```python
frame.index.names = ['key1', 'key2']
frame.columns.names = ['state', 'color']
frame
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th>state</th>
      <th colspan="2" halign="left">Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th></th>
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
      <th>Green</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">a</th>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">b</th>
      <th>1</th>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



有了部分列索引，因此可以轻松选取列分组：


```python
frame['Ohio']
```




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
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">a</th>
      <th>1</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>4</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">b</th>
      <th>1</th>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>




```python
frame.index
```




    MultiIndex(levels=[['a', 'b'], [1, 2]],
               codes=[[0, 0, 1, 1], [0, 1, 0, 1]],
               names=['key1', 'key2'])



### 重排与分级排序

重新调整某条轴上各级别的顺序，或根据指定级别上的值对数据进行排序。

swaplevel接受两个级别编号或名称，并返回一个互换了级别的新对象（但数据不会发生变化）：


```python
frame
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th>state</th>
      <th colspan="2" halign="left">Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th></th>
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
      <th>Green</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">a</th>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">b</th>
      <th>1</th>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 交换 key1 和 key2 位置
frame.swaplevel('key1', 'key2')
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th>state</th>
      <th colspan="2" halign="left">Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th></th>
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
      <th>Green</th>
    </tr>
    <tr>
      <th>key2</th>
      <th>key1</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <th>a</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <th>a</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th>1</th>
      <th>b</th>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th>2</th>
      <th>b</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



sort_index则根据单个级别中的值对数据进行排序。


```python
# 这里 level = 1 指的是 key2 列
frame.sort_index(level=1)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th>state</th>
      <th colspan="2" halign="left">Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th></th>
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
      <th>Green</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>b</th>
      <th>1</th>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th>a</th>
      <th>2</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th>b</th>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>




```python
frame.sort_index(level=0)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th>state</th>
      <th colspan="2" halign="left">Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th></th>
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
      <th>Green</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">a</th>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">b</th>
      <th>1</th>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>




```python
frame.swaplevel(0, 1).sort_index(level=0)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th>state</th>
      <th colspan="2" halign="left">Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th></th>
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
      <th>Green</th>
    </tr>
    <tr>
      <th>key2</th>
      <th>key1</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">1</th>
      <th>a</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>b</th>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">2</th>
      <th>a</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th>b</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



### 根据级别汇总统计

许多对DataFrame和Series的描述和汇总统计都有一个level选项，它用于指定在某条轴上求和的级别。


```python
frame
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th>state</th>
      <th colspan="2" halign="left">Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th></th>
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
      <th>Green</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">a</th>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">b</th>
      <th>1</th>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 列方向 根据 level = key2 求和
frame.sum(level='key2')
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th>state</th>
      <th colspan="2" halign="left">Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
      <th>Green</th>
    </tr>
    <tr>
      <th>key2</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>6</td>
      <td>8</td>
      <td>10</td>
    </tr>
    <tr>
      <th>2</th>
      <td>12</td>
      <td>14</td>
      <td>16</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 行方向 更具 level = color 求和
frame.sum(level='color', axis=1)
```




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
      <th>color</th>
      <th>Green</th>
      <th>Red</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">a</th>
      <th>1</th>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>8</td>
      <td>4</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">b</th>
      <th>1</th>
      <td>14</td>
      <td>7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>20</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>



### 使用DataFrame的列进行索引

人们经常想要将DataFrame的一个或多个列当做行索引来用，或者可能希望将行索引变成DataFrame的列。  
DataFrame的set_index函数会将其一个或多个列转换为行索引，并创建一个新的DataFrame：


```python
frame = pd.DataFrame({'a': range(7), 'b': range(7, 0, -1), 
                      'c': ['one', 'one', 'one', 'two', 'two', 'two', 'two'],
                      'd': [0, 1, 2, 0, 1, 2, 3]})
frame
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>7</td>
      <td>one</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>6</td>
      <td>one</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>5</td>
      <td>one</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>4</td>
      <td>two</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>3</td>
      <td>two</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>5</td>
      <td>2</td>
      <td>two</td>
      <td>2</td>
    </tr>
    <tr>
      <th>6</th>
      <td>6</td>
      <td>1</td>
      <td>two</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>




```python
frame2 = frame.set_index(['c', 'd'])
frame2
```




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
      <th></th>
      <th>a</th>
      <th>b</th>
    </tr>
    <tr>
      <th>c</th>
      <th>d</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="3" valign="top">one</th>
      <th>0</th>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>6</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>5</td>
    </tr>
    <tr>
      <th rowspan="4" valign="top">two</th>
      <th>0</th>
      <td>3</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>6</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



默认情况下，那些列会从DataFrame中移除，但也可以将其保留下来：


```python
frame.set_index(['c', 'd'], drop=False)
```




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
      <th></th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
    <tr>
      <th>c</th>
      <th>d</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="3" valign="top">one</th>
      <th>0</th>
      <td>0</td>
      <td>7</td>
      <td>one</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>6</td>
      <td>one</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>5</td>
      <td>one</td>
      <td>2</td>
    </tr>
    <tr>
      <th rowspan="4" valign="top">two</th>
      <th>0</th>
      <td>3</td>
      <td>4</td>
      <td>two</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4</td>
      <td>3</td>
      <td>two</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>5</td>
      <td>2</td>
      <td>two</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>6</td>
      <td>1</td>
      <td>two</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



reset_index的功能跟set_index刚好相反，层次化索引的级别会被转移到列里面：


```python
frame2.reset_index()
```




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
      <th>c</th>
      <th>d</th>
      <th>a</th>
      <th>b</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>one</td>
      <td>0</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>1</th>
      <td>one</td>
      <td>1</td>
      <td>1</td>
      <td>6</td>
    </tr>
    <tr>
      <th>2</th>
      <td>one</td>
      <td>2</td>
      <td>2</td>
      <td>5</td>
    </tr>
    <tr>
      <th>3</th>
      <td>two</td>
      <td>0</td>
      <td>3</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>two</td>
      <td>1</td>
      <td>4</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>two</td>
      <td>2</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>6</th>
      <td>two</td>
      <td>3</td>
      <td>6</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



## 合并数据集

pandas对象中的数据可以通过一些方式进行合并：  
1. pandas.merge可根据一个或多个键将不同DataFrame中的行连接起来。SQL或其他关系型数据库的用户对此应该会比较熟悉，因为它实现的就是数据库的join操作。
2. pandas.concat可以沿着一条轴将多个对象堆叠到一起。
3. 实例方法combine_first可以将重复数据拼接在一起，用一个对象中的值填充另一个对象中的缺失值。

### 数据库风格的DataFrame合并

数据集的合并（merge）或连接（join）运算是通过一个或多个键将行连接起来的。这些运算是关系型数据库（基于SQL）的核心。pandas的merge函数是对数据应用这些算法的主要切入点。


```python
df1 = pd.DataFrame({'key': ['b', 'b', 'a', 'c', 'a', 'a', 'b'], 'data1': range(7)})

df2 = pd.DataFrame({'key': ['a', 'b', 'd'], 'data2': range(3)})

df1
```




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
      <th>key</th>
      <th>data1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>b</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>a</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>c</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>a</td>
      <td>4</td>
    </tr>
    <tr>
      <th>5</th>
      <td>a</td>
      <td>5</td>
    </tr>
    <tr>
      <th>6</th>
      <td>b</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
</div>




```python
df2
```




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
      <th>key</th>
      <th>data2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>d</td>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div>



如果没有指定关联的列，merge就会将重叠列的列名当做键。默认情况下，merge做的是“内连接”；结果中的键是交集。


```python
pd.merge(df1, df2)
```




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
      <th>key</th>
      <th>data1</th>
      <th>data2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>b</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>b</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>a</td>
      <td>4</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>a</td>
      <td>5</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



指明要用哪个列进行连接。


```python
pd.merge(df1, df2, on='key')
```




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
      <th>key</th>
      <th>data1</th>
      <th>data2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>b</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>b</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>a</td>
      <td>4</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>a</td>
      <td>5</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



如果两个对象的列名不同，也可以分别进行指定：


```python
df3 = pd.DataFrame({'lkey': ['b', 'b', 'a', 'c', 'a', 'a', 'b'], 'data1': range(7)})

df4 = pd.DataFrame({'rkey': ['a', 'b', 'd'], 'data2': range(3)})

pd.merge(df3, df4, left_on='lkey', right_on='rkey')
```




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
      <th>lkey</th>
      <th>data1</th>
      <th>rkey</th>
      <th>data2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>b</td>
      <td>0</td>
      <td>b</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
      <td>b</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>b</td>
      <td>6</td>
      <td>b</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a</td>
      <td>2</td>
      <td>a</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>a</td>
      <td>4</td>
      <td>a</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>a</td>
      <td>5</td>
      <td>a</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



指定连接方式


```python
pd.merge(df1, df2, how='outer')
```




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
      <th>key</th>
      <th>data1</th>
      <th>data2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>b</td>
      <td>0.0</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1.0</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>b</td>
      <td>6.0</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a</td>
      <td>2.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>a</td>
      <td>4.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>a</td>
      <td>5.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>c</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>7</th>
      <td>d</td>
      <td>NaN</td>
      <td>2.0</td>
    </tr>
  </tbody>
</table>
</div>



![不同的连接类型](http://upload-images.jianshu.io/upload_images/7178691-e49b3341f4a3c90e.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

要根据多个键进行合并，传入一个由列名组成的列表即可：


```python
left = pd.DataFrame({'key1': ['foo', 'foo', 'bar'], 
                     'key2': ['one', 'two', 'one'], 
                     'lval': [1, 2, 3]})

right = pd.DataFrame({'key1': ['foo', 'foo', 'bar', 'bar'],
                               'key2': ['one', 'one', 'one', 'two'],
                               'rval': [4, 5, 6, 7]})
left 
```




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
      <th>key1</th>
      <th>key2</th>
      <th>lval</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>foo</td>
      <td>two</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>bar</td>
      <td>one</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>




```python
right
```




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
      <th>key1</th>
      <th>key2</th>
      <th>rval</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>foo</td>
      <td>one</td>
      <td>5</td>
    </tr>
    <tr>
      <th>2</th>
      <td>bar</td>
      <td>one</td>
      <td>6</td>
    </tr>
    <tr>
      <th>3</th>
      <td>bar</td>
      <td>two</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.merge(left, right, on=['key1', 'key2'], how='outer')
```




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
      <th>key1</th>
      <th>key2</th>
      <th>lval</th>
      <th>rval</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>1.0</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>foo</td>
      <td>one</td>
      <td>1.0</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>2.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>bar</td>
      <td>one</td>
      <td>3.0</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>bar</td>
      <td>two</td>
      <td>NaN</td>
      <td>7.0</td>
    </tr>
  </tbody>
</table>
</div>



对于合并运算需要考虑的最后一个问题是对重复列名的处理。虽然你可以手工处理列名重叠的问题（查看前面介绍的重命名轴标签），但merge有一个更实用的suffixes选项，用于指定附加到左右两个DataFrame对象的重叠列名上的字符串：


```python
pd.merge(left, right, on='key1')
```




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
      <th>key1</th>
      <th>key2_x</th>
      <th>lval</th>
      <th>key2_y</th>
      <th>rval</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>1</td>
      <td>one</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>foo</td>
      <td>one</td>
      <td>1</td>
      <td>one</td>
      <td>5</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>2</td>
      <td>one</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>foo</td>
      <td>two</td>
      <td>2</td>
      <td>one</td>
      <td>5</td>
    </tr>
    <tr>
      <th>4</th>
      <td>bar</td>
      <td>one</td>
      <td>3</td>
      <td>one</td>
      <td>6</td>
    </tr>
    <tr>
      <th>5</th>
      <td>bar</td>
      <td>one</td>
      <td>3</td>
      <td>two</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.merge(left, right, on='key1', suffixes=('_left', '_right'))
```




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
      <th>key1</th>
      <th>key2_left</th>
      <th>lval</th>
      <th>key2_right</th>
      <th>rval</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>1</td>
      <td>one</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>foo</td>
      <td>one</td>
      <td>1</td>
      <td>one</td>
      <td>5</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>2</td>
      <td>one</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>foo</td>
      <td>two</td>
      <td>2</td>
      <td>one</td>
      <td>5</td>
    </tr>
    <tr>
      <th>4</th>
      <td>bar</td>
      <td>one</td>
      <td>3</td>
      <td>one</td>
      <td>6</td>
    </tr>
    <tr>
      <th>5</th>
      <td>bar</td>
      <td>one</td>
      <td>3</td>
      <td>two</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>



merge函数的参数  

![1](http://upload-images.jianshu.io/upload_images/7178691-35ca716a4f1b8475.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)  

![2](http://upload-images.jianshu.io/upload_images/7178691-c86672e733ceccd9.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### 索引上的合并

有时候，DataFrame中的连接键位于其索引中。在这种情况下，你可以传入 `left_index=True` 或 `right_index=True`（或两个都传）以说明索引应该被用作连接键：


```python
left1 = pd.DataFrame({'key': ['a', 'b', 'a', 'a', 'b', 'c'], 'value': range(6)})
left1
```




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
      <th>key</th>
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>a</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>b</td>
      <td>4</td>
    </tr>
    <tr>
      <th>5</th>
      <td>c</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>




```python
right1 = pd.DataFrame({'group_val': [3.5, 7]}, index=['a', 'b'])
right1
```




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
      <th>group_val</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>3.5</td>
    </tr>
    <tr>
      <th>b</th>
      <td>7.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.merge(left1, right1, left_on='key', right_index=True)
```




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
      <th>key</th>
      <th>value</th>
      <th>group_val</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>0</td>
      <td>3.5</td>
    </tr>
    <tr>
      <th>2</th>
      <td>a</td>
      <td>2</td>
      <td>3.5</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a</td>
      <td>3</td>
      <td>3.5</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>b</td>
      <td>4</td>
      <td>7.0</td>
    </tr>
  </tbody>
</table>
</div>



对于层次化索引的数据，事情就有点复杂了，因为索引的合并默认是多键合并：


```python
lefth = pd.DataFrame({'key1': ['Ohio', 'Ohio', 'Ohio', 'Nevada', 'Nevada'],
                      'key2': [2000, 2001, 2002, 2001, 2002],
                      'data': np.arange(5.)})
lefth
```




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
      <th>key1</th>
      <th>key2</th>
      <th>data</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Ohio</td>
      <td>2000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Ohio</td>
      <td>2001</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Ohio</td>
      <td>2002</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Nevada</td>
      <td>2001</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Nevada</td>
      <td>2002</td>
      <td>4.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
righth = pd.DataFrame(np.arange(12).reshape((6, 2)),
                      index=[['Nevada', 'Nevada', 'Ohio', 'Ohio', 'Ohio', 'Ohio'],
                             [2001, 2000, 2000, 2000, 2001, 2002]],
                      columns=['event1', 'event2'])
righth
```




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
      <th></th>
      <th>event1</th>
      <th>event2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Nevada</th>
      <th>2001</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2000</th>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th rowspan="4" valign="top">Ohio</th>
      <th>2000</th>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th>2000</th>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>2001</th>
      <td>8</td>
      <td>9</td>
    </tr>
    <tr>
      <th>2002</th>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



这种情况下，你必须以列表的形式指明用作合并键的多个列


```python
pd.merge(lefth, righth, left_on=['key1', 'key2'], right_index=True)
```




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
      <th>key1</th>
      <th>key2</th>
      <th>data</th>
      <th>event1</th>
      <th>event2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Ohio</td>
      <td>2000</td>
      <td>0.0</td>
      <td>4</td>
      <td>5</td>
    </tr>
    <tr>
      <th>0</th>
      <td>Ohio</td>
      <td>2000</td>
      <td>0.0</td>
      <td>6</td>
      <td>7</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Ohio</td>
      <td>2001</td>
      <td>1.0</td>
      <td>8</td>
      <td>9</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Ohio</td>
      <td>2002</td>
      <td>2.0</td>
      <td>10</td>
      <td>11</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Nevada</td>
      <td>2001</td>
      <td>3.0</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



同时使用合并双方的索引也没问题：


```python
left2 = pd.DataFrame([[1., 2.], [3., 4.], [5., 6.]],
                     index=['a', 'c', 'e'],
                     columns=['Ohio', 'Nevada'])
left2
```




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
      <th>Ohio</th>
      <th>Nevada</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>1.0</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>c</th>
      <td>3.0</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>e</th>
      <td>5.0</td>
      <td>6.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
right2 = pd.DataFrame([[7., 8.], [9., 10.], [11., 12.], [13, 14]],
                      index=['b', 'c', 'd', 'e'],
                      columns=['Missouri', 'Alabama'])
right2
```




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
      <th>Missouri</th>
      <th>Alabama</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>b</th>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>c</th>
      <td>9.0</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>d</th>
      <td>11.0</td>
      <td>12.0</td>
    </tr>
    <tr>
      <th>e</th>
      <td>13.0</td>
      <td>14.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.merge(left2, right2, how='outer', left_index=True, right_index=True)
```




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
      <th>Ohio</th>
      <th>Nevada</th>
      <th>Missouri</th>
      <th>Alabama</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>1.0</td>
      <td>2.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>b</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>c</th>
      <td>3.0</td>
      <td>4.0</td>
      <td>9.0</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>d</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>11.0</td>
      <td>12.0</td>
    </tr>
    <tr>
      <th>e</th>
      <td>5.0</td>
      <td>6.0</td>
      <td>13.0</td>
      <td>14.0</td>
    </tr>
  </tbody>
</table>
</div>



DataFrame还有一个便捷的join实例方法，它能更为方便地实现按索引合并。它还可用于合并多个带有相同或相似索引的DataFrame对象，但要求没有重叠的列。


```python
left2.join(right2, how='outer')
```




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
      <th>Ohio</th>
      <th>Nevada</th>
      <th>Missouri</th>
      <th>Alabama</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>1.0</td>
      <td>2.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>b</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>c</th>
      <td>3.0</td>
      <td>4.0</td>
      <td>9.0</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>d</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>11.0</td>
      <td>12.0</td>
    </tr>
    <tr>
      <th>e</th>
      <td>5.0</td>
      <td>6.0</td>
      <td>13.0</td>
      <td>14.0</td>
    </tr>
  </tbody>
</table>
</div>



DataFrame的join方法默认使用的是左连接，保留左边表的行索引。它还支持在调用的DataFrame的列上，连接传递的DataFrame索引：


```python
left1.join(right1, on='key')
```




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
      <th>key</th>
      <th>value</th>
      <th>group_val</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>0</td>
      <td>3.5</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>a</td>
      <td>2</td>
      <td>3.5</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a</td>
      <td>3</td>
      <td>3.5</td>
    </tr>
    <tr>
      <th>4</th>
      <td>b</td>
      <td>4</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>c</td>
      <td>5</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



对于简单的索引合并，你还可以向join传入一组DataFrame 


```python
another = pd.DataFrame([[7., 8.], [9., 10.], [11., 12.], [16., 17.]],
                       index=['a', 'c', 'e', 'f'],
                       columns=['New York', 'Oregon'])
another
```




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
      <th>New York</th>
      <th>Oregon</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>c</th>
      <td>9.0</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>e</th>
      <td>11.0</td>
      <td>12.0</td>
    </tr>
    <tr>
      <th>f</th>
      <td>16.0</td>
      <td>17.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
left2.join([right2, another])
```




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
      <th>Ohio</th>
      <th>Nevada</th>
      <th>Missouri</th>
      <th>Alabama</th>
      <th>New York</th>
      <th>Oregon</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>1.0</td>
      <td>2.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>c</th>
      <td>3.0</td>
      <td>4.0</td>
      <td>9.0</td>
      <td>10.0</td>
      <td>9.0</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>e</th>
      <td>5.0</td>
      <td>6.0</td>
      <td>13.0</td>
      <td>14.0</td>
      <td>11.0</td>
      <td>12.0</td>
    </tr>
  </tbody>
</table>
</div>



### 轴向连接

另一种数据合并运算也被称作连接（concatenation）、绑定（binding）或堆叠（stacking）。NumPy的concatenate函数可以用NumPy数组来做：



```python
arr = np.arange(12).reshape((3, 4))
arr
```




    array([[ 0,  1,  2,  3],
           [ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])




```python
np.concatenate([arr, arr], axis=1)
```




    array([[ 0,  1,  2,  3,  0,  1,  2,  3],
           [ 4,  5,  6,  7,  4,  5,  6,  7],
           [ 8,  9, 10, 11,  8,  9, 10, 11]])



对于pandas对象（如Series和DataFrame），带有标签的轴使你能够进一步推广数组的连接运算。  
pandas的concat函数提供了一种能够解决这些问题的可靠方式。


```python
s1 = pd.Series([0, 1], index=['a', 'b'])

s2 = pd.Series([2, 3, 4], index=['c', 'd', 'e'])

s3 = pd.Series([5, 6], index=['f', 'g'])

# 把三个 series 连接在一起
pd.concat([s1, s2, s3])
```




    a    0
    b    1
    c    2
    d    3
    e    4
    f    5
    g    6
    dtype: int64



默认情况下，concat是在axis=0上工作的，最终产生一个新的Series。如果传入axis=1，则结果就会变成一个DataFrame（axis=1是列）：


```python
pd.concat([s1, s2, s3], axis=1)
```

    /usr/local/lib/python3.6/site-packages/ipykernel_launcher.py:1: FutureWarning: Sorting because non-concatenation axis is not aligned. A future version
    of pandas will change to not sort by default.
    
    To accept the future behavior, pass 'sort=False'.
    
    To retain the current behavior and silence the warning, pass 'sort=True'.
    
      """Entry point for launching an IPython kernel.
    




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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>b</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>c</th>
      <td>NaN</td>
      <td>2.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>d</th>
      <td>NaN</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>e</th>
      <td>NaN</td>
      <td>4.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>f</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>g</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>6.0</td>
    </tr>
  </tbody>
</table>
</div>



这种情况下，另外的轴上没有重叠，从索引的有序并集（外连接）上就可以看出来。传入join='inner'即可得到它们的交集：


```python
s4 = pd.concat([s1, s3])
s4
```




    a    0
    b    1
    f    5
    g    6
    dtype: int64




```python
pd.concat([s1, s4], axis=1)
```

    /usr/local/lib/python3.6/site-packages/ipykernel_launcher.py:1: FutureWarning: Sorting because non-concatenation axis is not aligned. A future version
    of pandas will change to not sort by default.
    
    To accept the future behavior, pass 'sort=False'.
    
    To retain the current behavior and silence the warning, pass 'sort=True'.
    
      """Entry point for launching an IPython kernel.
    




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
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>b</th>
      <td>1.0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>f</th>
      <td>NaN</td>
      <td>5</td>
    </tr>
    <tr>
      <th>g</th>
      <td>NaN</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.concat([s1, s4], axis=1, join='inner')
```




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
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>b</th>
      <td>1</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



通过 join_axes 指定要在其它轴上使用的索引：


```python
pd.concat([s1, s4], axis=1, join_axes=[['a', 'c', 'b', 'e']])
```




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
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>c</th>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>b</th>
      <td>1.0</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>e</th>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



不过有个问题，参与连接的片段在结果中区分不开。假设你想要在连接轴上创建一个层次化索引。使用keys参数即可达到这个目的：


```python
result = pd.concat([s1, s1, s3], keys=['one','two', 'three'])
result
```




    one    a    0
           b    1
    two    a    0
           b    1
    three  f    5
           g    6
    dtype: int64




```python
result.unstack()
```




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
      <th>a</th>
      <th>b</th>
      <th>f</th>
      <th>g</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>0.0</td>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>two</th>
      <td>0.0</td>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>three</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>5.0</td>
      <td>6.0</td>
    </tr>
  </tbody>
</table>
</div>



如果沿着 `axis=1` 对Series进行合并，则keys就会成为DataFrame的列头：


```python
pd.concat([s1, s2, s3], axis=1, keys=['one','two', 'three'], sort=True)
```




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
      <th>one</th>
      <th>two</th>
      <th>three</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>b</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>c</th>
      <td>NaN</td>
      <td>2.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>d</th>
      <td>NaN</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>e</th>
      <td>NaN</td>
      <td>4.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>f</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>g</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>6.0</td>
    </tr>
  </tbody>
</table>
</div>



同样的逻辑也适用于DataFrame对象：


```python
df1 = pd.DataFrame(np.arange(6).reshape(3, 2), index=['a', 'b', 'c'], columns=['one', 'two'])
df1
```




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
      <th>one</th>
      <th>two</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>b</th>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>c</th>
      <td>4</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>




```python
df2 = pd.DataFrame(5 + np.arange(4).reshape(2, 2), index=['a', 'c'], columns=['three', 'four'])
df2
```




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
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>5</td>
      <td>6</td>
    </tr>
    <tr>
      <th>c</th>
      <td>7</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.concat([df1, df2], axis=1, keys=['level1', 'level2'], sort = False)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="2" halign="left">level1</th>
      <th colspan="2" halign="left">level2</th>
    </tr>
    <tr>
      <th></th>
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0</td>
      <td>1</td>
      <td>5.0</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>b</th>
      <td>2</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>c</th>
      <td>4</td>
      <td>5</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
  </tbody>
</table>
</div>



如果传入的不是列表而是一个字典，则字典的键就会被当做keys选项的值：


```python
pd.concat({'level1': df1, 'level2': df2}, axis=1, sort = False)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="2" halign="left">level1</th>
      <th colspan="2" halign="left">level2</th>
    </tr>
    <tr>
      <th></th>
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0</td>
      <td>1</td>
      <td>5.0</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>b</th>
      <td>2</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>c</th>
      <td>4</td>
      <td>5</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
  </tbody>
</table>
</div>



我们可以用names参数命名创建的轴级别：


```python
pd.concat([df1, df2], axis=1, keys=['level1', 'level2'], names=['upper', 'lower'], sort = False)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th>upper</th>
      <th colspan="2" halign="left">level1</th>
      <th colspan="2" halign="left">level2</th>
    </tr>
    <tr>
      <th>lower</th>
      <th>one</th>
      <th>two</th>
      <th>three</th>
      <th>four</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0</td>
      <td>1</td>
      <td>5.0</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>b</th>
      <td>2</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>c</th>
      <td>4</td>
      <td>5</td>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
  </tbody>
</table>
</div>



DataFrame 在连接的时候会使用原来的索引，可以通过 `ignore_index=True` 来放弃使用  


```python
df1 = pd.DataFrame(np.random.randn(3, 4), columns=['a', 'b', 'c', 'd'])
df1
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-1.044321</td>
      <td>-0.049004</td>
      <td>0.026555</td>
      <td>-0.315565</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.085761</td>
      <td>0.873464</td>
      <td>-1.368797</td>
      <td>0.302554</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.277496</td>
      <td>-0.570469</td>
      <td>-0.606294</td>
      <td>1.253497</td>
    </tr>
  </tbody>
</table>
</div>




```python
df2 = pd.DataFrame(np.random.randn(2, 3), columns=['b', 'd', 'a'])
df2
```




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
      <th>b</th>
      <th>d</th>
      <th>a</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.343570</td>
      <td>-0.310123</td>
      <td>-0.379563</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-1.083807</td>
      <td>-1.480836</td>
      <td>-1.255112</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.concat([df1, df2], sort = False)
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-1.044321</td>
      <td>-0.049004</td>
      <td>0.026555</td>
      <td>-0.315565</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.085761</td>
      <td>0.873464</td>
      <td>-1.368797</td>
      <td>0.302554</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.277496</td>
      <td>-0.570469</td>
      <td>-0.606294</td>
      <td>1.253497</td>
    </tr>
    <tr>
      <th>0</th>
      <td>-0.379563</td>
      <td>0.343570</td>
      <td>NaN</td>
      <td>-0.310123</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-1.255112</td>
      <td>-1.083807</td>
      <td>NaN</td>
      <td>-1.480836</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.concat([df1, df2], ignore_index=True, sort = False)
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-1.044321</td>
      <td>-0.049004</td>
      <td>0.026555</td>
      <td>-0.315565</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.085761</td>
      <td>0.873464</td>
      <td>-1.368797</td>
      <td>0.302554</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.277496</td>
      <td>-0.570469</td>
      <td>-0.606294</td>
      <td>1.253497</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-0.379563</td>
      <td>0.343570</td>
      <td>NaN</td>
      <td>-0.310123</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-1.255112</td>
      <td>-1.083807</td>
      <td>NaN</td>
      <td>-1.480836</td>
    </tr>
  </tbody>
</table>
</div>



concat函数的参数  
![concat函数的参数](http://upload-images.jianshu.io/upload_images/7178691-339436563b519415.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### 合并重叠数据

还有一种数据组合问题不能用简单的合并（merge）或连接（concatenation）运算来处理。比如说，你可能有索引全部或部分重叠的两个数据集。举个有启发性的例子，我们使用NumPy的where函数，它表示一种等价于面向数组的if-else：

就是用一个数据组合来填充另一个数据组合的空值


```python
a = pd.Series([np.nan, 2.5, np.nan, 3.5, 4.5, np.nan], index=['f', 'e', 'd', 'c', 'b', 'a'])

b = pd.Series(np.arange(len(a), dtype=np.float64), index=['f', 'e', 'd', 'c', 'b', 'a'])
b[-1] = np.nan

a
```




    f    NaN
    e    2.5
    d    NaN
    c    3.5
    b    4.5
    a    NaN
    dtype: float64




```python
b
```




    f    0.0
    e    1.0
    d    2.0
    c    3.0
    b    4.0
    a    NaN
    dtype: float64




```python
np.where(pd.isnull(a), b, a)
```




    array([0. , 2.5, 2. , 3.5, 4.5, nan])



Series 和 DataFrame 有一个 combine_first 方法，实现的也是一样的功能，还带有pandas的数据对齐：


```python
b[:-2].combine_first(a[2:])
```




    a    NaN
    b    4.5
    c    3.0
    d    2.0
    e    1.0
    f    0.0
    dtype: float64




```python
df1 = pd.DataFrame({'a': [1., np.nan, 5., np.nan],
                    'b': [np.nan, 2., np.nan, 6.],
                    'c': range(2, 18, 4)})
df1
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>2</td>
    </tr>
    <tr>
      <th>1</th>
      <td>NaN</td>
      <td>2.0</td>
      <td>6</td>
    </tr>
    <tr>
      <th>2</th>
      <td>5.0</td>
      <td>NaN</td>
      <td>10</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>6.0</td>
      <td>14</td>
    </tr>
  </tbody>
</table>
</div>




```python
df2 = pd.DataFrame({'a': [5., 4., np.nan, 3., 7.],
                    'b': [np.nan, 3., 4., 6., 8.]})
df2
```




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
      <th>a</th>
      <th>b</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>5.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4.0</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3.0</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>7.0</td>
      <td>8.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
df1.combine_first(df2)
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4.0</td>
      <td>2.0</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>5.0</td>
      <td>4.0</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3.0</td>
      <td>6.0</td>
      <td>14.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>7.0</td>
      <td>8.0</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



## 重塑和轴向旋转

有许多用于重新排列表格型数据的基础运算。这些函数也称作重塑（reshape）或轴向旋转（pivot）运算。


### 重塑层次化索引

层次化索引为DataFrame数据的重排任务提供了一种具有良好一致性的方式。主要功能有二：
1. stack：将数据的列“旋转”为行。
2. unstack：将数据的行“旋转”为列。



```python
data = pd.DataFrame(np.arange(6).reshape((2, 3)),
                    index=pd.Index(['Ohio','Colorado'], name='state'),
                    columns=pd.Index(['one', 'two', 'three'], name='number'))
data
```




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
      <th>number</th>
      <th>one</th>
      <th>two</th>
      <th>three</th>
    </tr>
    <tr>
      <th>state</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>



对该数据使用stack方法即可将列转换为行，得到一个Series：


```python
result = data.stack()
result
```




    state     number
    Ohio      one       0
              two       1
              three     2
    Colorado  one       3
              two       4
              three     5
    dtype: int64



对于一个层次化索引的Series，你可以用unstack将其重排为一个DataFrame：


```python
result.unstack()
```




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
      <th>number</th>
      <th>one</th>
      <th>two</th>
      <th>three</th>
    </tr>
    <tr>
      <th>state</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ohio</th>
      <td>0</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>Colorado</th>
      <td>3</td>
      <td>4</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>



默认情况下，unstack操作的是最内层（stack也是如此）。传入分层级别的编号或名称即可对其它级别进行unstack操作：


```python
result.unstack(0)
```




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
      <th>state</th>
      <th>Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th>number</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>two</th>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>three</th>
      <td>2</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>




```python
result.unstack('state')
```




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
      <th>state</th>
      <th>Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th>number</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>two</th>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>three</th>
      <td>2</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>



如果不是所有的级别值都能在各分组中找到的话，则unstack操作可能会引入缺失数据：


```python
s1 = pd.Series([0, 1, 2, 3], index=['a', 'b', 'c', 'd'])

s2 = pd.Series([4, 5, 6], index=['c', 'd', 'e'])

data2 = pd.concat([s1, s2], keys=['one', 'two'])
data2
```




    one  a    0
         b    1
         c    2
         d    3
    two  c    4
         d    5
         e    6
    dtype: int64




```python
data2.unstack()
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>0.0</td>
      <td>1.0</td>
      <td>2.0</td>
      <td>3.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>two</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>4.0</td>
      <td>5.0</td>
      <td>6.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
data2.unstack().stack()
```




    one  a    0.0
         b    1.0
         c    2.0
         d    3.0
    two  c    4.0
         d    5.0
         e    6.0
    dtype: float64




```python
# 保留 nan 数据
data2.unstack().stack(dropna=False)
```




    one  a    0.0
         b    1.0
         c    2.0
         d    3.0
         e    NaN
    two  a    NaN
         b    NaN
         c    4.0
         d    5.0
         e    6.0
    dtype: float64



在对DataFrame进行unstack操作时，作为旋转轴的级别将会成为结果中的最低级别：


```python
df = pd.DataFrame({'left': result, 'right': result + 5},
                  columns=pd.Index(['left', 'right'], name='side'))
df
```




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
      <th>side</th>
      <th>left</th>
      <th>right</th>
    </tr>
    <tr>
      <th>state</th>
      <th>number</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="3" valign="top">Ohio</th>
      <th>one</th>
      <td>0</td>
      <td>5</td>
    </tr>
    <tr>
      <th>two</th>
      <td>1</td>
      <td>6</td>
    </tr>
    <tr>
      <th>three</th>
      <td>2</td>
      <td>7</td>
    </tr>
    <tr>
      <th rowspan="3" valign="top">Colorado</th>
      <th>one</th>
      <td>3</td>
      <td>8</td>
    </tr>
    <tr>
      <th>two</th>
      <td>4</td>
      <td>9</td>
    </tr>
    <tr>
      <th>three</th>
      <td>5</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>




```python
# state 列转换成行的时候，行的级别是最低的(在 side 下面)
df.unstack('state')
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th>side</th>
      <th colspan="2" halign="left">left</th>
      <th colspan="2" halign="left">right</th>
    </tr>
    <tr>
      <th>state</th>
      <th>Ohio</th>
      <th>Colorado</th>
      <th>Ohio</th>
      <th>Colorado</th>
    </tr>
    <tr>
      <th>number</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>one</th>
      <td>0</td>
      <td>3</td>
      <td>5</td>
      <td>8</td>
    </tr>
    <tr>
      <th>two</th>
      <td>1</td>
      <td>4</td>
      <td>6</td>
      <td>9</td>
    </tr>
    <tr>
      <th>three</th>
      <td>2</td>
      <td>5</td>
      <td>7</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>



当调用stack，我们可以指明轴的名字：


```python
df.unstack('state').stack('side')
```




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
      <th>state</th>
      <th>Colorado</th>
      <th>Ohio</th>
    </tr>
    <tr>
      <th>number</th>
      <th>side</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">one</th>
      <th>left</th>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>right</th>
      <td>8</td>
      <td>5</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">two</th>
      <th>left</th>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>right</th>
      <td>9</td>
      <td>6</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">three</th>
      <th>left</th>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>right</th>
      <td>10</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>



### 将“长格式”旋转为“宽格式”

多个时间序列数据通常是以所谓的“长格式”（long）或“堆叠格式”（stacked）存储在数据库和CSV中的。


```python
data = pd.read_csv('data/examples/macrodata.csv')
data.head()
```




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
      <th>year</th>
      <th>quarter</th>
      <th>realgdp</th>
      <th>realcons</th>
      <th>realinv</th>
      <th>realgovt</th>
      <th>realdpi</th>
      <th>cpi</th>
      <th>m1</th>
      <th>tbilrate</th>
      <th>unemp</th>
      <th>pop</th>
      <th>infl</th>
      <th>realint</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1959.0</td>
      <td>1.0</td>
      <td>2710.349</td>
      <td>1707.4</td>
      <td>286.898</td>
      <td>470.045</td>
      <td>1886.9</td>
      <td>28.98</td>
      <td>139.7</td>
      <td>2.82</td>
      <td>5.8</td>
      <td>177.146</td>
      <td>0.00</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1959.0</td>
      <td>2.0</td>
      <td>2778.801</td>
      <td>1733.7</td>
      <td>310.859</td>
      <td>481.301</td>
      <td>1919.7</td>
      <td>29.15</td>
      <td>141.7</td>
      <td>3.08</td>
      <td>5.1</td>
      <td>177.830</td>
      <td>2.34</td>
      <td>0.74</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1959.0</td>
      <td>3.0</td>
      <td>2775.488</td>
      <td>1751.8</td>
      <td>289.226</td>
      <td>491.260</td>
      <td>1916.4</td>
      <td>29.35</td>
      <td>140.5</td>
      <td>3.82</td>
      <td>5.3</td>
      <td>178.657</td>
      <td>2.74</td>
      <td>1.09</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1959.0</td>
      <td>4.0</td>
      <td>2785.204</td>
      <td>1753.7</td>
      <td>299.356</td>
      <td>484.052</td>
      <td>1931.3</td>
      <td>29.37</td>
      <td>140.0</td>
      <td>4.33</td>
      <td>5.6</td>
      <td>179.386</td>
      <td>0.27</td>
      <td>4.06</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1960.0</td>
      <td>1.0</td>
      <td>2847.699</td>
      <td>1770.5</td>
      <td>331.722</td>
      <td>462.199</td>
      <td>1955.5</td>
      <td>29.54</td>
      <td>139.6</td>
      <td>3.50</td>
      <td>5.2</td>
      <td>180.007</td>
      <td>2.31</td>
      <td>1.19</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 使用几个时间列拼接成一个时间索引
periods = pd.PeriodIndex(year=data.year, quarter=data.quarter, name='date')
periods
```




    PeriodIndex(['1959Q1', '1959Q2', '1959Q3', '1959Q4', '1960Q1', '1960Q2',
                 '1960Q3', '1960Q4', '1961Q1', '1961Q2',
                 ...
                 '2007Q2', '2007Q3', '2007Q4', '2008Q1', '2008Q2', '2008Q3',
                 '2008Q4', '2009Q1', '2009Q2', '2009Q3'],
                dtype='period[Q-DEC]', name='date', length=203, freq='Q-DEC')




```python
# 创建索引
columns = pd.Index(['realgdp', 'infl', 'unemp'], name='item')
columns
```




    Index(['realgdp', 'infl', 'unemp'], dtype='object', name='item')




```python
# 选取索引中的那几列
data = data.reindex(columns=columns)
data.head()
```




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
      <th>item</th>
      <th>realgdp</th>
      <th>infl</th>
      <th>unemp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2710.349</td>
      <td>0.00</td>
      <td>5.8</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2778.801</td>
      <td>2.34</td>
      <td>5.1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2775.488</td>
      <td>2.74</td>
      <td>5.3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2785.204</td>
      <td>0.27</td>
      <td>5.6</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2847.699</td>
      <td>2.31</td>
      <td>5.2</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 把索引赋值成时间索引
data.index = periods.to_timestamp('D', 'end')
data.head()
```




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
      <th>item</th>
      <th>realgdp</th>
      <th>infl</th>
      <th>unemp</th>
    </tr>
    <tr>
      <th>date</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1959-03-31 23:59:59.999999999</th>
      <td>2710.349</td>
      <td>0.00</td>
      <td>5.8</td>
    </tr>
    <tr>
      <th>1959-06-30 23:59:59.999999999</th>
      <td>2778.801</td>
      <td>2.34</td>
      <td>5.1</td>
    </tr>
    <tr>
      <th>1959-09-30 23:59:59.999999999</th>
      <td>2775.488</td>
      <td>2.74</td>
      <td>5.3</td>
    </tr>
    <tr>
      <th>1959-12-31 23:59:59.999999999</th>
      <td>2785.204</td>
      <td>0.27</td>
      <td>5.6</td>
    </tr>
    <tr>
      <th>1960-03-31 23:59:59.999999999</th>
      <td>2847.699</td>
      <td>2.31</td>
      <td>5.2</td>
    </tr>
  </tbody>
</table>
</div>



这就是多个时间序列（或者其它带有两个或多个键的可观察数据，这里，我们的键是date和item）的长格式。表中的每行代表一次观察。


```python
ldata = data.stack().reset_index().rename(columns={0: 'value'})
ldata.head()
```




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
      <th>date</th>
      <th>item</th>
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1959-03-31 23:59:59.999999999</td>
      <td>realgdp</td>
      <td>2710.349</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1959-03-31 23:59:59.999999999</td>
      <td>infl</td>
      <td>0.000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1959-03-31 23:59:59.999999999</td>
      <td>unemp</td>
      <td>5.800</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1959-06-30 23:59:59.999999999</td>
      <td>realgdp</td>
      <td>2778.801</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1959-06-30 23:59:59.999999999</td>
      <td>infl</td>
      <td>2.340</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.stack().head()
```




    date                           item   
    1959-03-31 23:59:59.999999999  realgdp    2710.349
                                   infl          0.000
                                   unemp         5.800
    1959-06-30 23:59:59.999999999  realgdp    2778.801
                                   infl          2.340
    dtype: float64




```python
data.stack().reset_index().head()
```




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
      <th>date</th>
      <th>item</th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1959-03-31 23:59:59.999999999</td>
      <td>realgdp</td>
      <td>2710.349</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1959-03-31 23:59:59.999999999</td>
      <td>infl</td>
      <td>0.000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1959-03-31 23:59:59.999999999</td>
      <td>unemp</td>
      <td>5.800</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1959-06-30 23:59:59.999999999</td>
      <td>realgdp</td>
      <td>2778.801</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1959-06-30 23:59:59.999999999</td>
      <td>infl</td>
      <td>2.340</td>
    </tr>
  </tbody>
</table>
</div>



关系型数据库（如MySQL）中的数据经常都是这样存储的，因为固定架构（即列名和数据类型）有一个好处：随着表中数据的添加，item列中的值的种类能够增加。在前面的例子中，date和item通常就是主键（用关系型数据库的说法），不仅提供了关系完整性，而且提供了更为简单的查询支持。有的情况下，使用这样的数据会很麻烦，你可能会更喜欢DataFrame，不同的item值分别形成一列，date列中的时间戳则用作索引。DataFrame的pivot方法完全可以实现这个转换：


```python
pivoted = ldata.pivot('date', 'item', 'value')
pivoted.head()
```




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
      <th>item</th>
      <th>infl</th>
      <th>realgdp</th>
      <th>unemp</th>
    </tr>
    <tr>
      <th>date</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1959-03-31 23:59:59.999999999</th>
      <td>0.00</td>
      <td>2710.349</td>
      <td>5.8</td>
    </tr>
    <tr>
      <th>1959-06-30 23:59:59.999999999</th>
      <td>2.34</td>
      <td>2778.801</td>
      <td>5.1</td>
    </tr>
    <tr>
      <th>1959-09-30 23:59:59.999999999</th>
      <td>2.74</td>
      <td>2775.488</td>
      <td>5.3</td>
    </tr>
    <tr>
      <th>1959-12-31 23:59:59.999999999</th>
      <td>0.27</td>
      <td>2785.204</td>
      <td>5.6</td>
    </tr>
    <tr>
      <th>1960-03-31 23:59:59.999999999</th>
      <td>2.31</td>
      <td>2847.699</td>
      <td>5.2</td>
    </tr>
  </tbody>
</table>
</div>



前两个传递的值分别用作行和列索引，最后一个可选值则是用于填充DataFrame的数据列。假设有两个需要同时重塑的数据列：

如果忽略最后一个参数，得到的DataFrame就会带有层次化的列：


```python
ldata.pivot('date', 'item').head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">value</th>
    </tr>
    <tr>
      <th>item</th>
      <th>infl</th>
      <th>realgdp</th>
      <th>unemp</th>
    </tr>
    <tr>
      <th>date</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1959-03-31 23:59:59.999999999</th>
      <td>0.00</td>
      <td>2710.349</td>
      <td>5.8</td>
    </tr>
    <tr>
      <th>1959-06-30 23:59:59.999999999</th>
      <td>2.34</td>
      <td>2778.801</td>
      <td>5.1</td>
    </tr>
    <tr>
      <th>1959-09-30 23:59:59.999999999</th>
      <td>2.74</td>
      <td>2775.488</td>
      <td>5.3</td>
    </tr>
    <tr>
      <th>1959-12-31 23:59:59.999999999</th>
      <td>0.27</td>
      <td>2785.204</td>
      <td>5.6</td>
    </tr>
    <tr>
      <th>1960-03-31 23:59:59.999999999</th>
      <td>2.31</td>
      <td>2847.699</td>
      <td>5.2</td>
    </tr>
  </tbody>
</table>
</div>




```python
ldata['value2'] = np.random.randn(len(ldata))
ldata.head()
```




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
      <th>date</th>
      <th>item</th>
      <th>value</th>
      <th>value2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1959-03-31 23:59:59.999999999</td>
      <td>realgdp</td>
      <td>2710.349</td>
      <td>0.363946</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1959-03-31 23:59:59.999999999</td>
      <td>infl</td>
      <td>0.000</td>
      <td>-0.287075</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1959-03-31 23:59:59.999999999</td>
      <td>unemp</td>
      <td>5.800</td>
      <td>0.144127</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1959-06-30 23:59:59.999999999</td>
      <td>realgdp</td>
      <td>2778.801</td>
      <td>-0.491877</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1959-06-30 23:59:59.999999999</td>
      <td>infl</td>
      <td>2.340</td>
      <td>0.725936</td>
    </tr>
  </tbody>
</table>
</div>




```python
ldata.pivot('date', 'item').head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">value</th>
      <th colspan="3" halign="left">value2</th>
    </tr>
    <tr>
      <th>item</th>
      <th>infl</th>
      <th>realgdp</th>
      <th>unemp</th>
      <th>infl</th>
      <th>realgdp</th>
      <th>unemp</th>
    </tr>
    <tr>
      <th>date</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1959-03-31 23:59:59.999999999</th>
      <td>0.00</td>
      <td>2710.349</td>
      <td>5.8</td>
      <td>-0.287075</td>
      <td>0.363946</td>
      <td>0.144127</td>
    </tr>
    <tr>
      <th>1959-06-30 23:59:59.999999999</th>
      <td>2.34</td>
      <td>2778.801</td>
      <td>5.1</td>
      <td>0.725936</td>
      <td>-0.491877</td>
      <td>0.026073</td>
    </tr>
    <tr>
      <th>1959-09-30 23:59:59.999999999</th>
      <td>2.74</td>
      <td>2775.488</td>
      <td>5.3</td>
      <td>1.025040</td>
      <td>0.144513</td>
      <td>-1.524801</td>
    </tr>
    <tr>
      <th>1959-12-31 23:59:59.999999999</th>
      <td>0.27</td>
      <td>2785.204</td>
      <td>5.6</td>
      <td>0.530287</td>
      <td>-1.027258</td>
      <td>-0.158004</td>
    </tr>
    <tr>
      <th>1960-03-31 23:59:59.999999999</th>
      <td>2.31</td>
      <td>2847.699</td>
      <td>5.2</td>
      <td>-0.476289</td>
      <td>0.037717</td>
      <td>1.186384</td>
    </tr>
  </tbody>
</table>
</div>




```python
ldata.pivot('date', 'item', ['value', 'value2']).head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">value</th>
      <th colspan="3" halign="left">value2</th>
    </tr>
    <tr>
      <th>item</th>
      <th>infl</th>
      <th>realgdp</th>
      <th>unemp</th>
      <th>infl</th>
      <th>realgdp</th>
      <th>unemp</th>
    </tr>
    <tr>
      <th>date</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1959-03-31 23:59:59.999999999</th>
      <td>0.00</td>
      <td>2710.349</td>
      <td>5.8</td>
      <td>-0.287075</td>
      <td>0.363946</td>
      <td>0.144127</td>
    </tr>
    <tr>
      <th>1959-06-30 23:59:59.999999999</th>
      <td>2.34</td>
      <td>2778.801</td>
      <td>5.1</td>
      <td>0.725936</td>
      <td>-0.491877</td>
      <td>0.026073</td>
    </tr>
    <tr>
      <th>1959-09-30 23:59:59.999999999</th>
      <td>2.74</td>
      <td>2775.488</td>
      <td>5.3</td>
      <td>1.025040</td>
      <td>0.144513</td>
      <td>-1.524801</td>
    </tr>
    <tr>
      <th>1959-12-31 23:59:59.999999999</th>
      <td>0.27</td>
      <td>2785.204</td>
      <td>5.6</td>
      <td>0.530287</td>
      <td>-1.027258</td>
      <td>-0.158004</td>
    </tr>
    <tr>
      <th>1960-03-31 23:59:59.999999999</th>
      <td>2.31</td>
      <td>2847.699</td>
      <td>5.2</td>
      <td>-0.476289</td>
      <td>0.037717</td>
      <td>1.186384</td>
    </tr>
  </tbody>
</table>
</div>



pivot其实就是用set_index创建层次化索引，再用unstack重塑：


```python
unstacked = ldata.set_index(['date', 'item']).unstack('item')
unstacked.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">value</th>
      <th colspan="3" halign="left">value2</th>
    </tr>
    <tr>
      <th>item</th>
      <th>infl</th>
      <th>realgdp</th>
      <th>unemp</th>
      <th>infl</th>
      <th>realgdp</th>
      <th>unemp</th>
    </tr>
    <tr>
      <th>date</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1959-03-31 23:59:59.999999999</th>
      <td>0.00</td>
      <td>2710.349</td>
      <td>5.8</td>
      <td>-0.287075</td>
      <td>0.363946</td>
      <td>0.144127</td>
    </tr>
    <tr>
      <th>1959-06-30 23:59:59.999999999</th>
      <td>2.34</td>
      <td>2778.801</td>
      <td>5.1</td>
      <td>0.725936</td>
      <td>-0.491877</td>
      <td>0.026073</td>
    </tr>
    <tr>
      <th>1959-09-30 23:59:59.999999999</th>
      <td>2.74</td>
      <td>2775.488</td>
      <td>5.3</td>
      <td>1.025040</td>
      <td>0.144513</td>
      <td>-1.524801</td>
    </tr>
    <tr>
      <th>1959-12-31 23:59:59.999999999</th>
      <td>0.27</td>
      <td>2785.204</td>
      <td>5.6</td>
      <td>0.530287</td>
      <td>-1.027258</td>
      <td>-0.158004</td>
    </tr>
    <tr>
      <th>1960-03-31 23:59:59.999999999</th>
      <td>2.31</td>
      <td>2847.699</td>
      <td>5.2</td>
      <td>-0.476289</td>
      <td>0.037717</td>
      <td>1.186384</td>
    </tr>
  </tbody>
</table>
</div>



### 将“宽格式”旋转为“长格式”

旋转DataFrame的逆运算是pandas.melt。它不是将一列转换到多个新的DataFrame，而是合并多个列成为一个，产生一个比输入长的DataFrame。


```python
df = pd.DataFrame({'key': ['foo', 'bar', 'baz'],
                   'A': [1, 2, 3],
                   'B': [4, 5, 6],
                   'C': [7, 8, 9]})
df
```




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
      <th>key</th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>1</td>
      <td>4</td>
      <td>7</td>
    </tr>
    <tr>
      <th>1</th>
      <td>bar</td>
      <td>2</td>
      <td>5</td>
      <td>8</td>
    </tr>
    <tr>
      <th>2</th>
      <td>baz</td>
      <td>3</td>
      <td>6</td>
      <td>9</td>
    </tr>
  </tbody>
</table>
</div>



key列可能是分组指标，其它的列是数据值。当使用pandas.melt，我们必须指明哪些列是分组指标。下面使用key作为唯一的分组指标：



```python
melted = pd.melt(df, ['key'])
melted
```




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
      <th>key</th>
      <th>variable</th>
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>A</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>bar</td>
      <td>A</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>baz</td>
      <td>A</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>foo</td>
      <td>B</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>bar</td>
      <td>B</td>
      <td>5</td>
    </tr>
    <tr>
      <th>5</th>
      <td>baz</td>
      <td>B</td>
      <td>6</td>
    </tr>
    <tr>
      <th>6</th>
      <td>foo</td>
      <td>C</td>
      <td>7</td>
    </tr>
    <tr>
      <th>7</th>
      <td>bar</td>
      <td>C</td>
      <td>8</td>
    </tr>
    <tr>
      <th>8</th>
      <td>baz</td>
      <td>C</td>
      <td>9</td>
    </tr>
  </tbody>
</table>
</div>



使用pivot，可以重塑回原来的样子：


```python
reshaped = melted.pivot('key', 'variable', 'value')
reshaped
```




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
      <th>variable</th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
    <tr>
      <th>key</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>bar</th>
      <td>2</td>
      <td>5</td>
      <td>8</td>
    </tr>
    <tr>
      <th>baz</th>
      <td>3</td>
      <td>6</td>
      <td>9</td>
    </tr>
    <tr>
      <th>foo</th>
      <td>1</td>
      <td>4</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>



因为pivot的结果从列创建了一个索引，用作行标签，我们可以使用reset_index将数据移回列：


```python
reshaped.reset_index()
```




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
      <th>variable</th>
      <th>key</th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>bar</td>
      <td>2</td>
      <td>5</td>
      <td>8</td>
    </tr>
    <tr>
      <th>1</th>
      <td>baz</td>
      <td>3</td>
      <td>6</td>
      <td>9</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>1</td>
      <td>4</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>



还可以指定列的子集，作为值的列：


```python
pd.melt(df, id_vars=['key'], value_vars=['A', 'B'])
```




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
      <th>key</th>
      <th>variable</th>
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>A</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>bar</td>
      <td>A</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>baz</td>
      <td>A</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>foo</td>
      <td>B</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>bar</td>
      <td>B</td>
      <td>5</td>
    </tr>
    <tr>
      <th>5</th>
      <td>baz</td>
      <td>B</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
</div>



pandas.melt也可以不用分组指标：


```python
pd.melt(df, value_vars=['A', 'B', 'C'])
```




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
      <th>variable</th>
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>A</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>A</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>A</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>B</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>B</td>
      <td>5</td>
    </tr>
    <tr>
      <th>5</th>
      <td>B</td>
      <td>6</td>
    </tr>
    <tr>
      <th>6</th>
      <td>C</td>
      <td>7</td>
    </tr>
    <tr>
      <th>7</th>
      <td>C</td>
      <td>8</td>
    </tr>
    <tr>
      <th>8</th>
      <td>C</td>
      <td>9</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.melt(df, value_vars=['key', 'A', 'B'])
```




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
      <th>variable</th>
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>key</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>1</th>
      <td>key</td>
      <td>bar</td>
    </tr>
    <tr>
      <th>2</th>
      <td>key</td>
      <td>baz</td>
    </tr>
    <tr>
      <th>3</th>
      <td>A</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>A</td>
      <td>2</td>
    </tr>
    <tr>
      <th>5</th>
      <td>A</td>
      <td>3</td>
    </tr>
    <tr>
      <th>6</th>
      <td>B</td>
      <td>4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>B</td>
      <td>5</td>
    </tr>
    <tr>
      <th>8</th>
      <td>B</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
</div>



# 数据聚合与分组运算

关系型数据库和SQL（Structured Query Language，结构化查询语言）能够如此流行的原因之一就是其能够方便地对数据进行连接、过滤、转换和聚合。但是，像SQL这样的查询语言所能执行的分组运算的种类很有限。在本章中你将会看到，由于Python和pandas强大的表达能力，我们可以执行复杂得多的分组运算（利用任何可以接受pandas对象或NumPy数组的函数）。

## GroupBy机制

Hadley Wickham（许多热门R语言包的作者）创造了一个用于表示分组运算的术语"split-apply-combine"（拆分－应用－合并）。第一个阶段，pandas对象（无论是Series、DataFrame还是其他的）中的数据会根据你所提供的一个或多个键被拆分（split）为多组。拆分操作是在对象的特定轴上执行的。例如，DataFrame可以在其行（axis=0）或列（axis=1）上进行分组。然后，将一个函数应用（apply）到各个分组并产生一个新值。最后，所有这些函数的执行结果会被合并（combine）到最终的结果对象中。结果对象的形式一般取决于数据上所执行的操作。图10-1大致说明了一个简单的分组聚合过程。
![图10-1](http://upload-images.jianshu.io/upload_images/7178691-e5c671e09ecf94be.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)


```python
df = pd.DataFrame({'key1' : ['a', 'a', 'b', 'b', 'a'],
                   'key2' : ['one', 'two', 'one', 'two', 'one'],
                  'data1' : np.random.randn(5),
                  'data2' : np.random.randn(5)})
df
```




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
      <th>key1</th>
      <th>key2</th>
      <th>data1</th>
      <th>data2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>one</td>
      <td>1.192962</td>
      <td>-1.675544</td>
    </tr>
    <tr>
      <th>1</th>
      <td>a</td>
      <td>two</td>
      <td>1.295617</td>
      <td>-0.621154</td>
    </tr>
    <tr>
      <th>2</th>
      <td>b</td>
      <td>one</td>
      <td>2.506938</td>
      <td>-0.954289</td>
    </tr>
    <tr>
      <th>3</th>
      <td>b</td>
      <td>two</td>
      <td>-0.503276</td>
      <td>-0.698834</td>
    </tr>
    <tr>
      <th>4</th>
      <td>a</td>
      <td>one</td>
      <td>-0.204452</td>
      <td>0.767441</td>
    </tr>
  </tbody>
</table>
</div>



假设你想要按key1进行分组，并计算data1列的平均值。实现该功能的方式有很多，而我们这里要用的是：访问data1，并根据key1调用groupby：


```python
grouped = df['data1'].groupby(df['key1'])
grouped
```




    <pandas.core.groupby.groupby.SeriesGroupBy object at 0x00000000080736D8>



变量 `grouped` 是一个 `GroupBy` 对象。它实际上还没有进行任何计算，只是含有一些有关分组键 `df['key1']` 的中间数据而已。换句话说，该对象已经有了接下来对各分组执行运算所需的一切信息。例如，我们可以调用 `GroupBy` 的 `mean` 方法来计算分组平均值：


```python
grouped.mean()
```




    key1
    a    0.761376
    b    1.001831
    Name: data1, dtype: float64



数据（Series）根据分组键进行了聚合，产生了一个新的Series，其索引为key1列中的唯一值。之所以结果中索引的名称为key1，是因为原始DataFrame的列df['key1']就叫这个名字。

使用多个分组字段  


```python
means = df['data1'].groupby([df['key1'], df['key2']]).mean()
means
```




    key1  key2
    a     one     0.494255
          two     1.295617
    b     one     2.506938
          two    -0.503276
    Name: data1, dtype: float64



这里，我通过两个键对数据进行了分组，得到的Series具有一个层次化索引（由唯一的键对组成）


```python
means.unstack()
```




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
      <th>key2</th>
      <th>one</th>
      <th>two</th>
    </tr>
    <tr>
      <th>key1</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.494255</td>
      <td>1.295617</td>
    </tr>
    <tr>
      <th>b</th>
      <td>2.506938</td>
      <td>-0.503276</td>
    </tr>
  </tbody>
</table>
</div>



分组键可以是任何长度适当 （等于要分组数据的长度）的数组：


```python
states = np.array(['Ohio', 'California', 'California', 'Ohio', 'Ohio'])

years = np.array([2005, 2005, 2006, 2005, 2006])

df['data1'].groupby([states, years]).mean()
```




    California  2005    1.295617
                2006    2.506938
    Ohio        2005    0.344843
                2006   -0.204452
    Name: data1, dtype: float64



通常，分组信息就位于相同的要处理DataFrame中。这里，你还可以将列名（可以是字符串、数字或其他Python对象）用作分组键：


```python
df.groupby('key1').mean()
```




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
      <th>data1</th>
      <th>data2</th>
    </tr>
    <tr>
      <th>key1</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.761376</td>
      <td>-0.509753</td>
    </tr>
    <tr>
      <th>b</th>
      <td>1.001831</td>
      <td>-0.826561</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.groupby(['key1', 'key2']).mean()
```




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
      <th></th>
      <th>data1</th>
      <th>data2</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">a</th>
      <th>one</th>
      <td>0.494255</td>
      <td>-0.454052</td>
    </tr>
    <tr>
      <th>two</th>
      <td>1.295617</td>
      <td>-0.621154</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">b</th>
      <th>one</th>
      <td>2.506938</td>
      <td>-0.954289</td>
    </tr>
    <tr>
      <th>two</th>
      <td>-0.503276</td>
      <td>-0.698834</td>
    </tr>
  </tbody>
</table>
</div>



你可能已经注意到了，第一个例子在执行df.groupby('key1').mean()时，结果中没有key2列。这是因为df['key2']不是数值数据（俗称“麻烦列”），所以被从结果中排除了。默认情况下，所有数值列都会被聚合，虽然有时可能会被过滤为一个子集，稍后就会碰到。

无论你准备拿 groupby 做什么，都有可能会用到 GroupBy 的 size 方法，它可以返回一个含有分组大小的 Series：


```python
df.groupby(['key1', 'key2']).size()
```




    key1  key2
    a     one     2
          two     1
    b     one     1
          two     1
    dtype: int64



注意，任何分组关键词中的缺失值，都会被从结果中除去。

### 对分组进行迭代

GroupBy对象支持迭代，可以产生一组二元元组（由分组名和数据块组成）。


```python
df
```




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
      <th>key1</th>
      <th>key2</th>
      <th>data1</th>
      <th>data2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>one</td>
      <td>1.192962</td>
      <td>-1.675544</td>
    </tr>
    <tr>
      <th>1</th>
      <td>a</td>
      <td>two</td>
      <td>1.295617</td>
      <td>-0.621154</td>
    </tr>
    <tr>
      <th>2</th>
      <td>b</td>
      <td>one</td>
      <td>2.506938</td>
      <td>-0.954289</td>
    </tr>
    <tr>
      <th>3</th>
      <td>b</td>
      <td>two</td>
      <td>-0.503276</td>
      <td>-0.698834</td>
    </tr>
    <tr>
      <th>4</th>
      <td>a</td>
      <td>one</td>
      <td>-0.204452</td>
      <td>0.767441</td>
    </tr>
  </tbody>
</table>
</div>




```python
for name, group in df.groupby('key1'):
    print(name)
    print(group)
```

    a
      key1 key2     data1     data2
    0    a  one  1.192962 -1.675544
    1    a  two  1.295617 -0.621154
    4    a  one -0.204452  0.767441
    b
      key1 key2     data1     data2
    2    b  one  2.506938 -0.954289
    3    b  two -0.503276 -0.698834
    

对于多重键的情况，元组的第一个元素将会是由键值组成的元组：


```python
for (k1, k2), group in df.groupby(['key1', 'key2']):
    print((k1, k2))
    print(group)
```

    ('a', 'one')
      key1 key2     data1     data2
    0    a  one  1.192962 -1.675544
    4    a  one -0.204452  0.767441
    ('a', 'two')
      key1 key2     data1     data2
    1    a  two  1.295617 -0.621154
    ('b', 'one')
      key1 key2     data1     data2
    2    b  one  2.506938 -0.954289
    ('b', 'two')
      key1 key2     data1     data2
    3    b  two -0.503276 -0.698834
    

你可以对这些数据片段做任何操作。有一个你可能会觉得有用的运算：将这些数据片段做成一个字典：


```python
pieces = dict(list(df.groupby('key1')))
pieces['b']
```




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
      <th>key1</th>
      <th>key2</th>
      <th>data1</th>
      <th>data2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>b</td>
      <td>one</td>
      <td>2.506938</td>
      <td>-0.954289</td>
    </tr>
    <tr>
      <th>3</th>
      <td>b</td>
      <td>two</td>
      <td>-0.503276</td>
      <td>-0.698834</td>
    </tr>
  </tbody>
</table>
</div>



groupby默认是在 `axis=0` 上进行分组的，通过设置也可以在其他任何轴上进行分组。拿上面例子中的df来说，我们可以根据dtype对列进行分组：


```python
df.dtypes
```




    key1      object
    key2      object
    data1    float64
    data2    float64
    dtype: object




```python
# 按照数据类型分组
grouped = df.groupby(df.dtypes, axis=1)
for dtype, group in grouped:
    print(dtype)
    print(group)
```

    float64
          data1     data2
    0  1.192962 -1.675544
    1  1.295617 -0.621154
    2  2.506938 -0.954289
    3 -0.503276 -0.698834
    4 -0.204452  0.767441
    object
      key1 key2
    0    a  one
    1    a  two
    2    b  one
    3    b  two
    4    a  one
    

### 选取一列或列的子集

对于由DataFrame产生的GroupBy对象，如果用一个（单个字符串）或一组（字符串数组）列名对其进行索引，就能实现选取部分列进行聚合的目的。  
```
df.groupby('key1')['data1']
df.groupby('key1')[['data2']]
```
是以下代码的语法糖：
```
df['data1'].groupby(df['key1'])
df[['data2']].groupby(df['key1'])
```

尤其对于大数据集，很可能只需要对部分列进行聚合。  
例如，在前面那个数据集中，如果只需计算data2列的平均值并以DataFrame形式得到结果，可以这样写：


```python
# 双 [[]] 要生成 dataframe 
df.groupby(['key1', 'key2'])[['data2']].mean()
```




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
      <th></th>
      <th>data2</th>
    </tr>
    <tr>
      <th>key1</th>
      <th>key2</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">a</th>
      <th>one</th>
      <td>-0.454052</td>
    </tr>
    <tr>
      <th>two</th>
      <td>-0.621154</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">b</th>
      <th>one</th>
      <td>-0.954289</td>
    </tr>
    <tr>
      <th>two</th>
      <td>-0.698834</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 单 [] 要生成 series
df.groupby(['key1', 'key2'])['data2'].mean()
```




    key1  key2
    a     one    -0.454052
          two    -0.621154
    b     one    -0.954289
          two    -0.698834
    Name: data2, dtype: float64



### 通过字典或Series进行分组


```python
people = pd.DataFrame(np.random.randn(5, 5),
                      columns=['a', 'b', 'c', 'd', 'e'],
                      index=['Joe', 'Steve', 'Wes', 'Jim', 'Travis'])
people.iloc[2:3, [1, 2]] = np.nan
people
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Joe</th>
      <td>1.259713</td>
      <td>-0.377088</td>
      <td>0.520075</td>
      <td>-0.881195</td>
      <td>0.158433</td>
    </tr>
    <tr>
      <th>Steve</th>
      <td>-1.226603</td>
      <td>0.648477</td>
      <td>-0.317307</td>
      <td>0.012993</td>
      <td>0.584107</td>
    </tr>
    <tr>
      <th>Wes</th>
      <td>-1.811950</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>-0.576653</td>
      <td>0.362209</td>
    </tr>
    <tr>
      <th>Jim</th>
      <td>0.951494</td>
      <td>0.253198</td>
      <td>-0.386507</td>
      <td>1.172929</td>
      <td>-1.755465</td>
    </tr>
    <tr>
      <th>Travis</th>
      <td>1.107800</td>
      <td>0.297369</td>
      <td>-0.279916</td>
      <td>1.512150</td>
      <td>0.755150</td>
    </tr>
  </tbody>
</table>
</div>



假设已知列的分组关系，并希望根据分组计算列的和：


```python
mapping = {'a': 'red', 'b': 'red', 'c': 'blue',  'd': 'blue', 'e': 'red', 'f' : 'orange'}
```

将这个字典传给groupby，来构造数组，但我们可以直接传递字典（我包含了键“f”来强调，存在未使用的分组键是可以的）：


```python
by_column = people.groupby(mapping, axis=1)
by_column.sum()
```




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
      <th>blue</th>
      <th>red</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Joe</th>
      <td>-0.361120</td>
      <td>1.041059</td>
    </tr>
    <tr>
      <th>Steve</th>
      <td>-0.304314</td>
      <td>0.005981</td>
    </tr>
    <tr>
      <th>Wes</th>
      <td>-0.576653</td>
      <td>-1.449741</td>
    </tr>
    <tr>
      <th>Jim</th>
      <td>0.786422</td>
      <td>-0.550774</td>
    </tr>
    <tr>
      <th>Travis</th>
      <td>1.232234</td>
      <td>2.160319</td>
    </tr>
  </tbody>
</table>
</div>



Series也有同样的功能，它可以被看做一个固定大小的映射：


```python
map_series = pd.Series(mapping)
map_series
```




    a       red
    b       red
    c      blue
    d      blue
    e       red
    f    orange
    dtype: object




```python
people.groupby(map_series, axis=1).count()
```




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
      <th>blue</th>
      <th>red</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Joe</th>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Steve</th>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Wes</th>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>Jim</th>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>Travis</th>
      <td>2</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



### 通过函数进行分组

比起使用字典或Series，使用Python函数是一种更原生的方法定义分组映射。任何被当做分组键的函数都会在各个**索引值**上被调用一次，其返回值就会被用作分组名称。


```python
people
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Joe</th>
      <td>1.259713</td>
      <td>-0.377088</td>
      <td>0.520075</td>
      <td>-0.881195</td>
      <td>0.158433</td>
    </tr>
    <tr>
      <th>Steve</th>
      <td>-1.226603</td>
      <td>0.648477</td>
      <td>-0.317307</td>
      <td>0.012993</td>
      <td>0.584107</td>
    </tr>
    <tr>
      <th>Wes</th>
      <td>-1.811950</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>-0.576653</td>
      <td>0.362209</td>
    </tr>
    <tr>
      <th>Jim</th>
      <td>0.951494</td>
      <td>0.253198</td>
      <td>-0.386507</td>
      <td>1.172929</td>
      <td>-1.755465</td>
    </tr>
    <tr>
      <th>Travis</th>
      <td>1.107800</td>
      <td>0.297369</td>
      <td>-0.279916</td>
      <td>1.512150</td>
      <td>0.755150</td>
    </tr>
  </tbody>
</table>
</div>



其索引值为人的名字。你可以计算一个字符串长度的数组，更简单的方法是传入 len 函数：


```python
people.groupby(len).sum()
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>3</th>
      <td>0.399257</td>
      <td>-0.123890</td>
      <td>0.133568</td>
      <td>-0.284919</td>
      <td>-1.234823</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-1.226603</td>
      <td>0.648477</td>
      <td>-0.317307</td>
      <td>0.012993</td>
      <td>0.584107</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1.107800</td>
      <td>0.297369</td>
      <td>-0.279916</td>
      <td>1.512150</td>
      <td>0.755150</td>
    </tr>
  </tbody>
</table>
</div>



将函数跟数组、列表、字典、Series混合使用也不是问题，因为任何东西在内部都会被转换为数组：


```python
key_list = ['one', 'one', 'one', 'two', 'two']
people.groupby([len, key_list]).min()
```




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
      <th></th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
      <th>e</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">3</th>
      <th>one</th>
      <td>-1.811950</td>
      <td>-0.377088</td>
      <td>0.520075</td>
      <td>-0.881195</td>
      <td>0.158433</td>
    </tr>
    <tr>
      <th>two</th>
      <td>0.951494</td>
      <td>0.253198</td>
      <td>-0.386507</td>
      <td>1.172929</td>
      <td>-1.755465</td>
    </tr>
    <tr>
      <th>5</th>
      <th>one</th>
      <td>-1.226603</td>
      <td>0.648477</td>
      <td>-0.317307</td>
      <td>0.012993</td>
      <td>0.584107</td>
    </tr>
    <tr>
      <th>6</th>
      <th>two</th>
      <td>1.107800</td>
      <td>0.297369</td>
      <td>-0.279916</td>
      <td>1.512150</td>
      <td>0.755150</td>
    </tr>
  </tbody>
</table>
</div>



### 根据索引级别分组

层次化索引数据集最方便的地方就在于它能够根据轴索引的一个级别进行聚合：


```python
columns = pd.MultiIndex.from_arrays([['US', 'US', 'US', 'JP', 'JP'],
                                    [1, 3, 5, 1, 3]],
                                    names=['cty', 'tenor'])
hier_df = pd.DataFrame(np.random.randn(4, 5), columns=columns)
hier_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th>cty</th>
      <th colspan="3" halign="left">US</th>
      <th colspan="2" halign="left">JP</th>
    </tr>
    <tr>
      <th>tenor</th>
      <th>1</th>
      <th>3</th>
      <th>5</th>
      <th>1</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.676690</td>
      <td>-0.294463</td>
      <td>0.275278</td>
      <td>-0.315009</td>
      <td>-0.454633</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-1.509024</td>
      <td>0.474617</td>
      <td>-0.969700</td>
      <td>-0.043906</td>
      <td>-1.237097</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.379676</td>
      <td>-0.577742</td>
      <td>1.084988</td>
      <td>0.499930</td>
      <td>0.373462</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.097124</td>
      <td>-0.437426</td>
      <td>0.725242</td>
      <td>-1.646882</td>
      <td>0.571528</td>
    </tr>
  </tbody>
</table>
</div>



要根据级别分组，使用 level 关键字传递级别序号或名字：


```python
hier_df.groupby(level='cty', axis=1).count()
```




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
      <th>cty</th>
      <th>JP</th>
      <th>US</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



## 数据聚合

聚合指的是任何能够从数组产生标量值的数据转换过程。之前的例子已经用过一些，比如mean、count、min以及sum等。  
常见的聚合运算  
![常用的聚合运算方法](http://upload-images.jianshu.io/upload_images/7178691-ba8de524e08b1b6f.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)


```python
df
```




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
      <th>key1</th>
      <th>key2</th>
      <th>data1</th>
      <th>data2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>one</td>
      <td>1.192962</td>
      <td>-1.675544</td>
    </tr>
    <tr>
      <th>1</th>
      <td>a</td>
      <td>two</td>
      <td>1.295617</td>
      <td>-0.621154</td>
    </tr>
    <tr>
      <th>2</th>
      <td>b</td>
      <td>one</td>
      <td>2.506938</td>
      <td>-0.954289</td>
    </tr>
    <tr>
      <th>3</th>
      <td>b</td>
      <td>two</td>
      <td>-0.503276</td>
      <td>-0.698834</td>
    </tr>
    <tr>
      <th>4</th>
      <td>a</td>
      <td>one</td>
      <td>-0.204452</td>
      <td>0.767441</td>
    </tr>
  </tbody>
</table>
</div>




```python
grouped = df.groupby('key1')
```

如果要使用你自己的聚合函数，只需将其传入 aggregate 或 agg 方法即可：


```python
def peak_to_peak(arr):
    return arr.max() - arr.min()
grouped.agg(peak_to_peak)
```




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
      <th>data1</th>
      <th>data2</th>
    </tr>
    <tr>
      <th>key1</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>1.500069</td>
      <td>2.442985</td>
    </tr>
    <tr>
      <th>b</th>
      <td>3.010214</td>
      <td>0.255455</td>
    </tr>
  </tbody>
</table>
</div>



获取分组后的描述信息


```python
grouped.describe()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="8" halign="left">data1</th>
      <th colspan="8" halign="left">data2</th>
    </tr>
    <tr>
      <th></th>
      <th>count</th>
      <th>mean</th>
      <th>std</th>
      <th>min</th>
      <th>25%</th>
      <th>50%</th>
      <th>75%</th>
      <th>max</th>
      <th>count</th>
      <th>mean</th>
      <th>std</th>
      <th>min</th>
      <th>25%</th>
      <th>50%</th>
      <th>75%</th>
      <th>max</th>
    </tr>
    <tr>
      <th>key1</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>3.0</td>
      <td>0.761376</td>
      <td>0.838004</td>
      <td>-0.204452</td>
      <td>0.494255</td>
      <td>1.192962</td>
      <td>1.244290</td>
      <td>1.295617</td>
      <td>3.0</td>
      <td>-0.509753</td>
      <td>1.225297</td>
      <td>-1.675544</td>
      <td>-1.148349</td>
      <td>-0.621154</td>
      <td>0.073143</td>
      <td>0.767441</td>
    </tr>
    <tr>
      <th>b</th>
      <td>2.0</td>
      <td>1.001831</td>
      <td>2.128543</td>
      <td>-0.503276</td>
      <td>0.249277</td>
      <td>1.001831</td>
      <td>1.754384</td>
      <td>2.506938</td>
      <td>2.0</td>
      <td>-0.826561</td>
      <td>0.180634</td>
      <td>-0.954289</td>
      <td>-0.890425</td>
      <td>-0.826561</td>
      <td>-0.762697</td>
      <td>-0.698834</td>
    </tr>
  </tbody>
</table>
</div>



自定义聚合函数要比图中那些经过优化的函数慢得多。这是因为在构造中间分组数据块时存在非常大的开销（函数调用、数据重排等）。

### 面向列的多函数应用

你可能希望对不同的列使用不同的聚合函数，或一次应用多个函数。其实这也好办，我将通过一些示例来进行讲解。


```python
tips = pd.read_csv('data/examples/tips.csv')
tips['tip_pct'] = tips['tip'] / tips['total_bill']
tips.head()
```




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
      <th>total_bill</th>
      <th>tip</th>
      <th>smoker</th>
      <th>day</th>
      <th>time</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>16.99</td>
      <td>1.01</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.059447</td>
    </tr>
    <tr>
      <th>1</th>
      <td>10.34</td>
      <td>1.66</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>3</td>
      <td>0.160542</td>
    </tr>
    <tr>
      <th>2</th>
      <td>21.01</td>
      <td>3.50</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>3</td>
      <td>0.166587</td>
    </tr>
    <tr>
      <th>3</th>
      <td>23.68</td>
      <td>3.31</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.139780</td>
    </tr>
    <tr>
      <th>4</th>
      <td>24.59</td>
      <td>3.61</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>4</td>
      <td>0.146808</td>
    </tr>
  </tbody>
</table>
</div>



首先，我根据天和smoker对tips进行分组：


```python
grouped = tips.groupby(['day', 'smoker'])
```

获取分组后的一列


```python
grouped_pct = grouped['tip_pct']
```

按照指定的方式对这一列分组进行结算


```python
grouped_pct.agg('mean')
```




    day   smoker
    Fri   No        0.151650
          Yes       0.174783
    Sat   No        0.158048
          Yes       0.147906
    Sun   No        0.160113
          Yes       0.187250
    Thur  No        0.160298
          Yes       0.163863
    Name: tip_pct, dtype: float64



如果传入一组函数或函数名，得到的DataFrame的列就会以相应的函数命名：


```python
# peak_to_peak 是上面自定义的一个方法
grouped_pct.agg(['mean', 'std', peak_to_peak])
```




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
      <th></th>
      <th>mean</th>
      <th>std</th>
      <th>peak_to_peak</th>
    </tr>
    <tr>
      <th>day</th>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Fri</th>
      <th>No</th>
      <td>0.151650</td>
      <td>0.028123</td>
      <td>0.067349</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.174783</td>
      <td>0.051293</td>
      <td>0.159925</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sat</th>
      <th>No</th>
      <td>0.158048</td>
      <td>0.039767</td>
      <td>0.235193</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.147906</td>
      <td>0.061375</td>
      <td>0.290095</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sun</th>
      <th>No</th>
      <td>0.160113</td>
      <td>0.042347</td>
      <td>0.193226</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.187250</td>
      <td>0.154134</td>
      <td>0.644685</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Thur</th>
      <th>No</th>
      <td>0.160298</td>
      <td>0.038774</td>
      <td>0.193350</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.163863</td>
      <td>0.039389</td>
      <td>0.151240</td>
    </tr>
  </tbody>
</table>
</div>



你并非一定要接受GroupBy自动给出的那些列名，特别是lambda函数，它们的名称是''，这样的辨识度就很低了（通过函数的name属性看看就知道了）。因此，如果传入的是一个由(name,function)元组组成的列表，则各元组的第一个元素就会被用作DataFrame的列名（可以将这种二元元组列表看做一个有序映射）：

设置方法的字段别名


```python
grouped_pct.agg([('foo', 'mean'), ('bar', np.std)])
```




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
      <th></th>
      <th>foo</th>
      <th>bar</th>
    </tr>
    <tr>
      <th>day</th>
      <th>smoker</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Fri</th>
      <th>No</th>
      <td>0.151650</td>
      <td>0.028123</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.174783</td>
      <td>0.051293</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sat</th>
      <th>No</th>
      <td>0.158048</td>
      <td>0.039767</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.147906</td>
      <td>0.061375</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sun</th>
      <th>No</th>
      <td>0.160113</td>
      <td>0.042347</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.187250</td>
      <td>0.154134</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Thur</th>
      <th>No</th>
      <td>0.160298</td>
      <td>0.038774</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.163863</td>
      <td>0.039389</td>
    </tr>
  </tbody>
</table>
</div>



对于DataFrame，你还有更多选择，你可以定义一组应用于全部列的一组函数，或不同的列应用不同的函数。假设我们想要对tip_pct和total_bill列计算三个统计信息：


```python
functions = ['count', 'mean', 'max']

result = grouped['tip_pct', 'total_bill'].agg(functions)

result
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th colspan="3" halign="left">tip_pct</th>
      <th colspan="3" halign="left">total_bill</th>
    </tr>
    <tr>
      <th></th>
      <th></th>
      <th>count</th>
      <th>mean</th>
      <th>max</th>
      <th>count</th>
      <th>mean</th>
      <th>max</th>
    </tr>
    <tr>
      <th>day</th>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Fri</th>
      <th>No</th>
      <td>4</td>
      <td>0.151650</td>
      <td>0.187735</td>
      <td>4</td>
      <td>18.420000</td>
      <td>22.75</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>15</td>
      <td>0.174783</td>
      <td>0.263480</td>
      <td>15</td>
      <td>16.813333</td>
      <td>40.17</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sat</th>
      <th>No</th>
      <td>45</td>
      <td>0.158048</td>
      <td>0.291990</td>
      <td>45</td>
      <td>19.661778</td>
      <td>48.33</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>42</td>
      <td>0.147906</td>
      <td>0.325733</td>
      <td>42</td>
      <td>21.276667</td>
      <td>50.81</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sun</th>
      <th>No</th>
      <td>57</td>
      <td>0.160113</td>
      <td>0.252672</td>
      <td>57</td>
      <td>20.506667</td>
      <td>48.17</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>19</td>
      <td>0.187250</td>
      <td>0.710345</td>
      <td>19</td>
      <td>24.120000</td>
      <td>45.35</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Thur</th>
      <th>No</th>
      <td>45</td>
      <td>0.160298</td>
      <td>0.266312</td>
      <td>45</td>
      <td>17.113111</td>
      <td>41.19</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>17</td>
      <td>0.163863</td>
      <td>0.241255</td>
      <td>17</td>
      <td>19.190588</td>
      <td>43.11</td>
    </tr>
  </tbody>
</table>
</div>




```python
result['tip_pct']
```




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
      <th></th>
      <th>count</th>
      <th>mean</th>
      <th>max</th>
    </tr>
    <tr>
      <th>day</th>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Fri</th>
      <th>No</th>
      <td>4</td>
      <td>0.151650</td>
      <td>0.187735</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>15</td>
      <td>0.174783</td>
      <td>0.263480</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sat</th>
      <th>No</th>
      <td>45</td>
      <td>0.158048</td>
      <td>0.291990</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>42</td>
      <td>0.147906</td>
      <td>0.325733</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sun</th>
      <th>No</th>
      <td>57</td>
      <td>0.160113</td>
      <td>0.252672</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>19</td>
      <td>0.187250</td>
      <td>0.710345</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Thur</th>
      <th>No</th>
      <td>45</td>
      <td>0.160298</td>
      <td>0.266312</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>17</td>
      <td>0.163863</td>
      <td>0.241255</td>
    </tr>
  </tbody>
</table>
</div>



跟前面一样，这里也可以传入带有自定义名称的一组元组：


```python
ftuples = [('Durchschnitt', 'mean'),('Abweichung', np.var)]

grouped['tip_pct', 'total_bill'].agg(ftuples)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th colspan="2" halign="left">tip_pct</th>
      <th colspan="2" halign="left">total_bill</th>
    </tr>
    <tr>
      <th></th>
      <th></th>
      <th>Durchschnitt</th>
      <th>Abweichung</th>
      <th>Durchschnitt</th>
      <th>Abweichung</th>
    </tr>
    <tr>
      <th>day</th>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Fri</th>
      <th>No</th>
      <td>0.151650</td>
      <td>0.000791</td>
      <td>18.420000</td>
      <td>25.596333</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.174783</td>
      <td>0.002631</td>
      <td>16.813333</td>
      <td>82.562438</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sat</th>
      <th>No</th>
      <td>0.158048</td>
      <td>0.001581</td>
      <td>19.661778</td>
      <td>79.908965</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.147906</td>
      <td>0.003767</td>
      <td>21.276667</td>
      <td>101.387535</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sun</th>
      <th>No</th>
      <td>0.160113</td>
      <td>0.001793</td>
      <td>20.506667</td>
      <td>66.099980</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.187250</td>
      <td>0.023757</td>
      <td>24.120000</td>
      <td>109.046044</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Thur</th>
      <th>No</th>
      <td>0.160298</td>
      <td>0.001503</td>
      <td>17.113111</td>
      <td>59.625081</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.163863</td>
      <td>0.001551</td>
      <td>19.190588</td>
      <td>69.808518</td>
    </tr>
  </tbody>
</table>
</div>



现在，假设你想要对一个列或不同的列应用不同的函数。具体的办法是向agg传入一个从列名映射到函数的字典：


```python
# 分组后，对 tip 列进行 np.max 运算； size 列进行 sum 运算
grouped.agg({'tip' : np.max, 'size' : 'sum'})
```




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
      <th></th>
      <th>tip</th>
      <th>size</th>
    </tr>
    <tr>
      <th>day</th>
      <th>smoker</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Fri</th>
      <th>No</th>
      <td>3.50</td>
      <td>9</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>4.73</td>
      <td>31</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sat</th>
      <th>No</th>
      <td>9.00</td>
      <td>115</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>10.00</td>
      <td>104</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sun</th>
      <th>No</th>
      <td>6.00</td>
      <td>167</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>6.50</td>
      <td>49</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Thur</th>
      <th>No</th>
      <td>6.70</td>
      <td>112</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>5.00</td>
      <td>40</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 分组后，对 tip_pct 列分别进行 多种 运算； size 列进行 sum 运算
grouped.agg({'tip_pct' : ['min', 'max', 'mean', 'std'],  'size' : 'sum'})
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th colspan="4" halign="left">tip_pct</th>
      <th>size</th>
    </tr>
    <tr>
      <th></th>
      <th></th>
      <th>min</th>
      <th>max</th>
      <th>mean</th>
      <th>std</th>
      <th>sum</th>
    </tr>
    <tr>
      <th>day</th>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Fri</th>
      <th>No</th>
      <td>0.120385</td>
      <td>0.187735</td>
      <td>0.151650</td>
      <td>0.028123</td>
      <td>9</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.103555</td>
      <td>0.263480</td>
      <td>0.174783</td>
      <td>0.051293</td>
      <td>31</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sat</th>
      <th>No</th>
      <td>0.056797</td>
      <td>0.291990</td>
      <td>0.158048</td>
      <td>0.039767</td>
      <td>115</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.035638</td>
      <td>0.325733</td>
      <td>0.147906</td>
      <td>0.061375</td>
      <td>104</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sun</th>
      <th>No</th>
      <td>0.059447</td>
      <td>0.252672</td>
      <td>0.160113</td>
      <td>0.042347</td>
      <td>167</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.065660</td>
      <td>0.710345</td>
      <td>0.187250</td>
      <td>0.154134</td>
      <td>49</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Thur</th>
      <th>No</th>
      <td>0.072961</td>
      <td>0.266312</td>
      <td>0.160298</td>
      <td>0.038774</td>
      <td>112</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.090014</td>
      <td>0.241255</td>
      <td>0.163863</td>
      <td>0.039389</td>
      <td>40</td>
    </tr>
  </tbody>
</table>
</div>



只有将多个函数应用到至少一列时，DataFrame才会拥有层次化的列。

### 以“没有行索引”的形式返回聚合数据

默认返回的数据是带分组索引的


```python
tips.groupby(['day', 'smoker']).mean()
```




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
      <th></th>
      <th>total_bill</th>
      <th>tip</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
    <tr>
      <th>day</th>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Fri</th>
      <th>No</th>
      <td>18.420000</td>
      <td>2.812500</td>
      <td>2.250000</td>
      <td>0.151650</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>16.813333</td>
      <td>2.714000</td>
      <td>2.066667</td>
      <td>0.174783</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sat</th>
      <th>No</th>
      <td>19.661778</td>
      <td>3.102889</td>
      <td>2.555556</td>
      <td>0.158048</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>21.276667</td>
      <td>2.875476</td>
      <td>2.476190</td>
      <td>0.147906</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sun</th>
      <th>No</th>
      <td>20.506667</td>
      <td>3.167895</td>
      <td>2.929825</td>
      <td>0.160113</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>24.120000</td>
      <td>3.516842</td>
      <td>2.578947</td>
      <td>0.187250</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Thur</th>
      <th>No</th>
      <td>17.113111</td>
      <td>2.673778</td>
      <td>2.488889</td>
      <td>0.160298</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>19.190588</td>
      <td>3.030000</td>
      <td>2.352941</td>
      <td>0.163863</td>
    </tr>
  </tbody>
</table>
</div>



可以向 groupby 传入 `as_index=False` 以禁用该功能


```python
tips.groupby(['day', 'smoker'], as_index=False).mean()
```




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
      <th>day</th>
      <th>smoker</th>
      <th>total_bill</th>
      <th>tip</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Fri</td>
      <td>No</td>
      <td>18.420000</td>
      <td>2.812500</td>
      <td>2.250000</td>
      <td>0.151650</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Fri</td>
      <td>Yes</td>
      <td>16.813333</td>
      <td>2.714000</td>
      <td>2.066667</td>
      <td>0.174783</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Sat</td>
      <td>No</td>
      <td>19.661778</td>
      <td>3.102889</td>
      <td>2.555556</td>
      <td>0.158048</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Sat</td>
      <td>Yes</td>
      <td>21.276667</td>
      <td>2.875476</td>
      <td>2.476190</td>
      <td>0.147906</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Sun</td>
      <td>No</td>
      <td>20.506667</td>
      <td>3.167895</td>
      <td>2.929825</td>
      <td>0.160113</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Sun</td>
      <td>Yes</td>
      <td>24.120000</td>
      <td>3.516842</td>
      <td>2.578947</td>
      <td>0.187250</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Thur</td>
      <td>No</td>
      <td>17.113111</td>
      <td>2.673778</td>
      <td>2.488889</td>
      <td>0.160298</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Thur</td>
      <td>Yes</td>
      <td>19.190588</td>
      <td>3.030000</td>
      <td>2.352941</td>
      <td>0.163863</td>
    </tr>
  </tbody>
</table>
</div>



## apply：一般性的“拆分－应用－合并”

apply会将待处理的对象拆分成多个片段，然后对各片段调用传入的函数，最后尝试将各片段组合到一起。  
![](http://upload-images.jianshu.io/upload_images/7178691-7e8bb217f599b4ae.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)


```python
tips.head()
```




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
      <th>total_bill</th>
      <th>tip</th>
      <th>smoker</th>
      <th>day</th>
      <th>time</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>16.99</td>
      <td>1.01</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.059447</td>
    </tr>
    <tr>
      <th>1</th>
      <td>10.34</td>
      <td>1.66</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>3</td>
      <td>0.160542</td>
    </tr>
    <tr>
      <th>2</th>
      <td>21.01</td>
      <td>3.50</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>3</td>
      <td>0.166587</td>
    </tr>
    <tr>
      <th>3</th>
      <td>23.68</td>
      <td>3.31</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.139780</td>
    </tr>
    <tr>
      <th>4</th>
      <td>24.59</td>
      <td>3.61</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>4</td>
      <td>0.146808</td>
    </tr>
  </tbody>
</table>
</div>



假设你想要根据分组选出最高的5个tip_pct值。首先，编写一个选取指定列具有最大值的行的函数：


```python
def top(df, n=5, column='tip_pct'):
    return df.sort_values(by=column)[-n:]
top(tips, n = 6)
```




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
      <th>total_bill</th>
      <th>tip</th>
      <th>smoker</th>
      <th>day</th>
      <th>time</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>109</th>
      <td>14.31</td>
      <td>4.00</td>
      <td>Yes</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.279525</td>
    </tr>
    <tr>
      <th>183</th>
      <td>23.17</td>
      <td>6.50</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>4</td>
      <td>0.280535</td>
    </tr>
    <tr>
      <th>232</th>
      <td>11.61</td>
      <td>3.39</td>
      <td>No</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.291990</td>
    </tr>
    <tr>
      <th>67</th>
      <td>3.07</td>
      <td>1.00</td>
      <td>Yes</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>1</td>
      <td>0.325733</td>
    </tr>
    <tr>
      <th>178</th>
      <td>9.60</td>
      <td>4.00</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.416667</td>
    </tr>
    <tr>
      <th>172</th>
      <td>7.25</td>
      <td>5.15</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.710345</td>
    </tr>
  </tbody>
</table>
</div>



如果对smoker分组并用该函数调用apply，就会得到：


```python
tips.groupby('smoker').apply(top)
```




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
      <th></th>
      <th>total_bill</th>
      <th>tip</th>
      <th>smoker</th>
      <th>day</th>
      <th>time</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
    <tr>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="5" valign="top">No</th>
      <th>88</th>
      <td>24.71</td>
      <td>5.85</td>
      <td>No</td>
      <td>Thur</td>
      <td>Lunch</td>
      <td>2</td>
      <td>0.236746</td>
    </tr>
    <tr>
      <th>185</th>
      <td>20.69</td>
      <td>5.00</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>5</td>
      <td>0.241663</td>
    </tr>
    <tr>
      <th>51</th>
      <td>10.29</td>
      <td>2.60</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.252672</td>
    </tr>
    <tr>
      <th>149</th>
      <td>7.51</td>
      <td>2.00</td>
      <td>No</td>
      <td>Thur</td>
      <td>Lunch</td>
      <td>2</td>
      <td>0.266312</td>
    </tr>
    <tr>
      <th>232</th>
      <td>11.61</td>
      <td>3.39</td>
      <td>No</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.291990</td>
    </tr>
    <tr>
      <th rowspan="5" valign="top">Yes</th>
      <th>109</th>
      <td>14.31</td>
      <td>4.00</td>
      <td>Yes</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.279525</td>
    </tr>
    <tr>
      <th>183</th>
      <td>23.17</td>
      <td>6.50</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>4</td>
      <td>0.280535</td>
    </tr>
    <tr>
      <th>67</th>
      <td>3.07</td>
      <td>1.00</td>
      <td>Yes</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>1</td>
      <td>0.325733</td>
    </tr>
    <tr>
      <th>178</th>
      <td>9.60</td>
      <td>4.00</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.416667</td>
    </tr>
    <tr>
      <th>172</th>
      <td>7.25</td>
      <td>5.15</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.710345</td>
    </tr>
  </tbody>
</table>
</div>



top函数在DataFrame的各个片段上调用，然后结果由pandas.concat组装到一起，并以分组名称进行了标记。于是，最终结果就有了一个层次化索引，其内层索引值来自原DataFrame。

如果传给apply的函数能够接受其他参数或关键字，则可以将这些内容放在函数名后面一并传入：


```python
tips.groupby(['smoker', 'day']).apply(top, n=1, column='total_bill')
```




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
      <th></th>
      <th></th>
      <th>total_bill</th>
      <th>tip</th>
      <th>smoker</th>
      <th>day</th>
      <th>time</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
    <tr>
      <th>smoker</th>
      <th>day</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="4" valign="top">No</th>
      <th>Fri</th>
      <th>94</th>
      <td>22.75</td>
      <td>3.25</td>
      <td>No</td>
      <td>Fri</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.142857</td>
    </tr>
    <tr>
      <th>Sat</th>
      <th>212</th>
      <td>48.33</td>
      <td>9.00</td>
      <td>No</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>4</td>
      <td>0.186220</td>
    </tr>
    <tr>
      <th>Sun</th>
      <th>156</th>
      <td>48.17</td>
      <td>5.00</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>6</td>
      <td>0.103799</td>
    </tr>
    <tr>
      <th>Thur</th>
      <th>142</th>
      <td>41.19</td>
      <td>5.00</td>
      <td>No</td>
      <td>Thur</td>
      <td>Lunch</td>
      <td>5</td>
      <td>0.121389</td>
    </tr>
    <tr>
      <th rowspan="4" valign="top">Yes</th>
      <th>Fri</th>
      <th>95</th>
      <td>40.17</td>
      <td>4.73</td>
      <td>Yes</td>
      <td>Fri</td>
      <td>Dinner</td>
      <td>4</td>
      <td>0.117750</td>
    </tr>
    <tr>
      <th>Sat</th>
      <th>170</th>
      <td>50.81</td>
      <td>10.00</td>
      <td>Yes</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>3</td>
      <td>0.196812</td>
    </tr>
    <tr>
      <th>Sun</th>
      <th>182</th>
      <td>45.35</td>
      <td>3.50</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>3</td>
      <td>0.077178</td>
    </tr>
    <tr>
      <th>Thur</th>
      <th>197</th>
      <td>43.11</td>
      <td>5.00</td>
      <td>Yes</td>
      <td>Thur</td>
      <td>Lunch</td>
      <td>4</td>
      <td>0.115982</td>
    </tr>
  </tbody>
</table>
</div>



在GroupBy中，当你调用诸如describe之类的方法时，实际上只是应用了下面两条代码的快捷方式而已：


```python
result = tips.groupby('smoker')['tip_pct'].describe()
result
```




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
      <th>count</th>
      <th>mean</th>
      <th>std</th>
      <th>min</th>
      <th>25%</th>
      <th>50%</th>
      <th>75%</th>
      <th>max</th>
    </tr>
    <tr>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>No</th>
      <td>151.0</td>
      <td>0.159328</td>
      <td>0.039910</td>
      <td>0.056797</td>
      <td>0.136906</td>
      <td>0.155625</td>
      <td>0.185014</td>
      <td>0.291990</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>93.0</td>
      <td>0.163196</td>
      <td>0.085119</td>
      <td>0.035638</td>
      <td>0.106771</td>
      <td>0.153846</td>
      <td>0.195059</td>
      <td>0.710345</td>
    </tr>
  </tbody>
</table>
</div>




```python
result.unstack('smoker')
```




           smoker
    count  No        151.000000
           Yes        93.000000
    mean   No          0.159328
           Yes         0.163196
    std    No          0.039910
           Yes         0.085119
    min    No          0.056797
           Yes         0.035638
    25%    No          0.136906
           Yes         0.106771
    50%    No          0.155625
           Yes         0.153846
    75%    No          0.185014
           Yes         0.195059
    max    No          0.291990
           Yes         0.710345
    dtype: float64




```python
result.unstack('smoker').swaplevel(0, 1)
```




    smoker       
    No      count    151.000000
    Yes     count     93.000000
    No      mean       0.159328
    Yes     mean       0.163196
    No      std        0.039910
    Yes     std        0.085119
    No      min        0.056797
    Yes     min        0.035638
    No      25%        0.136906
    Yes     25%        0.106771
    No      50%        0.155625
    Yes     50%        0.153846
    No      75%        0.185014
    Yes     75%        0.195059
    No      max        0.291990
    Yes     max        0.710345
    dtype: float64



applay 的实现方式


```python
f = lambda x: x.describe()
tips.groupby('smoker')['tip_pct'].apply(f)
```




    smoker       
    No      count    151.000000
            mean       0.159328
            std        0.039910
            min        0.056797
            25%        0.136906
            50%        0.155625
            75%        0.185014
            max        0.291990
    Yes     count     93.000000
            mean       0.163196
            std        0.085119
            min        0.035638
            25%        0.106771
            50%        0.153846
            75%        0.195059
            max        0.710345
    Name: tip_pct, dtype: float64



### 禁止分组键

分组键会跟原始对象的索引共同构成结果对象中的层次化索引。将 `group_keys=False` 传入 groupby 即可禁止该效果：


```python
tips.groupby('smoker').apply(top)
```




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
      <th></th>
      <th>total_bill</th>
      <th>tip</th>
      <th>smoker</th>
      <th>day</th>
      <th>time</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
    <tr>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="5" valign="top">No</th>
      <th>88</th>
      <td>24.71</td>
      <td>5.85</td>
      <td>No</td>
      <td>Thur</td>
      <td>Lunch</td>
      <td>2</td>
      <td>0.236746</td>
    </tr>
    <tr>
      <th>185</th>
      <td>20.69</td>
      <td>5.00</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>5</td>
      <td>0.241663</td>
    </tr>
    <tr>
      <th>51</th>
      <td>10.29</td>
      <td>2.60</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.252672</td>
    </tr>
    <tr>
      <th>149</th>
      <td>7.51</td>
      <td>2.00</td>
      <td>No</td>
      <td>Thur</td>
      <td>Lunch</td>
      <td>2</td>
      <td>0.266312</td>
    </tr>
    <tr>
      <th>232</th>
      <td>11.61</td>
      <td>3.39</td>
      <td>No</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.291990</td>
    </tr>
    <tr>
      <th rowspan="5" valign="top">Yes</th>
      <th>109</th>
      <td>14.31</td>
      <td>4.00</td>
      <td>Yes</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.279525</td>
    </tr>
    <tr>
      <th>183</th>
      <td>23.17</td>
      <td>6.50</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>4</td>
      <td>0.280535</td>
    </tr>
    <tr>
      <th>67</th>
      <td>3.07</td>
      <td>1.00</td>
      <td>Yes</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>1</td>
      <td>0.325733</td>
    </tr>
    <tr>
      <th>178</th>
      <td>9.60</td>
      <td>4.00</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.416667</td>
    </tr>
    <tr>
      <th>172</th>
      <td>7.25</td>
      <td>5.15</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.710345</td>
    </tr>
  </tbody>
</table>
</div>




```python
tips.groupby('smoker', group_keys=False).apply(top)
```




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
      <th>total_bill</th>
      <th>tip</th>
      <th>smoker</th>
      <th>day</th>
      <th>time</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>88</th>
      <td>24.71</td>
      <td>5.85</td>
      <td>No</td>
      <td>Thur</td>
      <td>Lunch</td>
      <td>2</td>
      <td>0.236746</td>
    </tr>
    <tr>
      <th>185</th>
      <td>20.69</td>
      <td>5.00</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>5</td>
      <td>0.241663</td>
    </tr>
    <tr>
      <th>51</th>
      <td>10.29</td>
      <td>2.60</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.252672</td>
    </tr>
    <tr>
      <th>149</th>
      <td>7.51</td>
      <td>2.00</td>
      <td>No</td>
      <td>Thur</td>
      <td>Lunch</td>
      <td>2</td>
      <td>0.266312</td>
    </tr>
    <tr>
      <th>232</th>
      <td>11.61</td>
      <td>3.39</td>
      <td>No</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.291990</td>
    </tr>
    <tr>
      <th>109</th>
      <td>14.31</td>
      <td>4.00</td>
      <td>Yes</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.279525</td>
    </tr>
    <tr>
      <th>183</th>
      <td>23.17</td>
      <td>6.50</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>4</td>
      <td>0.280535</td>
    </tr>
    <tr>
      <th>67</th>
      <td>3.07</td>
      <td>1.00</td>
      <td>Yes</td>
      <td>Sat</td>
      <td>Dinner</td>
      <td>1</td>
      <td>0.325733</td>
    </tr>
    <tr>
      <th>178</th>
      <td>9.60</td>
      <td>4.00</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.416667</td>
    </tr>
    <tr>
      <th>172</th>
      <td>7.25</td>
      <td>5.15</td>
      <td>Yes</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.710345</td>
    </tr>
  </tbody>
</table>
</div>



### 分位数和桶分析

pandas有一些能根据指定面元或样本分位数将数据拆分成多块的工具（比如cut和qcut）。将这些函数跟groupby结合起来，就能非常轻松地实现对数据集的桶（bucket）或分位数（quantile）分析了。以下面这个简单的随机数据集为例，我们利用cut将其装入长度相等的桶中：


```python
frame = pd.DataFrame({'data1': np.random.randn(1000),
                      'data2': np.random.randn(1000)})
quartiles = pd.cut(frame.data1, 4)
quartiles.head()
```




    0    (-1.698, 0.0798]
    1     (0.0798, 1.857]
    2    (-1.698, 0.0798]
    3     (0.0798, 1.857]
    4    (-1.698, 0.0798]
    Name: data1, dtype: category
    Categories (4, interval[float64]): [(-3.482, -1.698] < (-1.698, 0.0798] < (0.0798, 1.857] < (1.857, 3.635]]



由cut返回的Categorical对象可直接传递到groupby。因此，我们可以像下面这样对data2列做一些统计计算：


```python
def get_stats(group):
    return {'min': group.min(), 'max': group.max(), 'count': group.count(), 'mean': group.mean()}

grouped = frame.data2.groupby(quartiles)
grouped.apply(get_stats).unstack()
```




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
      <th>count</th>
      <th>max</th>
      <th>mean</th>
      <th>min</th>
    </tr>
    <tr>
      <th>data1</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>(-3.482, -1.698]</th>
      <td>38.0</td>
      <td>2.161012</td>
      <td>0.286213</td>
      <td>-1.820655</td>
    </tr>
    <tr>
      <th>(-1.698, 0.0798]</th>
      <td>472.0</td>
      <td>3.762126</td>
      <td>-0.044402</td>
      <td>-3.260810</td>
    </tr>
    <tr>
      <th>(0.0798, 1.857]</th>
      <td>452.0</td>
      <td>3.026034</td>
      <td>-0.040110</td>
      <td>-3.122991</td>
    </tr>
    <tr>
      <th>(1.857, 3.635]</th>
      <td>38.0</td>
      <td>1.482856</td>
      <td>-0.191989</td>
      <td>-1.969943</td>
    </tr>
  </tbody>
</table>
</div>



这些都是长度相等的桶。要根据样本分位数得到大小相等的桶，使用qcut即可。传入 `labels=False` 即可只获取分位数的编号：


```python
grouping = pd.qcut(frame.data1, 10, labels=False)
grouping.head()
```




    0    1
    1    5
    2    3
    3    5
    4    3
    Name: data1, dtype: int64




```python
temp = pd.qcut(frame.data1, 10)
temp.head()
```




    0    (-1.261, -0.827]
    1     (0.0684, 0.326]
    2    (-0.476, -0.193]
    3     (0.0684, 0.326]
    4    (-0.476, -0.193]
    Name: data1, dtype: category
    Categories (10, interval[float64]): [(-3.476, -1.261] < (-1.261, -0.827] < (-0.827, -0.476] < (-0.476, -0.193] ... (0.326, 0.596] < (0.596, 0.925] < (0.925, 1.368] < (1.368, 3.635]]




```python
grouped = frame.data2.groupby(grouping)
grouped.apply(get_stats).unstack()
```




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
      <th>count</th>
      <th>max</th>
      <th>mean</th>
      <th>min</th>
    </tr>
    <tr>
      <th>data1</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>100.0</td>
      <td>2.621324</td>
      <td>0.070152</td>
      <td>-2.179777</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100.0</td>
      <td>2.462273</td>
      <td>-0.049077</td>
      <td>-2.289337</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100.0</td>
      <td>3.762126</td>
      <td>-0.077355</td>
      <td>-3.260810</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100.0</td>
      <td>2.707121</td>
      <td>0.016885</td>
      <td>-2.551321</td>
    </tr>
    <tr>
      <th>4</th>
      <td>100.0</td>
      <td>1.805644</td>
      <td>-0.043425</td>
      <td>-2.499053</td>
    </tr>
    <tr>
      <th>5</th>
      <td>100.0</td>
      <td>2.079105</td>
      <td>-0.021532</td>
      <td>-2.564312</td>
    </tr>
    <tr>
      <th>6</th>
      <td>100.0</td>
      <td>3.026034</td>
      <td>-0.123689</td>
      <td>-3.122991</td>
    </tr>
    <tr>
      <th>7</th>
      <td>100.0</td>
      <td>2.220393</td>
      <td>-0.105029</td>
      <td>-2.630459</td>
    </tr>
    <tr>
      <th>8</th>
      <td>100.0</td>
      <td>2.454573</td>
      <td>-0.046064</td>
      <td>-2.195948</td>
    </tr>
    <tr>
      <th>9</th>
      <td>100.0</td>
      <td>2.476637</td>
      <td>0.024066</td>
      <td>-2.050193</td>
    </tr>
  </tbody>
</table>
</div>



### 示例：用特定于分组的值填充缺失值

对于缺失数据的清理工作，有时你会用dropna将其替换掉，而有时则可能会希望用一个固定值或由数据集本身所衍生出来的值去填充NA值。这时就得使用fillna这个工具了。在下面这个例子中，我用平均值去填充NA值：


```python
s = pd.Series(np.random.randn(6))
s[::2] = np.nan
s
```




    0         NaN
    1   -1.698228
    2         NaN
    3    0.250362
    4         NaN
    5   -0.981594
    dtype: float64




```python
s.fillna(s.mean())
```




    0   -0.809820
    1   -1.698228
    2   -0.809820
    3    0.250362
    4   -0.809820
    5   -0.981594
    dtype: float64



假设你需要对不同的分组填充不同的值。一种方法是将数据分组，并使用apply和一个能够对各数据块调用fillna的函数即可。


```python
states = ['Ohio', 'New York', 'Vermont', 'Florida',  'Oregon', 'Nevada', 'California', 'Idaho']

group_key = ['East'] * 4 + ['West'] * 4

group_key 
```




    ['East', 'East', 'East', 'East', 'West', 'West', 'West', 'West']




```python
data = pd.Series(np.random.randn(8), index=states)
data
```




    Ohio         -0.343101
    New York      1.024389
    Vermont       1.311144
    Florida      -0.423204
    Oregon        0.114283
    Nevada       -1.089131
    California   -1.727345
    Idaho        -0.830830
    dtype: float64




```python
data[['Vermont', 'Nevada', 'Idaho']] = np.nan
data
```




    Ohio         -0.343101
    New York      1.024389
    Vermont            NaN
    Florida      -0.423204
    Oregon        0.114283
    Nevada             NaN
    California   -1.727345
    Idaho              NaN
    dtype: float64




```python
data.groupby(group_key).mean()
```




    East    0.086028
    West   -0.806531
    dtype: float64



我们可以用分组平均值去填充NA值:


```python
fill_mean = lambda g: g.fillna(g.mean())

data.groupby(group_key).apply(fill_mean)
```




    Ohio         -0.343101
    New York      1.024389
    Vermont       0.086028
    Florida      -0.423204
    Oregon        0.114283
    Nevada       -0.806531
    California   -1.727345
    Idaho        -0.806531
    dtype: float64



也可以在代码中预定义各组的填充值。由于分组具有一个name属性，所以我们可以拿来用一下：


```python
fill_values = {'East': 0.5, 'West': -1}

fill_func = lambda g: g.fillna(fill_values[g.name])

data.groupby(group_key).apply(fill_func)
```




    Ohio         -0.343101
    New York      1.024389
    Vermont       0.500000
    Florida      -0.423204
    Oregon        0.114283
    Nevada       -1.000000
    California   -1.727345
    Idaho        -1.000000
    dtype: float64



### 示例：分组加权平均数和相关系数

根据groupby的“拆分－应用－合并”范式，可以进行DataFrame的列与列之间或两个Series之间的运算（比如分组加权平均）。以下面这个数据集为例，它含有分组键、值以及一些权重值：


```python
df = pd.DataFrame({'category': ['a', 'a', 'a', 'a', 'b', 'b', 'b', 'b'],
                   'data': np.random.randn(8),
                   'weights': np.random.rand(8)})
df
```




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
      <th>category</th>
      <th>data</th>
      <th>weights</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>-0.980463</td>
      <td>0.247153</td>
    </tr>
    <tr>
      <th>1</th>
      <td>a</td>
      <td>0.148452</td>
      <td>0.912352</td>
    </tr>
    <tr>
      <th>2</th>
      <td>a</td>
      <td>-1.067199</td>
      <td>0.719493</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a</td>
      <td>1.837065</td>
      <td>0.883523</td>
    </tr>
    <tr>
      <th>4</th>
      <td>b</td>
      <td>-1.030439</td>
      <td>0.907246</td>
    </tr>
    <tr>
      <th>5</th>
      <td>b</td>
      <td>0.120672</td>
      <td>0.538387</td>
    </tr>
    <tr>
      <th>6</th>
      <td>b</td>
      <td>-0.306529</td>
      <td>0.423223</td>
    </tr>
    <tr>
      <th>7</th>
      <td>b</td>
      <td>0.709020</td>
      <td>0.552725</td>
    </tr>
  </tbody>
</table>
</div>



利用 category 计算分组加权平均数：


```python
grouped = df.groupby('category')

get_wavg = lambda g: np.average(g['data'], weights=g['weights'])

grouped.apply(get_wavg)
```




    category
    a    0.270898
    b   -0.250964
    dtype: float64



另一个例子，考虑一个来自Yahoo!Finance的数据集，其中含有几只股票和标准普尔500指数（符号SPX）的收盘价：


```python
close_px = pd.read_csv('data/examples/stock_px_2.csv', parse_dates=True, index_col=0)
close_px.info()
```

    <class 'pandas.core.frame.DataFrame'>
    DatetimeIndex: 2214 entries, 2003-01-02 to 2011-10-14
    Data columns (total 4 columns):
    AAPL    2214 non-null float64
    MSFT    2214 non-null float64
    XOM     2214 non-null float64
    SPX     2214 non-null float64
    dtypes: float64(4)
    memory usage: 86.5 KB
    


```python
close_px.head()
```




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
      <th>AAPL</th>
      <th>MSFT</th>
      <th>XOM</th>
      <th>SPX</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003-01-02</th>
      <td>7.40</td>
      <td>21.11</td>
      <td>29.22</td>
      <td>909.03</td>
    </tr>
    <tr>
      <th>2003-01-03</th>
      <td>7.45</td>
      <td>21.14</td>
      <td>29.24</td>
      <td>908.59</td>
    </tr>
    <tr>
      <th>2003-01-06</th>
      <td>7.45</td>
      <td>21.52</td>
      <td>29.96</td>
      <td>929.01</td>
    </tr>
    <tr>
      <th>2003-01-07</th>
      <td>7.43</td>
      <td>21.93</td>
      <td>28.95</td>
      <td>922.93</td>
    </tr>
    <tr>
      <th>2003-01-08</th>
      <td>7.28</td>
      <td>21.31</td>
      <td>28.83</td>
      <td>909.93</td>
    </tr>
  </tbody>
</table>
</div>



来做一个比较有趣的任务：计算一个由日收益率（通过百分数变化计算）与SPX之间的年度相关系数组成的DataFrame。下面是一个实现办法，我们先创建一个函数，用它计算每列和SPX列的成对相关系数：


```python
spx_corr = lambda x: x.corrwith(x['SPX'])
# 我们使用pct_change计算close_px的百分比变化
rets = close_px.pct_change().dropna()
rets.head()
```




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
      <th>AAPL</th>
      <th>MSFT</th>
      <th>XOM</th>
      <th>SPX</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003-01-03</th>
      <td>0.006757</td>
      <td>0.001421</td>
      <td>0.000684</td>
      <td>-0.000484</td>
    </tr>
    <tr>
      <th>2003-01-06</th>
      <td>0.000000</td>
      <td>0.017975</td>
      <td>0.024624</td>
      <td>0.022474</td>
    </tr>
    <tr>
      <th>2003-01-07</th>
      <td>-0.002685</td>
      <td>0.019052</td>
      <td>-0.033712</td>
      <td>-0.006545</td>
    </tr>
    <tr>
      <th>2003-01-08</th>
      <td>-0.020188</td>
      <td>-0.028272</td>
      <td>-0.004145</td>
      <td>-0.014086</td>
    </tr>
    <tr>
      <th>2003-01-09</th>
      <td>0.008242</td>
      <td>0.029094</td>
      <td>0.021159</td>
      <td>0.019386</td>
    </tr>
  </tbody>
</table>
</div>



最后，我们用年对百分比变化进行分组，可以用一个一行的函数，从每行的标签返回每个datetime标签的year属性：


```python
get_year = lambda x: x.year

by_year = rets.groupby(get_year)

by_year.apply(spx_corr)
```




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
      <th>AAPL</th>
      <th>MSFT</th>
      <th>XOM</th>
      <th>SPX</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003</th>
      <td>0.541124</td>
      <td>0.745174</td>
      <td>0.661265</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2004</th>
      <td>0.374283</td>
      <td>0.588531</td>
      <td>0.557742</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2005</th>
      <td>0.467540</td>
      <td>0.562374</td>
      <td>0.631010</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2006</th>
      <td>0.428267</td>
      <td>0.406126</td>
      <td>0.518514</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2007</th>
      <td>0.508118</td>
      <td>0.658770</td>
      <td>0.786264</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2008</th>
      <td>0.681434</td>
      <td>0.804626</td>
      <td>0.828303</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2009</th>
      <td>0.707103</td>
      <td>0.654902</td>
      <td>0.797921</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2010</th>
      <td>0.710105</td>
      <td>0.730118</td>
      <td>0.839057</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2011</th>
      <td>0.691931</td>
      <td>0.800996</td>
      <td>0.859975</td>
      <td>1.0</td>
    </tr>
  </tbody>
</table>
</div>



还可以计算列与列之间的相关系数。这里，我们计算Apple和Microsoft的年相关系数：


```python
by_year.apply(lambda g: g['AAPL'].corr(g['MSFT']))
```




    2003    0.480868
    2004    0.259024
    2005    0.300093
    2006    0.161735
    2007    0.417738
    2008    0.611901
    2009    0.432738
    2010    0.571946
    2011    0.581987
    dtype: float64



### 示例：组级别的线性回归

顺着上一个例子继续，你可以用groupby执行更为复杂的分组统计分析，只要函数返回的是pandas对象或标量值即可。例如，我可以定义下面这个regress函数（利用statsmodels计量经济学库）对各数据块执行普通最小二乘法（Ordinary Least Squares，OLS）回归：


```python
import statsmodels.api as sm
def regress(data, yvar, xvars):
    Y = data[yvar]
    X = data[xvars]
    X['intercept'] = 1.
    result = sm.OLS(Y, X).fit()
    return result.params
```

现在，为了按年计算AAPL对SPX收益率的线性回归，执行：


```python
by_year.apply(regress, 'AAPL', ['SPX'])
```




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
      <th>SPX</th>
      <th>intercept</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003</th>
      <td>1.195406</td>
      <td>0.000710</td>
    </tr>
    <tr>
      <th>2004</th>
      <td>1.363463</td>
      <td>0.004201</td>
    </tr>
    <tr>
      <th>2005</th>
      <td>1.766415</td>
      <td>0.003246</td>
    </tr>
    <tr>
      <th>2006</th>
      <td>1.645496</td>
      <td>0.000080</td>
    </tr>
    <tr>
      <th>2007</th>
      <td>1.198761</td>
      <td>0.003438</td>
    </tr>
    <tr>
      <th>2008</th>
      <td>0.968016</td>
      <td>-0.001110</td>
    </tr>
    <tr>
      <th>2009</th>
      <td>0.879103</td>
      <td>0.002954</td>
    </tr>
    <tr>
      <th>2010</th>
      <td>1.052608</td>
      <td>0.001261</td>
    </tr>
    <tr>
      <th>2011</th>
      <td>0.806605</td>
      <td>0.001514</td>
    </tr>
  </tbody>
</table>
</div>



## 透视表和交叉表

透视表（pivot table）是各种电子表格程序和其他数据分析软件中一种常见的数据汇总工具。它根据一个或多个键对数据进行聚合，并根据行和列上的分组键将数据分配到各个矩形区域中。在Python和pandas中，可以通过本章所介绍的groupby功能以及（能够利用层次化索引的）重塑运算制作透视表。DataFrame有一个pivot_table方法，此外还有一个顶级的pandas.pivot_table函数。除能为groupby提供便利之外，pivot_table还可以添加分项小计，也叫做margins。


```python
tips.head()
```




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
      <th>total_bill</th>
      <th>tip</th>
      <th>smoker</th>
      <th>day</th>
      <th>time</th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>16.99</td>
      <td>1.01</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.059447</td>
    </tr>
    <tr>
      <th>1</th>
      <td>10.34</td>
      <td>1.66</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>3</td>
      <td>0.160542</td>
    </tr>
    <tr>
      <th>2</th>
      <td>21.01</td>
      <td>3.50</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>3</td>
      <td>0.166587</td>
    </tr>
    <tr>
      <th>3</th>
      <td>23.68</td>
      <td>3.31</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>2</td>
      <td>0.139780</td>
    </tr>
    <tr>
      <th>4</th>
      <td>24.59</td>
      <td>3.61</td>
      <td>No</td>
      <td>Sun</td>
      <td>Dinner</td>
      <td>4</td>
      <td>0.146808</td>
    </tr>
  </tbody>
</table>
</div>



假设我想要根据day和smoker计算分组平均数（pivot_table的默认聚合类型），并将day和smoker放到行上：


```python
tips.pivot_table(index=['day', 'smoker'])
```




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
      <th></th>
      <th>size</th>
      <th>tip</th>
      <th>tip_pct</th>
      <th>total_bill</th>
    </tr>
    <tr>
      <th>day</th>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Fri</th>
      <th>No</th>
      <td>2.250000</td>
      <td>2.812500</td>
      <td>0.151650</td>
      <td>18.420000</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>2.066667</td>
      <td>2.714000</td>
      <td>0.174783</td>
      <td>16.813333</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sat</th>
      <th>No</th>
      <td>2.555556</td>
      <td>3.102889</td>
      <td>0.158048</td>
      <td>19.661778</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>2.476190</td>
      <td>2.875476</td>
      <td>0.147906</td>
      <td>21.276667</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Sun</th>
      <th>No</th>
      <td>2.929825</td>
      <td>3.167895</td>
      <td>0.160113</td>
      <td>20.506667</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>2.578947</td>
      <td>3.516842</td>
      <td>0.187250</td>
      <td>24.120000</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Thur</th>
      <th>No</th>
      <td>2.488889</td>
      <td>2.673778</td>
      <td>0.160298</td>
      <td>17.113111</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>2.352941</td>
      <td>3.030000</td>
      <td>0.163863</td>
      <td>19.190588</td>
    </tr>
  </tbody>
</table>
</div>



可以用groupby直接来做。现在，假设我们只想聚合tip_pct和size，而且想根据time进行分组。我将smoker放到列上，把day放到行上：


```python
tips.pivot_table(['tip_pct', 'size'], index=['time', 'day'], columns='smoker')
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th colspan="2" halign="left">size</th>
      <th colspan="2" halign="left">tip_pct</th>
    </tr>
    <tr>
      <th></th>
      <th>smoker</th>
      <th>No</th>
      <th>Yes</th>
      <th>No</th>
      <th>Yes</th>
    </tr>
    <tr>
      <th>time</th>
      <th>day</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="4" valign="top">Dinner</th>
      <th>Fri</th>
      <td>2.000000</td>
      <td>2.222222</td>
      <td>0.139622</td>
      <td>0.165347</td>
    </tr>
    <tr>
      <th>Sat</th>
      <td>2.555556</td>
      <td>2.476190</td>
      <td>0.158048</td>
      <td>0.147906</td>
    </tr>
    <tr>
      <th>Sun</th>
      <td>2.929825</td>
      <td>2.578947</td>
      <td>0.160113</td>
      <td>0.187250</td>
    </tr>
    <tr>
      <th>Thur</th>
      <td>2.000000</td>
      <td>NaN</td>
      <td>0.159744</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Lunch</th>
      <th>Fri</th>
      <td>3.000000</td>
      <td>1.833333</td>
      <td>0.187735</td>
      <td>0.188937</td>
    </tr>
    <tr>
      <th>Thur</th>
      <td>2.500000</td>
      <td>2.352941</td>
      <td>0.160311</td>
      <td>0.163863</td>
    </tr>
  </tbody>
</table>
</div>




```python
tips.pivot_table(['tip_pct', 'size'], index=['time', 'day'])
```




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
      <th></th>
      <th>size</th>
      <th>tip_pct</th>
    </tr>
    <tr>
      <th>time</th>
      <th>day</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="4" valign="top">Dinner</th>
      <th>Fri</th>
      <td>2.166667</td>
      <td>0.158916</td>
    </tr>
    <tr>
      <th>Sat</th>
      <td>2.517241</td>
      <td>0.153152</td>
    </tr>
    <tr>
      <th>Sun</th>
      <td>2.842105</td>
      <td>0.166897</td>
    </tr>
    <tr>
      <th>Thur</th>
      <td>2.000000</td>
      <td>0.159744</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Lunch</th>
      <th>Fri</th>
      <td>2.000000</td>
      <td>0.188765</td>
    </tr>
    <tr>
      <th>Thur</th>
      <td>2.459016</td>
      <td>0.161301</td>
    </tr>
  </tbody>
</table>
</div>



还可以对这个表作进一步的处理，传入 `margins=True` 添加分项小计。这将会添加标签为All的行和列，其值对应于单个等级中所有数据的分组统计：


```python
tips.pivot_table(['tip_pct', 'size'], index=['time', 'day'], columns='smoker', margins=True)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th colspan="3" halign="left">size</th>
      <th colspan="3" halign="left">tip_pct</th>
    </tr>
    <tr>
      <th></th>
      <th>smoker</th>
      <th>No</th>
      <th>Yes</th>
      <th>All</th>
      <th>No</th>
      <th>Yes</th>
      <th>All</th>
    </tr>
    <tr>
      <th>time</th>
      <th>day</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="4" valign="top">Dinner</th>
      <th>Fri</th>
      <td>2.000000</td>
      <td>2.222222</td>
      <td>2.166667</td>
      <td>0.139622</td>
      <td>0.165347</td>
      <td>0.158916</td>
    </tr>
    <tr>
      <th>Sat</th>
      <td>2.555556</td>
      <td>2.476190</td>
      <td>2.517241</td>
      <td>0.158048</td>
      <td>0.147906</td>
      <td>0.153152</td>
    </tr>
    <tr>
      <th>Sun</th>
      <td>2.929825</td>
      <td>2.578947</td>
      <td>2.842105</td>
      <td>0.160113</td>
      <td>0.187250</td>
      <td>0.166897</td>
    </tr>
    <tr>
      <th>Thur</th>
      <td>2.000000</td>
      <td>NaN</td>
      <td>2.000000</td>
      <td>0.159744</td>
      <td>NaN</td>
      <td>0.159744</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Lunch</th>
      <th>Fri</th>
      <td>3.000000</td>
      <td>1.833333</td>
      <td>2.000000</td>
      <td>0.187735</td>
      <td>0.188937</td>
      <td>0.188765</td>
    </tr>
    <tr>
      <th>Thur</th>
      <td>2.500000</td>
      <td>2.352941</td>
      <td>2.459016</td>
      <td>0.160311</td>
      <td>0.163863</td>
      <td>0.161301</td>
    </tr>
    <tr>
      <th>All</th>
      <th></th>
      <td>2.668874</td>
      <td>2.408602</td>
      <td>2.569672</td>
      <td>0.159328</td>
      <td>0.163196</td>
      <td>0.160803</td>
    </tr>
  </tbody>
</table>
</div>



要使用其他的聚合函数，将其传给aggfunc即可。例如，使用count或len可以得到有关分组大小的交叉表（计数或频率）：


```python
tips.pivot_table('tip_pct', index=['time', 'smoker'], columns='day', aggfunc=len, margins=True)
```




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
      <th>day</th>
      <th>Fri</th>
      <th>Sat</th>
      <th>Sun</th>
      <th>Thur</th>
      <th>All</th>
    </tr>
    <tr>
      <th>time</th>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">Dinner</th>
      <th>No</th>
      <td>3.0</td>
      <td>45.0</td>
      <td>57.0</td>
      <td>1.0</td>
      <td>106.0</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>9.0</td>
      <td>42.0</td>
      <td>19.0</td>
      <td>NaN</td>
      <td>70.0</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">Lunch</th>
      <th>No</th>
      <td>1.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>44.0</td>
      <td>45.0</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>6.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>17.0</td>
      <td>23.0</td>
    </tr>
    <tr>
      <th>All</th>
      <th></th>
      <td>19.0</td>
      <td>87.0</td>
      <td>76.0</td>
      <td>62.0</td>
      <td>244.0</td>
    </tr>
  </tbody>
</table>
</div>



如果存在空的组合（也就是NA），你可能会希望设置一个fill_value：


```python
tips.pivot_table('tip_pct', index=['time', 'size', 'smoker'],
                 columns='day', aggfunc='mean', fill_value=0)
```




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
      <th></th>
      <th>day</th>
      <th>Fri</th>
      <th>Sat</th>
      <th>Sun</th>
      <th>Thur</th>
    </tr>
    <tr>
      <th>time</th>
      <th>size</th>
      <th>smoker</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="11" valign="top">Dinner</th>
      <th rowspan="2" valign="top">1</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.137931</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.000000</td>
      <td>0.325733</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">2</th>
      <th>No</th>
      <td>0.139622</td>
      <td>0.162705</td>
      <td>0.168859</td>
      <td>0.159744</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.171297</td>
      <td>0.148668</td>
      <td>0.207893</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">3</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.154661</td>
      <td>0.152663</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.000000</td>
      <td>0.144995</td>
      <td>0.152660</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">4</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.150096</td>
      <td>0.148143</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.117750</td>
      <td>0.124515</td>
      <td>0.193370</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">5</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.206928</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.000000</td>
      <td>0.106572</td>
      <td>0.065660</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.103799</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th rowspan="10" valign="top">Lunch</th>
      <th rowspan="2" valign="top">1</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.181728</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.223776</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">2</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.166005</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.181969</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.158843</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">3</th>
      <th>No</th>
      <td>0.187735</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.084246</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.204952</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">4</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.138919</td>
    </tr>
    <tr>
      <th>Yes</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.155410</td>
    </tr>
    <tr>
      <th>5</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.121389</td>
    </tr>
    <tr>
      <th>6</th>
      <th>No</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.173706</td>
    </tr>
  </tbody>
</table>
</div>



pivot_table的参数说明请参见表  
![](http://upload-images.jianshu.io/upload_images/7178691-c9e01844c4803a42.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

# pandas高级应用

## 分类数据

通过使用它，提高性能和内存的使用率。

### 背景和目的

表中的一列通常会有重复的包含不同值的小集合的情况。我们已经学过了unique和value_counts，它们可以从数组提取出不同的值，并分别计算频率：


```python
values = pd.Series(['apple', 'orange', 'apple', 'apple'] * 2)
values
```




    0     apple
    1    orange
    2     apple
    3     apple
    4     apple
    5    orange
    6     apple
    7     apple
    dtype: object




```python
pd.unique(values)
```




    array(['apple', 'orange'], dtype=object)




```python
pd.value_counts(values)
```




    apple     6
    orange    2
    dtype: int64



许多数据系统（数据仓库、统计计算或其它应用）都发展出了特定的表征重复值的方法，以进行高效的存储和计算。在数据仓库中，最好的方法是使用所谓的包含不同值的维表(Dimension Table)，将主要的参数存储为引用维表整数键：

就像 mysql 的分表存储


```python
values = pd.Series([0, 1, 0, 0] * 2)
values
```




    0    0
    1    1
    2    0
    3    0
    4    0
    5    1
    6    0
    7    0
    dtype: int64




```python
dim = pd.Series(['apple', 'orange'])
dim
```




    0     apple
    1    orange
    dtype: object



可以使用take方法存储原始的字符串Series：


```python
dim.take(values)
```




    0     apple
    1    orange
    0     apple
    0     apple
    0     apple
    1    orange
    0     apple
    0     apple
    dtype: object



这种用整数表示的方法称为分类或字典编码表示法。不同值得数组称为分类、字典或数据级。本书中，我们使用分类的说法。表示分类的整数值称为分类编码或简单地称为编码。

### pandas的分类类型

pandas有一个特殊的分类类型，用于保存使用整数分类表示法的数据。


```python
fruits = ['apple', 'orange', 'apple', 'apple'] * 2

N = len(fruits)

df = pd.DataFrame({'fruit': fruits,  
                   'basket_id': np.arange(N), 
                   'count': np.random.randint(3, 15, size=N),
                   'weight': np.random.uniform(0, 4, size=N)},
                   columns=['basket_id', 'fruit', 'count', 'weight'])
df
```




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
      <th>basket_id</th>
      <th>fruit</th>
      <th>count</th>
      <th>weight</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>apple</td>
      <td>11</td>
      <td>0.661412</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>orange</td>
      <td>6</td>
      <td>2.661072</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>apple</td>
      <td>10</td>
      <td>3.956839</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>apple</td>
      <td>10</td>
      <td>3.491835</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>apple</td>
      <td>6</td>
      <td>2.954149</td>
    </tr>
    <tr>
      <th>5</th>
      <td>5</td>
      <td>orange</td>
      <td>12</td>
      <td>3.967850</td>
    </tr>
    <tr>
      <th>6</th>
      <td>6</td>
      <td>apple</td>
      <td>8</td>
      <td>0.093289</td>
    </tr>
    <tr>
      <th>7</th>
      <td>7</td>
      <td>apple</td>
      <td>3</td>
      <td>3.056569</td>
    </tr>
  </tbody>
</table>
</div>



这里，`df['fruit']` 是一个Python字符串对象的数组。我们可以通过调用它，将它转变为分类：


```python
fruit_cat = df['fruit'].astype('category')
fruit_cat
```




    0     apple
    1    orange
    2     apple
    3     apple
    4     apple
    5    orange
    6     apple
    7     apple
    Name: fruit, dtype: category
    Categories (2, object): [apple, orange]



fruit_cat的值不是NumPy数组，而是一个pandas.Categorical实例：


```python
c = fruit_cat.values
c
```




    [apple, orange, apple, apple, apple, orange, apple, apple]
    Categories (2, object): [apple, orange]




```python
type(c)
```




    pandas.core.arrays.categorical.Categorical



分类对象有categories和codes属性：


```python
c.categories
```




    Index(['apple', 'orange'], dtype='object')




```python
c.codes
```




    array([0, 1, 0, 0, 0, 1, 0, 0], dtype=int8)



你可将DataFrame的列通过分配转换结果，转换为分类：


```python
df['fruit'] = df['fruit'].astype('category')
```


```python
df
```




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
      <th>basket_id</th>
      <th>fruit</th>
      <th>count</th>
      <th>weight</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>apple</td>
      <td>11</td>
      <td>0.661412</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>orange</td>
      <td>6</td>
      <td>2.661072</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>apple</td>
      <td>10</td>
      <td>3.956839</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>apple</td>
      <td>10</td>
      <td>3.491835</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>apple</td>
      <td>6</td>
      <td>2.954149</td>
    </tr>
    <tr>
      <th>5</th>
      <td>5</td>
      <td>orange</td>
      <td>12</td>
      <td>3.967850</td>
    </tr>
    <tr>
      <th>6</th>
      <td>6</td>
      <td>apple</td>
      <td>8</td>
      <td>0.093289</td>
    </tr>
    <tr>
      <th>7</th>
      <td>7</td>
      <td>apple</td>
      <td>3</td>
      <td>3.056569</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.fruit
```




    0     apple
    1    orange
    2     apple
    3     apple
    4     apple
    5    orange
    6     apple
    7     apple
    Name: fruit, dtype: category
    Categories (2, object): [apple, orange]



你还可以从其它Python序列直接创建pandas.Categorical：


```python
my_categories = pd.Categorical(['foo', 'bar', 'baz', 'foo', 'bar'])
my_categories
```




    [foo, bar, baz, foo, bar]
    Categories (3, object): [bar, baz, foo]



如果你已经从其它源获得了分类编码，你还可以使用from_codes构造器：


```python
categories = ['foo', 'bar', 'baz']

codes = [0, 1, 2, 0, 0, 1]

my_cats_2 = pd.Categorical.from_codes(codes, categories)

my_cats_2
```




    [foo, bar, baz, foo, foo, bar]
    Categories (3, object): [foo, bar, baz]



与显示指定不同，分类变换不认定指定的分类顺序。因此取决于输入数据的顺序，categories数组的顺序会不同。当使用from_codes或其它的构造器时，你可以指定分类一个有意义的顺序：


```python
ordered_cat = pd.Categorical.from_codes(codes, categories, ordered=True)
ordered_cat
```




    [foo, bar, baz, foo, foo, bar]
    Categories (3, object): [foo < bar < baz]



无序的分类实例可以通过as_ordered排序：


```python
my_cats_2.as_ordered()
```




    [foo, bar, baz, foo, foo, bar]
    Categories (3, object): [foo < bar < baz]



### 用分类进行计算

来看一些随机的数值数据，使用pandas.qcut面元函数。它会返回pandas.Categorical，我们之前使用过pandas.cut，但没解释分类是如何工作的：


```python
np.random.seed(12345)

draws = np.random.randn(1000)
draws[:5]
```




    array([-0.20470766,  0.47894334, -0.51943872, -0.5557303 ,  1.96578057])



计算这个数据的分位面元，提取一些统计信息：


```python
bins = pd.qcut(draws, 4)
bins
```




    [(-0.684, -0.0101], (-0.0101, 0.63], (-0.684, -0.0101], (-0.684, -0.0101], (0.63, 3.928], ..., (-0.0101, 0.63], (-0.684, -0.0101], (-2.9499999999999997, -0.684], (-0.0101, 0.63], (0.63, 3.928]]
    Length: 1000
    Categories (4, interval[float64]): [(-2.9499999999999997, -0.684] < (-0.684, -0.0101] < (-0.0101, 0.63] < (0.63, 3.928]]



虽然有用，确切的样本分位数与分位的名称相比，不利于生成汇总。我们可以使用labels参数qcut，实现目的：


```python
bins = pd.qcut(draws, 4, labels=['Q1', 'Q2', 'Q3', 'Q4'])
bins
```




    [Q2, Q3, Q2, Q2, Q4, ..., Q3, Q2, Q1, Q3, Q4]
    Length: 1000
    Categories (4, object): [Q1 < Q2 < Q3 < Q4]




```python
bins.codes[:10]
```




    array([1, 2, 1, 1, 3, 3, 2, 2, 3, 3], dtype=int8)



加上标签的面元分类不包含数据面元边界的信息，因此可以使用groupby提取一些汇总信息：


```python
bins = pd.Series(bins, name='quartile')
bins.head()
```




    0    Q2
    1    Q3
    2    Q2
    3    Q2
    4    Q4
    Name: quartile, dtype: category
    Categories (4, object): [Q1 < Q2 < Q3 < Q4]




```python
results = (pd.Series(draws)
           .groupby(bins)
           .agg(['count', 'min', 'max'])
           .reset_index())
results
```




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
      <th>quartile</th>
      <th>count</th>
      <th>min</th>
      <th>max</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Q1</td>
      <td>250</td>
      <td>-2.949343</td>
      <td>-0.685484</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Q2</td>
      <td>250</td>
      <td>-0.683066</td>
      <td>-0.010115</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Q3</td>
      <td>250</td>
      <td>-0.010032</td>
      <td>0.628894</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Q4</td>
      <td>250</td>
      <td>0.634238</td>
      <td>3.927528</td>
    </tr>
  </tbody>
</table>
</div>



分位数列保存了原始的面元分类信息，包括排序：


```python
results['quartile']
```




    0    Q1
    1    Q2
    2    Q3
    3    Q4
    Name: quartile, dtype: category
    Categories (4, object): [Q1 < Q2 < Q3 < Q4]



### 用分类提高性能

如果你是在一个特定数据集上做大量分析，将其转换为分类可以极大地提高效率。DataFrame列的分类使用的内存通常少的多。来看一些包含一千万元素的Series，和一些不同的分类：


```python
N = 10000000
draws = pd.Series(np.random.randn(N))

labels = pd.Series(['foo', 'bar', 'baz', 'qux'] * (N // 4))
```

现在，将标签转换为分类：


```python
categories = labels.astype('category')
```

这时，可以看到标签使用的内存远比分类多：


```python
labels.memory_usage()
```




    80000080




```python
categories.memory_usage()
```




    10000272



转换为分类不是没有代价的，但这是一次性的代价：


```python
%time _ = labels.astype('category')
```

    Wall time: 429 ms
    

GroupBy使用分类操作明显更快，是因为底层的算法使用整数编码数组，而不是字符串数组。

### 分类方法

包含分类数据的Series有一些特殊的方法，类似于Series.str字符串方法。它还提供了方便的分类和编码的使用方法。看下面的Series：


```python
s = pd.Series(['a', 'b', 'c', 'd'] * 2)

cat_s = s.astype('category')

cat_s
```




    0    a
    1    b
    2    c
    3    d
    4    a
    5    b
    6    c
    7    d
    dtype: category
    Categories (4, object): [a, b, c, d]



特别的cat属性提供了分类方法的入口：


```python
cat_s.cat.codes
```




    0    0
    1    1
    2    2
    3    3
    4    0
    5    1
    6    2
    7    3
    dtype: int8




```python
cat_s.cat.categories
```




    Index(['a', 'b', 'c', 'd'], dtype='object')



假设我们知道这个数据的实际分类集，超出了数据中的四个值。我们可以使用set_categories方法改变它们：


```python
actual_categories = ['a', 'b', 'c', 'd', 'e']
cat_s2 = cat_s.cat.set_categories(actual_categories)
cat_s2
```




    0    a
    1    b
    2    c
    3    d
    4    a
    5    b
    6    c
    7    d
    dtype: category
    Categories (5, object): [a, b, c, d, e]



虽然数据看起来没变，新的分类将反映在它们的操作中。例如，如果有的话，value_counts表示分类：


```python
cat_s.value_counts()
```




    d    2
    c    2
    b    2
    a    2
    dtype: int64




```python
cat_s2.value_counts()
```




    d    2
    c    2
    b    2
    a    2
    e    0
    dtype: int64



在大数据集中，分类经常作为节省内存和高性能的便捷工具。过滤完大DataFrame或Series之后，许多分类可能不会出现在数据中。我们可以使用remove_unused_categories方法删除没看到的分类：


```python
cat_s3 = cat_s[cat_s.isin(['a', 'b'])]
cat_s3
```




    0    a
    1    b
    4    a
    5    b
    dtype: category
    Categories (4, object): [a, b, c, d]




```python
cat_s3.cat.remove_unused_categories()
```




    0    a
    1    b
    4    a
    5    b
    dtype: category
    Categories (2, object): [a, b]



可用的分类方法  
![](http://upload-images.jianshu.io/upload_images/7178691-6c602152c2bba658.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### 为建模创建虚拟变量

当你使用统计或机器学习工具时，通常会将分类数据转换为虚拟变量，也称为one-hot编码。这包括创建一个不同类别的列的DataFrame；这些列包含给定分类的1s，其它为0。


```python
cat_s = pd.Series(['a', 'b', 'c', 'd'] * 2, dtype='category')
cat_s
```




    0    a
    1    b
    2    c
    3    d
    4    a
    5    b
    6    c
    7    d
    dtype: category
    Categories (4, object): [a, b, c, d]



pandas.get_dummies 函数可以转换这个分类数据为包含虚拟变量的DataFrame：


```python
pd.get_dummies(cat_s)
```




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
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



### GroupBy高级应用

### 分组转换

在分组操作中学习了apply方法，进行转换。还有另一个transform方法，它与apply很像，但是对使用的函数有一定限制：  
1. 它可以产生向分组形状广播标量值
2. 它可以产生一个和输入组形状相同的对象
3. 它不能修改输入


```python
df = pd.DataFrame({'key': ['a', 'b', 'c'] * 4,  'value': np.arange(12.)})
df
```




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
      <th>key</th>
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>c</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>a</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>b</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>c</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>a</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>b</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>c</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>a</td>
      <td>9.0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>b</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>c</td>
      <td>11.0</td>
    </tr>
  </tbody>
</table>
</div>



按键进行分组：


```python
g = df.groupby('key').value
g.mean()
```




    key
    a    4.5
    b    5.5
    c    6.5
    Name: value, dtype: float64



假设我们想产生一个和 `df['value']` 形状相同的Series，但值替换为按键分组的平均值。我们可以传递函数 `lambda x: x.mean()` 进行转换：


```python
g.transform(lambda x: x.mean())
```




    0     4.5
    1     5.5
    2     6.5
    3     4.5
    4     5.5
    5     6.5
    6     4.5
    7     5.5
    8     6.5
    9     4.5
    10    5.5
    11    6.5
    Name: value, dtype: float64



对于内置的聚合函数，我们可以传递一个字符串假名作为GroupBy的agg方法：


```python
g.transform('mean')
```




    0     4.5
    1     5.5
    2     6.5
    3     4.5
    4     5.5
    5     6.5
    6     4.5
    7     5.5
    8     6.5
    9     4.5
    10    5.5
    11    6.5
    Name: value, dtype: float64



与apply类似，transform的函数会返回Series，但是结果必须与输入大小相同。举个例子，我们可以用lambda函数将每个分组乘以2：


```python
g.transform(lambda x: x * 2)
```




    0      0.0
    1      2.0
    2      4.0
    3      6.0
    4      8.0
    5     10.0
    6     12.0
    7     14.0
    8     16.0
    9     18.0
    10    20.0
    11    22.0
    Name: value, dtype: float64



看一个由简单聚合构造的的分组转换函数：  
我们用transform或apply可以获得等价的结果：


```python
def normalize(x):
    return (x - x.mean()) / x.std()
g.transform(normalize)
```




    0    -1.161895
    1    -1.161895
    2    -1.161895
    3    -0.387298
    4    -0.387298
    5    -0.387298
    6     0.387298
    7     0.387298
    8     0.387298
    9     1.161895
    10    1.161895
    11    1.161895
    Name: value, dtype: float64




```python
g.apply(normalize)
```




    0    -1.161895
    1    -1.161895
    2    -1.161895
    3    -0.387298
    4    -0.387298
    5    -0.387298
    6     0.387298
    7     0.387298
    8     0.387298
    9     1.161895
    10    1.161895
    11    1.161895
    Name: value, dtype: float64



### 分组的时间重采样

对于时间序列数据，resample方法从语义上是一个基于内在时间的分组操作。


```python
N = 15

times = pd.date_range('2017-05-20 00:00', freq='1min', periods=N)

df = pd.DataFrame({'time': times, 'value': np.arange(N)})
df
```




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
      <th>time</th>
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2017-05-20 00:00:00</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2017-05-20 00:01:00</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2017-05-20 00:02:00</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2017-05-20 00:03:00</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2017-05-20 00:04:00</td>
      <td>4</td>
    </tr>
    <tr>
      <th>5</th>
      <td>2017-05-20 00:05:00</td>
      <td>5</td>
    </tr>
    <tr>
      <th>6</th>
      <td>2017-05-20 00:06:00</td>
      <td>6</td>
    </tr>
    <tr>
      <th>7</th>
      <td>2017-05-20 00:07:00</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8</th>
      <td>2017-05-20 00:08:00</td>
      <td>8</td>
    </tr>
    <tr>
      <th>9</th>
      <td>2017-05-20 00:09:00</td>
      <td>9</td>
    </tr>
    <tr>
      <th>10</th>
      <td>2017-05-20 00:10:00</td>
      <td>10</td>
    </tr>
    <tr>
      <th>11</th>
      <td>2017-05-20 00:11:00</td>
      <td>11</td>
    </tr>
    <tr>
      <th>12</th>
      <td>2017-05-20 00:12:00</td>
      <td>12</td>
    </tr>
    <tr>
      <th>13</th>
      <td>2017-05-20 00:13:00</td>
      <td>13</td>
    </tr>
    <tr>
      <th>14</th>
      <td>2017-05-20 00:14:00</td>
      <td>14</td>
    </tr>
  </tbody>
</table>
</div>



这里，我们可以用time作为索引，然后重采样：


```python
df.set_index('time').resample('5min').count()
```




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
      <th>value</th>
    </tr>
    <tr>
      <th>time</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2017-05-20 00:00:00</th>
      <td>5</td>
    </tr>
    <tr>
      <th>2017-05-20 00:05:00</th>
      <td>5</td>
    </tr>
    <tr>
      <th>2017-05-20 00:10:00</th>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>



假设DataFrame包含多个时间序列，用一个额外的分组键的列进行标记：


```python
df2 = pd.DataFrame({'time': times.repeat(3),
                    'key': np.tile(['a', 'b', 'c'], N),
                    'value': np.arange(N * 3.)})
df2.head()
```




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
      <th>time</th>
      <th>key</th>
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2017-05-20 00:00:00</td>
      <td>a</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2017-05-20 00:00:00</td>
      <td>b</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2017-05-20 00:00:00</td>
      <td>c</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2017-05-20 00:01:00</td>
      <td>a</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2017-05-20 00:01:00</td>
      <td>b</td>
      <td>4.0</td>
    </tr>
  </tbody>
</table>
</div>




```python

```
