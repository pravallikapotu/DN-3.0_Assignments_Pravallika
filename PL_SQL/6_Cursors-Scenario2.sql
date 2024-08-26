DECLARE
    annual_fee CONSTANT NUMBER := 45; 
    CURSOR ApplyAnnualFee IS
        SELECT AccountID, Balance
        FROM Accounts
        FOR UPDATE OF Balance;
    
    account_id Accounts.AccountID%TYPE;
    current_balance Accounts.Balance%TYPE;
BEGIN
    FOR rec IN ApplyAnnualFee LOOP
        account_id := rec.AccountID;
        current_balance := rec.Balance;
        
        -- Deduct the annual fee
        current_balance := current_balance - annual_fee;
        
        -- Update the balance
        UPDATE Accounts
        SET Balance = current_balance,
            LastModified = SYSDATE
        WHERE AccountID = account_id;
        
        DBMS_OUTPUT.PUT_LINE('Account ID: ' || account_id || ' - Annual fee applied. New Balance: ' || current_balance);
    END LOOP;
END;
/
