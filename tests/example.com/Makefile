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

##
## Собирает все цели проекта.
##
.PHONY: all
all: scripts styles

include ../../make/common.mk
include ../../make/remote.mk
include ../../make/db.mk
include ../../make/wordpress.mk

##
## Собирает сценарии.
##
.PHONY: scripts
scripts: $(uglifyjs)
	$(call run-uglifyjs,$(theme_dir)/main.js,$(theme_dir)/main.min.js)

##
## Собирает стили.
##
.PHONY: styles
styles: $(sass)
	$(call run-sass,$(theme_dir)/bundle.scss,$(theme_dir)/bundle.css)
