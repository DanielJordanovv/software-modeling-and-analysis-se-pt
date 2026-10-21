USE AirbnbCoursework;
GO
CREATE OR ALTER TRIGGER dbo.trg_Bookings_Validate
ON dbo.Bookings
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN dbo.Properties p ON p.PropertyID = i.PropertyID
        WHERE i.GuestID = p.HostID OR i.GuestCount > p.MaxGuests
    ) THROW 50101, N'Invalid guest or capacity for the selected property.', 1;
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN dbo.Bookings b WITH (UPDLOCK, HOLDLOCK) ON b.PropertyID = i.PropertyID AND b.BookingID <> i.BookingID
        WHERE i.Status IN (N'Pending', N'Confirmed', N'Completed')
          AND b.Status IN (N'Pending', N'Confirmed', N'Completed')
          AND i.CheckInDate < b.CheckOutDate AND i.CheckOutDate > b.CheckInDate
    ) THROW 50102, N'Overlapping bookings are not allowed.', 1;
END;
GO
CREATE OR ALTER TRIGGER dbo.trg_Payments_Validate
ON dbo.Payments
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN dbo.Bookings b ON b.BookingID = i.BookingID
        WHERE i.Status = N'Completed' AND b.Status = N'Cancelled'
    ) THROW 50111, N'Cancelled bookings cannot receive completed payments.', 1;
    IF EXISTS (
        SELECT 1
        FROM dbo.Payments p
        INNER JOIN dbo.Bookings b ON b.BookingID = p.BookingID
        GROUP BY p.BookingID, b.TotalAmount
        HAVING SUM(CASE WHEN p.Status = N'Completed' THEN p.Amount ELSE CONVERT(DECIMAL(12,2),0) END) > b.TotalAmount
    ) THROW 50112, N'Completed payments exceed the booking total.', 1;
END;
GO
CREATE OR ALTER TRIGGER dbo.trg_Reviews_Eligibility
ON dbo.Reviews
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN dbo.Bookings b ON b.BookingID = i.BookingID
        WHERE b.Status <> N'Completed' OR b.CheckOutDate > CAST(SYSUTCDATETIME() AS DATE)
    ) THROW 50121, N'Only completed stays can be reviewed.', 1;
END;
GO
