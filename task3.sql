CREATE OR REPLACE TRIGGER Borrowing_validation
BEFORE INSERT ON BorrowingRecords
FOR EACH ROW
DECLARE 
overdue_count int ;
borrowd_count int ;

BEGIN 
 SELECT COUNT(*) INTO overdue_count FROM BorrowingRecords
    WHERE student_id = :NEW.student_id
    AND return_date IS NULL 
    AND borrow_date < SYSDATE ;
    
    IF  overdue_count >0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Student has overdue books and cannot borrow more');
    END IF;
   
   SELECT COUNT(*) INTO  borrowd_count FROM BorrowingRecords
    WHERE student_id = :NEW.student_id
    AND return_date IS NULL;

    IF  borrowd_count >= 3 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Student has already borrowed the maximum number of books');
    END IF;

END;

INSERT INTO Students ( name , membership_status) VALUES ( 'Shahd Doe' ,TRUE);
INSERT INTO Students ( name , membership_status) VALUES ( 'Aya Smith' , TRUE);

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

 


INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Regular', 1.50);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Reference', 1.40);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Reference', 1.50);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Reference', 1.90);
INSERT INTO BookTypes (type_name, fee_rate) VALUES ('Regular', 1.90);


INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1001, 1, DATE '2023-12-01', NULL, TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1002, 1, DATE '2023-12-01', NULL, TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1003, 1,DATE '2023-12-01', NULL, TRUE);

INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES (1004, 1,DATE '2023-12-01', NULL, TRUE);


INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES ( 1005, 2 ,DATE '2023-12-01', NULL, TRUE);
INSERT INTO BorrowingRecords (book_id, student_id, borrow_date, return_date, status)
VALUES ( 1002, 2 ,DATE '2023-12-01', NULL, TRUE);