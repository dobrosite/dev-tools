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

### npm-clean

Удаляет установленные через npm пакеты (папку node_modules).

### npm-update

Обновляет зависимости через npm.

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.

### node_modules

Устанавливает зависимости через npm. Установка производится командой
`npm install --global-style=false`.

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.

### package.json

Создаёт файл [package.json](https://docs.npmjs.com/files/package.json). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
