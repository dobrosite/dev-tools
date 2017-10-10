.PHONY: build
build: prepare
	php box.phar build
	-rm mysqldump.php
	mv mysqldump.phar mysqldump.php

.PHONY: prepare
prepare:
ifeq ($(realpath vendor),)
	composer install
endif
ifeq ($(realpath box.phar),)
	curl -LSs https://box-project.github.io/box2/installer.php | php
endif
