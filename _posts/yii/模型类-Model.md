---
title: Yii-model
date: 2017-07-03 11:56:02
tags:
	- yii
	- model
	- 验证器
categories:
    - yii
    - model
---
## 前言  
简单的接收数据的表单，使用继承自  `Model` 类的模型即可，如果是需要增删改之类的牵扯到表的则用 `Active Record 活动记录`(也是继承自 `Model`)    
> 下面所述，字段和属性一个意思  

## 像数组一样访问和遍历模型  
可像访问数组单元项一样访问属性，这要感谢 `yii\base\Model` 支持 `ArrayAccess` 数组访问[参考链接](https://www.bunao.win/2018/10/11/php/%E5%AF%B9%E8%B1%A1%E6%95%B0%E7%BB%84-ArrayAccess/) 和 `ArrayIterator` 数组迭代器[参考链接](https://www.bunao.win/2018/10/11/php/%E8%BF%AD%E4%BB%A3%E5%99%A8-Iterator/):
```php
public function actionModel()
{
    $model = new TestForm;
    // 显示所有的公有属性
    var_dump($model->attributes);
    //  yii\base\Model 支持 ArrayAccess 数组访问 可以像访问数组但愿项一样访问属性
    $model['name'] = 'example';
    echo $model['name'];

    // Model 支持 ArrayIterator 数组迭代器，迭代器遍历模型，访问所有的公有属性  
    foreach ($model as $name => $value) {
        echo "$name: $value\n";
    }
}
```
<!-- more -->
## 属性标签  
属性标签多用在小部件展示字段的时候显示的字段名，默认情况下，属性标签通过 `yii\base\Model::generateAttributeLabel()` 方法自动从属性名生成. 它会自动将驼峰式大小写变量名转换为多个首字母大写的单词， 例如 `username` 转换为 `Username` ， `firstName` 转换为 `First Name`。

### 获取属性标签  
获取 `name` 字段的属性标签  
```php
$model->getAttributeLabel('name');
```
### 手动设置属性标签  
自定义属性标签  
```php
public function attributeLabels()
{
    return [
        'name' => 'Your name',
    ];
}
```
## 场景  
一个模型可以根据不同的场景所支持的字段来执行对应的验证或块赋值，从而实现一个Model对应可以对应多个不同业务。  

例如 `User` 模块可能会在收集用户登录输入， 也可能会在用户注册时使用。在不同的场景下， 模型可能会使用不同的业务规则和逻辑， 例如 `email` 属性在注册时强制要求有，但在登陆时不需要。  

### 定义场景  
默认情况下，模型支持一个名为 `default` 的场景  

#### 方式一：在场景 `scenarios()` 方法中定义  
```php
class User extends ActiveRecord
{
    const SCENARIO_LOGIN = 'login';
    const SCENARIO_REGISTER = 'register';
    //定义场景  
    public function scenarios()
    {
        return [
            self::SCENARIO_LOGIN => ['username', 'password'],
            self::SCENARIO_REGISTER => ['username', 'email', 'password'],
        ];
    }
}
```
#### 方式二：在规则 `rolus()` 方法中定义
直接在规则 `rolus()` 方法中 使用 `on` 来指定场景，没使用 `on` 将 **用在所有场景中**    
> 这里的所有场景是指规则中所有通过 `on` 或 `except` 定义的场景  

使用规则如下，请按照顺序  
1. 如果 `on` 没有指定场景，这条规则上的字段将会添加到所有的场景  
2. 如果 `on` 没有指定场景，而使用 `except` 指定场景，那么这条规则上的字段将作用于除了 `except` 指定场景外的所有场景  
3. 如果 `on` 指定了场景，那这条规则上的字段就将会使用所指定的场景  

```php
public function rules()
{
    return [
        // 在"register" 场景下 username, email 和 password 必须有值
        [['username', 'email', 'password'], 'required', 'on' => 'register'],

        // 在 "login" 场景下 username 和 password 必须有值
        [['username', 'password'], 'required', 'on' => 'login'],
    ];
}
```
#### 两种方式定义规则方式的区别   
其实两种方式是一样的，第一种方式更加清楚一些，而第二种方法更加灵活一些。我们看一下第二种是怎么实现的。  
其实就是将规则 `rules` 中定义的场景提取出来
```php
public function scenarios()
{
    // 默认场景
    $scenarios = [self::SCENARIO_DEFAULT => []];
    // 遍历rules定义的所有的验证器
    foreach ($this->getValidators() as $validator) {
        // rule数组中定义的场景 on=>scenario
        foreach ($validator->on as $scenario) {
            $scenarios[$scenario] = [];
        }
        // 验证规则中除去某个场景都验证的情况 except=>scenario
        foreach ($validator->except as $scenario) {
            $scenarios[$scenario] = [];
        }
    }
    // 获取所有的场景
    $names = array_keys($scenarios);

    // 将字段添加到对应的场景中
    foreach ($this->getValidators() as $validator) {
        // 如果 某个 rule 中没有定义场景
        // 表示这个rule中所有的字段用在所有的场景中
        if (empty($validator->on) && empty($validator->except)) {
            foreach ($names as $name) {
                foreach ($validator->attributes as $attribute) {
                    $scenarios[$name][$attribute] = true;
                }
            }
        // 如果 rule 没有定义使用的场景 on
        } elseif (empty($validator->on)) {
            foreach ($names as $name) {
                // 如果不在定义的排除 except 的场景
                if (!in_array($name, $validator->except, true)) {
                    foreach ($validator->attributes as $attribute) {
                        $scenarios[$name][$attribute] = true;
                    }
                }
            }
        // 如果定义了使用的场景 on
        } else {
            foreach ($validator->on as $name) {
                foreach ($validator->attributes as $attribute) {
                    $scenarios[$name][$attribute] = true;
                }
            }
        }
    }
    // 除去没用到的场景
    foreach ($scenarios as $scenario => $attributes) {
        if (!empty($attributes)) {
            $scenarios[$scenario] = array_keys($attributes);
        }
    }

    return $scenarios;
}
```  

### 使用场景  
如下展示两种设置场景的方法:
```php
// 场景作为属性来设置
$model->scenario = 'login';

// 场景通过构造初始化配置来设置
$model = new Model(['scenario' => 'login']);
```

## 验证规则  
为什么写在场景之后，因为用到场景啊  

### 示例  

先看一下下面的内容，之后我们在分析原理，内容来自[官方文档](https://www.yiichina.com/doc/guide/2.0/structure-models)  

当模型接收到终端用户输入的数据，数据应当满足某种规则(称为 验证规则, 也称为 业务规则)。

可调用 `yii\base\Model::validate()` 来验证接收到的数据， 该方法使用 `yii\base\Model::rules()` 申明的验证规则来验证每个相关属性， 如果没有找到错误，会返回 `true`， 否则它会将错误保存在 `yii\base\Model::errors` 属性中并返回 `false` ，例如：
```php
$model = new \app\models\ContactForm;

// 用户输入数据赋值到模型属性
$model->attributes = \Yii::$app->request->post('ContactForm');
// 验证数据
if ($model->validate()) {
    // 所有输入数据都有效 all inputs are valid
} else {
    // 验证失败：$errors 是一个包含错误信息的数组
    $errors = $model->errors;
}
```
通过覆盖 `yii\base\Model::rules()` 方法指定 模型属性应该满足的规则来申明模型相关验证规则。 下述例子显示ContactForm模型申明的验证规则:
```php
public function rules()
{
    return [
        // name, email, subject 和 body 属性必须有值
        [['name', 'email', 'subject', 'body'], 'required'],

        // email 属性必须是一个有效的电子邮箱地址
        ['email', 'email'],
    ];
}
```
一条规则可用来验证一个或多个属性，一个属性可对应一条或多条规则。

有时你想一条规则只在某个 场景 下应用， 为此你可以指定规则的 `on` 属性，如下所示:
```php
public function rules()
{
    return [
        // 在"register" 场景下 username, email 和 password 必须有值
        [['username', 'email', 'password'], 'required', 'on' => 'register'],

        // 在 "login" 场景下 username 和 password 必须有值
        [['username', 'password'], 'required', 'on' => 'login'],
    ];
}
```
如果没有指定 `on` 属性，规则会在所有场景下应用， 在当前 `yii\base\Model::scenario` 下应用的规则称之为 `active rule`活动规则。

一个属性只会属于`scenarios()`中定义的活动属性且在 `rules()` 申明对应一条或多条活动规则的情况下被验证。
### 原理  
根据 `rules` 中定义的规则生成验证器，然后在根据场景来获取到需要验证的字段进行验证  

### 使用  

#### rules 配置  
下面随便写几条规则理解一下  
```php
public function rules()
{
    return [
        // 在"register" 场景下 username, email 和 password 必须有值
        [['username', 'email', 'password'], 'required', 'on' => 'register'],
		// 验证之前会先执行 when 定义的匿名函数，如果返回的true才往后进行验证。 参数：(当前模型对象, 验证的属性)
        [['username', 'email', 'password'], 'required', 'when' => function ($model, $attribute){}],
		// 通过匿名函数进行校验         参数：(验证的属性, 规则中定义的params, InlineValidator对象)
        [['username', 'email', 'password'], function ($attribute, $params, $validator){}, 'params' => ['a', 'b']],
		// 使用当前model中的 myValidator() 方法进行验证
		[['username', 'email', 'password'], 'myValidator'],
        // 除了 register 场景,其他场景 username 和 password 必须有值; skipOnError = false 时，如果之前的验证器出现验证错误，该验证器依旧进行验证;  message 配置自定义的错误信息
        [['!username', 'password'], 'required', 'except' => 'register', 'skipOnError' => false, 'message' => 'Please choose a username.'],
    ];
}
```  
> 以 !开头的属性为 非安全属性(只验证，不赋值)  

#### yii自定义的验证器了解一下   
`yii\validators\Validator` 类中定义了一些常用的验证器，去了解一下   

### 相关方法  
#### 返回当前场景需要验证的字段  
```php
# 返回当前场景需要验证的字段，包括以 !开头的 非安全属性(只验证，不赋值)    
activeAttributes()
```
#### 返回当前场景 所有/某字段 有效的验证器  
```php
# 如果 $attribute = null 返回当前场景有效的验证器
# 如果 $attribute = 字段值 返回 该字段 在当前场景下所有的验证器  
getActiveValidators($attribute = null)
```
#### 验证 validate   
默认验证所有需要验证的字段，可以指定验证的字段  
```php
# 如果传 $attributeNames = ['字段1', '字段2'] 将会只验证这两个字段  
validate($attributeNames = null, $clearErrors = true)
```
#### 关于验证器的属性配置   
在验证属性的时候用到了验证器的两个属性 `skipOnError` 和 `skipOnEmpty` , 分别表示当如果之前的验证器已经有错误是否跳过和该字段值为空时是否跳过验证。跳过验证后将不会进行验证，也就不发获取到全部的验证错误信息  

**如果需要获取所有的验证错误信息，需要在配置 `rules` 时将 `skipOnError` 配置上去，值为 `false`**  

#### 几个和error相关的方法  
```php
# 给属性添加错误信息，一般自定义验证方法的时候会用到  
addError($attribute, $error = '')
# 上面的复数形式  
addErrors(array $items)
# 获取 所有/指定的属性 是否有验证错误  
hasErrors($attribute = null)
# 获取 所有/指定的属性 的验证错误信息  
getErrors($attribute = null)
# 清除 所有/指定的属性 的验证错误信息  
clearErrors($attribute = null)
# 获取该属性的第一个错误信息  
getFirstError($attribute)
# 获取所有属性的第一个错误信息
getFirstErrors()
```
### 临时验证   
有时，你需要对某些没有绑定任何模型类的值进行 临时验证。

若你只需要进行一种类型的验证 (e.g. 验证邮箱地址)，你可以调用所需验证器的 `validate()`` 方法。像这样：
```php
$email = 'test@example.com';
$validator = new yii\validators\EmailValidator();

if ($validator->validate($email, $error)) {
    echo '有效的 Email 地址。';
} else {
    echo $error;
}
```

## 块赋值  
### setAttributes() 块赋值  
块赋值只用一行代码将用户所有输入填充到一个模型，非常方便， 它直接将输入数据对应填充到 `yii\base\Model::attributes()` 属性。 以下两段代码效果是相同的， 都是将终端用户输入的表单数据赋值到 ContactForm 模型的属性， 明显地前一段块赋值的代码比后一段代码简洁且不易出错。
```php
$model = new \app\models\ContactForm;
$model->attributes = \Yii::$app->request->post('ContactForm');

$model = new \app\models\ContactForm;
$data = \Yii::$app->request->post('ContactForm', []);
$model->name = isset($data['name']) ? $data['name'] : null;
$model->email = isset($data['email']) ? $data['email'] : null;
$model->subject = isset($data['subject']) ? $data['subject'] : null;
$model->body = isset($data['body']) ? $data['body'] : null;
```
> 块赋值调用的是 `setAttributes($values, $safeOnly = true)` 方法，第二个参数默认为 `true` ,表示需要 `rolus()` 方法在声明了的字段(属性)且字段前面没有 `!` 才给赋值(赋值，并验证)，改为 `false` 表示只要对应的有这个属性(字段)，就给赋值  

### load() 表单块赋值  
通过表单上传的数据通常是通过 `load` 进行块赋值的(前端用到表单小部件的情况，因为表单小部件默认会在表单提交的name属性值带上 `$model->formName()` 来对应该模型)。当然也可以手动指定 `$formName` 值为自定义的值  
```php
public function load($data, $formName = null)
{
    // form表名
    $scope = $formName === null ? $this->formName() : $formName;
    // 如果没有表单名
    if ($scope === '' && !empty($data)) {
        $this->setAttributes($data);

        return true;
    // 如果有表名，获取表单名下的数据
    // 获取提交的类名下的数据
    } elseif (isset($data[$scope])) {
        $this->setAttributes($data[$scope]);

        return true;
    }
    return false;
}
```
> 哈哈，其实还是用的 `setAttributes()` 嘛，就是用表单小部件的时候用这个方便  


## 数据导出 toArray()  
其实这个应该放在 `restful` 和 `AR模型` 是分析的，这里先简单看一下用法[下面都是官网的](https://www.yiichina.com/doc/guide/2.0/structure-models)  


**默认情况下，字段名对应属性名，但是你可以通过覆盖 `fields()` 和/或 `extraFields()` 方法来改变这种行为， 两个方法都返回一个字段定义列表，`fields()` 方法定义的字段是默认字段， 表示 `toArray()` 方法默认会返回这些字段。 `extraFields()` 方法定义额外可用字段， 通过`toArray()`方法指定`$expand`参数来返回这些额外可用字段。** 例如如下代码会返回`fields()`方法定义的所有字段和`extraFields()`方法定义的`prettyName` and `fullAddress`字段。
```php
// toArray(array $fields = [], array $expand = [], $recursive = true) 方法参数
$array = $model->toArray([], ['prettyName', 'fullAddress']);
```
可通过覆盖 `fields()` 来增加、删除、重命名和重定义字段， `fields()` 方法返回值应为数组， 数组的键为字段名，数组的值为对应的可为属性名或匿名函数返回的字段定义对应的值。 特使情况下，如果字段名和属性定义名相同，可以省略数组键， 例如：
```php
// 明确列出每个字段，特别用于你想确保数据表或模型
// 属性改变不会导致你的字段改变(保证后端的API兼容)。
public function fields()
{
    return [
        // 字段名和属性名相同
        'id',

        // 字段名为 "email"，对应属性名为 "email_address"
        'email' => 'email_address',

        // 字段名为 "name", 值通过PHP代码返回
        'name' => function () {
            return $this->first_name . ' ' . $this->last_name;
        },
    ];
}

// 过滤掉一些字段，特别用于
// 你想继承父类实现并不想用一些敏感字段
public function fields()
{
    $fields = parent::fields();

    // 去掉一些包含敏感信息的字段
    unset($fields['auth_key'], $fields['password_hash'], $fields['password_reset_token']);

    return $fields;
}
```
> 警告： 由于模型的所有属性会被包含在导出数组，最好检查数据确保没包含敏感数据， 如果有敏感数据，应覆盖 `fields()` 方法过滤掉， 在上述列子中，我们选择过滤掉 `auth_key`, `password_hash` and `password_reset_token`  
