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

## Папка темы оформления.
theme_dir := $(PUBLIC_DIR)

.PHONY: build
build: $(COMPOSER_VENDOR_DIR) ## Собирает изменившиеся файлы (цель по умолчанию).
	$(MAKE) styles

.PHONY: clean
clean: composer-clean npm-clean ## Очищает проект от созданных файлов.

#.PHONY: scripts
#scripts: $(uglifyjs) ## Собирает сценарии.
#	$(call run-uglifyjs,$(theme_dir)/main.js,$(theme_dir)/main.min.js)

.PHONY: styles
styles: $(sass) ## Собирает стили.
	$(call run-sass,styles/bundle.scss,$(theme_dir))
