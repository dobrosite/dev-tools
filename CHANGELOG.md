# История изменений

Формат этого файла соответствует рекомендациям [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).
Проект использует [семантическое версионирование](http://semver.org/spec/v2.0.0.html).

## Не выпущено

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
