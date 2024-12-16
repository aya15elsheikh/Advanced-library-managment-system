CREATE OR REPLACE PROCEDURE suspend_students(p_penalty_threshold IN NUMBER) IS

BEGIN
    FOR rec IN (
        SELECT student_id, SUM(amount) AS total_penalty
        FROM Penalties
        GROUP BY student_id
        HAVING SUM(amount) > p_penalty_threshold
    ) LOOP
        UPDATE Students
        SET membership_status = FALSE --suspended
        WHERE id = rec.student_id;

        DBMS_OUTPUT.PUT_LINE('Student ID ' || rec.student_id || ' suspended due to penalties exceeding $' || p_penalty_threshold);

    END LOOP;
END;