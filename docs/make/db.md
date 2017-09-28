# db.mk

Содержит цели для работы с базами данных. Доступ к удалённымБД осуществляется либо по SSH, либо
через [mysqldump.php](mysqldump.php), загружаемый по FTP. Для подключения используется
[remote.mk](#remotemk).

## Переменные

### DB_DUMP_FILE

Задаёт имя файла дампа БД. По умолчанию `db/database.sql`. Используется целями `db-dump` и
`db-load`.

## Цели

### db-import

Импортирует БД с удалённого сервера на локальный.

Пример настройки в `Makefile`:

```makefile
test_db_name = example
test_db_user = example
test_db_password = 123456789
```
Пример вызова:

    make REMOTE=test LOCAL_DB_NAME=example db-import

