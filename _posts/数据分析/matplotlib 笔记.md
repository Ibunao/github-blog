---
title: matplotlib 基础
date: 2019-04-15 11:56:02
tags:
    - matplotlib  
categories:   
    - 数据分析  
    - matplotlib  
---


## 基础设置  


```python
# 引入
from matplotlib import pyplot as plt
```

### 示例

![](/images/shuju/Python_Figure_Structure.png)

<!-- more -->
```python
# 获取x轴的点，需要是可迭代对象
x = range(2, 26, 2)
# 获取y轴的点，需要是可迭代对象
y = [15, 13, 14.5, 17, 20, 25, 26, 26, 24, 22, 18, 15]
# 通过plot绘制折线图， x 和 y 是对应的关系，也就是长度要一样 
plt.plot(x, y)
# 展示图形
plt.show()
```


![png](/images/shuju/output_4_0.png)


### 设置图片大小、质量


```python
# 画图之前设置图片信息  figsize 设置图片的大小； dpi 设置图片的质量，让图片更清晰
fig = plt.figure(figsize=(6, 4), dpi= 80)
x = range(2, 26, 2)
y = [15, 13, 14.5, 17, 20, 25, 26, 26, 24, 22, 18, 15]
plt.plot(x, y)
plt.show()
```


![png](/images/shuju/output_6_0.png)


### 下载图片  


```python
# 画图之前设置图片信息  figsize 设置图片的大小； dpi 设置图片的质量，让图片更清晰
fig = plt.figure(figsize=(6, 4), dpi= 80)
x = range(2, 26, 2)
y = [15, 13, 14.5, 17, 20, 25, 26, 26, 24, 22, 18, 15]
plt.plot(x, y)
# 保存图片，可以根据后缀名来指定保存的格式
plt.savefig('savefig.png')
```


![png](/images/shuju/output_8_0.png)


### 调整 X 或者 Y 轴上的刻度和显示内容

虽然指定了 x 轴和 y 轴对应点的关系，但是 x 轴和 y 轴的刻度并没有指定，如果默认的刻度不满足需求，我们可以进行更改 


```python
# 画图之前设置图片信息  figsize 设置图片的大小； dpi 设置图片的质量，让图片更清晰
fig = plt.figure(figsize=(6, 4), dpi= 80)
x = range(2, 26, 2)
y = [15, 13, 14.5, 17, 20, 25, 26, 26, 24, 22, 18, 15]
plt.plot(x, y)
# 指定x轴的刻度值
# plt.xticks(x)
# 可以调整刻度的稀疏
plt.xticks(x[::2])
# 保存图片，可以根据后缀名来指定保存的格式
plt.show()
```


![png](/images/shuju/output_11_0.png)


#### 设置 x、y 轴刻度的别名、刻度方向

那么问题来了:  
       如果列表a表示10点到12点的每一分钟的气温,如何绘制折线图观察每分钟气温的变化情况?  
       `a= [random.randint(20,35) for i in range(120)]`



```python
import random
fig = plt.figure(figsize = (28, 8))
y = [random.randint(20,35) for i in range(120)]
x = range(120)
plt.plot(x, y)
# 生成x坐标对应的别名
_x_ticks = ['10点{}分'.format(i) for i in x if i < 60]
_x_ticks += ['11点{}分'.format(i) for i in x if i > 60]
# 前两个参数要一一对应，表示刻度和别名的对应关系
# rotation参数表示刻度显示旋转的方向
# plt.xticks(x, _x_ticks, rotation = 45)
plt.xticks(x[::5], _x_ticks[::5], rotation = 45)
plt.show()
```


![png](/images/shuju/output_14_0.png)


### 设置显示中文

`matplotlib` 默认不支持中文字符，因为默认的英文字体无法显示汉字
查看 `linux/mac` 下面支持的字体:  
`fc-list`   查看支持的字体  
`fc-list :lang=zh` 查看支持的中文(冒号前面有空格)  

