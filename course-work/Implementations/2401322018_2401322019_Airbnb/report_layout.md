# Airbnb Analytics — подредба на Power BI доклада

Този файл описва актуалната страница **Airbnb Analytics** в `Airbnb_Analytics.pbix`. Докладът работи с импортирани таблици на Data Warehouse от папка `data/`.

## Основни показатели

| KPI | Използвана DAX мярка | Смисъл |
|---|---|---|
| Резервации | `[Total Bookings]` | Брой резервации |
| Получени приходи | `[Collected Revenue]` | Плащания със статус `Completed` |
| Средна оценка | `[Average Rating]` | Средна оценка от отзивите |
| Имоти | `[Listings by Location]` | Уникални имоти с резервации при избраните филтри |

`[Total Listings]` е допълнителна мярка за всички имоти в `DimProperty` и не е мярката на четвъртата KPI карта в актуалния `.pbix`.

## Визуализации

| № | Графика | Визуален елемент | Категория/ос | Мярка |
|---|---|---|---|---|
| 1 | Динамика на резервациите | Line chart | `DimDate[YearMonth]` | `[Total Bookings]` |
| 2 | Получени приходи по град | Clustered bar | `DimLocation[CityName]` | `[Collected Revenue]` |
| 3 | Статус на резервациите | Donut | `DimBookingStatus[BookingStatusName]` | `[Total Bookings]` |
| 4 | Средна оценка по град | Clustered column | `DimLocation[CityName]` | `[Average Rating]` |
| 5 | Имотен портфейл по тип | Donut | `DimProperty[PropertyType]` | `[Listings by Location]` |
| 6 | Приходи по метод на плащане | Clustered bar | `DimPaymentMethod[PaymentMethodName]` | `[Collected Revenue]` |

Към диаграмата за типовете имоти е добавена `[Total Listings]` като допълнителна информация в tooltip, докато основната стойност за секторите е `[Listings by Location]`.

## Филтри и бутони

Използвани са четири Slicer филтъра: `DimLocation[CountryName]`, `DimLocation[CityName]`, `DimProperty[PropertyType]` и `DimDate[YearNumber]`. Бутонът за изчистване извиква bookmark `Reset Filters` (в режим на редактиране — `Ctrl + Click`).

## Връзки и време

Моделът е описан в `model_relationships.csv`: 20 връзки `1:*`, еднопосочни, от които 18 активни и 2 неактивни. За резервациите активната връзка с `DimDate` използва `BookingDateKey`; `CheckInDateKey` и `CheckOutDateKey` са неактивни. По подразбиране месечната диаграма групира резервациите по дата на създаване, а не по дата на настаняване.

Колоната `DimDate[YearMonth]` е изчислена с `FORMAT(DimDate[FullDate], "yyyy-MM")`.

## Данни и смисъл на сумите

`[Booking Value]` е стойността на създадените резервации, независимо от статуса, докато `[Collected Revenue]` включва само завършените плащания. Тези величини не са взаимозаменяеми. Валутата в основната схема не е дефинирана; използват се условни парични единици.

CSV файловете са създадени от SQL Data Warehouse. Готовият `.pbix` ползва локални CSV източници; `powerbi/queries/*.m` са отделни алтернативни заявки към SQL Server и при директно използване изискват промяна на инстанцията (в примерите е `localhost`).
