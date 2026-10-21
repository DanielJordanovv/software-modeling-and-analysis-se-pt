USE AirbnbCoursework;
GO
CREATE OR ALTER PROCEDURE dbo.sp_CreateBooking
    @PropertyID INT,
    @GuestID INT,
    @CheckInDate DATE,
    @CheckOutDate DATE,
    @GuestCount TINYINT,
    @BookingID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @HostID INT, @MaxGuests TINYINT, @Price DECIMAL(10,2), @IsActive BIT;
        SELECT @HostID = HostID, @MaxGuests = MaxGuests, @Price = PricePerNight, @IsActive = IsActive
        FROM dbo.Properties WITH (UPDLOCK, HOLDLOCK)
        WHERE PropertyID = @PropertyID;
        IF @HostID IS NULL THROW 50001, N'Property not found.', 1;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @GuestID) THROW 50002, N'Guest not found.', 1;
        IF @IsActive = 0 THROW 50003, N'Property is inactive.', 1;
        IF @HostID = @GuestID THROW 50004, N'Hosts cannot book their own property.', 1;
        IF @CheckInDate IS NULL OR @CheckOutDate IS NULL OR @CheckOutDate <= @CheckInDate THROW 50005, N'Invalid stay dates.', 1;
        IF @GuestCount IS NULL OR @GuestCount < 1 OR @GuestCount > @MaxGuests THROW 50006, N'Guest count exceeds property capacity.', 1;
        IF EXISTS (
            SELECT 1 FROM dbo.Bookings WITH (UPDLOCK, HOLDLOCK, INDEX(IX_Bookings_Availability))
            WHERE PropertyID = @PropertyID
              AND Status IN (N'Pending', N'Confirmed', N'Completed')
              AND CheckInDate < @CheckOutDate AND CheckOutDate > @CheckInDate
        ) THROW 50007, N'The property is not available for these dates.', 1;
        INSERT INTO dbo.Bookings (PropertyID, GuestID, CheckInDate, CheckOutDate, GuestCount, TotalAmount, Status)
        VALUES (@PropertyID, @GuestID, @CheckInDate, @CheckOutDate, @GuestCount,
                CAST(DATEDIFF(DAY, @CheckInDate, @CheckOutDate) * @Price AS DECIMAL(12,2)), N'Pending');
        SET @BookingID = CONVERT(INT, SCOPE_IDENTITY());
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_RecordPayment
    @BookingID INT,
    @PaymentMethod NVARCHAR(30),
    @TransactionRef NVARCHAR(80),
    @PaymentID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @Amount DECIMAL(12,2), @Status NVARCHAR(20);
        SELECT @Amount = TotalAmount, @Status = Status FROM dbo.Bookings WITH (UPDLOCK, HOLDLOCK) WHERE BookingID = @BookingID;
        IF @Status IS NULL THROW 50011, N'Booking not found.', 1;
        IF @Status <> N'Pending' THROW 50012, N'Only pending bookings can be paid.', 1;
        IF @PaymentMethod NOT IN (N'Card', N'Bank Transfer', N'PayPal', N'Apple Pay') THROW 50013, N'Unsupported payment method.', 1;
        IF @TransactionRef IS NULL OR LEN(TRIM(@TransactionRef)) = 0 THROW 50014, N'Transaction reference is required.', 1;
        INSERT INTO dbo.Payments (BookingID, Amount, PaymentMethod, Status, PaidAt, TransactionRef)
        VALUES (@BookingID, @Amount, @PaymentMethod, N'Completed', SYSUTCDATETIME(), @TransactionRef);
        SET @PaymentID = CONVERT(INT, SCOPE_IDENTITY());
        UPDATE dbo.Bookings SET Status = N'Confirmed' WHERE BookingID = @BookingID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_CancelBooking
    @BookingID INT,
    @GuestID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @CurrentStatus NVARCHAR(20), @CheckInDate DATE;
        SELECT @CurrentStatus = Status, @CheckInDate = CheckInDate
        FROM dbo.Bookings WITH (UPDLOCK, HOLDLOCK)
        WHERE BookingID = @BookingID AND GuestID = @GuestID;
        IF @CurrentStatus IS NULL THROW 50021, N'Booking not found for this guest.', 1;
        IF @CurrentStatus NOT IN (N'Pending', N'Confirmed') THROW 50022, N'Booking cannot be cancelled.', 1;
        IF @CheckInDate <= CAST(SYSUTCDATETIME() AS DATE) THROW 50023, N'Stay has already started.', 1;
        IF EXISTS (SELECT 1 FROM dbo.Payments WHERE BookingID = @BookingID AND Status = N'Completed')
            THROW 50024, N'Paid bookings require a refund before cancellation.', 1;
        UPDATE dbo.Bookings SET Status = N'Cancelled' WHERE BookingID = @BookingID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_CompleteStay
    @BookingID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Bookings
    SET Status = N'Completed'
    WHERE BookingID = @BookingID AND Status = N'Confirmed'
      AND CheckOutDate <= CAST(SYSUTCDATETIME() AS DATE);
    IF @@ROWCOUNT = 0 THROW 50031, N'Only finished confirmed stays can be completed.', 1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_SearchAvailableProperties
    @CityID INT,
    @CheckInDate DATE,
    @CheckOutDate DATE,
    @GuestCount TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    IF @CheckInDate IS NULL OR @CheckOutDate IS NULL OR @CheckOutDate <= @CheckInDate
        THROW 50041, N'Invalid dates.', 1;
    SELECT p.PropertyID, p.Title, p.PricePerNight, p.MaxGuests, pt.TypeName, c.Name AS CityName
    FROM dbo.Properties p
    INNER JOIN dbo.PropertyTypes pt ON pt.PropertyTypeID = p.PropertyTypeID
    INNER JOIN dbo.Cities c ON c.CityID = p.CityID
    WHERE p.CityID = @CityID AND p.IsActive = 1 AND p.MaxGuests >= @GuestCount
      AND NOT EXISTS (
          SELECT 1 FROM dbo.Bookings b
          WHERE b.PropertyID = p.PropertyID AND b.Status IN (N'Pending', N'Confirmed', N'Completed')
            AND b.CheckInDate < @CheckOutDate AND b.CheckOutDate > @CheckInDate
      )
    ORDER BY p.PricePerNight, p.PropertyID;
END;
GO
