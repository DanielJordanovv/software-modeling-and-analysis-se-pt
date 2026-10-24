# Airbnb — курсова работа по софтуерно моделиране и анализ

**Изготвили:**
- Християн Христов — ф.н. 2401322018
- Даниел Йорданов — ф.н. 2401322019

## За проекта

Разработката представя модел на платформа за краткосрочно настаняване по примера на Airbnb. Целта е да се проследи пътят от моделирането на данните до реализацията на релационна база, хранилище за аналитични данни и интерактивен отчет.

В модела потребителите могат да бъдат домакини или гости. Домакините публикуват имоти с местоположение, тип, капацитет, цена и удобства. Гостите правят резервации, за които се съхраняват статус, дати и плащания. След приключил престой може да бъде оставен отзив с оценка.

Проектът използва учебни примерни данни и не е свързан с реалната платформа Airbnb. Паричните стойности са в условни единици.

## Използвани технологии

- **diagrams.net (draw.io)** — концептуален, логически и Data Warehouse модел;
- **Microsoft SQL Server (T-SQL)** — таблици, ограничения, процедури, функции, тригери и изгледи;
- **Power BI Desktop** — аналитичен модел, DAX мерки и визуализации;
- **HTML, JavaScript и Plotly** — допълнителен уеб вариант на аналитичния доклад.

## Структура на проекта

```text
2401322018_2401322019_Airbnb/
├── database/
│   ├── 01_create_database.sql
│   ├── 02_seed_data.sql
│   ├── 03_functions.sql
│   ├── 04_procedures.sql
│   ├── 05_triggers.sql
│   └── 06_views.sql
├── diagrams/
│   ├── conceptual.drawio
│   ├── conceptual.png
│   ├── logical.drawio
│   ├── logical.png
│   ├── data_warehouse.drawio
│   └── data_warehouse.png
├── warehouse/
│   ├── 01_create_warehouse.sql
│   ├── 02_load_warehouse.sql
│   └── 03_validate_warehouse.sql
├── data/
├── powerbi/
│   ├── Airbnb_Analytics.pbix
│   ├── measures.dax
│   ├── model_relationships.csv
│   ├── report_layout.md
│   ├── source_queries.sql
│   └── queries/
├── dashboard/
│   ├── index.html
│   ├── plotly.min.js
│   ├── report_data.json
│   ├── preview.png
│   └── README.md
├── tests/
├── README_ANALYTICS.md
└── README.md
```

Папката `data/` съдържа CSV експорт на таблиците от аналитичния модел. В `tests/` се намират SQL скриптове за проверка на структурата и бизнес правилата.

## Модели на данните

В папка `diagrams/` са представени трите използвани модела:

