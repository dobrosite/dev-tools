##
## Работа с Node Package Manager.
##

__NPM_MK := 1
__LIB_DIR ?= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

ifndef __COMMON_MK
include $(__LIB_DIR)/common.mk
endif

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
## Устанавливает пакеты NodeJS.
##
node_modules: package.json
ifeq ($(realpath node_modules),)
	$(call run-npm,install)
endif

##
## Создаёт файл package.json.
##
package.json:
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
