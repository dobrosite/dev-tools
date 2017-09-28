# Библиотеки GNU Make

Вы можете использовать в своих [файлах Make](https://www.gnu.org/software/make/manual/make.html)
описанные ниже библиотеки, подключив этот пакет как
[подмодуль Git](https://git-scm.com/book/ru/v1/Инструменты-Git-Подмодули):

    git submodule add git@git.dobro.site:dobrosite/dev-tools.git tools/dev-tools

После чего библиотеки можно подключать к своему файлу, например:

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
- [remote.mk](remote.md)
