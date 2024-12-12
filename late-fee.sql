CREATE OR REPLACE FUNCTION calculate_late_fee(borrow_record_id IN INT)
RETURN NUMBER IS
    v_book_id           INT;
    v_student_id        INT;
    v_borrow_date       DATE;
    v_return_date       DATE;
    v_overdue_days      INT;
    v_fee_rate          NUMBER;
    v_fee_amount        NUMBER;
BEGIN
    -- Fetching the borrowing record details
    SELECT book_id, student_id, borrow_date, return_date
    INTO v_book_id, v_student_id, v_borrow_date, v_return_date
    FROM BorrowingRecords
    WHERE id = borrow_record_id;

    -- Calculating overdue days
    IF v_return_date < SYSDATE THEN
        v_overdue_days := TRUNC(SYSDATE) - TRUNC(v_return_date);
    ELSE
        v_overdue_days := 0;
    END IF;

    -- Fetching the book type fee rate
    SELECT fee_rate
    INTO v_fee_rate
    FROM BookTypes bt
    JOIN Books b ON b.type_id = bt.id
    WHERE b.id = v_book_id;

    -- Calculating the fee amount
    v_fee_amount := v_overdue_days * v_fee_rate;

    -- Inserting penalty record
    IF v_fee_amount > 0 THEN
        INSERT INTO Penalties (student_id, amount, reason)
        VALUES (v_student_id, v_fee_amount, 'Late fee for overdue book');
    END IF;

    -- Returning the calculated fee amount
    RETURN v_fee_amount;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- No record found for the given borrow_record_id
    WHEN OTHERS THEN
        RAISE; -- Reraise the exception for any other errors
END;

