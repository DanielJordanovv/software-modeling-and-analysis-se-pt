IF DB_ID(N'AirbnbCoursework') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE AirbnbCoursework');
END;
GO
USE AirbnbCoursework;
GO
SET NOCOUNT ON;
GO
CREATE TABLE dbo.Countries (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ISOCode CHAR(2) NOT NULL UNIQUE
);
GO
CREATE TABLE dbo.Cities (
    CityID INT IDENTITY(1,1) PRIMARY KEY,
    CountryID INT NOT NULL,
    Name NVARCHAR(120) NOT NULL,
    PostalCode NVARCHAR(15) NULL,
    CONSTRAINT FK_Cities_Countries FOREIGN KEY (CountryID) REFERENCES dbo.Countries(CountryID),
    CONSTRAINT UQ_Cities_NameCountry UNIQUE (CountryID, Name)
);
GO
CREATE TABLE dbo.Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(80) NOT NULL,
    LastName NVARCHAR(80) NOT NULL,
    Email NVARCHAR(254) NOT NULL UNIQUE,
    Phone NVARCHAR(30) NULL,
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME(),
    IsVerified BIT NOT NULL CONSTRAINT DF_Users_IsVerified DEFAULT (0)
);
GO
CREATE TABLE dbo.PropertyTypes (
    PropertyTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(80) NOT NULL UNIQUE,
    Description NVARCHAR(300) NULL
);
GO
CREATE TABLE dbo.Properties (
    PropertyID INT IDENTITY(1,1) PRIMARY KEY,
    HostID INT NOT NULL,
    CityID INT NOT NULL,
    PropertyTypeID INT NOT NULL,
    Title NVARCHAR(160) NOT NULL,
    Description NVARCHAR(600) NULL,
    AddressLine NVARCHAR(220) NOT NULL,
    PricePerNight DECIMAL(10,2) NOT NULL,
    MaxGuests TINYINT NOT NULL,
    Bedrooms TINYINT NOT NULL,
    Bathrooms TINYINT NOT NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_Properties_IsActive DEFAULT (1),
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Properties_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Properties_Host FOREIGN KEY (HostID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Properties_Cities FOREIGN KEY (CityID) REFERENCES dbo.Cities(CityID),
    CONSTRAINT FK_Properties_Types FOREIGN KEY (PropertyTypeID) REFERENCES dbo.PropertyTypes(PropertyTypeID),
    CONSTRAINT CK_Properties_Price CHECK (PricePerNight > 0),
    CONSTRAINT CK_Properties_Capacity CHECK (MaxGuests BETWEEN 1 AND 20 AND Bedrooms BETWEEN 0 AND 20 AND Bathrooms BETWEEN 1 AND 15)
);
GO
CREATE TABLE dbo.Amenities (
    AmenityID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(80) NOT NULL UNIQUE,
    Category NVARCHAR(60) NOT NULL
);
GO
CREATE TABLE dbo.PropertyAmenities (
    PropertyID INT NOT NULL,
    AmenityID INT NOT NULL,
    CONSTRAINT PK_PropertyAmenities PRIMARY KEY (PropertyID, AmenityID),
    CONSTRAINT FK_PropertyAmenities_Property FOREIGN KEY (PropertyID) REFERENCES dbo.Properties(PropertyID),
    CONSTRAINT FK_PropertyAmenities_Amenity FOREIGN KEY (AmenityID) REFERENCES dbo.Amenities(AmenityID)
);
GO
CREATE TABLE dbo.Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    PropertyID INT NOT NULL,
    GuestID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    GuestCount TINYINT NOT NULL,
    TotalAmount DECIMAL(12,2) NOT NULL,
    Status NVARCHAR(20) NOT NULL CONSTRAINT DF_Bookings_Status DEFAULT (N'Pending'),
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Bookings_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Bookings_Property FOREIGN KEY (PropertyID) REFERENCES dbo.Properties(PropertyID),
    CONSTRAINT FK_Bookings_Guest FOREIGN KEY (GuestID) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_Bookings_Dates CHECK (CheckOutDate > CheckInDate),
    CONSTRAINT CK_Bookings_Guests CHECK (GuestCount > 0),
    CONSTRAINT CK_Bookings_Total CHECK (TotalAmount >= 0),
    CONSTRAINT CK_Bookings_Status CHECK (Status IN (N'Pending', N'Confirmed', N'Completed', N'Cancelled'))
);
GO
CREATE TABLE dbo.Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    PaymentMethod NVARCHAR(30) NOT NULL,
    Status NVARCHAR(20) NOT NULL CONSTRAINT DF_Payments_Status DEFAULT (N'Pending'),
    PaidAt DATETIME2(0) NULL,
    TransactionRef NVARCHAR(80) NULL UNIQUE,
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Payments_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Payments_Booking FOREIGN KEY (BookingID) REFERENCES dbo.Bookings(BookingID),
    CONSTRAINT CK_Payments_Amount CHECK (Amount > 0),
    CONSTRAINT CK_Payments_Method CHECK (PaymentMethod IN (N'Card', N'Bank Transfer', N'PayPal', N'Apple Pay')),
    CONSTRAINT CK_Payments_Status CHECK (Status IN (N'Pending', N'Completed', N'Failed', N'Refunded')),
    CONSTRAINT CK_Payments_PaidAt CHECK (Status <> N'Completed' OR PaidAt IS NOT NULL)
);
GO
CREATE TABLE dbo.Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL UNIQUE,
    Rating TINYINT NOT NULL,
    Comment NVARCHAR(800) NULL,
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Reviews_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Reviews_Booking FOREIGN KEY (BookingID) REFERENCES dbo.Bookings(BookingID),
    CONSTRAINT CK_Reviews_Rating CHECK (Rating BETWEEN 1 AND 5)
);
GO
CREATE INDEX IX_Properties_CityType ON dbo.Properties(CityID, PropertyTypeID) INCLUDE (PricePerNight, MaxGuests, IsActive);
CREATE INDEX IX_Bookings_Availability ON dbo.Bookings(PropertyID, CheckInDate, CheckOutDate, Status);
CREATE INDEX IX_Bookings_Guest ON dbo.Bookings(GuestID, CreatedAt);
CREATE INDEX IX_Payments_BookingStatus ON dbo.Payments(BookingID, Status) INCLUDE (Amount);
CREATE INDEX IX_PropertyAmenities_Amenity ON dbo.PropertyAmenities(AmenityID, PropertyID);
GO
