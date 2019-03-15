---
title: 爬虫-scrapy  
date: 2018-10-23 20:00:02
tags:
    - python
    - scrapy
    - 爬虫
categories:
    - python
    - 爬虫  
---

## 实现项目    
### 创建项目  
```python
scrapy startproject cancao # 将会创建cankao项目目录及文件  

└── cankao
    ├── cankao
    │   ├── __init__.py
    │   ├── items.py
    │   ├── middlewares.py
    │   ├── pipelines.py
    │   ├── settings.py
    │   └── spiders
    │       └── __init__.py
    └── scrapy.cfg

scrapy.cfg # 项目的部署文件
cankao/ # 项目的Python模块，将会从这里引用代码
cankao/items.py # 项目的Item文件
cankao/pipelines.py # 项目的管道文件用于文件持久化
cankao/settings.py # 项目的配置文件
cankao/middlewares.py # 中间件
cankao/spiders/ # 存储爬虫代码目录

```
#### 创建爬虫  
```python
# 进入到项目目录
cd cankao
# 创建爬虫的命令 爬虫名称 限制的域名
scrapy genspider cankao1 douban.com

# spiders文件夹下生成cankao1.py文件
# -*- coding: utf-8 -*-
import scrapy


class Cankao1Spider(scrapy.Spider):
    # 爬虫名，必填
    name = 'cankao1'
    # 允许访问的域名
    allowed_domains = ['douban.com']
    # 开始的url
    start_urls = ['http://douban.com/']

    def parse(self, response):
        '''
        解析
        :param response:
        :return:
        '''
        pass
```
<!--more-->
我们对网页进行分析获取需要的内容  
```python
# -*- coding: utf-8 -*-
import scrapy
from scrapy.http.request import Request

class Cankao1Spider(scrapy.Spider):
    '''
    爬取豆瓣图书图片，单层爬虫
    '''
    # 爬虫名，必填
    name = 'cankao1'
    # 允许访问的域名，只允许访问这个域名下的url
    allowed_domains = ['douban.com']
    # 开始的url
    start_urls = ['https://book.douban.com/']
    # 自定义配置，会覆盖项目配置
    custom_settings = {}

    # def start_requests(self):
    #     '''
    #     重写父类的方法，父类的方法默认从start_urls中读取开始爬取
    #     一般不需要重写，但是如果第一步就是登陆的话就需要重写了
    #     :return:
    #     '''

    def parse(self, response):
        '''
        解析
        :param response:
        :return:
        '''
        # 打印响应体
        # print(response.body)
        papers = response.xpath('//*[@id="content"]/div/div[1]/div[1]/div[2]/div/div/ul[2]/li')
        # print(papers)
        for paper in papers:
            url = paper.xpath('.//div/a/@href').extract_first()
            img = paper.xpath('.//div/a/img/@src').extract_first()
            content = paper.xpath('.//div/div/a/text()').extract_first()
            print(url, img, content)


        # time.sleep(5000)
        # 分析下一个请求,进行请求（测试一下allowed_domains，不属于不能请求）
        # yield Request(url='http://www.bunao.win')
```  
#### 执行爬虫  
执行爬虫命令 `scrapy crawl cankao1` ，执行后可以看到输出的执行信息，方便进行分析  
此时可能并没有输出所期望的数据，我们需要修改配置参数  
```python
settings.py 文件  

#  客户端 user-agent请求头
USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36'

# 是否遵守robot协议
ROBOTSTXT_OBEY = False
```
此时，我们执行 `scrapy crawl cankao1 --nolog` 来查看不带执行信息的输入内容  

