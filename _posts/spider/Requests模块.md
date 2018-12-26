---
title: 爬虫-scrapy  
date: 2018-12-20 20:00:02
tags:
    - python
    - Requests模块
    - 爬虫
categories:
    - python
    - 爬虫
    - Requests模块  
---

## requests 模块  
比较方便的一个发送请求的模块  
[中文文档](http://docs.python-requests.org/zh_CN/latest/index.html)  

### 请求  
#### get请求    
第一种方式，直接输入url  
```python  
import requests  
r = request.get('http://www.baidu.com?key=word&next=2')  
print(r.content)
```  
第二种方式，通过参数，自动进行拼接  
```python
import requests
payload = {'key':'word', 'next':2}
r = requests.get('http://www.baidu.com', params = payload)
# 输出查看URL  
print(r.url)
```
#### post 请求  
```python  
import requests  
postData = {'key':'value'}
r = requests.post('http://www.baidu.com', data = postData)
```
#### 其他请求方式   
delete、put、head、options请求方式参考上面两个  
#### 请求头 headers    
```python  
import requests
headers = {'User-Agent': 'Mozilla/4.0 (******)'}
r = requests.get('http://www.baidu.com', headers = headers)
```
#### 代理（proxies参数）  
如果需要使用代理，你可以通过为任意请求方法提供 `proxies` 参数来配置单个请求：
```python
import requests

# 根据协议类型，选择不同的代理
proxies = {
  "http": "http://12.34.56.79:9527",
  "https": "http://12.34.56.79:9527",
}

response = requests.get("http://www.baidu.com", proxies = proxies)
print response.text
```

也可以通过 **本地环境变量** `HTTP_PROXY` 和 `HTTPS_PROXY` 来配置代理：
```python
export HTTP_PROXY="http://12.34.56.79:9527"
export HTTPS_PROXY="https://12.34.56.79:9527"
```
##### 私密代理   
```python
import requests

# 如果代理需要使用HTTP Basic Auth，可以使用下面这种格式：
proxy = { "http": "user:pass@61.158.163.130:16816" }

response = requests.get("http://www.baidu.com", proxies = proxy)

print (response.text)
```
### 响应
#### 响应数据的编码  
请求之后，获取到的数据，有些可能会出现乱码，这里我们着手解决一下  
```python  
import requests  
r = requests.get('http://www.baidu.com')
# 获取响应的字节码。是服务器响应数据的原始二进制字节流，可以用来保存图片等二进制文件。  
print(r.content)  
# 获取requests模块根据返回猜测出的编码格式(不一定正确)  
print(r.encoding)  
# 获取根据猜测个格式编码解析响应的字节码得到字符串    
print(r.text)
# 如果乱码重新指定编码格式  
r.encodeing = 'utf-8'
# 获取根据指定的编码格式解析后的字符串
print(r.text)

# 如果是json文件可以直接显示
print (r.json())
```
1. requests，自带解压压缩( 如 `gzip` )网页的功能
2. 当收到一个响应时，Requests 会猜测响应的编码方式，用于在你调用 `response.text` 方法时对响应进行解码。Requests 首先在 `HTTP` 头部检测是否存在指定的编码方式，如果不存在，则会使用 `chardet.detect` 来尝试猜测编码方式（存在误差）
3. **更推荐使用 `response.content.deocde()`**    

##### 通过 chardet 模块来获取响应的编码格式  
```python
# 安装  
pip3 install chardet  

# 使用  
r = requests.get('http://www.baidu.com')

r.encodeing = chardet.detect(r.content)['encoding']

print(r.text)
```

#### 响应码code和相应头headers  

```python
r = requests.get('http://www.baidu.com')
# 获取响应码  
print(r.status_code)  
# 获取响应头字典  
print(r.headers)  
# 安全获取响应头的某个字段  
print(r.headers.get('content-type')
# 索引获取，如果不存在会报错  
print(r.headers['content-type'])
```

#### 流模式获取响应数据  
请求的时候设置 `stream = True`  
```python  
r = requests.get('http://www.baidu.com', stream = True)
# 读取10个字节  
print(r.raw.read(10))
```  
#### 通过requests获取网络上图片的大小  

```python
from io import BytesIO,StringIO
import requests
from PIL import Image
img_url = "http://imglf1.ph.126.net/pWRxzh6FRrG2qVL3JBvrDg==/6630172763234505196.png"
response = requests.get(img_url)
f = BytesIO(response.content)
img = Image.open(f)
print(img.size)
输出结果：

(500, 262)
```
理解一下 `BytesIO` 和 `StringIO`

> 很多时候，数据读写不一定是文件，也可以在内存中读写。  
StringIO顾名思义就是在内存中读写str。  
BytesIO 就是在内存中读写bytes类型的二进制数据   

例子中如果使用StringIO 即`f = StringIO(response.text)`会产生`"cannot identify image file"`的错误  
当然上述例子也可以把图片存到本地之后再使用Image打开来获取图片大小

### cookie处理   

如果一个响应中包含了cookie，那么我们可以利用 cookies参数拿到：

```python
import requests

response = requests.get("http://www.baidu.com/")

# 返回CookieJar对象:
cookiejar = response.cookies

# 将CookieJar转为字典：
cookiedict = requests.utils.dict_from_cookiejar(cookiejar)

print (cookiejar)

print (cookiedict)
运行结果：

<RequestsCookieJar[<Cookie BDORZ=27315 for .baidu.com/>]>

{'BDORZ': '27315'}
```
#### session 实现cookie自动管理  

在 requests 里，session对象是一个非常常用的对象，这个对象代表一次用户会话：从客户端浏览器连接服务器开始，到客户端浏览器与服务器断开。  

会话能让我们在跨请求时候保持某些参数，比如在同一个 Session 实例发出的所有请求之间保持 cookie 。

##### 实现人人网登录
```python  
import requests

# 1. 创建session对象，可以保存Cookie值
ssion = requests.session()

# 2. 处理 headers
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36"}

# 3. 需要登录的用户名和密码
data = {"email":"mr_mao_hacker@163.com", "password":"alarmchime"}  

# 4. 发送附带用户名和密码的请求，并获取登录后的Cookie值，保存在ssion里
ssion.post("http://www.renren.com/PLogin.do", data = data)

# 5. ssion包含用户登录后的Cookie值，可以直接访问那些登录后才可以访问的页面
response = ssion.get("http://www.renren.com/410043129/profile")

# 6. 打印响应内容
print (response.text)
```
### 其他  
#### 是否允许重定向  
将 `allow_redirects` 设置为 `True` 表示允许重定向，可以通过 `history` 来查看之前重定向跳转信息  
```python
import requests
r = requests.get('http://github.com')
print(r.url)
print(r.status_code)
print(r.history)
```
#### 设置超时时间   
超时时间通过 `timeout` 参数进行设置  
```python
requests.get('http://github.com', timeout = 3)
```



#### https跳过证书验证  
如果我们想跳过 12306 的证书验证，把 verify 设置为 `False` 就可以正常请求了。
```python
r = requests.get("https://www.12306.cn/mormhweb/", verify = False)
```
