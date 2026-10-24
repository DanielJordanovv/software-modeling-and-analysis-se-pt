USE AirbnbCoursework;
GO
SET NOCOUNT ON;
GO

SET IDENTITY_INSERT dbo.Countries ON;

INSERT INTO dbo.Countries (CountryID, Name, ISOCode) VALUES
(1, N'Bulgaria', N'BG'),
(2, N'Greece', N'GR');

SET IDENTITY_INSERT dbo.Countries OFF;
GO

SET IDENTITY_INSERT dbo.Cities ON;

INSERT INTO dbo.Cities (CityID, CountryID, Name, PostalCode) VALUES
(1, 1, N'Sofia', N'1000'),
(2, 1, N'Plovdiv', N'4000'),
(3, 1, N'Varna', N'9000'),
(4, 1, N'Burgas', N'8000'),
(5, 2, N'Thessaloniki', N'54621'),
(6, 2, N'Kavala', N'65403');

SET IDENTITY_INSERT dbo.Cities OFF;
GO

SET IDENTITY_INSERT dbo.Users ON;

INSERT INTO dbo.Users (UserID, FirstName, LastName, Email, Phone, CreatedAt, IsVerified) VALUES
(1, N'Alexander', N'Petrov', N'alex.petrov@example.com', N'+359888100001', N'2025-01-12T10:10:00', 1),
(2, N'Maria', N'Ivanova', N'maria.ivanova@example.com', N'+359888100002', N'2025-01-15T12:00:00', 1),
(3, N'Georgi', N'Dimitrov', N'georgi.dimitrov@example.com', N'+359888100003', N'2025-02-03T09:30:00', 1),
(4, N'Elena', N'Georgieva', N'elena.georgieva@example.com', N'+359888100004', N'2025-02-20T09:30:00', 1),
(5, N'Nikolay', N'Stoyanov', N'nikolay.stoyanov@example.com', N'+359888100005', N'2025-03-10T09:30:00', 1),
(6, N'Victoria', N'Nikolova', N'victoria.nikolova@example.com', N'+359888100006', N'2025-03-15T09:30:00', 1),
(7, N'Daniel', N'Hristov', N'daniel.hristov@example.com', N'+359888100007', N'2025-03-28T09:30:00', 1),
(8, N'Teodora', N'Koleva', N'teodora.koleva@example.com', N'+359888100008', N'2025-04-02T09:30:00', 1),
(9, N'Ivan', N'Kostov', N'ivan.kostov@example.com', N'+359888100009', N'2025-04-11T09:30:00', 1),
(10, N'Sofia', N'Angelova', N'sofia.angelova@example.com', N'+359888100010', N'2025-04-19T09:30:00', 1),
(11, N'Mila', N'Popova', N'mila.popova@example.com', N'+359888100011', N'2025-05-10T09:30:00', 1),
(12, N'Martin', N'Pavlov', N'martin.pavlov@example.com', N'+359888100012', N'2025-06-01T09:30:00', 1),
(13, N'Nadia', N'Todorova', N'nadia.todorova@example.com', N'+359888100013', N'2025-06-03T09:30:00', 1),
(14, N'Petar', N'Vasilev', N'petar.vasilev@example.com', N'+359888100014', N'2025-06-08T09:30:00', 1),
(15, N'Raya', N'Ivanova', N'raya.ivanova@example.com', N'+359888100015', N'2025-06-12T09:30:00', 1),
(16, N'Kris', N'Mihaylov', N'kris.mihaylov@example.com', N'+359888100016', N'2025-06-21T09:30:00', 1),
(17, N'Yana', N'Filipova', N'yana.filipova@example.com', N'+359888100017', N'2025-07-01T09:30:00', 1),
(18, N'Bozhidar', N'Valkov', N'bozhidar.valkov@example.com', N'+359888100018', N'2025-07-05T09:30:00', 1),
(19, N'Tanya', N'Marinova', N'tanya.marinova@example.com', N'+359888100019', N'2025-07-08T09:30:00', 1),
(20, N'Kristina', N'Ruseva', N'kristina.ruseva@example.com', N'+359888100020', N'2025-07-10T09:30:00', 1);

SET IDENTITY_INSERT dbo.Users OFF;
GO

SET IDENTITY_INSERT dbo.PropertyTypes ON;

