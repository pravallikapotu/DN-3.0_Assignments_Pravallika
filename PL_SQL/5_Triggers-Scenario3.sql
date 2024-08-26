CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
    current_balance NUMBER;
BEGIN
    -- Get the current balance of the account
    SELECT Balance INTO current_balance FROM Accounts WHERE AccountID = :NEW.AccountID FOR UPDATE;

    -- Check if the transaction is a withdrawal and if it exceeds the balance
    IF :NEW.TransactionType = 'withdrawal' AND :NEW.Amount > current_balance THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance for withdrawal');
    END IF;

    -- Check if the transaction is a deposit and if it is not positive
    IF :NEW.TransactionType = 'deposit' AND :NEW.Amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Deposit amount must be positive');
    END IF;

    -- Update the account balance
    UPDATE Accounts
    SET Balance = Balance + CASE
        WHEN :NEW.TransactionType = 'deposit' THEN :NEW.Amount
        WHEN :NEW.TransactionType = 'withdrawal' THEN -:NEW.Amount
    END,
    LastModified = SYSDATE
    WHERE AccountID = :NEW.AccountID;
END;
/
