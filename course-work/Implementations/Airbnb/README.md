# Airbnb

## Екип

| Име | Факултетен номер |
| --- | --- |
| Даниел Йорданов | 2401322019 |
| Християн Христов | 2401322018 |

## Описание

Курсов проект по „Софтуерно моделиране и анализ“, който моделира платформата Airbnb. Потребителите могат да бъдат домакини, които предлагат имоти, и гости, които правят резервации. Към всеки имот има град, тип, удобства и снимки. Към резервациите има плащания и по едно ревю.

Проектът съдържа:

- концептуален модел (нотация на Chen);
- логически модел (нотация Crow's Foot) с 10 таблици, включително връзка много към много между имоти и удобства;
- база данни в MS SQL Server с тестови данни за период от 14 месеца;
- 2 съхранени процедури, 2 функции и 2 тригера.

## Структура

```
models/
    conceptual-model.drawio
    conceptual-model.png
    logical-model.drawio
    logical-model.png
database/
    01-create-tables.sql
    02-insert-data.sql
    03-programmability.sql
```

## Програмируеми обекти

| Обект | Тип | Какво прави |
| --- | --- | --- |
| `fn_CalculateStayPrice` | функция | Връща цената за престой: брой нощувки × цена на нощувка. |
| `fn_GetAverageRating` | функция | Връща средната оценка на имот от ревютата му. |
| `sp_CreateBooking` | процедура | Създава резервация със статус `Pending`, след като провери датите, броя гости и дали няма припокриване с друга резервация. |
| `sp_CancelBooking` | процедура | Отказва резервация и маркира плащанията по нея като `Refunded`. |
| `tr_Payments_ConfirmBooking` | тригер | Потвърждава резервацията, когато сумата на плащанията покрие цялата цена. |
| `tr_Reviews_OnlyCompletedBookings` | тригер | Не позволява ревю за резервация, която не е приключила. |

## Инсталация и стартиране

Изисквания: MS SQL Server 2019 или по-нов и SQL Server Management Studio (или Azure Data Studio / `sqlcmd`).

1. Клонирайте репото и отворете папката `course-work/Implementations/Airbnb/database`.
2. Изпълнете скриптовете по ред:
   1. `01-create-tables.sql` – създава базата `AirbnbDB` и таблиците.
   2. `02-insert-data.sql` – пълни таблиците с данни.
   3. `03-programmability.sql` – създава функциите, процедурите и тригерите.

С `sqlcmd`:

```bash
sqlcmd -S localhost -U sa -P <парола> -C -i 01-create-tables.sql
sqlcmd -S localhost -U sa -P <парола> -C -i 02-insert-data.sql
sqlcmd -S localhost -U sa -P <парола> -C -i 03-programmability.sql
```

Скрипт `01` изтрива и създава таблиците наново, затова цялата база може да се пресъздаде, като трите скрипта се пуснат отново в същия ред.

## Примери

```sql
USE AirbnbDB;

SELECT dbo.fn_CalculateStayPrice(1, '2027-01-10', '2027-01-15');
SELECT dbo.fn_GetAverageRating(6);

DECLARE @BookingId INT;
EXEC dbo.sp_CreateBooking 1, 7, '2027-01-10', '2027-01-15', 2, @BookingId OUTPUT;
INSERT INTO Payments (BookingId, Amount, Method) VALUES (@BookingId, 475, 'Card');
SELECT Status FROM Bookings WHERE BookingId = @BookingId;
EXEC dbo.sp_CancelBooking @BookingId;
```
