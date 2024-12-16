INSERT INTO user_1.BookTypes (type_name,fee_rate) VALUES ('Regular','1.50');
INSERT INTO user_1.BookTypes (type_name,fee_rate) VALUES ('Regular','1.90');
INSERT INTO user_1.BookTypes (type_name,fee_rate) VALUES ('Reference','1.60');
INSERT INTO user_1.BookTypes (type_name,fee_rate) VALUES ('Regular','1.50');
INSERT INTO user_1.BookTypes (type_name,fee_rate) VALUES ('Reference','1.70');


INSERT INTO user_1.Books (title, author, available, type_id)
VALUES ('The Great Gatsby', 'F. Scott Fitzgerald',TRUE, 6001);

COMMIT;


--user 2 task 10,11
--create student_id_var and will assign its value from select statement 
VARIABLE student_id_var NUMBER;  
--try to fetch student_id with sid
BEGIN  
    SELECT student_id  
    INTO :student_id_var  
    FROM MANAGER_USER.BorrowingRecords  
    WHERE id = 2001  -- Reference the borrowing record locked by User 1  
    FOR UPDATE;  --'for update' try to lock the row
END;  



-- Insert a penalty with the same user1 id
INSERT INTO MANAGER_USER.Penalties ( student_id, amount, reason, borrowing_id)  
VALUES (:student_id_var, 50.00, 'Late return', 2001);  

-- Commit the transaction  
COMMIT;


set serveroutput on;
BEGIN
   UPDATE MANAGER_USER.BorrowingRecords SET status = 'TRUE' WHERE book_id = 1001;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in User 1 Transaction 1: ' || SQLERRM);
        ROLLBACK;
END; 

set serveroutput on;
BEGIN
    UPDATE user_1.Books SET available = 'FALSE' WHERE id = 1001;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in User 1 Transaction 1: ' || SQLERRM);
        ROLLBACK;
END; 

