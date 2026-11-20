USE library_db;



-- add a new book

START TRANSACTION;

INSERT INTO ITEM (Title) VALUES ('The Ember Atlas');

INSERT INTO BOOK (ItemID, Author, Genre, PubYear, ISBN, Format, Publisher)

VALUES (LAST_INSERT_ID(), 'Rowan Pike', 'Fantasy', 2026, '9781234567901',

        'Hardcover', 'Silverleaf Publishing');

COMMIT;



SELECT i.ItemID, i.Title, b.Author, b.ISBN, i.AvailabilityStatus

FROM ITEM i JOIN BOOK b ON b.ItemID = i.ItemID

WHERE b.ISBN = '9781234567901';





-- check out an item (only if client is active and item is available)

START TRANSACTION;

SET @client = 8, @item = 30;



INSERT INTO LOAN (ClientID, ItemID, CheckoutDate, DueDate)

SELECT c.ClientID, @item, CURDATE(), DATE_ADD(CURDATE(), INTERVAL m.LoanPeriod DAY)

FROM CLIENT c

JOIN MEMBERSHIP m ON m.MembershipType = c.MembershipType

WHERE c.ClientID = @client

  AND c.AccountStatus = 'Active'

  AND EXISTS (SELECT 1 FROM ITEM WHERE ItemID = @item AND AvailabilityStatus = 'Available');

SET @loan_created = ROW_COUNT();   -- 1 = worked, 0 = rejected



UPDATE ITEM SET AvailabilityStatus = 'Checked Out'

WHERE ItemID = @item AND @loan_created = 1;

COMMIT;



SELECT @loan_created AS loan_created;





-- return an item and charge the late fine

START TRANSACTION;

SET @loan = 9;



UPDATE CLIENT c

JOIN LOAN l       ON l.ClientID = c.ClientID

JOIN MEMBERSHIP m ON m.MembershipType = c.MembershipType

SET c.FeesOwed = c.FeesOwed

      + GREATEST(GREATEST(DATEDIFF(CURDATE(), l.DueDate), 0) * m.DailyFine - l.FineAmount, 0)

WHERE l.LoanID = @loan AND l.ReturnDate IS NULL;



UPDATE ITEM i

JOIN LOAN l ON l.ItemID = i.ItemID

SET i.AvailabilityStatus = 'Available'

WHERE l.LoanID = @loan AND l.ReturnDate IS NULL;



UPDATE LOAN l

JOIN CLIENT c     ON c.ClientID = l.ClientID

JOIN MEMBERSHIP m ON m.MembershipType = c.MembershipType

SET l.ReturnDate = CURDATE(),

    l.FineAmount = GREATEST(GREATEST(DATEDIFF(CURDATE(), l.DueDate), 0) * m.DailyFine,

                            l.FineAmount)

WHERE l.LoanID = @loan AND l.ReturnDate IS NULL;

COMMIT;



SELECT LoanID, ReturnDate, FineAmount FROM LOAN WHERE LoanID = @loan;





-- search the catalog by keyword

SET @kw = 'silent';

SELECT i.ItemID, i.Title, s.ItemType, s.Creator, s.Genre, i.AvailabilityStatus

FROM ITEM i

JOIN (

    SELECT ItemID, 'Book' AS ItemType, Author AS Creator, Genre FROM BOOK

    UNION ALL

    SELECT ItemID, 'Digital Media', Creator, Genre FROM DIGITAL_MEDIA

    UNION ALL

    SELECT ItemID, 'Magazine', Publisher, NULL FROM MAGAZINE

) s ON s.ItemID = i.ItemID

WHERE CHAR_LENGTH(TRIM(@kw)) > 0

  AND (   LOCATE(LOWER(TRIM(@kw)), LOWER(i.Title))   > 0

       OR LOCATE(LOWER(TRIM(@kw)), LOWER(s.Creator)) > 0

       OR LOCATE(LOWER(TRIM(@kw)), LOWER(IFNULL(s.Genre, ''))) > 0)

ORDER BY i.Title;





-- a client's loan status

SET @client = 3;

SELECT l.LoanID, i.Title, l.CheckoutDate, l.DueDate, l.ReturnDate,

       CASE

         WHEN l.ReturnDate IS NOT NULL AND l.ReturnDate > l.DueDate THEN 'Returned late'

         WHEN l.ReturnDate IS NOT NULL                              THEN 'Returned'

         WHEN l.DueDate < CURDATE()                                 THEN 'Overdue'

         ELSE 'On loan'

       END AS loan_status,

       CASE WHEN l.ReturnDate IS NULL THEN DATEDIFF(l.DueDate, CURDATE()) END AS days_until_due,

       l.FineAmount

FROM LOAN l JOIN ITEM i ON i.ItemID = l.ItemID

WHERE l.ClientID = @client

ORDER BY l.CheckoutDate DESC;





-- overdue loans

