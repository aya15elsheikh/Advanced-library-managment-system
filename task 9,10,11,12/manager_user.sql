alter session set "_oracle_script"=true;
create user user_1 identified by 123;
create user user_2 identified by 123;

grant create any table , create session to user_1;
grant ALL PRIVILEGES to user_1;

grant insert any table , create session to user_2;

