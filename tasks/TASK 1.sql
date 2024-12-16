CREATE OR REPLACE PROCEDURE OverdueNotifications
IS
    -- Declare local variables
    
    overdue_days INT;
    notification_date DATE := SYSDATE;

BEGIN
    -- Insert statement
    INSERT INTO NotificationLogs (student_id, book_id, overdue_days, notification_date)
    SELECT 
        br.student_id,
        br.book_id,
        TRUNC(SYSDATE - br.return_date) AS overdue_days,
        notification_date
    FROM BorrowingRecords br
    INNER JOIN Books b ON br.book_id = b.id
    WHERE 
        br.return_date IS NOT NULL 
        AND TRUNC(SYSDATE - br.return_date) > 7 
        AND br.status = 'overdue';
END OverdueNotifications;
