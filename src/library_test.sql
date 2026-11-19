-- mysql -u root < library_schema.sql
-- mysql -u root < library_data.sql
-- mysql -u root

-- mysql> source library_test.sql;
-- Look at the screenshot for how the output should look like

USE library_db;

-- Print table contents
SELECT * FROM MEMBERSHIP;
SELECT * FROM CLIENT;
SELECT * FROM ITEM;
SELECT * FROM BOOK;
SELECT * FROM DIGITAL_MEDIA;
SELECT * FROM MAGAZINE;
SELECT * FROM LOAN;
SELECT * FROM RESERVATION;