CREATE OR REPLACE PROCEDURE suspend_students IS
    penalty_threshold CONSTANT NUMBER := 50;
BEGIN
    FOR rec IN (
        SELECT student_id, SUM(amount) AS total_penalty
        FROM Penalties
        GROUP BY student_id
        HAVING SUM(amount) > penalty_threshold
    ) LOOP
        UPDATE Students
        SET membership_status = 'SUSPENDED'
        WHERE id = rec.student_id;

        DBMS_OUTPUT.PUT_LINE('Student ID ' || rec.student_id || ' suspended due to penalties exceeding $' || penalty_threshold);
    END LOOP;
END;
