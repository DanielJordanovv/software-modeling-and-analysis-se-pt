USE AirbnbCoursework;
GO
CREATE OR ALTER FUNCTION dbo.fn_GetBookingNights (@BookingID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;
    SELECT @Result = DATEDIFF(DAY, CheckInDate, CheckOutDate)
    FROM dbo.Bookings
    WHERE BookingID = @BookingID;
    RETURN @Result;
END;
GO
CREATE OR ALTER FUNCTION dbo.fn_GetPropertyAverageRating (@PropertyID INT)
RETURNS DECIMAL(4,2)
AS
BEGIN
    DECLARE @Rating DECIMAL(4,2);
    SELECT @Rating = CAST(AVG(CAST(r.Rating AS DECIMAL(8,2))) AS DECIMAL(4,2))
    FROM dbo.Reviews r
    INNER JOIN dbo.Bookings b ON b.BookingID = r.BookingID
    WHERE b.PropertyID = @PropertyID;
    RETURN @Rating;
END;
GO
CREATE OR ALTER FUNCTION dbo.fn_GetPropertyRevenue (@PropertyID INT)
RETURNS DECIMAL(14,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(14,2);
    SELECT @Revenue = COALESCE(SUM(p.Amount), 0)
    FROM dbo.Payments p
    INNER JOIN dbo.Bookings b ON b.BookingID = p.BookingID
    WHERE b.PropertyID = @PropertyID AND p.Status = N'Completed';
    RETURN @Revenue;
END;
GO
