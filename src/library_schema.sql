-- mysql -u root 
-- mysql> source library_schema.sql;

-- OR

-- mysql -u root < library_schema.sql

-- ----------------------------------
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- DROP TABLES (for re-running the database creation)
DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS LOAN;
DROP TABLE IF EXISTS CLIENT;
DROP TABLE IF EXISTS MEMBERSHIP;
DROP TABLE IF EXISTS MAGAZINE;
DROP TABLE IF EXISTS DIGITAL_MEDIA;
DROP TABLE IF EXISTS BOOK;
DROP TABLE IF EXISTS ITEM;

-- ITEM (superclass)
CREATE TABLE ITEM (
    ItemID INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    AvailabilityStatus VARCHAR(20) NOT NULL DEFAULT 'Available',
    Restricted VARCHAR(20) NOT NULL DEFAULT 'None',

    PRIMARY KEY (ItemID),
    CONSTRAINT check_item_availability 
        CHECK (AvailabilityStatus IN ('Available', 'Checked Out')),
    CONSTRAINT check_item_restricted 
        CHECK (Restricted IN ('None', 'Restricted'))
);

-- BOOK (subclass of ITEM)
CREATE TABLE BOOK (
    ItemID    INT NOT NULL,
    Author    VARCHAR(100) NOT NULL,
    Genre     VARCHAR(50) NOT NULL,
    PubYear   YEAR,
    ISBN      CHAR(13) NOT NULL,
    Format    VARCHAR(30),
    Publisher VARCHAR(100),

    PRIMARY KEY (ItemID),
    CONSTRAINT fk_book_item
        FOREIGN KEY (ItemID) REFERENCES ITEM (ItemID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    UNIQUE KEY uq_book_isbn (ISBN),
    CONSTRAINT check_book_isbn CHECK (ISBN REGEXP '^[0-9]{13}$')
);

-- DIGITAL_MEDIA (subclass of ITEM)
CREATE TABLE DIGITAL_MEDIA (
    ItemID INT NOT NULL,
    Creator VARCHAR(100) NOT NULL,
    Format VARCHAR(30),
    Genre VARCHAR(50) NOT NULL,
    ReleaseYear YEAR,

    PRIMARY KEY (ItemID),
    CONSTRAINT fk_digital_media_item
        FOREIGN KEY (ItemID) REFERENCES ITEM (ItemID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- MAGAZINE (subclass of ITEM)
CREATE TABLE MAGAZINE (
    ItemID INT NOT NULL,
    IssueNum VARCHAR(20) NOT NULL,
    PubDate DATE NOT NULL,
    Publisher VARCHAR(100) NOT NULL,

    PRIMARY KEY (ItemID),
    CONSTRAINT fk_magazine_item
        FOREIGN KEY (ItemID) REFERENCES ITEM (ItemID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
 
-- MEMBERSHIP
CREATE TABLE MEMBERSHIP (
    MembershipType VARCHAR(10) NOT NULL,
    BorrowingLimit INT NOT NULL,
    DailyFine DECIMAL(7,2) NOT NULL,
    LoanPeriod INT NOT NULL,
    ReserveLimit INT NOT NULL,

    PRIMARY KEY (MembershipType),
    CONSTRAINT check_membership_type
        CHECK (MembershipType IN ('Regular', 'Student', 'Senior')),
    CONSTRAINT check_membership_limits
        CHECK (BorrowingLimit > 0 AND LoanPeriod > 0 AND ReserveLimit > 0 AND DailyFine >= 0)
);

-- CLIENT
CREATE TABLE CLIENT (
    ClientID INT NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(250),
    AccountStatus VARCHAR(20) NOT NULL DEFAULT 'Active',
    FeesOwed DECIMAL(7,2) NOT NULL DEFAULT 0.00,
    MembershipType VARCHAR(10) NOT NULL,

    PRIMARY KEY (ClientID),
    CONSTRAINT fk_client_membership
        FOREIGN KEY (MembershipType) REFERENCES MEMBERSHIP (MembershipType)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT check_client_status
        CHECK (AccountStatus IN ('Active', 'Suspended', 'Expired')),
    CONSTRAINT check_client_fees CHECK (FeesOwed >= 0)
);
 
-- LOAN (relational entity; CLIENT borrows ITEM)
CREATE TABLE LOAN (
    LoanID INT NOT NULL AUTO_INCREMENT,
    ClientID INT NOT NULL,
    ItemID INT NOT NULL,
    CheckoutDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,
    FineAmount DECIMAL(7,2) NOT NULL DEFAULT 0.00,

    PRIMARY KEY (LoanID),
    CONSTRAINT fk_loan_client
        FOREIGN KEY (ClientID) REFERENCES CLIENT (ClientID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_loan_item
        FOREIGN KEY (ItemID) REFERENCES ITEM (ItemID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT check_loan_dates
        CHECK (DueDate >= CheckoutDate AND (ReturnDate IS NULL OR ReturnDate >= CheckoutDate)),
    CONSTRAINT check_loan_fine CHECK (FineAmount >= 0)
);
 
-- RESERVATION (relational entity; CLIENT reserves ITEM)
CREATE TABLE RESERVATION (
    ReservationID INT NOT NULL AUTO_INCREMENT,
    ClientID INT NOT NULL,
    ItemID INT NOT NULL,
    ReservationDate DATE NOT NULL,
    ReservationStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',

    PRIMARY KEY (ReservationID),
    CONSTRAINT fk_reservation_client
        FOREIGN KEY (ClientID) REFERENCES CLIENT (ClientID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_reservation_item
        FOREIGN KEY (ItemID) REFERENCES ITEM (ItemID)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT check_reservation_status
        CHECK (ReservationStatus IN ('Pending', 'Ready', 'Expired', 'Fulfilled'))
);
 