### 创建item  
创建 `item` 就比较简单了，主要是用来存放保存信息的  
```python
import scrapy

class CankaoItem(scrapy.Item):
    '''
    定义要保存的字段
    '''
    # define the fields for your item here like:
    url = scrapy.Field()
    img = scrapy.Field()
    content = scrapy.Field()
```
### 创建 pipeline , 存储数据   
#### 数据保存到文件  
```python
import json
from scrapy.exceptions import DropItem

class CankaoPipeline(object):
    '''
    保存到文件中
    '''
    def __init__(self):
        self.file = open('./download/papers.json', 'wb')

    # def open_spider(self, spider):
    #     '''
    #     spider是一个Spider对象，代表开启的Spider，当spider被开启时，调用这个方法
    #     数据库/文件的开启可以放在这里
    #     :param spider:
    #     :return:
    #     '''
    #     pass

    def process_item(self, item, spider):
        '''
        处理item，进行保存
        :param item:
        :param spider:
        :return:
        '''
        print(item['img'])
        if item['img']:
            line = json.dumps(dict(item)) + '\n'
            # 要转成字节类型，写入文件
            self.file.write(line.encode())
            # 给下一个pipline处理
            return item
        else:
            # 丢弃，后面的pipline也无法处理了
            raise DropItem('miss img in %s' % item)

    def close_spider(self, spider):
        '''
        spider被关闭的时候调用
        可以放置数据库/文件关闭的代码
        :param spider:
        :return:
        '''
        # pass
        self.file.close()
        print('pipine open file times %s' % 5)

    # @classmethod
    # def from_crawler(cls, crawler):
    #     '''
    #     类方法，用来创建pipeline实例，可以通过crawler来获取scarpy所有的核心组件，如配置
    #     :param crawler:
    #     :return:
    #     '''
    #     pass
```
配置  
写好的 pipelines 需要配置激活  
```python
settings.py

# 激活pipline，从低到高开始执行
ITEM_PIPELINES = {
   'cankao.pipelines.CankaoPipeline': 300,
}
```
#### 数据保存到mongo  
```python
from pymongo import MongoClient

class CankaoMongoPipeline(object):
    '''
    以mongo存储为例
    '''
    # 集合名
    collection_name = 'scrapy_items'

    def __init__(self, mongo_uri, mongo_port, mongo_db):
        self.mongo_uri = mongo_uri
        self.mongo_port = mongo_port
        self.mongo_db = mongo_db

    @classmethod
    def from_crawler(cls, crawler):
        '''
        类方法，用来创建pipeline实例，可以通过crawler来获取scarpy所有的核心组件，如配置
        :param crawler:
        :return:
        '''
        return cls(
            # 获取mongo连接
            mongo_uri = crawler.settings.get('MONGO_URI'),
            # 获取mongo连接
            mongo_port = crawler.settings.get('MONGO_PORT'),
            # 获取数据库，如果没有则用默认的item
            mongo_db = crawler.settings.get('MONGO_DATABASE', 'fecshop_test')
        )

    def open_spider(self, spider):
        '''
        spider是一个Spider对象，代表开启的Spider，当spider被开启时，调用这个方法
        数据库/文件的开启可以放在这里
        :param spider:
        :return:
        '''
        # 连接mongo
        self.client = MongoClient(self.mongo_uri, self.mongo_port)
        # 选择使用的数据库
        db_auth = self.client[self.mongo_db]
        # 验证登陆
        db_auth.authenticate("simpleUser", "simplePass")
        self.db = self.client[self.mongo_db]

    def process_item(self, item, spider):
        '''
        处理item，进行保存
        :param item:
        :param spider:
        :return:
        '''
        # 向集合中添加数据
        self.db[self.collection_name].insert(dict(item))
        return item

    def close_spider(self, spider):
        '''
        spider被关闭的时候调用
        可以放置数据库/文件关闭的代码
        :param spider:
        :return:
        '''
        self.client.close()
```
配置  
写好的 pipelines 需要配置激活  
```python
settings.py

# 激活pipline，从低到高开始执行
ITEM_PIPELINES = {
    'cankao.pipelines.CankaoPipeline': 300,
    'cankao.pipelines.CankaoMongoPipeline': 500,
}

# mongo的配置信息
MONGO_URI = '118.25.38.240'
MONGO_PORT = 27017
MONGO_DATABASE = 'fecshop_test'
```
#### 下载文件(自定义文件名)  
```python
import scrapy
from scrapy.pipelines.files import FilesPipeline
from scrapy.http import Request
import os

class CankaoFilesPipeline(FilesPipeline):
    '''
    下载文件
    继承框架自带的FilesPipeline文件下载类
    '''

    def get_media_requests(self, item, info):
        '''
        重写此方法， 用来获取图片url进行下载
        :param item:
        :param info:
        :return:
        '''
        self.item = item
        yield scrapy.Request(item['img'])

    # def item_completed(self, results, item, info):
    #     '''
    #     下载完成后将会把结果送到这个方法
    #     :param results:
    #     :param item:
    #     :param info:
    #     :return:
    #     '''
    #     # print(results)
    #
    #     '''
    #     results 为下载返回的数据, 如下
    #     [(True, {'url': 'https://img3.doubanio.com/view/subject/m/public/s29816983.jpg', 'path': 'full/fced9acc2ecf23e0f96b9a2d9a442b02234f4388.jpg', 'checksum': 'ce0e7d543b37dbe3d21dd46ef8fcbd1b'})]
    #     图片下载成功时为True
    #     url 源图片地址
    #     path 下载的文件路径
    #     checksum md5 hash
    #     '''
    #     print(item)
    #     print(info)

    def file_path(self, request, response=None, info=None):
        '''
        重写要保存的文件路径，不使用框架自带的hash文件名
        :param request:
        :param response:
        :param info:
        :return:
        '''
        def _warn():
            from scrapy.exceptions import ScrapyDeprecationWarning
            import warnings
            warnings.warn('FilesPipeline.file_key(url) method is deprecated, please use '
                          'file_path(request, response=None, info=None) instead',
                          category=ScrapyDeprecationWarning, stacklevel=1)

        # check if called from file_key with url as first argument
        if not isinstance(request, Request):
            _warn()
            url = request
        else:
            url = request.url

        # 后缀
        media_ext = os.path.splitext(url)[1]
        # 原名带后缀
        media_content = url.split("/")[-1]
        # 使用item中的内容
        # return 'full/%s%s' % (self.item['content'], media_ext)
        return 'full/%s' % (media_content)

```
配置  
写好的 pipelines 需要配置激活  
```python
settings.py

# 激活pipline，从低到高开始执行
ITEM_PIPELINES = {
    'cankao.pipelines.CankaoPipeline': 300,
    'cankao.pipelines.CankaoMongoPipeline': 500,
    'cankao.pipelines.CankaoFilesPipeline': 600,
}
'''
FilesPipeline 配置
'''
# 设置文件存放位置
FILES_STORE = './download/files'
# 设置文件过期时间30天
FILES_EXPIRES = 30
```

