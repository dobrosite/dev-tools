##
## Работа с базами данных.
##

ifndef __DB_MK

__DB_MK := 1
__LIB_DIR ?= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

include $(__LIB_DIR)/common.mk
include $(__LIB_DIR)/remote.mk

## Хост удалённого СУБД (по умолчанию localhost).
REMOTE_DB_HOST := $($(REMOTE)_db_host)
ifeq ($(REMOTE_DB_HOST),)
REMOTE_DB_HOST := localhost
endif
## Пользователь СУБД.
REMOTE_DB_USER := $($(REMOTE)_db_user)
## Пароль.
REMOTE_DB_PASSWORD := $($(REMOTE)_db_password)
## Имя удалённой БД.
REMOTE_DB_NAME := $($(REMOTE)_db_name)

## Доступ к локальной БД
LOCAL_DB_HOST ?= localhost
LOCAL_DB_USER ?= user
LOCAL_DB_PASSWORD ?= password

## Файл дампа БД.
DB_DUMP_FILE := db/database.sql

## Опции для mysqldump.
MYSQLDUMP_OPTIONS=\
	--add-drop-table \
	--add-locks \
	--allow-keywords \
	--disable-keys \
	--no-create-db \
	--skip-comments \
	--skip-compact \
	--skip-extended-insert

## Таблицы, которые надо пропустить при создании дампа (через пробел).
MYSQLDUMP_IGNORE_TABLES=

####
## Выполняет команду с локальным СУБД MySQL.
##
## @param $1 Команда с параметрами.
##
run-mysql-local = mysql --user=$(LOCAL_DB_USER) --password=$(LOCAL_DB_PASSWORD) \
	--host=$(LOCAL_DB_HOST) $(1)

####
## Выполняет mysqldump на удалённом сервере.
##
## @param $1 Имя базы данных.
##
run-mysqldump-remote = mysqldump --no-defaults --host=$(REMOTE_DB_HOST) --user=$(REMOTE_DB_USER) \
	--password=$(REMOTE_DB_PASSWORD) $(MYSQLDUMP_OPTIONS) \
	$(foreach table,$(MYSQLDUMP_IGNORE_TABLES),--ignore-table=$(1).$(table)) \
	$(1)

##
## Сохраняет дамп БД в файл.
##
.PHONY: db-dump
db-dump: ## Сохраняет дамп БД в файл.
ifdef REMOTE
	$(assert-required-remote-variables)
ifeq ($(REMOTE_PROTO),ftp)
	$(call run-ftp-upload,$(DEV_TOOLS_DIR)/mysql/mysqldump.php,mysqldump.php)
	curl --data 'user=$(REMOTE_DB_USER)&password=$(REMOTE_DB_PASSWORD)&db=$(REMOTE_DB_NAME)&host=$(REMOTE_DB_HOST)' \
		$(REMOTE_HTTP_ROOT)/mysqldump.php > $(DB_DUMP_FILE)
	-$(call run-ftp,DELE $(REMOTE_ROOT)/mysqldump.php)
else
	$(call run-ssh,$(call run-mysqldump-remote,$(REMOTE_DB_NAME)) | xz > /tmp/$(REMOTE_DB_NAME).sql.xz)
	-rm $(DB_DUMP_FILE).xz
	$(call run-scp-from,/tmp/$(REMOTE_DB_NAME).sql.xz,$(DB_DUMP_FILE).xz)
	-rm $(DB_DUMP_FILE)
	xz -d $(DB_DUMP_FILE).xz
endif
else
	$(call assert-variable-set,LOCAL_DB_NAME,имя локальной БД)
	mysqldump --user=$(LOCAL_DB_USER) --password=$(LOCAL_DB_PASSWORD) $(MYSQLDUMP_OPTIONS) \
		$(LOCAL_DB_NAME) > $(DB_DUMP_FILE)
endif

##
## Загружает дамп из файла БД.
##
## ВНИМАНИЕ! Во избежание потери данных, загрузка на боевой сайт не поддерживается!
##
.PHONY: db-load
db-load: ## Загружает дамп из файла БД.
ifdef REMOTE
	$(assert-required-remote-variables)
ifeq ($(REMOTE),prod)
	$(error Запись в боевую базу данных запрещена!)
endif
	$(if $(REMOTE_HOST),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_host))
ifeq ($(REMOTE_PROTO),ftp)
	$(error Загрузка по FTP пока не поддерживается!)
else
	xz $(DB_DUMP_FILE)
	scp $(DB_DUMP_FILE).xz $(REMOTE_USER)@$(REMOTE_HOST):/tmp/
	ssh $(REMOTE_USER)@$(REMOTE_HOST) \
		'xzcat /tmp/$(shell basename $(DB_DUMP_FILE)).xz | mysql --host=$(REMOTE_DB_HOST) --user=$(REMOTE_DB_USER) --password=$(REMOTE_DB_PASSWORD) $(REMOTE_DB_NAME)'
	-rm $(DB_DUMP_FILE).xz
endif
else
	$(call assert-variable-set,LOCAL_DB_NAME,имя локальной БД)
	$(call run-mysql-local,$(LOCAL_DB_NAME) < $(DB_DUMP_FILE))
endif
##
## Импортирует БД с удалённого сервера на локальный.
##
.PHONY: db-import
db-import: DB_DUMP_FILE := $(shell mktemp --tmpdir dev-tools-dump-XXXX.sql)
db-import: ## Импортирует БД с удалённого сервера на локальный.
	$(assert-required-remote-variables)
	$(call assert-variable-set,LOCAL_DB_NAME,имя локальной БД)
	$(MAKE) db-dump DB_DUMP_FILE=$(DB_DUMP_FILE)
	$(call run-mysql-local,$(LOCAL_DB_NAME) < $(DB_DUMP_FILE))
	-rm $(DB_DUMP_FILE)

##
## Экспортирует БД с локального сервера на удалённый.
##
## ВНИМАНИЕ! Во избежание потери данных, экспорт на боевой сайт не поддерживается!
##
.PHONY: db-export
db-export: DB_DUMP_FILE := $(shell mktemp --tmpdir dev-tools-dump-XXXX.sql)
db-export: ## Экспортирует БД с локального сервера на удалённый.
	$(assert-required-remote-variables)
	$(call assert-variable-set,LOCAL_DB_NAME,имя локальной БД)
ifeq ($(REMOTE),prod)
	$(error Экспорт БД на боевой хостинг запрещён!)
endif
	$(MAKE) db-dump DB_DUMP_FILE=$(DB_DUMP_FILE)
	$(MAKE) db-load REMOTE=$(REMOTE) DB_DUMP_FILE=$(DB_DUMP_FILE)
	-rm $(DB_DUMP_FILE)

# ifndef __DB_MK
endif
