##
## Функции общего назначения.
##

ifndef __COMMON_MK

__COMMON_MK := 1
__LIB_DIR ?= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

SHELL ?= /bin/bash

## Доменное имя сайта.
SITE_DOMAIN ?= $(shell basename `pwd`)
## Название сайта.
SITE_TITLE ?= $(SITE_DOMAIN)
## Корневая папка файлов, достпных по HTTP.
PUBLIC_DIR ?= htdocs

# Задаёт переменную TMPDIR, если она не задана в системе или аргументах make.
TMPDIR ?= /tmp

## Путь к jpegoptim.
jpegoptim := node_modules/.bin/jpegoptim
## Путь к OptiPNG.
optipng := node_modules/.bin/optipng
## Путь к Sass.
sass := node_modules/.bin/node-sass
## Путь к UglifyJS.
uglifyjs := node_modules/.bin/uglifyjs

####
## Проверяет что указанная переменная установлена и её значение не пусто.
## В случае ошибки прерывает работу сценария.
##
## @param Имя переменной для проверки.
## @param Сообщение при ошибке (не обязательно).
##
assert-variable-set = $(if $(value $1),,$(error Не задано значение переменной $1$(if $2, ($2))))

####
## Сжимает JPEG.
##
## @param $1 Аргументы для jpegoptim (обычно имя файла).
##
run-jpegoptim = $(jpegoptim) --preserve-perms --strip-all --threshold=1% $(1)

####
## Сжимает PNG.
##
## @param $1 Имя файла или маска (например *.png).
##
run-optipng = $(optipng) -o7 $(1)

####
## Собирает SCSS.
##
## @param $1 Исходный файл.
## @param $2 Итоговый файл.
##
run-sass = $(sass) --output-style=compressed --output $(2) $(1)

####
## Сжимает указанный файл JavaScript.
##
## @param $1 Исходный файл или файлы (через пробел).
## @param $2 Итоговый файл.
##
run-uglifyjs = $(uglifyjs) $(1) -o $(2)

##
## Устанавливает jpegoptim.
##
$(jpegoptim): node_modules
ifeq (,$(realpath $(jpegoptim)))
	$(call run-npm,install jpegoptim-bin --save-dev)
endif

##
## Устанавливает SASS.
##
$(sass): node_modules
ifeq (,$(realpath $(sass)))
	$(call run-npm,install node-sass --save-dev)
endif

##
## Устанавливает OptiPNG.
##
$(optipng): node_modules
ifeq (,$(realpath $(optipng)))
	$(call run-npm,install optipng-bin --save-dev)
endif

##
## Устанавливает UglifyJS.
##
$(uglifyjs): node_modules
ifeq (,$(realpath $(uglifyjs)))
	$(call run-npm,install uglify-js --save-dev)
endif


ifndef __NPM_MK
include $(__LIB_DIR)/npm.mk
endif

# ifndef __COMMON_MK
endif