```python
import scrapy
from scrapy.pipelines.images import ImagesPipeline

class CankaoImagesPipeline(ImagesPipeline):
    '''
    继承框架自带的ImagesPipeline图片下载类，可以下载的同时生成不同尺寸的图片放在配置的目录下
    '''

    def get_media_requests(self, item, info):
        '''
        重写此方法， 用来获取图片url进行下载
        :param item:
        :param info:
        :return:
        '''
        yield scrapy.Request(item['img'])

    # def item_completed(self, results, item, info):
    #     '''
    #     下载完成后将会把结果送到这个方法
    #     :param results:
    #     :param item:
    #     :param info:
    #     :return:
    #     '''
    #     print(results)
    #
    #     '''
    #     results 为下载返回的数据, 如下
    #     [(True, {'url': 'https://img3.doubanio.com/view/subject/m/public/s29827942.jpg', 'path': 'full/ad6acfdbef4d9df208c0e010ed1efcc287cb6225.jpg', 'checksum': 'c5d853689829ba8731cbb27146d89573'})]
    #     图片下载成功时为True
    #     url 源图片地址
    #     path 下载的文件路径
    #     checksum md5 hash
    #     '''
    #     print(item)
    #     print(info)
```
配置  
写好的 pipelines 需要配置激活  
```python
settings.py

# 激活pipline，从低到高开始执行
ITEM_PIPELINES = {
    'cankao.pipelines.CankaoPipeline': 300,
    'cankao.pipelines.CankaoMongoPipeline': 500,
    'cankao.pipelines.CankaoFilesPipeline': 600,
    'cankao.pipelines.CankaoImagesPipeline': 700,
}
'''
ImagesPipeline 配置
'''
# 设置图片路径
IMAGES_STORE = './download/images'
# 制作缩略图
IMAGES_THUMBS = {
   'small': (50, 50),
   'big': (270, 270)
}
# 设置图片过期时间30天
IMAGES_EXPIRES = 30
# 过滤下载图片的大小
# 过滤条件：最小图片尺寸
# IMAGES_MIN_HEIGH = 10
# IMAGES_MIN_WIDTH = 10
```
### 创建中间件  
#### 下载中间件实现 随机 USER_AGENT  
```python
import random
class RandomUserAgent(object):
    '''
    使用随机 User-Agent的中间件
    '''
    def __init__(self, agents):
        self.agents = agents

    @classmethod
    def from_crawler(cls, crawler):
        '''
        通过这个类方法创建对象
        :param crawler:
        :return:
        '''
        '''
        settings.py USER_AGENTS的值示例
        USER_AGENTS = [
           'Mozilla/5.1 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
           'Mozilla/5.2 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
           'Mozilla/5.3 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
           ]

        '''
        # 获取配置文件settings中USER_AGENTS的值
        return cls(crawler.settings.getlist('USER_AGENTS'))


    def process_request(self, request, spider):
        print('here')
        '''
        中间件请求过程中设置request
        :param request:
        :param spider:
        :return:
        '''
        # 设置request的的User-Agent头
        # setdefault 如果已经存在了就不会重新赋值了，所以中间件要靠前才生效
        request.headers.setdefault("User-Agent", random.choice(self.agents))
```
配置  
```python
settings.py  

# 下载中间件
DOWNLOADER_MIDDLEWARES = {
   'cankao.middlewares.RandomUserAgent': 100, # 数值要小
}
#  客户端 user-agent请求头 随机使用一个
USER_AGENTS = [
   'Mozilla/5.1 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
   'Mozilla/5.2 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
   'Mozilla/5.3 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
]
```
#### 下载中间件实现 随机代理  
```python
class RandomProxy(object):
    '''
    使用随机代理的中间件
    '''
    def __init__(self, iplist):
        self.iplist = iplist

    @classmethod
    def from_crawler(cls, crawler):
        return cls(crawler.settings.getlist('IPLIST'))

    def process_request(self, request, spider):
        '''
        给代理随机添加上一个代理
        :param request:
        :param spider:
        :return:
        '''
        proxy = random.choice(self.iplist)
        request.meta['proxy'] = proxy
```
配置同上  
### 创建 cankao2 爬虫，并验证中间件，实现cookie管理  
```python
# -*- coding: utf-8 -*-
import scrapy
from scrapy.http.request import Request
import random

class Cankao2Spider(scrapy.Spider):
    '''
    测试随机User-agent头中间件和cookie管理
    '''
    name = 'cankao2'
    allowed_domains = ['wuxingxiangsheng.com']
    # start_urls = ['http://temp.wuxingxiangsheng.com/test/request']

    def start_requests(self):
        # cookiejar 参数用来自动管理cookie， 可以自动管理多个，根据cookiejar对应的值不同
        return [Request('http://temp.wuxingxiangsheng.com/test/request', meta = {'cookiejar':1})]

    def parse(self, response):
        '''
        解析
        :param response:
        :return:
        '''
        # 打印响应体
        print(response.body)
        # print(papers)
        salt = random.random()

        # 获取响应的cookie
        print(response.headers.getlist('Set-Cookie'))
        # 获取cookiejar对应的值 1
        print(response.meta['cookiejar'])
        # cookies 为自定义cookie值  meta = {'cookiejar' 为自动管理的cookie
        yield Request(url='http://temp.wuxingxiangsheng.com/test/request?salt=%s' % salt, cookies={'test':'test'},
                      meta = {'cookiejar':response.meta['cookiejar']}, callback=self.next)

    def next(self, response):
        # 获取请求携带的cookie， 自定义的加自动管理的
        cookie = response.request.headers.getlist('Cookie')
        print('请求时携带请求的Cookies：', cookie)
        print(response.body)
```
如果cookie不能使用，请查看配置  
```python
COOKIES_ENABLED = True
```

