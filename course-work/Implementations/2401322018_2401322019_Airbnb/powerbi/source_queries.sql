USE AirbnbCoursework;
GO
SELECT b.BookingID,
       CAST(b.CreatedAt AS DATE) AS BookingDate,
       b.CheckInDate,
       b.CheckOutDate,
       b.GuestCount,
       b.TotalAmount,
       b.Status AS BookingStatus,
       p.PropertyID,
       p.Title AS PropertyName,
       pt.TypeName AS PropertyType,
       c.Name AS CityName,
       co.Name AS CountryName
FROM dbo.Bookings b
INNER JOIN dbo.Properties p ON p.PropertyID = b.PropertyID
INNER JOIN dbo.PropertyTypes pt ON pt.PropertyTypeID = p.PropertyTypeID
INNER JOIN dbo.Cities c ON c.CityID = p.CityID
INNER JOIN dbo.Countries co ON co.CountryID = c.CountryID;
GO
SELECT py.PaymentID,
       CAST(COALESCE(py.PaidAt, py.CreatedAt) AS DATE) AS PaymentDate,
       py.Amount AS PaymentAmount,
       py.PaymentMethod,
       py.Status AS PaymentStatus,
       p.PropertyID,
       p.Title AS PropertyName,
       pt.TypeName AS PropertyType,
       c.Name AS CityName,
       co.Name AS CountryName
FROM dbo.Payments py
INNER JOIN dbo.Bookings b ON b.BookingID = py.BookingID
INNER JOIN dbo.Properties p ON p.PropertyID = b.PropertyID
INNER JOIN dbo.PropertyTypes pt ON pt.PropertyTypeID = p.PropertyTypeID
INNER JOIN dbo.Cities c ON c.CityID = p.CityID
INNER JOIN dbo.Countries co ON co.CountryID = c.CountryID;
GO
SELECT r.ReviewID,
       CAST(r.CreatedAt AS DATE) AS ReviewDate,
       r.Rating,
       p.PropertyID,
       p.Title AS PropertyName,
       pt.TypeName AS PropertyType,
       c.Name AS CityName,
       co.Name AS CountryName
FROM dbo.Reviews r
INNER JOIN dbo.Bookings b ON b.BookingID = r.BookingID
INNER JOIN dbo.Properties p ON p.PropertyID = b.PropertyID
INNER JOIN dbo.PropertyTypes pt ON pt.PropertyTypeID = p.PropertyTypeID
INNER JOIN dbo.Cities c ON c.CityID = p.CityID
INNER JOIN dbo.Countries co ON co.CountryID = c.CountryID;
GO