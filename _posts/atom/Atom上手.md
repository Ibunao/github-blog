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
| autocomplete-paths        | yes       |
| atom-ternjs        | no       |
| emmet        | yes       |
| docblockr        | yes       |
| vim-mode        | no       |
| platformio-ide-terminal        | no       |
| atom-beautify        | yes       |


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
* [linter-jshint](https://atom.io/packages/linter-jshint) 检查php语法错误  ，可能需要将php配置成全局  ，安装它的时候会让安装一些依赖插件，按照提示安装即可  






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
2.
