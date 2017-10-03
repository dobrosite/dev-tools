# wordpress.mk

Функции и цели для работы с Wordpress.

## Функции

### run-wp-cli

Выполняет команду [wp-cli](http://wp-cli.org/).

**Аргументы**

1. Аргументы `wp`.

В команду уже включён аргумент `--path`. 

```makefile
foo: $(wp-cli)
    $(call run-wp-cli,plugin install --activate wp-scss)
```

См. [$(wp-cli)](#wp-cli)


## Цели

### wordpress-install

Устанавливает и настраивает Wordpress.

**Требования**

1. [Composer](https://getcomposer.org/) должен быть установлен в системе и доступен через команду
   `composer`.
2. Переменная `LOCAL_DB_NAME` должна содержать имя существующей пустой базы данных.


### $(wp-cli)

Устанавливает [wp-cli](http://wp-cli.org/). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.

См. [run-wp-cli](#run-wp-cli).
