# Airbnb — моделиране и анализ на база данни

**Курсова работа по „Софтуерно моделиране и анализ“**

| Автор | Факултетен номер |
| --- | --- |
| Християн Христов | 2401322018 |
| Даниел Йорданов | 2401322019 |

**Тема:** Airbnb — учебен модел на онлайн платформа за краткосрочно настаняване  
**СУБД:** Microsoft SQL Server 2019+  
**Диаграми:** Chen, Crow's Foot, UML Database Notation  
**Аналитичен слой:** SQL Server Data Warehouse, Power BI помощни файлове, HTML/Plotly доклад; допълнителен Streamlit/Plotly проект

## 1. Резюме

Проектът представя моделиране, реализация и анализ на данните на платформа от типа Airbnb. Гостите създават резервации, домакините предлагат имоти, а системата съхранява информация за местоположения, удобства, плащания и отзиви. Проектът включва оперативна релационна база, SQL бизнес логика, демонстрационни данни и аналитично хранилище.

Реализацията е **учебен модел**, а не копие на действителната система на Airbnb. Всички примерни записи са синтетични.

## 2. Съответствие с изискванията

| Изискване | Реализация |
| --- | --- |
| Онлайн платформа | Airbnb |
| Концептуален модел | `diagrams/conceptual.drawio` (Chen), PNG преглед |
| Логически модел | `diagrams/logical.drawio` (Crow's Foot), PNG преглед |
| ≥ 8 обекта и ≥ 30 атрибута | 10 релационни таблици и 57 колони |
| Връзка много към много | `Properties` ↔ `Amenities` чрез `PropertyAmenities` |
| Релационна база + данни | Microsoft SQL Server, `database/` |
| ≥ 2 процедури, 2 функции, 2 тригера | 5 процедури, 3 функции и 3 тригера |
| DW диаграма: ≥ 3 факта, ≥ 6 измерения | 3 факта, 8 измерения, `diagrams/data_warehouse.drawio` (UML) |
| ≥ 4 визуализации | 6 визуализации и 4 KPI показателя в интерактивния доклад |
| Документация и инсталация | Настоящият README |

**Разграничение:** `dashboard/` е готов HTML/Plotly доклад. `powerbi/` съдържа изходни заявки, мерки и инструкции, **но не съдържа автоматично завършен `.pbix` файл**. Ако при предаването се изисква конкретно Power BI, Tableau или Looker Studio, трябва да се създаде и запази отчет в избрания инструмент. В проекта е предвиден и самостоятелен Streamlit/Plotly аналитичен вариант.

## 3. Организация на файловете

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
│   ├── DimDate.csv
│   ├── DimGuest.csv
│   ├── DimHost.csv
│   ├── DimProperty.csv
│   ├── DimLocation.csv
│   ├── DimPaymentMethod.csv
│   ├── DimBookingStatus.csv
│   ├── DimPaymentStatus.csv
│   ├── FactBookings.csv
│   ├── FactPayments.csv
│   └── FactReviews.csv
├── dashboard/
│   ├── index.html
│   ├── plotly.min.js
│   ├── preview.png
│   ├── report_data.json
│   └── README.md
├── powerbi/
│   ├── measures.dax
│   ├── model_relationships.csv
│   ├── source_queries.sql
│   ├── report_layout.md
│   └── queries/                 (11 Power Query .m файла)
├── tests/
│   ├── 01_validate.sql
│   ├── 02_transaction_smoke_test.sql
│   ├── 03_integrity_tests.sql
│   ├── 04_validate_warehouse.sql
│   └── expected_values.json
├── analytics_app/                (незадължителен допълнителен компонент)
│   ├── app.py
│   ├── requirements.txt
│   └── README.md
├── docs/                         (незадължителна допълнителна документация)
│   └── POWER_BI_DESKTOP.md
├── README_ANALYTICS.md
└── README.md
```

Това е пълната **планирана структура** на проекта. Допълнителните папки `analytics_app/` и `docs/` се използват само ако съответните файлове са качени. Основната демонстрация може да бъде изпълнена без тях.

## 4. Необходими инструменти

- Microsoft SQL Server 2019 или по-нова версия (Developer или Express).
- SQL Server Management Studio (SSMS) с връзка към работещата SQL Server инстанция.
- diagrams.net (draw.io) за преглед и редакция на диаграмите.
- Браузър (Chrome/Edge/Firefox) за HTML доклада.
- Power BI Desktop при създаване на нативен `.pbix` отчет.
- Python 3.10+ **само** за допълнителния Streamlit проект.

## 5. Изтегляне

1. В GitHub отворете директорията `course-work/Implementations/2401322018_2401322019_Airbnb/`.
2. От основната страница на хранилището изберете **Code → Download ZIP** или клонирайте fork-а.
3. Разархивирайте и отворете проектната директория. Запазете относителните пътища към файловете.

## 6. Първоначално създаване и стартиране на SQL базата

1. Стартирайте SQL Server и отворете SSMS.
2. Изберете **Connect → Database Engine**, въведете името на вашата инстанция (например `localhost` или `.\\SQLEXPRESS`) и използвайте подходящата автентикация.
3. За всеки скрипт изберете **File → Open → File** и го изпълнете чрез **Execute (F5)**.
4. Изпълнявайте файловете **в следния ред**:

| Ред | Файл | Роля |
| ---: | --- | --- |
| 1 | `database/01_create_database.sql` | Създава `AirbnbCoursework`, таблици, ограничения и индекси |
| 2 | `database/02_seed_data.sql` | Зарежда примерни записи |
| 3 | `database/03_functions.sql` | Създава 3 функции |
| 4 | `database/04_procedures.sql` | Създава 5 съхранени процедури |
| 5 | `database/05_triggers.sql` | Създава 3 тригера |
| 6 | `database/06_views.sql` | Създава 2 SQL изгледа |
| 7 | `warehouse/01_create_warehouse.sql` | Създава аналитичната схема `dw` и DW таблиците |
| 8 | `warehouse/02_load_warehouse.sql` | Зарежда измеренията и фактите |
| 9 | `warehouse/03_validate_warehouse.sql` | Проверява DW структурата и съответствието на данните |

Всеки от скриптовете е предназначен за T-SQL и използва `GO`, затова изпълнявайте с SSMS или съвместим инструмент като `sqlcmd`. Скриптовете за първоначално създаване и демонстрационни данни **не са предназначени за многократно изпълнение** върху вече попълнена база. Не ги стартирайте втори път, без да знаете дали обектите и записите вече съществуват.

### Проверка на създадената база

```sql
USE AirbnbCoursework;
GO
SELECT COUNT(*) AS UsersCount FROM dbo.Users;
SELECT COUNT(*) AS PropertiesCount FROM dbo.Properties;
SELECT COUNT(*) AS BookingsCount FROM dbo.Bookings;
SELECT COUNT(*) AS PaymentsCount FROM dbo.Payments;
SELECT COUNT(*) AS ReviewsCount FROM dbo.Reviews;
SELECT COUNT(*) AS FactBookingsCount FROM dw.FactBookings;
SELECT COUNT(*) AS FactPaymentsCount FROM dw.FactPayments;
SELECT COUNT(*) AS FactReviewsCount FROM dw.FactReviews;
GO
```

При непроменените демонстрационни данни очакваните стойности са **20 потребители, 18 имота, 49 резервации, 47 плащания, 24 отзива**. Фактните таблици трябва да съдържат съответно 49, 47 и 24 реда.

## 7. Оперативен модел и бизнес логика

### Таблици

`Countries`, `Cities`, `Users`, `PropertyTypes`, `Properties`, `Amenities`, `PropertyAmenities`, `Bookings`, `Payments`, `Reviews`.

За основните връзки се използват първични и външни ключове, `CHECK` и `UNIQUE` ограничения. Връзката много към много между имоти и удобства е реализирана чрез съставния първичен ключ `(PropertyID, AmenityID)` на `PropertyAmenities`.

### Съхранени процедури (5)

- `dbo.sp_CreateBooking` — проверява капацитет, дати и наличност, след което създава резервация.
- `dbo.sp_RecordPayment` — записва плащане по чакаща резервация и я потвърждава.
- `dbo.sp_CancelBooking` — отказва резервация при допустими условия.
- `dbo.sp_CompleteStay` — маркира завършен престой.
- `dbo.sp_SearchAvailableProperties` — извежда свободни имоти за дати, град и брой гости.

Пример за справка без промяна на данни:

```sql
USE AirbnbCoursework;
GO
EXEC dbo.sp_SearchAvailableProperties
    @CityID = 1,
    @CheckInDate = '2027-03-01',
    @CheckOutDate = '2027-03-05',
    @GuestCount = 2;
GO
```

### Функции (3)

- `dbo.fn_GetBookingNights` — брой нощувки.
- `dbo.fn_GetPropertyAverageRating` — средна оценка на имот.
- `dbo.fn_GetPropertyRevenue` — сума на успешно завършени плащания за имот.

```sql
SELECT dbo.fn_GetBookingNights(1) AS Nights;
SELECT dbo.fn_GetPropertyAverageRating(1) AS AverageRating;
SELECT dbo.fn_GetPropertyRevenue(1) AS PropertyRevenue;
```

### Тригери (3)

- `dbo.trg_Bookings_Validate` — ограничения за капацитет, гост и припокривания.
- `dbo.trg_Payments_Validate` — контрол на плащанията спрямо статус и сума.
- `dbo.trg_Reviews_Eligibility` — отзив само за допустим завършен престой.

**SQL изгледи:** `dbo.vw_PropertyOverview` и `dbo.vw_MonthlyRevenue`.

## 8. Data Warehouse

DW е реализиран в схема **`dw`** на същата база `AirbnbCoursework`.

**Таблици факти:** `FactBookings`, `FactPayments`, `FactReviews` (3).

**Таблици измерения:** `DimDate`, `DimGuest`, `DimHost`, `DimProperty`, `DimLocation`, `DimPaymentMethod`, `DimBookingStatus`, `DimPaymentStatus` (8).

Фактите съдържат ключови показатели за броя и стойността на резервациите, плащанията и оценките; измеренията позволяват групиране по дати, имоти, локации, гости, домакини и статуси. Физическият модел е в [diagrams/data_warehouse.drawio](diagrams/data_warehouse.drawio) и [PNG](diagrams/data_warehouse.png).

За обновяване след промени в оперативната база изпълнете отново **само** `warehouse/02_load_warehouse.sql`, след което `warehouse/03_validate_warehouse.sql`. Зареждането е пълно презареждане, не инкрементален процес.

## 9. Аналитичен доклад (6 визуализации)

### Вариант A — HTML/Plotly (готов за локално отваряне)

1. Отворете `dashboard/index.html` с двоен клик в браузър.
2. Уверете се, че `dashboard/plotly.min.js` е в същата директория като HTML файла.
3. Демонстрирайте филтрите по държава, град, тип имот и година.

Визуализациите са: резервации по месец, постъпления по град, статуси на резервации, средна оценка по град, имоти по тип, постъпления по платежен метод. Показват се и четири KPI стойности.

![Преглед на аналитичния доклад](dashboard/preview.png)

Това е **самостоятелен HTML доклад**, не Power BI файл. Използва статичен експорт от примерните DW данни. За актуализиране на показателите след промени в SQL Server е нужен нов експорт.

### Вариант B — Power BI Desktop

1. След изпълнение на DW скриптовете стартирайте Power BI Desktop.
2. Изберете **Get data → SQL Server** и въведете името на SQL Server инстанцията и база `AirbnbCoursework` (Import mode). Алтернатива е импортиране на CSV файловете от `data/`.
3. От схема `dw` заредете 11-те таблици (3 факта и 8 измерения).
4. В Model view създайте връзките от `powerbi/model_relationships.csv`. За `FactBookings` е активна датата `BookingDateKey`; връзките към `CheckInDateKey` и `CheckOutDateKey` следва да са неактивни.
5. Добавете една по една DAX мерките от `powerbi/measures.dax` чрез **Modeling → New measure**.
6. Създайте визуализациите според `powerbi/report_layout.md`, след което запазете `powerbi/Airbnb_Analytics.pbix`.

**Уточнение:** Наличието на `.dax`, `.m`, `.csv` и HTML файлове не означава, че е създаден `.pbix`. За безспорно представяне на Power BI отчет трябва действително да се запише `.pbix` в Power BI Desktop.

### Вариант C — Streamlit/Plotly (допълнителен компонент)

Ако папката `analytics_app/` е качена, инсталирайте Python 3.10+ и изпълнете **от корена на проекта**:

```bash
python -m pip install -r analytics_app/requirements.txt
python -m streamlit run analytics_app/app.py
```

След това отворете локалния адрес, показан в терминала (обикновено `http://localhost:8501`). Streamlit чете данни от `data/`, тоест използва демонстрационните CSV експорти, а не текуща SQL връзка.

## 10. SQL тестове

След създаване и попълване на базата и DW изпълнете в SSMS:

1. `tests/01_validate.sql` — структура, ограничения, броячи и стойности.
2. `tests/02_transaction_smoke_test.sql` — създаване на резервация и плащане в транзакция с `ROLLBACK`.
3. `tests/03_integrity_tests.sql` — проверка дали тригерите отхвърлят некоректни записи.
4. `tests/04_validate_warehouse.sql` — факти, измерения и съответствие на DW.

`tests/expected_values.json` съдържа контролни показатели за примерните данни. **Не използвайте тази процедура за демонстрация върху продукционни данни.** Наличието на тестовете в хранилището не доказва, че са изпълнени: проверете резултатите в SSMS и отстранете всички съобщени грешки.

## 11. Отваряне на диаграмите

Отворете [diagrams.net](https://app.diagrams.net/) → **File → Open From → Device** и заредете съответния `.drawio` файл. PNG изображенията са за бърз преглед в GitHub.

- **Chen notation:** `conceptual.drawio` — концептуален модел.
- **Crow's Foot notation:** `logical.drawio` — логически модел със съответстващи на SQL първични и външни ключове.
- **UML Database notation:** `data_warehouse.drawio` — физически DW модел.

## 12. Демонстрация пред преподавателя

1. Покажете трите диаграми и връзката много към много.
2. Отворете `database/01_create_database.sql` и обяснете таблиците, ключовете и ограниченията.
3. Покажете резултат от `sp_SearchAvailableProperties`, една SQL функция и дефинициите на тригерите.
4. Изпълнете тестовете и покажете успешните резултати.
5. Покажете DW модела и данните в трите фактни таблици.
6. Отворете аналитичния доклад и демонстрирайте поне четири графики и филтрите.
7. Ако сте създали `.pbix`, покажете модела и визуализациите в Power BI Desktop.

## 13. Ограничения

- Примерните данни са учебни; няма реални Airbnb акаунти или разплащания.
- Паричните стойности не включват поле за валута и трябва да се четат като условни парични единици.
- HTML докладът и CSV експорти не се обновяват автоматично от SQL Server.
- Не се предоставя пълен уебсайт с потребителски интерфейс за резервации — фокусът е върху моделирането, SQL и аналитиката.

---

**Автори:** Християн Христов (2401322018), Даниел Йорданов (2401322019).
