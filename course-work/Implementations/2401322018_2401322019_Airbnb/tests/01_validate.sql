USE AirbnbCoursework;
GO
SET NOCOUNT ON;
IF (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dbo')
    AND name IN (N'Countries', N'Cities', N'Users', N'PropertyTypes', N'Properties',
                 N'Amenities', N'PropertyAmenities', N'Bookings', N'Payments', N'Reviews')) <> 10
    THROW 50210, N'Operational model has missing tables.', 1;
IF (SELECT COUNT(*) FROM sys.columns c
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    WHERE t.schema_id = SCHEMA_ID(N'dbo') AND t.name IN
    (N'Countries', N'Cities', N'Users', N'PropertyTypes', N'Properties',
     N'Amenities', N'PropertyAmenities', N'Bookings', N'Payments', N'Reviews')) < 30
    THROW 50212, N'The operational model requires at least 30 attributes.', 1;
IF (SELECT COUNT(*) FROM sys.procedures WHERE schema_id = SCHEMA_ID(N'dbo') AND name LIKE N'sp[_]%') < 2
    THROW 50213, N'At least two stored procedures are required.', 1;
IF (SELECT COUNT(*) FROM sys.objects WHERE schema_id = SCHEMA_ID(N'dbo') AND type = N'FN' AND name LIKE N'fn[_]%') < 2
    THROW 50214, N'At least two scalar functions are required.', 1;
IF (SELECT COUNT(*) FROM sys.triggers WHERE name LIKE N'trg[_]%') < 2
    THROW 50215, N'At least two triggers are required.', 1;
IF (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dw') AND name LIKE N'Dim%') < 6
    THROW 50216, N'At least six warehouse dimensions are required.', 1;
IF (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dw') AND name LIKE N'Fact%') < 3
    THROW 50217, N'At least three warehouse fact tables are required.', 1;
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints
               WHERE parent_object_id = OBJECT_ID(N'dbo.PropertyAmenities') AND type = N'PK')
    THROW 50218, N'Many-to-many junction key is missing.', 1;
IF (SELECT COUNT(*) FROM dbo.Properties) < 8 THROW 50201, N'Insufficient properties.', 1;
IF (SELECT COUNT(*) FROM dbo.Bookings) = 0 THROW 50202, N'No bookings found.', 1;
IF EXISTS (
    SELECT 1 FROM dbo.Bookings b
    INNER JOIN dbo.Properties p ON p.PropertyID = b.PropertyID
    WHERE b.GuestCount > p.MaxGuests OR b.GuestID = p.HostID
) THROW 50203, N'Invalid booking capacity or owner.', 1;
IF EXISTS (
    SELECT 1 FROM dbo.Bookings a INNER JOIN dbo.Bookings b
      ON a.PropertyID = b.PropertyID AND a.BookingID < b.BookingID
      AND a.CheckInDate < b.CheckOutDate AND b.CheckInDate < a.CheckOutDate
    WHERE a.Status IN (N'Pending', N'Confirmed', N'Completed')
      AND b.Status IN (N'Pending', N'Confirmed', N'Completed')
) THROW 50204, N'Overlapping active reservations.', 1;
IF EXISTS (
    SELECT 1 FROM dbo.Reviews r INNER JOIN dbo.Bookings b ON b.BookingID = r.BookingID
    WHERE b.Status <> N'Completed'
) THROW 50205, N'Invalid review.', 1;
IF (SELECT COUNT(*) FROM dw.FactBookings) <> (SELECT COUNT(*) FROM dbo.Bookings)
    THROW 50206, N'Booking warehouse reconciliation failed.', 1;
IF (SELECT COUNT(*) FROM dw.FactPayments) <> (SELECT COUNT(*) FROM dbo.Payments)
    THROW 50207, N'Payment warehouse reconciliation failed.', 1;
IF (SELECT COUNT(*) FROM dw.FactReviews) <> (SELECT COUNT(*) FROM dbo.Reviews)
    THROW 50208, N'Review warehouse reconciliation failed.', 1;
IF (SELECT COALESCE(SUM(BookingAmount),0) FROM dw.FactBookings) <> (SELECT COALESCE(SUM(TotalAmount),0) FROM dbo.Bookings)
    THROW 50209, N'Booking amount warehouse reconciliation failed.', 1;
SELECT N'Countries' AS Item, COUNT(*) AS [RowCount] FROM dbo.Countries
UNION ALL SELECT N'Cities', COUNT(*) FROM dbo.Cities
UNION ALL SELECT N'Users', COUNT(*) FROM dbo.Users
UNION ALL SELECT N'Properties', COUNT(*) FROM dbo.Properties
UNION ALL SELECT N'Amenities', COUNT(*) FROM dbo.Amenities
UNION ALL SELECT N'PropertyAmenities', COUNT(*) FROM dbo.PropertyAmenities
UNION ALL SELECT N'Bookings', COUNT(*) FROM dbo.Bookings
UNION ALL SELECT N'Payments', COUNT(*) FROM dbo.Payments
UNION ALL SELECT N'Reviews', COUNT(*) FROM dbo.Reviews
UNION ALL SELECT N'FactBookings', COUNT(*) FROM dw.FactBookings
UNION ALL SELECT N'FactPayments', COUNT(*) FROM dw.FactPayments
UNION ALL SELECT N'FactReviews', COUNT(*) FROM dw.FactReviews;
SELECT dbo.fn_GetBookingNights(1) AS ExampleNights,
       dbo.fn_GetPropertyAverageRating(1) AS ExampleRating,
       dbo.fn_GetPropertyRevenue(1) AS ExampleRevenue;
GO