SELECT l.LoanID,

       CONCAT(c.FirstName, ' ', c.LastName)             AS client,

       c.Email, c.MembershipType, i.Title, l.DueDate,

       DATEDIFF(CURDATE(), l.DueDate)                   AS days_overdue,

       l.FineAmount                                     AS stored_fine,

       DATEDIFF(CURDATE(), l.DueDate) * m.DailyFine     AS computed_fine

FROM LOAN l

JOIN CLIENT c     ON c.ClientID = l.ClientID

JOIN MEMBERSHIP m ON m.MembershipType = c.MembershipType

JOIN ITEM i       ON i.ItemID = l.ItemID

WHERE l.ReturnDate IS NULL AND l.DueDate < CURDATE()

ORDER BY days_overdue DESC;





-- availability by item type

SELECT t.ItemType,

       COUNT(*)                                  AS total_items,

       SUM(i.AvailabilityStatus = 'Available')   AS available,

       SUM(i.AvailabilityStatus = 'Checked Out') AS checked_out,

       SUM(i.Restricted = 'Restricted')          AS restricted,

       ROUND(100 * SUM(i.AvailabilityStatus = 'Available') / COUNT(*), 1) AS pct_available

FROM ITEM i

JOIN (

    SELECT ItemID, 'Book' AS ItemType FROM BOOK

    UNION ALL SELECT ItemID, 'Digital Media' FROM DIGITAL_MEDIA

    UNION ALL SELECT ItemID, 'Magazine' FROM MAGAZINE

) t ON t.ItemID = i.ItemID

GROUP BY t.ItemType;





-- client activity (loans and reservations counted separately so joins don't double count)

SELECT c.ClientID,

       CONCAT(c.FirstName, ' ', c.LastName)  AS client,

       c.MembershipType, c.AccountStatus, c.FeesOwed,

       COALESCE(ln.total_loans, 0)       AS total_loans,

       COALESCE(ln.active_loans, 0)      AS active_loans,

       COALESCE(ln.overdue_loans, 0)     AS overdue_loans,

       COALESCE(ln.total_fines, 0)       AS total_fines,

       COALESCE(rs.open_reservations, 0) AS open_reservations

FROM CLIENT c

LEFT JOIN (

    SELECT ClientID,

           COUNT(*)                                        AS total_loans,

           SUM(ReturnDate IS NULL)                         AS active_loans,

           SUM(ReturnDate IS NULL AND DueDate < CURDATE()) AS overdue_loans,

           SUM(FineAmount)                                 AS total_fines

    FROM LOAN GROUP BY ClientID

) ln ON ln.ClientID = c.ClientID

LEFT JOIN (

    SELECT ClientID, SUM(ReservationStatus IN ('Pending', 'Ready')) AS open_reservations

    FROM RESERVATION GROUP BY ClientID

) rs ON rs.ClientID = c.ClientID

ORDER BY overdue_loans DESC, total_fines DESC;





-- bad input (run one at a time, each should error)



-- 3819: invalid membership type

INSERT INTO MEMBERSHIP VALUES ('Premium', 5, 1.00, 7, 3);



-- 3819: due date before checkout date

INSERT INTO LOAN (ClientID, ItemID, CheckoutDate, DueDate)

VALUES (1, 30, '2026-11-20', '2026-11-10');



-- 3819: negative fee balance

UPDATE CLIENT SET FeesOwed = FeesOwed - 100 WHERE ClientID = 2;



-- 1452: client doesn't exist

INSERT INTO LOAN (ClientID, ItemID, CheckoutDate, DueDate)

VALUES (999, 30, '2026-11-20', '2026-12-04');



-- 1451: client has loan history

DELETE FROM CLIENT WHERE ClientID = 1;



-- bad ISBNs (rolled back after)

START TRANSACTION;

INSERT INTO ITEM (Title) VALUES ('ISBN Test Item');

SET @t = LAST_INSERT_ID();

INSERT INTO BOOK (ItemID, Author, Genre, ISBN) VALUES (@t, 'A', 'B', '12345');          -- too short

INSERT INTO BOOK (ItemID, Author, Genre, ISBN) VALUES (@t, 'A', 'B', '97812345678AB');  -- has letters

INSERT INTO BOOK (ItemID, Author, Genre, ISBN) VALUES (@t, 'A', 'B', '9781234567890');  -- duplicate

ROLLBACK;



-- these search inputs should just return 0 rows (re-run the search with each):

--   SET @kw = '   ';

--   SET @kw = '%';

--   SET @kw = 'x''; DROP TABLE ITEM;--';





-- performance: compare the plan before and after adding an index

EXPLAIN ANALYZE

SELECT LoanID, ClientID, DueDate

FROM LOAN

WHERE ReturnDate IS NULL AND DueDate < CURDATE();



CREATE INDEX idx_loan_open_due ON LOAN (ReturnDate, DueDate);



EXPLAIN ANALYZE

SELECT LoanID, ClientID, DueDate

FROM LOAN

WHERE ReturnDate IS NULL AND DueDate < CURDATE();
