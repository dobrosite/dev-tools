##
## Функции общего назначения.
##

ifndef __COMMON_MK

SHELL = /bin/sh

__COMMON_MK := 1
__LIB_DIR ?= $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

DEV_TOOLS_DIR := $(realpath $(dir $(__LIB_DIR)))

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
## @param $2 Папка для файла CSS.
##
run-sass = $(sass) --output-style=compressed --output $(2) $(1)

####
## Сжимает указанный файл JavaScript.
##
## @param $1 Исходный файл или файлы (через пробел).
## @param $2 Итоговый файл.
##
run-uglifyjs = $(uglifyjs) --mangle --compress --output=$(2) $(1)

## Цель по умолчанию.
.DEFAULT_GOAL := build

##
## Создаёт архив проекта.
##
.PHONY: archive
archive: ## Создаёт архив проекта (для передачи заказчику).
	-rm $(SITE_DOMAIN).zip
	git archive --format=zip --output=$(SITE_DOMAIN).zip -9 HEAD
	zip --recurse-paths $(SITE_DOMAIN).zip $(DEV_TOOLS_DIR)

##
## Обновляет dev-tools.
##
.PHONY: dev-tools-update
dev-tools-update: develop/dev-tools/.git ## Обновляет dev-tools.
	cd develop/dev-tools && git pull

##
## Выводит подсказку по доступным целям Make.
##
.PHONY: help
help: ## Выводит подсказку по доступным целям Make.
	@awk 'BEGIN {FS = ":.*?## "; targets[0] = ""} /^[a-zA-Z_\.-]+:.*?## / \
		{\
			if (!($$1 in targets)) {\
				printf "\033[36m%-20s\033[0m %s\n", $$1, $$2;\
				targets[$$1] = 1;\
			}\
		}' $(MAKEFILE_LIST)

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
