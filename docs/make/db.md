# db.mk

Содержит цели для работы с базами данных. Доступ к удалённымБД осуществляется либо по SSH, либо
через [mysqldump.php](mysqldump.php), загружаемый по FTP. Для подключения используется
[remote.mk](#remotemk).

## Переменные

### DB_DUMP_FILE

Задаёт имя файла дампа БД. По умолчанию `db/database.sql`. Используется целями `db-dump` и
`db-load`.

### LOCAL_DB_HOST

Хост для подключения к локальной БД. По умолчанию `localhost`. 

### LOCAL_DB_NAME

Имя локальной БД. Должна задаваться в командной строке при вызове make. 

### MYSQLDUMP_IGNORE_TABLES

Таблицы, которые надо пропустить при создании дампа (через пробел).

### MYSQLDUMP_OPTIONS

Опции для `mysqldump`. По умолчанию содержит:

- `--add-drop-table`
- `--add-locks`
- `--allow-keywords`
- `--disable-keys`
- `--no-create-db`
- `--skip-comments`
- `--skip-compact`

## Цели

### db-dump

Сохраняет дамп БД в файл, заданный [DB_DUMP_FILE](#DB_DUMP_FILE).

#### Дамп локальной БД

Если не задана переменная [REMOTE](remote.md#REMOTE), то будет создан дамп локальной БД. В этом
случае обязательно должна быть задана переменная [LOCAL_DB_NAME](#LOCAL_DB_NAME).

Пример вызова:

    make db-dump LOCAL_DB_NAME=example

#### Дамп удалённой БД

Пример вызова:

    make db-dump REMOTE=test

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

### db-load

Загружает дамп БД из файла, заданного переменной [DB_DUMP_FILE](#DB_DUMP_FILE).

#### Загрузка в локальную БД

Если не задана переменная [REMOTE](remote.md#REMOTE), то дамп будет загружен в локальную БД. В этом
случае обязательно должна быть задана переменная [LOCAL_DB_NAME](#LOCAL_DB_NAME).

Пример вызова:

    make db-load LOCAL_DB_NAME=example

#### Загрузка в удалённую БД

Пример вызова:

    make db-load REMOTE=test
