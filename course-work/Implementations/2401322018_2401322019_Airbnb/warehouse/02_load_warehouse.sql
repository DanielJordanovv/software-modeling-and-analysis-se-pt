USE AirbnbCoursework;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY
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
        UNION ALL SELECT CAST(CreatedAt AS DATE) FROM dbo.Payments
        UNION ALL SELECT CAST(PaidAt AS DATE) FROM dbo.Payments WHERE PaidAt IS NOT NULL
        UNION ALL SELECT CAST(CreatedAt AS DATE) FROM dbo.Reviews
    ) AS SourceDates;
    SET @FirstDate = COALESCE(@FirstDate, CAST(SYSUTCDATETIME() AS DATE));
    SET @LastDate = COALESCE(@LastDate, @FirstDate);
    ;WITH Dates AS (
        SELECT @FirstDate AS FullDate
        UNION ALL
        SELECT DATEADD(DAY, 1, FullDate) FROM Dates WHERE FullDate < @LastDate
    )
    INSERT INTO dw.DimDate (DateKey, FullDate, DayNumber, MonthNumber, MonthName, QuarterNumber, YearNumber)
    SELECT CONVERT(INT, CONVERT(CHAR(8), FullDate, 112)), FullDate,
           DAY(FullDate), MONTH(FullDate), DATENAME(MONTH, FullDate), DATEPART(QUARTER, FullDate), YEAR(FullDate)
    FROM Dates OPTION (MAXRECURSION 0);
    INSERT INTO dw.DimGuest (GuestKey, GuestName, Email, IsVerified)
    SELECT UserID, FirstName + N' ' + LastName, Email, IsVerified FROM dbo.Users;
    INSERT INTO dw.DimHost (HostKey, HostName, IsVerified)
    SELECT UserID, FirstName + N' ' + LastName, IsVerified FROM dbo.Users;
    INSERT INTO dw.DimProperty (PropertyKey, PropertyName, PropertyType, PricePerNight, MaxGuests)
    SELECT p.PropertyID, p.Title, t.TypeName, p.PricePerNight, p.MaxGuests
    FROM dbo.Properties p INNER JOIN dbo.PropertyTypes t ON t.PropertyTypeID = p.PropertyTypeID;
    INSERT INTO dw.DimLocation (LocationKey, CityName, CountryName, CountryISO)
    SELECT c.CityID, c.Name, co.Name, co.ISOCode
    FROM dbo.Cities c INNER JOIN dbo.Countries co ON co.CountryID = c.CountryID;
    INSERT INTO dw.DimPaymentMethod (PaymentMethodKey, PaymentMethodName)
    VALUES (1, N'Card'), (2, N'Bank Transfer'), (3, N'PayPal'), (4, N'Apple Pay');
    INSERT INTO dw.DimBookingStatus (BookingStatusKey, BookingStatusName)
    VALUES (1, N'Pending'), (2, N'Confirmed'), (3, N'Completed'), (4, N'Cancelled');
    INSERT INTO dw.DimPaymentStatus (PaymentStatusKey, PaymentStatusName)
    VALUES (1, N'Pending'), (2, N'Completed'), (3, N'Failed'), (4, N'Refunded');
    INSERT INTO dw.FactBookings
    (BookingID, BookingDateKey, CheckInDateKey, CheckOutDateKey, PropertyKey, GuestKey, HostKey, LocationKey,
     BookingStatusKey, NightCount, GuestCount, BookingAmount, BookingCount)
    SELECT b.BookingID, CONVERT(INT, CONVERT(CHAR(8), CAST(b.CreatedAt AS DATE), 112)),
           CONVERT(INT, CONVERT(CHAR(8), b.CheckInDate, 112)), CONVERT(INT, CONVERT(CHAR(8), b.CheckOutDate, 112)),
           b.PropertyID, b.GuestID, p.HostID, p.CityID, s.BookingStatusKey,
           DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate), b.GuestCount, b.TotalAmount, 1
    FROM dbo.Bookings b
    INNER JOIN dbo.Properties p ON p.PropertyID = b.PropertyID
    INNER JOIN dw.DimBookingStatus s ON s.BookingStatusName = b.Status;
    INSERT INTO dw.FactPayments
    (PaymentID, PaymentDateKey, PropertyKey, GuestKey, HostKey, LocationKey, PaymentMethodKey, PaymentStatusKey, PaymentAmount, PaymentCount)
    SELECT pay.PaymentID, CONVERT(INT, CONVERT(CHAR(8), CAST(COALESCE(pay.PaidAt, pay.CreatedAt) AS DATE), 112)),
           b.PropertyID, b.GuestID, p.HostID, p.CityID, pm.PaymentMethodKey, ps.PaymentStatusKey, pay.Amount, 1
    FROM dbo.Payments pay
    INNER JOIN dbo.Bookings b ON b.BookingID = pay.BookingID
    INNER JOIN dbo.Properties p ON p.PropertyID = b.PropertyID
    INNER JOIN dw.DimPaymentMethod pm ON pm.PaymentMethodName = pay.PaymentMethod
    INNER JOIN dw.DimPaymentStatus ps ON ps.PaymentStatusName = pay.Status;
    INSERT INTO dw.FactReviews
    (ReviewID, ReviewDateKey, PropertyKey, GuestKey, HostKey, LocationKey, Rating, ReviewCount)
    SELECT r.ReviewID, CONVERT(INT, CONVERT(CHAR(8), CAST(r.CreatedAt AS DATE), 112)),
           b.PropertyID, b.GuestID, p.HostID, p.CityID, r.Rating, 1
    FROM dbo.Reviews r
    INNER JOIN dbo.Bookings b ON b.BookingID = r.BookingID
    INNER JOIN dbo.Properties p ON p.PropertyID = b.PropertyID;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
