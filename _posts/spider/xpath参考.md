

## 语法  
百度吧  
看过之后可以通过后面的 应用 部分理解一下  
## 获得 xpath 路径   
通过chrome浏览器可以右键来查看  
![xpath](/images/scrapy/scrapy-xpath1.png)

## 应用  

```
#!/usr/bin/env python
# -*- coding:utf-8 -*-

from scrapy.selector import Selector
from scrapy.http import HtmlResponse

html = """<!DOCTYPE html>
<html>
    <head lang="en">
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        <ul>
            <li class="item-"><a id='i1' href="link.html" class='ding'>first item</a></li>
            <li class="item-0"><a id='i2' href="llink.html" class='ding'>first item</a></li>
            <li class="item-1"><a href="llink2.html">second item<span>vv</span></a></li>
        </ul>
        <div><a href="llink2.html">second item</a></div>
        <div><a href="llink2.html">10</a></div>
    </body>
</html>
"""
# 构造response对象
response = HtmlResponse(url='', body=html, encoding='utf-8')
selector = Selector(response=response)
# 获取所有a标签
temp = selector.xpath('//a')
# 获取第一个body标签并从body标签开始找ul标签 ./ul 相对标签的子标签
temp = selector.xpath('body')[0].xpath('.//ul')
print(temp)
exit()
# 获取body的子标签ul
temp = selector.xpath('body/ul')
# 获取body的后代标签li
temp = selector.xpath('body//li')
# []空，li不是body的子标签
temp = selector.xpath('body/li')
# 获取body的父标签
temp = selector.xpath('body')[0].xpath('..')
# 获取包含class属性的标签
temp = selector.xpath('//@class')
# 获取属性class=item-0的标签
temp = selector.xpath('//@class=item-0')
# 获取body的后代第一个li标签
temp = selector.xpath('body//li[1]')
# 获取body的后代最后一个li标签
temp = selector.xpath('body//li[last()]')
# 获取body的后代倒数第二个li标签
temp = selector.xpath('body//li[last()-1]')
# 获取body的后代前两个li标签
temp = selector.xpath('body//li[position() < 3]')
# 拥有id属性的a标签
temp = selector.xpath('body//a[@id]')
# 标签a id属性为i1
temp = selector.xpath('body//a[@id=i1]')
# 标签div下a标签值为 second item 的div标签
temp = selector.xpath('body//div[a="second item"]')
# 标签div下a标签值小于30的div标签
temp = selector.xpath('body//div[a < 30]')
# 匹配任何节点
temp = selector.xpath('//*')
# 匹配当前节点任何子节点
temp = selector.xpath('*')
# 匹配当前节点任何子节点包含属性的节点
temp = selector.xpath('@*')
# 匹配任何包含了属性的节点
temp = selector.xpath('//@*')

# 获取body子元素中的ul标签
temp = selector.xpath('body/child::ul')
# 获取body标签的父标签
temp = selector.xpath('body/parent::*')
# 获取body标签的祖先标签
temp = selector.xpath('body/ancestor::*')
# 获取body标签的祖先标签包含自己
temp = selector.xpath('body/ancestor-or-self::*')
# 获取body标签的后代标签
temp = selector.xpath('body/descendant::*')
# 获取body标签的后代标签为a的a标签
temp = selector.xpath('body/descendant::a')
# 获取body标签的后代标签包含自己
temp = selector.xpath('body/descendant-or-self::*')
# 获取body标签的同级标签
temp = selector.xpath('body/preceding-sibling::*')
# 获取class为item-0的li标签的下一个同级标签
temp = selector.xpath('//li[@class="item-0"]/following-sibling::*')
# 获取class为item-0的li标签后面的所有标签
temp = selector.xpath('//li[@class="item-0"]/following::*')
# 获取class为item-0的li标签前面的所有标签
temp = selector.xpath('//li[@class="item-0"]/preceding::*')
# 获取所有li节点的所有属性
temp = selector.xpath('//li/attribute::*')
# 获取属性class为ding并且属性href为llink.html的a标签
temp = selector.xpath('//a[@class="ding"][@href="llink.html"]')
# 获取属性href包含link的a标签
temp = selector.xpath('//a[contains(@href, "link")]')
# 获取属性href以llin开头的a标签
temp = selector.xpath('//a[starts-with(@href, "llin")]')
# 正则匹配 id属性符合正则的a标签
temp = selector.xpath('//a[re:test(@id, "i\d+")]')
# 正则匹配 id属性符合正则的a标签 获取标签内容，并转换成正常的列表
temp = selector.xpath('//a[re:test(@id, "i\d+")]/text()').extract()
# 正则匹配 id属性符合正则的a标签 获取标签href属性值，并转换成正常的列表
temp = selector.xpath('//a[re:test(@id, "i\d+")]/@href').extract()
# 正则匹配 id属性符合正则的a标签 获取标签href属性值，获取第一个值
temp = selector.xpath('//a[re:test(@id, "i\d+")]/@href').extract_first()
print(temp)
```
