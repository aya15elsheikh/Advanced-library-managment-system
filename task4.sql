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


UPDATE BorrowingRecords
SET return_date = TO_DATE('2024-12-20', 'YYYY-MM-DD')
WHERE id = 2001;

DELETE BorrowingRecords 
WHERE id = 2001;

select * from AuditTrail;