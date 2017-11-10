##
## Работа с удалёнными системами.
##

ifndef __REMOTE_MK

__REMOTE_MK := 1
__LIB_DIR ?= $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

include $(__LIB_DIR)/common.mk

## Протокол доступа к удалённой системе (ssh, ftp).
REMOTE_PROTO := $($(REMOTE)_proto)
ifeq ($(REMOTE),test)
ifeq ($(REMOTE_PROTO),)
REMOTE_PROTO := ssh
endif
endif
## Хост для подключения.
REMOTE_HOST := $($(REMOTE)_$(REMOTE_PROTO)_host)
## Имя пользователя.
REMOTE_USER := $($(REMOTE)_$(REMOTE_PROTO)_user)
## Пароль (при необходимости)
REMOTE_PASSWORD := $($(REMOTE)_$(REMOTE_PROTO)_password)
## Корневая папка.
REMOTE_ROOT := $(patsubst %/,%,$($(REMOTE)_$(REMOTE_PROTO)_root))
## Корневой URK.
REMOTE_HTTP_ROOT := $($(REMOTE)_http_root)

ifeq ($(REMOTE),test)
ifeq ($(REMOTE_HOST),)
REMOTE_HOST := dobrotest.site
endif
ifeq ($(REMOTE_USER),)
REMOTE_USER := dobrotest
endif
endif

####
## Проверяет что заданы все необходимые для удалённого доступа переменные.
##
define assert-required-remote-variables =
	$(call assert-variable-set,REMOTE,имя конфигурации сайта)
	$(if $(REMOTE_HOST),,$(error Не задана переменная $(REMOTE)_$(REMOTE_PROTO)_host))
endef

####
## Выполняет команду FTP.
##
## @param $1 Команда.
##
run-ftp = curl ftp://$(REMOTE_HOST) --user $(REMOTE_USER):$(REMOTE_PASSWORD) --request '$(1)'

####
## Загружает файл на сервер FTP.
##
## @param $1 Загружаемый файл.
## @param $1 Путь для загрузки на сервере относительно $(REMOTE_ROOT).
##
run-ftp-upload = curl --upload-file '$(1)' ftp://$(REMOTE_HOST)$(REMOTE_ROOT) --user $(REMOTE_USER):$(REMOTE_PASSWORD)

####
## Выполняет команду на удалённом сервере по SSH.
##
## @param $1 Команда.
##
run-ssh = ssh $(REMOTE_USER)@$(REMOTE_HOST) '/bin/bash -c "$(if $(REMOTE_ROOT),cd $(REMOTE_ROOT) &&) $(1)"'

# ifndef __REMOTE_MK
endif
