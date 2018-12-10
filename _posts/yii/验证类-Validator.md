// 配置的验证已有错误是否跳过后续验证
// 配置的属性为空值是否跳过
$skip = $this->skipOnError && $model->hasErrors($attribute)
    || $this->skipOnEmpty && $this->isEmpty($model->$attribute);
if (!$skip) {
    
    if ($this->when === null || call_user_func($this->when, $model, $attribute)) {
        $this->validateAttribute($model, $attribute);
    }
}
