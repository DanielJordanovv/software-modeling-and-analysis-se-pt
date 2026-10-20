IF DB_ID(N'AirbnbDB') IS NULL
    CREATE DATABASE AirbnbDB;
GO

USE AirbnbDB;
GO

DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS PropertyImages;
DROP TABLE IF EXISTS PropertyAmenities;
DROP TABLE IF EXISTS Amenities;
DROP TABLE IF EXISTS Properties;
DROP TABLE IF EXISTS PropertyTypes;
DROP TABLE IF EXISTS Cities;
DROP TABLE IF EXISTS Users;
GO

CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20) NULL,
    RegistrationDate DATE NOT NULL DEFAULT GETDATE(),
    IsHost BIT NOT NULL DEFAULT 0
);

CREATE TABLE Cities (
    CityId INT IDENTITY(1,1) PRIMARY KEY,
    CityName NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    CONSTRAINT UQ_Cities_CityName_Country UNIQUE (CityName, Country)
);

CREATE TABLE PropertyTypes (
    PropertyTypeId INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Properties (
    PropertyId INT IDENTITY(1,1) PRIMARY KEY,
    HostId INT NOT NULL,
    CityId INT NOT NULL,
    PropertyTypeId INT NOT NULL,
    Title NVARCHAR(150) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    PricePerNight DECIMAL(10,2) NOT NULL CHECK (PricePerNight > 0),
    MaxGuests INT NOT NULL CHECK (MaxGuests > 0),
    Bedrooms INT NOT NULL CHECK (Bedrooms >= 0),
    CreatedDate DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Properties_Users FOREIGN KEY (HostId) REFERENCES Users(UserId),
    CONSTRAINT FK_Properties_Cities FOREIGN KEY (CityId) REFERENCES Cities(CityId),
    CONSTRAINT FK_Properties_PropertyTypes FOREIGN KEY (PropertyTypeId) REFERENCES PropertyTypes(PropertyTypeId)
);

CREATE TABLE Amenities (
    AmenityId INT IDENTITY(1,1) PRIMARY KEY,
    AmenityName NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE PropertyAmenities (
    PropertyId INT NOT NULL,
    AmenityId INT NOT NULL,
    CONSTRAINT PK_PropertyAmenities PRIMARY KEY (PropertyId, AmenityId),
    CONSTRAINT FK_PropertyAmenities_Properties FOREIGN KEY (PropertyId) REFERENCES Properties(PropertyId) ON DELETE CASCADE,
    CONSTRAINT FK_PropertyAmenities_Amenities FOREIGN KEY (AmenityId) REFERENCES Amenities(AmenityId) ON DELETE CASCADE
);

CREATE TABLE PropertyImages (
    ImageId INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT NOT NULL,
    ImageUrl NVARCHAR(300) NOT NULL,
    IsMain BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_PropertyImages_Properties FOREIGN KEY (PropertyId) REFERENCES Properties(PropertyId) ON DELETE CASCADE
);

CREATE TABLE Bookings (
    BookingId INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT NOT NULL,
    GuestId INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    GuestsCount INT NOT NULL CHECK (GuestsCount > 0),
    TotalPrice DECIMAL(10,2) NOT NULL CHECK (TotalPrice >= 0),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Bookings_Properties FOREIGN KEY (PropertyId) REFERENCES Properties(PropertyId),
    CONSTRAINT FK_Bookings_Users FOREIGN KEY (GuestId) REFERENCES Users(UserId),
    CONSTRAINT CK_Bookings_Dates CHECK (CheckOutDate > CheckInDate)
);

CREATE TABLE Payments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    BookingId INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    Method NVARCHAR(20) NOT NULL CHECK (Method IN ('Card', 'PayPal', 'BankTransfer')),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Completed' CHECK (Status IN ('Pending', 'Completed', 'Refunded')),
    CONSTRAINT FK_Payments_Bookings FOREIGN KEY (BookingId) REFERENCES Bookings(BookingId)
);

CREATE TABLE Reviews (
    ReviewId INT IDENTITY(1,1) PRIMARY KEY,
    BookingId INT NOT NULL UNIQUE,
    Rating TINYINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(1000) NULL,
    ReviewDate DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Reviews_Bookings FOREIGN KEY (BookingId) REFERENCES Bookings(BookingId)
);
GO