INSERT INTO dbo.PropertyTypes (PropertyTypeID, TypeName, Description) VALUES
(1, N'Apartment', N'Entire apartment'),
(2, N'House', N'Entire house'),
(3, N'Studio', N'Open-plan accommodation'),
(4, N'Villa', N'Private villa'),
(5, N'Loft', N'Loft accommodation');

SET IDENTITY_INSERT dbo.PropertyTypes OFF;
GO

SET IDENTITY_INSERT dbo.Properties ON;

INSERT INTO dbo.Properties (PropertyID, HostID, CityID, PropertyTypeID, Title, Description, AddressLine, PricePerNight, MaxGuests, Bedrooms, Bathrooms, IsActive, CreatedAt) VALUES
(1, 1, 1, 1, N'Central Sofia Apartment', N'Bright city apartment near public transport', N'8 Vitosha Blvd', 98, 4, 2, 1, 1, N'2025-07-01T08:00:00'),
(2, 2, 1, 3, N'Sofia City Studio', N'Compact studio in a quiet neighborhood', N'12 Shishman St', 68, 2, 0, 1, 1, N'2025-07-01T08:00:00'),
(3, 3, 2, 2, N'Old Town Family House', N'Family home in historical Plovdiv', N'4 Saborna St', 145, 6, 3, 2, 1, N'2025-07-01T08:00:00'),
(4, 4, 3, 1, N'Sea Garden Flat', N'Sunny apartment close to the beach', N'19 Primorski Blvd', 115, 4, 2, 1, 1, N'2025-07-01T08:00:00'),
(5, 5, 4, 4, N'Burgas Garden Villa', N'Modern villa with private outdoor space', N'5 Lazur St', 210, 8, 4, 3, 1, N'2025-07-01T08:00:00'),
(6, 6, 5, 1, N'Thessaloniki Riverside', N'Central apartment for weekend travel', N'23 Tsimiski St', 125, 4, 2, 1, 1, N'2025-07-01T08:00:00'),
(7, 7, 6, 3, N'Kavala Port Studio', N'Harbor-facing studio for two', N'9 Omonias St', 84, 2, 0, 1, 1, N'2025-07-01T08:00:00'),
(8, 8, 1, 5, N'Sofia Designer Loft', N'Open loft with dedicated workspace', N'14 Rakovski St', 133, 3, 1, 1, 1, N'2025-07-01T08:00:00'),
(9, 1, 3, 2, N'Varna Coastal House', N'Coastal guest house with yard', N'27 Chaika St', 172, 6, 3, 2, 1, N'2025-07-01T08:00:00'),
(10, 2, 2, 1, N'Kapana Art Apartment', N'Apartment in the creative district', N'3 Bratya Pulievi St', 105, 3, 1, 1, 1, N'2025-07-01T08:00:00'),
(11, 3, 4, 3, N'Burgas Compact Studio', N'Affordable studio in city center', N'7 Bogoridi St', 61, 2, 0, 1, 1, N'2025-07-01T08:00:00'),
(12, 4, 5, 4, N'Northern Greece Villa', N'Comfortable villa for group stays', N'18 Egnatia St', 240, 8, 4, 3, 1, N'2025-07-01T08:00:00'),
(13, 5, 6, 1, N'Kavala Family Apartment', N'Spacious apartment near the center', N'6 Venizelou St', 112, 5, 2, 2, 1, N'2025-07-01T08:00:00'),
(14, 6, 1, 1, N'Sofia University Retreat', N'Quiet modern flat with fast Wi-Fi', N'25 Shipka St', 92, 3, 1, 1, 1, N'2025-07-01T08:00:00'),
(15, 7, 2, 5, N'Plovdiv Vintage Loft', N'Exposed brick loft near the center', N'10 Otets Paisiy St', 117, 4, 2, 1, 1, N'2025-07-01T08:00:00'),
(16, 8, 3, 1, N'Varna Panorama', N'Apartment with balcony and sea views', N'31 Knyaz Boris St', 156, 4, 2, 2, 1, N'2025-07-01T08:00:00'),
(17, 1, 4, 2, N'Burgas Family Residence', N'Comfortable home close to parks', N'6 Demokratsia Blvd', 138, 5, 2, 2, 1, N'2025-07-01T08:00:00'),
(18, 2, 5, 3, N'Thessaloniki Old Town Studio', N'Simple studio in the old town', N'11 Kassandrou St', 77, 2, 0, 1, 1, N'2025-07-01T08:00:00');

