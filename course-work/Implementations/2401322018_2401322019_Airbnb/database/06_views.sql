USE AirbnbCoursework;
GO
CREATE OR ALTER VIEW dbo.vw_PropertyOverview
AS
SELECT p.PropertyID, p.Title, u.FirstName + N' ' + u.LastName AS HostName,
       c.Name AS City, co.Name AS Country, pt.TypeName,
       p.PricePerNight, p.MaxGuests, p.Bedrooms, p.Bathrooms,
       COUNT(DISTINCT b.BookingID) AS BookingCount,
       COUNT(DISTINCT r.ReviewID) AS ReviewCount,
       CAST(AVG(CAST(r.Rating AS DECIMAL(8,2))) AS DECIMAL(4,2)) AS AverageRating
FROM dbo.Properties p
INNER JOIN dbo.Users u ON u.UserID = p.HostID
INNER JOIN dbo.Cities c ON c.CityID = p.CityID
INNER JOIN dbo.Countries co ON co.CountryID = c.CountryID
INNER JOIN dbo.PropertyTypes pt ON pt.PropertyTypeID = p.PropertyTypeID
LEFT JOIN dbo.Bookings b ON b.PropertyID = p.PropertyID
LEFT JOIN dbo.Reviews r ON r.BookingID = b.BookingID
GROUP BY p.PropertyID, p.Title, u.FirstName, u.LastName, c.Name, co.Name,
         pt.TypeName, p.PricePerNight, p.MaxGuests, p.Bedrooms, p.Bathrooms;
GO
CREATE OR ALTER VIEW dbo.vw_MonthlyRevenue
AS
SELECT YEAR(p.PaidAt) AS RevenueYear, MONTH(p.PaidAt) AS RevenueMonth,
       COUNT(*) AS PaymentCount, SUM(p.Amount) AS Revenue
FROM dbo.Payments p
WHERE p.Status = N'Completed' AND p.PaidAt IS NOT NULL
GROUP BY YEAR(p.PaidAt), MONTH(p.PaidAt);
GO
