# npm.mk

Работа с [Node Package Manager](https://npmjs.com/).

## Функции

### run-npm

Выполняет команду [npm](https://docs.npmjs.com/cli/npm).

**Аргументы**

1. Аргументы `npm`.

```makefile
foo: package.json
    $(call run-npm,install node-sass)
```

## Цели

### node_modules

Устанавливает зависимости через npm.

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.

### package.json

Создаёт файл [package.json](https://docs.npmjs.com/files/package.json). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
