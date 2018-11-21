---
title: Yii-安全组件
date: 2018-10-09 00:20:02
tags:
    - yii
    - 加解密
    - 安全
categories:
    - yii  
---

## 加密&解密 相关方法    
### 数据加密和解密  
#### encryptByPassword & decryptByPassword  
通过key 对原数据进行加密，每次加密后的生成的数据是不一样的，但是都可以通过它来解密出原来的数据    
```php
/**
 * 获取加密(编码)后的数据。
 * 和 decryptByPassword 配对使用
 * @param string $data the data to encrypt  要加密的数据
 * @param string $password the password to use for encryption  加密使用的key
 * @return string the encrypted data
 * @see decryptByPassword()
 * @see encryptByKey()
 */
public function encryptByPassword($data, $password)
{
    ...
}
```
<!-- more -->
通过上面加密的数据和key获得原数据  
```php
/**
 * 获取解密(解码)后的数据。
 * 和 encryptByPassword 配对使用
 * @param string $data the encrypted data to decrypt  加密后的数据
 * @param string $password the password to use for decryption 加密时使用的key
 * @return bool|string the decrypted data or false on authentication failure
 * @see encryptByPassword()
 */
public function decryptByPassword($data, $password)
{
    ...
}
```
**注意，encryptByPassword进行加密后的数据不是ASCII，也就是在显示的时候会乱码，可以通过base64_encode和base64_decode在外层包装下**  

实例：  
```php
public function actionIndex()
{
	echo $temp = Yii::$app->security->encryptByPassword("security","bunao");
	echo "<br/>";
	echo Yii::$app->security->decryptByPassword($temp,"bunao"); # security
	echo "<br/>";


	// 进行base64编码，防止乱码
	echo $temp = base64_encode(Yii::$app->security->encryptByPassword("security","bunao"));
	echo "<br/>";
	echo Yii::$app->security->decryptByPassword(base64_decode($temp),"bunao"); security
}
```

