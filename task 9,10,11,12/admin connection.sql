CREATE TABLE Students(
id int GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) PRIMARY KEY ,
name varchar2(50) NOT NULL,
membership_status boolean DEFAULT(TRUE) CHECK (membership_status IN (TRUE, FALSE))
)

CREATE TABLE BorrowingRecords(
id int GENERATED ALWAYS as IDENTITY(START with 2001 INCREMENT by 1) PRIMARY KEY  ,
book_id int,
student_id int,
borrow_date date,
return_date date,
status boolean DEFAULT(TRUE) CHECK (status IN (TRUE, FALSE)),
FOREIGN KEY (book_id) REFERENCES user_1.Books(id),
FOREIGN KEY (student_id) REFERENCES Students(id),
CHECK (borrow_date <= return_date)
)

GRANT REFERENCES (id)ON user_1.books TO manager_user;
GRANT SELECT ON user_1.books TO manager_user; -- Optional


CREATE TABLE Penalties(
id int GENERATED ALWAYS as IDENTITY(START with 3001 INCREMENT by 1) PRIMARY KEY  ,
student_id int,
borrowing_id int ,
amount number CHECK (amount > 0) NOT NULL,
reason varchar2(200),
FOREIGN KEY (student_id) REFERENCES Students(id),
FOREIGN KEY (borrowing_id) REFERENCES BorrowingRecords(id)
)

CREATE TABLE AuditTrail(
id int GENERATED ALWAYS as IDENTITY(START with 4001 INCREMENT by 1) PRIMARY KEY  ,
table_name varchar2(50) NOT NULL,
operation varchar2(20) CHECK(operation in('INSERT','UPDATE','DELETE')) ,
old_data varchar2(100),
new_data varchar2(100),
time_stamp timestamp
)

CREATE TABLE NotificationLogs(
id int GENERATED ALWAYS as IDENTITY(START with 5001 INCREMENT by 1) PRIMARY KEY ,
student_id int,
book_id int,
overdue_days int CHECK (overdue_days > 0),
notification_date date,
FOREIGN KEY (book_id) REFERENCES user_1.Books(id),
FOREIGN KEY (student_id) REFERENCES Students(id)
)

alter session set "_oracle_script"=true;
 
create user manager_user identified by 123;

GRANT ALL PRIVILEGES to manager_user;
GRANT SELECT, UPDATE, INSERT, DELETE ON BorrowingRecords TO user_1;
GRANT SELECT, UPDATE, INSERT, DELETE ON BorrowingRecords TO user_2;

GRANT SELECT, UPDATE, INSERT, DELETE ON user_1.Books TO manager_user;


drop table NotificationLogs;
drop table Penalties;
drop table BorrowingRecords;
drop table Books;
drop table AuditTrail;
drop table Students;
drop table BookTypes;
------------------------

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

SELECT SID, USERNAME, STATUS
FROM V$SESSION
ORDER BY USERNAME;

--to solve the blocking situation
--commit; or rollback;
--ALTER SYSTEM KILL SESSION ' b.sid,b.serial';
--ALTER SYSTEM KILL SESSION 'sid,serial#';

GRANT SELECT, UPDATE ON manager_user.BorrowingRecords TO user_1,user_2;
GRANT SELECT, UPDATE, INSERT ON manager_user.Penalties TO user_1,user_2;

GRANT ALL PRIVILEGES ON sys.BorrowingRecords TO manager_user;

GRANT SELECT, INSERT, UPDATE, DELETE  ON sys.BorrowingRecords TO manager_user;
GRANT CREATE TRIGGER  TO manager_user;
Grant ALl Privileges to manager_user;

SELECT * from user_1.books;





GRANT CREATE SESSION TO manager_user;
GRANT EXECUTE ON BorrowingRecords TO manager_user; -- Replace with actual package name
GRANT SELECT ON sys.Students TO manager_user; -- Example for another table
GRANT ALTER ON sys.BorrowingRecords TO manager_user; -- Optional
