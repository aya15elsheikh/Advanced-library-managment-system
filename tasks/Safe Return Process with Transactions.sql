CREATE OR REPLACE PROCEDURE ProcessLateReturns(student_id_in NUMBER)
AS
    overdue_penalty NUMBER;
BEGIN
    -- Cursor to fetch book IDs for the student with overdue books
    FOR rec IN (SELECT book_id 
                FROM BorrowingRecords 
                WHERE student_id = student_id_in AND status = 'BORROWED') LOOP

        BEGIN
            -- Calculate penalty dynamically for overdue books
            overdue_penalty := calculate_late_feee(rec.book_id);

            -- Update penalty in Penalties table
            IF overdue_penalty > 0 THEN
                INSERT INTO Penalties (student_id, amount, reason)
                VALUES (student_id_in, overdue_penalty, 'Late Return');
            END IF;

            -- Mark the book as returned
            UPDATE BorrowingRecords
            SET status = 'RETURNED', return_date = SYSDATE
            WHERE book_id = rec.book_id;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while processing return for book ID: ' || rec.book_id);
                ROLLBACK;
        END;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Books returned successfully for student ID: ' || student_id_in);
END ProcessLateReturns;

