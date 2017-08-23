---
title: Yii-model
date: 2017-07-03 11:56:02
tags:
	- yii
	- model
categories:
    - yii
    - model
---

简单的接收数据的表单，使用继承自  `Model` 类的模型即可，如果是需要增删改之类的牵扯到表的则用 `Active Record 活动记录`(也是继承自 `Model`)  

## Model 类

### 属性  
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
### 属性标签  
> 属性标签多用在小部件展示字段的时候显示的字段名  

获取属性标签  
$model->getAttributeLabel('name');

手动设置属性标签  
public function attributeLabels()
{
    return [
        'name' => 'Your name',
    ];
}

### 场景  
> 不同的场景执行不同字段的验证，实现一个Model对应可以对应多个不同业务的表单  

模型可能在多个 场景 下使用，例如 User 模块可能会在收集用户登录输入， 也可能会在用户注册时使用。在不同的场景下， 模型可能会使用不同的业务规则和逻辑， 例如 email 属性在注册时强制要求有，但在登陆时不需要。  

模型使用 `yii\base\Model::scenario` 属性保持使用场景的跟踪， 默认情况下，模型支持一个名为 `default` 的场景， 如下展示两种设置场景的方法:
```php
// 场景作为属性来设置
$model->scenario = 'login';

// 场景通过构造初始化配置来设置
$model = new Model(['scenario' => 'login']);
```
定义场景验证规则：
方式一：直接在场景方法中定义  
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
方式二：直接在规则 `rolus()` 方法中 使用 `on` 来指定场景，没使用 `on` 将用在所有场景中    
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
场景特性主要在验证 和 属性块赋值 中使用。

### 验证规则
当模型接收到终端用户输入的数据，数据应当满足某种规则(称为 验证规则, 也称为 业务规则)。 例如假定 `ContactForm` 模型， 你可能想确保所有属性不为空且 `email` 属性包含一个有效的邮箱地址， 如果某个属性的值不满足对应的业务规则， 相应的错误信息应显示，以帮助用户修正错误。

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

> 一个属性只会属于`scenarios()`中定义的活动属性且在 `rules()` 申明对应一条或多条活动规则的情况下被验证。

### 块赋值
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
> 块赋值调用的是 `setAttributes()` 方法，有两个参数，第二个参数默认为 `true` ,表示需要 `rolus()` 方法在声明了的字段(属性)且字段前面没有 `!` 才给赋值(只是赋值，并验证)，改为 `false` 表示只要对应的有这个属性(字段)，就给赋值  

### 非安全属性
如上所述，`yii\base\Model::scenarios()` 方法提供两个用处：定义哪些属性应被验证，定义哪些属性安全。 在某些情况下，你可能想验证一个属性但不想让他是安全的， 可在scenarios()方法中属性名加一个惊叹号 `!`。 例如像如下的 `secret` 属性。
```php
public function scenarios()
{
    return [
        'login' => ['username', 'password', '!secret'],
    ];
}
```
> 当模型在 `login` 场景下，三个属性都会被验证， 但只有 `username`和 `password` 属性会被块赋值， 要对 `secret`属性赋值，必须像如下例子明确对它赋值。

```php
$model->secret = $secret;
The same can be done in rules() method:

public function rules()
{
    return [
        [['username', 'password', '!secret'], 'required', 'on' => 'login']
    ];
}
```
> 加了`!`的只能单独赋值才能赋值，没想到有什么情景会用到  

### 数据导出
模型通常要导出成不同格式，例如，你可能想将模型的一个集合转成JSON或Excel格式， 导出过程可分解为两个步骤，  
第一步，模型转换成数组；  
第二步，数组转换成所需要的格式。   
你只需要关注第一步，因为第二步可被通用的 数据转换器如`yii\web\JsonResponseFormatter`来完成。

将模型转换为数组最简单的方式是使用 `yii\base\Model::attributes()` 属性， 例如：
```php
$post = \app\models\Post::findOne(100);
$array = $post->attributes;
```

## AR
### rules规则  
