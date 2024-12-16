alter session set "_oracle_script"=true;
 
create user manager_user identified by 123;

GRANT ALL PRIVILEGES to manager_user;
GRANT SELECT, UPDATE, INSERT, DELETE ON BorrowingRecords TO user_1;
GRANT SELECT, UPDATE, INSERT, DELETE ON BorrowingRecords TO user_2;


--task10,11

select w.sid "Wating Session", W.serial# "Wating Serial Id",
w.blocking_session "Blocker session id",
W.seconds_in_wait "Wating Session Period",
V.sql_fulltext "wating session sql statment "from v$session w join v$sql v on w.sql_id=v.sql_id and w.blocking_session is not null;


--to solve the blocking situation
--commit; or rollback;
--ALTER SYSTEM KILL SESSION ' b.sid,b.serial';
--ALTER SYSTEM KILL SESSION 'sid,serial#';

GRANT SELECT, UPDATE ON BorrowingRecords TO user_1,user_2;
GRANT SELECT, UPDATE, INSERT ON Penalties TO user_1,user_2;

GRANT ALL PRIVILEGES ON sys.BorrowingRecords TO manager_user;

GRANT SELECT, INSERT, UPDATE, DELETE  ON sys.BorrowingRecords TO manager_user;
GRANT CREATE TRIGGER  TO manager_user;
Grant ALl Privileges to manager_user;

SELECT * from user_1.books;

GRANT CREATE SESSION TO manager_user;
GRANT EXECUTE ON BorrowingRecords TO manager_user; -- Replace with actual package name
GRANT SELECT ON sys.Students TO manager_user; -- Example for another table
GRANT ALTER ON sys.BorrowingRecords TO manager_user; -- Optional

