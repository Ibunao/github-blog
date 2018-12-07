
Request 中的方法并不难，主要是一些功能的封装罢了，原理上没有很复杂的东西。只是涉及到许多HTTP的有关知识,具体的代码分析和相关知识可以看


这里主要归纳一下使用方法  


## 请求头请求体  
### getHeaders() 获取请求头  
可以获取所有的请求头  

### getRawBody() 获取请求体   
使用了 `php://input` 来获取请求体，这个 `php://input` 有这么几个特点：

`php://input` 是个只读流，用于获取请求体。  
`php://input` 是返回整个HTTP请求中，除去HTTP头部的全部原始内容， 而不管是什么 `Content Type（或称为编码方式）`。 相比较之下， `$_POST` 只支持 `application/x-www-form-urlencoded` 和 `multipart/form-data-encoded` 两种 `Content Type` 。其中前一种就是简单的HTML表单以 `method="post"` 提交时的形式， 后一种主要是用于上传文档。因此，对于诸如 `application/json` 等 `Content Type`，这往往是在 `AJAX` 场景下使用， 那么使用 `$_POST` 得到的是空的内容，这时就必须使用 `php://input` 。
相比较于 `$HTTP_RAW_POST_DATA` ， `php://input` 无需额外地在 `php.ini` 中 激活 `always-populate-raw-post-data` ，而且对于内存的压力也比较小。
当编码方式为 `multipart/form-data-encoded` 时， `php://input` 是无效的。这种情况一般为上传文档。 这种情况可以使用传统的 `$_FILES` 或者 `yii\web\UploadedFile`   


## 获取/判断请求方法  
### getMethod() 获取请求的方法  
可以以指定 `$_POST['_method']` 的方式来用POST请求来模拟其他方法的请求。  

### getIsAjax() 是否是AJAX请求  
这其实不是HTTP请求方法, 需要js在写入相应的header头 `HTTP_X_REQUESTED_WITH: XMLHttpRequest`
### getIsDelete() 是否是DELETE请求
### getIsFlash() 是否是Adobe Flash 或 Adobe Flex 发出的请求，这其实也不是HTTP请求方法。
### getIsGet() 是否是一个GET请求
### getIsHead() 是否是一个HEAD请求
### getIsOptions() 是否是一个OPTIONS请求
### getIsPatch() 是否是PATCH请求
### getIsPjax() 是否是一个PJAX请求，这也并非是HTTP请求方法。
### getIsPost() 是否是一个POST请求
### getIsPut() 是否是一个PUT请求

## 获取请求数据    
### get($name = null, $defaultValue = null) 获取get请求的数据
1. 如果不带参数，则表示获取所有的get参数 `getQueryParams()`  
2. 常用的方式，获取某个值，如果这个值不存在就给指定的默认值 `getQueryParam($name, $defaultValue = null)`  

```php
get('ding', 'ding')
```
### post($name = null, $defaultValue = null) 获取post请求的数据  
和get用法一样  

### getBodyParams() 解析请求体中的数据    
这个方法会根据请求的 `content-type` 来找对应的解析类把 请求体 的数据给解析出来  

### getBodyParam($name = null, $defaultValue = null) 解析请求体中的数据  
获取`getBodyParams()`解析后的内容中对应的key  

## 域名相关  
### getHostInfo() 获取当前的域名，带协议(http或https)和端口号  
举例  
```php
请求
www.yiibasic.com/test/test
输出
http://www.yiibasic.com
```
### getHostName() 获取当前域名，只是域名  
```php
解析的 getHostInfo() 获取到的值  
parse_url($this->getHostInfo(), PHP_URL_HOST)
```
```php
请求
www.yiibasic.com/test/test
输出
www.yiibasic.com
```
### getServerName() 也是返回域名 和 getHostName一样  

## url相关  
### getUrl() 返回当前请求域名后的所有内容  
如  
`http://localhost/learn/yii/yiilearn/basic/web/index.php/test/request`   
返回  
`/learn/yii/yiilearn/basic/web/index.php/test/request`    

