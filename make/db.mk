##
## Работа с базами данных
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

## Локальный пользователь и его пароль.
LOCAL_DB_USER ?= user
LOCAL_DB_PASSWORD ?= password

## Файл дампа БД.
DB_DUMP_FILE := db/database.sql

####
## Выполняет команду с локальным СУБД MySQL.
##
run-mysql-local = mysql --user=$(LOCAL_DB_USER) --password=$(LOCAL_DB_PASSWORD) $(1)

####
## Выполняет mysqldump на удалённом сервере
##
## @param $1 Имя базы данных
##
run-mysqldump-remote = mysqldump --host=$(REMOTE_DB_HOST) --user=$(REMOTE_DB_USER) --password=$(REMOTE_DB_PASSWORD) $(1)

##
## Сохраняет дамп БД в db/database.sql
##
.PHONY: db-dump
db-dump:
ifdef REMOTE
	$(assert-required-remote-variables)
ifeq ($(REMOTE_PROTO),ftp)
	ftp -inpu ftp://$(subst @,%40,$(REMOTE_USER)):$(REMOTE_PASSWORD)@$(REMOTE_HOST)$(REMOTE_ROOT)/mysqldump.php \
		$(DEV_TOOLS_DIR)/mysql/mysqldump.php
	curl --data 'user=$(REMOTE_DB_USER)&password=$(REMOTE_DB_PASSWORD)&db=$(REMOTE_DB_NAME)&host=$(REMOTE_DB_HOST)' \
		$(REMOTE_ROOT)/mysqldump.php > $(DB_DUMP_FILE)
	-$(call run-ftp,DELE $(REMOTE_ROOT)/mysqldump.php)
else
	$(call run-ssh,$(run-mysqldump-remote) $(REMOTE_DB_NAME) | xz > /tmp/$(REMOTE_DB_NAME).sql.xz)
	-rm $(DB_DUMP_FILE).xz
	scp $(REMOTE_USER)@$(REMOTE_HOST):/tmp/$(REMOTE_DB_NAME).sql.xz $(DB_DUMP_FILE).xz
	-rm $(DB_DUMP_FILE)
	xz -d $(DB_DUMP_FILE).xz
endif
else
	$(call assert-variable-set,LOCAL_DB_NAME,имя локальной БД)
	mysqldump --user=$(LOCAL_DB_USER) --password=$(LOCAL_DB_PASSWORD) $(LOCAL_DB_NAME) > $(DB_DUMP_FILE)
endif

##
## Загружает дамп из db/database.sql в удалённую БД.
##
## ВНИМАНИЕ! Во избежание потери данных, загрузка на боевой сайт не поддерживается!
##
.PHONY: db-load
db-load:
	$(assert-required-remote-variables)
ifeq ($(REMOTE),prod)
	$(error Запись в боевую базу данных запрещена!)
endif
	$(if $(REMOTE_HOST),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_host))
ifeq ($(REMOTE_PROTO),ftp)
	$(error Загрузка по FTP пока не поддерживается!)
	$(if $(REMOTE_ROOT),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_root))
	$(if $(REMOTE_USER),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_user))
	$(if $(REMOTE_PASSWORD),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_password))
	$(eval tmp_file := $(shell mktemp --tmpdir import-db.XXXX))
	curl --upload-file ../.dev-tools/mysqldump.php ftp://$(REMOTE_HOST)$(REMOTE_ROOT) \
		--user $(REMOTE_USER):$(REMOTE_PASSWORD)
	curl --data 'user=$(prod_db_user)&password=$(prod_db_password)&db=$(prod_db_name)&host=$(prod_db_host)' \
		$(prod_http_root)/mysqldump.php > $(tmp_file)
	-curl ftp://$(REMOTE_HOST)$(REMOTE_ROOT) --request 'DELE mysqldump.php' \
		--user $(REMOTE_USER):$(REMOTE_PASSWORD)
else
	xz $(DB_DUMP_FILE)
	scp $(DB_DUMP_FILE).xz $(REMOTE_USER)@$(REMOTE_HOST):/tmp/
	ssh $(REMOTE_USER)@$(REMOTE_HOST) \
		'xzcat /tmp/$(shell basename $(DB_DUMP_FILE)).xz | mysql --host=$(REMOTE_DB_HOST) --user=$(REMOTE_DB_USER) --password=$(REMOTE_DB_PASSWORD) $(REMOTE_DB_NAME)'
	-rm $(DB_DUMP_FILE).xz
endif

##
## Импортирует БД с удалённого сервера на локальный.
##
.PHONY: db-import
db-import: DB_DUMP_FILE := $(shell mktemp --tmpdir dev-tools-dump-XXXX.sql)
db-import:
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
db-export:
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