> mac 下如果不支持该命令，需要安装 `brew install fontconfig`  


那么问题来了:如何修改 `matplotlib` 的默认字体?
1. 通过 `matplotlib.rc` 可以修改,具体方法参见源码( `windows/linux` 平台下可行)
2. 通过 `matplotlib` 下的 `font_manager` 可以解决( `windows/linux/mac` 平台下可行)



```python
import random  
import matplotlib
from matplotlib import font_manager  
# 全局的字体设置(没实验成功，没找到字体名)
# font = {
#     'family': "Microsoft Yahei",
#     'size': "10"
# }
# matplotlib.rc('font', **font)


fig = plt.figure(figsize = (28, 8))
y = [random.randint(20,35) for i in range(120)]
x = range(120)
plt.plot(x, y)
_x_ticks = ['10点{}分'.format(i) for i in x if i < 60]
_x_ticks += ['11点{}分'.format(i) for i in x if i > 60]

# 指定字体路径，然后在需要显示中文的地方添加 fontproperties 参数  
my_font = font_manager.FontProperties(fname='/System/Library/Fonts/Pingfang.ttc')
plt.xticks(x[::5], _x_ticks[::5], rotation = 45, fontproperties = my_font)

plt.show()
```


![png](/images/shuju/output_17_0.png)


### 给图像添加描述信息  

#### 设置图的 title 和轴的 label，显示网格


```python
fig = plt.figure(figsize = (28, 8))
y = [random.randint(20,35) for i in range(120)]
x = range(120)
plt.plot(x, y)
_x_ticks = ['10点{}分'.format(i) for i in x if i < 60]
_x_ticks += ['11点{}分'.format(i) for i in x if i > 60]

# 指定字体路径，然后在需要显示中文的地方添加 fontproperties 参数  
my_font = font_manager.FontProperties(fname='/System/Library/Fonts/Pingfang.ttc')
plt.xticks(x[::5], _x_ticks[::5], rotation = 45, fontproperties = my_font)

# 设置x、y轴的label
plt.xlabel('时间', fontproperties = my_font)
plt.ylabel('温度', fontproperties = my_font)
# 设置图的标题
plt.title('10-11点的温度记录', fontproperties = my_font)
# 显示网格
plt.grid(alpha = 0.4)
plt.show()
```


![png](/images/shuju/output_20_0.png)


#### 设置线条样式和图例位置

线条样式参数值  

| 颜色字符(color) | 风格字符(linestyle) | 点样式(marker) |
| :------------- | :------------- | :------------- |
| `r`红色 | `-` or `solid` 实线 | `.` point |
| `g`绿色 | `--` or `dashed` 虚线 | `,` pixel |
| `g`蓝色 | `-.` or `dashdot` 点划线 | `o` circle |
| `w`白色 | `:` or `dotted` 点虚线 | `v` triangle_down |
| `c`青色 | ` `空或者空格，无线条 | `^` triangle_up |
| `m`洋红 |  | `<` triangle_left |
| `y`黄色 |  |  |
| `k`黑色 |  |  |
| `#00ff00`16进制 |  |  |


```python
a = [1,0,1,1,2,4,3,2,3,4,4,5,6,5,4,3,3,1,1,1]
b = [1,0,3,1,2,2,3,3,2,1 ,2,1,1,1,1,1,1,1,1,1]
x = range(20)
# 绘制两条线  
# label 线条数名; color 设置字体颜色； linestyle 设置线条样式； linewidth 设置线条宽度； alpha 设置线条透明度
plt.plot(x, a, label='线1', color='r', linestyle='--', linewidth=5, alpha=0.5)
plt.plot(x, b, label='线2')
my_font = font_manager.FontProperties(fname='/System/Library/Fonts/Pingfang.ttc')
# 显示图例 prop 指定文字类型， loc 指定显示位置
plt.legend(prop = my_font, loc = 'best')

plt.show()
```


