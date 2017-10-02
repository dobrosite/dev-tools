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

### $(wp-cli)

Устанавливает [wp-cli](http://wp-cli.org/). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
2. [package.json](https://docs.npmjs.com/files/package.json) должен существовать и располагаться в
   одной папке с `Makefile`.

См. [run-wp-cli](#run-wp-cli).
