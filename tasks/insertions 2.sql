--manager
INSERT INTO Students ( name , membership_status) VALUES ( 'Shahd Doe' ,TRUE);
INSERT INTO Students ( name , membership_status) VALUES ( 'Aya Smith' , TRUE);
--user1
INSERT INTO Books (title, author, available, type_id) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', TRUE, 6001);
 INSERT INTO Books (title, author, available, type_id) VALUES
('To Kill a Mockingbird', 'Harper Lee', TRUE, 6002);
INSERT INTO Books (title, author, available, type_id) VALUES
('1984', 'George Orwell', TRUE , 6003);
INSERT INTO Books (title, author, available, type_id) VALUES
('The Catcher in the Rye', 'J.D. Salinger', TRUE, 6004);
INSERT INTO Books (title, author, available, type_id) VALUES
('Moby Dick', 'Herman Melville', FALSE, 6005);

 

--user 1
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Regular', 1.50);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Reference', 1.40);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Reference', 1.50);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Reference', 1.90);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Regular', 1.90);

--manager
INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1001, 1, DATE '2023-12-01', NULL, TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1002, 1, DATE '2023-12-01', NULL, TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1003, 1,DATE '2023-12-01', SYSDATE, TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1004, 1,DATE '2023-12-01', NULL, TRUE);


-- INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
-- VALUES ( 1005, 2 ,DATE '2023-12-01', NULL, TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES ( 1002, 2 ,DATE '2023-12-01', NULL, TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES ( 1002, 2 ,DATE '2023-12-01', NULL, TRUE);

INSERT INTO Penalties (student_id, amount, reason,borrowing_id) VALUES (1, 5.00, 'Late fee for overdue book',2001);
INSERT INTO Penalties (student_id, amount, reason,borrowing_id) VALUES (2, 2.00, 'Late fee for overdue book',2002);

INSERT INTO NotificationLogs (student_id, book_id, overdue_days, notification_date) 
VALUES (1, 1001,  1,TO_DATE('2024-11-16', 'YYYY-MM-DD'));

INSERT INTO NotificationLogs (student_id, book_id, overdue_days, notification_date) 
VALUES (2, 1002, 2, TO_DATE('2024-11-23', 'YYYY-MM-DD'));

commit;



-- test task 3 

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1001, 1, DATE '2024-12-14', NULL, TRUE);


INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1002, 1, DATE '2024-12-14', NULL, TRUE);
