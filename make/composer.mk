##
## Работа с Composer.
##

ifndef __COMPOSER_MK

__COMPOSER_MK := 1
__LIB_DIR ?= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

include $(__LIB_DIR)/common.mk

## Путь к папке, содержащей composer.json.
COMPOSER_ROOT_DIR ?= .
## Путь к папке для установки зависимостей.
COMPOSER_VENDOR_DIR ?= $(COMPOSER_ROOT_DIR)/vendor
## Путь к папке для установки исполняемых файлов.
COMPOSER_BIN_DIR ?= $(COMPOSER_VENDOR_DIR)/bin

## Путь к файлу composer.json
composer.json = $(COMPOSER_ROOT_DIR)/composer.json


####
## Выполняет команду Composer.
##
## @param $(1) Аргументы composer.
##
run-composer = cd $(COMPOSER_ROOT_DIR) && composer --no-interaction $(1)

##
## Устанавливает зависимости через Composer.
##
.PHONY: composer-install
composer-install: $(composer.json)
	$(call run-composer,install)

##
## Обновляет зависимости через Composer.
##
.PHONY: composer-update
composer-update: $(composer.json)
	$(call run-composer,update)

##
## Создаёт файл composer.json.
##
$(composer.json):
ifeq ($(realpath $(COMPOSER_ROOT_DIR)/composer.json),)
	$(call run-composer,init --name=dobrosite/$(SITE_DOMAIN) --type=project --stability=stable --license=proprietary)
	$(call run-composer,config vendor-dir $(patsubst ./%,%,$(COMPOSER_VENDOR_DIR)))
	$(call run-composer,config bin-dir $(patsubst ./%,%,$(COMPOSER_BIN_DIR)))
endif

# ifndef __COMPOSER_MK
endif