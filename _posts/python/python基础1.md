---
title: python基础1
date: 2018-10-11 00:00:02
tags:
    - python基础
categories:
    - python    
---


## 前言  
算是一篇记录或摘抄的笔记，方便用来查询基础知识点。  

## 小点    
### 查看关键字  

```python
import keyword
print(keyword.kwlist)
```
### 生成随机数  
```python
import random
random.randint(12, 20)  # 生成的随机数n: 12 <= n <= 20   
random.randint(20, 20)  # 结果永远是 20   
random.randint(20, 10)  # 该语句是错误的，下限必须小于上限
```
### print 输出  
如果希望输出文字信息的同时，一起输出 数据，就需要使用到 **格式化操作符**
`%` 被称为 **格式化操作符**，专门用于处理字符串中的格式
包含 `%` 的字符串，被称为 **格式化字符串**
`%` 和不同的 `字符` 连用，不同类型的数据 需要使用 不同的格式化字符  

|  格式化字符   |   含义   |
| :------------- | :------------- |
| %s | 字符串 |
| %d | 有符号十进制整数，%06d 表示输出的整数显示位数，不足的地方使用 0 补全 |
| %f | 浮点数，%.2f 表示小数点后只显示两位 |
| 其他 | [other](http://www.runoob.com/python/python-strings.html) |

```python
print("格式化字符串" % 变量1)

print("格式化字符串" % (变量1, 变量2...))
```
<!--more-->
print 总是会以一个不可见的“新一行”字符（ `\n` ）结尾，因此重复调用 print 将会在相互独立的一行中分别打印。为防止打印过程中出现这一换行符，你可以通过 end 指定其应以空白结尾：
```python
print('a', end='')
print('b', end='')

输出结果如下：
ab
```
### 文件开头注释  
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
```
第一行注释是为了告诉`Linux/OS X`系统，这是一个Python可执行程序，可以直接点击执行，Windows系统会忽略这个注释；  
查看系统python3的命令目录  
```python
which python3
```

第二行注释是为了告诉Python解释器，按照UTF-8编码读取源代码，否则，你在源代码中写的中文输出可能会有乱码。  

> #!这个符号叫做 Shebang 或者 Sha-bang
Shebang 通常在 Unix 系统脚本的中 第一行开头 使用
指明 执行这个脚本文件 的 解释程序  

使用 Shebang 的步骤

1. 使用 which 查询 python3 解释器所在路径
```python
$ which python3
```
2. 修改要运行的 主 python 文件，在第一行增加以下内容
```python
#! /usr/bin/python3 # 路径为which查询到的路径
```
3. 修改 主 python 文件 的文件权限，增加执行权限
```python
$ chmod +x cards_main.py
```
4. 在需要时执行程序即可
```python
./cards_main.py
```

### dir() 方法查看对象内的变量、方法    
内置的 `dir()` 函数能够返回由对象(一切皆对象)所定义的变量列表。如果这一对象是一个模块，则该列表会包括函数内所定义的函数、类与变量。

不带参数时表示列出当前模块的，带参数是表示列出参数对象的  
```python
>>> dir()
['__builtins__', '__doc__', '__loader__', '__name__', '__package__', '__spec__']
>>> import random
>>> dir(random)
['BPF', 'LOG4', 'NV_MAGICCONST', 'RECIP_BPF', 'Random', 'SG_MAGICCONST', 'SystemRandom', 'TWOPI', '_BuiltinMethodType', '_MethodType', '_Sequence', '_Set', '__all__', '__builtins__', '__cached__', '__doc__', '__file__', '__loader__', '__name__', '__package__', '__spec__', '_acos', '_ceil', '_cos', '_e', '_exp', '_inst', '_log', '_pi', '_random', '_sha512', '_sin', '_sqrt', '_test', '_test_generator', '_urandom', '_warn', 'betavariate', 'choice', 'expovariate', 'gammavariate', 'gauss', 'getrandbits', 'getstate', 'lognormvariate', 'normalvariate', 'paretovariate', 'randint', 'random', 'randrange', 'sample', 'seed', 'setstate', 'shuffle', 'triangular', 'uniform', 'vonmisesvariate', 'weibullvariate']
```
### help() 获取使用帮助    
获取对象使用的帮助信息  `help(random)` 其实用不到，可以直接去查看源码嘛  

### DocStrings 输出函数介绍信息  
获取函数的文档，也就是备注。按照规定的格式写备注，可以方便的生成使用或接口文档    

函数顶部定义的 `'''内容信息'''` 的内容信息  

```python
def print_max(x, y):
    '''Prints the maximum of two numbers.

    The two values must be integers. '''
    # 如果可能， 将其转换至整数类型
    x = int(x)
    y = int(y)
    if x < y:
        print('a')
    else:
        print('b')
print_max(3, 5)
print(print_max.__doc__)
```
**格式约定：**

该文档字符串所约定的是一串多行字符串，其中第一行以某一大写字母开始，以句号结束。第二行为空行，后跟的第三行开始是任何详细的解释说明。  

> 使用 `help()` 和 用 `pydoc` 生成文档时会用到定义的这段文字  

### eval函数 执行字符串代码       

eval() 函数十分强大 —— 将字符串 当成 有效的表达式 来求值 并 返回计算结果
```python
# 基本的数学计算
In [1]: eval("1 + 1")
Out[1]: 2

# 字符串重复
In [2]: eval("'*' * 10")
Out[2]: '**********'

# 将字符串转换成列表
In [3]: type(eval("[1, 2, 3, 4, 5]"))
Out[3]: list

# 将字符串转换成字典
In [4]: type(eval("{'name': 'xiaoming', 'age': 18}"))
Out[4]: dict
```
### 判断对象类型  
#### type() 判断类型   
判断基础数据类型  
```python
>>> type(123)==type(456)
True
>>> type(123)==int
True
>>> type('abc')==type('123')
True
>>> type('abc')==str
True
>>> type('abc')==type(123)
False
```
判断是否是函数  
```python
>>> import types
>>> def fn():
...     pass
...
>>> type(fn)==types.FunctionType
True
>>> type(abs)==types.BuiltinFunctionType
True
>>> type(lambda x: x)==types.LambdaType
True
>>> type((x for x in range(10)))==types.GeneratorType
True
```
#### isinstance() 判断继承关系  
继承关系如下
```python
object -> Animal -> Dog -> Husky
```
那么，isinstance()就可以告诉我们，一个对象是否是某种类型。先创建3种类型的对象：
```python
>>> a = Animal()
>>> d = Dog()
>>> h = Husky()
```
然后，判断：
```python
>>> isinstance(h, Husky)
True
```
能用type()判断的基本类型也可以用isinstance()判断：
```python
>>> isinstance('a', str)
True
>>> isinstance(123, int)
True
>>> isinstance(b'a', bytes)
True
```
并且还可以判断一个变量是否是某些类型中的一种，比如下面的代码就可以判断是否是list或者tuple：
```python
>>> isinstance([1, 2, 3], (list, tuple))
True
>>> isinstance((1, 2, 3), (list, tuple))
True
```
## 基础类型    
### 数字型  
#### 整型 (int)  
强转方法  
`int()`  

#### 浮点型（float）
强转方法 `float()`  

#### 布尔型（bool）  

> 注意大小写  

真 `True`
假 `False`

#### 运算符  

| 运算符 | 描述 | 实例 |
| :------------- | :------------- |:------------- |
| + | 加 | 10 + 20 = 30 |
| - | 减 | 10 - 20 = -10 |
| * | 乘 | 10 * 20 = 200 |
| / | 除 | 10 / 20 = 0.5 |
| // | 取整除  返回除法的整数部分（商） | 9 // 2 输出结果 4 |
| % | 取余数  返回除法的余数 | 9 % 2 = 1 |
| ** | 幂  又称次方、乘方 | 2 ** 3 = 8 |

### 非数字型  
包括：字符串、列表、元组、字典  

在 Python 中，所有 非数字型变量 都支持以下特点：

1. 都是一个 序列 `sequence`，也可以理解为 容器
2. 取值 `[]`
3. 遍历 `for in`
4. 计算长度、最大/最小值、比较、删除
5. 链接 `+` 和 重复 `*`
6. 切片  

#### 切片  
```
非数字类型[开始索引:结束索引:步长]  

'ding'[1:2] # 'i'
'ding'[1:-1] # 'in'
'ding'[::2] # 'dn'
'ding'[::-1] # 倒序 'gnid'
['ding', 'bu', 'nao'][1:2:]  # ['bu']
```

#### Python 内置函数
| 函数 |	描述 |	备注 |
|:-- |:--|:--|
| len(item) |	计算容器中元素个数 |	|
| del(item)/del(item[x]) |	删除变量 |	del item 两种方式 |
| max(item) |	返回容器中元素最大值 |	如果是字典，只针对 key 比较 |
| min(item) |	返回容器中元素最小值 |	如果是字典，只针对 key 比较 |

#### 运算符  
| 运算符 | Python 表达式 | 结果 | 描述 | 支持的数据类型 |
|:-- |:--|:--|:--|:--|
| + | [1, 2] + [3, 4] | [1, 2, 3, 4] | 合并 | 字符串、列表、元组 |
| * | ["Hi!"] * 4 | ['Hi!', 'Hi!', 'Hi!', 'Hi!'] | 重复 | 字符串、列表、元组 |
| in | 3 in (1, 2, 3) | True | 元素是否存在 | 字符串、列表、元组、字典 |
| not in | 4 not in (1, 2, 3) | True | 元素是否不存在 | 字符串、列表、元组、字典 |
| > >= == < <= | (1, 2, 3) < (2, 2, 3) | True | 元素比较 | 字符串、列表、元组 |

> in 在对 字典 操作时，判断的是 字典的键  

#### 字符串
在python中单双引号都是一样的  

多行字符串用三引号 `"""` 或 `'''` 包裹  
```python
'''这是一段多行字符串。这是它的第一行。
This is the second line.
"What's your name?," I asked.
He said "Bond, James Bond."
'''
```
在一个字符串中，一个放置在末尾的反斜杠表示字符串将在下一行继
续，但不会添加新的一行。来看看例子：
```python
"This is the first sentence. \
This is the second sentence."
相当于

"This is the first sentence. This is the second sentence."
```
同样可以用在任何代码中换行的地方  
```python
i = \
5
等同于
i = 5
```

##### r'' 原始字符串  
如果你需要指定一些未经过特殊处理的字符串，比如转义序列，那么你需要在字符串前增加
r 或 R 来指定一个 原始（Raw） 字符串 。下面是一个例子：
```python
ding = r"Newlines are indicated by \n"
print(ding)
输出  
Newlines are indicated by \n
```
这样就不用一个一个的去添加转义符 `\` 了  

所有字符串都是 `str` 类下的对象。下面的案例将演示这种类之下一些有用
的方法。要想获得这些方法的完成清单，你可以查阅 `help(str)` 。

##### 判断类型相关方法  

| 方法	| 说明 |
|:-- |:--|
| string.isspace()	| 如果 string 中只包含空格，则返回 True |
| string.isalnum()	| 如果 string 至少有一个字符并且所有字符都是字母或数字则返回 True |
| string.isalpha()	| 如果 string 至少有一个字符并且所有字符都是字母则返回 True |
| string.isdecimal()	| 如果 string 只包含数字则返回 True，全角数字 |
| string.isdigit()	| 如果 string 只包含数字则返回 True，全角数字、⑴、\u00b2 |
| string.isnumeric()	| 如果 string 只包含数字则返回 True，全角数字，汉字数字 |
| string.istitle()	| 如果 string 是标题化的(每个单词的首字母大写)则返回 True |
| string.islower()	| 如果 string 中包含至少一个区分大小写的字符，并且所有这些(区分大小写的)字符都是小写，则返回 True |
| string.isupper()	| 如果 string 中包含至少一个区分大小写的字符，并且所有这些(区分大小写的)字符都是大写，则返回 True |

##### 查找和替换相关方法  

| 方法	| 说明 |
|:-- |:--|
| `string.startswith(str)`	| 检查字符串是否是以 str 开头，是则返回 True |
| `string.endswith(str)`	| 检查字符串是否是以 str 结束，是则返回 True |
| `string.find(str, start=0, end=len(string))`	| 检测 str 是否包含在 string 中，如果 start 和 end 指定范围，则检查是否包含在指定范围内，如果是返回开始的索引值，否则返回 -1 |
| `string.rfind(str, start=0, end=len(string))`	| 类似于 find()，不过是从右边开始查找 |
| `string.index(str, start=0, end=len(string))`	| 跟 find() 方法类似，不过如果 str 不在 string 会报错 |
| `string.rindex(str, start=0, end=len(string))`	| 类似于 index()，不过是从右边开始 |
| `string.replace(old_str, new_str, num=string.count(old))`	| 把 string 中的 `old_str` 替换成 `new_str`，如果 num 指定，则替换不超过 num 次 |

##### 文本对齐相关  
| 方法	| 说明 |
|:-- |:--|
| string.ljust(width) | 返回一个原字符串左对齐，并使用空格填充至长度 width 的新字符串 |
| string.rjust(width) | 返回一个原字符串右对齐，并使用空格填充至长度 width 的新字符串 |
| string.center(width) | 返回一个原字符串居中，并使用空格填充至长度 width 的新字符串 |

##### 去除空白字符  

| 方法	| 说明 |
|:-- |:--|
| string.lstrip() | 截掉 string 左边（开始）的空白字符 |
| string.rstrip() | 截掉 string 右边（末尾）的空白字符 |
| string.strip() | 截掉 string 左右两边的空白字符 |

##### 拆分和连接相关方法  

| 方法	| 说明 |
|:-- |:--|
| string.partition(str) | 把字符串 string 分成一个 3 元素的元组 (str前面, str, str后面) |
| string.rpartition(str) | 类似于 partition() 方法，不过是从右边开始查找 |
| string.split(str="", num) | 以 str 为分隔符拆分 string，如果 num 有指定值，则仅分隔 num + 1 个子字符串，str 默认包含 '\r', '\t', '\n' 和空格 |
| string.splitlines() | 按照行('\r', '\n', '\r\n')分隔，返回一个包含各行作为元素的列表 |
| string.join(seq) | 以 string 作为分隔符，将 seq 中所有的元素（的字符串表示）合并为一个新的字符串 |


##### 格式化输出  
输出带数据的信息  
`%` 被称为 格式化操作符，专门用于处理字符串中的格式  
包含 `%` 的字符串，被称为 格式化字符串  
`%` 和不同的 字符 连用，不同类型的数据 需要使用 不同的格式化字符  

| 格式化字符 | 含义 |
|:--:|:--|
| %s | 字符串 |
| %d | 有符号十进制整数，%06d 表示输出的整数显示位数，不足的地方使用 0 补全 |
| %f | 浮点数，%.2f 表示小数点后只显示两位 |
| %% | 输出 % |  

语法格式：  
```python
print("格式化字符串" % 变量1)

print("格式化字符串" % (变量1, 变量2...))
```
示例：  
```python
print("我的名字叫 %s，请多多关照！" % name)
print("我的学号是 %06d" % student_no)
print("苹果单价 %.02f 元／斤，购买 %.02f 斤，需要支付 %.02f 元" % (price, weight, money))
print("数据比例是 %.02f%%" % (scale * 100))
```
##### `format()` 拼接字符串&格式化    
相对于拼接可能方便一点  
```python
age = 20
name = 'Swaroop'
print('{0} was {1} years old when he wrote this book'.format(name, age))
print('Why is {0} playing with that python?'.format(name))

等同于  
age = 20
name = 'Swaroop'
print('{} was {} years old when he wrote this book'.format(name, age))
print('Why is {} playing with that python?'.format(name))

输出：
$ python str_format.py
Swaroop was 20 years old when he wrote this book
Why is Swaroop playing with that python?
```
格式化替换的数据  
```python  
# 对于浮点数 '0.333' 保留小数点(.)后三位
print('{0:.3f}'.format(1.0/3))
# 使用下划线填充文本，并保持文字处于中间位置
# 使用 (^) 定义 '___hello___'字符串长度为 11
print('{0:_^11}'.format('hello'))
# 基于关键词输出 'Swaroop wrote A Byte of Python'
print('{name} wrote {book}'.format(name='Swaroop', book='A Byte of Python'))
```
##### `len() decode() encode()` 字节  
由于Python的字符串类型是str，在内存中以Unicode表示，一个字符对应若干个字节。如果要在网络上传输，或者保存到磁盘上，就需要把str变为以字节为单位的bytes。  
Python对bytes类型的数据用带b前缀的单引号或双引号表示：
```python
x = b'ABC'
```
如果我们从网络或磁盘上读取了字节流，那么读到的数据就是bytes。要把bytes变为str，就需要用decode()方法：  
```python
>>> b'ABC'.decode('ascii')
'ABC'
>>> b'\xe4\xb8\xad\xe6\x96\x87'.decode('utf-8')
'中文'
```
如果bytes中只有一小部分无效的字节，可以传入errors='ignore'忽略错误的字节：
```python
>>> b'\xe4\xb8\xad\xff'.decode('utf-8', errors='ignore')
'中'
```
要计算str包含多少个字符，可以用len()函数：
```python
>>> len('ABC')
3
>>> len('中文')
2
```
len()函数计算的是str的字符数，如果换成bytes，len()函数就计算字节数：
```python
>>> len(b'ABC')
3
>>> len(b'\xe4\xb8\xad\xe6\x96\x87')
6
>>> len('中文'.encode('utf-8'))
6
```


#### 列表List 数组  
定义列表
```python
ding = ['ding', 'bunao']
```
##### 列表常用操作  
| 序号 | 分类 | 关键字 、 函数 、 方法 | 说明 |
|:--:|:--:|:--|:--|
| 1 | 增加 | 列表.insert(索引, 数据) | 在指定位置插入数据 |
||| 列表.append(数据) | 在末尾追加数据 |
||| 列表.extend(列表2) | 将列表2 的数据追加到列表 |
| 2 | 修改 | 列表[索引] = 数据 | 修改指定索引的数据 |
| 3 | 删除 | del 列表[索引] | 删除指定索引的数据 |
||| 列表.remove[数据] | 删除第一个出现的指定数据 |
||| 列表.pop | 删除末尾数据 |
||| 列表.pop(索引) | 删除指定索引数据 |
||| 列表.clear | 清空列表 |
| 4 | 统计 | len(列表) | 列表长度 |
||| 列表.count(数据) | 数据在列表中出现的次数 |
| 5 | 排序 | 列表.sort() | 升序排序 |
||| 列表.sort(reverse=True) | 降序排序 |
||| 列表.reverse() | 逆序、反转 |
| 6 | 索引 | 元组.index(数据) | 获取数据第一次出现的索引，如果不存在会报异常 |
##### 列表生成式
要生成list [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]可以用 `list(range(1, 11))`  
如果要生成[1x1, 2x2, 3x3, ..., 10x10]怎么做？方法一是循环：  
```python
>>> L = []
>>> for x in range(1, 11):
...    L.append(x * x)
...
>>> L
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```
而列表生成式则可以用一行语句代替循环生成上面的list：
```python
>>> [x * x for x in range(1, 11)]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```
筛选出仅偶数的平方：
```python
>>> [x * x for x in range(1, 11) if x % 2 == 0]
[4, 16, 36, 64, 100]
```
还可以使用两层循环，可以生成全排列：
```python
>>> [m + n for m in 'ABC' for n in 'XYZ']
['AX', 'AY', 'AZ', 'BX', 'BY', 'BZ', 'CX', 'CY', 'CZ']
```

#### 元组 Tuple
元组和列表一样，只是元组不能修改(“指向不变”（引用的地址不变），如果指向的是一个可变的如list和对象，只要引用的地址不变，值是可以改变的)  
定义形式  
```
info = ('a', 1, 3)
```
只定义一个元素时由于()的歧义也要加 `,`   
```
info = ('a',)
```
##### 元组的常用操作  

| 序号 | 分类 | 关键字 、 函数 、 方法 | 说明 |
|:--:|:--:|:--|:--|
| 1 | 统计 | len(元组) | 元组长度 |
||| 元组.count(数据) | 数据在元组中出现的次数 |
| 2 | 索引 | 元组.index(数据) | 获取数据第一次出现的索引 |

##### 和列表互转  
```python
list(元组)   元组转列表
tuple(列表)  列表转元组
```
#### 字典 dictionary  
定义形式  
```python
xiaoming = {"name": "小明",
            "age": 18,
            "gender": True,
            "height": 1.75}
```

##### 字典的常用操作  

| 序号 | 分类 | 关键字/函数/方法 | 说明 |
|:--:|:--:|:--|:--|
| 1 | 取值 | 字典[key] | 取值，如果不存在则报错 |
| 1 | 取值 | 字典.get(key) | 取值，如果不存在也不报错，默认返回 None，也可以指定不存在时返回值 `.get('key', 666) |
| 2 | 修改/添加 | 字典[key] = 数据 | 修改指定key的数据，如果不存在则添加 |
|| 添加 | 字典.setdefault(key, value) | 如果key存在则不修改，不存在则添加 |
| 3 | 删除 | del 字典[key] | 删除指定key的数据 |
||| 字典.pop(key) | 删除指定key数据 |
||| 字典.popitem() | 随机删除一个 |
||| 字典.clear() | 清空字典 |
| 4 | 统计 | len(字典) | 字典长度 |
||| 字典.keys() | 所有key列表 |
||| 字典.values() | 所有value列表 |
||| 字典.items() | 所有(key, value)元组列表 |

#### 集合 set
set和字典dict类似，也是一组key的集合，但不存储value。由于key不能重复，所以，在set中，没有重复的key。

要创建一个set，需要提供一个list作为输入集合：
```python
>>> s = set([1, 2, 3, 3])
>>> s
{1, 2, 3}
```
通过 `add(key)` 方法可以添加元素到set中，可以重复添加，但不会有效果：
```python
>>> s.add(4)
>>> s
{1, 2, 3, 4}
>>> s.add(4)
>>> s
{1, 2, 3, 4}
```
通过 `remove(key)` 方法可以删除元素：
```python
>>> s.remove(4)
>>> s
{1, 2, 3}
```
set可以看成数学意义上的无序和无重复元素的集合，因此，两个set可以做数学意义上的交集、并集等操作：
```python
>>> s1 = set([1, 2, 3])
>>> s2 = set([2, 3, 4])
>>> s1 & s2
{2, 3}
>>> s1 | s2
{1, 2, 3, 4}
```

## 基础语句  
### if 语句  
```python
if 条件1:
    条件1满足执行的代码
    ……
elif 条件2:
    条件2满足时，执行的代码
    ……
elif 条件3:
    条件3满足时，执行的代码
    ……
else:
    以上条件都不满足时，执行的代码
    ……
```

#### 逻辑运算符  
逻辑运算符 包括：与 `and` 或 `or` 非 `not` 三种   

### 迭代 `for in`
```python
for ... in
```
dict类型  
```python
>>> d = {'a': 1, 'b': 2, 'c': 3}
>>> for key in d:
...     print(key)
...
a
c
b
```
如何判断一个对象是可迭代对象呢？方法是通过 `collections` 模块的 `Iterable` 类型判断：
```python
>>> from collections import Iterable
>>> isinstance('abc', Iterable) # str是否可迭代
True
>>> isinstance([1,2,3], Iterable) # list是否可迭代
True
>>> isinstance(123, Iterable) # 整数是否可迭代
False
```  
Python内置的enumerate函数可以把一个list变成索引-元素对，这样就可以在for循环中同时迭代索引和元素本身：
```python
>>> for i, value in enumerate(['A', 'B', 'C']):
...     print(i, value)
...
0 A
1 B
2 C
```
同时引用两个变量还有下面这种
```python
>>> for x, y in [(1, 1), (2, 4), (3, 9)]:
...     print(x, y)
...
1 1
2 4
3 9
```

### while循环  
```python
# 0. 最终结果
result = 0

# 1. 计数器
i = 0

# 2. 开始循环
while i <= 100:

    # 判断偶数
    if i % 2 == 0:
        print(i)
        result += i

    # 处理计数器
    i += 1

print("0~100之间偶数求和结果 = %d" % result)

```
#### 退出当前循环 break 和 跳当前此次循环 continue  


### 函数  
#### 函数的文档注释  
在开发中，如果希望给函数添加注释，应该在 定义函数 的下方，使用 连续的三对引号  
在 连续的三对引号 之间编写对函数的说明文字  
```python
"""
这是一个多行注释

在多行注释之间，可以写很多很多的内容……
"""
```

#### 变量 作用域  
```python
d = ['ding', 'a']
s =  'ding'
g_s = 'ding'
gl_list = [4, 5, 6]
def demo1(al, num_list):
    al.append('bunao')
    d.append('yes')
    num_list = [1, 2, 3]
    s = 'bunao'
    global g_s
    g_s = 'bunao'

demo(d, gl_list)
print(gl_list) # [4, 5, 6]
print(d) # ['ding', 'a', 'bunao', 'yes']
print(g_d) # ['ding', 'a']
print(s) # ding
print(g_s) # bunao
```
1. 列表、字典、对象这些**可变类型**作为函数的参数，函数内改变他们会影响到函数外的实参，但是赋值语句相当于修改了引用所以不会影响外部   

> 列表变量调用 `+=` 赋值, 本质上是在执行列表变量的 extend 方法,所以会影响外部  

2. 当不使用 `global` 关键字的时候，函数内用全局的变量都是复制了一份，更改不会影响到函数外  

#### 函数参数  
##### 缺省参数(默认参数)  
1. 缺省的参数必须放在最后
```python
def print_info(name, title, gender=True):
```
2. 当多个缺省参数时，调用的时候需要指定参数名  
```python
def print_info(name, title="", gender=True):
    ……

print_info("老王", title="班长")
print_info("小美", gender=False)
print_info(gender=False, name="小美")
```
> 默认参数必须指向不变对象！  

```python
def add_end(L=[]):
    L.append('END')
    return L
```
当你正常调用时，结果似乎不错：
```python
>>> add_end([1, 2, 3])
[1, 2, 3, 'END']
>>> add_end(['x', 'y', 'z'])
['x', 'y', 'z', 'END']
```
当你使用默认参数调用时，一开始结果也是对的：
```python
>>> add_end()
['END']
```
但是，再次调用add_end()时，结果就不对了：
```python
>>> add_end()
['END', 'END']
>>> add_end()
['END', 'END', 'END']
```
原因解释如下：

Python函数在定义的时候，默认参数L的值就被计算出来了，即[]，因为默认参数L也是一个变量，它指向对象[]，每次调用该函数，如果改变了L的内容，则下次调用时，默认参数的内容就变了，不再是函数定义时的[]了。  


##### 多值参数  
python 中有 两种 多值参数：
1. 参数名前增加 一个 `*` 可以接收 **元组** , 常用 `*args` 表示 **可变参数**   
2. 参数名前增加 两个 `*` 可以接收 **字典** , 常用 `**kwargs` 表示, **关键字参数**   

```python
def demo(num, *args, **kwargs):

    print(num)
    print(args)
    print(kwargs)


demo(1, 2, 3, 4, 5, name="小明", age=18, gender=True)
```
> 除了需要的参数，其他的不带参数名的会合并为 `args` 元组，带参数名的合并为 `kwargs` 字典  

###### 元组和字典的拆包  
如果想要把元组和字典直接传递给定义的多值参数，就需要拆包  
拆包 的方式是：  
在 元组变量前，增加 一个 *  
在 字典变量前，增加 两个 *  
```python
def demo(*args, **kwargs):

    print(args)
    print(kwargs)


# 需要将一个元组变量/字典变量传递给函数对应的参数
gl_nums = (1, 2, 3)
gl_xiaoming = {"name": "小明", "age": 18}

# 会把 num_tuple 和 xiaoming 作为元组传递个 args
# demo(gl_nums, gl_xiaoming)
demo(*gl_nums, **gl_xiaoming)
```
###### 命名关键字参数
对于关键字参数，函数的调用者可以传入任意不受限制的关键字参数。至于到底传入了哪些，就需要在函数内部通过kw检查。

以person()函数为例，我们希望检查是否有city和job参数：
```python
def person(name, age, **kw):
    if 'city' in kw:
        # 有city参数
        pass
    if 'job' in kw:
        # 有job参数
        pass
    print('name:', name, 'age:', age, 'other:', kw)
```

如果要限制关键字参数的名字，就可以用命名关键字参数，例如，只接收city和job作为关键字参数。这种方式定义的函数如下：
```python
def person(name, age, *, city, job):
    print(name, age, city, job)
```
和关键字参数 `**kw` 不同，命名关键字参数需要一个特殊分隔符 `*` ，`*` 后面的参数被视为命名关键字参数。

调用方式如下：
```python
>>> person('Jack', 24, city='Beijing', job='Engineer')
Jack 24 Beijing Engineer
```
如果函数定义中已经有了一个可变参数，后面跟着的命名关键字参数就不再需要一个特殊分隔符 `*` 了：
```python
def person(name, age, *args, city, job):
    print(name, age, args, city, job)
```
命名关键字参数必须传入参数名，这和位置参数不同。如果没有传入参数名，调用将报错：
```python
>>> person('Jack', 24, 'Beijing', 'Engineer')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: person() takes 2 positional arguments but 4 were given
```
由于调用时缺少参数名city和job，Python解释器把这4个参数均视为位置参数，但person()函数仅接受2个位置参数。

命名关键字参数可以有缺省值，从而简化调用：
```python
def person(name, age, *, city='Beijing', job):
    print(name, age, city, job)
```
由于命名关键字参数city具有默认值，调用时，可不传入city参数：
```python
>>> person('Jack', 24, job='Engineer')
Jack 24 Beijing Engineer
```
#### map()/reduce() 高阶函数  
map()函数接收两个参数，一个是函数，一个是Iterable，map将传入的函数依次作用到序列的每个元素，并把结果作为新的Iterator返回。  
```python
>>> def f(x):
...     return x * x
...
>>> r = map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])
>>> list(r)
[1, 4, 9, 16, 25, 36, 49, 64, 81]
```
map()传入的第一个参数是f，即函数对象本身。由于结果r是一个Iterator，Iterator是惰性序列，因此通过list()函数让它把整个序列都计算出来并返回一个list。  

reduce把一个函数作用在一个序列 `[x1, x2, x3, ...]` 上，这个函数必须接收两个参数，reduce把结果继续和序列的下一个元素做累积计算，其效果就是：
```python
reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)
```
比方说对一个序列求和，就可以用reduce实现：
```python
>>> from functools import reduce
>>> def add(x, y):
...     return x + y
...
>>> reduce(add, [1, 3, 5, 7, 9])
25
```
整理成一个str2int的函数就是：  
```python
from functools import reduce

DIGITS = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}

def str2int(s):
    def fn(x, y):
        return x * 10 + y
    def char2num(s):
        return DIGITS[s]
    return reduce(fn, map(char2num, s))
```
#### filter() 高阶函数实现过滤  
filter()也接收一个函数和一个序列。和map()不同的是，filter()把传入的函数依次作用于每个元素，然后根据返回值是True还是False决定保留还是丢弃该元素。

例如，在一个list中，删掉偶数，只保留奇数，可以这么写：
```
def is_odd(n):
    return n % 2 == 1

list(filter(is_odd, [1, 2, 4, 5, 6, 9, 10, 15]))
# 结果: [1, 5, 9, 15]
```
#### sorted() 高阶函数实现排序  
根据函数的返回值对原数据进行排序  
```
L = [('Bob', 75), ('Adam', 92), ('Bart', 66), ('Lisa', 88)]
def by_score(t):
    return t[1]
L2 = sorted(L, key = by_score) # [('Bart', 66), ('Bob', 75), ('Lisa', 88), ('Adam', 92)]  
```
要进行反向排序，不必改动key函数，可以传入第三个参数 `reverse=True`  

#### 匿名函数 lambda表达式  

匿名函数 `lambda x: x * x` 实际上就是：
```
def f(x):
    return x * x
```


## 面向对象  

### 定义类  
```
class 类名(object):

    def 方法1(self, 参数列表):
        pass

    def 方法2(self, 参数列表):
        pass
```
方法相对于函数只是多了一个 `self` 参数  
你一定会在想 Python 是如何给 `self` 赋值的，以及为什么你不必给它一个值。一个例子或许 会让这些疑问得到解答。假设你有一个 `MyClass` 的类，这个类下有一个实例 myobject 。当 你调用一个这个对象的方法，如 `myobject.method(arg1, arg2)` 时，Python 将会自动将其转 换成 `MyClass.method(myobject, arg1, arg2)` ——这就是 `self` 的全部特殊之处所在。    

`self`，表示创建的实例本身  
### 创建对象  
```
对象变量 = 类名()
```
### 内置方法  

| 序号 | 方法名 | 类型 | 作用 |
|:-- |:--|:--|:--|
| 01 | `__new__` | 方法 | 创建对象时，会被 自动 调用 |
| 02 | `__init__` | 方法 | 对象被初始化时，会被 自动 调用 |
| 03 | `__del__` | 方法 | 对象被从内存中销毁前，会被 自动 调用 |
| 04 | `__str__` | 方法 | 返回对象的描述信息，print 函数输出使用 |

> 可以使用 `dir(obj)` 查看  

#### `__new__` 方法  

使用 类名() 创建对象时，Python 的解释器 首先 会 调用 `__new__` 方法为对象 分配空间  
`__new__` 是一个 由 object 基类提供的 内置的静态方法，主要作用有两个：  
1) 在内存中为对象 分配空间  
2) 返回 对象的引用  
Python 的解释器获得对象的 引用 后，将引用作为 第一个参数，传递给 `__init__` 方法  

重写 `__new__` 方法 一定要 `return super().__new__(cls)`
否则 Python 的解释器 得不到 分配了空间的 对象引用，就不会调用对象的初始化方法  
> 注意：`__new__` 是一个~~静态方法~~ 类方法，在调用时需要 主动传递 `cls` 参数  

```Python
class MusicPlayer(object):

    def __new__(cls, *args, **kwargs):
        # 如果不返回则无法往后执行 __init__
        return super().__new__(cls)

    def __init__(self):
        print("初始化音乐播放对象")

player = MusicPlayer()

print(player)
```

#### 初始化 `__init__`   
初始化方法 `__init__` 主要做的事就是接受创建对象时传递的参数，创建属性，属性的初始化赋值  
```python
class Women:

    def __init__(self, name):

        self.name = name
        self.__age = 18
xiaofang = Women("小芳")
```
### 实例属性  
1. 在类的内部创建  
```python
class Women:

    def __init__(self, name):
        # 这就创建属性了
        self.name = name
        # 创建私有属性
        self.__age = 18
xiaofang = Women("小芳")
```
2. 通过对象创建  
```python
xiaofang.sex = 0
```
这就创建了属性，坑不坑，不建议这样使用  

#### 限制创建实例属性 `__slots__`  
Python允许在定义class的时候，定义一个特殊的 `__slots__` 变量，来限制该class实例能添加的属性：  
```python
class Student(object):
    __slots__ = ('name', 'age') # 用tuple定义允许绑定的属性名称
```
使用 `__slots__` 要注意， `__slots__` 定义的属性仅对当前类实例起作用，对继承的子类是不起作用的：  
除非在子类中也定义 `__slots__` ，这样，子类实例允许定义的属性就是自身的 `__slots__` 加上父类的 `__slots__` 。



### 私有  
在创建私有属性和私有方法的时候只需要在属性名或方法名前加两个下划线 `__`
```python
class Women:

    def __init__(self, name):

        self.name = name
        # 不要问女生的年龄
        self.__age = 18

    def __secret(self):
        print("我的年龄是 %d" % self.__age)


xiaofang = Women("小芳")
# 私有属性，外部不能直接访问
# print(xiaofang.__age)

# 私有方法，外部不能直接调用
# xiaofang.__secret()
```
Python 中，并没有 真正意义 的 私有

在给 属性、方法 命名时，实际是对 名称 做了一些特殊处理，使得外界无法访问到
处理方式：在 名称 前面加上 `_类名 => _类名__名称`
```python
# 私有属性，外部不能直接访问到
print(xiaofang._Women__age)

# 私有方法，外部不能直接调用
xiaofang._Women__secret()
```

`_x`: 单前置下划线,私有化属性或方法，`from somemodule import *` 禁止导入,类对象和子类可以访问  
`__xx`：双前置下划线,避免与子类中的属性命名冲突，无法在外部直接访问(名字重整所以访问不到)，子类不继承，子类不能访问  

### 继承  
python 默认继承 `Object` 类  
```python
class 类名(父类名):

    pass
```
#### 调用父类的属性/方法  
如果子类对父类的方法进行了重写覆盖，但是想调用父类中的方法可以通过 `super().父类方法名`
关于 super
1. 在 `Python` 中 `super` 是一个 特殊的类
2. `super()` 就是使用 `super` 类创建出来的对象

调用父类方法的另外一种方式（知道）

在 Python 2.x 时，如果需要调用父类的方法，还可以使用以下方式：
```python
父类名.方法(self)
```
#### 多继承  
```python
class 子类名(父类名1, 父类名2...)
    pass
```
不推荐，因为多个父类中重复的变量的方法将会变得不可控  

##### Python 中的 MRO —— 方法搜索顺序（知道）

Python 中针对 类 提供了一个 内置属性 `__mro__` 可以查看 方法 搜索顺序
MRO 是 method resolution order，主要用于 在多继承时判断 方法、属性 的调用 路径  
假设 `C` 类继承自 `A` 类和 `B` 类  
```
print(C.__mro__)
输出结果

(<class '__main__.C'>, <class '__main__.A'>, <class '__main__.B'>, <class 'object'>)
```
##### MixIn  
MixIn的目的就是给一个类增加多个功能，这样，在设计类的时候，我们优先考虑通过多重继承来组合多个MixIn的功能，而不是设计多层次的复杂的继承关系。

假设  
```python
class Dog(Mammal, Runnable, Carnivorous):
    pass
```  
由于多个父类中有相同的方法，会导致某个方法不可控，改成MixIn的方式就是让Dog继承一个主线Mammal,而其他两个父类中要用到的最小部分单独摘出来作为一个类，这个类通常以MixIn结尾  
```python
class Dog(Mammal, RunnableMixIn, CarnivorousMixIn):
    pass
```



### 类对象  
在 Python 中，类 是一个特殊的对象 —— 类对象  
除了封装 实例 的 属性 和 方法外，类对象 还可以拥有自己的 属性 和 方法  

所有的实例共享 类属性和类方法，通过类名进行访问  
#### 类属性  

```python
class Tool(object):
    # 定义类属性
    # 使用赋值语句，定义类属性，记录创建工具对象的总数
    count = 0

    def __init__(self, name):
        self.name = name

        # 针对类属性做一个计数+1
        Tool.count += 1


# 创建工具对象
tool1 = Tool("斧头")
tool2 = Tool("榔头")
tool3 = Tool("铁锹")

# 知道使用 Tool 类到底创建了多少个对象?
print("现在创建了 %d 个工具" % Tool.count)
```
在 Python 中 属性的获取 存在一个 向上查找机制，**在对象中查找不到的实例属性会自动向上查找类属性**   
因此，要访问类属性有两种方式：
1. 类名.类属性
2. 对象.类属性 （不推荐）

> 如果使用 对象.类属性 = 值 赋值语句，只会 给对象添加一个属性，而不会影响到 类属性的值

#### 类方法  
```python
@classmethod
def 类方法名(cls):
    pass
```
1. 类方法需要用 修饰器 `@classmethod` 来标识，告诉解释器这是一个类方法  
2. 类方法的 第一个参数 应该是 `cls`  
    2.1 由 哪一个类 调用的方法，方法内的 cls 就是 哪一个类的引用  
    2.2 这个参数和 实例方法 的第一个参数是 self 类似  
3. 通过 `类名. 调用` 类方法，调用方法时，不需要传递 `cls` 参数  
4. 在方法内部  
    4.1 可以通过 `cls.` 访问类的属性  
    4.2 也可以通过 `cls.` 调用其他的类方法  

#### 静态方法
```python
@staticmethod
def 静态方法名():
    pass
```
静态方法也是用过 `类名.` 调用  
和类方法的不同是：没有办法通过 `cls`来访问 类属性 或者调用 类方法，但是可以通过类名直接调用    
但是，这会在继承的时候显示出来差别，因为类方法的 `cls` 参数是动态的，使用的是调用者的类对象，而静态方法是写死的  
#### 实例方法、静态方法和类方法  
三种方法在内存中 **都归属于类**，区别在于调用方式不同。

实例方法：由对象调用；至少一个self参数；执行实例方法时，自动将调用该方法的对象赋值给self；  
类方法：由类调用； 至少一个cls参数；执行类方法时，自动将调用该方法的类赋值给cls；  
静态方法：由类调用；无默认参数；    


相同点：对于所有的方法而言，均属于类，所以 在内存中也只保存一份  
不同点：方法调用者不同、调用方法时自动传入的参数不同。  


### 单例  
```python
class MusicPlayer(object):

    # 记录第一个被创建对象的引用
    instance = None
    # 记录是否执行过初始化动作
    init_flag = False

    def __new__(cls, *args, **kwargs):

        # 1. 判断类属性是否是空对象
        if cls.instance is None:
            # 2. 调用父类的方法，为第一个对象分配空间
            cls.instance = super().__new__(cls)

        # 3. 返回类属性保存的对象引用
        return cls.instance

    def __init__(self):
        # 防止每次都初始化
        if not MusicPlayer.init_flag:
            print("初始化音乐播放器")

            MusicPlayer.init_flag = True


# 创建多个对象
player1 = MusicPlayer()
print(player1)

player2 = MusicPlayer()
print(player2)
```
**注意点**  
创建对象的时候每次都会执行 `__new__` 和 `__init__` 方法，所以 `__init__` 方法中的初始化也要进行判断  


### is 与 == 区别：

`is` 用于判断 两个变量 引用对象(地址)是否为同一个
`==` 用于判断 引用变量的值 是否相等
```python
>>> a = [1, 2, 3]
>>> b = [1, 2, 3]
>>> b is a
False
>>> b == a
True
```
### 属性操作 getattr()、setattr()、hasattr() 反射获取  
```python
>>> class MyObject(object):
...     def __init__(self):
...         self.x = 9
...     def power(self):
...         return self.x * self.x
...
>>> obj = MyObject()
```
紧接着，可以测试该对象的属性：
```python
>>> hasattr(obj, 'x') # 有属性'x'吗？
True
>>> obj.x
9
>>> hasattr(obj, 'y') # 有属性'y'吗？
False
>>> setattr(obj, 'y', 19) # 设置一个属性'y'
>>> hasattr(obj, 'y') # 有属性'y'吗？
True
>>> getattr(obj, 'y') # 获取属性'y'
19
>>> obj.y # 获取属性'y'
19
```
如果试图获取不存在的属性，会抛出AttributeError的错误：
```python
>>> getattr(obj, 'z') # 获取属性'z'
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'MyObject' object has no attribute 'z'
```
可以传入一个default参数，如果属性不存在，就返回默认值：
```python
>>> getattr(obj, 'z', 404) # 获取属性'z'，如果不存在，返回默认值404
404
```
> 要注意的是，只有在不知道对象信息的时候，我们才会去获取对象信息。(性能原因)

### 使用装饰器 decorator  
可以将方法当做属性来使用，也就是类似于定义 `getter/setter` 方法  
```python
class Student(object):

    @property # 设置成getter属性
    def score(self):
        return self._score

    @score.setter # 设置成setter属性
    def score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value


>>> s = Student()
>>> s.score = 60 # OK，实际转化为s.set_score(60)
>>> s.score # OK，实际转化为s.get_score()
60
>>> s.score = 9999
Traceback (most recent call last):
  ...
ValueError: score must between 0 ~ 100!
```
三种@property装饰器
```python
#coding=utf-8
# ############### 定义 ###############
class Goods:
    """python3中默认继承object类
        以python2、3执行此程序的结果不同，因为只有在python3中才有@xxx.setter  @xxx.deleter
    """
    @property
    def price(self):
        print('@property')

    @price.setter
    def price(self, value):
        print('@price.setter')

    @price.deleter
    def price(self):
        print('@price.deleter')

# ############### 调用 ###############
obj = Goods()
obj.price          # 自动执行 @property 修饰的 price 方法，并获取方法的返回值
obj.price = 123    # 自动执行 @price.setter 修饰的 price 方法，并将  123 赋值给方法的参数
del obj.price      # 自动执行 @price.deleter 修饰的 price 方法
```
#### 类属性方式，创建值为property对象的类属性  

property方法中有个四个参数  

第一个参数是方法名，调用 `对象.属性` 时自动触发执行方法  
第二个参数是方法名，调用 `对象.属性 ＝ XXX` 时自动触发执行方法  
第三个参数是方法名，调用 `del 对象.属性` 时自动触发执行方法  
第四个参数是字符串，调用 `对象.属性.__doc__` ，此参数是该属性的描述信息  
```python
#coding=utf-8
class Foo(object):
    def get_bar(self):
        print("getter...")
        return 'laowang'

    def set_bar(self, value):
        """必须两个参数"""
        print("setter...")
        return 'set value' + value

    def del_bar(self):
        print("deleter...")
        return 'laowang'

    BAR = property(get_bar, set_bar, del_bar, "description...")

obj = Foo()

obj.BAR  # 自动调用第一个参数中定义的方法：get_bar
obj.BAR = "alex"  # 自动调用第二个参数中定义的方法：set_bar方法，并将“alex”当作参数传入
desc = Foo.BAR.__doc__  # 自动获取第四个参数中设置的值：description...
print(desc)
del obj.BAR  # 自动调用第三个参数中定义的方法：del_bar方法
```
### 魔术属性  
[参考-定制类](https://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/0014319098638265527beb24f7840aa97de564ccc7f20f6000)  
#### `__doc__` 获取类的描述信息  
```python
class Foo:
    """ 描述类信息，这是用于看片的神奇 """
    def func(self):
        pass

print(Foo.__doc__)
#输出：类的描述信息
```
#### `__module__` 模块信息 `__class__`类信息  

test.py
```python
# -*- coding:utf-8 -*-

class Person(object):
    def __init__(self):
        self.name = 'laowang'
```      
main.py
```python
from test import Person

obj = Person()
print(obj.__module__)  # 输出 test 即：输出模块
print(obj.__class__)  # 输出 test.Person 即：输出类
```

#### `__init__` 创建的时候触发

初始化方法，通过类创建对象时，自动触发执行  
```python
class Person:
    def __init__(self, name):
        self.name = name
        self.age = 18


obj = Person('laowang')  # 自动执行类中的 __init__ 方法
```
#### `__del__` 删除对象的时候触发

当对象在内存中被释放时，自动触发执行。
注：此方法一般无须定义，因为Python是一门高级语言，程序员在使用时无需关心内存的分配和释放，因为此工作都是交给Python解释器来执行，所以，`__del__` 的调用是由解释器在进行垃圾回收时自动触发执行的。
```python
class Foo:
    def __del__(self):
        pass
```
#### `__call__` 对象后面加括号，触发执行。

对象后面加括号，触发执行。
注：`__init__` 方法的执行是由创建对象触发的，即：`对象 = 类名()` ；而对于 `__call__` 方法的执行是由对象后加括号触发的，即：`对象() 或者 类()()`
```python
class Foo:
    def __init__(self):
        pass

    def __call__(self, *args, **kwargs):
        print('__call__')


obj = Foo()  # 执行 __init__
obj()  # 执行 __call__
```
#### `__dict__` 类或对象中的所有属性和方法

类或对象中的所有属性  
类的实例属性属于对象；类中的类属性和方法等属于类，即：

```python
class Province(object):
    country = 'China'

    def __init__(self, name, count):
        self.name = name
        self.count = count

    def func(self, *args, **kwargs):
        print('func')
# 获取类的属性，即：类属性、方法、
print(Province.__dict__)
# 输出：{'__dict__': <attribute '__dict__' of 'Province' objects>, '__module__': '__main__', 'country': 'China', '__doc__': None, '__weakref__': <attribute '__weakref__' of 'Province' objects>, 'func': <function Province.func at 0x101897950>, '__init__': <function Province.__init__ at 0x1018978c8>}

obj1 = Province('山东', 10000)
print(obj1.__dict__)
# 获取 对象obj1 的属性
# 输出：{'count': 10000, 'name': '山东'}

obj2 = Province('山西', 20000)
print(obj2.__dict__)
# 获取 对象obj1 的属性
# 输出：{'count': 20000, 'name': '山西'}
```
#### `__str__` 类当字符串使用的时候

如果一个类中定义了 `__str__` 方法，那么在打印 对象 时，默认输出该方法的返回值。  
```python
class Foo:
    def __str__(self):
        return 'laowang'


obj = Foo()
print(obj)
# 输出：laowang
```
#### `__getitem__、__setitem__、__delitem__` 当字典使用  

用于索引操作，如字典。以上分别表示获取、设置、删除数据
```python
# -*- coding:utf-8 -*-

class Foo(object):

    def __getitem__(self, key):
        print('__getitem__', key)

    def __setitem__(self, key, value):
        print('__setitem__', key, value)

    def __delitem__(self, key):
        print('__delitem__', key)


obj = Foo()

result = obj['k1']      # 自动触发执行 __getitem__
obj['k2'] = 'laowang'   # 自动触发执行 __setitem__
del obj['k1']           # 自动触发执行 __delitem__
```
#### `__getslice__、__setslice__、__delslice__` 对象切片  

该三个方法用于分片操作，如：列表  
```python
# -*- coding:utf-8 -*-

class Foo(object):

    def __getslice__(self, i, j):
        print('__getslice__', i, j)

    def __setslice__(self, i, j, sequence):
        print('__setslice__', i, j)

    def __delslice__(self, i, j):
        print('__delslice__', i, j)

obj = Foo()

obj[-1:1]                   # 自动触发执行 __getslice__
obj[0:1] = [11,22,33,44]    # 自动触发执行 __setslice__
del obj[0:2]                # 自动触发执行 __delslice__
```
#### `__iter__` 和 `__next__` 实现迭代器，用来遍历  
如果一个类想被用于for ... in循环，类似list或tuple那样，就必须实现一个 `__iter__()` 方法，该方法返回一个迭代对象，然后，Python的for循环就会不断调用该迭代对象的 `__next__()` 方法拿到循环的下一个值，直到遇到StopIteration错误时退出循环。

我们以斐波那契数列为例，写一个Fib类，可以作用于for循环：
```python
class Fib(object):
    def __init__(self):
        self.a, self.b = 0, 1 # 初始化两个计数器a，b

    def __iter__(self):
        return self # 实例本身就是迭代对象，故返回自己

    def __next__(self):
        self.a, self.b = self.b, self.a + self.b # 计算下一个值
        if self.a > 100000: # 退出循环的条件
            raise StopIteration()
        return self.a # 返回下一个值
现在，试试把Fib实例作用于for循环：

>>> for n in Fib():
...     print(n)
...
1
1
2
3
5
...
46368
75025
```
#### `__getattr__` `__setattr__` 属性不存在的时候调用  
当属性不存在的时候就会调用 `__getattr__`   
```python
class Student(object):

    def __init__(self):
        self.name = 'Michael'

    def __getattr__(self, attr):
        if attr=='score':
            return 99
    def __setattr__(self, key, value):
        self[key] = value
```
当调用不存在的属性时，比如score，Python解释器会试图调用 `__getattr__(self, 'score')` 来尝试获得属性，这样，我们就有机会返回score的值：
```python
>>> s = Student()
>>> s.name
'Michael'
>>> s.score
99
```
返回函数也是完全可以的：
```python
class Student(object):

    def __getattr__(self, attr):
        if attr=='age':
            return lambda: 25
```
只是调用方式要变为：
```python
>>> s = Student()
>>> s.age
<function Student.__getattr__.<locals>.<lambda> at 0x0000000001E7BB70>
>>> s.age()
25
```
此外，注意到任意调用如s.abc都会返回None，这是因为我们定义的 `__getattr__` 默认返回就是None。要让class只响应特定的几个属性，我们就要按照约定，抛出AttributeError的错误：
```python
class Student(object):

    def __getattr__(self, attr):
        if attr=='age':
            return lambda: 25
        raise AttributeError('\'Student\' object has no attribute \'%s\'' % attr)
```


## 异常  
看例子  
```python
try:
    # 尝试执行的代码
    pass
except 错误类型1:
    # 针对错误类型1，对应的代码处理
    pass
except 错误类型2:
    # 针对错误类型2，对应的代码处理
    pass
except (错误类型3, 错误类型4):
    # 针对错误类型3 和 4，对应的代码处理
    pass
except Exception as result:
    # 打印错误信息
    print(result)
else:
    # 没有异常才会执行的代码
    pass
finally:
    # 无论是否有异常，都会执行的代码
    print("无论是否有异常，都会执行的代码")
```
### 抛出异常 raise  
```python
def input_password():

    pwd = input("请输入密码：")

    if len(pwd) >= 8:
        return pwd

    # 1> 创建异常对象 - 使用异常的错误信息字符串作为参数
    ex = Exception("密码长度不够")

    # 2> 抛出异常对象
    raise ex


try:
    user_pwd = input_password()
    print(user_pwd)
except Exception as result:
    print("发现错误：%s" % result)
```
### 记录异常日志  
ython内置的logging模块可以非常容易地记录错误信息：
```python
# err_logging.py

import logging

def foo(s):
    return 10 / int(s)

def bar(s):
    return foo(s) * 2

def main():
    try:
        bar('0')
    except Exception as e:
        logging.exception(e)

main()
print('END')
```
同样是出错，但程序打印完错误信息后会继续执行，并正常退出：
```python
$ python3 err_logging.py
ERROR:root:division by zero
Traceback (most recent call last):
  File "err_logging.py", line 13, in main
    bar('0')
  File "err_logging.py", line 9, in bar
    return foo(s) * 2
  File "err_logging.py", line 6, in foo
    return 10 / int(s)
ZeroDivisionError: division by zero
END
```
通过配置，logging还可以把错误记录到日志文件里，方便事后排查。
## 模块和包  
### 模块  
和js一样一个文件就是一个模块  
在模块中定义的 全局变量 、函数、类 都是提供给外界直接使用的 工具  
模块 就好比是 工具包，要想使用这个工具包中的工具，就需要先 导入 这个模块  
#### 引入模块  
1. `import module`  导入整个模块 `module`，通过模块来访问模块中的变量  
```python
import sys
print('The command line arguments are:')
for i in sys.argv:
    print(i)
print('\n\nThe PYTHONPATH is', sys.path, '\n')
```
如果模块的名字太长，可以使用 `as` 指定模块的名称，以方便在代码中的使用
```python
import 模块名1 as 模块别名
```
2. `from module import var` 从模块 `module` 中导入变量 `var` ，导入到的变量可以直接使用,也可以导入私有变量，不推荐    
导入一个模块的多个变量 `from module import var1, var2`  
导入一个模块的所有变量，除了私有变量 `from module import *`  

一旦发现冲突，可以使用 `as` 关键字 给其中一个工具起一个别名

#### `__name__` 属性  
前置理解：当模块第一次被导入时，它所包含的没有缩进的代码将被执行  
所以可以通过判断 `__name__` 来确定该模块是否是独立运行  

每个模块都有定义它的 `__name__` 属性，当 `__name__ == '__main__'`
表示这个模块是独立运行的，而不是导入到了其他模块。
#### `__file__` 属性 模块路径  
Python 中每一个模块都有一个内置属性 `__file__` 可以 查看模块 的 完整路径

#### import搜索路径  
查看 import 搜索的路径  
```python
import sys
sys.path
```
1. 从上面列出的目录里依次查找要导入的模块文件
2. `''` 表示当前路径
3. 列表中的路径的先后顺序代表了python解释器在搜索模块时的先后顺序

#### 添加新的模块路径  
```python
sys.path.append('/home/itcast/xxx')
sys.path.insert(0, '/home/itcast/xxx')  # 可以确保先搜索这个路径
```
#### 重新导入模块  
导入模块后，如果没有结束，然后修改了模块的内容，在此导入，依旧不会生效，这就要用到重新导入模块  
```python
from imp import reload
reload(module) # 重新导入模块  
```

#### 多模块开发时导入时需要注意  
当两个模块共用了一个模块，并且同时执行时会出现问题  
假设 `test.py` 模块  
```python
ding = 'ding'
def test():
    print('--2--')
```
假设 `xiaoming.py` 模块  
```python
import test
def xChang():
    test.ding = 'ran'

def xEcho():
    print(test.ding)
```
假设 `you.py` 模块  
```python
import test
def chang():
    test.ding = 'bunao'

def echo():
    print(test.ding)
```
假设 `main.py` 模块  
```python
from xiaoming import *
from you import *
chang()
xEcho() # 出现了bunao
```
直接通过 `import` 导入模块使用时，可以将这个模块比作 **一个类对象** 使用，在一个模块中使用会影响到其他使用的模块    
```python
import common
# 如果通过这种方式导入的变量，更改变量 common.HANDLE_FLAG则会影响其他导入这个模块的这个值  
```  
通过 `from xxx import xxx` 导入的，相当于直接将变量复制到本模块，不会影响其他的模块    
```python
from common import HANDLE_FLAG
# 如果是通过这种方式导入的变量，更改变量HANDLE_FLAG则不会影响到其他使用该模块中的这个变量  
```

### 包  
文件多了就要用文件夹管理，python中和java一样将文件夹称为包  

包是指一个包含模块与一个特殊的 `__init__.py` 文件的文件夹，后者向 Python 表明这一文件夹是特别的，因为其包含了 Python 模块。  

建设你想创建一个名为“world”的包，其中还包含着”asia“、”africa“等其它子包，同时这些子包都包含了诸如”india“、”madagascar“等模块。  
下面是你会构建出的文件夹的结构：
```python
- <some folder present in the sys.path>/
	- world/
	- __init__.py
	- asia/
		- __init__.py
		- india/
			- __init__.py
			- foo.py
	- africa/
		- __init__.py
		- madagascar/
			- __init__.py
			- bar.py
```
使用 `import 包名` 可以一次性导入 包 中 所有的模块  

#### pip安装第三方模块  
pip 是一个现代的，通用的 Python 包管理工具
提供了对 Python 包的查找、下载、安装、卸载等功能  
```python
# 将模块安装到 Python 3.x 环境
$ sudo pip3 install pygame
$ sudo pip3 uninstall pygame
```
#### 发布模块  
假设要在发布的包在test文件夹下buildpacket包下的模块  
目录如下
```python
/test
    setup.py # 创建 setup.py 文件
    /buildpacket
        __init__.py
        ding.py
        /ran
            __init__.py
            bunao.py

```
1. 创建setup.py文件，setup.py 文件内容如下  
```python
from distutils.core import setup

setup(name="ding",  # 包名,生成发布压缩包时的压缩包名
      version="1.0",  # 版本
      description="描述",  # 描述信息
      long_description="完整描述",  # 完整描述信息
      author="ding",  # 作者
      author_email="",  # 作者邮箱
      url="www.bunao.me",  # 主页
      py_modules=["buildpacket.ding",
                  "buildpacket.ran.bunao"]) # 要打包的模块
```

[官网上有关字典参数的详细信息](https://docs.python.org/2/distutils/apiref.html)  

2. 构建模块  
```python
$ python3 setup.py build
```
这个步骤其实就是复制，将包复制到 `./build/lib/` 下  

3. 生成发布压缩包
```python
$ python3 setup.py sdist
```
在 `./dist/` 下生成要发布的压缩包  

4. 安装模块  
```python
# 解压./dist/ 下的压缩包  
$ tar -zxvf ding-1.0.tar.gz
# 进入到解压后的文件夹中 执行里面的setup.py
$ sudo python3 setup.py install
```
win系统将会在安装python的目录中的 `Lib/site-packages/` 下创建`buildpacket`包(带`__pycache__`文件夹)   
同时也会在执行 `install` 的目录下创建`build/buildpacket` 包(原包，不带`__pycache__`文件夹)  
5. 引入模块  
```python
import buildpacket # 引入整个包
import buildpacket.ding # 引入包下的模块
import buildpacket.ran.bunao # 引入包下的包下的模块  
```
5. 删除模块  
找到安装模块的地方，直接删除包文件夹   
```python
$ cd /usr/local/lib/python3.5/dist-packages/
$ sudo rm -r ding*
```


## 文件操作  

| 序号 | 函数/方法 | 说明 |
| :--- | :--- |:--- |
| 01 | open | 打开文件，并且返回文件操作对象 |
| 02 | read | 将文件所有内容读取到内存,可以反复调用read(size)方法，每次最多读取size个字节的内容。 |
| 03 | readline | 将文件一行内容读取到内存 |
| 03 | readlines | 将文件所有行内容读取到list数组中 |
| 04 | write | 将指定内容写入文件 |
| 05 | close | 关闭文件 |  

```python
# 1. 打开 - 文件名需要注意大小写
file = open("README")

# 2. 读取
text = file.read()
print(text)

# 3. 关闭
file.close()
```
### 打开文件方式  
open 函数默认以 只读方式 打开文件，并且返回文件对象
语法如下：
```python
f = open("文件名", "访问方式")
```
| 访问方式 | 说明 |
| :---: | :--- |
| r | 以只读方式打开文件。文件的指针将会放在文件的开头，这是默认模式。如果文件不存在，抛出异常 |
| w | 以只写方式打开文件。如果文件存在会被覆盖。如果文件不存在，创建新文件 |
| a | 以追加方式打开文件。如果该文件已存在，文件指针将会放在文件的结尾。如果文件不存在，创建新文件进行写入 |
| r+ | 以读写方式打开文件。文件的指针将会放在文件的开头。如果文件不存在，抛出异常 |
| w+ | 以读写方式打开文件。如果文件存在会被覆盖。如果文件不存在，创建新文件 |
| a+ | 以读写方式打开文件。如果该文件已存在，文件指针将会放在文件的结尾。如果文件不存在，创建新文件进行写入 |  

### 大文件复制示例   
```python
# 1. 打开文件
file_read = open("README")
file_write = open("README[复件]", "w")

# 2. 读取并写入文件
while True:
    # 每次读取一行
    text = file_read.readline()

    # 判断是否读取到内容
    if not text:
        break

    file_write.write(text)

# 3. 关闭文件
file_read.close()
file_write.close()
```
### 文件／目录操作  
在 Python 中，如果希望通过程序实现上述功能，需要导入 os 模块  
#### 文件操作  

| 序号 | 方法名 | 说明 | 示例 |
| :--- | :--- |:--- |:--- |
| 01 | rename | 重命名文件 | os.rename(源文件名, 目标文件名) |
| 02 | remove | 删除文件 | os.remove(文件名) |

#### 目录操作  

| 序号 | 方法名 | 说明 | 示例 |
| :--- | :--- |:--- |:--- |
| 01 | listdir | 目录列表 | os.listdir(目录名) |
| 02 | mkdir | 创建目录 | os.mkdir(目录名) |
| 03 | rmdir | 删除目录 | os.rmdir(目录名) |
| 04 | getcwd | 获取当前目录 | os.getcwd() |
| 05 | chdir | 修改工作目录 | os.chdir(目标目录) |
| 06 | path.isdir | 判断是否是目录 | os.path.isdir(目录路径) |  

## 基本模块  
默认情况下，Python解释器会搜索当前目录、所有已安装的内置模块和第三方模块，搜索路径存放在sys模块的path变量中：
```python
>>> import sys
>>> sys.path
['', '/Library/Frameworks/Python.framework/Versions/3.6/lib/python36.zip', '/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6', ..., '/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages']
```
如果我们要添加自己的搜索目录，有两种方法：

一是直接修改 `sys.path` ，添加要搜索的目录：
```python
>>> import sys
>>> sys.path.append('/Users/michael/my_py_scripts')
```
这种方法是在运行时修改，运行结束后失效。

第二种方法是设置环境变量 `PYTHONPATH`，该环境变量的内容会被自动添加到模块搜索路径中。设置方式与设置Path环境变量类似。注意只需要添加你自己的搜索路径，Python自己本身的搜索路径不受影响。  

### os模块 系统相关   
其实操作系统提供的命令只是简单地调用了操作系统提供的接口函数，Python内置的os模块也可以直接调用操作系统提供的接口函数。  
执行终端命令  
```python
__import__('os').system('ls')
等价代码
import os
os.system("终端命令")
```  

```python
>>> import os
>>> os.name # 操作系统类型
'posix'
```
如果是posix，说明系统是Linux、Unix或Mac OS X，如果是nt，就是Windows系统。

要获取详细的系统信息，可以调用uname()函数：
```python
>>> os.uname()
posix.uname_result(sysname='Darwin', nodename='MichaelMacPro.local', release='14.3.0', version='Darwin Kernel Version 14.3.0: Mon Mar 23 11:59:05 PDT 2015; root:xnu-2782.20.48~5/RELEASE_X86_64', machine='x86_64')
```
注意uname()函数在Windows上不提供，也就是说，os模块的某些函数是跟操作系统相关的。

环境变量

在操作系统中定义的环境变量，全部保存在os.environ这个变量中，可以直接查看：
```python
>>> os.environ
environ({'VERSIONER_PYTHON_PREFER_32_BIT': 'no', 'TERM_PROGRAM_VERSION': '326', 'LOGNAME': 'michael', 'USER': 'michael', 'PATH': '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/usr/local/mysql/bin', ...})
```
要获取某个环境变量的值，可以调用os.environ.get('key')：
```python
>>> os.environ.get('PATH')
'/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/usr/local/mysql/bin'
>>> os.environ.get('x', 'default')
'default'
```
#### 操作文件和目录

操作文件和目录的函数一部分放在os模块中，一部分放在os.path模块中，这一点要注意一下。查看、创建和删除目录可以这么调用：
```python
# 查看当前目录的绝对路径:
>>> os.path.abspath('.')
'/Users/michael'
# 在某个目录下创建一个新目录，首先把新目录的完整路径表示出来:
>>> os.path.join('/Users/michael', 'testdir')
'/Users/michael/testdir'
# 然后创建一个目录:
>>> os.mkdir('/Users/michael/testdir')
# 删掉一个目录:
>>> os.rmdir('/Users/michael/testdir')
```
把两个路径合成一个时，不要直接拼字符串，而要通过os.path.join()函数，这样可以正确处理不同操作系统的路径分隔符。在Linux/Unix/Mac下，os.path.join()返回这样的字符串：
```python
part-1/part-2
```
而Windows下会返回这样的字符串：
```python
part-1\part-2
```
同样的道理，要拆分路径时，也不要直接去拆字符串，而要通过os.path.split()函数，这样可以把一个路径拆分为两部分，后一部分总是最后级别的目录或文件名：
```python
>>> os.path.split('/Users/michael/testdir/file.txt')
('/Users/michael/testdir', 'file.txt')
```
os.path.splitext()可以直接让你得到文件扩展名，很多时候非常方便：
```python
>>> os.path.splitext('/path/to/file.txt')
('/path/to/file', '.txt')
```
这些合并、拆分路径的函数并不要求目录和文件要真实存在，它们只对字符串进行操作。

文件操作使用下面的函数。假定当前目录下有一个test.txt文件：
```python
# 对文件重命名:
>>> os.rename('test.txt', 'test.py')
# 删掉文件:
>>> os.remove('test.py')
```
但是复制文件的函数居然在os模块中不存在！原因是复制文件并非由操作系统提供的系统调用。理论上讲，我们通过上一节的读写文件可以完成文件复制，只不过要多写很多代码。

幸运的是shutil模块提供了copyfile()的函数，你还可以在shutil模块中找到很多实用函数，它们可以看做是os模块的补充。

最后看看如何利用Python的特性来过滤文件。比如我们要列出当前目录下的所有目录，只需要一行代码：
```python
>>> [x for x in os.listdir('.') if os.path.isdir(x)]
['.lein', '.local', '.m2', '.npm', '.ssh', '.Trash', '.vim', 'Applications', 'Desktop', ...]
要列出所有的.py文件，也只需一行代码：

>>> [x for x in os.listdir('.') if os.path.isfile(x) and os.path.splitext(x)[1]=='.py']
['apis.py', 'config.py', 'models.py', 'pymonitor.py', 'test_db.py', 'urls.py', 'wsgiapp.py']
```

### datetime 时间模块  
#### now() 获取当前日期和时间

我们先看如何获取当前日期和时间：
```python
>>> from datetime import datetime
>>> now = datetime.now() # 获取当前datetime
>>> print(now)
2015-05-18 16:28:07.198690
```
#### 设置时间  
```python
>>> from datetime import datetime
>>> dt = datetime(2015, 4, 19, 12, 20) # 用指定日期时间创建datetime
>>> print(dt)
2015-04-19 12:20:00
```
#### 转时间戳  
把一个datetime类型转换为timestamp只需要简单调用timestamp()方法：
```python
>>> from datetime import datetime
>>> dt = datetime(2015, 4, 19, 12, 20) # 用指定日期时间创建datetime
>>> dt.timestamp() # 把datetime转换为timestamp
1429417200.0
```
注意Python的timestamp是一个浮点数。如果有小数位，小数位表示毫秒数。
#### 时间戳转时间  
要把timestamp转换为datetime，使用datetime提供的fromtimestamp()方法：
```python
>>> from datetime import datetime
>>> t = 1429417200.0
>>> print(datetime.fromtimestamp(t))
2015-04-19 12:20:00
```
注意到timestamp是一个浮点数，它没有时区的概念，而datetime是有时区的。上述转换是在timestamp和本地时间(系统时间)做转换。  
timestamp也可以直接被转换到UTC标准时区的时间：
```python
>>> from datetime import datetime
>>> t = 1429417200.0
>>> print(datetime.fromtimestamp(t)) # 本地时间
2015-04-19 12:20:00
>>> print(datetime.utcfromtimestamp(t)) # UTC时间
2015-04-19 04:20:00
```
#### 字符串转时间  
转换方法是通过datetime.strptime()实现，需要一个日期和时间的格式化字符串：
```python
>>> from datetime import datetime
>>> cday = datetime.strptime('2015-6-1 18:19:59', '%Y-%m-%d %H:%M:%S')
>>> print(cday)
2015-06-01 18:19:59
```
字符串`'%Y-%m-%d %H:%M:%S'`规定了日期和时间部分的格式   
#### 时间转字符串  
转换方法是通过strftime()实现的，同样需要一个日期和时间的格式化字符串：
```python
>>> from datetime import datetime
>>> now = datetime.now()
>>> print(now.strftime('%a, %b %d %H:%M'))
Mon, May 05 16:28
```
#### 时间的加减  
加减可以直接用+和-运算符，不过需要导入timedelta这个类：
```python
>>> from datetime import datetime, timedelta
>>> now = datetime.now()
>>> now
datetime.datetime(2015, 5, 18, 16, 57, 3, 540997)
>>> now + timedelta(hours=10)
datetime.datetime(2015, 5, 19, 2, 57, 3, 540997)
>>> now - timedelta(days=1)
datetime.datetime(2015, 5, 17, 16, 57, 3, 540997)
>>> now + timedelta(days=2, hours=12)
datetime.datetime(2015, 5, 21, 4, 57, 3, 540997)
```
#### 时区  
[廖雪峰-datetime](https://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001431937554888869fb52b812243dda6103214cd61d0c2000)  

### 日志模块 logging  
[参考](https://www.cnblogs.com/CJOKER/p/8295272.html)  
### 更多模块  
用到再添加吧  
可以查看 [廖雪峰教程](https://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/0014319347182373b696e637cc04430b8ee2d548ca1b36d000)  


## 补充  
### 深浅拷贝  
浅拷贝是对于一个对象的顶层拷贝  
正常的赋值就是浅拷贝，只是拷贝了引用地址，一个改变，所有的引用都要变  
```python
>>> a = [11, 12]
>>> b = a
>>> id(a) # 用来获取a指向的数据的内存地址  
31969928
>>> id(b) # 用来获取b指向的数据的内存地址
31969928
>>> a.append(15)
>>> a
[11, 12, 15]
>>> b
[11, 12, 15]
```
#### 使用copy进行copy  属于浅拷贝  
使用切片拷贝就相当于 copy.copy()
```python
>>> a = [11, 12]
>>> import copy
>>> b = copy.copy(a)
>>> c = a[:]
>>> id(a)
31970760
>>> id(b)
43237064
>>> id(c)
43237070
```
这个例子看着算是深拷贝，但是 copy 并不是真正的深拷贝  
下面这个例子可以看出，copy只是复制了顶层的对象进行了拷贝  
```python
>>> a = [11, 12]
>>> b = [33, 44]
>>> c = [a, b]
>>> id(a)
31969928
>>> id(b)
31970760
>>> id(c)
43237064
>>> import copy
>>> d = copy.copy(c)
>>> id(d)
43237128
>>> id(d[0])
31969928
>>> id(d[1])
31970760
>>> a.append(16)
>>> c.append(15)
>>> c
[[11, 12, 16], [33, 44], 15]
>>> d
[[11, 12, 16], [33, 44]]
```  

#### 深拷贝  deepcopy()  
深拷贝是对于一个对象所有层次的拷贝(递归)  

```python
>>> a = [11, 12]
>>> b = [33, 44]
>>> c = [a, b]
>>> id(a)
31969928
>>> id(b)
31970760
>>> id(c)
43237064
>>> import copy
>>> d = copy.deepcopy(c)
>>> id(d)
43237128
>>> id(d[0])
31969950
>>> id(d[1])
31970780
>>> a.append(16)
>>> c.append(15)
>>> c
[[11, 12, 16], [33, 44], 15]
>>> d
[[11, 12], [33, 44]]
```  

### 装饰器 decorator  

为了扩展函数/方法，而不去修改原来的函数  
本质上，decorator就是一个返回函数的高阶函数。所以，我们要定义一个能打印日志的decorator，可以定义如下：  
```python
def log(func):
    def wrapper(*args, **kw):
        print('call %s():' % func.__name__)
        return func(*args, **kw)
    return wrapper
```
借助Python的 `@` 语法，把decorator置于函数的定义处：
```python
@log
def now():
    print('2015-3-25')
```
调用now()函数，不仅会运行now()函数本身，还会在运行now()函数前打印一行日志：
```python
>>> now()
call now():
2015-3-25
```
把 `@log` 放到now()函数的定义处，相当于执行了语句：
```python
now = log(now)
```
如果decorator本身需要传入参数，那就需要编写一个返回decorator的高阶函数，写出来会更复杂。比如，要自定义log的文本：
```python
def log(text):
    def decorator(func):
        def wrapper(*args, **kw):
            print('%s %s():' % (text, func.__name__))
            return func(*args, **kw)
        return wrapper
    return decorator
```
这个3层嵌套的decorator用法如下：
```python
@log('execute')
def now():
    print('2015-3-25')
执行结果如下：

>>> now()
execute now():
2015-3-25
```
和两层嵌套的decorator相比，3层嵌套的效果是这样的：
```python
>>> now = log('execute')(now)
```
以上两种decorator的定义都没有问题，但还差最后一步。因为我们讲了函数也是对象，它有 `__name__` 等属性，但你去看经过decorator装饰之后的函数，它们的 `__name__` 已经从原来的'now'变成了'wrapper'：
```python
>>> now.__name__
'wrapper'
```
因为返回的那个wrapper()函数名字就是'wrapper'，所以，需要把原始函数的 `__name__` 等属性复制到wrapper()函数中，否则，有些依赖函数签名的代码执行就会出错。

不需要编写 `wrapper.__name__ = func.__name__` 这样的代码，Python内置的functools.wraps就是干这个事的，所以，一个完整的decorator的写法如下：
```python
import functools

def log(func):
    @functools.wraps(func)
    def wrapper(*args, **kw):
        print('call %s():' % func.__name__)
        return func(*args, **kw)
    return wrapper
```    
### 权举类 Enum  

当我们需要定义常量时，一个办法是用大写变量通过整数来定义，例如月份：
```python
JAN = 1
FEB = 2
MAR = 3
...
NOV = 11
DEC = 12
```
好处是简单，缺点是类型是int，并且仍然是变量。

更好的方法是为这样的枚举类型定义一个class类型，然后，每个常量都是class的一个唯一实例。Python提供了Enum类来实现这个功能：
```python
from enum import Enum

Month = Enum('Month', ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
```
这样我们就获得了Month类型的枚举类，可以直接使用Month.Jan来引用一个常量，或者枚举它的所有成员：
```python
for name, member in Month.__members__.items():
    print(name, '=>', member, ',', member.value)
```
value属性则是自动赋给成员的int常量，默认从1开始计数。

如果需要更精确地控制枚举类型，可以从Enum派生出自定义类：
```python
from enum import Enum, unique

@unique
class Weekday(Enum):
    Sun = 0 # Sun的value被设定为0
    Mon = 1
    Tue = 2
    Wed = 3
    Thu = 4
    Fri = 5
    Sat = 6
```
@unique装饰器可以帮助我们检查保证没有重复值。

访问这些枚举类型可以有若干种方法：
```python
>>> day1 = Weekday.Mon
>>> print(day1)
Weekday.Mon
>>> print(Weekday.Tue)
Weekday.Tue
>>> print(Weekday['Tue'])
Weekday.Tue
>>> print(Weekday.Tue.value)
2
>>> print(day1 == Weekday.Mon)
True
>>> print(day1 == Weekday.Tue)
False
>>> print(Weekday(1))
Weekday.Mon
>>> print(day1 == Weekday(1))
True
>>> Weekday(7)
Traceback (most recent call last):
  ...
ValueError: 7 is not a valid Weekday
>>> for name, member in Weekday.__members__.items():
...     print(name, '=>', member)
...
Sun => Weekday.Sun
Mon => Weekday.Mon
Tue => Weekday.Tue
Wed => Weekday.Wed
Thu => Weekday.Thu
Fri => Weekday.Fri
Sat => Weekday.Sat
```
### 动态创建类和元类 type   
[廖雪峰-使用元类](https://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/0014319106919344c4ef8b1e04c48778bb45796e0335839000)   

### 调试  
#### 断言 assert  
凡是用print()来辅助查看的地方，都可以用断言（assert）来替代：  
```python
def foo(s):
    n = int(s)
    assert n != 0, 'n is zero!'
    return 10 / n

def main():
    foo('0')
```
assert的意思是，表达式 `n != 0` 应该是 `True` ，否则，根据程序运行的逻辑，后面的代码肯定会出错。  

程序中如果到处充斥着assert，和print()相比也好不到哪去。不过，启动Python解释器时可以用 `-O` 参数来关闭assert：
```python
$ python -O err.py
Traceback (most recent call last):
  ...
ZeroDivisionError: division by zero
```
关闭后，你可以把所有的assert语句当成pass来看。

#### logging  
和assert比，logging不会抛出错误，而且可以输出到文件：  

```python
import logging
logging.basicConfig(level=logging.INFO)
s = '0'
n = int(s)
logging.info('n = %d' % n)
print(10 / n)
```
看到输出了：
```python
$ python err.py
INFO:root:n = 0  # 看这里
Traceback (most recent call last):
  File "err.py", line 8, in <module>
    print(10 / n)
ZeroDivisionError: division by zero
```

这就是logging的好处，它允许你指定记录信息的级别，有debug，info，warning，error等几个级别，当我们指定level=INFO时，logging.debug就不起作用了。同理，指定level=WARNING后，debug和info就不起作用了。这样一来，你可以放心地输出不同级别的信息，也不用删除，最后统一控制输出哪个级别的信息。

logging的另一个好处是通过简单的配置，一条语句可以同时输出到不同的地方，比如console和文件。  


#### 单元测试  
[廖雪峰-单元测试](https://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/00143191629979802b566644aa84656b50cd484ec4a7838000)  
#### 文档测试  
[廖雪峰-文档测试](https://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/0014319170285543a4d04751f8846908770660de849f285000)  

### StringIO和BytesIO  
很多时候，数据读写不一定是文件，也可以在内存中读写。

StringIO顾名思义就是在内存中读写str。

要把str写入StringIO，我们需要先创建一个StringIO，然后，像文件一样写入即可：
```python
>>> from io import StringIO
>>> f = StringIO()
>>> f.write('hello')
5
>>> f.write(' ')
1
>>> f.write('world!')
6
>>> print(f.getvalue())
hello world!
```
getvalue()方法用于获得写入后的str。

要读取StringIO，可以用一个str初始化StringIO，然后，像读文件一样读取：
```python
>>> from io import StringIO
>>> f = StringIO('Hello!\nHi!\nGoodbye!')
>>> while True:
...     s = f.readline()
...     if s == '':
...         break
...     print(s.strip())
...
Hello!
Hi!
Goodbye!
BytesIO
```
StringIO操作的只能是str，如果要操作二进制数据，就需要使用BytesIO。

BytesIO实现了在内存中读写bytes，我们创建一个BytesIO，然后写入一些bytes：
```python
>>> from io import BytesIO
>>> f = BytesIO()
>>> f.write('中文'.encode('utf-8'))
6
>>> print(f.getvalue())
b'\xe4\xb8\xad\xe6\x96\x87'
```
请注意，写入的不是str，而是经过UTF-8编码的bytes。

和StringIO类似，可以用一个bytes初始化BytesIO，然后，像读文件一样读取：
```python
>>> from io import BytesIO
>>> f = BytesIO(b'\xe4\xb8\xad\xe6\x96\x87')
>>> f.read()
b'\xe4\xb8\xad\xe6\x96\x87'
```

### 序列化  
我们把变量从内存中变成可存储或传输的过程称之为序列化，在Python中叫pickling  
Python提供了pickle模块来实现序列化。

首先，我们尝试把一个对象序列化并写入文件：
```python
>>> import pickle
>>> d = dict(name='Bob', age=20, score=88)
>>> pickle.dumps(d)
b'\x80\x03}q\x00(X\x03\x00\x00\x00ageq\x01K\x14X\x05\x00\x00\x00scoreq\x02KXX\x04\x00\x00\x00nameq\x03X\x03\x00\x00\x00Bobq\x04u.'
```
pickle.dumps()方法把任意对象序列化成一个bytes，然后，就可以把这个bytes写入文件。或者用另一个方法pickle.dump()直接把对象序列化后写入一个file-like Object：
```python
>>> f = open('dump.txt', 'wb')
>>> pickle.dump(d, f)
>>> f.close()
```
看看写入的dump.txt文件，一堆乱七八糟的内容，这些都是Python保存的对象内部信息。

当我们要把对象从磁盘读到内存时，可以先把内容读到一个bytes，然后用pickle.loads()方法反序列化出对象，也可以直接用pickle.load()方法从一个 `file-like Object` 中直接反序列化出对象。我们打开另一个Python命令行来反序列化刚才保存的对象：
```python
>>> f = open('dump.txt', 'rb')
>>> d = pickle.load(f)
>>> f.close()
>>> d
{'age': 20, 'score': 88, 'name': 'Bob'}
```
### json  
Python内置的json模块提供了非常完善的Python对象到JSON格式的转换。我们先看看如何把Python对象变成一个JSON：
```python
>>> import json
>>> d = dict(name='Bob', age=20, score=88)
>>> json.dumps(d)
'{"age": 20, "score": 88, "name": "Bob"}'
```
dumps()方法返回一个str，内容就是标准的JSON。类似的，dump()方法可以直接把JSON写入一个file-like Object。

要把JSON反序列化为Python对象，用loads()或者对应的load()方法，前者把JSON的字符串反序列化，后者从 `file-like Object` 中读取字符串并反序列化：
```python
>>> json_str = '{"age": 20, "score": 88, "name": "Bob"}'
>>> json.loads(json_str)
{'age': 20, 'score': 88, 'name': 'Bob'}
```
把对象json化只需要将class的实例变为dict：
```python
# s 是Student的实例对象
print(json.dumps(s, default=lambda obj: obj.__dict__))
```
因为通常class的实例都有一个`__dict__`属性，它就是一个dict，用来存储实例变量。

如果我们要把JSON反序列化为一个Student对象实例，loads()方法首先转换出一个dict对象，然后，我们传入的object_hook函数负责把dict转换为Student实例：
```python
def dict2student(d):
    return Student(d['name'], d['age'], d['score'])
```
运行结果如下：
```python
>>> json_str = '{"age": 20, "score": 88, "name": "Bob"}'
>>> print(json.loads(json_str, object_hook=dict2student))
<__main__.Student object at 0x10cd3c190>
```
打印出的是反序列化的Student实例对象。

### with与上下文管理器  
#### with 优雅关闭资源  
系统资源如文件、数据库连接、socket 而言，应用程序打开这些资源并执行完业务逻辑之后，必须做的一件事就是要关闭（断开）该资源。

为了保证资源的关闭，代码通常是这样写的  
```python
def m2():
    f = open("output.txt", "w")
    try:
        f.write("python之禅")
    except IOError:
        print("oops error")
    finally:
        f.close()
```
使用with方式  
```python
def m3():
    with open("output.txt", "r") as f:
        f.write("Python之禅")
```

一种更加简洁、优雅的方式就是用 with 关键字。open 方法的返回值赋值给变量 f，当离开 with 代码块的时候，系统会自动调用 f.close() 方法， with 的作用和使用 try/finally 语句是一样的。那么它的实现原理是什么？在讲 with 的原理前要涉及到另外一个概念，就是上下文管理器（Context Manager）。

#### 上下文管理器  
任何实现了 `__enter__()` 和 `__exit__()` 方法的对象都可称之为上下文管理器，上下文管理器对象可以使用 with 关键字。显然，文件（file）对象也实现了上下文管理器。

那么文件对象是如何实现这两个方法的呢？我们可以模拟实现一个自己的文件类，让该类实现 `__enter__()` 和 `__exit__()` 方法。
```python
class File():

    def __init__(self, filename, mode):
        self.filename = filename
        self.mode = mode

    def __enter__(self):
        print("entering")
        self.f = open(self.filename, self.mode)
        return self.f

    def __exit__(self, *args):
        print("will exit")
        self.f.close()
```
`__enter__()` 方法返回资源对象，这里就是你将要打开的那个文件对象，`__exit__()` 方法处理一些清除工作。

因为 File 类实现了上下文管理器，现在就可以使用 with 语句了。
```python
with File('out.txt', 'w') as f:
    print("writing")
    f.write('hello, python')
```
这样，你就无需显示地调用 close 方法了，由系统自动去调用，哪怕中间遇到异常 close 方法也会被调用。  

#### 实现上下文管理器的另外方式  
Python 还提供了一个 contextmanager 的装饰器，更进一步简化了上下文管理器的实现方式。通过 yield 将函数分割成两部分，yield 之前的语句在 `__enter__` 方法中执行，yield 之后的语句在 `__exit__` 方法中执行。紧跟在 yield 后面的值是函数的返回值。
```python
from contextlib import contextmanager

@contextmanager
def my_open(path, mode):
    f = open(path, mode)
    yield f
    f.close()
调用

with my_open('out.txt', 'w') as f:
    f.write("hello , the simplest context manager")
```
