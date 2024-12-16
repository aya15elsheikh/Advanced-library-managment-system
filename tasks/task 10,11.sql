--user 1
update SYS.BorrowingRecords set status= True where id=2001;

--user 2
--create student_id_var and will assign its value from select statement 
VARIABLE student_id_var NUMBER;  
--try to fetch student_id with specific id
BEGIN  
    SELECT student_id  
    INTO :student_id_var  
    FROM sys.BorrowingRecords  
    WHERE id = 2001  -- Reference the borrowing record locked by User 1  
    FOR UPDATE;  --'for update' try to lock the row
END;  
/ 

-- Insert a penalty with the same user1 id
INSERT INTO sys.Penalties (id, student_id, amount, reason, borrowing_id)  
VALUES (3, :student_id_var, 50.00, 'Late return', 2001);  

-- Commit the transaction  
COMMIT;

select w.sid "Wating Session", W.serial# "Wating Serial Id",
w.blocking_session "Blocker session id",
W.seconds_in_wait "Wating Session Period",
V.sql_fulltext "wating session sql statment "from v$session w join v$sql v on w.sql_id=v.sql_id and w.blocking_session is not null;


--to solve the blocking situation
--commit; or rollback;
--ALTER SYSTEM KILL SESSION ' b.sid,b.serial';



GRANT SELECT, UPDATE ON BorrowingRecords TO user_1,user_2;
GRANT SELECT, UPDATE, INSERT ON Penalties TO user_1,user_2;