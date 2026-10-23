USE AirbnbDB;
GO

SET NOCOUNT ON;

BEGIN TRANSACTION;

DECLARE @BookingId INT, @OtherId INT, @CompletedId INT;

PRINT 'fn_CalculateStayPrice(1, 2027-01-10, 2027-01-15) = ' + CAST(dbo.fn_CalculateStayPrice(1, '2027-01-10', '2027-01-15') AS VARCHAR(20));
PRINT 'fn_GetAverageRating(6) = ' + ISNULL(CAST(dbo.fn_GetAverageRating(6) AS VARCHAR(20)), 'NULL');

EXEC dbo.sp_CreateBooking 1, 7, '2027-01-10', '2027-01-15', 2, @BookingId OUTPUT;
SELECT 'New booking' AS TestCase, BookingId, Status, TotalPrice FROM Bookings WHERE BookingId = @BookingId;

BEGIN TRY
    EXEC dbo.sp_CreateBooking 1, 8, '2027-01-12', '2027-01-14', 2, @OtherId OUTPUT;
    PRINT 'FAIL: overlapping booking was created';
END TRY
BEGIN CATCH
    PRINT 'OK overlap rejected: ' + ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC dbo.sp_CreateBooking 1, 1, '2027-02-01', '2027-02-03', 2, @OtherId OUTPUT;
    PRINT 'FAIL: host booked own property';
END TRY
BEGIN CATCH
    PRINT 'OK host rejected: ' + ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC dbo.sp_CreateBooking 2, 8, '2020-01-01', '2020-01-03', 1, @OtherId OUTPUT;
    PRINT 'FAIL: booking in the past was created';
END TRY
BEGIN CATCH
    PRINT 'OK past date rejected: ' + ERROR_MESSAGE();
END CATCH;

INSERT INTO Payments (BookingId, Amount, Method) VALUES (@BookingId, 100, 'Card');
SELECT 'After partial payment' AS TestCase, Status FROM Bookings WHERE BookingId = @BookingId;

INSERT INTO Payments (BookingId, Amount, Method) VALUES (@BookingId, 375, 'Card');
SELECT 'After full payment' AS TestCase, Status FROM Bookings WHERE BookingId = @BookingId;

EXEC dbo.sp_CancelBooking @BookingId;
SELECT 'After cancel' AS TestCase, b.Status AS BookingStatus, p.Status AS PaymentStatus, COUNT(*) AS Payments
FROM Bookings b
JOIN Payments p ON p.BookingId = b.BookingId
WHERE b.BookingId = @BookingId
GROUP BY b.Status, p.Status;

BEGIN TRY
    EXEC dbo.sp_CancelBooking @BookingId;
    PRINT 'FAIL: booking was cancelled twice';
END TRY
BEGIN CATCH
    PRINT 'OK second cancel rejected: ' + ERROR_MESSAGE();
END CATCH;

SELECT TOP 1 @CompletedId = b.BookingId
FROM Bookings b
WHERE b.Status = 'Completed'
  AND NOT EXISTS (SELECT 1 FROM Reviews r WHERE r.BookingId = b.BookingId);

INSERT INTO Reviews (BookingId, Rating, Comment) VALUES (@CompletedId, 4, 'Test review');
PRINT 'OK review for a completed booking accepted';

BEGIN TRY
    INSERT INTO Reviews (BookingId, Rating) VALUES (@BookingId, 5);
    PRINT 'FAIL: review for a future booking was accepted';
END TRY
BEGIN CATCH
    PRINT 'OK review rejected: ' + ERROR_MESSAGE();
END CATCH;

IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;
PRINT 'All test changes were rolled back.';
GO
