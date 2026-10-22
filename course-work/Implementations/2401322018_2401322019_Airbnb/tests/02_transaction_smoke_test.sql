USE AirbnbCoursework;
GO
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @BookingID INT, @PaymentID INT;
    EXEC dbo.sp_CreateBooking
        @PropertyID = 18,
        @GuestID = 20,
        @CheckInDate = '2027-02-04',
        @CheckOutDate = '2027-02-08',
        @GuestCount = 2,
        @BookingID = @BookingID OUTPUT;
    EXEC dbo.sp_RecordPayment
        @BookingID = @BookingID,
        @PaymentMethod = N'Card',
        @TransactionRef = N'TEST-TRANSACTION-ROLLBACK',
        @PaymentID = @PaymentID OUTPUT;
    IF NOT EXISTS (
        SELECT 1 FROM dbo.Bookings WHERE BookingID = @BookingID AND Status = N'Confirmed'
    ) THROW 50211, N'Booking workflow failed.', 1;
    IF NOT EXISTS (
        SELECT 1 FROM dbo.Payments WHERE PaymentID = @PaymentID AND Status = N'Completed'
    ) THROW 50212, N'Payment workflow failed.', 1;
    SELECT @BookingID AS TestBookingID, @PaymentID AS TestPaymentID, N'Passed' AS Result;
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
