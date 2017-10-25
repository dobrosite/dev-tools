##
## Работа с Node Package Manager.
##

ifndef __NPM_MK

__NPM_MK := 1
__LIB_DIR ?= $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

include $(__LIB_DIR)/common.mk

####
## Выполняет команду npm
##
## @param $1 Аргументы npm
##
run-npm = npm $(1)

####
## Изменяет package.json.
##
## @access private
##
edit-package.json = node_modules/.bin/json --in-place -f package.json $(1)

##
## Обновляет пакеты через npm.
##
npm-update: node_modules ## Обновляет пакеты через npm.
	$(call run-npm,install)

##
## Устанавливает пакеты через npm.
##
node_modules: package.json ## Устанавливает пакеты через npm.
ifeq ($(realpath node_modules),)
	$(call run-npm,install --global-style=false)
endif

##
## Создаёт файл package.json.
##
package.json: ## Создаёт файл package.json.
ifeq ($(realpath package.json),)
	npm init --force
	$(call run-npm,install json --save-dev)
	$(call edit-package.json,-e 'this.version="$(shell date +%Y).1.0"')
	$(call edit-package.json,-e 'this.private=true')
	$(call edit-package.json,-e 'this.license="UNLICENSED"')
	$(call edit-package.json,-e 'this.main=undefined')
	$(call edit-package.json,-e 'this.scripts=undefined')
	$(call edit-package.json,-e 'this.keywords=undefined')
	$(call edit-package.json,-e 'this.author=undefined')
	$(call run-npm,uninstall json --save-dev)
endif

# ifndef __NPM_MK
endif
