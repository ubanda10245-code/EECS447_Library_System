-- mysql -u root < library_schema.sql
-- mysql -u root < library_data.sql
-- mysql -u root

-- ----------------------------------
USE library_db;

-- MEMBERSHIP
INSERT INTO MEMBERSHIP (MembershipType, BorrowingLimit, DailyFine, LoanPeriod, ReserveLimit)
VALUES 
('Regular', 10, 5.00, 14, 5),
('Student', 15, 3.00, 21, 15),
('Senior', 10, 3.00, 30, 10)
;

-- CLIENT (MembershipType must already exist in MEMBERSHIP)
INSERT INTO CLIENT (ClientID, FirstName, LastName, Email, AccountStatus, FeesOwed, MembershipType)
VALUES 
(1, 'Ethan', 'Marlowe', 'ethan.marlowe@example.com', 'Active', 0.00, 'Regular'),
(2, 'Sophia', 'Whitaker', 'sophia.whitaker@example.com', 'Active', 5.00, 'Student'),
(3, 'Lucas', 'Bennett', 'lucas.bennett@example.com', 'Active', 0.00, 'Senior'),
(4, 'Amelia', 'Calloway', 'amelia.calloway@example.com', 'Active', 0.00, 'Student'),
(5, 'Noah', 'Prescott', 'noah.prescott@example.com', 'Suspended', 15.00, 'Regular'),
(6, 'Isabella', 'Monroe', 'isabella.monroe@example.com', 'Active', 0.00, 'Senior'),
(7, 'Oliver', 'Hawthorne', 'oliver.hawthorne@example.com', 'Active', 3.00, 'Student'),
(8, 'Charlotte', 'Winslow', 'charlotte.winslow@example.com', 'Active', 0.00, 'Regular'),
(9, 'Henry', 'Ashford', 'henry.ashford@example.com', 'Active', 0.00, 'Senior'),
(10, 'Grace', 'Ellington', 'grace.ellington@example.com', 'Active', 10.00, 'Student')
;

-- ITEM --
INSERT INTO ITEM (ItemID, Title, AvailabilityStatus, Restricted)
VALUES
-- Books (ItemID 1-10)
(1, 'The Clockwork Garden', 'Available', 'None'),
(2, 'Whispers Beyond the Valley', 'Checked Out', 'None'),
(3, 'The Last Cartographer', 'Available', 'None'),
(4, 'Beneath the Silver Moon', 'Checked Out', 'None'),
(5, 'Echoes of the Forgotten City', 'Available', 'None'),
(6, 'The Glass Harbor', 'Available', 'Restricted'),
(7, 'A Kingdom of Embers', 'Checked Out', 'None'),
(8, 'The Art of Silent Rivers', 'Available', 'None'),
(9, 'Shadows Over Evermere', 'Checked Out', 'Restricted'),
(10, 'The Midnight Archive', 'Available', 'None'),

-- Digital Media (ItemID 11-20)
(11, 'Beyond the Digital Horizon', 'Available', 'None'),
(12, 'Mysteries of Deep Space', 'Checked Out', 'None'),
(13, 'The Lost Signal', 'Available', 'None'),
(14, 'Legends of the Iron Coast', 'Checked Out', 'None'),
(15, 'A Journey Through Time', 'Available', 'None'),
(16, 'The Hidden Frequency', 'Available', 'Restricted'),
(17, 'Wildlife of the Northern Realm', 'Checked Out', 'None'),
(18, 'The Forgotten Experiment', 'Available', 'None'),
(19, 'Voices from Another World', 'Checked Out', 'Restricted'),
(20, 'The Infinite Machine', 'Available', 'None'),

-- Magazines (ItemID 21-30)
(21, 'Modern Living Quarterly', 'Available', 'None'),
(22, 'Future Technology Review', 'Checked Out', 'None'),
(23, 'The Creative Workshop', 'Available', 'None'),
(24, 'Nature and Discovery', 'Checked Out', 'None'),
(25, 'World Architecture Today', 'Available', 'None'),
(26, 'Science Frontier Monthly', 'Available', 'Restricted'),
(27, 'The Culinary Journal', 'Checked Out', 'None'),
(28, 'Digital Innovations', 'Available', 'None'),
(29, 'Exploring Our Planet', 'Checked Out', 'Restricted'),
(30, 'The History Collector', 'Available', 'None')
;


-- BOOK
INSERT INTO BOOK (ItemID, Author, Genre, PubYear, ISBN, Format, Publisher)
VALUES
(1, 'Adrian Vale', 'Fantasy', 2021, '9781234567890', 'Hardcover', 'Silverleaf Publishing'),
(2, 'Marina Ellery', 'Mystery', 2020, '9781234567891', 'Paperback', 'Northstar Press'),
(3, 'Julian Mercer', 'Adventure', 2023, '9781234567892', 'Hardcover', 'Willow Creek Books'),
(4, 'Elena Frost', 'Romance', 2019, '9781234567893', 'Paperback', 'Moonstone Publishers'),
(5, 'Nathaniel Cross', 'Historical Fiction', 2022, '9781234567894', 'Hardcover', 'Ashwood Publishing'),
(6, 'Clara Winslet', 'Science Fiction', 2024, '9781234567895', 'Paperback', 'Silverleaf Publishing'),
(7, 'Dominic Hale', 'Fantasy', 2021, '9781234567896', 'Hardcover', 'Northstar Press'),
(8, 'Vivian Locke', 'Literary Fiction', 2018, '9781234567897', 'Paperback', 'Willow Creek Books'),
(9, 'Theodore Blake', 'Thriller', 2025, '9781234567898', 'Hardcover', 'Moonstone Publishers'),
(10, 'Isabelle Rowan', 'Mystery', 2022, '9781234567899', 'Paperback', 'Ashwood Publishing')
;

