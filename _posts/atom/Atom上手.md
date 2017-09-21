# Atom使用教程  
[极客学院](http://wiki.jikexueyuan.com/project/atom/)
[W3C](https://www.w3cschool.cn/atom/z3fq1hr1.html)

# win7环境
## 删除Atom
使用的360进行删除，删除后会发现 `C:\Users\你的用户名\` 有一个隐藏的文件夹 `.atom` 将其删除，不删除的话重新安装atom的时候依旧会保留原来的配置及插件

## 插件
安装完 Atom 之后自带了79个插件，基本的功能都已经可以使用了  
**安装插件**
> 在 setting 页面可以看到 `Packages` 和 `Install` 两个选项，  `Packages` 查看已经安装的插件， `Install` 来安装插件的，可以使用
`ctrl+Shift+p` 进入这个页面  

| 插件           | 是否安装 |
| :------------- | :------------- |
| file-icons        | yes       |
| pigments        | no       |
| minimap        | yes       |
| autocomplete-paths        | no       |
| atom-ternjs        | no       |
| emmet        | yes       |
| docblockr        | yes       |
| vim-mode        | no       |
| platformio-ide-terminal        | no       |
| atom-beautify        | yes       |
| php-debug        | yes       |
| linter-jshint        | yes       |
| simplified-chinese-menu        | no       |
| goto-definition        | yes       |


* [file-icons](https://atom.io/packages/file-icons) 显示文件类型对应的图标  
* [pigments](https://atom.io/packages/pigments) css/less 写表示颜色时显示颜色  
* [minimap](https://atom.io/packages/minimap)  右边代码预览框  
* [autocomplete-paths](https://atom.io/packages/autocomplete-paths) 补全路径  
* [atom-ternjs](https://atom.io/packages/atom-ternjs) 补全Js
* [emmet](https://atom.io/packages/emmet) 前端实用工具 [教程](http://wiki.jikexueyuan.com/project/atom/emmet.html)
* [docblockr](https://atom.io/packages/docblockr)  代码注释

* [vim-mode](https://atom.io/packages/vim-mode)  在 Atom 上使用 Vim
* [platformio-ide-terminal](https://atom.io/packages/platformio-ide-terminal)  Atom 中集成终端
* [atom-beautify](https://atom.io/packages/atom-beautify)  美化代码段   快捷键 `ctrl + alt + b`  ，如果弹出出错信息，可能是需要依赖一些其他插件，比如 php的 就需要装 [php-cs-fixer](https://atom.io/packages/php-cs-fixer) 插件  
* [linter-php](https://atom.io/packages/linter-php) 检查php语法错误  ，可能需要将php配置成全局  ，安装它的时候会让安装一些依赖插件，按照提示安装即可  

* [linter-jshint](https://atom.io/packages/linter-jshint) 检查js语法错误  ，需要安装node，使用npm 全局安装jshint      (没有配置成功，报错incompatible values for the esversion and es3 linting option ，配置文件写错了) 相关资料 [jshint配置](http://www.jianshu.com/p/4cb23f9e19d3)
**linter-jshint配置**
1. 首先安装 node ，使用npm 全局安装jshint
2. 在 `~` (`~`,表示用户目录，在windows下是`C:\Users\dingran`)文件下放置js配置文件 `.jshintrc` [配置文件](/images/atom/.jshintrc)  
3. atom 配置插件，如下图    
勾选lint inline javaScript,可以在html或php中检查js  
![js配置](/images/atom/atom-jshint1.png)  
点击 `open config folder` 找到配置文件，查看配置文件 `config.cson`  
![js配置](/images/atom/atom-jshint2.png)  
```
"linter-jshint":
    disableWhenNoJshintrcFileInPath: false
    lintInlineJavaScript: true
```

* [php-debug](https://atom.io/packages/php-debug) xdebug调试    

* [simplified-chinese-menu](https://atom.io/packages/simplified-chinese-menu
) 汉化  

* [goto-definition](https://atom.io/packages/goto-definition) 文件跳转，放到方法或类名上右键 `goto definition` 就会出现列表，选择跳转，有快捷键，还是不用了  

* [remote-ftp](https://atom.io/packages/remote-ftp)  sftp上传工具  
插件配置：把 `auto upload on save` 由 `aways` 改为 `nerver`  

可以在 `packages->Remote-Ftp->Create ……` 来生成配置文件 `.ftpconfig`  (生成在添加到Atom项目文件根目录，上传的时候也是在根目录中寻找配置文件，限制啊)，上传只能在左边 `menu` 菜单来选中上传和下载 (限制啊)   
```
{
    "protocol": "sftp", # 协议
    "port": 22, # 端口
    "host": "128.128.1.79", # ip
    "user": "root", # 用户
    "pass": "******", # 密码
    "promptForPass": false,
    "remote": "/usr/share/nginx/html/protected", # 对应的项目文件地址
    "local": "",
    "agent": "",
    "privatekey": "",
    "passphrase": "",
    "hosthash": "",
    "ignorehost": true,
    "connTimeout": 10000,
    "keepalive": 10000,
    "keyboardInteractive": false,
    "remoteCommand": "",
    "remoteShell": "",
    "watch": [],
    "watchTimeout": 500
}
```







### 装逼神奇  
* [activate-power-mode](https://atom.io/packages/activate-power-mode)  颤抖吧  

## 快捷键
[慕课ATOM编辑器快捷键大全](http://www.imooc.com/article/1370)  
> Atom 兼容sublime快捷键，同时也有自己的快捷键  

```
Ctrl + /                启用注释            同sublime
Ctrl + \                展示隐藏目录树       同时也可以 ctrl+k ctrl+b
Ctrl + Alt + I          打开Chrome调试器     nb
Ctrl + [                向右缩进
Ctrl + ]                向左缩进
Shift + Home            选定光标至行首
Shift + End             选定光标至行尾
Shift + PageUp          选定光标至页首
Shift + PageDown        选定光标至页尾
Ctrl + Home             光标到页首
Ctrl + End              光标至页尾
Ctrl + PageUp           切换上一个打开的标签
Ctrl + PageDown         切换下一个打开的标签
Ctrl + D                匹配选定下一个       同sublime
Alt + F3                匹配选定所有
Ctrl + ↑                选中行上移           和sublime有区别，sulime为ctrl+Shift+↑
Ctrl + ↓                选中行下移
cmd + b                 在打开的文件之间切换
Ctrl + Shift + L        切换文本内容类型，例如 html/php   和sublime不同  
cmd + shift + b         只搜索从上次git commit后修改或者新增的文件
cmd + shift + d         复制选中代码并粘贴到选中的后面
cmd + shift + u         选择文件编码格式
```

### 折叠
```
Alt + Ctrl + [          折叠
Alt + Ctrl + ]          展开
Alt + Ctrl + Shift + {  折叠全部
Alt + Ctrl + Shift + }  展开全部

```

### Markdown 写作
```
Ctrl + Shift + M        Markdown预览
```

#### Markdown 语法补全
```
b                       **加粗**
legal                   Copyright (c) 2017 Copyright Holder All Rights Reserved.
img                     ![]()
l                       []()
i                       **
code                    \```code\```\
t                       - [ ]   多选按钮
table  
| Header One     | Header Two     |
| :------------- | :------------- |
| Item One       | Item Two       |
```
## 更改快捷键  
> 有些时候需要更改快捷键，比如快捷键冲突时  

1. 打开快捷键设置，如图  
![自定义快捷键](/images/atom/atom-kuaijiejian1.png)  
搜索要改的快捷键 如 `ctrl-shift-m`,发现有两个，出现了冲突，这时可以自定义一个(优先级最高)将其覆盖  
点击需要自定义快捷键的最左边的小按钮进行复制  
2. 打开自定义文件(点击链接 your keymap file)
3. 将复制的快捷键定义粘贴在自定义文件中，如图  
![自定义快捷键](/images/atom/atom-kuaijiejian2.png)   

## 备份插件
[备份插件教程](https://zhuanlan.zhihu.com/p/26175781?group_id=832895479217004544)
> 将配置文件上传到github  

备份  
使用快捷键 `Ctrl + Shift + P` 呼出命令栏，输入 `sync backup`  
恢复备份  
使用快捷键 `Ctrl + Shift + P` 呼出命令栏，输入 `sync restore`
**补充**
获取 `Gist Id`  
1. 进入到github，点击你的头像会看到 `Your gists`,点击进去  
2. 如果没有，则需要创建一个：起个名称(用途)，写个简介  
3. 获取 `Gist Id`，进入创建好的 `Gist` 看到连接 `https://gist.github.com/Ibunao/654a98d3e154348eaebba448312b0152` 其中 `654a98d3e154348eaebba448312b0152` 就是 `Gist Id`  

## 问题
1. `ctrl+,` 快捷键无法打开 setting ,可能是因为快捷键冲突

## xdebug调试  
**相关教程**  
1. atom 安装 `php-debug` 插件，不用配置  
2. php开启xdebug  
win上安装的是wamp所以xdebug都是有的  
php.ini 配置  

```
[xdebug]
zend_extension ="D:/ding/wamp64/bin/php/php5.6.25/zend_ext/php_xdebug-2.4.1-5.6-vc11-x86_64.dll"
;xdebug.remote_enable = Off
xdebug.profiler_enable = On
xdebug.profiler_enable_trigger = off
xdebug.profiler_output_name = cachegrind.out.%t.%p
xdebug.profiler_output_dir ="D:/ding/wamp64/tmp"
xdebug.show_local_vars=0

xdebug.remote_enable=1
xdebug.remote_host=127.0.0.1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_autostart=true
```  

3. 调试  
  1. 开启debug插件 atom左下角debug按钮打开debug，没有监听到时显示的是 `Listening on address:port 127.0.0.1:9000`
  2. 在方法中打断点  (断点要注意了，如果打到空行，或者for循环里面将会无法监听到) 如图  
  ![debug](/images/atom/atom-debug1.png)
  3. 浏览器中访问能进入到打断点的方法中 ，如 `www.basic.com/test/test`  
    如果操作正确将会看到监听状态由 `Listening on address:port 127.0.0.1:9000` 改变成 `Connected` ,此时就可以使用debug调试了  

> 如果没有改变监听状态，可能就是断点打错了，请检查  
> 如果atom的debug启动不起来，可能是9000端口被占用了，更改插件端口和php.ini 中的xdebug配置的端口即可  


**操作详解**  
进入到断点将会输出一下内容，如下图  
![debug](/images/atom/atom-debug2.png)  
其中，主要的有两部分内容 栈信息`Stack` 和变量值信息 `Context`  
其中 `Stack` 显示的是走到这个断点所经过的方法，如图从7到0，可以点击不同的栈来查看他的 变量值信息 `Context`  

`Context` 中显示的是变量信息，  
其中 `Locals` 显示的是方法中的变量值信息  
`Superglobals` 显示的是全局的信息 ，如 `$_COOKLE、$_POST` 等一些全局的信息  
`User defined constants` 显示的是定义的常量  

**操作**
添加断点  
在代码的左边栏上点击，因为比较窄不好点击，也可以使用快捷键  `alt + f9`  

`Stop` 释放掉监听  `alt + f5`  
`Continue` 走向下一个断点
`Step Over` 一步一步往下走    `alt + f6`  
`Step In` 进入到方法内     `alt + f7`  
`Step Out` 跳出方法    `alt + f8`  

`Restore Panels` 恢复原始的展示窗口  
其他两个就是切换展示位置的  



[xdebug使用](http://blog.csdn.net/frycn/article/details/68925991)
[xdebug使用](http://www.jianshu.com/p/74a1d60ab5ef)
[xdebug使用](http://www.jianshu.com/p/e9ad4c99d118)
[xdebug使用](http://www.taovq.com/index.php/archives/102/)
[xdebug相关](http://philix.iteye.com/blog/960606)
[xdebug相关](https://segmentfault.com/a/1190000009500015)
[mac 安装](http://www.alliedjeep.com/139216.htm)  

## 设置代码段 snippet  
> 有一点不好的是，只能在某个语言环境中触发为某个语言设置的代码段  

[教程](http://www.jianshu.com/p/ee5c4eacf807)  

实例  
```
'.text.html.php': # 语言类型的 scope
  'php': # 随便
    'prefix': 'header' #触发单词
    'body': 'header("Content-Type:text/html;charset=utf-8");\n' #\n 换行
'.text.html.php':
  'yii':
    'prefix': 'vy'
    'body': '<?=$${1:this} ;?>'
```
