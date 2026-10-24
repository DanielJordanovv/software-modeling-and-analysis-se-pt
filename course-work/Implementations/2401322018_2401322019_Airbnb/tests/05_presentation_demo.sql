/*
AirbnbCoursework - примерни SQL заявки за представяне
База данни: AirbnbCoursework | SQL Server 2022+

Файлът се изпълнява в SSMS след създаване и зареждане на проектната база.
Всяка номерирана част завършва с GO и може да се маркира и изпълни отделно с F5.
Части 08 и 09 използват транзакции, които се отменят с ROLLBACK.
Скриптът не създава или заменя обекти и не трябва да оставя промени в данните.
*/
USE AirbnbCoursework;
GO
SET NOCOUNT ON;
GO

-- 01. Обобщена информация за оперативната база
-- Показва броя на основните записи в примерните данни.
SELECT
    (SELECT COUNT(*) FROM dbo.Users) AS UsersCount,
    (SELECT COUNT(*) FROM dbo.Properties) AS PropertiesCount,
    (SELECT COUNT(*) FROM dbo.Bookings) AS BookingsCount,
    (SELECT COUNT(*) FROM dbo.Payments) AS PaymentsCount,
    (SELECT COUNT(*) FROM dbo.Reviews) AS ReviewsCount;
GO

-- 02. JOIN: резервации, имоти и местоположения
-- Една резервация е за един имот, но един имот може да има много резервации.
SELECT TOP (10)
    b.BookingID,
    p.Title AS PropertyTitle,
    c.Name AS City,
    co.Name AS Country,
    b.CheckInDate,
    b.CheckOutDate,
    b.TotalAmount,
    b.Status
FROM dbo.Bookings AS b
INNER JOIN dbo.Properties AS p ON p.PropertyID = b.PropertyID
INNER JOIN dbo.Cities AS c ON c.CityID = p.CityID
INNER JOIN dbo.Countries AS co ON co.CountryID = c.CountryID
ORDER BY b.BookingID;
GO

-- 03. Връзка много към много: имоти и удобства
-- Таблицата dbo.PropertyAmenities реализира връзката M:N.
SELECT TOP (15)
    p.PropertyID,
    p.Title AS PropertyTitle,
    a.Name AS Amenity,
    a.Category
FROM dbo.PropertyAmenities AS pa
INNER JOIN dbo.Properties AS p ON p.PropertyID = pa.PropertyID
INNER JOIN dbo.Amenities AS a ON a.AmenityID = pa.AmenityID
ORDER BY p.PropertyID, a.Name;
GO

-- 04. Обобщаване: получени приходи по градове
-- В приходите се включват само плащания със статус Completed.
SELECT
    c.Name AS City,
    COUNT(*) AS CompletedPayments,
    SUM(pay.Amount) AS CollectedRevenue
FROM dbo.Payments AS pay
INNER JOIN dbo.Bookings AS b ON b.BookingID = pay.BookingID
INNER JOIN dbo.Properties AS p ON p.PropertyID = b.PropertyID
INNER JOIN dbo.Cities AS c ON c.CityID = p.CityID
WHERE pay.Status = N'Completed'
GROUP BY c.Name
ORDER BY CollectedRevenue DESC, c.Name;
GO

-- 05. Скаларни SQL функции
-- Изчислява нощувките за резервация 1, както и оценката и приходите за имот 1.
SELECT
    dbo.fn_GetBookingNights(1) AS ExampleNights,
    dbo.fn_GetPropertyAverageRating(1) AS ExampleRating,
    dbo.fn_GetPropertyRevenue(1) AS ExamplePropertyRevenue;
GO

-- 06. Изгледи: обобщение на имотите и месечни приходи
SELECT TOP (10)
    PropertyID,
    Title,
    City,
    Country,
    BookingCount,
    ReviewCount,
    AverageRating
FROM dbo.vw_PropertyOverview
ORDER BY BookingCount DESC, PropertyID;

SELECT RevenueYear, RevenueMonth, PaymentCount, Revenue
FROM dbo.vw_MonthlyRevenue
ORDER BY RevenueYear, RevenueMonth;
GO

-- 07. Съхранена процедура: търсене на свободни имоти в София
-- Процедурата само извлича информация и не променя резервации или плащания.
EXEC dbo.sp_SearchAvailableProperties
    @CityID = 1,
    @CheckInDate = '2027-03-10',
    @CheckOutDate = '2027-03-13',
    @GuestCount = 2;