![png](/images/shuju/output_23_0.png)


### 添加注解


```python
# text添加文字注解
from numpy import random
random.seed(10)
plt.plot(random.randn(30).cumsum(), 'ko--')
# 添加注解
plt.text(5, 2, 'hello', family='monospace', fontsize = 10)
```




    Text(5, 2, 'hello')




![png](/images/shuju/output_25_1.png)



```python
# annotate 添加注解
from numpy import random
random.seed(10)
plt.plot(random.randn(30).cumsum(), 'ko--')
# 添加注解
plt.annotate('jinrong', 
             xy=(6, 2), # 指向的点
             xytext=(6, 6), # 文字位置
             arrowprops=dict(facecolor='green', headwidth=6, headlength=6, width=2),# 设置箭头 颜色 头的宽度 头的高度 线宽
             horizontalalignment='right', # 文字在箭头的左侧还是右侧
             verticalalignment='top' # 文字在箭头的顶部还是底部
            )
```




    Text(6, 6, 'jinrong')




![png](/images/shuju/output_26_1.png)


## 折线图plot  

上面的都是以折线图为例子的，看下就OK


```python
from numpy.random import randn
data = randn(30).cumsum()
# plt.plot(randn(30).cumsum(), 'ko--')
# 扩展开就是下面这种形式 marker 绘制点
plt.plot(data, color='k', linestyle='dashed', marker='o')
# 在线型图中，非实际数据点默认是按线性方式插值的。可以通过drawstyle选项修改
plt.plot(data, 'k-', drawstyle='steps-post')
# 返回当前的X轴绘图范围
print(plt.xlim())
# 设置x轴绘制范围
plt.xlim([0, 50])
```

    (-1.4500000000000002, 30.45)





    (0, 50)




![png](/images/shuju/output_29_2.png)


## 散点图scatter

散点图和折线图的用法相似，基本把plot改成scatter方法  


```python
# 假设下面是3,10月份每天白天的最高气温
y_a = [11,17,16,11,12,11,12,6,6,7,8,9,12,15,14,17,18,21,16,17,20,14,15,15,15,19,21,22,22,22,23]
y_b = [26,26,28,19,21,17,16,19,18,20,20,19,22,23,17,20,21,20,22,15,11,15,5,13,17,10,11,13,12,13,6]

fig = plt.figure(figsize = (28, 8))
# 分别获取a、b对应的x的坐标
x_a = range(1, 32)
x_b = range(51, 82)

# 绘制散点图
plt.scatter(x_a, y_a)
plt.scatter(x_b, y_b)

_x_ticks = ['3月{}日'.format(i) for i in x_a]
_x_ticks += ['10月{}日'.format(i - 50) for i in x_b]

# 指定字体路径，然后在需要显示中文的地方添加 fontproperties 参数  
my_font = font_manager.FontProperties(fname='/System/Library/Fonts/Pingfang.ttc')
plt.xticks(list(x_a) + list(x_b), _x_ticks, rotation = 45, fontproperties = my_font)

# 设置x、y轴的label
plt.xlabel('时间', fontproperties = my_font)
plt.ylabel('温度', fontproperties = my_font)
# 设置图的标题
plt.title('3月、10月的温度记录', fontproperties = my_font)

plt.show()


```


![png](/images/shuju/output_32_0.png)


## 条形图bar(竖着的)、barh(横着的)


