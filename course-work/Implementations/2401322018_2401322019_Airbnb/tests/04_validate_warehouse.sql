USE AirbnbCoursework;
GO
SET NOCOUNT ON;

IF OBJECT_ID(N'dw.FactBookings', N'U') IS NULL
    THROW 51000, N'Data Warehouse is not created.', 1;
IF OBJECT_ID(N'dw.FactPayments', N'U') IS NULL
    THROW 51001, N'FactPayments is missing.', 1;
IF OBJECT_ID(N'dw.FactReviews', N'U') IS NULL
    THROW 51002, N'FactReviews is missing.', 1;

IF (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dw') AND name LIKE N'Dim%') <> 8
    THROW 51003, N'Expected exactly eight dimension tables.', 1;
IF (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dw') AND name LIKE N'Fact%') <> 3
    THROW 51004, N'Expected exactly three fact tables.', 1;

IF (SELECT COUNT_BIG(*) FROM dbo.Bookings) <> (SELECT COUNT_BIG(*) FROM dw.FactBookings)
    THROW 51005, N'Booking fact count does not match source.', 1;
IF (SELECT COUNT_BIG(*) FROM dbo.Payments) <> (SELECT COUNT_BIG(*) FROM dw.FactPayments)
    THROW 51006, N'Payment fact count does not match source.', 1;
IF (SELECT COUNT_BIG(*) FROM dbo.Reviews) <> (SELECT COUNT_BIG(*) FROM dw.FactReviews)
    THROW 51007, N'Review fact count does not match source.', 1;

IF EXISTS (
    SELECT BookingID, PropertyID, GuestID, TotalAmount, DATEDIFF(DAY, CheckInDate, CheckOutDate)
    FROM dbo.Bookings
    EXCEPT
    SELECT BookingID, PropertyKey, GuestKey, BookingAmount, NightCount
    FROM dw.FactBookings
)
    THROW 51008, N'Booking fact values do not match source.', 1;

IF EXISTS (
    SELECT PaymentID, Amount FROM dbo.Payments
    EXCEPT
    SELECT PaymentID, PaymentAmount FROM dw.FactPayments
)
    THROW 51009, N'Payment fact values do not match source.', 1;

IF EXISTS (
    SELECT ReviewID, Rating FROM dbo.Reviews
    EXCEPT
    SELECT ReviewID, Rating FROM dw.FactReviews
)
    THROW 51010, N'Review fact values do not match source.', 1;

SELECT N'DimDate' AS TableName, COUNT_BIG(*) AS [RowCount] FROM dw.DimDate
UNION ALL SELECT N'DimGuest', COUNT_BIG(*) FROM dw.DimGuest
UNION ALL SELECT N'DimHost', COUNT_BIG(*) FROM dw.DimHost
UNION ALL SELECT N'DimProperty', COUNT_BIG(*) FROM dw.DimProperty
UNION ALL SELECT N'DimLocation', COUNT_BIG(*) FROM dw.DimLocation
UNION ALL SELECT N'DimPaymentMethod', COUNT_BIG(*) FROM dw.DimPaymentMethod
UNION ALL SELECT N'DimBookingStatus', COUNT_BIG(*) FROM dw.DimBookingStatus
UNION ALL SELECT N'DimPaymentStatus', COUNT_BIG(*) FROM dw.DimPaymentStatus
UNION ALL SELECT N'FactBookings', COUNT_BIG(*) FROM dw.FactBookings
UNION ALL SELECT N'FactPayments', COUNT_BIG(*) FROM dw.FactPayments
UNION ALL SELECT N'FactReviews', COUNT_BIG(*) FROM dw.FactReviews;
GO
