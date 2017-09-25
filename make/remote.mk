##
## Работа с удалёнными системами.
##

__COMMON_MK := 1
__LIB_DIR ?= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

ifndef __COMMON_MK
include $(__LIB_DIR)/common.mk
endif

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
REMOTE_ROOT := $($(REMOTE)_$(REMOTE_PROTO)_root)

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
## Выполняет команду на удалённом сервере по SSH.
##
## @param $1 Команда.
##
run-ssh = ssh $(REMOTE_USER)@$(REMOTE_HOST) '/bin/bash -c "$(if $(REMOTE_ROOT),cd $(REMOTE_ROOT) &&) $(1)"'
