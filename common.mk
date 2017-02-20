SHELL = /bin/sh

.PHONY: import-db

REMOTE_PROTO := $($(REMOTE)_proto)
REMOTE_HOST := $($(REMOTE)_$(REMOTE_PROTO)_host)
REMOTE_USER := $($(REMOTE)_$(REMOTE_PROTO)_user)
REMOTE_PASSWORD := $($(REMOTE)_$(REMOTE_PROTO)_password)
REMOTE_ROOT := $($(REMOTE)_$(REMOTE_PROTO)_root)

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

import-db:
	$(call assert_variable_set, REMOTE, имя конфигурации сайта)
	$(call assert_variable_set, LOCAL_DB_NAME, имя локальной БД)
	$(if $(REMOTE_HOST),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_host))
	$(if $(REMOTE_USER),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_user))
	$(if $(REMOTE_PASSWORD),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_password))
	$(if $(REMOTE_ROOT),,$(error Undefined variable $(REMOTE)_$(REMOTE_PROTO)_root))
	$(eval tmp_file := $(shell mktemp --tmpdir import-db.XXXX))
ifeq ($(REMOTE_PROTO),ftp)
	curl --upload-file ../.dev-tools/mysqldump.php ftp://$(REMOTE_HOST)$(REMOTE_ROOT) \
		--user $(REMOTE_USER):$(REMOTE_PASSWORD)
	curl --data 'user=$(prod_db_user)&password=$(prod_db_password)&db=$(prod_db_name)&host=$(prod_db_host)' \
		$(prod_http_root)/mysqldump.php > $(tmp_file)
	-curl ftp://$(REMOTE_HOST)$(REMOTE_ROOT) --request 'DELE mysqldump.php' \
		--user $(REMOTE_USER):$(REMOTE_PASSWORD)
else
	ssh $(test_host) \
		'mysqldump --user=$(test_db_user) --password=$(test_db_password) $(test_db_name) | xz > /tmp/$(test_db_name).sql.xz'
	scp $(test_host):/tmp/$(test_db_name).sql.xz /tmp/
	-rm /tmp/$(test_db_name).sql
	xz -d /tmp/$(test_db_name).sql.xz
	mysql --user=$(DB_USER) --password=$(DB_PASSWORD) $(DB_NAME) < /tmp/$(test_db_name).sql
	rm /tmp/$(test_db_name).sql
endif
ifdef LOCAL_DB_USER
	mysql --user=$(LOCAL_DB_USER) --password=$(LOCAL_DB_PASSWORD) $(LOCAL_DB_NAME) < $(tmp_file)
else
	mysql $(LOCAL_DB_NAME) < $(tmp_file)
endif
	-rm $(tmp_file)
