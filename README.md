# Инструменты для разработки сайтов

Пакет предназначен упрощения разработки и поддержки сайтов по процессам компании «Добро.сайт».

- [Библиотеки GNU Make](docs/make/index.md)
- Сценарий для создания дампов БД

## Подключение к проекту

Подключите это хранилище к своему проекту как
[подмодуль Git](https://git-scm.com/book/ru/v1/Инструменты-Git-Подмодули):

    git submodule add https://github.com/dobrosite/dev-tools.git develop/dev-tools
    git commit -am 'Подключены dev-tools'

## Обновление c 0.1.x до 1.x

Выполните

    git submodule deinit tools/dev-tools

Удалите из файла `.gitmodules` код

```
[submodule "tools/dev-tools"]
	path = tools/dev-tools
	url = git@git.dobro.site:dobrosite/dev-tools.git
```

Выполните

    git add .gitmodules
    git rm --cached tools/dev-tools
    rm -rf .git/modules/tools/dev-tools

Выполните действия, описанные в разделе [Подключение к проекту](#Подключение-к-проекту).