SET IDENTITY_INSERT dbo.Properties OFF;
GO

SET IDENTITY_INSERT dbo.Amenities ON;

INSERT INTO dbo.Amenities (AmenityID, Name, Category) VALUES
(1, N'Wi-Fi', N'Connectivity'),
(2, N'Air conditioning', N'Comfort'),
(3, N'Kitchen', N'Essentials'),
(4, N'Parking', N'Transport'),
(5, N'Workspace', N'Work'),
(6, N'Washer', N'Essentials'),
(7, N'Pool', N'Leisure'),
(8, N'Balcony', N'Comfort'),
(9, N'Pets allowed', N'Policies'),
(10, N'Sea view', N'Scenery'),
(11, N'Heating', N'Comfort'),
(12, N'Self check-in', N'Access');

SET IDENTITY_INSERT dbo.Amenities OFF;
GO

INSERT INTO dbo.PropertyAmenities (PropertyID, AmenityID) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 7),
(1, 8),
(1, 9),
(1, 11),
(1, 12),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 8),
(2, 10),
(2, 11),
(2, 12),
(3, 1),
(3, 2),
(3, 3),
(3, 6),
(3, 8),
(3, 9),
(3, 10),
(3, 11),
(3, 12),
(4, 1),
(4, 2),
(4, 3),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(4, 10),
(4, 11),
(4, 12),
(5, 1),
(5, 2),
(5, 3),
(5, 7),
(5, 8),
(5, 11),
(5, 12),
(6, 1),
(6, 2),
(6, 3),
(6, 5),
(6, 7),
(6, 8),
(6, 11),
(6, 12),
(7, 1),
(7, 2),
(7, 3),
(7, 6),
(7, 7),
(7, 10),
(7, 11),
(7, 12),
(8, 1),
(8, 2),
(8, 3),
(8, 5),
(8, 7),
(8, 11),
(8, 12),
(9, 1),
(9, 2),
(9, 3),
(9, 4),
(9, 6),
(9, 10),
(9, 11),
(9, 12),
(10, 1),
(10, 2),
(10, 3),
(10, 4),
(10, 7),
(10, 9),
(10, 11),
(10, 12),
(11, 1),
(11, 2),
(11, 3),
(11, 5),
(11, 6),
(11, 8),
(11, 9),
(11, 10),
(11, 11),
(11, 12),
(12, 1),
(12, 2),
(12, 3),
(12, 5),
(12, 6),
(12, 7),
(12, 9),
(12, 10),
(12, 11),
(12, 12),
(13, 1),
(13, 2),
(13, 3),
(13, 5),
(13, 6),
(13, 9),
(13, 10),
(13, 11),
(13, 12),
(14, 1),
(14, 2),
(14, 3),
(14, 5),
(14, 8),
(14, 11),
(14, 12),
(15, 1),
(15, 2),
(15, 3),
(15, 4),
(15, 6),
(15, 9),
(15, 11),
(15, 12),
(16, 1),
(16, 2),
(16, 3),
(16, 5),
(16, 7),
(16, 10),
(16, 11),
(16, 12),
(17, 1),
(17, 2),
(17, 3),
(17, 4),
(17, 6),
(17, 9),
(17, 10),
(17, 11),
(17, 12),
(18, 1),
(18, 2),
(18, 3),
(18, 5);

INSERT INTO dbo.PropertyAmenities (PropertyID, AmenityID) VALUES
(18, 7),
(18, 11),
(18, 12);
GO

SET IDENTITY_INSERT dbo.Bookings ON;

