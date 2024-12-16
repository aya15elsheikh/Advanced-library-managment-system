
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Standard', 0.50);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Premium', 1.00);

INSERT INTO Students (name, membership_status) VALUES ('Alice Johnson', TRUE);
INSERT INTO Students (name, membership_status) VALUES ('Bob Smith', TRUE);
INSERT INTO Students (name, membership_status) VALUES ('Charlie Brown', TRUE);

INSERT INTO AuditTrail (table_name, operation, old_data, new_data, time_stamp) 
VALUES ('Books', 'INSERT', NULL, 'Inserted The Great Gatsby', SYSTIMESTAMP);

INSERT INTO AuditTrail (table_name,  operation, old_data, new_data, time_stamp) 
VALUES ('Students', 'INSERT', NULL, 'Inserted Alice Johnson', SYSTIMESTAMP);


INSERT INTO Books (title, author, available, type_id) VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', TRUE, 6001);
INSERT INTO Books (title, author, available, type_id) VALUES ('1984', 'George Orwell', TRUE, 6002);
INSERT INTO Books (title, author, available, type_id) VALUES ('To Kill a Mockingbird', 'Harper Lee', TRUE, 6001);
INSERT INTO Books (title, author, available, type_id) VALUES ('The Catcher in the Rye', 'J.D. Salinger', TRUE, 6001);
INSERT INTO Books (title, author, available, type_id) VALUES ('Brave New World', 'Aldous Huxley', TRUE, 6002);



INSERT INTO Penalties (student_id, amount, reason,borrowing_id) VALUES (1, 5.00, 'Late fee for overdue book',2001);
INSERT INTO Penalties (student_id, amount, reason,borrowing_id) VALUES (2, 2.00, 'Late fee for overdue book',2002);

INSERT INTO NotificationLogs (student_id, book_id, overdue_days, notification_date) 
VALUES (1, 1001,  1,TO_DATE('2024-11-16', 'YYYY-MM-DD'));

INSERT INTO NotificationLogs (student_id, book_id, overdue_days, notification_date) 
VALUES (2, 1002, 2, TO_DATE('2024-11-23', 'YYYY-MM-DD'));

commit;



INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Fiction', 1.50);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Non-Fiction', 2.00);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Reference', 3.00);


INSERT INTO Books (title, author, available, type_id) VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', TRUE, 6001);
INSERT INTO Books (title, author, available, type_id) VALUES ('A Brief History of Time', 'Stephen Hawking', TRUE, 6002);
INSERT INTO Books (title, author, available, type_id) VALUES ('Introduction to Algorithms', 'Thomas H. Cormen', TRUE, 6003);


INSERT INTO Students (name, membership_status) VALUES ('Aya Elsheikh', TRUE);
INSERT INTO Students (name, membership_status) VALUES ('Judy', TRUE);


-- Assuming today's date is '2024-12-15'
-- This record is overdue as the return date is 2024-12-01
INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status) 
VALUES (1001, 1, DATE '2024-11-15', DATE '2024-12-01', TRUE);

-- This record is not overdue
INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status) 
VALUES (1002, 2, DATE '2024-12-10', DATE '2024-12-20', TRUE);

-- This record is overdue as the return date is 2024-12-05
INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status) 
VALUES (1003, 1, DATE '2024-11-20', DATE '2024-12-05', TRUE);

commit;