#### encryptByKey & decryptByKey  
这一对和上面的 `encryptByPassword & decryptByPassword` 基本一样，只是添加了一个参数对其进行了扩展，这样就可以通过一个常量和一个变量组成一个加密的key  
```php
/**
 * 获取加密(编码)后的数据。
 * 和 decryptByKey 配对使用
 * @param string $data the data to encrypt 要编码的数据
 * @param string $inputKey the input to use for encryption and authentication 加密使用的key
 * @param string $info optional context and application specific information, see [[hkdf()]] 和第二个参数共同生成加密的key
 * @return string the encrypted data
 */
public function encryptByKey($data, $inputKey, $info = null)
{
    ...
}

/**
 * 获取解密(解码)后的数据
 * 和encryptByKey 配对使用
 * Verifies and decrypts data encrypted with [[encryptByKey()]].
 * @param string $data the encrypted data to decrypt。加密后的数据
 * @param string $inputKey the input to use for encryption and authentication 加密使用的key1
 * @param string $info optional context and application specific information, see [[hkdf()]] 加密使用的key2
 * @return bool|string the decrypted data or false on authentication failure
 */
public function decryptByKey($data, $inputKey, $info = null)
{
    ...
}
```
**注意，encryptByPassword进行加密后的数据不是ASCII，也就是在显示的时候会乱码，可以通过base64_encode和base64_decode在外层包装下**  
实例：  
将用户id组合key  
```php
public function actionIndex()
{
	$userId = 30;
	echo $temp = Yii::$app->security->encryptByKey("security", "bunao", $userId);
	echo "<br/>";
	echo Yii::$app->security->decryptByKey($temp, "bunao", $userId);
	echo "<br/>";


	// 进行base64编码，防止乱码
	echo $temp = base64_encode(Yii::$app->security->encryptByKey("security", "bunao", $userId));
	echo "<br/>";
	echo Yii::$app->security->decryptByKey(base64_decode($temp), "bunao", $userId);
}
```
### token 的生成和验证  
#### maskToken & unmaskToken  
根据提供的字符串token，生成加密的token
```php
/**
 * 生成token 提供一个源token可以生成一些列加密的token，可以通过生成的token逆转出来源token  
 * csrf使用这个  
 * 和 unmaskToken 配对使用
 * Masks a token to make it uncompressible.
 * Applies a random mask to the token and prepends the mask used to the result making the string always unique.
 * Used to mitigate BREACH attack by randomizing how token is outputted on each request.
 * @param string $token An unmasked token.
 * @return string A masked token.
 * @since 2.0.12
 */
public function maskToken($token)
{
    // The number of bytes in a mask is always equal to the number of bytes in a token.
    $mask = $this->generateRandomKey(StringHelper::byteLength($token));
    return StringHelper::base64UrlEncode($mask . ($mask ^ $token));
}
```
对加密的token进行解密，获取原token，就可以判断token时候正确  
```php
/**
 * 解码
 * Unmasks a token previously masked by `maskToken`.
 * @param string $maskedToken A masked token. 加密的token
 * @return string An unmasked token, or an empty string in case of token format is invalid.
 * @since 2.0.12
 */
public function unmaskToken($maskedToken)
{
    $decoded = StringHelper::base64UrlDecode($maskedToken);
    $length = StringHelper::byteLength($decoded) / 2;
    // Check if the masked token has an even length.
    if (!is_int($length)) {
        return '';
    }
    return StringHelper::byteSubstr($decoded, $length, $length) ^ StringHelper::byteSubstr($decoded, 0, $length);
}
```
##### 实例：
###### csrf 实例
Yii csrf   
获取csrftoken  
```php
yii\web\Request
/**
 * 获取csrftoken
 * 如果cookie或session中不存在则生成csrftoken
 * @param bool $regenerate whether to regenerate CSRF token. When this parameter is true, each time 是否重新生成令牌
 * this method is called, a new CSRF token will be generated and persisted (in session or cookie).
 * @return string the token used to perform CSRF validation.
 */
public function getCsrfToken($regenerate = false)
{
    if ($this->_csrfToken === null || $regenerate) {
        if ($regenerate || ($token = $this->loadCsrfToken()) === null) {
            $token = $this->generateCsrfToken();
        }
        $this->_csrfToken = Yii::$app->security->maskToken($token);
    }

    return $this->_csrfToken;
}
/**
 * 生成csrftoken
 * Generates an unmasked random token used to perform CSRF validation.
 * @return string the random token for CSRF validation.
 */
protected function generateCsrfToken()
{
    $token = Yii::$app->getSecurity()->generateRandomKey();
    if ($this->enableCsrfCookie) {
        $cookie = $this->createCsrfCookie($token);
        // 添加到cookie中
        Yii::$app->getResponse()->getCookies()->add($cookie);
    } else {
        // 添加到session中
        Yii::$app->getSession()->set($this->csrfParam, $token);
    }
    return $token;
}
```
验证csrftoken  
```php
yii\web\Request
/**
 * 验证csrf
 * Performs the CSRF validation.
 *
 * This method will validate the user-provided CSRF token by comparing it with the one stored in cookie or session.
 * This method is mainly called in [[Controller::beforeAction()]].
 *
 * Note that the method will NOT perform CSRF validation if [[enableCsrfValidation]] is false or the HTTP method
 * is among GET, HEAD or OPTIONS.
 *
 * @param string $clientSuppliedToken the user-provided CSRF token to be validated. If null, the token will be retrieved from
 * the [[csrfParam]] POST field or HTTP header.
 * This parameter is available since version 2.0.4.
 * @return bool whether CSRF token is valid. If [[enableCsrfValidation]] is false, this method will return true.
 */
public function validateCsrfToken($clientSuppliedToken = null)
{
    $method = $this->getMethod();
    // 'GET', 'HEAD', 'OPTIONS' 这三种方法不验证csrf
    // only validate CSRF token on non-"safe" methods http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.1.1
    if (!$this->enableCsrfValidation || in_array($method, ['GET', 'HEAD', 'OPTIONS'], true)) {
        return true;
    }

    $trueToken = $this->getCsrfToken();

    if ($clientSuppliedToken !== null) {
        return $this->validateCsrfTokenInternal($clientSuppliedToken, $trueToken);
    }
    // 获取请求数据或者header头中的数据进行验证
    return $this->validateCsrfTokenInternal($this->getBodyParam($this->csrfParam), $trueToken)
        || $this->validateCsrfTokenInternal($this->getCsrfTokenFromHeader(), $trueToken);
}

/**
 * Validates CSRF token
 *
 * @param string $clientSuppliedToken The masked client-supplied token.
 * @param string $trueToken The masked true token.
 * @return bool
 */
private function validateCsrfTokenInternal($clientSuppliedToken, $trueToken)
{
    if (!is_string($clientSuppliedToken)) {
        return false;
    }

    $security = Yii::$app->security;

    return $security->unmaskToken($clientSuppliedToken) === $security->unmaskToken($trueToken);
}
```
### 密码的加密和验证  
#### generatePasswordHash & validatePassword  
为了数据安全，存储的用户密码肯定是要加密的，而且是难以破解的，即使数据库被盗，对方依旧很难通过存储的加密信息破解出密码  