INSERT INTO dbo.Bookings (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, GuestCount, TotalAmount, Status, CreatedAt) VALUES
(1, 1, 11, '2026-02-05', '2026-02-08', 2, 294, N'Completed', N'2026-01-04T13:20:00'),
(2, 1, 12, '2026-05-17', '2026-05-21', 3, 392, N'Completed', N'2026-04-15T13:20:00'),
(3, 2, 13, '2026-03-05', '2026-03-09', 2, 272, N'Completed', N'2026-02-01T13:20:00'),
(4, 2, 14, '2026-06-17', '2026-06-22', 2, 340, N'Completed', N'2026-05-16T13:20:00'),
(5, 3, 15, '2026-04-05', '2026-04-10', 4, 725, N'Completed', N'2026-03-04T13:20:00'),
(6, 3, 16, '2026-07-17', '2026-07-19', 1, 290, N'Completed', N'2026-06-15T13:20:00'),
(7, 4, 17, '2026-05-05', '2026-05-07', 1, 230, N'Completed', N'2026-04-03T13:20:00'),
(8, 4, 18, '2026-08-17', '2026-08-20', 2, 345, N'Completed', N'2026-07-16T13:20:00'),
(9, 5, 19, '2026-06-05', '2026-06-08', 2, 630, N'Completed', N'2026-05-04T13:20:00'),
(10, 5, 20, '2026-09-17', '2026-09-21', 3, 840, N'Completed', N'2026-08-16T13:20:00'),
(11, 6, 9, '2026-07-05', '2026-07-09', 3, 500, N'Completed', N'2026-06-03T13:20:00'),
(12, 6, 10, '2026-01-17', '2026-01-22', 4, 625, N'Completed', N'2025-12-16T13:20:00'),
(13, 7, 11, '2026-08-05', '2026-08-10', 2, 420, N'Completed', N'2026-07-04T13:20:00'),
(14, 7, 12, '2026-02-17', '2026-02-19', 1, 168, N'Completed', N'2026-01-16T13:20:00'),
(15, 8, 13, '2026-09-05', '2026-09-07', 1, 266, N'Completed', N'2026-08-04T13:20:00'),
(16, 8, 14, '2026-03-17', '2026-03-20', 2, 399, N'Completed', N'2026-02-13T13:20:00'),
(17, 9, 15, '2026-01-05', '2026-01-08', 2, 516, N'Completed', N'2025-12-04T13:20:00'),
(18, 9, 16, '2026-04-17', '2026-04-21', 3, 688, N'Completed', N'2026-03-16T13:20:00'),
(19, 10, 17, '2026-02-05', '2026-02-09', 3, 420, N'Completed', N'2026-01-04T13:20:00'),
(20, 10, 18, '2026-05-17', '2026-05-22', 3, 525, N'Completed', N'2026-04-15T13:20:00'),
(21, 11, 19, '2026-03-05', '2026-03-10', 2, 305, N'Completed', N'2026-02-01T13:20:00'),
(22, 11, 20, '2026-06-17', '2026-06-19', 1, 122, N'Completed', N'2026-05-16T13:20:00'),
(23, 12, 9, '2026-04-05', '2026-04-07', 1, 480, N'Completed', N'2026-03-04T13:20:00'),
(24, 12, 10, '2026-07-17', '2026-07-20', 2, 720, N'Completed', N'2026-06-15T13:20:00'),
(25, 13, 11, '2026-05-05', '2026-05-08', 2, 336, N'Completed', N'2026-04-03T13:20:00'),
(26, 13, 12, '2026-08-17', '2026-08-21', 3, 448, N'Completed', N'2026-07-16T13:20:00'),
(27, 14, 13, '2026-06-05', '2026-06-09', 3, 368, N'Completed', N'2026-05-04T13:20:00'),
(28, 14, 14, '2026-09-17', '2026-09-22', 3, 460, N'Completed', N'2026-08-16T13:20:00'),
(29, 15, 15, '2026-07-05', '2026-07-10', 4, 585, N'Completed', N'2026-06-03T13:20:00'),
(30, 15, 16, '2026-01-17', '2026-01-19', 1, 234, N'Completed', N'2025-12-16T13:20:00'),
(31, 16, 17, '2026-08-05', '2026-08-07', 1, 312, N'Completed', N'2026-07-04T13:20:00'),
(32, 16, 18, '2026-02-17', '2026-02-20', 2, 468, N'Completed', N'2026-01-16T13:20:00'),
(33, 17, 19, '2026-09-05', '2026-09-08', 2, 414, N'Completed', N'2026-08-04T13:20:00'),
(34, 17, 20, '2026-03-17', '2026-03-21', 3, 552, N'Completed', N'2026-02-13T13:20:00'),
(35, 18, 9, '2026-01-05', '2026-01-09', 2, 308, N'Completed', N'2025-12-04T13:20:00'),
(36, 18, 10, '2026-04-17', '2026-04-22', 2, 385, N'Completed', N'2026-03-16T13:20:00'),
(37, 1, 12, '2026-11-03', '2026-11-06', 3, 294, N'Confirmed', N'2026-10-10T12:00:00'),
(38, 2, 15, '2026-12-04', '2026-12-08', 2, 272, N'Confirmed', N'2026-10-10T12:00:00'),
(39, 3, 18, '2026-11-05', '2026-11-10', 5, 725, N'Confirmed', N'2026-10-10T12:00:00'),
(40, 4, 9, '2026-12-06', '2026-12-08', 2, 230, N'Confirmed', N'2026-10-10T12:00:00'),
(41, 5, 12, '2026-11-07', '2026-11-10', 3, 630, N'Confirmed', N'2026-10-10T12:00:00'),
(42, 6, 15, '2026-12-08', '2026-12-12', 4, 500, N'Confirmed', N'2026-10-10T12:00:00'),
(43, 7, 18, '2026-11-09', '2026-11-14', 2, 420, N'Confirmed', N'2026-10-10T12:00:00'),
(44, 8, 9, '2026-12-10', '2026-12-12', 2, 266, N'Confirmed', N'2026-10-10T12:00:00'),
(45, 9, 12, '2026-11-11', '2026-11-14', 3, 516, N'Pending', N'2026-10-10T12:00:00'),
(46, 10, 15, '2026-12-12', '2026-12-16', 3, 420, N'Pending', N'2026-10-10T12:00:00'),
(47, 11, 18, '2026-11-13', '2026-11-18', 2, 305, N'Pending', N'2026-10-10T12:00:00'),
(48, 12, 9, '2026-12-14', '2026-12-16', 2, 480, N'Cancelled', N'2026-10-10T12:00:00'),
(49, 13, 12, '2026-11-15', '2026-11-18', 3, 336, N'Cancelled', N'2026-10-10T12:00:00');

