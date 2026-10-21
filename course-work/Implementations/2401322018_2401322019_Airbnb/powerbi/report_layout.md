# Airbnb Analytics — Power BI report specification

## Page 1 — Overview

| Visual | Power BI visual | Axis / Category | Value / Legend |
|---|---|---|---|
| 1. Нови резервации по месеци | Line chart | DimDate[YearNumber], DimDate[MonthNumber] | [Total Bookings] |
| 2. Плащания по град | Clustered bar chart | DimLocation[CityName] | [Collected Revenue] |
| 3. Статуси на резервациите | Donut chart | DimBookingStatus[BookingStatusName] | [Total Bookings] |
| 4. Средна оценка по град | Clustered column chart | DimLocation[CityName] | [Average Rating] |
| 5. Видове имоти | Donut chart | DimProperty[PropertyType] | [Total Listings] |
| 6. Приходи по начин на плащане | Clustered bar chart | DimPaymentMethod[PaymentMethodName] | [Collected Revenue] |

Cards: [Total Bookings], [Collected Revenue], [Average Rating], [Total Listings].

Slicers: DimLocation[CountryName], DimLocation[CityName], DimProperty[PropertyType], DimDate[YearNumber].

## Model

20 отношения са изброени в `model_relationships.csv`. Измеренията имат еднопосочни 1:* връзки с фактите. При `FactBookings` активна датова връзка е `BookingDateKey`. `CheckInDateKey` и `CheckOutDateKey` са неактивни; при нужда се активират за определена мярка с USERELATIONSHIP. Една и съща DimDate активна връзка към FactPayments/PaymentDateKey и FactReviews/ReviewDateKey филтрира всяка метрика по нейната дата.

## Financial definition

[Booking Value] означава заявена стойност на всички резервации (включва отменени, изчакващи и потвърдени). [Collected Revenue] означава сума само от завършени плащания. Различни измерители са и не трябва да се сумират.

## Field settings

DimDate[FullDate] → Date. DimDate[YearNumber], [MonthNumber], DateKey and all foreign keys → Whole number. Money fields → Decimal number, two decimal places. [Cancellation Rate] → Percentage. [Average Rating] → two decimal places. Сортирайте `DimDate[MonthName]` по `DimDate[MonthNumber]`. Ако се използват йерархии по дата, избягвайте показване само на месец без година.

## Expected sample totals

Фиксираните примерни данни съдържат 49 резервации, 47 плащания и 24 отзива. Показаните приходи зависят от статуса на всяко плащане.
