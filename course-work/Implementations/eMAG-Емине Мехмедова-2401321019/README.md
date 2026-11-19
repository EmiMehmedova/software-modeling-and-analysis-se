# eMAG – база данни на онлайн магазин

**Студент:** Емине Мехмедова
**Факултетен номер:** 2401321019
**Проект:** eMAG

## Кратко описание

Проектът моделира базата данни на онлайн магазина **eMAG**: клиенти, продукти, категории, продавачи, поръчки и ревюта.

Включва:
- **Концептуален модел** в Chen нотация (`eMAG_Conceptual`)
- **Логически модел** в Crow's Foot нотация (`eMAG_Logical`): 7 таблици, 31 атрибута и връзка много към много (Orders ↔ Products чрез OrderItems)
- **Релационна база данни** в MS SQL Server със съхранена процедура, функция, тригер и изглед (VIEW)
- **Data Warehouse** диаграма в UML нотация (`eMAG_DataWarehouse`): 3 таблици на фактите и 6 таблици на измеренията
- **Power BI доклад** (`eMAG_Report`) с 4 визуализации

## Файлове

| Файл | Описание |
|---|---|
| `eMAG_Conceptual.drawio` / `.png` | Концептуален модел (Chen) |
| `eMAG_Logical.drawio` / `.png` | Логически модел (Crow's Foot) |
| `eMAG_DataWarehouse.drawio` / `.png` | Data Warehouse модел (UML) |
| `01_create_database.sql` | Създава базата `eMAG` и таблиците |
| `02_insert_data.sql` | Пълни таблиците с данни |
| `03_procedure_function_trigger.sql` | Съхранена процедура, функция и тригер |
| `04_report_view.sql` | Изглед `vw_Sales` за Power BI доклада |
| `05_tests.sql` | Тестове на процедурата, функцията и тригера |
| `eMAG_Report.pbix` / `.pdf` | Power BI доклад |

## Обекти в базата

| Тип | Име | Какво прави |
|---|---|---|
| Функция | `fn_CustomerTotalSpent` | Връща колко общо е похарчил даден клиент (без отказаните поръчки) |
| Съхранена процедура | `sp_GetCustomerOrders` | Показва всички поръчки на даден клиент с продуктите в тях |
| Тригер | `trg_UpdateOrderTotal` | При добавяне, промяна или изтриване на продукт в поръчка автоматично преизчислява `TotalAmount` |
| Изглед | `vw_Sales` | Събира данните за продажбите в една таблица за Power BI |

## Инсталация и стартиране

### Изисквания
- Microsoft SQL Server (например SQL Server 2022 Express)
- SQL Server Management Studio (SSMS)
- Power BI Desktop
- draw.io (app.diagrams.net) за отваряне на диаграмите

### База данни
1. Отворете **SSMS** и се свържете със сървъра (например `localhost\SQLEXPRESS`).
2. Изпълнете скриптовете **по ред** (File → Open → File, после F5):
   1. `01_create_database.sql`
   2. `02_insert_data.sql`
   3. `03_procedure_function_trigger.sql`
   4. `04_report_view.sql`
3. За проверка изпълнете `05_tests.sql`. Той тества функцията, процедурата и тригера и може да се пуска многократно.

### Power BI доклад
1. Отворете `eMAG_Report.pbix` в **Power BI Desktop**.
2. Ако името на сървъра е различно: **Transform data → Data source settings → Change Source** и въведете вашия сървър и база `eMAG`.
3. Натиснете **Refresh**.

### Диаграми
Отворете `.drawio` файловете в **app.diagrams.net** (Open Existing Diagram). Снимките са и като `.png`.
