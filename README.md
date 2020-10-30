# Обзор

В этом каталоге находится пример статьи, выполенной в стиле одностраничного документа формата А5.
Такой формат характерен для [МНТК МЭИ](https://reepe.mpei.ru).

Для работы с этим шаблоном необходимо установить язык программирования [R](https://cran.r-project.org/bin/windows) и среду [RStudio](https://www.rstudio.com/products/rstudio/download/preview/).
Также рекомендуется наличие [Markdown](http://daringfireball.net/projects/markdown)-редактора - например, [ReText](https://github.com/retext-project/retext) или [Typora](https://typora.io).

Полный список файлов и каталогов представлен в таблице ниже:

| Имя  | Назначение и содержание |
| --------- | ----------------------- |
| `/img` | Папка для иллюстраций |
| `10pt.eqp` | Файл с настройками форматирования формул MathType |
| `article.bib` | Список библиографических ссылок в формате [BibTeX](https://ru.wikipedia.org/wiki/BibTeX) |
| `article.Rproj` | Файл проекта для RStudio |
| `_bookdown.yml` | Настройки для bookdown документа в формате YAML (имя выходного файла, подписи рисунков, таблиц и листингов) |
| `filter.lua` | Файл Lua-фильтра для Pandoc, служит для автоматического редактирования docx документа в соответствии с шаблоном МНТК |
| `filter-table.lua` | Файл Lua-фильтра для Pandoc для форматирования таблиц документа в соответствии с шаблоном МНТК |
| `gost-r-7-0-5-2008-numeric.csl` | Файл CSL-стиля для  формирования списка литературы по ГОСТ |
| `index.Rmd` | Основной документ, содержит настройки в формате YAML (в том числе название статьи) и тело статьи |
| `styles-a5.docx` | Шаблон документа MS Word со стилями оформления |

**Примечание**: после клонирования этого репозитория и запуска компиляции документа в программе RStudio с помощью кнопки *Build All* в списке файлов появятся следующие элементы:

* файл `article.html` - книга в виде единого HTML-документа (соответствует формату  `bookdown::html_document2`);
* папка `_book` со следующими файлами:
  * `article.docx` - книга в формате docx (Microsoft Word) с учетом файла-шаблона *styles-a5.docx*.

# Использование шаблона

Подготовку статьи следует выполнять в следующем порядке:

1. Задать авторов статьи и ее название в соответствующих местах файла `index.Rmd`.
2. Написать текст статьи в файле `index.Rmd` с использованием Markdown и его расширений ([RMarkdown Cheat Sheet](https://raw.githubusercontent.com/rstudio/cheatsheets/master/rmarkdown-2.0.pdf) и [bookdown](https://bookdown.org/home/getting-started.html)).
3. Преобразовать документ в HTML-формат кнопкой *Build Book* → `bookdown::html_document2` для проверки правильности нумерации рисунков, таблиц, формул и ссылок на них.
4. Преобразовать документ в docx-формат  кнопкой *Build Book* → `bookdown::docx_document2`.

После получения финальной версии docx-документа следует:

1. Преобразовать все формулы в MathType: 

	1. На ленте *MathType* нажать кнопку *Convert Equations*;
  в открывшемся окне установить в области *Equation types to convert* галочку *Word 2007 and late (OMML) equations*, затем в области *Convert equations to* выбрать *MathType equations (OLE objects)*.  
	2. Нажать кнопку *Convert* и ждать результата.
	  
	   > **Примечание:** При конвертации из OMML в MathType могут не работать LaTeX-окружения `split` и `multiline`, поэтому надежнее использовать `array`.

	3. Отформатировать все формулы (греческие буквы - прямо и т.п.) - нажать на ленте *MathType* кнопку *Format Equations*, в области *Format equations using preferences from* установить переключатель в положение *MathType preference file*, нажать кнопку *Browse*, выбрать файл настроек `10pt.eqp` и применить изменения кнопкой *OK*.

       В результате ко всем формулам будет применен стиль *MTDisplayEquation*, сами формулы будут расположены в центре колонки, а их номера будут выравнены табуляцией по правому краю.

2. Проконтроллировать ширину таблиц - она должна быть не более 115 мм (или 100%).

