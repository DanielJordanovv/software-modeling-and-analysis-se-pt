USE AirbnbDB;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION;

DELETE FROM dw.FactReviews;
DELETE FROM dw.FactPayments;
DELETE FROM dw.FactBookings;
DELETE FROM dw.DimPaymentStatus;
DELETE FROM dw.DimBookingStatus;
DELETE FROM dw.DimPaymentMethod;
DELETE FROM dw.DimLocation;
DELETE FROM dw.DimProperty;
DELETE FROM dw.DimHost;
DELETE FROM dw.DimGuest;
DELETE FROM dw.DimDate;

DECLARE @FirstDate DATE, @LastDate DATE;

SELECT @FirstDate = MIN(FullDate), @LastDate = MAX(FullDate)
FROM (
    SELECT CAST(CreatedAt AS DATE) AS FullDate FROM dbo.Bookings
    UNION ALL SELECT CheckInDate FROM dbo.Bookings
    UNION ALL SELECT CheckOutDate FROM dbo.Bookings
    UNION ALL SELECT CAST(PaymentDate AS DATE) FROM dbo.Payments
    UNION ALL SELECT ReviewDate FROM dbo.Reviews
) AS SourceDates;

WITH Dates AS (
    SELECT @FirstDate AS FullDate
    UNION ALL
    SELECT DATEADD(DAY, 1, FullDate) FROM Dates WHERE FullDate < @LastDate
)
INSERT INTO dw.DimDate (DateKey, FullDate, DayNumber, MonthNumber, MonthName, QuarterNumber, YearNumber)
SELECT CONVERT(INT, CONVERT(CHAR(8), FullDate, 112)), FullDate, DAY(FullDate), MONTH(FullDate),
       DATENAME(MONTH, FullDate), DATEPART(QUARTER, FullDate), YEAR(FullDate)
FROM Dates
OPTION (MAXRECURSION 0);

INSERT INTO dw.DimGuest (GuestKey, GuestName, Email, RegistrationDate)
SELECT UserId, FirstName + N' ' + LastName, Email, RegistrationDate
FROM dbo.Users;

INSERT INTO dw.DimHost (HostKey, HostName, Email)
SELECT UserId, FirstName + N' ' + LastName, Email
FROM dbo.Users
WHERE IsHost = 1;

INSERT INTO dw.DimProperty (PropertyKey, PropertyName, PropertyType, PricePerNight, MaxGuests)
SELECT p.PropertyId, p.Title, t.TypeName, p.PricePerNight, p.MaxGuests
FROM dbo.Properties p
JOIN dbo.PropertyTypes t ON t.PropertyTypeId = p.PropertyTypeId;

INSERT INTO dw.DimLocation (LocationKey, CityName, CountryName)
SELECT CityId, CityName, Country
FROM dbo.Cities;

INSERT INTO dw.DimPaymentMethod (PaymentMethodKey, PaymentMethodName)
VALUES (1, N'Card'), (2, N'PayPal'), (3, N'BankTransfer');

INSERT INTO dw.DimBookingStatus (BookingStatusKey, BookingStatusName)
VALUES (1, N'Pending'), (2, N'Confirmed'), (3, N'Completed'), (4, N'Cancelled');

INSERT INTO dw.DimPaymentStatus (PaymentStatusKey, PaymentStatusName)
VALUES (1, N'Pending'), (2, N'Completed'), (3, N'Refunded');

INSERT INTO dw.FactBookings
    (BookingID, BookingDateKey, CheckInDateKey, CheckOutDateKey, PropertyKey, GuestKey, HostKey, LocationKey,
     BookingStatusKey, NightCount, GuestCount, BookingAmount, BookingCount)
SELECT b.BookingId,
       CONVERT(INT, CONVERT(CHAR(8), CAST(b.CreatedAt AS DATE), 112)),
       CONVERT(INT, CONVERT(CHAR(8), b.CheckInDate, 112)),
       CONVERT(INT, CONVERT(CHAR(8), b.CheckOutDate, 112)),
       b.PropertyId, b.GuestId, p.HostId, p.CityId, s.BookingStatusKey,
       DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate), b.GuestsCount, b.TotalPrice, 1
FROM dbo.Bookings b
JOIN dbo.Properties p ON p.PropertyId = b.PropertyId
JOIN dw.DimBookingStatus s ON s.BookingStatusName = b.Status;

INSERT INTO dw.FactPayments
    (PaymentID, PaymentDateKey, PropertyKey, GuestKey, HostKey, LocationKey,
     PaymentMethodKey, PaymentStatusKey, PaymentAmount, PaymentCount)
SELECT pay.PaymentId,
       CONVERT(INT, CONVERT(CHAR(8), CAST(pay.PaymentDate AS DATE), 112)),
       b.PropertyId, b.GuestId, p.HostId, p.CityId, pm.PaymentMethodKey, ps.PaymentStatusKey, pay.Amount, 1
FROM dbo.Payments pay
JOIN dbo.Bookings b ON b.BookingId = pay.BookingId
JOIN dbo.Properties p ON p.PropertyId = b.PropertyId
JOIN dw.DimPaymentMethod pm ON pm.PaymentMethodName = pay.Method
JOIN dw.DimPaymentStatus ps ON ps.PaymentStatusName = pay.Status;

INSERT INTO dw.FactReviews
    (ReviewID, ReviewDateKey, PropertyKey, GuestKey, HostKey, LocationKey, Rating, ReviewCount)
SELECT r.ReviewId,
       CONVERT(INT, CONVERT(CHAR(8), r.ReviewDate, 112)),
       b.PropertyId, b.GuestId, p.HostId, p.CityId, r.Rating, 1
FROM dbo.Reviews r
JOIN dbo.Bookings b ON b.BookingId = r.BookingId
JOIN dbo.Properties p ON p.PropertyId = b.PropertyId;

COMMIT TRANSACTION;
GO
