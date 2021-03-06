##
## Работа с Composer.
##

ifndef __COMPOSER_MK

__COMPOSER_MK := 1
__LIB_DIR ?= $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

include $(__LIB_DIR)/common.mk

## Путь к папке, содержащей composer.json.
COMPOSER_ROOT_DIR ?= .
## Путь к папке для установки зависимостей.
COMPOSER_VENDOR_DIR ?= $(COMPOSER_ROOT_DIR)/vendor
## Путь к папке для установки исполняемых файлов.
# TODO cat htdocs/composer.json | grep bin-dir | awk '{gsub(/"/, "", $2); print $2}'
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
## Удаляет установленные через Composer пакеты.
##
.PHONY: composer-clean
composer-clean: ## Удаляет установленные через Composer пакеты.
ifneq ($(realpath $(COMPOSER_VENDOR_DIR)),)
	rm -rf $(COMPOSER_VENDOR_DIR)
endif
ifneq ($(realpath $(COMPOSER_BIN_DIR)),)
	rm -rf $(COMPOSER_BIN_DIR)
endif

##
## Устанавливает зависимости через Composer.
##
$(COMPOSER_VENDOR_DIR): $(composer.json) ## Устанавливает зависимости через Composer.
	$(call run-composer,install$(if $(findstring prod,$(ENV)), --no-dev,))

# TODO Удалить в 2.x
.PHONY: composer-install
composer-install:
	$(info ВНИМАНИЕ! Цель "composer-install" устарела и будет удалена в версии 2.0.)
	$(MAKE) $(COMPOSER_VENDOR_DIR)

##
## Обновляет зависимости через Composer.
##
.PHONY: composer-update
composer-update: $(composer.json) ## Обновляет зависимости через Composer.
	$(call run-composer,update$(if $(findstring prod,$(ENV)), --no-dev,))

##
## Создаёт файл composer.json.
##
$(composer.json):
ifeq ($(realpath $(COMPOSER_ROOT_DIR)/composer.json),)
	$(call run-composer,init --name=dobrosite/$(SITE_DOMAIN) --type=project --stability=stable --license=proprietary)
	$(call run-composer,config vendor-dir $(patsubst $(COMPOSER_ROOT_DIR)/%,%,$(COMPOSER_VENDOR_DIR)))
	$(call run-composer,config bin-dir $(patsubst $(COMPOSER_ROOT_DIR)/%,%,$(COMPOSER_BIN_DIR)))
endif

# ifndef __COMPOSER_MK
endif