1. **Концептуален модел (Chen)** — основните обекти и отношенията между тях.
2. **Логически модел (Crow's Foot)** — таблици, атрибути, първични и външни ключове и кардиналности.
3. **Физически модел на Data Warehouse (UML Database)** — таблици факти, измерения и техните връзки.

Файловете `.drawio` се отварят чрез [diagrams.net](https://app.diagrams.net/). PNG версиите са предназначени за бърз преглед в GitHub.

## Релационна база данни

Оперативната база съдържа 10 таблици:

| Таблица | Съдържание |
|---|---|
| `Users` | Потребители, които могат да бъдат гости и домакини |
| `Countries`, `Cities` | Географски данни за имотите |
| `PropertyTypes` | Видове имоти |
| `Properties` | Обяви, цени, капацитет и информация за домакина |
| `Amenities` | Видове удобства |
| `PropertyAmenities` | Удобствата към конкретен имот |
| `Bookings` | Резервации и периоди на престой |
| `Payments` | Плащания, методи и статуси |
| `Reviews` | Оценки и коментари за завършени престои |

Връзката между `Properties` и `Amenities` е **много към много** и се реализира чрез `PropertyAmenities` със съставен първичен ключ.

Бизнес логиката е отделена в SQL обекти:

- **Процедури:** `sp_CreateBooking`, `sp_RecordPayment`, `sp_CancelBooking`, `sp_CompleteStay`, `sp_SearchAvailableProperties`.
- **Функции:** `fn_GetBookingNights`, `fn_GetPropertyAverageRating`, `fn_GetPropertyRevenue`.
- **Тригери:** `trg_Bookings_Validate`, `trg_Payments_Validate`, `trg_Reviews_Eligibility`.
- **Изгледи:** `vw_PropertyOverview`, `vw_MonthlyRevenue`.

Използвани са външни ключове, ограничения за допустими стойности и проверки за валидни резервации, плащания и отзиви.

## Инсталиране и стартиране на базата

Необходими са **SQL Server 2019 или по-нов** и **SQL Server Management Studio (SSMS)**.

1. Изтеглете проекта от GitHub чрез **Code → Download ZIP** или го клонирайте с Git.
2. Стартирайте SQL Server и отворете SSMS.
3. Свържете се към инстанцията си на SQL Server (например `localhost` или `.\SQLEXPRESS`).
4. Отворете последователно файловете от таблицата и изпълнете всеки чрез **Execute (F5)**:

| Ред | Файл | Действие |
|---:|---|---|
| 1 | `database/01_create_database.sql` | Създава базата `AirbnbCoursework` и таблиците |
| 2 | `database/02_seed_data.sql` | Добавя примерните данни |
| 3 | `database/03_functions.sql` | Създава функциите |
| 4 | `database/04_procedures.sql` | Създава процедурите |
| 5 | `database/05_triggers.sql` | Създава тригерите |
| 6 | `database/06_views.sql` | Създава изгледите |
| 7 | `warehouse/01_create_warehouse.sql` | Създава Data Warehouse таблиците |
| 8 | `warehouse/02_load_warehouse.sql` | Зарежда аналитичните данни |
| 9 | `warehouse/03_validate_warehouse.sql` | Извежда проверки за аналитичния модел |

Скриптовете за създаване и първоначално зареждане са предназначени за **нова база**. Не ги изпълнявайте повторно върху съществуваща инсталация, без да проверите текущите данни. Зареждането на Data Warehouse обновява аналитичните таблици от оперативната база.

След инсталирането можете да разгледате данните с:

```sql
USE AirbnbCoursework;
GO

SELECT TOP (10) * FROM dbo.Properties;
SELECT TOP (10) * FROM dbo.Bookings;
SELECT TOP (10) * FROM dbo.Payments;
SELECT TOP (10) * FROM dbo.Reviews;

SELECT TOP (10) * FROM dw.FactBookings;
SELECT TOP (10) * FROM dw.FactPayments;
SELECT TOP (10) * FROM dw.FactReviews;
```

Допълнителните SQL скриптове в `tests/` са отделени от инсталацията и се изпълняват след зареждане на базата.

## Data Warehouse

Аналитичните таблици са организирани в схема `dw` на базата `AirbnbCoursework`.

**Таблици факти:** `FactBookings`, `FactPayments`, `FactReviews`.

**Таблици измерения:** `DimDate`, `DimGuest`, `DimHost`, `DimProperty`, `DimLocation`, `DimPaymentMethod`, `DimBookingStatus`, `DimPaymentStatus`.

Чрез този модел могат да се разглеждат резервации, приходи и оценки по време, местоположение, имот и статус. Зареждането на данните се извършва със `warehouse/02_load_warehouse.sql`.

## Аналитичен доклад

Основният отчет се намира в `powerbi/Airbnb_Analytics.pbix` и се отваря с **Power BI Desktop**. Той включва четири основни показателя, шест графики и филтри по държава, град, тип имот и година. За да се разгледа отчетът, не е необходимо предварително да се стартира SQL Server, когато данните вече са записани във файла `.pbix`. За обновяването им може да се наложи настройване на източника.

Подробностите за полетата, мерките и работата с отчета са в [README_ANALYTICS.md](README_ANALYTICS.md).

Алтернативният уеб доклад се отваря чрез `dashboard/index.html`. Файлът `plotly.min.js` трябва да остане в същата папка. HTML вариантът използва демонстрационните данни, подготвени за проекта, и не прави автоматични заявки към SQL Server.
