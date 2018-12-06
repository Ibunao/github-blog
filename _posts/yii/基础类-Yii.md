---
title: Yii类了解一下    
date: 2018-11-09 00:00:02
tags:
    - yii
    - 别名
    - 自动加载
categories:
    - yii  
---

## 前言  
Yii这个类相对比较简单，主要做的功能应该就是自动加载，和一些其他全局使用的方法  

## 自动加载  
Yii自带的自动加载比较简单，一个亮点是为了更快的加载使用了一个自定义的类-路径映射，我们在优化的时候也开把自己要加载的提前放进这个数组中。`Composer` 自带的自动加载这里也不打算分析了[composer自动加载分析](http://www.leoyang90.cn/2017/03/18/Composer-Autoload-Source-Reading-%E2%80%94%E2%80%94-Register-and-Run/)]  
### 注册自动加载  

```php
class Yii extends \yii\BaseYii
{
}
// 注册自动加载，注册到在此之前已经注册的所有自动加载的最前端，也就是会先使用Yii的自动加载进行加载
spl_autoload_register(['Yii', 'autoload'], true, true);
// 设置类与路径的加载映射，加快自动加载
Yii::$classMap = require(__DIR__ . '/classes.php');
// 容器
Yii::$container = new yii\di\Container();
```
### 自动加载逻辑  
```php
public static function autoload($className)
{		
	// 是否在定义的 类加载映射文件  
    if (isset(static::$classMap[$className])) {
        $classFile = static::$classMap[$className];
        if ($classFile[0] === '@') {
            $classFile = static::getAlias($classFile);
        }
    // 下面两个else在找不到的时候会直接return，会交给其他自动加载进行处理
    } elseif (strpos($className, '\\') !== false) {
        $classFile = static::getAlias('@' . str_replace('\\', '/', $className) . '.php', false);
        if ($classFile === false || !is_file($classFile)) {
            return;
        }
    } else {
        return;
    }
	// 加载类文件
    include($classFile);
	// 判断类、接口、trait类是否存在  
    if (YII_DEBUG && !class_exists($className, false) && !interface_exists($className, false) && !trait_exists($className, false)) {
        throw new UnknownClassException("Unable to find '$className' in file: $classFile. Namespace missing?");
    }
}
```

## 别名  
别名一般用来简化路径和url，像框架的基础路径就是通过别名设置的  

### 设置别名 setAlias
```php
public static function setAlias($alias, $path)
{
    //如果不是以 @ 开头的添加 @
    if (strncmp($alias, '@', 1)) {
        $alias = '@' . $alias;
    }
	// 别名是否带有 / ;例如：@yii/ding
    $pos = strpos($alias, '/');
    $root = $pos === false ? $alias : substr($alias, 0, $pos);
    if ($path !== null) {
        //$alias 的第一个字符和 @ 比较，如果相等返回0，不相等返回的结果可能是1或-1 为 true
		// 如果 $path 中含有别名，获取别名路径
        $path = strncmp($path, '@', 1) ? rtrim($path, '\\/') : static::getAlias($path);
        if (!isset(static::$aliases[$root])) {
            if ($pos === false) {
                static::$aliases[$root] = $path;
            } else {
				// 别名中如果带有 / ;存为二维数组
                static::$aliases[$root] = [$alias => $path];
            }
		// 如果已经设置过别名，而且为字符串
        } elseif (is_string(static::$aliases[$root])) {
            if ($pos === false) {
				// 直接覆盖
                static::$aliases[$root] = $path;
            } else {
				// 字符串改成数组形式
                static::$aliases[$root] = [
                    $alias => $path,
                    $root => static::$aliases[$root],
                ];
            }
		// 本身就是数组，则直接添加，并排序
        } else {
            static::$aliases[$root][$alias] = $path;
            krsort(static::$aliases[$root]);
        }
    } elseif (isset(static::$aliases[$root])) {
        //删除
        if (is_array(static::$aliases[$root])) {
            unset(static::$aliases[$root][$alias]);
        } elseif ($pos === false) {
            unset(static::$aliases[$root]);
        }
    }
}
```
#### 获取别名 getAlias
```php
public static function getAlias($alias, $throwException = true)
{
    //$alias 的第一个字符和 @ 比较，如果相等返回0，不相等返回的结果可能是1或-1进入if
    if (strncmp($alias, '@', 1)) {
        // not an alias
		// 不是别名，不是以 @ 开头
        return $alias;
    }
	// 别名是否带有 / ;例如：@yii/ding
    $pos = strpos($alias, '/');
    $root = $pos === false ? $alias : substr($alias, 0, $pos);

    if (isset(static::$aliases[$root])) {
		// 如果是字符串，则表示存的是路径
        if (is_string(static::$aliases[$root])) {
            return $pos === false ? static::$aliases[$root] : static::$aliases[$root] . substr($alias, $pos);
        }
        foreach (static::$aliases[$root] as $name => $path) {
			// 在 $alias/ 中匹配 $name/ ,如果存在，就截取路径
            if (strpos($alias . '/', $name . '/') === 0) {
                return $path . substr($alias, strlen($name));
            }
        }
    }

    if ($throwException) {
        throw new InvalidParamException("Invalid path alias: $alias");
    }

    return false;
}
```
## 其他小方法  
### 创建对象  
创建对象最终是通过容器进行创建的，方便解决依赖  
```php
public static function createObject($type, array $params = [])
{
    // 字符串，代表一个类名、接口名、别名。
    if (is_string($type)) {
        // 全局容器获取实例，并解决其依赖关系
        return static::$container->get($type, $params);
    // 是个数组，代表配置数组，必须含有 class 元素。
    } elseif (is_array($type) && isset($type['class'])) {
        $class = $type['class'];
        unset($type['class']);
        return static::$container->get($class, $params, $type);
    // 是个PHP callable则调用其返回一个具体实例。
    } elseif (is_callable($type, true)) {
        // 解决回调函数的依赖
        return static::$container->invoke($type, $params);
    } elseif (is_array($type)) {
        throw new InvalidConfigException('Object configuration must be an array containing a "class" element.');
    }
    throw new InvalidConfigException('Unsupported configuration type: ' . gettype($type));
}
```
### 配置对象属性值  
通过数组配置对象对应的属性值  
```php
public static function configure($object, $properties)
{
    foreach ($properties as $name => $value) {
        $object->$name = $value;
    }

    return $object;
}
```
### 获取对象属性与值 数组
```php
public static function getObjectVars($object)
{
    return get_object_vars($object);
}
```

### 获取Yii版本
```php
public static function getVersion()
{
    return '2.0.12';
}
```
