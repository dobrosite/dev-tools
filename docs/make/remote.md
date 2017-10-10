# remote.mk

Пример настройки:

```makefile
prod_proto = ftp
prod_ftp_host = ftp.example.com
prod_ftp_user = foo@example.com
prod_ftp_password = password
prod_ftp_root = /
prod_http_root = http://example.com/

test_proto = ssh
test_ssh_host = dobrotest.site
test_ssh_user = dobrotest
test_ssh_password = password
test_ssh_root = /var/www/dobrotest.site/example.com/htdocs
test_http_root = http://example.com.dobrotest.site
```
Если тестовый сайт находится на сервере dobrotest.site, то переменные `test_proto`, `test_*_host`,
`test_*_user` и `test_*_password` можно не задавать.

## Функции

### assert-required-remote-variables

Проверяет правильность установки переменных, необходимых для удалённого доступа.

Пример:
```makefile
foo:
    $(call assert-required-remote-variables)
```
### run-ftp

Выполняет команду FTP.

Пример:
```makefile
foo:
    $(call run-ftp,'DELE foo.txt')
```

### run-ssh

Выполняет команду на удалённом сервере по SSH.

Пример:
```makefile
foo:
    $(call run-ssh,ls htdocs)
```
