# composer.mk

Работа с [Composer](https://getcomposer.org/).

## Переменные

- `COMPOSER_ROOT_DIR` — путь к папке, содержащей `composer.json`. По умолчанию та же где `Makefile`.
- `COMPOSER_VENDOR_DIR` — путь к папке для установки зависимостей. По умолчанию `vendor` в папке
  `COMPOSER_ROOT_DIR`.
- `COMPOSER_BIN_DIR` — путь к папке для установки исполняемых файлов. По умолчанию `bin` в папке
  `COMPOSER_VENDOR_DIR`. 

## Функции

### run-composer

Выполняет команду composer.

**Аргументы**

1. Аргументы `composer`.

Команда будет выполнена в папке заданной `COMPOSER_ROOT_DIR`. В команду уже включён аргумент
`--no-interaction`. 

```makefile
foo:
    $(call run-composer,require foo/bar)
```

## Цели

### composer-clean

Удаляет установленные через Composer пакеты.

### composer-install

Устанавливает зависимости через Composer.

**Требования**

1. [Composer](https://getcomposer.org/) должен быть установлен в системе и доступен через команду
   `composer`.

### composer-update

Обновляет зависимости через Composer.

**Требования**

1. [Composer](https://getcomposer.org/) должен быть установлен в системе и доступен через команду
   `composer`.


### $(composer.json)

Предназначена для использования в качестве зависимости для целей, требующих наличие этого файла.

Создаёт файл [composer.json](https://getcomposer.org/doc/01-basic-usage.md#composer-json-project-setup). 

**Требования**

1. [Composer](https://getcomposer.org/) должен быть установлен в системе и доступен через команду
   `composer`.
