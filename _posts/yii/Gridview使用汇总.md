---
title: Gridview使用汇总
date: 2019-2-22 20:00:02
tags:
    - yii
    - gridview
categories:
    - yii  
---


## 列相关  
先看一个gii生成的正常状态下的Gridview  
```php
GridView::widget([
    'dataProvider' => $dataProvider,
    'filterModel' => $searchModel,
    'columns' => [
        // ['class' => 'yii\grid\SerialColumn'],
        ['class' => 'yii\grid\CheckboxColumn'],

        'id',
        'user_id',
        'goods_id',
        'need_num',
        'has_num',
        'status',
        'created_at:datetime',
        'end_time:datetime',
        //'updated_at',
        //'ver',

        ['class' => 'yii\grid\ActionColumn'],
    ],
]);
```
我们要修改展示内容，修改的就是 `columns` 下的值  

### 格式化列的值    
一般修改一个列的值的使用格式如下，将数值对应成文字    
```php
[
    'attribute' => 'groupon_status',  # 对应的属性
    'label' => '团购状态',  # 列的title
    'value' => function($model) { # 根据对应的属性值返回要显示的数据
        return $model->groupon_status == 1 ? '进行中' : '已成团';
    },
],
```
当然为了方便，yii也提供了一些特有的格式化  
格式化时间戳     
```php
[
    'time:datetime', # 时间戳格式化成时间
]
```

下面罗列一下额外的参数配置  

### 单元格显示html  
默认是过滤html的  
```php
[
    'attribute' => 'groupon_id',
    'label' => '团购信息',
    'format'=>'raw',// 一定要设置这个才可以显示html
    'value' => function($model)
    {
        $url = "/groupon/view?id=".$model->groupon_id;
        return Html::a('点击查看团购信息', $url, ['title' => '点击查看团购信息']);
    },
],
```
### 自定义按钮  
```php
[
    [
    	'class' => 'yii\grid\ActionColumn',
    	'template' => '{view} {update} {delete}',
    	'header' => '操作',
    	'buttons' => [
    		'view'=> function ($url, $model, $key){
    			$str = '<span class="glyphicon glyphicon-eye-open"></span>';
    			return Html::a($str, null,  ['lay-href' => Url::to(['view', 'id'=>$model->id])]) ;
    		},
    		'update'=> function ($url, $model, $key){
    			$str = '<span class="glyphicon glyphicon-pencil"></span>';
    			return Html::a($str, null,  ['lay-href' => Url::to(['update', 'id'=>$model->id])]) ;
    		},
    		'delete'=> function ($url, $model, $key){
    			$str = $model->putaway ? '下架' : '上架';
    			return Html::a($str, ['putaway', 'id'=>$model->id],
    				[
        				'data-confirm' => '确定'.$str.'该商品？', //添加确认框
        				'style' => $model->putaway ? '':'color:red'
        			]) ;
    		}
    	],
    ],
]
```
### 搜索改为下拉框  
```php
[
    'attribute' => 'groupon_status',  # 对应的属性
    'label' => '团购状态',  # 列的title
    'value' => function($model) { # 根据对应的属性值返回要显示的数据
        return $model->groupon_status == 1 ? '进行中' : '已成团';
    },
    'filter' => [ 1 => '进行中', 2 => '已成团']  # 搜索框改成下拉选项
],
```
### 列title不使用排序功能   
```php
[
    'attribute' => 'groupon_status',  # 对应的属性
    'label' => '团购状态',  # 列的title
    'enableSorting'=>false, # 不使用排序功能  
],
```
这个可以在gii生成的对应的 `search` 模型中进行更改，相对比较麻烦  
```php
public function search($params)
{
    $query = Groupon::find();

    $dataProvider = new ActiveDataProvider([
        'query' => $query,
    ]);

    // 排序功能，只有写在attributes里面的属性才会有排序功能
    $dataProvider->setSort([
        'attributes' => [
            'groupon_status',
        ]
    ]);
}
```
### headerOptions 控制列属性 样式  
针对于列样式，GridView提供了3个属性，分别为 `headerOptions` 、 `contentOptions` 和 `footerOptions`(还没发现footer有实际用途)  
`headerOptions` 控制的是 `th` 的样式 也就是我们看到的title
`contentOptions` 控制的是 `td` 的样式 也就是我们看到的显示的列内容
```php
[
    'attribute' => 'groupon_status',  # 对应的属性
    'label' => '团购状态',  # 列的title
    'headerOptions' => ['style'=>'color:red'], # title的文字颜色改成红色
    'contentOptions' => ['style'=>'color:blue;min-width:100px;'], # 列文字改成绿色，列宽设置最小为100px  
],
```
### 隐藏列  
GridView列的visible属性，此属性默认为true代表此列显示，通过设置visible属性可以隐藏一列，这种隐藏非css的display:none，而是在渲染表格的时候就去掉了此列。visible是可以传递一个表达式，实现逻辑判断，比如下面的需求当1号管理员登录的时候可以看到省市一列。
```php
[
    'attribute' => 'groupon_status',  # 对应的属性
    'label' => '团购状态',  # 列的title
    'visible' =>  (Yii::$app->admin->id === 1) # 只有id === 1 的才显示这一列  
],
```
### 增加列表勾选框列  
在cloumns中加入以下代码  虽然不知道有什么用处  
```php
['class' => 'yii\grid\CheckboxColumn'],
```

