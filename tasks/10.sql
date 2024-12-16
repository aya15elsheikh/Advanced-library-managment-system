--user 1
update SYS.BorrowingRecords set status= True where id=2001;
update SYS.BorrowingRecords set status= FALSE where id=2001;
--user 2
--create student_id_var and will assign its value from select statement 
VARIABLE student_id_var NUMBER;  
--try to fetch student_id with specific id
BEGIN  
    SELECT student_id  
    INTO :student_id_var  
    FROM sys.BorrowingRecords  
    WHERE id = 2001  -- Reference the same borrowing record locked by User 1  
    FOR UPDATE;  --'for update' try to lock the row
END;  
/  

-- Insert a penalty with the same user1's id
INSERT INTO sys.Penalties (id, student_id, amount, reason, borrowing_id)  
VALUES (3, :student_id_var, 50.00, 'Late return', 2001);  