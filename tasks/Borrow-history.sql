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
          JOIN Books b ON BR.book_id = b.id
          LEFT JOIN Penalties p ON BR.student_id = p.student_id
         WHERE BR.student_id = Bstudent_id;  

    VBook_id BorrowingRecords.book_id%TYPE;
    VBook_title Books.title%TYPE;
    Vborrow_date BorrowingRecords.borrow_date%TYPE;
    Vreturn_date BorrowingRecords.return_date%TYPE;
    Vstatus VARCHAR2(20);
    Vpenalty_amount NUMBER;
    Vpenalty_reason VARCHAR2(200);

    student_id_input NUMBER := 1;

BEGIN
    OPEN Borrow_History(student_id_input);

    LOOP 
        FETCH Borrow_History INTO VBook_id, VBook_title, Vborrow_date,
                                   Vreturn_date, Vstatus, Vpenalty_amount, Vpenalty_reason;
        EXIT WHEN Borrow_History%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Book ID: ' || VBook_id ||
                             ', Book Title: ' || VBook_title ||
                             ', Borrow Date: ' || Vborrow_date ||
                             ', Return Date: ' || Vreturn_date ||
                             ', Status: ' || Vstatus ||
                             ', Penalty Amount: ' || Vpenalty_amount ||
                             ', Penalty Reason: ' || Vpenalty_reason);
    END LOOP;

    CLOSE Borrow_History;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        IF Borrow_History%ISOPEN THEN
            CLOSE Borrow_History;
        END IF;
END;
