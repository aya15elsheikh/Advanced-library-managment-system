-- 1 Over due Notifications
CREATE OR REPLACE PROCEDURE OverdueNotifications
IS
    overdue_days INT;
    notification_date DATE := SYSDATE;

BEGIN
    INSERT INTO NotificationLogs (student_id, book_id, overdue_days, notification_date)
    SELECT 
        br.student_id,
        br.book_id,
        TRUNC(SYSDATE - br.return_date) AS overdue_days,
        notification_date
    FROM BorrowingRecords br
    INNER JOIN user_1.Books b ON br.book_id = b.id
    WHERE 
        br.return_date IS NOT NULL 
        AND TRUNC(SYSDATE - br.return_date) > 7 
        AND br.status = 1; -- Assuming status TRUE is represented as 1

    COMMIT; -- Add a commit if this is not part of a larger transaction
END OverdueNotifications;


-- 2 late fee dynamic calculation  

CREATE OR REPLACE FUNCTION calculate_late_fee(borrow_record_id IN INT)
RETURN NUMBER IS
    v_book_id           INT;
    v_student_id        INT;
    v_borrow_date       DATE;
    v_return_date       DATE;
    v_overdue_days      INT;
    v_fee_rate          NUMBER;
    v_fee_amount        NUMBER := 0; -- Initialize fee amount to 0
BEGIN
    -- Fetching the borrowing record details
    SELECT book_id, student_id, borrow_date, return_date
    INTO v_book_id, v_student_id, v_borrow_date, v_return_date
    FROM BorrowingRecords
    WHERE id = borrow_record_id;

    -- Calculating overdue days
    IF v_return_date < SYSDATE THEN
        v_overdue_days := TRUNC(SYSDATE) - TRUNC(v_return_date);
    ELSE
        v_overdue_days := 0;
    END IF;

    -- Only calculate fee if overdue days are greater than 5
    IF v_overdue_days > 5 THEN
        -- Fetching the book type fee rate
        SELECT fee_rate
        INTO v_fee_rate
        FROM user_1.BookTypes
        WHERE id = (SELECT type_id FROM user_1.Books WHERE id = v_book_id);
        
        -- Calculate the fee amount
        v_fee_amount := v_overdue_days * v_fee_rate;

        -- Insert penalty into Penalties table
        INSERT INTO Penalties (student_id, amount, reason, borrowing_id)
        VALUES (v_student_id, v_fee_amount, 'Late return', borrow_record_id);
    END IF;

    RETURN v_fee_amount; -- Return the calculated fee amount
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Return 0 if no data is found
    WHEN OTHERS THEN
        RAISE; -- Re-raise other exceptions
END;


DECLARE
    late_fee NUMBER;
BEGIN
    late_fee := calculate_late_fee(2011); 
    DBMS_OUTPUT.PUT_LINE('Late Fee for Borrow Record ID 2008: ' || late_fee);
END;



--3 borrowing validation 
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


--4 
CREATE OR REPLACE TRIGGER Update_Or_Delete_BorrowingRecord
BEFORE DELETE OR UPDATE ON BorrowingRecords
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        INSERT INTO AuditTrail (table_name, operation, old_data, new_data, time_stamp)
        VALUES (
            'BorrowingRecords',
            'UPDATE',         
            'book_id=' || :OLD.book_id || ', student_id=' || :OLD.student_id || 
            ', borrow_date=' || :OLD.borrow_date || ', return_date=' || :OLD.return_date || 
            ', status=' || :OLD.status,  
            'book_id=' || :NEW.book_id || ', student_id=' || :NEW.student_id || 
            ', borrow_date=' || :NEW.borrow_date || ', return_date=' || :NEW.return_date || 
            ', status=' || :NEW.status,  
            CURRENT_TIMESTAMP     -- Timestamp of the operation
         );
        END IF;

    IF DELETING THEN
        INSERT INTO AuditTrail (table_name, operation, old_data, new_data, time_stamp)
        VALUES (
            'BorrowingRecords', 
            'DELETE',           
            'book_id=' || :OLD.book_id || ', student_id=' || :OLD.student_id || 
            ', borrow_date=' || :OLD.borrow_date || ', return_date=' || :OLD.return_date || 
            ', status=' || :OLD.status,  
            NULL, 
            CURRENT_TIMESTAMP     -- Timestamp of the operation
          );
         END IF;
