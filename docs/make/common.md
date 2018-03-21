# common.mk

Функции и цели общего назначения.

## Переменные

- `DEV_TOOLS_DIR` — путь к папке dev-tools.
- `PUBLIC_DIR` — корневая папка сайта (доступная по HTTP). По умолчанию `htdocs`.
- `SITE_HOSTNAME` — доменное имя сайта. По умолчанию имя папки проекта.
- `SITE_TITLE` — название сайта. По умолчанию совпадает с `SITE_DOMAIN`.

## Функции

### assert-variable-set

Проверяет что указанная переменная установлена и её значение не пусто. Пример:

```makefile
foo:
    $(call assert-variable-set,REMOTE,имя конфигурации сайта)
```
Если переменная `REMOTE` не задана или пуста, выведет сообщение об ошибке «Не задано значение
переменной REMOTE (имя конфигурации сайта)».

### run-jpegoptim

Сжимает JPEG, используя [jpegoptim](https://github.com/tjko/jpegoptim).

**Аргументы**

1. Аргументы `jpegoptim`, обычно просто маска файлов.

В команду уже включены аргументы `--preserve-perms --strip-all --threshold=1%`. 

```makefile
foo: $(jpegoptim)
    $(call run-jpegoptim,path/to/images/*.jpg)
```

См. [$(jpegoptim)](#jpegoptim)


### run-optipng

Сжимает PNG, используя [OptiPNG](http://optipng.sourceforge.net/).

**Аргументы**

1. Имя файла или маска (например *.png).

В команду уже включены аргументы для максимальной степени сжатия без потерь. 

```makefile
foo: $(optipng)
    $(call run-optipng,path/to/images/*.png)
```

См. [$(optipng)](#optipng)


### run-sass

Собирает файл SCSS, используя [node-sass](https://www.npmjs.com/package/node-sass).

**Аргументы**

1. Исходный файл.
2. Папка для файла CSS.

```makefile
foo: $(sass)
    $(call run-sass,path/to/bundle.scss,path/to/bundle.css)
```

См. [$(sass)](#$(sass))


### run-uglifyjs

Сжимает JavaScript, используя [UglifyJS](http://lisperator.net/uglifyjs/).

**Аргументы**

1. Исходный файл или файлы (через пробел).
2. Итоговый файл. 

```makefile
foo: $(uglifyjs)
    $(call run-uglifyjs,path/to/file1.js path/to/file2.js, path/to/bundle.min.js)
```

См. [$(uglifyjs)](#$(uglifyjs))


## Цели

### archive

Создаёт архив проекта для передачи заказчику.

**Требования**

1. Команда git должна быть доступна.
2. Команда zip должна быть доступна.


### dev-tools-update

Обновляет dev-tools.

**Требования**

1. Команда git должна быть доступна.


### help

Выводит список целей с описаниями. Чтобы цель выводилась, она должна быть описана следующим образом:

```makefile
имя_цели: зависимости ## Описание цели.
```


### $(jpegoptim)

Устанавливает [jpegoptim](https://github.com/tjko/jpegoptim). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.

См. [run-jpegoptim](#run-jpegoptim).


### $(optipng)

Устанавливает [OptiPNG](http://optipng.sourceforge.net/). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
   
См. [run-optipng](#run-optipng).


### $(sass)

Устанавливает [node-sass](https://www.npmjs.com/package/node-sass). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
   
См. [run-sass](#run-sass).


### $(uglifyjs)

Устанавливает [UglifyJS](http://lisperator.net/uglifyjs/). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
   
См. [run-uglifyjs](#run-uglifyjs).