```python
fig = plt.figure(figsize = (28, 8))
# 指定字体路径，然后在需要显示中文的地方添加 fontproperties 参数  
my_font = font_manager.FontProperties(fname='/System/Library/Fonts/Pingfang.ttc')

a = ["战狼2","速度与激情8","功夫瑜伽","西游伏妖篇","变形金刚5：最后的骑士","摔跤吧！爸爸","加勒比海盗5：死无对证","金刚：骷髅岛","极限特工：终极回归","生化危机6：终章","乘风破浪","神偷奶爸3","智取威虎山","大闹天竺","金刚狼3：殊死一战","蜘蛛侠：英雄归来","悟空传","银河护卫队2","情圣","新木乃伊",]

b = [56.01,26.94,17.53,16.49,15.45,12.96,11.8,11.61,11.28,11.12,10.49,10.3,8.75,7.55,7.32,6.99,6.88,6.86,6.58,6.23] 

# 画竖着的条形图 width 设置条形的宽度  
# plt.bar(range(len(a)), b, width = 0.6)
# 设置x轴别名
# plt.xticks(range(len(a)), a, rotation = 45, fontproperties = my_font)

# 画横着的条形图 height 设置条形的宽度
plt.barh(range(len(a)), b, height = 0.6)
# 设置y轴别名
plt.yticks(range(len(a)), a, rotation = 45, fontproperties = my_font)

# 设置x、y轴的label
plt.xlabel('电影名称', fontproperties = my_font)
plt.ylabel('票房：亿', fontproperties = my_font)
# 设置图的标题
plt.title('票房记录', fontproperties = my_font)
plt.show()

```


![png](/images/shuju/output_34_0.png)


### 多次条形图

假设你知道了列表a中电影分别在2017-09-14(b_14), 2017-09-15(b_15), 2017-09-16(b_16)三天的票房,为了展示列表中电影本身的票房以及同其他电影的数据对比情况,应该如何更加直观的呈现该数据?



```python
fig = plt.figure(figsize = (28, 8))
# 指定字体路径，然后在需要显示中文的地方添加 fontproperties 参数  
my_font = font_manager.FontProperties(fname='/System/Library/Fonts/Pingfang.ttc')

a = ["猩球崛起3：终极之战","敦刻尔克","蜘蛛侠：英雄归来","战狼2"]
b_16 = [15746,312,4497,319]
b_15 = [12357,156,2045,168]
b_14 = [2358,399,2358,362]

# 多个条形图根据条形图的宽度错开
bar_width = 0.2
x_14 = range(len(a))
x_15 = [i + bar_width for i in x_14]
x_16 = [i + bar_width * 2 for i in x_14]

# 画竖着的条形图 width 设置条形的宽度  
plt.bar(x_14, b_14, width = bar_width, label = '2017-09-14日')
plt.bar(x_15, b_15, width = bar_width, label = '2017-09-15日')
plt.bar(x_16, b_16, width = bar_width, label = '2017-09-16日')
# 设置图例
plt.legend(prop = my_font)

# 设置x轴别名
plt.xticks(x_15, a, rotation = 45, fontproperties = my_font)

# 设置x、y轴的label
plt.xlabel('电影名称', fontproperties = my_font)
plt.ylabel('票房：亿', fontproperties = my_font)
# 设置图的标题
plt.title('票房记录', fontproperties = my_font)
plt.show()
```


![png](/images/shuju/output_37_0.png)


## 直方图hist  


