
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Standard', 0.50);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Premium', 1.00);

INSERT INTO Students (name, membership_status) VALUES ('Alice Johnson', TRUE);
INSERT INTO Students (name, membership_status) VALUES ('Bob Smith', TRUE);
INSERT INTO Students (name, membership_status) VALUES ('Charlie Brown', TRUE);

INSERT INTO AuditTrail (table_name, operation, old_data, new_data, time_stamp) 
VALUES ('Books', 'INSERT', NULL, 'Inserted The Great Gatsby', SYSTIMESTAMP);

INSERT INTO AuditTrail (table_name, operation, old_data, new_data, time_stamp) 
VALUES ('Students', 'INSERT', NULL, 'Inserted Alice Johnson', SYSTIMESTAMP);


INSERT INTO Books (title, author, available, type_id) VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', TRUE, 6001);
INSERT INTO Books (title, author, available, type_id) VALUES ('1984', 'George Orwell', TRUE, 6002);
INSERT INTO Books (title, author, available, type_id) VALUES ('To Kill a Mockingbird', 'Harper Lee', TRUE, 6001);
INSERT INTO Books (title, author, available, type_id) VALUES ('The Catcher in the Rye', 'J.D. Salinger', TRUE, 6001);
INSERT INTO Books (title, author, available, type_id) VALUES ('Brave New World', 'Aldous Huxley', TRUE, 6002);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status) 
VALUES (1021, 1, TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-11-15', 'YYYY-MM-DD'), TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status) 
VALUES (1022, 2, TO_DATE('2024-11-05', 'YYYY-MM-DD'), TO_DATE('2024-11-20', 'YYYY-MM-DD'), TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status) 
VALUES (1023, 1, TO_DATE('2024-11-10', 'YYYY-MM-DD'), TO_DATE('2024-11-25', 'YYYY-MM-DD'), TRUE);

INSERT INTO Penalties (student_id, amount, reason) VALUES (1, 5.00, 'Late fee for overdue book');
INSERT INTO Penalties (student_id, amount, reason) VALUES (2, 2.00, 'Late fee for overdue book');

INSERT INTO NotificationLogs (student_id, book_id, overdue_days, notification_date) 
VALUES (1, 1021, 5, TO_DATE('2024-11-16', 'YYYY-MM-DD'));

INSERT INTO NotificationLogs (student_id, book_id, overdue_days, notification_date) 
VALUES (2, 1022, 3, TO_DATE('2024-11-23', 'YYYY-MM-DD'));


