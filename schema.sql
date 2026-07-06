-- Drop database if it exists
DROP DATABASE IF EXISTS library_management;
CREATE DATABASE library_management;
USE library_management;

-- 1. Create Tables

-- Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    PublishedYear INT CHECK (PublishedYear >= 1000 AND PublishedYear <= 2100), -- Domain Constraint
    AvailableCopies INT CHECK (AvailableCopies >= 0), -- Semantic/Domain Constraint
    TotalCopies INT CHECK (TotalCopies >= 0),
    CONSTRAINT chk_copies CHECK (AvailableCopies <= TotalCopies) -- Semantic Constraint
);

-- Members Table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL, -- Key Constraint
    Phone VARCHAR(20),
    JoinDate DATE DEFAULT (CURRENT_DATE)
);

-- BorrowRecords Table
CREATE TABLE BorrowRecords (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    BorrowDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    PenaltyFee DECIMAL(10,2) DEFAULT 0.00,
    Status ENUM('Borrowed', 'Returned', 'Overdue') DEFAULT 'Borrowed', -- Domain Constraint
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE, -- Referential Integrity
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE, -- Referential Integrity
    CONSTRAINT chk_dates CHECK (ReturnDate IS NULL OR ReturnDate >= BorrowDate) -- Semantic Constraint
);

-- 2. Insert Sample Data

-- Books
INSERT INTO Books (Title, Author, Category, PublishedYear, AvailableCopies, TotalCopies) VALUES
('The Lord of the Rings', 'J.R.R. Tolkien', 'Fantasy', 1954, 5, 5),
('1984', 'George Orwell', 'Dystopian', 1949, 2, 3),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 4, 4),
('Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 1, 2),
('The Hitchhiker''s Guide to the Galaxy', 'Douglas Adams', 'Science Fiction', 1979, 6, 6);

-- Members
INSERT INTO Members (Name, Email, Phone, JoinDate) VALUES
('Alice Smith', 'alice.smith@example.com', '555-0101', '2023-01-15'),
('Bob Johnson', 'bob.johnson@example.com', '555-0102', '2023-05-20'),
('Charlie Brown', 'charlie.brown@example.com', '555-0103', '2024-02-10');

-- BorrowRecords (Example of tracking a borrowed/returned book)
INSERT INTO BorrowRecords (BookID, MemberID, BorrowDate, DueDate, ReturnDate, Status) VALUES
(2, 1, '2024-02-01', '2024-02-15', NULL, 'Borrowed'), -- Alice borrowed '1984'
(4, 2, '2024-01-10', '2024-01-24', '2024-01-20', 'Returned'); -- Bob borrowed and returned 'Pride and Prejudice'
select * from members