GO

-- 08. Съхранени процедури: създаване на резервация и регистриране на плащане
-- Накрая се изпълнява ROLLBACK, за да не се запазят тестовите записи.
BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @DemoBookingID INT;
    DECLARE @DemoPaymentID INT;

    EXEC dbo.sp_CreateBooking
        @PropertyID = 18,
        @GuestID = 20,
        @CheckInDate = '2027-02-04',
        @CheckOutDate = '2027-02-08',
        @GuestCount = 2,
        @BookingID = @DemoBookingID OUTPUT;

    EXEC dbo.sp_RecordPayment
        @BookingID = @DemoBookingID,
        @PaymentMethod = N'Card',
        @TransactionRef = N'PRESENTATION-ROLLBACK-ONLY',
        @PaymentID = @DemoPaymentID OUTPUT;

    SELECT
        b.BookingID,
        b.Status AS BookingStatus,
        b.TotalAmount,
        pay.PaymentID,
        pay.Status AS PaymentStatus,
        pay.Amount AS PaymentAmount
    FROM dbo.Bookings AS b
    INNER JOIN dbo.Payments AS pay ON pay.BookingID = b.BookingID
    WHERE b.BookingID = @DemoBookingID AND pay.PaymentID = @DemoPaymentID;

    ROLLBACK TRANSACTION;
    SELECT N'Demo booking and payment were rolled back.' AS DemoResult;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO

-- 09. Демонстрация на тригер: отказ на припокриваща се резервация
-- Очаква се грешка 50102, която се обработва в CATCH. Тестови записи не се запазват.
DECLARE @OverlapRejected BIT = 0;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.Bookings
        (PropertyID, GuestID, CheckInDate, CheckOutDate, GuestCount, TotalAmount, Status)
    VALUES
        (1, 20, '2026-11-04', '2026-11-06', 2, 196.00, N'Pending');
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() = 50102
        SET @OverlapRejected = 1;
    ELSE
        THROW;
END CATCH;
IF @OverlapRejected <> 1
    THROW 51090, N'The expected overlap restriction did not reject the booking.', 1;
SELECT N'Overlap rejected by trg_Bookings_Validate (50102).' AS TriggerDemo;
GO

-- 10. Data Warehouse: брой записи в измеренията и фактите
SELECT
    (SELECT COUNT(*) FROM dw.DimDate) AS DatesCount,
    (SELECT COUNT(*) FROM dw.DimProperty) AS PropertiesCount,
    (SELECT COUNT(*) FROM dw.DimLocation) AS LocationsCount,
    (SELECT COUNT(*) FROM dw.FactBookings) AS BookingFacts,
    (SELECT COUNT(*) FROM dw.FactPayments) AS PaymentFacts,
    (SELECT COUNT(*) FROM dw.FactReviews) AS ReviewFacts;
GO

-- 11. Data Warehouse: резервации по държава и град
SELECT
    dl.CountryName,
    dl.CityName,
    SUM(fb.BookingCount) AS TotalBookings,
    SUM(fb.BookingAmount) AS TotalBookingValue
FROM dw.FactBookings AS fb
INNER JOIN dw.DimLocation AS dl ON dl.LocationKey = fb.LocationKey
GROUP BY dl.CountryName, dl.CityName
ORDER BY TotalBookings DESC, dl.CityName;
GO

-- 12. Data Warehouse: получени приходи по начин на плащане
SELECT
    pm.PaymentMethodName,
    SUM(fp.PaymentAmount) AS CollectedRevenue
FROM dw.FactPayments AS fp
INNER JOIN dw.DimPaymentMethod AS pm ON pm.PaymentMethodKey = fp.PaymentMethodKey
INNER JOIN dw.DimPaymentStatus AS ps ON ps.PaymentStatusKey = fp.PaymentStatusKey
WHERE ps.PaymentStatusName = N'Completed'
GROUP BY pm.PaymentMethodName
ORDER BY CollectedRevenue DESC;
GO

-- 13. Финална проверка: броят на основните записи трябва да е непроменен
SELECT
    (SELECT COUNT(*) FROM dbo.Bookings) AS BookingsAfterDemo,
    (SELECT COUNT(*) FROM dbo.Payments) AS PaymentsAfterDemo,
    (SELECT COUNT(*) FROM dbo.Reviews) AS ReviewsAfterDemo;
GO