## 其他    
### debug 模式启动(调试) || 多爬虫启动   
**调试需要通过IDE的debug模式启动**  
由于通过终端直接执行爬虫命令无法调试，我们需要将执行爬虫的命令写在一个文件中然后执行  
创建文件 `cankao3.py`, 内容如下    
```python
from cankao.spiders.cankao1 import Cankao1Spider
from scrapy.utils.project import get_project_settings
from scrapy.crawler import CrawlerProcess

'''
启动爬虫, 可以通过debug模式启动(debug模式启动)，进行源码分析
'''

def my_run1():
    '''
    启动单个爬虫，这里可以定制爬虫的配置
    :return:
    '''
    process = CrawlerProcess(get_project_settings())
    process.crawl(Cankao1Spider)
    process.start()

def my_run2():
    '''
    启动多个爬虫，这里可以给每个爬虫定制配置
    :return:
    '''
    process = CrawlerProcess(get_project_settings())
    process.crawl(Cankao1Spider)
    process.crawl(Cankao1Spider)
    process.start()

if __name__ == '__main__':
    my_run1()
```
调试方法2    

在项目根目录下新建 main.py 文件,用于调试
```python
from scrapy import cmdline
cmdline.execute('scrapy crawl sunwz'.split())

执行程序
python3 main.py
```
### 配置  
#### 日志文件名和处理等级  
```python
LOG_FILE = "dg.log"
LOG_LEVEL = "DEBUG"
```
下面给出如何使用 WARNING 级别来记录信息的例子:
```python
from scrapy import log
log.msg("This is a warning", level=log.WARNING)
```
#### 延时下载  
```python
DOWNLOAD_DELAY = 0.25    # 250 ms of delay
```

### 终端分析xpath是否正确   
> win系统无法使用,mac正常     

```python
1. 执行
scrapy shell 'www.bunao.win' # 执行要分析页面地址   
2. 获得返回数据后，执行  
response.xpath('//a')  # response对象就是上一步返回的对象，执行自己的xpath表达式，查看结果是否正确  

也可以通过  
view(response)  # 将请求返回的网页再浏览器打开，再浏览器里测试xpath表达式  

```
### 获取配置  
获取项目配置信息，如果没设置返回的是默认的配置信息  

```
获取USER_AGENT配置信息，具体的配置字段查看setting文件
F:\python\cankao>scrapy settings --get USER_AGENT
Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrom
e/61.0.3163.100 Safari/537.36
```

> 项目地址 [github](https://github.com/Ibunao/cankao)   

### 增量式爬虫(去重)  
用到了查一下，比较简单。这里记录一下防止忘记  
《python爬虫开发与项目实践 P372》
