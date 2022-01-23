# mod-fixparams

Fix invalid parameters to urlencoded valid parameters.

## Install

First, you have to enable mod_lua. For example, the following:

```sh
sudo a2enmod lua
```

Second, configure as follows:

```apache
LuaInputFilter fix_body_params_filter /etc/apache2/fixparams.lua fix_body_params_filter
  
<Location />
    LuaHookTranslateName /etc/apache2/fixparams.lua fix_url_params
    SetInputFilter fix_body_params_filter
</Location>
```

## Example

Suppose publish this page.

```php:test.php
QueryString: <?php echo $_SERVER['QUERY_STRING'] ?>

Body: <?php echo file_get_contents('php://input') ?>

```

Let's test the module using curl.

```sh
curl 'http://localhost/test.php?a1=x1@あ+&a2=y2*い~' -d 'b1=x1@あ+&b2=y2*い~' -v
*   Trying 127.0.0.1:80...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 80 (#0)
> POST /test1.php?a1=x1@あ+&a2=y2*い~ HTTP/1.1
> Host: localhost
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 21
> Content-Type: application/x-www-form-urlencoded
> 
* upload completely sent off: 21 out of 21 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Sun, 23 Jan 2022 00:11:54 GMT
< Server: Apache/2.4.41 (Ubuntu)
< Vary: Accept-Encoding
< Content-Length: 95
< Content-Type: text/html; charset=UTF-8
< 
QueryString: a1=x1%40%E3%81%82+&a2=y2%2A%E3%81%84~
Body: b1=x1%40%E3%81%82+&b2=y2%2A%E3%81%84~
* Connection #0 to host localhost left intact
```

## License

Licensed under Apache License, Version 2.0 (LICENSE-APACHE or http://www.apache.org/licenses/LICENSE-2.0).


