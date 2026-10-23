# Airbnb Analytics — Power BI доклад

## Идея на доклада

Докладът показва резервациите, получените плащания и оценките на имотите. Данните идват от Data Warehouse схемата `dw` в базата `AirbnbDB`, така че показателите могат да се разглеждат по месец, град, тип имот, статус и начин на плащане.

Основният доклад е в **Power BI Desktop**. В папка `../dashboard/` има и HTML вариант със същите графики.

## Файлове

- `Airbnb_Analytics.pbix` — Power BI отчет с модел, мерки и визуализации;
- `measures.dax` — DAX мерките;
- `model_relationships.csv` — 20-те връзки между таблиците;
- `queries/` — Power Query заявките (SQL Server `localhost`, база `AirbnbDB`, схема `dw`);
- `report_layout.md` — описание на страницата и визуализациите;
- `../data/` — CSV експорт на 11-те DW таблици.

## Как да отворите доклада

1. Инсталирайте **Power BI Desktop** (Windows).
2. Изпълнете SQL скриптовете от главния README, включително `warehouse/01` и `warehouse/02`.
3. Отворете `Airbnb_Analytics.pbix` чрез **File → Open**.
4. Отворете **Transform data → Data source settings → Change Source** и задайте сървъра (`localhost` или `.\SQLEXPRESS`) и база `AirbnbDB`.
5. В Power Query редактора натиснете **Close & Apply**, после **Home → Refresh**.
6. Използвайте филтрите **Държава**, **Град**, **Тип имот** и **Година**.

### Проверка след обновяване

При данните от `database/02-insert-data.sql` отчетът трябва да показва:

| Показател | Стойност |
|---|---|
| Total Bookings | 60 |
| Collected Revenue | 25 357,50 |
| Average Rating | 3,85 (33 отзива) |
| Total Listings | 20 |
| Статуси | Completed 46 · Cancelled 7 · Confirmed 6 · Pending 1 |

Ако нямате SQL Server, таблиците могат да се импортират от `../data/` чрез **Get data → Text/CSV**.

## Съдържание

Четири показателя:

| Показател | Какво представя |
|---|---|
| **Total Bookings** | Брой резервации |
| **Collected Revenue** | Сума на плащанията със статус `Completed` |
| **Average Rating** | Средна оценка от отзивите |
| **Total Listings** | Брой имоти в `DimProperty` |

Шест визуализации:

| Графика | Тип | Основни полета |
|---|---|---|
| Динамика на резервациите | Линейна | `DimDate[YearMonth]`, `Total Bookings` |
| Получени плащания по град | Хоризонтална стълбовидна | `DimLocation[CityName]`, `Collected Revenue` |
| Статус на резервациите | Donut | `DimBookingStatus[BookingStatusName]`, `Total Bookings` |
| Средна оценка по град | Вертикална стълбовидна | `DimLocation[CityName]`, `Average Rating` |
| Имоти по тип | Donut | `DimProperty[PropertyType]`, `Listings by Location` |
| Приходи по начин на плащане | Хоризонтална стълбовидна | `DimPaymentMethod[PaymentMethodName]`, `Collected Revenue` |

Приходите се смятат само от завършените плащания, затова се различават от общата стойност на резервациите.

## Модел на данните

Моделът има 11 таблици: 3 факти (`FactBookings`, `FactPayments`, `FactReviews`) и 8 измерения (`DimDate`, `DimGuest`, `DimHost`, `DimProperty`, `DimLocation`, `DimPaymentMethod`, `DimBookingStatus`, `DimPaymentStatus`). Всички 20 връзки са `1:*` от измерението към факта.

`DimDate` е свързана с трите факти. При резервациите активната връзка е през `BookingDateKey`, а връзките през `CheckInDateKey` и `CheckOutDateKey` са неактивни и могат да се ползват с `USERELATIONSHIP`.

Допълнителни мерки в отчета:

```dax
Listings by Location = DISTINCTCOUNT(FactBookings[PropertyKey])
YearMonth = FORMAT(DimDate[FullDate], "yyyy-MM")
```

## Изграждане на отчета наново

1. **Get data → SQL Server** (`localhost`, `AirbnbDB`) и изберете 11-те таблици от схема `dw`, или ги импортирайте от `../data/`.
2. Проверете типовете: ключовете са цели числа, `FullDate` е дата, сумите са десетични.
3. В **Model view** създайте връзките от `model_relationships.csv`.
4. Добавете мерките от `measures.dax` чрез **Modeling → New measure**.
5. Постройте визуализациите от таблицата горе и добавете четири Slicer филтъра.
6. Запазете като `Airbnb_Analytics.pbix`.
