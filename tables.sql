CREATE TABLE Books (
id int GENERATED ALWAYS as IDENTITY(START with 1001 INCREMENT by 1) PRIMARY KEY ,
title varchar2(100) NOT NULL,
author varchar2(50) NOT NULL,
available boolean DEFAULT(TRUE) CHECK (available IN (TRUE, FALSE)),
type_id int ,
FOREIGN KEY (type_id) REFERENCES BookTypes(id)
)

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
FOREIGN KEY (book_id) REFERENCES Books(id),
FOREIGN KEY (student_id) REFERENCES Students(id),
CHECK (borrow_date <= return_date)
)

CREATE TABLE Penalties(
id int GENERATED ALWAYS as IDENTITY(START with 3001 INCREMENT by 1) PRIMARY KEY  ,
student_id int,
amount number CHECK (amount > 0) NOT NULL,
reason varchar2(200),
FOREIGN KEY (student_id) REFERENCES Students(id)
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
FOREIGN KEY (book_id) REFERENCES Books(id),
FOREIGN KEY (student_id) REFERENCES Students(id)
)

CREATE TABLE BookTypes(
id int GENERATED ALWAYS as IDENTITY(START with 6001 INCREMENT by 1) PRIMARY KEY,
type_name varchar2(50),
fee_rate number(5,2)
)