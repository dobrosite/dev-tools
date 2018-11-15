# История изменений

Формат этого файла соответствует рекомендациям [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).
Проект использует [семантическое версионирование](http://semver.org/spec/v2.0.0.html).

## Не выпущено


## 1.6.0 — 15.11.2018

### Исправлено

- В функции [run-ssh](docs/make/remote.md#run-ssh) не работала авторизация по паролю. 

### Добавлено

- Функция [run-scp-from](docs/make/remote.md#run-scp-from) — копирование с удалённого сервера.
- Переменная [LOCAL_DB_HOST](docs/make/db.md#local_db_host) — хост локальной БД.
- Переменная [MYSQLDUMP_IGNORE_TABLES](docs/make/db.md#mysqldump_ignore_tables) — таблицы, которые
  надо пропустить при создании дампов.

### Изменено

- Цель [db-load](docs/make/db.md#db-load) теперь может загружать дампы в локальную БД.


## 1.5.0 — 06.09.2018

### Добавлено

- Переменная [ENV](docs/make/common.md#Переменные).

### Изменено

- Если переменная `ENV` установлена в `prod`, то Composer будет запускаться с опцией `--no-dev`.  


## 1.4.1 — 27.07.2018

### Изменено

- Из вызова uglify-js исключена устаревшая опция `--screw-ie8`.


## 1.4.0 — 2018.06.26

### Добавлено

- Переменная [$(MYSQLDUMP_OPTIONS)](docs/make/db.md#Переменные) — опции для `mysqldump`.


## 1.3.1 — 2018.03.21

### Исправлено

- Команда [run-wp-cli](docs/make/wordpress.md#run-wp-cli) не использовала переменную
  [$(PUBLIC_DIR)](docs/make/common.md#Переменные).

### Изменено

- Цель [$(wp-cli)](docs/make/wordpress.md#$(wp-cli)) теперь устанавливает `wp-cli` как зависимость
 `require-dev`.


## 1.3.0 — 2018.02.27

### Добавлено

- Добавлена цель [dev-tools-update](docs/make/common.md#dev-tools-update).


## 1.2.0 — 2018.02.27

### Изменено

- Цель `composer-clean` теперь удаляет ещё и папку
  [COMPOSER_BIN_DIR](docs/make/composer.md#Переменные).
- Цель `composer-install` объявлена устаревшей. Вместо неё используйте
  [$(COMPOSER_VENDOR_DIR)](docs/make/composer.md#$(COMPOSER_VENDOR_DIR)).


## 1.1.0 — 2018.01.26

### Изменено

- Инструменты теперь должны устанавливаться в папку `develop`.
- Настройки доступов теперь должны храниться в отдельном файле `Makefile.local`, см.
  [пример](docs/make/Makefile.local.example).


## 1.0.0 — 2018-01-18

### Добавлено

- Добавлена цель [archive](docs/make/common.md#archive).


## 0.1.10 — 2017.11.10

### Исправлено

- Цель [db-dump](docs/make/db.md#db-dump) неправильно работала по FTP.


## 0.1.9 — 2017.11.10

### Изменено

- Команда [run-ftp-upload](docs/make/remote.md#run-ftp-upload) использует curl вместо ftp, т. к. не все реализации ftp
  поддерживают флаг «-u».


## 0.1.8 — 2017.10.25

### Изменено

- Цель [node_modules](docs/make/npm.md#node_modules) теперь вызывает `npm install` с флагом
  `--global-style=false`.

### Добавлено

- Добавлена цель [composer-clean](docs/make/composer.md#composer-clean).
- Добавлена цель [npm-clean](docs/make/npm.md#npm-clean).
- Добавлена функция [run-ftp-upload](docs/make/remote.md#run-ftp-upload).

## 0.1.7 – 2017.10.12

### Изменено

- Улучшено сжатие функцией `run-uglifyjs`.

### Добавлено

- Добавлена цель [npm-update](docs/make/npm.md#npm-update).
- Добавлены подсказки по некоторым встроенным целям.

## 0.1.6 – 2017-10-11

### Изменено

- `mysqldump.php` больше не использует консольную команду `mysqldump`.
- Цели `wordpress-install` теперь требуется переменная `ADMIN_PASSWORD`, содержащая пароль для
  создания пользователя dobrosite.
- Цель `db-dump` теперь делает дамп локальной БД, если переменная `REMOTE` не задана.

### Добавлено

- Цели `db-load` и `db-export` теперь могут загружать дампы по SSH.
- Цель `db-dump` теперь может работать по FTP.
- Функция [run-ftp](docs/make/remote.md#run-ftp).
- Переменная [DEV_TOOLS_DIR](docs/make/common.md#Переменные) — путь к папке dev-tools.


## 0.1.5 – 2017-10-04

### Исправлено

- Цель `build` в `Makefile.example` имела неправильные зависимости.
- При значениях переменной `COMPOSER_ROOT_DIR` отличных от значения по умолчанию, в файл
  `composer.json` записывались неправильные пути. 


## 0.1.4 – 2017-10-04

### Добавлено

- Добавлена цель [help](docs/make/common.md#help), выводящая список целей с описаниями.

### Изменено

- Целью по умолчанию назначена `build`.


## 0.1.3 – 2017-10-03

### Исправлено

- Исправлена защита от повторного подключения файлов *.mk.

### Добавлено

- Файл [make/composer.mk](docs/make/composer.md) — работы с Composer.
- Файл [make/npm.mk](docs/make/npm.md) — работы с npm.
- Файл [make/wordpress.mk](docs/make/wordpress.md) — работы с Wordpress.
- Переменная [PUBLIC_DIR](docs/make/common.md#Переменные) — корневая папка сайта.
- Переменная [SITE_DOMAIN](docs/make/common.md#Переменные) — доменное имя сайта.
- Переменная [SITE_TITLE](docs/make/common.md#Переменные) — название сайта.

### Изменено

- Цель `node_modules` перенесена в `npm.mk`.
- Цель `package.json` перенесена в `npm.mk`.
- Цель `package.json` теперь создаёт файл в случае его отсутствия, а не сообщает об ошибке.
- Цель `composer-install` перенесена в `composer.mk`.
- Цель `composer-update` перенесена в `composer.mk`.
- Переменная `COMPOSER_ROOT` переименована в `COMPOSER_ROOT_DIR` и перенесена в `composer.mk`.


## 0.1.2 – 2017-09-28

### Исправлено

- Исправлена цель `db-import`.

### Добавлено

- Переменная `TMPDIR`, если не установлена, устанавливается равной `/tmp`.
- Цель [composer-install](docs/make/composer.md#composer-install) — установка зависимостей через
  Composer.  
- Цель [composer-update](docs/make/composer.md#composer-update) — обновление зависимостей через
  Composer.  

### Изменено

- `db-import` создаёт временный файл в папке, задаваемой переменной `TMPDIR`.
- `db-import` сообщает о неустановленных переменных в начале работы.
- `$(jpegoptim)`, `$(sass)`, `$(optipng)` и `$(uglifyjs)` теперь зависят от `node_modules`, а не от
  `package.json`, что позволяет при их установке устанавливать и другие указанные в `package.json`
  пакеты. 

### Прочее

- Документация перенесена в папку `docs`.


## 0.1.1 – 2017-09-26

### Исправлено

- Не работали цели `$(sass)`, `$(optipng)` и `$(uglifyjs)`.


## 0.1.0 – 2017-09-25

Первая версия.
