USE AirbnbDB;
GO

CREATE OR ALTER FUNCTION dbo.fn_CalculateStayPrice
(
    @PropertyId INT,
    @CheckInDate DATE,
    @CheckOutDate DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @PricePerNight DECIMAL(10,2);

    SELECT @PricePerNight = PricePerNight
    FROM Properties
    WHERE PropertyId = @PropertyId;

    RETURN DATEDIFF(DAY, @CheckInDate, @CheckOutDate) * @PricePerNight;
END;
GO

CREATE OR ALTER FUNCTION dbo.fn_GetAverageRating
(
    @PropertyId INT
)
RETURNS DECIMAL(3,2)
AS
BEGIN
    DECLARE @AverageRating DECIMAL(3,2);

    SELECT @AverageRating = AVG(CAST(r.Rating AS DECIMAL(3,2)))
    FROM Reviews r
    JOIN Bookings b ON b.BookingId = r.BookingId
    WHERE b.PropertyId = @PropertyId;

    RETURN @AverageRating;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CreateBooking
    @PropertyId INT,
    @GuestId INT,
    @CheckInDate DATE,
    @CheckOutDate DATE,
    @GuestsCount INT,
    @BookingId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @CheckOutDate <= @CheckInDate
        THROW 50001, 'Check-out date must be after check-in date.', 1;

    IF NOT EXISTS (SELECT 1 FROM Properties WHERE PropertyId = @PropertyId)
        THROW 50002, 'Property does not exist.', 1;

    IF NOT EXISTS (SELECT 1 FROM Users WHERE UserId = @GuestId)
        THROW 50003, 'Guest does not exist.', 1;

    IF EXISTS (SELECT 1 FROM Properties WHERE PropertyId = @PropertyId AND HostId = @GuestId)
        THROW 50004, 'The host cannot book their own property.', 1;

    IF EXISTS (SELECT 1 FROM Properties WHERE PropertyId = @PropertyId AND MaxGuests < @GuestsCount)
        THROW 50005, 'Too many guests for this property.', 1;

    IF EXISTS (
        SELECT 1
        FROM Bookings
        WHERE PropertyId = @PropertyId
          AND Status <> 'Cancelled'
          AND CheckInDate < @CheckOutDate
          AND CheckOutDate > @CheckInDate
    )
        THROW 50006, 'The property is already booked for these dates.', 1;

    INSERT INTO Bookings (PropertyId, GuestId, CheckInDate, CheckOutDate, GuestsCount, TotalPrice, Status)
    VALUES (@PropertyId, @GuestId, @CheckInDate, @CheckOutDate, @GuestsCount,
            dbo.fn_CalculateStayPrice(@PropertyId, @CheckInDate, @CheckOutDate), 'Pending');

    SET @BookingId = SCOPE_IDENTITY();
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CancelBooking
    @BookingId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Bookings WHERE BookingId = @BookingId)
        THROW 50011, 'Booking does not exist.', 1;

    IF EXISTS (SELECT 1 FROM Bookings WHERE BookingId = @BookingId AND Status IN ('Cancelled', 'Completed'))
        THROW 50012, 'Only pending or confirmed bookings can be cancelled.', 1;

    BEGIN TRANSACTION;

    UPDATE Bookings
    SET Status = 'Cancelled'
    WHERE BookingId = @BookingId;

    UPDATE Payments
    SET Status = 'Refunded'
    WHERE BookingId = @BookingId AND Status = 'Completed';

    COMMIT TRANSACTION;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Payments_ConfirmBooking
ON Payments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE b
    SET b.Status = 'Confirmed'
    FROM Bookings b
    WHERE b.BookingId IN (SELECT BookingId FROM inserted)
      AND b.Status = 'Pending'
      AND b.TotalPrice <= (
          SELECT SUM(p.Amount)
          FROM Payments p
          WHERE p.BookingId = b.BookingId AND p.Status = 'Completed'
      );
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Reviews_OnlyCompletedBookings
ON Reviews
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Bookings b ON b.BookingId = i.BookingId
        WHERE b.Status <> 'Completed'
           OR b.CheckOutDate > CAST(GETDATE() AS DATE)
    )
        THROW 50021, 'A review can be added only for a completed booking.', 1;
END;
GO
