---
title: vue 学习
date: 2017-07-01 11:56:02
tags:
  - vue
categories: vue
---

> vue中 **数据和DOM** 是绑定的，**动态响应的**，数据改变，对应的DOM也会发生改变  

### 属性与方法

**每个 Vue 实例都会代理其 data 对象里所有的属性：**
```js
var data = { a: 1 }
var vm = new Vue({
  data: data
})
vm.a === data.a // -> true
// 设置属性也会影响到原始数据
vm.a = 2
data.a // -> 2
// ... 反之亦然
data.a = 3
vm.a // -> 3
```
注意只有这些被代理的属性是响应的，也就是说值的任何改变都是触发视图的重新渲染。如果在实例创建之后添加新的属性到实例上，它不会触发视图更新。  
除了 data 属性， Vue 实例暴露了一些有用的 **实例属性与方法** 。这些属性与方法都有 **前缀 $**，以便与代理的 data 属性区分。例如：
```js
var data = { a: 1 }
var vm = new Vue({
  el: '#example',
  data: data
})
vm.$data === data // -> true
vm.$el === document.getElementById('example') // -> true
// $watch 是一个实例方法
vm.$watch('a', function (newVal, oldVal) {
  // 这个回调将在 `vm.a`  改变后调用
})
```
> 注意，不要在实例属性或者回调函数中（如 `vm.$watch('a', newVal => this.myMethod())`）使用箭头函数。因为箭头函数绑定父级上下文，所以 `this` 不会像预想的一样是 `Vue` 实例，而是 `this.myMethod` 未被定义。  

### 声明周期  
每个 Vue 实例在被创建之前都要经过一系列的初始化过程。例如，实例需要配置数据观测(data observer)、编译模版、挂载实例到 DOM ，然后在数据变化时更新 DOM 。在这个过程中，实例也会调用一些 生命周期钩子 ，这就给我们提供了执行自定义逻辑的机会。例如，created 这个钩子在实例被创建之后被调用：
```js
var vm = new Vue({
  data: {
    a: 1
  },
  created: function () {
    // `this` 指向 vm 实例
    console.log('a is: ' + this.a)
  }
})
// -> "a is: 1"
```
也有一些其它的钩子，在实例生命周期的不同阶段调用，如 `mounted、updated、destroyed`。钩子的 this 指向调用它的 Vue 实例。
**声明周期图**  
![声明周期图](https://cn.vuejs.org/images/lifecycle.png)   

## 模版语法  
