-- mysql -u root < library_schema.sql
-- mysql -u root < library_data.sql
-- mysql -u root

-- ----------------------------------
USE library_db;

-- MEMBERSHIP
INSERT INTO MEMBERSHIP (MembershipType, BorrowingLimit, DailyFine, LoanPeriod, ReserveLimit)
VALUES ('Regular', 10, 5.00, 14, 5),
    ('Student', 15, 3.00, 21, 15),
    ('Senior', 10, 3.00, 30, 10)
;

-- CLIENT (MembershipType must already exist in MEMBERSHIP)
INSERT INTO CLIENT (ClientID, FirstName, LastName, Email, AccountStatus, FeesOwed, MembershipType)
VALUES (1, 'Maria', 'Lopez', 'maria.lopez@example.com', 'Active', 0.00, 'Student');

-- ITEM --

-- BOOK (ItemID must match a row in ITEM)
INSERT INTO ITEM (ItemID, Title, AvailabilityStatus, Restricted)
VALUES (1, 'Dune', 'Checked Out', 'None');

INSERT INTO BOOK (ItemID, Author, Genre, PubYear, ISBN, Format, Publisher)
VALUES (1, 'Frank Herbert', 'Sci-Fi', 1965, '9780441013593', 'Paperback', 'Ace Books');

-- DIGITAL_MEDIA (needs its own ITEM row first)
INSERT INTO ITEM (ItemID, Title) 
VALUES (2, 'Planet Earth');

INSERT INTO DIGITAL_MEDIA (ItemID, Creator, Format, Genre, ReleaseYear)
VALUES (2, 'BBC', 'DVD', 'Documentary', 2006);

-- MAGAZINE (needs its own ITEM row first; Publisher is required)
INSERT INTO ITEM (ItemID, Title) 
VALUES (3, 'National Geographic');

INSERT INTO MAGAZINE (ItemID, IssueNum, PubDate, Publisher)
VALUES (3, 'Nov 2026', '2026-11-01', 'National Geographic Society');


-- LOAN (client 1 borrows item 1; student loan period is 21 days)
INSERT INTO LOAN (LoanID, ClientID, ItemID, CheckoutDate, DueDate, ReturnDate, FineAmount)
VALUES (1, 1, 1, '2026-11-10', '2026-12-01', NULL, 0.00);

-- RESERVATION
INSERT INTO RESERVATION (ReservationID, ClientID, ItemID, ReservationDate, ReservationStatus)
VALUES (1, 1, 2, '2026-11-15', 'Pending');
