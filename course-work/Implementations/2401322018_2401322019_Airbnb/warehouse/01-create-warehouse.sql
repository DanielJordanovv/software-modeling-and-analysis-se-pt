USE AirbnbDB;
GO

IF SCHEMA_ID(N'dw') IS NULL
    EXEC(N'CREATE SCHEMA dw');
GO

DROP TABLE IF EXISTS dw.FactReviews;
DROP TABLE IF EXISTS dw.FactPayments;
DROP TABLE IF EXISTS dw.FactBookings;
DROP TABLE IF EXISTS dw.DimPaymentStatus;
DROP TABLE IF EXISTS dw.DimBookingStatus;
DROP TABLE IF EXISTS dw.DimPaymentMethod;
DROP TABLE IF EXISTS dw.DimLocation;
DROP TABLE IF EXISTS dw.DimProperty;
DROP TABLE IF EXISTS dw.DimHost;
DROP TABLE IF EXISTS dw.DimGuest;
DROP TABLE IF EXISTS dw.DimDate;
GO

CREATE TABLE dw.DimDate (
    DateKey INT NOT NULL PRIMARY KEY,
    FullDate DATE NOT NULL UNIQUE,
    DayNumber TINYINT NOT NULL,
    MonthNumber TINYINT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    QuarterNumber TINYINT NOT NULL,
    YearNumber SMALLINT NOT NULL
);

CREATE TABLE dw.DimGuest (
    GuestKey INT NOT NULL PRIMARY KEY,
    GuestName NVARCHAR(101) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    RegistrationDate DATE NOT NULL
);

CREATE TABLE dw.DimHost (
    HostKey INT NOT NULL PRIMARY KEY,
    HostName NVARCHAR(101) NOT NULL,
    Email NVARCHAR(100) NOT NULL
);

CREATE TABLE dw.DimProperty (
    PropertyKey INT NOT NULL PRIMARY KEY,
    PropertyName NVARCHAR(150) NOT NULL,
    PropertyType NVARCHAR(50) NOT NULL,
    PricePerNight DECIMAL(10,2) NOT NULL,
    MaxGuests INT NOT NULL
);

CREATE TABLE dw.DimLocation (
    LocationKey INT NOT NULL PRIMARY KEY,
    CityName NVARCHAR(100) NOT NULL,
    CountryName NVARCHAR(100) NOT NULL
);

CREATE TABLE dw.DimPaymentMethod (
    PaymentMethodKey INT NOT NULL PRIMARY KEY,
    PaymentMethodName NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE dw.DimBookingStatus (
    BookingStatusKey INT NOT NULL PRIMARY KEY,
    BookingStatusName NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE dw.DimPaymentStatus (
    PaymentStatusKey INT NOT NULL PRIMARY KEY,
    PaymentStatusName NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE dw.FactBookings (
    BookingID INT NOT NULL PRIMARY KEY,
    BookingDateKey INT NOT NULL,
    CheckInDateKey INT NOT NULL,
    CheckOutDateKey INT NOT NULL,
    PropertyKey INT NOT NULL,
    GuestKey INT NOT NULL,
    HostKey INT NOT NULL,
    LocationKey INT NOT NULL,
    BookingStatusKey INT NOT NULL,
    NightCount INT NOT NULL,
    GuestCount INT NOT NULL,
    BookingAmount DECIMAL(10,2) NOT NULL,
    BookingCount INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_FB_BookingDate FOREIGN KEY (BookingDateKey) REFERENCES dw.DimDate(DateKey),
    CONSTRAINT FK_FB_CheckInDate FOREIGN KEY (CheckInDateKey) REFERENCES dw.DimDate(DateKey),
    CONSTRAINT FK_FB_CheckOutDate FOREIGN KEY (CheckOutDateKey) REFERENCES dw.DimDate(DateKey),
    CONSTRAINT FK_FB_Property FOREIGN KEY (PropertyKey) REFERENCES dw.DimProperty(PropertyKey),
    CONSTRAINT FK_FB_Guest FOREIGN KEY (GuestKey) REFERENCES dw.DimGuest(GuestKey),
    CONSTRAINT FK_FB_Host FOREIGN KEY (HostKey) REFERENCES dw.DimHost(HostKey),
    CONSTRAINT FK_FB_Location FOREIGN KEY (LocationKey) REFERENCES dw.DimLocation(LocationKey),
    CONSTRAINT FK_FB_Status FOREIGN KEY (BookingStatusKey) REFERENCES dw.DimBookingStatus(BookingStatusKey)
);

CREATE TABLE dw.FactPayments (
    PaymentID INT NOT NULL PRIMARY KEY,
    PaymentDateKey INT NOT NULL,
    PropertyKey INT NOT NULL,
    GuestKey INT NOT NULL,
    HostKey INT NOT NULL,
    LocationKey INT NOT NULL,
    PaymentMethodKey INT NOT NULL,
    PaymentStatusKey INT NOT NULL,
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentCount INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_FP_Date FOREIGN KEY (PaymentDateKey) REFERENCES dw.DimDate(DateKey),
    CONSTRAINT FK_FP_Property FOREIGN KEY (PropertyKey) REFERENCES dw.DimProperty(PropertyKey),
    CONSTRAINT FK_FP_Guest FOREIGN KEY (GuestKey) REFERENCES dw.DimGuest(GuestKey),
    CONSTRAINT FK_FP_Host FOREIGN KEY (HostKey) REFERENCES dw.DimHost(HostKey),
    CONSTRAINT FK_FP_Location FOREIGN KEY (LocationKey) REFERENCES dw.DimLocation(LocationKey),
    CONSTRAINT FK_FP_Method FOREIGN KEY (PaymentMethodKey) REFERENCES dw.DimPaymentMethod(PaymentMethodKey),
    CONSTRAINT FK_FP_Status FOREIGN KEY (PaymentStatusKey) REFERENCES dw.DimPaymentStatus(PaymentStatusKey)
);

CREATE TABLE dw.FactReviews (
    ReviewID INT NOT NULL PRIMARY KEY,
    ReviewDateKey INT NOT NULL,
    PropertyKey INT NOT NULL,
    GuestKey INT NOT NULL,
    HostKey INT NOT NULL,
    LocationKey INT NOT NULL,
    Rating TINYINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    ReviewCount INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_FR_Date FOREIGN KEY (ReviewDateKey) REFERENCES dw.DimDate(DateKey),
    CONSTRAINT FK_FR_Property FOREIGN KEY (PropertyKey) REFERENCES dw.DimProperty(PropertyKey),
    CONSTRAINT FK_FR_Guest FOREIGN KEY (GuestKey) REFERENCES dw.DimGuest(GuestKey),
    CONSTRAINT FK_FR_Host FOREIGN KEY (HostKey) REFERENCES dw.DimHost(HostKey),
    CONSTRAINT FK_FR_Location FOREIGN KEY (LocationKey) REFERENCES dw.DimLocation(LocationKey)
);
GO