```python
fig = plt.figure(figsize = (28, 8))
# 指定字体路径，然后在需要显示中文的地方添加 fontproperties 参数  
my_font = font_manager.FontProperties(fname='/System/Library/Fonts/Pingfang.ttc')

a=[131,  98, 125, 131, 124, 139, 131, 117, 128, 108, 135, 138, 131, 102, 107, 114, 119, 128, 121, 142, 127, 130, 124, 101, 110, 116, 117, 110, 128, 128, 115,  99, 136, 126, 134,  95, 138, 117, 111,78, 132, 124, 113, 150, 110, 117,  86,  95, 144, 105, 126, 130,126, 130, 126, 116, 123, 106, 112, 138, 123,  86, 101,  99, 136,123, 117, 119, 105, 137, 123, 128, 125, 104, 109, 134, 125, 127,105, 120, 107, 129, 116, 108, 132, 103, 136, 118, 102, 120, 114,105, 115, 132, 145, 119, 121, 112, 139, 125, 138, 109, 132, 134,156, 106, 117, 127, 144, 139, 139, 119, 140,  83, 110, 102,123,107, 143, 115, 136, 118, 139, 123, 112, 118, 125, 109, 119, 133,112, 114, 122, 109, 106, 123, 116, 131, 127, 115, 118, 112, 135,115, 146, 137, 116, 103, 144,  83, 123, 111, 110, 111, 100, 154,136, 100, 118, 119, 133, 134, 106, 129, 126, 110, 111, 109, 141,120, 117, 106, 149, 122, 122, 110, 118, 127, 121, 114, 125, 126,114, 140, 103, 130, 141, 117, 106, 114, 121, 114, 133, 137,  92,121, 112, 146,  97, 137, 105,  98, 117, 112,  81,  97, 139, 113,134, 106, 144, 110, 137, 137, 111, 104, 117, 100, 111, 101, 110,105, 129, 137, 112, 120, 113, 133, 112,  83,  94, 146, 133, 101,131, 116, 111,  84, 137, 115, 122, 106, 144, 109, 123, 116, 111,111, 133, 150]

# 设置组距,这个要求有点高，设置不好图形会偏(要能被max(a) - min(a)整除)
bin_width = 6 
# 计算组数  
num_bins = int((max(a) - min(a))//bin_width)
print(num_bins, max(a), min(a), max(a) - min(a))
# 绘制直方图，传入数据和组数即可
plt.hist(a, num_bins)
# 默认绘制的是频数，density = 1 设置成频数
# plt.hist(a, num_bins, density = 1)
# 也可以通过列表来指定各个组距，通常在组距不均匀的时候使用，长度为组数，值为分组依据
# plt.hist(a, [min(a) + i * bin_width for i in range(num_bins)])

plt.xticks(list(range(min(a), max(a)))[::bin_width], rotation = 45)
plt.grid()
plt.show()


```

    13 156 78 78



![png](/images/shuju/output_39_1.png)


## 一页创建多张图 subplot


```python
import matplotlib.pyplot as plt
import numpy as np
fig = plt.figure()
# 图像应该是2×2的（即最多4张图），且当前选中的是4个subplot中的第一个（编号从1开始）
ax1 = fig.add_subplot(2, 2, 1)
ax2 = fig.add_subplot(2, 2, 2)
ax3 = fig.add_subplot(2, 2, 3)
# 直方图
ax1.hist(np.random.randn(100), bins=20, color='k', alpha=0.3)
# 散点图
ax2.scatter(np.arange(30), np.arange(30) + 3 * np.random.randn(30))
# 在第三张上画图，  k-- 表示黑色虚线 k表示黑色 -- 表示虚线
ax3.plot(np.random.randn(50).cumsum(), 'k--')

```




    [<matplotlib.lines.Line2D at 0x8444080>]




![png](/images/shuju/output_41_1.png)



```python
# 快速创建一图多张表 figsize 是figure的参数
# fig是figure对象 axes 是各个图表列表
fig, axes = plt.subplots(2, 3, figsize=(18, 6))
print(axes)
# subplots_adjues 调整个图表之间的间距
plt.subplots_adjust(wspace=0, hspace=0)
```

    [[<matplotlib.axes._subplots.AxesSubplot object at 0x000000000907BB70>
      <matplotlib.axes._subplots.AxesSubplot object at 0x00000000090A4C50>
      <matplotlib.axes._subplots.AxesSubplot object at 0x00000000090D4208>]
     [<matplotlib.axes._subplots.AxesSubplot object at 0x00000000090F9780>
      <matplotlib.axes._subplots.AxesSubplot object at 0x00000000095A2CF8>
      <matplotlib.axes._subplots.AxesSubplot object at 0x00000000095D32B0>]]



![png](/images/shuju/output_42_1.png)


## 实战

### 1. 导入包


