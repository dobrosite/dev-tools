# common.mk

Функции и цели общего назначения.

## Переменные

- `COMPOSER_ROOT` — путь к папке, содержащей `composer.json` (по умолчанию та же где `Makefile`).
- `TMPDIR` — если такая переменная отсутствует в окружении и не задана через аргументы make, она
  будет создана и указывать на папку `/tmp`.

Следующие переменные предназначены для использования в качестве зависимостей в целях, требующих
наличия соответствующих команд.   
 
## Функции

### assert-variable-set

Проверяет что указанная переменная установлена и её значение не пусто. Пример:

```makefile
foo:
    $(call assert-variable-set,REMOTE,имя конфигурации сайта)
```
Если переменная `REMOTE` не задана илиerfewr пуста, выведет сообщение об ошибке «Не задано значение
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
2. Итоговый файл.

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

### composer-install

Устанавливает зависимости через Composer.

**Требования**

1. [Composer](https://getcomposer.org/) должен быть установлен в системе и доступен через команду
   `composer`.
2. В проекте должен существовать файл `composer.lock` или `composer.json` (см. переменную
   `COMPOSER_ROOT`).

### composer-update

Обновляет зависимости через Composer.

**Требования**

1. [Composer](https://getcomposer.org/) должен быть установлен в системе и доступен через команду
   `composer`.
2. В проекте должен существовать файл `composer.json` (см. переменную `COMPOSER_ROOT`).


### $(jpegoptim)

Устанавливает [jpegoptim](https://github.com/tjko/jpegoptim). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
2. [package.json](https://docs.npmjs.com/files/package.json) должен существовать и располагаться в
   одной папке с `Makefile`.

См. [run-jpegoptim](#run-jpegoptim).


### $(optipng)

Устанавливает [OptiPNG](http://optipng.sourceforge.net/). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
2. [package.json](https://docs.npmjs.com/files/package.json) должен существовать и располагаться в
   одной папке с `Makefile`.
   
См. [run-optipng](#run-optipng).


### $(sass)

Устанавливает [node-sass](https://www.npmjs.com/package/node-sass). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
2. [package.json](https://docs.npmjs.com/files/package.json) должен существовать и располагаться в
   одной папке с `Makefile`.
   
См. [run-sass](#run-sass).


### $(uglifyjs)

Устанавливает [UglifyJS](http://lisperator.net/uglifyjs/). 

**Требования**

1. [npm](https://docs.npmjs.com/getting-started/what-is-npm) должен быть установлен.
2. [package.json](https://docs.npmjs.com/files/package.json) должен существовать и располагаться в
   одной папке с `Makefile`.
   
См. [run-uglifyjs](#run-uglifyjs).
