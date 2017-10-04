prod_proto = ftp
prod_ftp_host = ftp.example.com
prod_ftp_user = user
prod_ftp_password = password
prod_ftp_root = /
prod_http_root = http://example.com/
prod_db_host = localhost:3306
prod_db_name = example
prod_db_user = user
prod_db_password = password

test_http_root = http://example.com.dobrotest.site
test_db_name = example
test_db_user = user
test_db_password = password

COMPOSER_ROOT_DIR = htdocs
COMPOSER_BIN_DIR = htdocs/bin

include ../../make/common.mk
include ../../make/npm.mk
include ../../make/composer.mk
include ../../make/remote.mk
include ../../make/db.mk
include ../../make/wordpress.mk

.PHONY: build
build: ## Собирает изменившиеся файлы (цель по умолчанию).
	$(MAKE) prepare
#	$(MAKE) scripts styles

## Готовит проект и окружение к сборке.
.PHONY: prepare
prepare: tools/dev-tools/.git

#.PHONY: scripts
#scripts: $(uglifyjs) ## Собирает сценарии.
#	$(call run-uglifyjs,$(theme_dir)/main.js,$(theme_dir)/main.min.js)

#.PHONY: styles
#styles: $(sass) ## Собирает стили.
#	$(call run-sass,$(theme_dir)/bundle.scss,$(theme_dir)/bundle.css)

## Устанавливает dev-tools.
tools/dev-tools/.git:
	git submodule init
	git submodule update