```python
import numpy as np
import matplotlib.pyplot as plt
```

### 2. 准备数据


```python
# 定义数据部分
x = np.arange(0., 10, 0.2)
y1 = np.cos(x)
y2 = np.sin(x)
y3 = np.sqrt(x)
```

### 3. 绘制基本曲线


```python
# 使用 plot 函数直接绘制上述函数曲线，可以通过配置 plot 函数参数调整曲线的样式、粗细、颜色、标记等：
# 绘制 3 条函数曲线
plt.plot(x, y1, color='blue', linewidth=1.5, linestyle='-', marker='.', label=r'$y = cos{x}$')
plt.plot(x, y2, color='green', linewidth=1.5, linestyle='-', marker='*', label=r'$y = sin{x}$')
plt.plot(x, y3, color='m', linewidth=1.5, linestyle='-', marker='x', label=r'$y = \sqrt{x}$')
```




    [<matplotlib.lines.Line2D at 0x8315b00>]




![png](/images/shuju/output_49_1.png)


### 4. 设置坐标轴


```python
# 坐标轴上移
ax = plt.subplot(111)
# 去掉右边的边框线
ax.spines['right'].set_color('none')     
# 去掉上边的边框线
ax.spines['top'].set_color('none')  

# 移动下边边框线，相当于移动 X 轴
ax.xaxis.set_ticks_position('bottom')    
# 下边框线移动到 y=0 的位置
ax.spines['bottom'].set_position(('data', 0))

# 移动左边边框线，相当于移动 y 轴
ax.yaxis.set_ticks_position('left')
# 左边框线移动到 x=0 的位置
ax.spines['left'].set_position(('data', 0))
```


![png](/images/shuju/output_51_0.png)



```python
# 设置 x, y 轴的刻度取值范围
plt.xlim(x.min()*1.1, x.max()*1.1)
plt.ylim(-1.5, 4.0)
# 设置 x, y 轴的刻度标签值
plt.xticks([2, 4, 6, 8, 10], [r'2.0', r'4', r'6', r'8', r'10'])
plt.yticks([-1.0, 0.0, 1.0, 2.0, 3.0, 4.0],
    [r'-1.00', r'0.00', r'1.00', r'2.00', r'3.00', r'4.00'])
```




    ([<matplotlib.axis.YTick at 0x7f3fb00>,
      <matplotlib.axis.YTick at 0x7f3f438>,
      <matplotlib.axis.YTick at 0x7f5b438>,
      <matplotlib.axis.YTick at 0x8103940>,
      <matplotlib.axis.YTick at 0x8103e48>,
      <matplotlib.axis.YTick at 0x8109390>],
     <a list of 6 Text yticklabel objects>)




![png](/images/shuju/output_52_1.png)



```python
# 设置标题、x轴、y轴
plt.title(r'$the \ function \ figure \ of \ cos(), \ sin() \ and \ sqrt()$', fontsize=19)
plt.xlabel(r'$the \ input \ value \ of \ x$', fontsize=18, labelpad=88.8)
plt.ylabel(r'$y = f(x)$', fontsize=18, labelpad=12.5)
```




    Text(0, 0.5, '$y = f(x)$')




![png](/images/shuju/output_53_1.png)


### 5. 设置文字描述、注解


```python
plt.text(4, 1.68, r'$x \in [0.0, \ 10.0]$', color='k', fontsize=15)
plt.text(4, 1.38, r'$y \in [-1.0, \ 4.0]$', color='k', fontsize=15)
```




    Text(4, 1.38, '$y \\in [-1.0, \\ 4.0]$')




![png](/images/shuju/output_55_1.png)



```python
# 特殊点添加注解
# 使用散点图放大当前点
plt.scatter([8,],[np.sqrt(8),], 50, color ='m')
plt.annotate(r'$2\sqrt{2}$', xy=(8, np.sqrt(8)), xytext=(8.5, 2.2), fontsize=16, color='#090909', arrowprops=dict(arrowstyle='->', connectionstyle='arc3, rad=0.1', color='#090909'))
```




    Text(8.5, 2.2, '$2\\sqrt{2}$')