END;


-- SELECT SID, USERNAME, STATUS
-- FROM V$SESSION
-- ORDER BY USERNAME;
--task 10 test

-- 5 Borrowing history 
DECLARE
  
    CURSOR Borrow_History (Bstudent_id IN NUMBER) IS  
        SELECT BR.book_id, 
               b.title AS book_title,
               BR.borrow_date,
               BR.return_date, 
               CASE 
                   WHEN BR.return_date < SYSDATE THEN 'Over Due'
                   ELSE 'On Time'
               END AS status,
               NVL(p.amount, 0) AS penalty_amount,
               NVL(p.reason, 'No penalty') AS penalty_reason 
          FROM BorrowingRecords BR 
          JOIN user_1.Books b ON BR.book_id = b.id
          JOIN Penalties p ON BR.student_id = p.student_id
          WHERE BR.student_id = Bstudent_id;  


    VBook_id BorrowingRecords.book_id%TYPE;
    VBook_title user_1.Books.title%TYPE;
    Vborrow_date BorrowingRecords.borrow_date%TYPE;
    Vreturn_date BorrowingRecords.return_date%TYPE;
    Vstatus VARCHAR2(20);
    Vpenalty_amount NUMBER;
    Vpenalty_reason VARCHAR2(200);

    student_id_input NUMBER := 2;  

BEGIN
    OPEN Borrow_History(student_id_input);

    LOOP 
        FETCH Borrow_History INTO VBook_id, VBook_title, Vborrow_date,
                                   Vreturn_date, Vstatus, Vpenalty_amount, Vpenalty_reason;
        EXIT WHEN Borrow_History%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            RPAD('Book ID: ', 20) || RPAD(VBook_id, 10) ||
            RPAD(', Book Title: ', 20) || RPAD(VBook_title, 30) ||
            RPAD(', Borrow Date: ', 20) || RPAD(Vborrow_date, 15) ||
            RPAD(', Return Date: ', 20) || RPAD(Vreturn_date, 15) ||
            RPAD(', Status: ', 20) || RPAD(Vstatus, 10) ||
            RPAD(', Penalty Amount: ', 20) || RPAD(Vpenalty_amount, 10) ||
            RPAD(', Penalty Reason: ', 20) || Vpenalty_reason  
        );

    END LOOP;

    CLOSE Borrow_History;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        IF Borrow_History%ISOPEN THEN
            CLOSE Borrow_History;
        END IF;
END;



-- 6 Safe Return Process with Transactions

DECLARE
    overdue_penalty NUMBER;
    student_id NUMBER := 2; -- Replace with the desired student ID
BEGIN
    -- Start a loop to fetch overdue books for the given student
    FOR rec IN (SELECT book_id
                FROM BorrowingRecords
                WHERE student_id = student_id AND status = FALSE) LOOP

        BEGIN
            -- Calculate penalty dynamically for overdue books
            overdue_penalty := calculate_late_fee(rec.book_id);

            -- Update penalty in Penalties table
            IF overdue_penalty > 0 THEN
                INSERT INTO Penalties (student_id, amount, reason)
                VALUES (student_id, overdue_penalty, 'Late Return');
            END IF;

            -- Mark the book as returned
            UPDATE BorrowingRecords
            SET status = TRUE, return_date = SYSDATE
            WHERE book_id = rec.book_id;

        EXCEPTION
            WHEN OTHERS THEN
                -- Log the error and rollback the transaction
                DBMS_OUTPUT.PUT_LINE('Error while processing return for book ID: ' || rec.book_id);
                ROLLBACK;
                RETURN; -- Exit the block to prevent further processing
        END;

    END LOOP;

    -- Commit the transaction if everything completes successfully
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Books returned successfully for student ID: ' || student_id);