根据原密码生成密码对应的加密数据  
```php
/**
 * 加密密码
 * 和validatePassword 配对使用
 * @param string $password The password to be hashed. 要加密的密码
 * @param int $cost Cost parameter used by the Blowfish hash algorithm.  数值越大暴力破解越难，生成也越耗费资源
 * @return string The password hash string. When [[passwordHashStrategy]] is set to 'crypt',
 * the output is always 60 ASCII characters, when set to 'password_hash' the output length
 * might increase in future versions of PHP (http://php.net/manual/en/function.password-hash.php)
 * @throws Exception on bad password parameter or cost parameter.
 * @see validatePassword()
 */
public function generatePasswordHash($password, $cost = null)
{
    ...
}
```
验证密码是否匹配原密码生成的hash  
```php
/**
 * 验证密码
 * 和generatePasswordHash配对使用
 * Verifies a password against a hash.
 * @param string $password The password to verify. 用户输入的密码
 * @param string $hash The hash to verify the password against. 使用generatePasswordHash生成的加密后的密码
 * @return bool whether the password is correct.
 * @throws InvalidParamException on bad password/hash parameters or if crypt() with Blowfish hash is not available.
 * @see generatePasswordHash()
 */
public function validatePassword($password, $hash)
{
    ...
}
```
实例：  
```php
// generates the hash (usually done during user registration or when the password is changed)
$hash = Yii::$app->getSecurity()->generatePasswordHash($password);
// ...save $hash in database...
 *
// during login, validate if the password entered is correct using $hash fetched from database
if (Yii::$app->getSecurity()->validatePassword($password, $hash) {
    // password is good
} else {
    // password is bad
}
```
### 数据的防篡改  
#### hashData & validateData  
就是我给你看，但是你不能改  
对原始数据进行加密，然后拼接原始数据  
```php
/**
 * 加密数据 防篡改
 * 和 validateData 配对使用
 *
 * Prefixes data with a keyed hash value so that it can later be detected if it is tampered.
 * There is no need to hash inputs or outputs of [[encryptByKey()]] or [[encryptByPassword()]]
 * as those methods perform the task.
 * @param string $data the data to be protected  要加密的数据
 * @param string $key the secret key to be used for generating hash. Should be a secure 加密使用的key
 * cryptographic key.
 * @param bool $rawHash whether the generated hash value is in raw binary format. If false, lowercase
 * hex digits will be generated.
 * @return string the data prefixed with the keyed hash
 * @throws InvalidConfigException when HMAC generation fails.
 */
public function hashData($data, $key, $rawHash = false)
{
    ...
}
```
验证 hashData 后的数据,并返回数据    
```php
/**
 * 验证数据
 * 使用 和 hashData 配对使用
 * Validates if the given data is tampered.
 * @param string $data the data to be validated. The data must be previously 让hashData加密后的数据
 * generated by [[hashData()]].
 * @param string $key the secret key that was previously used to generate the hash for the data in [[hashData()]]. 加密时用的key
 * function to see the supported hashing algorithms on your system. This must be the same
 * as the value passed to [[hashData()]] when generating the hash for the data.
 * @param bool $rawHash this should take the same value as when you generate the data using [[hashData()]].
 * It indicates whether the hash value in the data is in binary format. If false, it means the hash value consists
 * of lowercase hex digits only.
 * hex digits will be generated.
 * @return string|false the real data with the hash stripped off. False if the data is tampered.
 * @throws InvalidConfigException when HMAC generation fails.
 */
public function validateData($data, $key, $rawHash = false)
{
    ...
}
```
##### 实例：  
```php
public function actionIndex3()
{
	$userId = 30;
	echo $temp = Yii::$app->security->hashData("security", "bunao");
	echo "<br/>";
	echo Yii::$app->security->validateData($temp, "bunao"); # security
	echo "<br/>";
}
```
###### cookie 加解密
Yii写读cookie的时候使用   
```php  
在cookie的时候会对cookie数据进行加密  
yii/web/Response  
/**
 * 发送cookie
 * Sends the cookies to the client.
 */
protected function sendCookies()
{
    ...
    ...

    // 加密存入cookie
    foreach ($this->getCookies() as $cookie) {
        $value = $cookie->value;
        if ($cookie->expire != 1  && isset($validationKey)) {
            $value = Yii::$app->getSecurity()->hashData(serialize([$cookie->name, $value]), $validationKey);
        }
        setcookie($cookie->name, $value, $cookie->expire, $cookie->path, $cookie->domain, $cookie->secure, $cookie->httpOnly);
    }
}

获取cookie的时候对其进行解密  
yii/web/Request
/**
 * 获取cookie并转换
 * Converts `$_COOKIE` into an array of [[Cookie]].
 * @return array the cookies obtained from request
 * @throws InvalidConfigException if [[cookieValidationKey]] is not set when [[enableCookieValidation]] is true
 */
protected function loadCookies()
{
    ...
    ...

            // 验证后获取源数据
            $data = Yii::$app->getSecurity()->validateData($value, $this->cookieValidationKey);
            if ($data === false) {
                continue;
            }

    ...
    ...
}
```