![png](/images/shuju/output_56_1.png)


### 6. 设置图例


```python
plt.legend(['cos(x)', 'sin(x)', 'sqrt(x)'], loc='upper right')
```




    <matplotlib.legend.Legend at 0x9495c88>




![png](/images/shuju/output_58_1.png)


### 7. 网格线开关


```python
# 显示网格线
plt.grid(True)
```


![png](/images/shuju/output_60_0.png)


### 8. 显示


```python
# 显示
plt.show()
```

### 完整的绘制程序


```python
import numpy as np
import matplotlib.pyplot as plt

# 定义数据部分
x = np.arange(0., 10, 0.2)
y1 = np.cos(x)
y2 = np.sin(x)
y3 = np.sqrt(x)

# 绘制 3 条函数曲线
plt.plot(x, y1, color='blue', linewidth=1.5, linestyle='-', marker='.', label=r'$y = cos{x}$')
plt.plot(x, y2, color='green', linewidth=1.5, linestyle='-', marker='*', label=r'$y = sin{x}$')
plt.plot(x, y3, color='m', linewidth=1.5, linestyle='-', marker='x', label=r'$y = \sqrt{x}$')

# 坐标轴上移
ax = plt.subplot(111)
ax.spines['right'].set_color('none')     # 去掉右边的边框线
ax.spines['top'].set_color('none')       # 去掉上边的边框线

# 移动下边边框线，相当于移动 X 轴
ax.xaxis.set_ticks_position('bottom')    
# 下边框线移动到 y=0 的位置
ax.spines['bottom'].set_position(('data', 0))

# 移动左边边框线，相当于移动 y 轴
ax.yaxis.set_ticks_position('left')
# 左边框线移动到 x=0 的位置
ax.spines['left'].set_position(('data', 0))

# 设置 x, y 轴的取值范围
plt.xlim(x.min()*1.1, x.max()*1.1)
plt.ylim(-1.5, 4.0)

# 设置 x, y 轴的刻度值
plt.xticks([2, 4, 6, 8, 10], [r'2', r'4', r'6', r'8', r'10'])
plt.yticks([-1.0, 0.0, 1.0, 2.0, 3.0, 4.0], 
    [r'-1.0', r'0.0', r'1.0', r'2.0', r'3.0', r'4.0'])

# 添加文字
plt.text(4, 1.68, r'$x \in [0.0, \ 10.0]$', color='k', fontsize=15)
plt.text(4, 1.38, r'$y \in [-1.0, \ 4.0]$', color='k', fontsize=15)

# 特殊点添加注解
plt.scatter([8,],[np.sqrt(8),], 50, color ='m')  # 使用散点图放大当前点
plt.annotate(r'$2\sqrt{2}$', xy=(8, np.sqrt(8)), xytext=(8.5, 2.2), fontsize=16, color='#090909', arrowprops=dict(arrowstyle='->', connectionstyle='arc3, rad=0.1', color='#090909'))

# 设置标题、x轴、y轴
plt.title(r'$the \ function \ figure \ of \ cos(), \ sin() \ and \ sqrt()$', fontsize=19)
plt.xlabel(r'$the \ input \ value \ of \ x$', fontsize=18, labelpad=88.8)
plt.ylabel(r'$y = f(x)$', fontsize=18, labelpad=12.5)

# 设置图例及位置
plt.legend(loc='up right')    
# plt.legend(['cos(x)', 'sin(x)', 'sqrt(x)'], loc='up right')

# 显示网格线
plt.grid(True)    

# 显示绘图
plt.show()
```


![png](/images/shuju/output_64_0.png)


## 参考

[官方案例](https://matplotlib.org/gallery/index.html)


```python

```
