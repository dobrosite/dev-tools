# Библиотеки GNU Make

После [../../README.md](подключения) к проекту библиотеки можно включать в свой Makefile файл,
например:

```makefile
all: build

include tools/dev-tools/make/common.mk
```
Желательно подключать библиотеки как можно ближе к началу файла, но после цели по умолчанию (иначе
целью по умолчанию может стать цель из библиотеки).

Файл [Makefile.example](Makefile.example) показывает пример использования библиотек.

## Документация по библиотекам

- [common.mk](common.md)
- [db.mk](db.md)
- [npm.mk](npm.md)
- [remote.mk](remote.md)
- [wordpress.mk](wordpress.md)
