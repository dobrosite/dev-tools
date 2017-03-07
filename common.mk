SHELL = /bin/sh

.PHONY: import-db

REMOTE_PROTO := $($(REMOTE)_proto)
REMOTE_HOST := $($(REMOTE)_$(REMOTE_PROTO)_host)
REMOTE_USER := $($(REMOTE)_$(REMOTE_PROTO)_user)
REMOTE_PASSWORD := $($(REMOTE)_$(REMOTE_PROTO)_password)
REMOTE_ROOT := $($(REMOTE)_$(REMOTE_PROTO)_root)

REMOTE_DB_NAME := $($(REMOTE)_db_name)
REMOTE_DB_HOST := $($(REMOTE)_db_host)
ifeq ($(REMOTE_DB_HOST),)
REMOTE_DB_HOST := localhost
endif
REMOTE_DB_USER := $($(REMOTE)_db_user)
REMOTE_DB_PASSWORD := $($(REMOTE)_db_password)

##
# Проверяет что указанные переменные установлены и их значения не пусты.
# В случае ошибки прерывает работу сценария.
#
# @param Имя переменной для проверки.
# @param Сообщение при ошибке (опционально).
#
assert_variable_set = $(strip $(foreach 1,$1, \
        $(call __assert_variable_set,$1,$(strip $(value 2)))))

__assert_variable_set = $(if $(value $1),,$(error Undefined variable $1$(if $2, ($2))))

##
# Импортирует БД с удалённого сервера на локальный.
#
import-db:
	$(call assert_variable_set, REMOTE, имя конфигурации сайта)
	$(call assert_variable_set, LOCAL_DB_NAME, имя локальной БД)
	$(if $(REMOTE_HOST),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_host))
ifeq ($(REMOTE_PROTO),ftp)
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
	ssh $(REMOTE_USER)@$(REMOTE_HOST) \
		'mysqldump --user=$(REMOTE_DB_USER) --password=$(REMOTE_DB_PASSWORD) $(REMOTE_DB_NAME) | xz > /tmp/$(REMOTE_DB_NAME).sql.xz'
	scp $(REMOTE_USER)@$(REMOTE_HOST):/tmp/$(REMOTE_DB_NAME).sql.xz /tmp/
	$(eval tmp_file := /tmp/$(REMOTE_DB_NAME).sql)
	-rm $(tmp_file)
	xz -d /tmp/$(REMOTE_DB_NAME).sql.xz
endif
ifdef LOCAL_DB_USER
	mysql --user=$(LOCAL_DB_USER) --password=$(LOCAL_DB_PASSWORD) $(LOCAL_DB_NAME) < $(tmp_file)
else
	mysql $(LOCAL_DB_NAME) < $(tmp_file)
endif
	-rm $(tmp_file)

##
# Экспортирует БД с локального сервера на удалённый.
#
# ВНИМАНИЕ! Во избежание потери данных, экспорт на боевой сайт не поддерживается!
#
export-db:
	$(call assert_variable_set, REMOTE, имя конфигурации сайта)
ifeq ($(REMOTE),prod)
	$(error Export to production server is prohibited!)
endif
	$(call assert_variable_set, LOCAL_DB_NAME, имя локальной БД)
	$(if $(REMOTE_HOST),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_host))
	$(eval tmp_file := $(shell mktemp --tmpdir export-db.XXXX))
	$(eval tmp_basename := $(shell basename $(tmp_file)))
ifdef LOCAL_DB_USER
	mysqldump --user=$(LOCAL_DB_USER) --password=$(LOCAL_DB_PASSWORD) $(LOCAL_DB_NAME) > $(tmp_file)
else
	mysqldump $(LOCAL_DB_NAME) > $(tmp_file)
endif
ifeq ($(REMOTE_PROTO),ftp)
	$(error Export over FTP is not supported yet!)
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
	xz $(tmp_file)
	scp $(tmp_file).xz $(REMOTE_USER)@$(REMOTE_HOST):/tmp/
	ssh $(REMOTE_USER)@$(REMOTE_HOST) \
		'xzcat /tmp/$(tmp_basename).xz | mysql --user=$(REMOTE_DB_USER) --password=$(REMOTE_DB_PASSWORD) $(REMOTE_DB_NAME)'
	-rm $(tmp_file).xz
endif
	-rm $(tmp_file)
