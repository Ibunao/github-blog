


## this
> 在一个独立的函数调用中，根据是否是strict模式，this指向undefined或window
> 对象的方法中的this指向对象，但是方法中的函数this指向的是window或undefined
> this 指向函数外层，外层如果是对象，则指向此对象，如果不是则指向 `undefined` 或 `window`  


> 在一个方法内部，`this` 是一个特殊变量，它始终指向当前对象，也就是 `xiaoming` 这个变量。所以，`this.birth` 可以拿到xiaoming的birth属性。

```js
让我们拆开写：

function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25, 正常结果
getAge(); // NaN
```

如果以对象的方法形式调用，比如 `xiaoming.age()` ，该函数的 `this` 指向被调用的对象，也就是 `xiaoming`，
如果单独调用函数，比如 `getAge()` ，此时，该函数的 `this` 指向全局对象，也就是 `window`。

更坑爹的是，如果这么写：
```js
var fn = xiaoming.age; // 先拿到xiaoming的age函数
fn(); // NaN
```
也是不行的！要保证 `this` 指向正确，必须用 `obj.xxx()` 的形式调用！

由于这是一个巨大的设计错误，要想纠正可没那么简单。ECMA决定，在 **strict模式** 下让函数的 `this` 指向 `undefined`，因此，在strict模式下，你会得到一个错误：
```js
'use strict';

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var y = new Date().getFullYear();
        return y - this.birth;
    }
};

var fn = xiaoming.age;
fn(); // Uncaught TypeError: Cannot read property 'birth' of undefined
```
> 这个决定只是让错误及时暴露出来，并没有解决this应该指向的正确位置。

有些时候，喜欢重构的你把方法重构了一下：
```js
'use strict';

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - this.birth;
        }
        return getAgeFromBirth();
    }
};

xiaoming.age(); // Uncaught TypeError: Cannot read property 'birth' of undefined
```
结果又报错了！原因是this指针只在age方法的函数内指向xiaoming，在函数内部定义的函数，this又指向undefined了！（在非strict模式下，它重新指向全局对象window！）

修复的办法也不是没有，我们用一个that变量首先捕获this：
```js
'use strict';

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var that = this; // 在方法内部一开始就捕获this
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - that.birth; // 用that而不是this
        }
        return getAgeFromBirth();
    }
};

xiaoming.age(); // 25
```
用 `var that = this;` ，你就可以放心地在方法内部定义其他函数，而不是把所有语句都堆到一个方法中。
