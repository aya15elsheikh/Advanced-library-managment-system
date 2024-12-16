CREATE TABLE BookTypes(
id int GENERATED ALWAYS as IDENTITY(START with 6001 INCREMENT by 1) PRIMARY KEY,
type_name varchar2(50),
fee_rate number(5,2)
)
CREATE TABLE Books (
id int GENERATED ALWAYS as IDENTITY(START with 1001 INCREMENT by 1) PRIMARY KEY ,
title varchar2(100) NOT NULL,
author varchar2(50) NOT NULL,
available boolean DEFAULT(TRUE) CHECK (available IN (TRUE, FALSE)),
type_id int ,
FOREIGN KEY (type_id) REFERENCES BookTypes(id)
)


GRANT REFERENCES (id) ON user_1.BookTypes  TO system;
GRANT REFERENCES (id) ON user_1.Books  TO system;
GRANT INSERT , DELETE , UPDATE , SELECT ON Books  TO system;
GRANT INSERT , DELETE , UPDATE , SELECT ON BookTypes  TO system;
GRANT SELECT, UPDATE, INSERT, DELETE ON Books TO user_2;
GRANT INSERT ON user_1.BookTypes to user_2;
GRANT INSERT ON user_1.Books to user_2;

--user 1  task 10,11
update SYS.BorrowingRecords set status= True where id=2001;

commit;

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
   UPDATE sys.BorrowingRecords SET status = 'TRUE' WHERE book_id = 1001;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in User 1 Transaction 1: ' || SQLERRM);
        ROLLBACK;
END; 