## 行相关  
### rowOptions 管理tbody下tr的属性  
```php
GridView::widget([
    'dataProvider' => $dataProvider,
    'filterModel' => $searchModel,
    'caption'=>"会员列表", # 显示table的标题
    'captionOptions' => ['style' => 'color:red'], # 控制caption的属性  
    'columns' => [
        ...
    ],
    /**
     * $model 当前对象
     * $key 当前对象的主键
     * $index 当前页面第几行，从0开始
     * $grid Gridview 对象
     *
     * goods_id 等于 11 的行背景改为红色  
     */
    'rowOptions'=>function($model, $key, $index, $grid){
        if($model->goods_id == 11){
            return ['style'=>'background:red'];
        }
    }
]);
```

### beforeRow和afterRow 行前行后增加要显示的数据  
这是一对非常灵活的属性，它们接收一个匿名函数。分别表示在渲染了一行之前和之后发生点什么  
要记住的是，匿名函数返回的结果也会作为一行纳入到渲染过程，比如当我们遇到奇数的时候就在此行下面添加一行，可以如下代码  
```php
GridView::widget([
    'dataProvider' => $dataProvider,
    'columns'=>[
        .....
    ],
    /**
     * $model 当前对象
     * $key 当前对象的主键
     * $index 当前页面第几行，从0开始
     * $grid Gridview 对象
     */
    'afterRow'=>function($model, $key, $index, $grid){
        if(($index+1)%2 != 0){
            return "<tr><td colspan='4'>我是基数</td></tr>";
        }
    }
]);
```