### getScriptUrl() 获取入口文件相对域名的路径，带入口文件  
如 `www.bunao.me/web/index.php` 获取到的是 `/web/index.php`  
`www.bunao.me/index.php` 和 `www.bunao.me` 获取到的就是 `/index.php`  
如果开启了省略入口文件，则获取到的为空  
### getBaseUrl() 获取入口文件相对域名的路径,不带入口文件  
`getBaseUrl()` 获取到的是对 `getScriptUrl()` 的处理,去掉了入口文件  
假设域名指向的不是 `web` 而是 `web的外层`     
则获取到的是 `/web`
### getAbsoluteUrl() 获取完整的当前请求  
```php
$this->getHostInfo() . $this->getUrl();
```
### getScriptFile() 获取当前脚本的实际物理路径  
例如  
```php
D:/ding/wamp64/www/learn/yii/yiilearn/basic/web/index.php  
```

### getPathInfo() 返回真正的 pathInfo  
`?` 问号前和入口文件之间的部分
例子  
```
url
www.bunao.me/index.php/ding/ran?bunao=yes 带入口文件的情况
www.bunao.me/ding/ran?bunao=yes 不带入口文件
www.bunao.me/web/index.php/ding/ran?bunao=yes 带入口文件  
www.bunao.me/web/ding/ran?bunao=yes 不带入口文件
pathInfo  
ding/ran
```

## 加解密相关的  
### getCookies() 获取cookie  
默认是必须用这个方法来获取cookie的，因为默认存取cookie是存取的加密数据，而这个方法获取时会对加密的数据进行解密  

### Csrf  
这里理解一下yii如何实现csrf的  
1. 生成token:在渲染页面的时候通过 `getCsrfToken()` 方法获取到token，嵌到页面里，参考 `BaseHtml::csrfMetaTags()` 方法  
2. 验证token:在请求的时候通过 `validateCsrfToken()` 方法来验证token，参考 `Controller::beforeAction()` 方法  

info1: 在生成token的时候同时会保存在 cookie、session 中，验证的时候将 接口(页面)传来的数据 和正确的数据(从 cookie、session 中获取) 进行比较。也就是说csrf依赖cookie。  
info2: 为什么敢将token同时存在cookie？因为存cookie时候是加密的形式，所以也就不害怕了。  


## 其他方法  
### getQueryString() 返回url中?后的部分  
### getIsSecureConnection() 判读不是 https请求  
### getServerPort() 获取端口号  
### getReferrer() 获取 Referer  
### getUserAgent() 获取浏览器信息，简单防爬虫  
### getUserIP() 获取用户ip  
### getPort() 获取http端口号，默认是80
### getSecurePort() 获取https端口号，默认是443
### getContentType() 获取 `content-type`  
### resolve() 获取解析后的请求  
Application 会用它来执行解析Url请求，分析出正确的路由和参数    

## 其他的其他  
### getUserHost() 获取用户主机名/域名  
### getAuthUser() http认证机制  
### getAuthPassword() http认证密码  
### getAcceptableContentTypes() 获取用户能够接受的content-type类型  
看示例吧  
```php
$_SERVER['HTTP_ACCEPT'] = 'text/plain; q=0.5, application/json; version=1.0, application/xml; version=2.0;';
$types = $request->getAcceptableContentTypes();
print_r($types);
// 结果
// [
//     'application/json' => ['q' => 1, 'version' => '1.0'],
//      'application/xml' => ['q' => 1, 'version' => '2.0'],
//           'text/plain' => ['q' => 0.5],
// ]
```
### parseAcceptHeader($header)  解析获取到的请求头字段  
，看示例  
```php
$header = 'text/plain; q=0.5, application/json; version=1.0, application/xml; version=2.0;';
$accepts = $request->parseAcceptHeader($header);
print_r($accepts);
// displays:
// [
//     'application/json' => ['q' => 1, 'version' => '1.0'],
//      'application/xml' => ['q' => 1, 'version' => '2.0'],
//           'text/plain' => ['q' => 0.5],
// ]
```
### getAcceptableLanguages() 获取能够接收的语言类型  
### getPreferredLanguage(array $languages = []) 返回该应用程序应该用的首选语言  
### getETags() 返回etags内容, 在http缓存有用  
[使用ETags减少Web应用带宽和负载](http://www.infoq.com/cn/articles/etags)  

## 参考  
[深入理解yii-Request(完全参考)](http://www.digpage.com/web_request.html#)  
