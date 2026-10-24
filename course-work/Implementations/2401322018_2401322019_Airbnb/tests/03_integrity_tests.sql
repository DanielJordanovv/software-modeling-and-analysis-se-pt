USE AirbnbCoursework;
GO
SET NOCOUNT ON;
GO
DECLARE @CaughtBooking BIT = 0;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.Bookings (PropertyID, GuestID, CheckInDate, CheckOutDate, GuestCount, TotalAmount, Status)
    VALUES (1, 20, '2026-11-04', '2026-11-06', 2, 196.00, N'Pending');
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() = 50102 SET @CaughtBooking = 1;
    ELSE THROW;
END CATCH;
IF @CaughtBooking = 0 THROW 50301, N'Booking overlap was not rejected.', 1;
GO
DECLARE @CaughtPayment BIT = 0;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.Payments (BookingID, Amount, PaymentMethod, Status, PaidAt, TransactionRef)
    VALUES (48, 480, N'Card', N'Completed', SYSUTCDATETIME(), N'INTEGRITY-TEST-01');
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() = 50111 SET @CaughtPayment = 1;
    ELSE THROW;
END CATCH;
IF @CaughtPayment = 0 THROW 50302, N'Payment trigger did not reject cancelled booking.', 1;
GO
DECLARE @CaughtReview BIT = 0;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.Reviews (BookingID, Rating, Comment)
    VALUES (45, 5, N'Invalid test review');
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() = 50121 SET @CaughtReview = 1;
    ELSE THROW;
END CATCH;
IF @CaughtReview = 0 THROW 50303, N'Review trigger did not reject pending booking.', 1;
SELECT N'Integrity tests passed' AS Result;
GO