## 生成随机字符  
### generateRandomKey & generateRandomString
两个都是随机一串字符，但是 `generateRandomKey` 生成的不是Ascii码，所以在显示的时候有可能乱码，而 `generateRandomString` 是对 `generateRandomKey` 的封装，加了 `base64_encode` 使其不会乱码  
生成指定长度随机字符，可能不是 ASCII字符，显示的时候会出现乱码  
```php
/**
 * 生成随机key。
 * 和 generateRandomString 的区别就是输出的可能不是 Ascii码的
 * Generates specified number of random bytes.
 * Note that output may not be ASCII.
 * @see generateRandomString() if you need a string.
 *
 * @param int $length the number of bytes to generate 生成的长度
 * @return string the generated random bytes
 * @throws InvalidParamException if wrong length is specified
 * @throws Exception on failure.
 */
public function generateRandomKey($length = 32)
{
    ...
}
```
生成指定长度随机字符  
```php
/**
 * 生成指定长度的随机字符串
 * Generates a random string of specified length.
 * The string generated matches [A-Za-z0-9_-]+ and is transparent to URL-encoding.
 *
 * @param int $length the length of the key in characters 生成字符的长度
 * @return string the generated random key
 * @throws Exception on failure.
 */
public function generateRandomString($length = 32)
{
    ...
}
```
<!-- 实例：  
```php

``` -->


## compareString 比较字符串
可防止时序攻击的字符串比较，用法非常简单。
```
Yii::$app->security->compareString("abc",'abc');
```
结果为真则相等，否则不相等。

那么什么是时序攻击那？我来举一个简单的例子。
```
if($code == Yii::$app->request->get('code')){

}
```
上面的比较逻辑，两个字符串是从第一位开始逐一进行比较的，发现不同就立即返回 false，那么通过计算返回的速度就知道了大概是哪一位开始不同的，这样就实现了按位破解密码的场景。

而使用 `compareString` 比较两个字符串，无论字符串是否相等，函数的时间消耗是恒定的，这样可以有效的防止时序攻击。  
