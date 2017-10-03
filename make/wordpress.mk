##
## Функции и цели для работы с Wordpress.
##

ifndef __WORDPRESS_MK

__WORDPRESS_MK := 1
__LIB_DIR ?= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

include $(__LIB_DIR)/common.mk
include $(__LIB_DIR)/composer.mk
include $(__LIB_DIR)/db.mk

## Путь к wp-cli.
wp-cli := $(COMPOSER_BIN_DIR)/wp

####
## Выполняет команду wp-cli
##
## @param $1 Аргументы команды
##
run-wp-cli = $(wp-cli) --path=htdocs $(1)

##
## Устанавливает Wordpress.
##
wordpress-install:
	$(call assert-variable-set,LOCAL_DB_NAME,имя локальной БД)
	$(MAKE) wordpress-download $(PUBLIC_DIR)/wp-config.php
	$(call run-wp-cli,core install --url=http://$(SITE_DOMAIN).dobrotest.site --title=$(SITE_TITLE) \
		--admin_user=dobrosite --admin_email=support@dobro.site --admin_password=dobro --skip-email)
	$(call run-wp-cli,plugin uninstall --deactivate hello akismet)
	$(call run-wp-cli,plugin install --activate wp-scss)

##
## Устанавливает файлы Wordpress.
##
wordpress-download: $(wp-cli)
	$(call run-wp-cli,core download --path=$(PUBLIC_DIR) --locale=ru_RU)

##
## Создаёт файл настроек Wordpress.
##
$(PUBLIC_DIR)/wp-config.php: $(wp-cli)
	$(call assert-variable-set,LOCAL_DB_NAME,имя локальной БД)
	$(call run-wp-cli,core config --dbname=$(LOCAL_DB_NAME) --dbuser=$(LOCAL_DB_USER) --dbpass=$(LOCAL_DB_PASSWORD) --locale=ru_RU)

##
## Устанавливает wp-cli.
##
$(wp-cli): $(composer.json)
ifeq ($(realpath $(wp-cli)),)
	$(call run-composer,require wp-cli/wp-cli)
endif

# ifndef __WORDPRESS_MK
endif
