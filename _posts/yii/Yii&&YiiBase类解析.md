## Yii.php  
主要任务  
1. 定义Yii类，只是继承了 BaseYii类  
2. 注册自动加载  
3. 定义自动加载 映射 数组  
4. 赋值容器  
```php
class Yii extends \yii\BaseYii
{
}
//注册自动加载
spl_autoload_register(['Yii', 'autoload'], true, true);
//设置类与路径的加载映射
Yii::$classMap = require(__DIR__ . '/classes.php');
// 容器
Yii::$container = new yii\di\Container();
```
## YiiBase
### 属性
```php
/**
 * @var array class map used by the Yii autoloading mechanism.
 * The array keys are the class names (without leading backslashes), and the array values
 * are the corresponding class file paths (or [path aliases](guide:concept-aliases)). This property mainly affects
 * how [[autoload()]] works.
 * @see autoload()
 */
public static $classMap = [];
/**
 * @var \yii\console\Application|\yii\web\Application the application instance
 */
public static $app;
/**
 * @var array registered path aliases
 * @see getAlias()
 * @see setAlias()
 */
public static $aliases = ['@yii' => __DIR__];
/**
 * @var Container the dependency injection (DI) container used by [[createObject()]].
 * You may use [[Container::set()]] to set up the needed dependencies of classes and
 * their initial property values.
 * @see createObject()
 * @see Container
 */
public static $container;
```

#### 获取Yii版本
```php
public static function getVersion()
{
    return '2.0.12';
}
```
### 别名
#### 设置别名 setAlias
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
### 自动加载  
```php
public static function autoload($className)
{		
		// 是否在定义的 类加载映射文件  
    if (isset(static::$classMap[$className])) {
        $classFile = static::$classMap[$className];
        if ($classFile[0] === '@') {
            $classFile = static::getAlias($classFile);
        }
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
### 创建对象  
```php
public static function createObject($type, array $params = [])
{
    if (is_string($type)) {
        return static::$container->get($type, $params);
    } elseif (is_array($type) && isset($type['class'])) {
        $class = $type['class'];
        unset($type['class']);
        return static::$container->get($class, $params, $type);
    } elseif (is_callable($type, true)) {
        return static::$container->invoke($type, $params);
    } elseif (is_array($type)) {
        throw new InvalidConfigException('Object configuration must be an array containing a "class" element.');
    }

    throw new InvalidConfigException('Unsupported configuration type: ' . gettype($type));
}
```
### 配置对象属性值  
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
### 国际化  

```php
public static function t($category, $message, $params = [], $language = null)
{
    if (static::$app !== null) {
        return static::$app->getI18n()->translate($category, $message, $params, $language ?: static::$app->language);
    }
    $placeholders = [];
    foreach ((array) $params as $name => $value) {
        $placeholders['{' . $name . '}'] = $value;
    }
    //字符串替换
    return ($placeholders === []) ? $message : strtr($message, $placeholders);
}
```
### 日志  