EXCEPTION
    WHEN OTHERS THEN
        -- Handle any unexpected errors and rollback changes
        DBMS_OUTPUT.PUT_LINE('An error occurred. Rolling back all changes.');
        ROLLBACK;
END;


-- 7 book availabity report 
DECLARE
    v_book_id          user_1.Books.id%TYPE;
    v_title            user_1.Books.title%TYPE;
    v_author           user_1.Books.author%TYPE;
    v_availability     VARCHAR2(20);
    v_student_name     Students.name%TYPE;
    v_overdue_days     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Books Availability Report');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Book ID | Title                     | Author               | Status    | Student Name        | Overdue Days');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');

    FOR rec IN (
        SELECT b.id AS book_id,
               b.title,
               b.author,
               CASE 
                   WHEN BR.return_date IS NULL THEN 'Borrowed'
                   WHEN BR.return_date < SYSDATE THEN 'Overdue'
                   ELSE 'Available'
               END AS availability_status,
               s.name AS student_name,
               CASE 
                   WHEN BR.return_date < SYSDATE THEN TRUNC(SYSDATE) - TRUNC(BR.return_date)
                   ELSE 0
               END AS overdue_days
        FROM user_1.Books b
        LEFT JOIN BorrowingRecords BR ON b.id = BR.book_id
        LEFT JOIN Students s ON BR.student_id = s.id
    ) LOOP
        v_book_id := rec.book_id;
        v_title := rec.title;
        v_author := rec.author;
        v_availability := rec.availability_status;
        v_student_name := NVL(rec.student_name, 'N/A');  -- use 'N/A' if no student
        v_overdue_days := rec.overdue_days;

        DBMS_OUTPUT.PUT_LINE(RPAD(v_book_id, 8) || ' | ' ||
                             RPAD(v_title, 25) || ' | ' ||
                             RPAD(v_author, 20) || ' | ' ||
                             RPAD(v_availability, 10) || ' | ' ||
                             RPAD(v_student_name, 20) || ' | ' ||
                             v_overdue_days);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('End ');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ');
END;

--8 Automated Suspension
-- Procedure to suspend students based on penalty threshold

CREATE OR REPLACE PROCEDURE suspend_students(p_penalty_threshold IN NUMBER) IS
BEGIN
    FOR rec IN (
        SELECT student_id, SUM(amount) AS total_penalty
        FROM Penalties
        GROUP BY student_id
        HAVING SUM(amount) > p_penalty_threshold
    ) LOOP
        UPDATE Students
        SET membership_status = FALSE -- suspended
        WHERE id = rec.student_id;

        DBMS_OUTPUT.PUT_LINE('Student ID ' || rec.student_id || ' suspended due to penalties exceeding $' || p_penalty_threshold);
    END LOOP;
END suspend_students;
/

-- Anonymous PL/SQL block to call the procedure
BEGIN
    suspend_students(50); -- Pass the penalty threshold as an argument
END;


--12 deadlock 
--user1
set serveroutput on;
BEGIN
    UPDATE Books SET available = 'FALSE' WHERE id = 1001;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in User 1 Transaction 1: ' || SQLERRM);
        ROLLBACK;
END; 

set serveroutput on;
BEGIN
   UPDATE MANAGER_USER.BorrowingRecords SET status = 'TRUE' WHERE book_id = 1001;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in User 1 Transaction 1: ' || SQLERRM);
        ROLLBACK;
END; 


alter session set "_oracle_script"=true;
 
create user manager_user identified by 123;

GRANT ALL PRIVILEGES to manager_user;





commit;

select * from BORROWINGRECORDS ;
SELECT * from PENALTIES;
SELECT * from  BOOKS;

SELECT * from students ;

SELECT * FROM user_objects WHERE object_type = 'FUNCTION' AND object_name = 'CALCULATE_LATE_FEE';
