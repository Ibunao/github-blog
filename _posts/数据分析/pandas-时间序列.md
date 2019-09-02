---
title: pandas 时间序列
date: 2019-04-15 11:56:02
tags:
    - pandas 时间序列 
categories:   
    - 数据分析  
    - pandas  
---


[参考引用](https://seancheney.gitbook.io/python-for-data-analysis-2nd/di-11-zhang-shi-jian-xu-lie#tong-guo-shi-qi-jin-hang-zhong-cai-yang)


```python
import pandas as pd
from pandas import Series, DataFrame
import numpy as np
from numpy import nan as NA
from datetime import datetime
from datetime import timedelta
from dateutil.parser import parse
from pandas.tseries.offsets import Hour, Minute
from pandas.tseries.offsets import Day, MonthEnd
import pytz
from pandas.tseries.offsets import Hour
```

pandas提供了许多内置的时间序列处理工具和数据算法。因此，你可以高效处理非常大的时间序列，轻松地进行切片/切块、聚合、对定期/不定期的时间序列进行重采样等。有些工具特别适合金融和经济应用，你当然也可以用它们来分析服务器日志数据。
<!-- more -->
## 日期和时间数据类型及工具

python 标准库提供的相关的时间库

Python标准库包含用于日期（date）和时间（time）数据的数据类型，而且还有日历方面的功能。我们主要会用到datetime、time以及calendar模块。datetime.datetime（也可以简写为datetime）是用得最多的数据类型：


```python
now = datetime.now()
now
```




    datetime.datetime(2019, 5, 14, 9, 21, 6, 222759)




```python
now.year, now.month, now.day
```




    (2019, 5, 14)



datetime以毫秒形式存储日期和时间。timedelta表示两个datetime对象之间的时间差：


```python
delta = datetime(2011, 1, 7) - datetime(2008, 6, 24, 8, 15)
delta
```




    datetime.timedelta(days=926, seconds=56700)




```python
delta.days, delta.seconds
```




    (926, 56700)




```python
timedelta(12)
```




    datetime.timedelta(days=12)




```python
start = datetime(2011, 1, 7)
start + timedelta(12)
```




    datetime.datetime(2011, 1, 19, 0, 0)




```python
start - 2 * timedelta(12)
```




    datetime.datetime(2010, 12, 14, 0, 0)



datetime模块中的数据类型  
![datetime模块中的数据类型](https://upload-images.jianshu.io/upload_images/7178691-4af261a305a70aeb.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)  

### 字符串和datetime的相互转换

利用str或strftime方法（传入一个格式化字符串），datetime对象和pandas的Timestamp对象（稍后就会介绍）可以被格式化为字符串：


```python
stamp = datetime(2011, 1, 3)
stamp
```




    datetime.datetime(2011, 1, 3, 0, 0)




```python
str(stamp)
```




    '2011-01-03 00:00:00'




```python
stamp.strftime('%Y-%m-%d')
```




    '2011-01-03'



datetime格式定义  

![](https://upload-images.jianshu.io/upload_images/7178691-50c751823754df58.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)  


![](https://upload-images.jianshu.io/upload_images/7178691-de0181e1f6b45eaf.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240). 


datetime.strptime可以用这些格式化编码将字符串转换为日期：


```python
value = '2011-01-03'
datetime.strptime(value, '%Y-%m-%d')
```




    datetime.datetime(2011, 1, 3, 0, 0)




```python
datestrs = ['7/6/2011', '8/6/2011']
[datetime.strptime(x, '%m/%d/%Y') for x in datestrs]
```




    [datetime.datetime(2011, 7, 6, 0, 0), datetime.datetime(2011, 8, 6, 0, 0)]



datetime.strptime是通过已知格式进行日期解析的最佳方式。但是每次都要编写格式定义是很麻烦的事情，尤其是对于一些常见的日期格式。这种情况下，你可以用dateutil这个第三方包中的parser.parse方法（pandas中已经自动安装好了）


```python
parse('2011-01-03')
```




    datetime.datetime(2011, 1, 3, 0, 0)




```python
parse('Jan 31, 1997 10:45 PM')
```




    datetime.datetime(1997, 1, 31, 22, 45)



在国际通用的格式中，日出现在月的前面很普遍，传入dayfirst=True即可解决这个问题：


```python
parse('6/12/2011', dayfirst=True)
```




    datetime.datetime(2011, 12, 6, 0, 0)



pandas通常是用于处理成组日期的，不管这些日期是DataFrame的轴索引还是列。to_datetime方法可以解析多种不同的日期表示形式。对标准日期格式（如ISO8601）的解析非常快：


```python
datestrs = ['2011-07-06 12:00:00', '2011-08-06 00:00:00']
pd.to_datetime(datestrs)
```




    DatetimeIndex(['2011-07-06 12:00:00', '2011-08-06 00:00:00'], dtype='datetime64[ns]', freq=None)



它还可以处理缺失值（None、空字符串等）：


```python
idx = pd.to_datetime(datestrs + [None])
idx
```




    DatetimeIndex(['2011-07-06 12:00:00', '2011-08-06 00:00:00', 'NaT'], dtype='datetime64[ns]', freq=None)




```python
idx[2]
```




    NaT




```python
pd.isnull(idx)
```




    array([False, False,  True])



NaT（Not a Time）是pandas中时间戳数据的null值。  
> 注意：dateutil.parser是一个实用但不完美的工具。比如说，它会把一些原本不是日期的字符串认作是日期（比如"42"会被解析为2042年的今天）。  

datetime对象还有一些特定于当前环境（位于不同国家或使用不同语言的系统）的格式化选项。例如，德语或法语系统所用的月份简写就与英语系统所用的不同。下表进行了总结。  
特定于当前环境的日期格式  
[Python中获取当前日期的格式](https://www.cnblogs.com/wenBlog/p/6023742.html)
![特定于当前环境的日期格式](https://upload-images.jianshu.io/upload_images/7178691-cf0119398273e2b0.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)


```python
datetime(2011, 1, 3).strftime("%A")
```




    'Monday'



## 时间序列基础

pandas最基本的时间序列类型就是以时间戳（通常以Python字符串或datatime对象表示）为索引的Series：


```python
dates = [datetime(2011, 1, 2), datetime(2011, 1, 5), datetime(2011, 1, 7), 
         datetime(2011, 1, 8), datetime(2011, 1, 10), datetime(2011, 1, 12)]
ts = pd.Series(np.random.randn(6), index=dates)
ts
```




    2011-01-02    0.502699
    2011-01-05    1.188837
    2011-01-07   -1.558365
    2011-01-08    0.770966
    2011-01-10    0.372228
    2011-01-12   -1.640982
    dtype: float64



这些datetime对象实际上是被放在一个DatetimeIndex中的：


```python
ts.index
```




    DatetimeIndex(['2011-01-02', '2011-01-05', '2011-01-07', '2011-01-08',
                   '2011-01-10', '2011-01-12'],
                  dtype='datetime64[ns]', freq=None)



跟其他Series一样，不同索引的时间序列之间的算术运算会自动按日期对齐：


```python
# ts[::2] 是每隔两个取一个
ts + ts[::2]
```




    2011-01-02    1.005399
    2011-01-05         NaN
    2011-01-07   -3.116730
    2011-01-08         NaN
    2011-01-10    0.744455
    2011-01-12         NaN
    dtype: float64



pandas用NumPy的datetime64数据类型以纳秒形式存储时间戳：


```python
ts.index.dtype
```




    dtype('<M8[ns]')



DatetimeIndex中的各个标量值是pandas的Timestamp对象：


```python
ts.index[0]
```




    Timestamp('2011-01-02 00:00:00')



只要有需要，TimeStamp可以随时自动转换为datetime对象。此外，它还可以存储频率信息（如果有的话），且知道如何执行时区转换以及其他操作。

### 索引、选取、子集构造

当你根据标签索引选取数据时，时间序列和其它的pandas.Series很像：


```python
stamp = ts.index[2]
stamp
```




    Timestamp('2011-01-07 00:00:00')




```python
ts[stamp]
```




    -1.5583649551664842



还有一种更为方便的用法：传入一个可以被解释为日期的字符串：


```python
ts['1/10/2011']
```




    0.3722275907128481




```python
ts['20110110']
```




    0.3722275907128481



对于较长的时间序列，只需传入“年”或“年月”即可轻松选取数据的切片：


```python
longer_ts = pd.Series(np.random.randn(1000),
                      index=pd.date_range('1/1/2000', periods=1000))
longer_ts.head()
```




    2000-01-01   -1.005154
    2000-01-02   -0.025581
    2000-01-03   -1.069827
    2000-01-04    0.620630
    2000-01-05    0.320359
    Freq: D, dtype: float64




```python
longer_ts['2001'].head()
```




    2001-01-01    0.904721
    2001-01-02   -1.321671
    2001-01-03   -0.758130
    2001-01-04   -0.639765
    2001-01-05   -1.898212
    Freq: D, dtype: float64



这里，字符串“2001”被解释成年，并根据它选取时间区间。指定月也同样奏效：


```python
longer_ts['2001-05'].head()
```




    2001-05-01    1.054962
    2001-05-02   -0.788939
    2001-05-03   -0.439097
    2001-05-04    0.036200
    2001-05-05    0.458054
    Freq: D, dtype: float64



datetime对象也可以进行切片：


```python
ts[datetime(2011, 1, 7):]
```




    2011-01-07   -1.558365
    2011-01-08    0.770966
    2011-01-10    0.372228
    2011-01-12   -1.640982
    dtype: float64



由于大部分时间序列数据都是按照时间先后排序的，因此你也可以用不存在于该时间序列中的时间戳对其进行切片（即范围查询）：


```python
ts
```




    2011-01-02    0.502699
    2011-01-05    1.188837
    2011-01-07   -1.558365
    2011-01-08    0.770966
    2011-01-10    0.372228
    2011-01-12   -1.640982
    dtype: float64




```python
ts['1/6/2011':'1/11/2011']
```




    2011-01-07   -1.558365
    2011-01-08    0.770966
    2011-01-10    0.372228
    dtype: float64




```python
ts
```




    2011-01-02    0.502699
    2011-01-05    1.188837
    2011-01-07   -1.558365
    2011-01-08    0.770966
    2011-01-10    0.372228
    2011-01-12   -1.640982
    dtype: float64



前面这些操作对DataFrame也有效。例如，对DataFrame的行进行索引：


```python
dates = pd.date_range('1/1/2000', periods=100, freq='W-WED')
long_df = pd.DataFrame(np.random.randn(100, 4),
                       index=dates,
                       columns=['Colorado', 'Texas', 'New York', 'Ohio'])
long_df.head()
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000-01-05</th>
      <td>1.252168</td>
      <td>-0.120885</td>
      <td>1.323235</td>
      <td>0.253597</td>
    </tr>
    <tr>
      <th>2000-01-12</th>
      <td>-1.124264</td>
      <td>1.739674</td>
      <td>0.693579</td>
      <td>1.562149</td>
    </tr>
    <tr>
      <th>2000-01-19</th>
      <td>-0.814943</td>
      <td>0.409049</td>
      <td>-0.794594</td>
      <td>-1.158813</td>
    </tr>
    <tr>
      <th>2000-01-26</th>
      <td>-1.254203</td>
      <td>-1.770200</td>
      <td>-1.693423</td>
      <td>-0.588621</td>
    </tr>
    <tr>
      <th>2000-02-02</th>
      <td>-0.724392</td>
      <td>-1.776080</td>
      <td>-0.505409</td>
      <td>0.130541</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



```python
long_df.loc['5-2001']
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2001-05-02</th>
      <td>-0.267807</td>
      <td>-1.382954</td>
      <td>0.904109</td>
      <td>0.219650</td>
    </tr>
    <tr>
      <th>2001-05-09</th>
      <td>0.639089</td>
      <td>-0.665502</td>
      <td>0.321638</td>
      <td>1.234549</td>
    </tr>
    <tr>
      <th>2001-05-16</th>
      <td>1.172080</td>
      <td>-1.194735</td>
      <td>0.821372</td>
      <td>1.968535</td>
    </tr>
    <tr>
      <th>2001-05-23</th>
      <td>1.491895</td>
      <td>-1.684519</td>
      <td>-1.374041</td>
      <td>0.072872</td>
    </tr>
    <tr>
      <th>2001-05-30</th>
      <td>-0.035682</td>
      <td>-0.904268</td>
      <td>-0.071059</td>
      <td>-0.641927</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



```python
long_df.loc['2001-5']
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2001-05-02</th>
      <td>-0.267807</td>
      <td>-1.382954</td>
      <td>0.904109</td>
      <td>0.219650</td>
    </tr>
    <tr>
      <th>2001-05-09</th>
      <td>0.639089</td>
      <td>-0.665502</td>
      <td>0.321638</td>
      <td>1.234549</td>
    </tr>
    <tr>
      <th>2001-05-16</th>
      <td>1.172080</td>
      <td>-1.194735</td>
      <td>0.821372</td>
      <td>1.968535</td>
    </tr>
    <tr>
      <th>2001-05-23</th>
      <td>1.491895</td>
      <td>-1.684519</td>
      <td>-1.374041</td>
      <td>0.072872</td>
    </tr>
    <tr>
      <th>2001-05-30</th>
      <td>-0.035682</td>
      <td>-0.904268</td>
      <td>-0.071059</td>
      <td>-0.641927</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


### 带有重复索引的时间序列

在某些应用场景中，可能会存在多个观测数据落在同一个时间点上的情况。


```python
dates = pd.DatetimeIndex(['1/1/2000', '1/2/2000', '1/2/2000', '1/2/2000', '1/3/2000'])
dup_ts = pd.Series(np.arange(5), index=dates)
dup_ts
```




    2000-01-01    0
    2000-01-02    1
    2000-01-02    2
    2000-01-02    3
    2000-01-03    4
    dtype: int32



通过检查索引的is_unique属性，我们就可以知道它是不是唯一的：


```python
dup_ts.index.is_unique
```




    False



对这个时间序列进行索引，要么产生标量值，要么产生切片，具体要看所选的时间点是否重复：


```python
dup_ts['1/3/2000']
```




    4




```python
dup_ts['1/2/2000']
```




    2000-01-02    1
    2000-01-02    2
    2000-01-02    3
    dtype: int32



对具有非唯一时间戳的数据进行聚合。一个办法是使用groupby，并传入level=0：


```python
grouped = dup_ts.groupby(level=0)
```


```python
grouped
```




    <pandas.core.groupby.groupby.SeriesGroupBy object at 0x0000000009A3AA90>




```python
grouped.count()
```




    2000-01-01    1
    2000-01-02    3
    2000-01-03    1
    dtype: int64




```python
grouped.mean()
```




    2000-01-01    0
    2000-01-02    2
    2000-01-03    4
    dtype: int32



## 日期的范围、频率以及移动

pandas中的原生时间序列一般被认为是不规则的，也就是说，它们没有固定的频率。对于大部分应用程序而言，这是无所谓的。但是，它常常需要以某种相对固定的频率进行分析，比如每日、每月、每15分钟等（这样自然会在时间序列中引入缺失值）。幸运的是，pandas有一整套标准时间序列频率以及用于重采样、频率推断、生成固定频率日期范围的工具。例如，我们可以将之前那个时间序列转换为一个具有固定频率（每日）的时间序列，只需调用resample即可：


```python
ts
```




    2011-01-02    0.502699
    2011-01-05    1.188837
    2011-01-07   -1.558365
    2011-01-08    0.770966
    2011-01-10    0.372228
    2011-01-12   -1.640982
    dtype: float64




```python
# 字符串“D”是每天的意思。
ts.resample('D')
```




    DatetimeIndexResampler [freq=<Day>, axis=0, closed=left, label=left, convention=start, base=0]



频率的转换（或重采样）是一个比较大的主题，稍后将专门用一节来进行讨论。

### 生成日期范围

pandas.date_range可用于根据指定的频率生成指定长度的DatetimeIndex：


```python
index = pd.date_range('2012-04-01', '2012-06-01')
index
```




    DatetimeIndex(['2012-04-01', '2012-04-02', '2012-04-03', '2012-04-04',
                   '2012-04-05', '2012-04-06', '2012-04-07', '2012-04-08',
                   '2012-04-09', '2012-04-10', '2012-04-11', '2012-04-12',
                   '2012-04-13', '2012-04-14', '2012-04-15', '2012-04-16',
                   '2012-04-17', '2012-04-18', '2012-04-19', '2012-04-20',
                   '2012-04-21', '2012-04-22', '2012-04-23', '2012-04-24',
                   '2012-04-25', '2012-04-26', '2012-04-27', '2012-04-28',
                   '2012-04-29', '2012-04-30', '2012-05-01', '2012-05-02',
                   '2012-05-03', '2012-05-04', '2012-05-05', '2012-05-06',
                   '2012-05-07', '2012-05-08', '2012-05-09', '2012-05-10',
                   '2012-05-11', '2012-05-12', '2012-05-13', '2012-05-14',
                   '2012-05-15', '2012-05-16', '2012-05-17', '2012-05-18',
                   '2012-05-19', '2012-05-20', '2012-05-21', '2012-05-22',
                   '2012-05-23', '2012-05-24', '2012-05-25', '2012-05-26',
                   '2012-05-27', '2012-05-28', '2012-05-29', '2012-05-30',
                   '2012-05-31', '2012-06-01'],
                  dtype='datetime64[ns]', freq='D')



默认情况下，date_range会产生按天计算的时间点。如果只传入起始或结束日期，那就还得传入一个表示一段时间的数字：


```python
pd.date_range(start='2012-04-01', periods=20)
```




    DatetimeIndex(['2012-04-01', '2012-04-02', '2012-04-03', '2012-04-04',
                   '2012-04-05', '2012-04-06', '2012-04-07', '2012-04-08',
                   '2012-04-09', '2012-04-10', '2012-04-11', '2012-04-12',
                   '2012-04-13', '2012-04-14', '2012-04-15', '2012-04-16',
                   '2012-04-17', '2012-04-18', '2012-04-19', '2012-04-20'],
                  dtype='datetime64[ns]', freq='D')




```python
pd.date_range(end='2012-06-01', periods=20)
```




    DatetimeIndex(['2012-05-13', '2012-05-14', '2012-05-15', '2012-05-16',
                   '2012-05-17', '2012-05-18', '2012-05-19', '2012-05-20',
                   '2012-05-21', '2012-05-22', '2012-05-23', '2012-05-24',
                   '2012-05-25', '2012-05-26', '2012-05-27', '2012-05-28',
                   '2012-05-29', '2012-05-30', '2012-05-31', '2012-06-01'],
                  dtype='datetime64[ns]', freq='D')



起始和结束日期定义了日期索引的严格边界。  
如果你想要生成一个由每月最后一个工作日组成的日期索引，可以传入"BM"频率（表示business end of month，下表有频率列表），这样就只会包含时间间隔内（或刚好在边界上的）符合频率要求的日期：


```python
pd.date_range('2000-01-01', '2000-12-01', freq='BM')
```




    DatetimeIndex(['2000-01-31', '2000-02-29', '2000-03-31', '2000-04-28',
                   '2000-05-31', '2000-06-30', '2000-07-31', '2000-08-31',
                   '2000-09-29', '2000-10-31', '2000-11-30'],
                  dtype='datetime64[ns]', freq='BM')



基本的时间序列频率  
![基本的时间序列频率](https://upload-images.jianshu.io/upload_images/7178691-c8614ddbd10793ca.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

date_range默认会保留起始和结束时间戳的时间信息（如果有的话）：


```python
pd.date_range('2012-05-02 12:56:31', periods=5)
```




    DatetimeIndex(['2012-05-02 12:56:31', '2012-05-03 12:56:31',
                   '2012-05-04 12:56:31', '2012-05-05 12:56:31',
                   '2012-05-06 12:56:31'],
                  dtype='datetime64[ns]', freq='D')



有时，虽然起始和结束日期带有时间信息，但你希望产生一组被规范化（normalize）到午夜的时间戳。normalize选项即可实现该功能：


```python
pd.date_range('2012-05-02 12:56:31', periods=5, normalize=True)
```




    DatetimeIndex(['2012-05-02', '2012-05-03', '2012-05-04', '2012-05-05',
                   '2012-05-06'],
                  dtype='datetime64[ns]', freq='D')



### 频率和日期偏移量

pandas中的频率是由一个基础频率（base frequency）和一个乘数组成的。基础频率通常以一个字符串别名表示，比如"M"表示每月，"H"表示每小时。对于每个基础频率，都有一个被称为日期偏移量（date offset）的对象与之对应。例如，按小时计算的频率可以用Hour类表示：


```python
from pandas.tseries.offsets import Hour, Minute
hour = Hour()
hour
```




    <Hour>



传入一个整数即可定义偏移量的倍数：


```python
four_hours = Hour(4)
four_hours
```




    <4 * Hours>



一般来说，无需明确创建这样的对象，只需使用诸如"H"或"4H"这样的字符串别名即可。在基础频率前面放上一个整数即可创建倍数：


```python
pd.date_range('2000-01-01', '2000-01-03 23:59', freq='4h')
```




    DatetimeIndex(['2000-01-01 00:00:00', '2000-01-01 04:00:00',
                   '2000-01-01 08:00:00', '2000-01-01 12:00:00',
                   '2000-01-01 16:00:00', '2000-01-01 20:00:00',
                   '2000-01-02 00:00:00', '2000-01-02 04:00:00',
                   '2000-01-02 08:00:00', '2000-01-02 12:00:00',
                   '2000-01-02 16:00:00', '2000-01-02 20:00:00',
                   '2000-01-03 00:00:00', '2000-01-03 04:00:00',
                   '2000-01-03 08:00:00', '2000-01-03 12:00:00',
                   '2000-01-03 16:00:00', '2000-01-03 20:00:00'],
                  dtype='datetime64[ns]', freq='4H')



大部分偏移量对象都可通过加法进行连接：


```python
Hour(2) + Minute(30)
```




    <150 * Minutes>



同理，你也可以传入频率字符串（如"2h30min"），这种字符串可以被高效地解析为等效的表达式：


```python
pd.date_range('2000-01-01', periods=10, freq='1h30min')
```




    DatetimeIndex(['2000-01-01 00:00:00', '2000-01-01 01:30:00',
                   '2000-01-01 03:00:00', '2000-01-01 04:30:00',
                   '2000-01-01 06:00:00', '2000-01-01 07:30:00',
                   '2000-01-01 09:00:00', '2000-01-01 10:30:00',
                   '2000-01-01 12:00:00', '2000-01-01 13:30:00'],
                  dtype='datetime64[ns]', freq='90T')



时间序列的基础频率  
![时间序列的基础频率](https://upload-images.jianshu.io/upload_images/7178691-ff139312cd972204.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/7178691-adfa57a998c0296e.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/7178691-d09e577a10d0e6eb.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### WOM日期

WOM（Week Of Month）是一种非常实用的频率类，它以WOM开头。它使你能获得诸如“每月第3个星期五”之类的日期：


```python
rng = pd.date_range('2012-01-01', '2012-09-01', freq='WOM-3FRI')
rng
```




    DatetimeIndex(['2012-01-20', '2012-02-17', '2012-03-16', '2012-04-20',
                   '2012-05-18', '2012-06-15', '2012-07-20', '2012-08-17'],
                  dtype='datetime64[ns]', freq='WOM-3FRI')




```python
list(rng)
```




    [Timestamp('2012-01-20 00:00:00', freq='WOM-3FRI'),
     Timestamp('2012-02-17 00:00:00', freq='WOM-3FRI'),
     Timestamp('2012-03-16 00:00:00', freq='WOM-3FRI'),
     Timestamp('2012-04-20 00:00:00', freq='WOM-3FRI'),
     Timestamp('2012-05-18 00:00:00', freq='WOM-3FRI'),
     Timestamp('2012-06-15 00:00:00', freq='WOM-3FRI'),
     Timestamp('2012-07-20 00:00:00', freq='WOM-3FRI'),
     Timestamp('2012-08-17 00:00:00', freq='WOM-3FRI')]



### 移动（超前和滞后）数据

移动（shifting）指的是沿着时间轴将数据前移或后移。Series和DataFrame都有一个shift方法用于执行单纯的前移或后移操作，保持索引不变：


```python
ts = pd.Series(np.random.randn(4),
               index=pd.date_range('1/1/2000', periods=4, freq='M'))
ts
```




    2000-01-31   -3.150432
    2000-02-29    0.426478
    2000-03-31   -1.580138
    2000-04-30   -0.454702
    Freq: M, dtype: float64




```python
ts.shift(2)
```




    2000-01-31         NaN
    2000-02-29         NaN
    2000-03-31   -3.150432
    2000-04-30    0.426478
    Freq: M, dtype: float64




```python
ts.shift(-2)
```




    2000-01-31   -1.580138
    2000-02-29   -0.454702
    2000-03-31         NaN
    2000-04-30         NaN
    Freq: M, dtype: float64



当我们这样进行移动时，就会在时间序列的前面或后面产生缺失数据。

shift通常用于计算一个时间序列或多个时间序列（如DataFrame的列）中的百分比变化。可以这样表达：


```python
ts / ts.shift(1) - 1
```




    2000-01-31         NaN
    2000-02-29   -1.135371
    2000-03-31   -4.705091
    2000-04-30   -0.712239
    Freq: M, dtype: float64



由于单纯的移位操作不会修改索引，所以部分数据会被丢弃。因此，如果频率已知，则可以将其传给shift以便实现对时间戳进行位移而不是对数据进行简单位移：


```python
# 加两个月
ts.shift(2, freq='M')
```




    2000-03-31   -3.150432
    2000-04-30    0.426478
    2000-05-31   -1.580138
    2000-06-30   -0.454702
    Freq: M, dtype: float64



还可以使用其他频率，于是你就能非常灵活地对数据进行超前和滞后处理了：


```python
# 加三天
ts.shift(3, freq='D')
```




    2000-02-03   -3.150432
    2000-03-03    0.426478
    2000-04-03   -1.580138
    2000-05-03   -0.454702
    dtype: float64



### 通过偏移量对日期进行位移

pandas的日期偏移量还可以用在datetime或Timestamp对象上：


```python
from pandas.tseries.offsets import Day, MonthEnd
now = datetime(2011, 11, 17)
now + 3 * Day()
```




    Timestamp('2011-11-20 00:00:00')



如果加的是锚点偏移量（比如MonthEnd），第一次增量会将原日期向前滚动到符合频率规则的下一个日期：


```python
now
```




    datetime.datetime(2011, 11, 17, 0, 0)




```python
# 月末
now + MonthEnd()
```




    Timestamp('2011-11-30 00:00:00')




```python
# 两个月末
now + MonthEnd(2)
```




    Timestamp('2011-12-31 00:00:00')



通过锚点偏移量的rollforward和rollback方法，可明确地将日期向前或向后“滚动”：


```python
offset = MonthEnd()
```


```python
offset.rollforward(now)
```




    Timestamp('2011-11-30 00:00:00')




```python
offset.rollback(now)
```




    Timestamp('2011-10-31 00:00:00')



日期偏移量还有一个巧妙的用法，即结合groupby使用这两个“滚动”方法：


```python
ts = pd.Series(np.random.randn(20),
               index=pd.date_range('1/15/2000', periods=20, freq='4d'))
ts
```




    2000-01-15   -0.182953
    2000-01-19   -0.991147
    2000-01-23   -0.014200
    2000-01-27   -0.019404
    2000-01-31    1.417325
    2000-02-04    0.558435
    2000-02-08    1.092113
    2000-02-12   -0.463639
    2000-02-16   -0.232902
    2000-02-20    0.461556
    2000-02-24   -2.170060
    2000-02-28   -0.409881
    2000-03-03    0.156696
    2000-03-07   -0.846032
    2000-03-11    0.450076
    2000-03-15    0.383532
    2000-03-19    0.162644
    2000-03-23   -0.038723
    2000-03-27    1.229935
    2000-03-31    1.217698
    Freq: 4D, dtype: float64




```python
# 索引用月末的一天
ts.groupby(offset.rollforward).mean()
```




    2000-01-31    0.041924
    2000-02-29   -0.166340
    2000-03-31    0.339478
    dtype: float64



当然，更简单、更快速地实现该功能的办法是使用resample， 后面会进行介绍


```python
ts.resample('M').mean()
```




    2000-01-31    0.041924
    2000-02-29   -0.166340
    2000-03-31    0.339478
    Freq: M, dtype: float64



## 时区处理

时间序列处理工作中最让人不爽的就是对时区的处理。许多人都选择以协调世界时（UTC，它是格林尼治标准时间（Greenwich Mean Time）的接替者，目前已经是国际标准了）来处理时间序列。时区是以UTC偏移量的形式表示的。例如，夏令时期间，纽约比UTC慢4小时，而在全年其他时间则比UTC慢5小时。
在Python中，时区信息来自第三方库pytz，它使Python可以使用Olson数据库（汇编了世界时区信息）。这对历史数据非常重要，这是因为由于各地政府的各种突发奇想，夏令时转变日期（甚至UTC偏移量）已经发生过多次改变了。就拿美国来说，DST转变时间自1900年以来就改变过多次！
有关pytz库的更多信息，请查阅其文档。就本书而言，由于pandas包装了pytz的功能，因此你可以不用记忆其API，只要记得时区的名称即可。时区名可以在shell中看到，也可以通过文档查看：


```python
import pytz
pytz.common_timezones[-5:]
```




    ['US/Eastern', 'US/Hawaii', 'US/Mountain', 'US/Pacific', 'UTC']



要从pytz中获取时区对象，使用pytz.timezone即可：


```python
tz = pytz.timezone('America/New_York')
tz
```




    <DstTzInfo 'America/New_York' LMT-1 day, 19:04:00 STD>



pandas中的方法既可以接受时区名也可以接受这些对象。

### 时区本地化和转换

默认情况下，pandas中的时间序列是单纯（naive）的时区。


```python
rng = pd.date_range('3/9/2012 9:30', periods=6, freq='D')
rng
```




    DatetimeIndex(['2012-03-09 09:30:00', '2012-03-10 09:30:00',
                   '2012-03-11 09:30:00', '2012-03-12 09:30:00',
                   '2012-03-13 09:30:00', '2012-03-14 09:30:00'],
                  dtype='datetime64[ns]', freq='D')




```python
ts = pd.Series(np.random.randn(len(rng)), index=rng)
ts
```




    2012-03-09 09:30:00    1.206028
    2012-03-10 09:30:00   -1.239482
    2012-03-11 09:30:00   -1.594181
    2012-03-12 09:30:00    1.342129
    2012-03-13 09:30:00    1.791927
    2012-03-14 09:30:00    0.511703
    Freq: D, dtype: float64



其时间索引的 tz 字段(时区)为 None：


```python
print(ts.index.tz)
```

    None


可以用时区集生成日期范围：


```python
temp = pd.date_range('3/9/2012 9:30', periods=10, freq='D', tz='UTC')
temp
```




    DatetimeIndex(['2012-03-09 09:30:00+00:00', '2012-03-10 09:30:00+00:00',
                   '2012-03-11 09:30:00+00:00', '2012-03-12 09:30:00+00:00',
                   '2012-03-13 09:30:00+00:00', '2012-03-14 09:30:00+00:00',
                   '2012-03-15 09:30:00+00:00', '2012-03-16 09:30:00+00:00',
                   '2012-03-17 09:30:00+00:00', '2012-03-18 09:30:00+00:00'],
                  dtype='datetime64[ns, UTC]', freq='D')




```python
temp.tz
```




    <UTC>



本地化的转换是通过 tz_localize 方法处理的：(也就是没有时区(本地时区)转换成指定时区)


```python
ts
```




    2012-03-09 09:30:00    1.206028
    2012-03-10 09:30:00   -1.239482
    2012-03-11 09:30:00   -1.594181
    2012-03-12 09:30:00    1.342129
    2012-03-13 09:30:00    1.791927
    2012-03-14 09:30:00    0.511703
    Freq: D, dtype: float64




```python
ts_utc = ts.tz_localize('UTC')
ts_utc
```




    2012-03-09 09:30:00+00:00    1.206028
    2012-03-10 09:30:00+00:00   -1.239482
    2012-03-11 09:30:00+00:00   -1.594181
    2012-03-12 09:30:00+00:00    1.342129
    2012-03-13 09:30:00+00:00    1.791927
    2012-03-14 09:30:00+00:00    0.511703
    Freq: D, dtype: float64




```python
ts_utc.index.tz
```




    <UTC>



一旦时间序列被本地化转到某个特定时区，就可以用 tz_convert 将其转换到别的时区了：


```python
ts_utc.tz_convert('America/New_York')
```




    2012-03-09 04:30:00-05:00    1.206028
    2012-03-10 04:30:00-05:00   -1.239482
    2012-03-11 05:30:00-04:00   -1.594181
    2012-03-12 05:30:00-04:00    1.342129
    2012-03-13 05:30:00-04:00    1.791927
    2012-03-14 05:30:00-04:00    0.511703
    Freq: D, dtype: float64



tz_localize 和 tz_convert 也是 DatetimeIndex 的实例方法：


```python
ts.index.tz_localize('Asia/Shanghai')
```




    DatetimeIndex(['2012-03-09 09:30:00+08:00', '2012-03-10 09:30:00+08:00',
                   '2012-03-11 09:30:00+08:00', '2012-03-12 09:30:00+08:00',
                   '2012-03-13 09:30:00+08:00', '2012-03-14 09:30:00+08:00'],
                  dtype='datetime64[ns, Asia/Shanghai]', freq='D')



### Timestamp对象

跟时间序列和日期范围差不多，独立的 Timestamp 对象也能被从单纯型（naive）本地化转为时区意识型（time zone-aware），并从一个时区转换到另一个时区：


```python
stamp = pd.Timestamp('2011-03-12 04:00')
print(stamp.tz)
```

    None



```python
stamp_utc = stamp.tz_localize('utc')
stamp_utc.tz
```




    <UTC>




```python
stamp_utc.tz_convert('America/New_York')
```




    Timestamp('2011-03-11 23:00:00-0500', tz='America/New_York')



在创建Timestamp时，还可以传入一个时区信息：


```python
stamp_moscow = pd.Timestamp('2011-03-12 04:00', tz='Europe/Moscow')
stamp_moscow
```




    Timestamp('2011-03-12 04:00:00+0300', tz='Europe/Moscow')



时区意识型Timestamp对象在内部保存了一个UTC时间戳值（自UNIX纪元（1970年1月1日）算起的纳秒数）。这个UTC值在时区转换过程中是不会发生变化的：


```python
stamp_utc.value
```




    1299902400000000000




```python
stamp_utc.tz_convert('America/New_York').value
```




    1299902400000000000



当使用 pandas 的 DateOffset 对象执行时间算术运算时，运算过程会自动关注是否存在夏令时转变期。  

这里，我们创建了在DST转变之前的时间戳。首先，来看夏令时转变前的30分钟：


```python
from pandas.tseries.offsets import Hour
stamp = pd.Timestamp('2012-03-12 01:30', tz='US/Eastern')
stamp
```




    Timestamp('2012-03-12 01:30:00-0400', tz='US/Eastern')




```python
stamp + Hour()
```




    Timestamp('2012-03-12 02:30:00-0400', tz='US/Eastern')



然后，夏令时转变前90分钟：


```python
stamp = pd.Timestamp('2012-11-04 00:30', tz='US/Eastern')
stamp
```




    Timestamp('2012-11-04 00:30:00-0400', tz='US/Eastern')




```python
stamp + 2 * Hour()
```




    Timestamp('2012-11-04 01:30:00-0500', tz='US/Eastern')



### 不同时区之间的运算

如果两个时间序列的时区不同，在将它们合并到一起时，最终结果就会是UTC。由于时间戳其实是以UTC存储的，所以这是一个很简单的运算，并不需要发生任何转换：


```python
rng = pd.date_range('3/7/2012 9:30', periods=10, freq='B')
ts = pd.Series(np.random.randn(len(rng)), index=rng)
ts
```




    2012-03-07 09:30:00   -0.204868
    2012-03-08 09:30:00   -0.921229
    2012-03-09 09:30:00    1.727979
    2012-03-12 09:30:00    1.019146
    2012-03-13 09:30:00    1.690955
    2012-03-14 09:30:00   -0.156478
    2012-03-15 09:30:00    0.655796
    2012-03-16 09:30:00    0.229343
    2012-03-19 09:30:00    2.329904
    2012-03-20 09:30:00    0.600509
    Freq: B, dtype: float64




```python
ts1 = ts[:7].tz_localize('Europe/London')
ts1
```




    2012-03-07 09:30:00+00:00   -0.204868
    2012-03-08 09:30:00+00:00   -0.921229
    2012-03-09 09:30:00+00:00    1.727979
    2012-03-12 09:30:00+00:00    1.019146
    2012-03-13 09:30:00+00:00    1.690955
    2012-03-14 09:30:00+00:00   -0.156478
    2012-03-15 09:30:00+00:00    0.655796
    Freq: B, dtype: float64




```python
ts2 = ts1[2:].tz_convert('Europe/Moscow')
ts2
```




    2012-03-09 13:30:00+04:00    1.727979
    2012-03-12 13:30:00+04:00    1.019146
    2012-03-13 13:30:00+04:00    1.690955
    2012-03-14 13:30:00+04:00   -0.156478
    2012-03-15 13:30:00+04:00    0.655796
    Freq: B, dtype: float64




```python
result = ts1 + ts2
result
```




    2012-03-07 09:30:00+00:00         NaN
    2012-03-08 09:30:00+00:00         NaN
    2012-03-09 09:30:00+00:00    3.455958
    2012-03-12 09:30:00+00:00    2.038293
    2012-03-13 09:30:00+00:00    3.381910
    2012-03-14 09:30:00+00:00   -0.312956
    2012-03-15 09:30:00+00:00    1.311593
    Freq: B, dtype: float64




```python
result.index
```




    DatetimeIndex(['2012-03-07 09:30:00+00:00', '2012-03-08 09:30:00+00:00',
                   '2012-03-09 09:30:00+00:00', '2012-03-12 09:30:00+00:00',
                   '2012-03-13 09:30:00+00:00', '2012-03-14 09:30:00+00:00',
                   '2012-03-15 09:30:00+00:00'],
                  dtype='datetime64[ns, UTC]', freq='B')



## 时期(Period)及其算术运算

时期（period）表示的是时间区间，比如数日、数月、数季、数年等。Period类所表示的就是这种数据类型，其构造函数需要用到一个字符串或整数和之前提到的时间频率（搜 时间序列的基础频率）


```python
p = pd.Period(2007, freq='A-DEC')
p
```




    Period('2007', 'A-DEC')



这里，这个Period对象表示的是从2007年1月1日到2007年12月31日之间的整段时间。  

```python
p + 5
```




    Period('2012', 'A-DEC')




```python
p - 2
```




    Period('2005', 'A-DEC')



如果两个Period对象拥有相同的频率，则它们的差就是它们之间的单位数量：


```python
pd.Period('2014', freq='A-DEC') - p
```




    7



period_range函数可用于创建规则的时期范围：


```python
rng = pd.period_range('2000-01-01', '2000-06-30', freq='M')
rng
```




    PeriodIndex(['2000-01', '2000-02', '2000-03', '2000-04', '2000-05', '2000-06'], dtype='period[M]', freq='M')



PeriodIndex类保存了一组Period，它可以在任何pandas数据结构中被用作轴索引：


```python
pd.Series(np.random.randn(6), index=rng)
```




    2000-01   -1.975257
    2000-02   -1.347283
    2000-03   -0.117589
    2000-04   -0.323535
    2000-05    0.065720
    2000-06   -1.698198
    Freq: M, dtype: float64



如果你有一个字符串数组，你也可以使用PeriodIndex类：


```python
values = ['2001Q3', '2002Q2', '2003Q1']
index = pd.PeriodIndex(values, freq='Q-DEC')
index
```




    PeriodIndex(['2001Q3', '2002Q2', '2003Q1'], dtype='period[Q-DEC]', freq='Q-DEC')



### 时期的频率转换

Period和PeriodIndex对象都可以通过其asfreq方法被转换成别的频率。  
假设我们有一个年度时期，希望将其转换为当年年初或年末的一个月度时期。该任务非常简单：


```python
p = pd.Period('2007', freq='A-DEC')
p
```




    Period('2007', 'A-DEC')




```python
p.asfreq('M', how='start')
```




    Period('2007-01', 'M')




```python
p.asfreq('M', how='end')
```




    Period('2007-12', 'M')



你可以将 `Period('2007','A-DEC')` 看做一个被划分为多个月度时期的时间段中的游标。  

![Period频率转换示例](https://upload-images.jianshu.io/upload_images/7178691-d201200d0e65676f.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

在将高频率转换为低频率时，超时期（superperiod）是由子时期（subperiod）所属的位置决定的。例如，在A-JUN频率中，月份“2007年8月”实际上是属于周期“2008年”的：


```python
p = pd.Period('Aug-2007', 'M')
p.asfreq('A-JUN')
```




    Period('2008', 'A-JUN')



完整的 PeriodIndex 或 TimeSeries 的频率转换方式也是如此：


```python
rng = pd.period_range('2006', '2009', freq='A-DEC')
ts = pd.Series(np.random.randn(len(rng)), index=rng)
ts
```




    2006    1.020120
    2007   -0.377748
    2008   -0.058147
    2009   -1.282297
    Freq: A-DEC, dtype: float64




```python
ts.asfreq('M', how='start')
```




    2006-01    1.020120
    2007-01   -0.377748
    2008-01   -0.058147
    2009-01   -1.282297
    Freq: M, dtype: float64



这里，根据年度时期的第一个月，每年的时期被取代为每月的时期。如果我们想要每年的最后一个工作日，我们可以使用“B”频率，并指明想要该时期的末尾：


```python
ts.asfreq('B', how='end')
```




    2006-12-29    1.020120
    2007-12-31   -0.377748
    2008-12-31   -0.058147
    2009-12-31   -1.282297
    Freq: B, dtype: float64



### 按季度计算的时期频率

季度型数据在会计、金融等领域中很常见。许多季度型数据都会涉及“财年末”的概念，通常是一年12个月中某月的最后一个日历日或工作日。就这一点来说，时期"2012Q4"根据财年末的不同会有不同的含义。pandas支持12种可能的季度型频率，即Q-JAN到Q-DEC：


```python
p = pd.Period('2012Q4', freq='Q-JAN')
p
```




    Period('2012Q4', 'Q-JAN')



在以1月结束的财年中，2012Q4是从11月到1月（将其转换为日型频率就明白了）。下图对此进行了说明：


```python
p.asfreq('D', 'start')
```




    Period('2011-11-01', 'D')




```python
p.asfreq('D', 'end')
```




    Period('2012-01-31', 'D')



![不同季度型频率之间的转换](https://upload-images.jianshu.io/upload_images/7178691-e2e1d52c9766f6ff.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240) 

因此，Period之间的算术运算会非常简单。例如，要获取该季度倒数第二个工作日下午4点的时间戳，你可以这样：


```python
p4pm = (p.asfreq('B', 'e') - 1).asfreq('T', 's') + 16 * 60
p4pm
```




    Period('2012-01-30 16:00', 'T')




```python
p4pm.to_timestamp()
```




    Timestamp('2012-01-30 16:00:00')



period_range可用于生成季度型范围。季度型范围的算术运算也跟上面是一样的：


```python
rng = pd.period_range('2011Q3', '2012Q4', freq='Q-JAN')
ts = pd.Series(np.arange(len(rng)), index=rng)
ts
```




    2011Q3    0
    2011Q4    1
    2012Q1    2
    2012Q2    3
    2012Q3    4
    2012Q4    5
    Freq: Q-JAN, dtype: int32




```python
new_rng = (rng.asfreq('B', 'e') - 1).asfreq('T', 's') + 16 * 60
ts.index = new_rng.to_timestamp()
ts
```




    2010-10-28 16:00:00    0
    2011-01-28 16:00:00    1
    2011-04-28 16:00:00    2
    2011-07-28 16:00:00    3
    2011-10-28 16:00:00    4
    2012-01-30 16:00:00    5
    dtype: int32



### 将Timestamp转换为Period（及其反向过程）

通过使用 to_period 方法，可以将由时间戳索引的 Series 和 DataFrame 对象转换为以时期索引：


```python
rng = pd.date_range('2000-01-01', periods=3, freq='M')
ts = pd.Series(np.random.randn(3), index=rng)
ts
```




    2000-01-31    0.269545
    2000-02-29   -0.056993
    2000-03-31    0.967725
    Freq: M, dtype: float64




```python
pts = ts.to_period()
pts
```




    2000-01    0.269545
    2000-02   -0.056993
    2000-03    0.967725
    Freq: M, dtype: float64



由于时期指的是非重叠时间区间，因此对于给定的频率，一个时间戳只能属于一个时期。新PeriodIndex的频率默认是从时间戳推断而来的，你也可以指定任何别的频率。结果中允许存在重复时期：


```python
rng = pd.date_range('1/29/2000', periods=6, freq='D')
ts2 = pd.Series(np.random.randn(6), index=rng)
ts2
```




    2000-01-29    0.193937
    2000-01-30   -1.982108
    2000-01-31    1.623989
    2000-02-01   -0.980946
    2000-02-02    1.431045
    2000-02-03    0.765108
    Freq: D, dtype: float64




```python
ts2.to_period('M')
```




    2000-01    0.193937
    2000-01   -1.982108
    2000-01    1.623989
    2000-02   -0.980946
    2000-02    1.431045
    2000-02    0.765108
    Freq: M, dtype: float64



要转换回时间戳，使用to_timestamp即可：


```python
pts = ts2.to_period()
pts
```




    2000-01-29    0.193937
    2000-01-30   -1.982108
    2000-01-31    1.623989
    2000-02-01   -0.980946
    2000-02-02    1.431045
    2000-02-03    0.765108
    Freq: D, dtype: float64




```python
pts.to_timestamp(how='end')
```




    2000-01-29    0.193937
    2000-01-30   -1.982108
    2000-01-31    1.623989
    2000-02-01   -0.980946
    2000-02-02    1.431045
    2000-02-03    0.765108
    Freq: D, dtype: float64



### 通过数组创建 PeriodIndex (通过多列创建时间索引)

固定频率的数据集通常会将时间信息分开存放在多个列中。例如，在下面这个宏观经济数据集中，年度和季度就分别存放在不同的列中：


```python
data = pd.read_csv('data/examples/macrodata.csv')
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
{% endraw %}


通过将这些时间列数组以及一个频率传入PeriodIndex，就可以将它们合并成DataFrame的一个索引：


```python
index = pd.PeriodIndex(year=data.year, quarter=data.quarter, freq='Q-DEC')
index
```




    PeriodIndex(['1959Q1', '1959Q2', '1959Q3', '1959Q4', '1960Q1', '1960Q2',
                 '1960Q3', '1960Q4', '1961Q1', '1961Q2',
                 ...
                 '2007Q2', '2007Q3', '2007Q4', '2008Q1', '2008Q2', '2008Q3',
                 '2008Q4', '2009Q1', '2009Q2', '2009Q3'],
                dtype='period[Q-DEC]', length=203, freq='Q-DEC')




```python
data.index = index
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
      <th>1959Q1</th>
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
      <th>1959Q2</th>
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
      <th>1959Q3</th>
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
      <th>1959Q4</th>
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
      <th>1960Q1</th>
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
{% endraw %}



```python
data.infl.head()
```




    1959Q1    0.00
    1959Q2    2.34
    1959Q3    2.74
    1959Q4    0.27
    1960Q1    2.31
    Freq: Q-DEC, Name: infl, dtype: float64



## 重采样及频率转换

重采样（resampling）指的是将时间序列从一个频率转换到另一个频率的处理过程。将高频率数据聚合到低频率称为降采样（downsampling），而将低频率数据转换到高频率则称为升采样（upsampling）。

pandas对象都带有一个resample方法，它是各种频率转换工作的主力函数。resample有一个类似于groupby的API，调用resample可以分组数据，然后会调用一个聚合函数：


```python
rng = pd.date_range('2000-01-01', periods=100, freq='D')
ts = pd.Series(np.random.randn(len(rng)), index=rng)
ts.head()
```




    2000-01-01   -1.798126
    2000-01-02    0.937883
    2000-01-03   -1.010101
    2000-01-04   -0.553884
    2000-01-05   -1.131896
    Freq: D, dtype: float64




```python
ts.resample('M').mean()
```




    2000-01-31   -0.163057
    2000-02-29   -0.128462
    2000-03-31   -0.136395
    2000-04-30    0.362875
    Freq: M, dtype: float64




```python
ts.resample('M', kind='period').mean()
```




    2000-01   -0.163057
    2000-02   -0.128462
    2000-03   -0.136395
    2000-04    0.362875
    Freq: M, dtype: float64



### 降采样

将数据聚合到规律的低频率是一件非常普通的时间序列处理任务。待聚合的数据不必拥有固定的频率，期望的频率会自动定义聚合的面元边界，这些面元用于将时间序列拆分为多个片段。例如，要转换到月度频率（'M'或'BM'），数据需要被划分到多个单月时间段中。各时间段都是半开放的。一个数据点只能属于一个时间段，所有时间段的并集必须能组成整个时间帧。在用resample对数据进行降采样时，需要考虑两样东西：  

1. 各区间哪边是闭合的。
2. 如何标记各个聚合面元，用区间的开头还是末尾。

为了说明，我们来看一些“1分钟”数据：


```python
rng = pd.date_range('2000-01-01', periods=12, freq='T')
ts = pd.Series(np.arange(12), index=rng)
ts
```




    2000-01-01 00:00:00     0
    2000-01-01 00:01:00     1
    2000-01-01 00:02:00     2
    2000-01-01 00:03:00     3
    2000-01-01 00:04:00     4
    2000-01-01 00:05:00     5
    2000-01-01 00:06:00     6
    2000-01-01 00:07:00     7
    2000-01-01 00:08:00     8
    2000-01-01 00:09:00     9
    2000-01-01 00:10:00    10
    2000-01-01 00:11:00    11
    Freq: T, dtype: int32



假设你想要通过求和的方式将这些数据聚合到“5分钟”块中：


```python
ts.resample('5min', closed='right').sum()
```




    1999-12-31 23:55:00     0
    2000-01-01 00:00:00    15
    2000-01-01 00:05:00    40
    2000-01-01 00:10:00    11
    Freq: 5T, dtype: int32



传入的频率将会以“5分钟”的增量定义面元边界。默认情况下，面元的右边界是包含的，因此00:00到00:05的区间中是包含00:05的。传入closed='left'会让区间以左边界闭合：


```python
ts.resample('5min', closed='left').sum()
```




    2000-01-01 00:00:00    10
    2000-01-01 00:05:00    35
    2000-01-01 00:10:00    21
    Freq: 5T, dtype: int32



最终的时间序列是以各面元右边界的时间戳进行标记的。传入label='right'即可用面元的邮编界对其进行标记：


```python
ts.resample('5min', closed='right', label='right').sum()
```




    2000-01-01 00:00:00     0
    2000-01-01 00:05:00    15
    2000-01-01 00:10:00    40
    2000-01-01 00:15:00    11
    Freq: 5T, dtype: int32



下图说明了“1分钟”数据被转换为“5分钟”数据的处理过程。  
![](https://upload-images.jianshu.io/upload_images/7178691-7a77f47844f2ee8c.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

最后，你可能希望对结果索引做一些位移，比如从右边界减去一秒以便更容易明白该时间戳到底表示的是哪个区间。只需通过loffset设置一个字符串或日期偏移量即可实现这个目的：


```python
ts.resample('5min', closed='right', label='right', loffset='-1s').sum()
```




    1999-12-31 23:59:59     0
    2000-01-01 00:04:59    15
    2000-01-01 00:09:59    40
    2000-01-01 00:14:59    11
    Freq: 5T, dtype: int32




```python
ts.resample('5min', closed='left', label='right', loffset='-1s').sum()
```




    2000-01-01 00:04:59    10
    2000-01-01 00:09:59    35
    2000-01-01 00:14:59    21
    Freq: 5T, dtype: int32



此外，也可以通过调用结果对象的 shift 方法来实现该目的


```python
temp = ts.resample('5min', closed='left', label='right').sum()
temp
```




    2000-01-01 00:05:00    10
    2000-01-01 00:10:00    35
    2000-01-01 00:15:00    21
    Freq: 5T, dtype: int32




```python
temp.shift(-1, freq='s')
```




    2000-01-01 00:04:59    10
    2000-01-01 00:09:59    35
    2000-01-01 00:14:59    21
    Freq: 5T, dtype: int32



### OHLC重采样

金融领域中有一种无所不在的时间序列聚合方式，即计算各面元的四个值：第一个值（open，开盘）、最后一个值（close，收盘）、最大值（high，最高）以及最小值（low，最低）。传入how='ohlc'即可得到一个含有这四种聚合值的DataFrame。整个过程很高效，只需一次扫描即可计算出结果：


```python
ts
```




    2000-01-01 00:00:00     0
    2000-01-01 00:01:00     1
    2000-01-01 00:02:00     2
    2000-01-01 00:03:00     3
    2000-01-01 00:04:00     4
    2000-01-01 00:05:00     5
    2000-01-01 00:06:00     6
    2000-01-01 00:07:00     7
    2000-01-01 00:08:00     8
    2000-01-01 00:09:00     9
    2000-01-01 00:10:00    10
    2000-01-01 00:11:00    11
    Freq: T, dtype: int32




```python
ts.resample('5min').ohlc()
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
      <th>open</th>
      <th>high</th>
      <th>low</th>
      <th>close</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000-01-01 00:00:00</th>
      <td>0</td>
      <td>4</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>2000-01-01 00:05:00</th>
      <td>5</td>
      <td>9</td>
      <td>5</td>
      <td>9</td>
    </tr>
    <tr>
      <th>2000-01-01 00:10:00</th>
      <td>10</td>
      <td>11</td>
      <td>10</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


### 升采样和插值

在将数据从低频率转换到高频率时，就不需要聚合了。我们来看一个带有一些周型数据的DataFrame：


```python
frame = pd.DataFrame(np.random.randn(2, 4),
                     index=pd.date_range('1/1/2000', periods=2, freq='W-WED'),
                     columns=['Colorado', 'Texas', 'New York', 'Ohio'])
frame
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000-01-05</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-12</th>
      <td>0.702946</td>
      <td>-0.824366</td>
      <td>1.054700</td>
      <td>1.809035</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


当你对这个数据进行聚合，每组只有一个值，这样就会引入缺失值。我们使用asfreq方法转换成高频，不经过聚合：


```python
df_daily = frame.resample('D').asfreq()
df_daily
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000-01-05</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-06</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-07</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-08</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-09</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-10</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-11</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-12</th>
      <td>0.702946</td>
      <td>-0.824366</td>
      <td>1.054700</td>
      <td>1.809035</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


假设你想要用前面的周型值填充“非星期三”。resample 的填充和插值方式跟fillna和reindex的一样：


```python
frame.resample('D').ffill()
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000-01-05</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-06</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-07</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-08</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-09</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-10</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-11</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-12</th>
      <td>0.702946</td>
      <td>-0.824366</td>
      <td>1.054700</td>
      <td>1.809035</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


同样，这里也可以只填充指定的时期数（目的是限制前面的观测值的持续使用距离）：


```python
frame.resample('D').ffill(limit=2)
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000-01-05</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-06</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-07</th>
      <td>0.512990</td>
      <td>1.145801</td>
      <td>0.765452</td>
      <td>-1.319816</td>
    </tr>
    <tr>
      <th>2000-01-08</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-09</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-10</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-11</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2000-01-12</th>
      <td>0.702946</td>
      <td>-0.824366</td>
      <td>1.054700</td>
      <td>1.809035</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


### 通过时期(period)进行重采样

对那些使用时期索引的数据进行重采样与时间戳很像：


```python
frame = pd.DataFrame(np.random.randn(24, 4),
                     index=pd.period_range('1-2000', '12-2001', freq='M'),
                     columns=['Colorado', 'Texas', 'New York', 'Ohio'])
frame.head()
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000-01</th>
      <td>1.031093</td>
      <td>0.497053</td>
      <td>0.741678</td>
      <td>-0.765792</td>
    </tr>
    <tr>
      <th>2000-02</th>
      <td>0.882783</td>
      <td>1.501811</td>
      <td>0.966431</td>
      <td>0.258871</td>
    </tr>
    <tr>
      <th>2000-03</th>
      <td>0.793097</td>
      <td>2.349771</td>
      <td>1.678723</td>
      <td>-0.131274</td>
    </tr>
    <tr>
      <th>2000-04</th>
      <td>0.501516</td>
      <td>-1.210646</td>
      <td>-1.090834</td>
      <td>-1.627167</td>
    </tr>
    <tr>
      <th>2000-05</th>
      <td>-0.941150</td>
      <td>-1.149196</td>
      <td>-1.078340</td>
      <td>-1.399332</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



```python
frame.index
```




    PeriodIndex(['2000-01', '2000-02', '2000-03', '2000-04', '2000-05', '2000-06',
                 '2000-07', '2000-08', '2000-09', '2000-10', '2000-11', '2000-12',
                 '2001-01', '2001-02', '2001-03', '2001-04', '2001-05', '2001-06',
                 '2001-07', '2001-08', '2001-09', '2001-10', '2001-11', '2001-12'],
                dtype='period[M]', freq='M')



降采样


```python
annual_frame = frame.resample('Y').mean()
annual_frame
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


??? 这个升采样没理解

升采样要稍微麻烦一些，因为你必须决定在新频率中各区间的哪端用于放置原来的值，就像asfreq方法那样。convention参数默认为'start'，也可设置为'end'：


```python
annual_frame.resample('Q-DEC').ffill()
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000Q1</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2000Q2</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2000Q3</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2000Q4</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001Q1</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
    <tr>
      <th>2001Q2</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
    <tr>
      <th>2001Q3</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
    <tr>
      <th>2001Q4</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



```python
annual_frame.resample('Q-DEC', convention='end').ffill()
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000Q4</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001Q1</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001Q2</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001Q3</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001Q4</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


由于时期指的是时间区间，所以升采样和降采样的规则就比较严格：  
1. 在降采样中，目标频率必须是源频率的子时期（subperiod）。
2. 在升采样中，目标频率必须是源频率的超时期（superperiod）。  

如果不满足这些条件，就会引发异常。这主要影响的是按季、年、周计算的频率。例如，由Q-MAR定义的时间区间只能升采样为A-MAR、A-JUN、A-SEP、A-DEC等：



```python
annual_frame.resample('Q-MAR').ffill()
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
      <th>Colorado</th>
      <th>Texas</th>
      <th>New York</th>
      <th>Ohio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000Q4</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001Q1</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001Q2</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001Q3</th>
      <td>0.134307</td>
      <td>-0.098188</td>
      <td>-0.306211</td>
      <td>-0.268521</td>
    </tr>
    <tr>
      <th>2001Q4</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
    <tr>
      <th>2002Q1</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
    <tr>
      <th>2002Q2</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
    <tr>
      <th>2002Q3</th>
      <td>-0.750393</td>
      <td>-0.031389</td>
      <td>0.054950</td>
      <td>0.275272</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


## 移动窗口函数

在移动窗口（可以带有指数衰减权数）上计算的各种统计函数也是一类常见于时间序列的数组变换。这样可以圆滑噪音数据或断裂数据。我将它们称为移动窗口函数（moving window function），其中还包括那些窗口不定长的函数（如指数加权移动平均）。跟其他统计函数一样，移动窗口函数也会自动排除缺失值。

开始之前，我们加载一些时间序列数据，将其重采样为工作日频率：


```python
close_px_all = pd.read_csv('data/examples/stock_px_2.csv', parse_dates=True, index_col=0)
close_px = close_px_all[['AAPL', 'MSFT', 'XOM']]
close_px.head()
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
      <th>AAPL</th>
      <th>MSFT</th>
      <th>XOM</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003-01-02</th>
      <td>7.40</td>
      <td>21.11</td>
      <td>29.22</td>
    </tr>
    <tr>
      <th>2003-01-03</th>
      <td>7.45</td>
      <td>21.14</td>
      <td>29.24</td>
    </tr>
    <tr>
      <th>2003-01-06</th>
      <td>7.45</td>
      <td>21.52</td>
      <td>29.96</td>
    </tr>
    <tr>
      <th>2003-01-07</th>
      <td>7.43</td>
      <td>21.93</td>
      <td>28.95</td>
    </tr>
    <tr>
      <th>2003-01-08</th>
      <td>7.28</td>
      <td>21.31</td>
      <td>28.83</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}



```python
close_px = close_px.resample('B').ffill()
close_px.head()
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
      <th>AAPL</th>
      <th>MSFT</th>
      <th>XOM</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003-01-02</th>
      <td>7.40</td>
      <td>21.11</td>
      <td>29.22</td>
    </tr>
    <tr>
      <th>2003-01-03</th>
      <td>7.45</td>
      <td>21.14</td>
      <td>29.24</td>
    </tr>
    <tr>
      <th>2003-01-06</th>
      <td>7.45</td>
      <td>21.52</td>
      <td>29.96</td>
    </tr>
    <tr>
      <th>2003-01-07</th>
      <td>7.43</td>
      <td>21.93</td>
      <td>28.95</td>
    </tr>
    <tr>
      <th>2003-01-08</th>
      <td>7.28</td>
      <td>21.31</td>
      <td>28.83</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


现在引入rolling运算符，它与resample和groupby很像。可以在TimeSeries或DataFrame以及一个window（表示期数，见图11-4）上调用它：


```python
close_px.AAPL.plot()
close_px.AAPL.rolling(250).mean().plot()
```




    <matplotlib.axes._subplots.AxesSubplot at 0xc51a898>




![png](/images/shuju/output_303_1.png)



```python

```




    <matplotlib.axes._subplots.AxesSubplot at 0xc41fcc0>




![png](/images/shuju/output_304_1.png)


表达式rolling(250)与groupby很像，但不是对其进行分组，而是创建一个按照250天分组的滑动窗口对象。然后，我们就得到了苹果公司股价的250天的移动窗口。

默认情况下，rolling函数需要窗口中所有的值为非NA值。可以修改该行为以解决缺失数据的问题。其实，在时间序列开始处尚不足窗口期的那些数据就是个特例


```python
appl_std250 = close_px.AAPL.rolling(250, min_periods=10).std()
appl_std250[5:12]
```




    2003-01-09         NaN
    2003-01-10         NaN
    2003-01-13         NaN
    2003-01-14         NaN
    2003-01-15    0.077496
    2003-01-16    0.074760
    2003-01-17    0.112368
    Freq: B, Name: AAPL, dtype: float64




```python
appl_std250.plot()
```




    <matplotlib.axes._subplots.AxesSubplot at 0xc60f0b8>




![png](/images/shuju/output_308_1.png)


要计算扩展窗口平均（expanding window mean），可以使用expanding而不是rolling。“扩展”意味着，从时间序列的起始处开始窗口，增加窗口直到它超过所有的序列。apple_std250时间序列的扩展窗口平均如下所示：


```python
expanding_mean = appl_std250.expanding().mean()
expanding_mean.plot()
```




    <matplotlib.axes._subplots.AxesSubplot at 0xc6bb940>




![png](/images/shuju/output_310_1.png)


对DataFrame调用rolling_mean（以及与之类似的函数）会将转换应用到所有的列上


```python
close_px.rolling(60).mean().plot(logy=True)
```




    <matplotlib.axes._subplots.AxesSubplot at 0xc6bba90>




![png](/images/shuju/output_312_1.png)


rolling函数也可以接受一个指定固定大小时间补偿字符串，而不是一组时期。这样可以方便处理不规律的时间序列。这些字符串也可以传递给resample。例如，我们可以计算20天的滚动均值，如下所示：


```python
close_px.rolling('20D').mean().head()
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
      <th>AAPL</th>
      <th>MSFT</th>
      <th>XOM</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003-01-02</th>
      <td>7.400000</td>
      <td>21.110000</td>
      <td>29.220000</td>
    </tr>
    <tr>
      <th>2003-01-03</th>
      <td>7.425000</td>
      <td>21.125000</td>
      <td>29.230000</td>
    </tr>
    <tr>
      <th>2003-01-06</th>
      <td>7.433333</td>
      <td>21.256667</td>
      <td>29.473333</td>
    </tr>
    <tr>
      <th>2003-01-07</th>
      <td>7.432500</td>
      <td>21.425000</td>
      <td>29.342500</td>
    </tr>
    <tr>
      <th>2003-01-08</th>
      <td>7.402000</td>
      <td>21.402000</td>
      <td>29.240000</td>
    </tr>
  </tbody>
</table>
</div>
{% endraw %}


### 指数加权函数

另一种使用固定大小窗口及相等权数观测值的办法是，定义一个衰减因子（decay factor）常量，以便使近期的观测值拥有更大的权数。衰减因子的定义方式有很多，比较流行的是使用时间间隔（span），它可以使结果兼容于窗口大小等于时间间隔的简单移动窗口（simple moving window）函数。  

由于指数加权统计会赋予近期的观测值更大的权数，因此相对于等权统计，它能“适应”更快的变化。  

除了rolling和expanding，pandas还有ewm运算符。下面这个例子对比了苹果公司股价的30日移动平均和span=30的指数加权移动平均


```python
aapl_px = close_px.AAPL['2006':'2007']
ma60 = aapl_px.rolling(30, min_periods=20).mean()
ewma60 = aapl_px.ewm(span=30).mean()
ma60.plot(style='k--', label='Simple MA')
ewma60.plot(style='k-', label='EW MA')
```




    <matplotlib.axes._subplots.AxesSubplot at 0xcadb5c0>




![png](/images/shuju/output_317_1.png)


### 二元移动窗口函数

有些统计运算（如相关系数和协方差）需要在两个时间序列上执行。例如，金融分析师常常对某只股票对某个参考指数（如标准普尔500指数）的相关系数感兴趣。要进行说明，我们先计算我们感兴趣的时间序列的百分数变化：


```python
spx_px = close_px_all['SPX']
spx_rets = spx_px.pct_change()
returns = close_px.pct_change()
```

调用rolling之后，corr聚合函数开始计算与spx_rets滚动相关系数


```python
corr = returns.AAPL.rolling(125, min_periods=100).corr(spx_rets)
corr.plot()
```




    <matplotlib.axes._subplots.AxesSubplot at 0xdb4b5f8>




![png](/images/shuju/output_322_1.png)


假设你想要一次性计算多只股票与标准普尔500指数的相关系数。虽然编写一个循环并新建一个DataFrame不是什么难事，但比较啰嗦。其实，只需传入一个TimeSeries和一个DataFrame，rolling_corr就会自动计算TimeSeries（本例中就是spx_rets）与DataFrame各列的相关系数。


```python
corr = returns.rolling(125, min_periods=100).corr(spx_rets)
corr.plot()
```




    <matplotlib.axes._subplots.AxesSubplot at 0xdc05dd8>




![png](/images/shuju/output_324_1.png)


### 用户定义的移动窗口函数

rolling_apply函数使你能够在移动窗口上应用自己设计的数组函数。唯一要求的就是：该函数要能从数组的各个片段中产生单个值（即约简）。比如说，当我们用rolling(...).quantile(q)计算样本分位数时，可能对样本中特定值的百分等级感兴趣。scipy.stats.percentileofscore函数就能达到这个目的


```python
from scipy.stats import percentileofscore
score_at_2percent = lambda x: percentileofscore(x, 0.02)
result = returns.AAPL.rolling(250).apply(score_at_2percent, raw=False)
result.plot()
```




    <matplotlib.axes._subplots.AxesSubplot at 0xdd44630>




![png](/images/shuju/output_327_1.png)



```python

```
