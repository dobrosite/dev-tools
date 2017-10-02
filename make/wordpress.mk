##
## Функции и цели для работы с Wordpress.
##

__WORDPRESS_MK := 1
__LIB_DIR ?= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

ifndef __COMMON_MK
include $(__LIB_DIR)/common.mk
endif

#ifndef __REMOTE_MK
#include $(__LIB_DIR)/remote.mk
#endif

## Путь к wp-cli.
wp-cli := bin/wp

####
## Выполняет команду wp-cli
##
## @param $1 Аргументы команды
##
run-wp-cli = $(wp-cli) --path=htdocs $(1)

htdocs/wp-content/wp-scss:
	$(wp) plugin install --activate wp-scss

htdocs/wp-config.php: htdocs/index.php
	$(wp) core config --dbname=$(DB_NAME) --dbuser=$(DB_USER) --dbpass=$(DB_PASSWORD) \
		--locale=ru_RU
	$(wp) core install --url=http://$(SITE_HOSTNAME).dobrotest.site --title=$(SITE_TITLE) \
		--admin_user=dobrosite --admin_email=support@dobro.site --admin_password=dobro --skip-email
	$(wp) plugin uninstall --deactivate hello akismet

htdocs/index.php: bin/wp
	$(wp) core download --locale=ru_RU

cleanup:
	-$(wp) db reset --yes
	-mkdir tmp
	mv htdocs/wp-content/themes/customized tmp/customized
	-rm -rf bin htdocs
	mkdir -p htdocs/wp-content/themes
	mv tmp/customized htdocs/wp-content/themes/customized
	-rm -rf tmp

##
## Устанавливает wp-cli.
##
$(wp-cli):
ifeq (,$(realpath $(wp-cli)))
	-mkdir tmp
	curl --output tmp/wp-cli.phar \
		https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x tmp/wp-cli.phar
	-mkdir bin
	mv tmp/wp-cli.phar bin/wp
endif
