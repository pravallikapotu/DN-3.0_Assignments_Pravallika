DECLARE
    CURSOR GenerateMonthlyStatements IS
        SELECT c.CustomerID, c.Name, t.TransactionDate, t.Amount, t.TransactionType
        FROM Customers c
        JOIN Accounts a ON c.CustomerID = a.CustomerID
        JOIN Transactions t ON a.AccountID = t.AccountID
        WHERE TRUNC(t.TransactionDate, 'MM') = TRUNC(SYSDATE, 'MM');
    
    customer_name VARCHAR2(100);
    transaction_date DATE;
    amount NUMBER;
    transaction_type VARCHAR2(10);
BEGIN
    FOR rec IN GenerateMonthlyStatements LOOP
        IF rec.CustomerID IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Customer: ' || rec.Name);
            DBMS_OUTPUT.PUT_LINE('Transaction Date: ' || rec.TransactionDate);
            DBMS_OUTPUT.PUT_LINE('Amount: ' || rec.Amount);
            DBMS_OUTPUT.PUT_LINE('Transaction Type: ' || rec.TransactionType);
            DBMS_OUTPUT.PUT_LINE('---------------------------');
        END IF;
    END LOOP;
END;
/