SET IDENTITY_INSERT dbo.Bookings OFF;
GO

SET IDENTITY_INSERT dbo.Payments ON;

INSERT INTO dbo.Payments (PaymentID, BookingID, Amount, PaymentMethod, Status, PaidAt, TransactionRef, CreatedAt) VALUES
(1, 1, 294, N'PayPal', N'Completed', N'2026-01-06T14:30:00', N'TXN-2026-00001', N'2026-01-06T14:25:00'),
(2, 2, 392, N'Bank Transfer', N'Completed', N'2026-04-17T14:30:00', N'TXN-2026-00002', N'2026-04-17T14:25:00'),
(3, 3, 272, N'Apple Pay', N'Completed', N'2026-02-03T14:30:00', N'TXN-2026-00003', N'2026-02-03T14:25:00'),
(4, 4, 340, N'Card', N'Completed', N'2026-05-18T14:30:00', N'TXN-2026-00004', N'2026-05-18T14:25:00'),
(5, 5, 725, N'PayPal', N'Completed', N'2026-03-06T14:30:00', N'TXN-2026-00005', N'2026-03-06T14:25:00'),
(6, 6, 290, N'Bank Transfer', N'Completed', N'2026-06-17T14:30:00', N'TXN-2026-00006', N'2026-06-17T14:25:00'),
(7, 7, 230, N'Apple Pay', N'Completed', N'2026-04-05T14:30:00', N'TXN-2026-00007', N'2026-04-05T14:25:00'),
(8, 8, 345, N'Card', N'Completed', N'2026-07-18T14:30:00', N'TXN-2026-00008', N'2026-07-18T14:25:00'),
(9, 9, 630, N'PayPal', N'Completed', N'2026-05-06T14:30:00', N'TXN-2026-00009', N'2026-05-06T14:25:00'),
(10, 10, 840, N'Bank Transfer', N'Completed', N'2026-08-18T14:30:00', N'TXN-2026-00010', N'2026-08-18T14:25:00'),
(11, 11, 500, N'Apple Pay', N'Completed', N'2026-06-05T14:30:00', N'TXN-2026-00011', N'2026-06-05T14:25:00'),
(12, 12, 625, N'Card', N'Completed', N'2025-12-18T14:30:00', N'TXN-2026-00012', N'2025-12-18T14:25:00'),
(13, 13, 420, N'PayPal', N'Completed', N'2026-07-06T14:30:00', N'TXN-2026-00013', N'2026-07-06T14:25:00'),
(14, 14, 168, N'Bank Transfer', N'Completed', N'2026-01-18T14:30:00', N'TXN-2026-00014', N'2026-01-18T14:25:00'),
(15, 15, 266, N'Apple Pay', N'Completed', N'2026-08-06T14:30:00', N'TXN-2026-00015', N'2026-08-06T14:25:00'),
(16, 16, 399, N'Card', N'Completed', N'2026-02-15T14:30:00', N'TXN-2026-00016', N'2026-02-15T14:25:00'),
(17, 17, 516, N'PayPal', N'Completed', N'2025-12-06T14:30:00', N'TXN-2026-00017', N'2025-12-06T14:25:00'),
(18, 18, 688, N'Bank Transfer', N'Completed', N'2026-03-18T14:30:00', N'TXN-2026-00018', N'2026-03-18T14:25:00'),
(19, 19, 420, N'Apple Pay', N'Completed', N'2026-01-06T14:30:00', N'TXN-2026-00019', N'2026-01-06T14:25:00'),
(20, 20, 525, N'Card', N'Completed', N'2026-04-17T14:30:00', N'TXN-2026-00020', N'2026-04-17T14:25:00'),
(21, 21, 305, N'PayPal', N'Completed', N'2026-02-03T14:30:00', N'TXN-2026-00021', N'2026-02-03T14:25:00'),
(22, 22, 122, N'Bank Transfer', N'Completed', N'2026-05-18T14:30:00', N'TXN-2026-00022', N'2026-05-18T14:25:00'),
(23, 23, 480, N'Apple Pay', N'Completed', N'2026-03-06T14:30:00', N'TXN-2026-00023', N'2026-03-06T14:25:00'),
(24, 24, 720, N'Card', N'Completed', N'2026-06-17T14:30:00', N'TXN-2026-00024', N'2026-06-17T14:25:00'),
(25, 25, 336, N'PayPal', N'Completed', N'2026-04-05T14:30:00', N'TXN-2026-00025', N'2026-04-05T14:25:00'),
(26, 26, 448, N'Bank Transfer', N'Completed', N'2026-07-18T14:30:00', N'TXN-2026-00026', N'2026-07-18T14:25:00'),
(27, 27, 368, N'Apple Pay', N'Completed', N'2026-05-06T14:30:00', N'TXN-2026-00027', N'2026-05-06T14:25:00'),
(28, 28, 460, N'Card', N'Completed', N'2026-08-18T14:30:00', N'TXN-2026-00028', N'2026-08-18T14:25:00'),
(29, 29, 585, N'PayPal', N'Completed', N'2026-06-05T14:30:00', N'TXN-2026-00029', N'2026-06-05T14:25:00'),
(30, 30, 234, N'Bank Transfer', N'Completed', N'2025-12-18T14:30:00', N'TXN-2026-00030', N'2025-12-18T14:25:00'),
(31, 31, 312, N'Apple Pay', N'Completed', N'2026-07-06T14:30:00', N'TXN-2026-00031', N'2026-07-06T14:25:00'),
(32, 32, 468, N'Card', N'Completed', N'2026-01-18T14:30:00', N'TXN-2026-00032', N'2026-01-18T14:25:00'),
(33, 33, 414, N'PayPal', N'Completed', N'2026-08-06T14:30:00', N'TXN-2026-00033', N'2026-08-06T14:25:00'),
(34, 34, 552, N'Bank Transfer', N'Completed', N'2026-02-15T14:30:00', N'TXN-2026-00034', N'2026-02-15T14:25:00'),
(35, 35, 308, N'Apple Pay', N'Completed', N'2025-12-06T14:30:00', N'TXN-2026-00035', N'2025-12-06T14:25:00'),
(36, 36, 385, N'Card', N'Completed', N'2026-03-18T14:30:00', N'TXN-2026-00036', N'2026-03-18T14:25:00'),
(37, 37, 294, N'Card', N'Completed', N'2026-10-12T12:30:00', N'TXN-2026-00037', N'2026-10-12T12:25:00'),
(38, 38, 272, N'Card', N'Completed', N'2026-10-12T12:30:00', N'TXN-2026-00038', N'2026-10-12T12:25:00'),
(39, 39, 725, N'Card', N'Completed', N'2026-10-12T12:30:00', N'TXN-2026-00039', N'2026-10-12T12:25:00'),
(40, 40, 230, N'Card', N'Completed', N'2026-10-12T12:30:00', N'TXN-2026-00040', N'2026-10-12T12:25:00'),
(41, 41, 630, N'Card', N'Completed', N'2026-10-12T12:30:00', N'TXN-2026-00041', N'2026-10-12T12:25:00'),
(42, 42, 500, N'Card', N'Completed', N'2026-10-12T12:30:00', N'TXN-2026-00042', N'2026-10-12T12:25:00'),
(43, 43, 420, N'Card', N'Completed', N'2026-10-12T12:30:00', N'TXN-2026-00043', N'2026-10-12T12:25:00'),
(44, 44, 266, N'Card', N'Completed', N'2026-10-12T12:30:00', N'TXN-2026-00044', N'2026-10-12T12:25:00'),
(45, 45, 516, N'Bank Transfer', N'Pending', NULL, NULL, N'2026-10-12T12:25:00'),
(46, 46, 420, N'Bank Transfer', N'Pending', NULL, NULL, N'2026-10-12T12:25:00'),
(47, 47, 305, N'Bank Transfer', N'Pending', NULL, NULL, N'2026-10-12T12:25:00');

