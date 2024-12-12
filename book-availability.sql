DECLARE
    v_book_id          Books.id%TYPE;
    v_title            Books.title%TYPE;
    v_author           Books.author%TYPE;
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
        FROM Books b
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