## 整体显示相关  
### 更改layout  
layout表示列表显示的样式，一个列表有三个部分组成 `items` 列表部分、`summary` 显示第几页共几页的部分、 `pages` 分页部分
![引用图片](https://user-gold-cdn.xitu.io/2018/6/14/163fd14c7acd08dc?w=1744&h=666&f=jpeg&s=122564)  

更改显示顺序，把显示第几页共几页部分放到列表下面  
```php
GridView::widget([
    'dataProvider' => $dataProvider,
    'filterModel' => $searchModel,
    'layout'=>"{items}\n{summary}\n{pager}", # 显示调整
    'columns' => [
        ...
    ],
]);
```
#### 修改分页显示  
显示在右侧，并替换分页的显示的内容   
```php
GridView::widget([
    'dataProvider' => $dataProvider,
    'filterModel' => $searchModel,
    //重新定义分页样式
    'layout'=> '{items}<div class="text-right tooltip-demo">{pager}</div>',
    'pager'=>[
        //'options'=>['class'=>'hidden']//关闭分页
        'firstPageLabel'=>"First",
        'prevPageLabel'=>'Prev',
        'nextPageLabel'=>'Next',
        'lastPageLabel'=>'Last',
    ],
    'columns' => [
        ...
    ],
]);
```

### 不显示title和搜索框  
```php
GridView::widget([
    'dataProvider' => $dataProvider,
    'filterModel' => $searchModel,
    'showHeader'=>false, # 不显示title和搜索框  
    'columns' => [
        ...
    ],
]);
```
### 增加表的标题   
也就是增加table的caption，在table的上边显示标题  
```php
GridView::widget([
    'dataProvider' => $dataProvider,
    'filterModel' => $searchModel,
    'caption'=>"会员列表", # 显示table的标题
    'captionOptions' => ['style' => 'color:red'], # 控制caption的属性  
    'columns' => [
        ...
    ],
]);
```
### tableOptions和options属性 管理table属性      
这两个属性有的开发者可能会混淆，接下来我用一张图让你瞬间明白。  
![options](https://user-gold-cdn.xitu.io/2018/6/14/163fd150d07cd170?w=1726&h=836&f=jpeg&s=214974)  
就是说GridView渲染的时候首先弄出来一个div容器，这是这个GridView的代表，接下来在此容器内放各种元素，比如 `{summary}、{items}` 等等。
`options` 控制着 `div容器` 的属性，默认添加一个 `class="grid-view"`
`tableOptions` 控制着 `{items}` 表格table的属性，默认为其添加一个 `class="table table-striped table-bordered"`

### headerRowOptions 管理thead下的tr属性  
`headerRowOptions` 它管理的是thead下tr的属性。
### emptyCell 管理空单元格的显示  
emptyCell 又是一个小细节，如果一个单元格为空，用什么字符填充那？默认是 &nbsp，你可以重新指定。

## 控制分页显示数量  
这个可以在gii生成的对应的 `search` 模型中进行更改，相对比较麻烦  
```php
public function search($params)
{
    $query = Groupon::find();

    $dataProvider = new ActiveDataProvider([
        'query' => $query,
        # 设置分页大小
        'pagination' => ['pageSize' => 1],
    ]);
}
```
## 让关联字段带搜索和排序功能  
假设现在有一张团购表 `groupon` 通过Gridview进行展示，表中存有 `goods_id` 关联的是 `goods` 表的 `id`, `user_id` 关联的是 `user` 表的 `id`  
现在要在展示的时候把对应的id转换成名称，这就需要进行表的关联  

### 1. model中定义关联表  
AR模型类  
```php
class Groupon extends \yii\db\ActiveRecord
{
    .....
    .....

    /**
     * 关联user表
     * @return [type] [description]
     */
    public function getUser()
    {
        return $this->hasOne(User::className(), ['id' => 'user_id']);
    }
    /**
     * 关联商品表
     * @return [type] [description]
     */
    public function getGoods()
    {
        return $this->hasOne(GoodsModel::className(), ['id' => 'goods_id']);
    }
}
```
### 2. search 模型的修改  
gii根据AR模型类生成的search模型  
```php
class GrouponSearch extends Groupon
{
    // 定义属性和规则是为了让可以搜索   
    public $username;
    public $goodsName;
    public $goodsNo;
    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            ....
            // 添加属性规则，添加了才会有搜索
            [['username', 'goodsName', 'goodsNo'], 'safe'],
        ];
    }

    public function search($params)
    {
        $query = Groupon::find();
        // 进行联表，joinWith联表 即时加载 ，也就是用了in的搜索，减少查询次数  
        // 此处的user和goods对应的是model中定义的getUser和getGoods关联  
        $query->joinWith(['user']);
        $query->joinWith(['goods']);

        $dataProvider = new ActiveDataProvider([
            'query' => $query,
            # 设置分页大小
            'pagination' => ['pageSize' => 1],
        ]);

        // 排序功能(点击title进行排序)，定义在attributes中的属性才能使用排序功能
        $dataProvider->setSort([
            'attributes' => array_merge(self::attributes(),
            [
                'username' => [
                    'asc' => ['user.username' => SORT_ASC],
                    'desc' => ['user.username' => SORT_DESC],
                    'label' => 'Customer Name'
                ],
            ])
        ]);

        ...
        ...
        // 添加搜索过滤条件
        $query->andFilterWhere(['like', 'user.username', $this->username]) ;
        $query->andFilterWhere(['like', 'goods.goods_name', $this->goodsName]) ;
        $query->andFilterWhere(['like', 'goods.goods_no', $this->goodsNo]) ;
        return $dataProvider;
    }

}
```
### 3. 视图修改    
```php
GridView::widget([
    'dataProvider' => $dataProvider,
    'filterModel' => $searchModel,
    'columns' => [
        // ['class' => 'yii\grid\SerialColumn'],
        ['class' => 'yii\grid\CheckboxColumn'],

        'id',
        'user_id',
        [
            'label'=>'用户名',  
            'attribute' => 'username',  # search模型中定义的属性
            'value' => 'user.username' # 联表user对应的属性值
        ],
        [
            'label'=>'商品名',  
            'attribute' => 'goodsName',  # search模型中定义的属性
            'value' => 'goods.goods_name' # 联表goods对应的属性值
        ],
        [
            'label'=>'商品编号',  
            'attribute' => 'goodsNo',  # search模型中定义的属性
            'value' => 'goods.goods_no' # 联表goods对应的属性值
        ],
        'created_at:datetime',
        'end_time:datetime',

        ['class' => 'yii\grid\ActionColumn'],
    ],
]);
```

### 参考  
[Yii2的GridView使用大全](http://www.imooc.com/article/36206)   
[yii2数据列表插件-gridview](https://www.yiichina.com/code/906)  
[yii2-GridView在开发中常用的功能及技巧](https://segmentfault.com/a/1190000003765961)  
[Yii2-GridView 中让关联字段带搜索和排序功能](https://www.yiichina.com/tutorial/120)  