SET IDENTITY_INSERT dbo.Payments OFF;
GO

SET IDENTITY_INSERT dbo.Reviews ON;

INSERT INTO dbo.Reviews (ReviewID, BookingID, Rating, Comment, CreatedAt) VALUES
(1, 1, 4, N'Clean rooms and a convenient location.', N'2026-02-10T10:40:00'),
(2, 2, 5, N'Nice stay, helpful host and good amenities.', N'2026-05-23T10:40:00'),
(3, 3, 5, N'Nice stay, helpful host and good amenities.', N'2026-03-11T10:40:00'),
(4, 6, 4, N'Very pleasant accommodation and easy check-in.', N'2026-07-21T10:40:00'),
(5, 7, 4, N'Very pleasant accommodation and easy check-in.', N'2026-05-09T10:40:00'),
(6, 8, 5, N'Clean rooms and a convenient location.', N'2026-08-22T10:40:00'),
(7, 9, 5, N'Clean rooms and a convenient location.', N'2026-06-10T10:40:00'),
(8, 12, 4, N'Comfortable beds and a quiet neighborhood.', N'2026-01-24T10:40:00'),
(9, 13, 4, N'Comfortable beds and a quiet neighborhood.', N'2026-08-12T10:40:00'),
(10, 14, 5, N'Very pleasant accommodation and easy check-in.', N'2026-02-21T10:40:00'),
(11, 15, 5, N'Very pleasant accommodation and easy check-in.', N'2026-09-09T10:40:00'),
(12, 18, 4, N'Nice stay, helpful host and good amenities.', N'2026-04-23T10:40:00'),
(13, 19, 4, N'Nice stay, helpful host and good amenities.', N'2026-02-11T10:40:00'),
(14, 20, 5, N'Comfortable beds and a quiet neighborhood.', N'2026-05-24T10:40:00'),
(15, 21, 5, N'Comfortable beds and a quiet neighborhood.', N'2026-03-12T10:40:00'),
(16, 24, 4, N'Clean rooms and a convenient location.', N'2026-07-22T10:40:00'),
(17, 25, 4, N'Clean rooms and a convenient location.', N'2026-05-10T10:40:00'),
(18, 26, 5, N'Nice stay, helpful host and good amenities.', N'2026-08-23T10:40:00'),
(19, 27, 5, N'Nice stay, helpful host and good amenities.', N'2026-06-11T10:40:00'),
(20, 30, 4, N'Very pleasant accommodation and easy check-in.', N'2026-01-21T10:40:00'),
(21, 31, 4, N'Very pleasant accommodation and easy check-in.', N'2026-08-09T10:40:00'),
(22, 32, 5, N'Clean rooms and a convenient location.', N'2026-02-22T10:40:00'),
(23, 33, 5, N'Clean rooms and a convenient location.', N'2026-09-10T10:40:00'),
(24, 36, 4, N'Comfortable beds and a quiet neighborhood.', N'2026-04-24T10:40:00');

SET IDENTITY_INSERT dbo.Reviews OFF;
GO
