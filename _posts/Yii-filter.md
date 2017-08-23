---
title: Yii-过滤器
date: 2017-07-03 11:56:02
tags:
	- yii
	- 过滤器
categories:
    - yii
    - 过滤器
---
## 过滤器 Filters
> 过滤器是 **`控制器 动作` 执行之前或之后执行的对象**。 例如访问控制过滤器可在动作执行之前来控制特殊终端用户是否有权限执行动作， 内容压缩过滤器可在动作执行之后发给终端用户之前压缩响应内容。

> 过滤器可包含 **预过滤**（过滤逻辑在动作之前） 或 **后过滤**（过滤逻辑在动作之后）， 也可同时包含两者。

> 通过配置 `only属性` 来给定使用过滤器的 动作action ，配置 `except属性` 来给定那些 动作action 不使用过滤器  

### 使用过滤器
**过滤器本质上是一类特殊的 行为(behaviors)，所以使用过滤器和 使用 行为一样**。 可以在控制器类中覆盖它的 ` yii\base\Controller::behaviors()` 方法来申明过滤器， 如下所示：
```php
public function behaviors()
{
    return [
        [
            'class' => 'yii\filters\HttpCache',
            'only' => ['index', 'view'],
            'lastModified' => function ($action, $params) {
                $q = new \yii\db\Query();
                return $q->from('user')->max('updated_at');
            },
        ],
    ];
}
```
控制器类的过滤器默认应用到该类的 所有 动作， 你可以配置 **only属性** 明确指定控制器应用到哪些动作。 在上述例子中， HttpCache 过滤器只应用到index和view动作。 也可以配置 **except属性** 使一些动作不执行过滤器。

除了控制器外，可在 模块或应用主体 中申明过滤器。 申明之后，过滤器会应用到所属该模块或应用主体的 所有 控制器动作， 除非像上述一样配置过滤器的 only 和 except 属性。

> 注意: 在模块或应用主体中申明过滤器，在 **only 和 except 属性中使用路由 代替动作ID**， 因为在模块或应用主体中只用动作ID并不能唯一指定到具体动作。

当一个动作有多个过滤器时，根据以下规则先后执行：  
**预过滤**
1. 按顺序执行应用主体中 `behaviors()` 列出的过滤器。
2. 按顺序执行模块中 `behaviors()` 列出的过滤器。
3. 按顺序执行控制器中 `behaviors()` 列出的过滤器。
4. 如果任意过滤器终止动作执行， 后面的过滤器（包括预过滤和后过滤）不再执行。

成功通过预过滤后执行动作。  

**后过滤**
1. 倒序执行控制器中 `behaviors()` 列出的过滤器。
2. 倒序执行模块中 `behaviors()` 列出的过滤器。
3. 倒序执行应用主体中 `behaviors()` 列出的过滤器。

### 创建过滤器
继承 `yii\base\ActionFilter` 类并覆盖 `beforeAction()` 和/或 `afterAction()` 方法来创建动作的过滤器，前者在动作执行之前执行，后者在动作执行之后执行。 `beforeAction()` 返回值决定动作是否应该执行， 如果为`false`，之后的过滤器和动作不会继续执行。  

下面的例子申明一个记录动作执行时间日志的过滤器。  
```php
namespace app\components;

use Yii;
use yii\base\ActionFilter;

class ActionTimeFilter extends ActionFilter
{
    private $_startTime;

    public function beforeAction($action)
    {
        $this->_startTime = microtime(true);
        return parent::beforeAction($action);
    }

    public function afterAction($action, $result)
    {
        $time = microtime(true) - $this->_startTime;
        Yii::trace("Action '{$action->uniqueId}' spent $time second.");
        return parent::afterAction($action, $result);
    }
}
```
