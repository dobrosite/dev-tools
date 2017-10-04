# Библиотеки GNU Make

После [../../README.md](подключения) к проекту библиотеки можно включать в свой Makefile файл,
например:

```makefile
all: build

include tools/dev-tools/make/common.mk
```
Подключайте библиотеки после объявления всех переменных, но до объявления целей.

Файл [Makefile.example](Makefile.example) показывает пример использования библиотек.

## Документация по библиотекам

- [common.mk](common.md)
- [composer.mk](composer.md)
- [db.mk](db.md)
- [npm.mk](npm.md)
- [remote.mk](remote.md)
- [wordpress.mk](wordpress.md)

## См. также

- https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