-- DIGITAL_MEDIA
INSERT INTO DIGITAL_MEDIA (ItemID, Creator, Format, Genre, ReleaseYear)
VALUES
(11, 'Marcus Ellwood', 'Audiobook', 'Educational', 2022),
(12, 'Stella Maren', 'DVD', 'Science Fiction', 2021),
(13, 'Oliver Dane', 'Blu-ray', 'Mystery', 2023),
(14, 'Rebecca Thorn', 'DVD', 'Adventure', 2020),
(15, 'Caleb Winters', 'Audiobook', 'Historical', 2024),
(16, 'Nora Bellamy', 'Blu-ray', 'Documentary', 2022),
(17, 'Graham Sterling', 'DVD', 'Nature', 2019),
(18, 'Audrey Sinclair', 'Audiobook', 'Science Fiction', 2025),
(19, 'Felix Hartwell', 'Blu-ray', 'Fantasy', 2023),
(20, 'Lydia Everly', 'DVD', 'Educational', 2021)
;

-- MAGAZINE
INSERT INTO MAGAZINE (ItemID, IssueNum, PubDate, Publisher)
VALUES
(21, 'Vol. 8 Issue 11', '2026-11-01', 'Evergreen Media Group'),
(22, 'Vol. 5 Issue 11', '2026-11-03', 'Horizon Publications'),
(23, 'Vol. 12 Issue 11', '2026-11-05', 'Creative House Press'),
(24, 'Vol. 7 Issue 11', '2026-11-07', 'Evergreen Media Group'),
(25, 'Vol. 9 Issue 11', '2026-11-09', 'Horizon Publications'),
(26, 'Vol. 4 Issue 11', '2026-11-12', 'Discovery Publishing'),
(27, 'Vol. 6 Issue 11', '2026-11-15', 'Creative House Press'),
(28, 'Vol. 10 Issue 12', '2026-12-01', 'Evergreen Media Group'),
(29, 'Vol. 3 Issue 12', '2026-12-05', 'Discovery Publishing'),
(30, 'Vol. 11 Issue 12', '2026-12-10', 'Horizon Publications')
;


-- LOAN
INSERT INTO LOAN (LoanID, ClientID, ItemID, CheckoutDate, DueDate, ReturnDate, FineAmount)
VALUES
-- Client 1: Ethan Marlowe (Regular)
(1, 1, 2, '2026-10-20', '2026-11-03', NULL, 80.00),
(2, 1, 27, '2026-11-10', '2026-11-24', NULL, 0.00),

-- Client 2: Sophia Whitaker (Student)
(3, 2, 4, '2026-10-20', '2026-11-10', NULL, 27.00),
(4, 2, 29, '2026-11-05', '2026-11-26', NULL, 0.00),

-- Client 3: Lucas Bennett (Senior)
(5, 3, 7, '2026-10-10', '2026-11-09', NULL, 30.00),
(6, 3, 1, '2026-09-10', '2026-10-10', '2026-10-12', 6.00),

-- Client 4: Amelia Calloway (Student)
(7, 4, 9, '2026-10-25', '2026-11-15', NULL, 12.00),
(8, 4, 3, '2026-10-01', '2026-10-22', '2026-10-24', 6.00),

-- Client 5: Noah Prescott (Regular)
(9, 5, 12, '2026-11-01', '2026-11-15', NULL, 20.00),
(10, 5, 5, '2026-10-01', '2026-10-15', '2026-10-17', 10.00),

-- Client 6: Isabella Monroe (Senior)
(11, 6, 14, '2026-10-25', '2026-11-24', NULL, 0.00),

-- Client 7: Oliver Hawthorne (Student)
(12, 7, 17, '2026-11-05', '2026-11-26', NULL, 0.00),

-- Client 8: Charlotte Winslow (Regular)
(13, 8, 19, '2026-11-10', '2026-11-24', NULL, 0.00),

-- Client 9: Henry Ashford (Senior)
(14, 9, 22, '2026-11-01', '2026-12-01', NULL, 0.00),

-- Client 10: Grace Ellington (Student)
(15, 10, 24, '2026-11-01', '2026-11-22', NULL, 0.00)
;


-- RESERVATION
INSERT INTO RESERVATION (ReservationID, ClientID, ItemID, ReservationDate, ReservationStatus) 
VALUES
(1,  1,  1,  '2026-11-01', 'Fulfilled'),
(2,  2,  12, '2026-11-03', 'Pending'),
(3,  3,  23, '2026-11-05', 'Ready'),
(4,  4,  4,  '2026-11-07', 'Pending'),
(5,  5,  15, '2026-11-10', 'Fulfilled'),
(6,  6,  26, '2026-11-12', 'Ready'),
(7,  7,  7,  '2026-11-15', 'Pending'),
(8,  8,  18, '2026-11-17', 'Expired'),
(9,  9,  29, '2026-11-19', 'Pending'),
(10, 10, 10, '2026-11-21', 'Pending')
;
