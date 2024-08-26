CREATE OR REPLACE PROCEDURE TransferFunds (
    p_source_account_id IN NUMBER,
    p_destination_account_id IN NUMBER,
    p_amount IN NUMBER
) IS
    v_source_balance NUMBER;
BEGIN
    -- Get the current balance of the source account
    SELECT Balance INTO v_source_balance
    FROM Accounts
    WHERE AccountID = p_source_account_id
    FOR UPDATE;

    -- Check if the source account has sufficient balance
    IF v_source_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds');
    ELSE
        -- Deduct the amount from the source account
        UPDATE Accounts
        SET Balance = Balance - p_amount
        WHERE AccountID = p_source_account_id;

        -- Add the amount to the destination account
        UPDATE Accounts
        SET Balance = Balance + p_amount
        WHERE AccountID = p_destination_account_id;

        COMMIT;
    END IF;
END TransferFunds;

