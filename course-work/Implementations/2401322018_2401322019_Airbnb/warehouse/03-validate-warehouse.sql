USE AirbnbDB;
GO

SET NOCOUNT ON;

IF (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dw') AND name LIKE N'Dim%') <> 8
    THROW 51001, N'Expected eight dimension tables.', 1;

IF (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dw') AND name LIKE N'Fact%') <> 3
    THROW 51002, N'Expected three fact tables.', 1;

IF (SELECT COUNT(*) FROM dbo.Bookings) <> (SELECT COUNT(*) FROM dw.FactBookings)
    THROW 51003, N'Booking fact count does not match the source.', 1;

IF (SELECT COUNT(*) FROM dbo.Payments) <> (SELECT COUNT(*) FROM dw.FactPayments)
    THROW 51004, N'Payment fact count does not match the source.', 1;

IF (SELECT COUNT(*) FROM dbo.Reviews) <> (SELECT COUNT(*) FROM dw.FactReviews)
    THROW 51005, N'Review fact count does not match the source.', 1;

IF EXISTS (
    SELECT BookingId, PropertyId, GuestId, TotalPrice, DATEDIFF(DAY, CheckInDate, CheckOutDate) FROM dbo.Bookings
    EXCEPT
    SELECT BookingID, PropertyKey, GuestKey, BookingAmount, NightCount FROM dw.FactBookings
)
    THROW 51006, N'Booking fact values do not match the source.', 1;

IF EXISTS (
    SELECT PaymentId, Amount FROM dbo.Payments
    EXCEPT
    SELECT PaymentID, PaymentAmount FROM dw.FactPayments
)
    THROW 51007, N'Payment fact values do not match the source.', 1;

IF EXISTS (
    SELECT ReviewId, Rating FROM dbo.Reviews
    EXCEPT
    SELECT ReviewID, Rating FROM dw.FactReviews
)
    THROW 51008, N'Review fact values do not match the source.', 1;

SELECT N'DimDate' AS TableName, COUNT(*) AS RowsCount FROM dw.DimDate
UNION ALL SELECT N'DimGuest', COUNT(*) FROM dw.DimGuest
UNION ALL SELECT N'DimHost', COUNT(*) FROM dw.DimHost
UNION ALL SELECT N'DimProperty', COUNT(*) FROM dw.DimProperty
UNION ALL SELECT N'DimLocation', COUNT(*) FROM dw.DimLocation
UNION ALL SELECT N'DimPaymentMethod', COUNT(*) FROM dw.DimPaymentMethod
UNION ALL SELECT N'DimBookingStatus', COUNT(*) FROM dw.DimBookingStatus
UNION ALL SELECT N'DimPaymentStatus', COUNT(*) FROM dw.DimPaymentStatus
UNION ALL SELECT N'FactBookings', COUNT(*) FROM dw.FactBookings
UNION ALL SELECT N'FactPayments', COUNT(*) FROM dw.FactPayments
UNION ALL SELECT N'FactReviews', COUNT(*) FROM dw.FactReviews;
GO
