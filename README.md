# Инструменты разработчика

Пакет предназначен упрощения разработки и поддержки сайтов по процессам Добро.сайт.

Пакет содержит:

- библиотеки GNU Make
- сценарий для создания дампов БД.

## Библиотеки GNU Make

Вы можете использовать в своих [файлах Make](https://www.gnu.org/software/make/manual/make.html)
описанные ниже библиотеки, подключив этот пакет как
[подмодуль Git](https://git-scm.com/book/ru/v1/Инструменты-Git-Подмодули):

    git submodule add git@git.dobro.site:dobrosite/dev-tools.git tools/dev-tools

После чего библиотеки можно подключать к своему файлу, например:

```makefile
all: build

include tools/dev-tools/common.mk
```
Желательно подключать библиотеки как можно ближе к началу файла, но после цели по умолчанию (иначе
целью по умолчанию может стать цель из библиотеки).

### common.mk

Содержит функции и цели общего назначения.

#### assert-variable-set (функция)

Проверяет что указанная переменная установлена и её значение не пусто. Пример:

```makefile
foo:
    $(call assert-variable-set,REMOTE,имя конфигурации сайта)
```
Если переменная `REMOTE` не задана или пуста, выведет сообщение об ошибке «Не задано значение
переменной REMOTE (имя конфигурации сайта)».

### db.mk

Содержит цели для работы с базами данных. Доступ к удалённымБД осуществляется либо по SSH, либо
через [mysqldump.php](mysqldump.php), загружаемый по FTP. Для подключения используется
[remote.mk](#remotemk).

#### DB_DUMP_FILE (переменная)

Задаёт имя файла дампа БД. По умолчанию `db/database.sql`. Используется целями `db-dump` и
`db-load`.

#### db-import (цель)

Импортирует БД с удалённого сервера на локальный.

Пример настройки в `Makefile`:

```makefile
test_db_name = example
test_db_user = example
test_db_password = 123456789
```
Пример вызова:

    make REMOTE=test LOCAL_DB_NAME=example db-import

### remote.mk

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

#### assert-required-remote-variables (функция)

Проверяет правильность установки переменных, необходимых для удалённого доступа.

Пример:
```makefile
foo:
    $(assert-required-remote-variables)
```

#### run-ssh (функция)

Выполняет команду на удалённом сервере по SSH.

Пример:
```makefile
foo:
    $(run-ssh,ls htdocs)
```
