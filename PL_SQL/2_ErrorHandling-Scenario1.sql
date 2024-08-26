
CREATE TABLE Accounts ( 
AccountID NUMBER PRIMARY KEY, 
CustomerID NUMBER, 
AccountType VARCHAR2(20), 
Balance NUMBER, 
LastModified DATE, 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
); 

select * from Transactions;
INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (101, 1, 'Savings', 1000, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (102, 2, 'Checking', 1500, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (103, 3, 'Savings', 2000, SYSDATE);



 
CREATE TABLE Transactions ( 
    TransactionID NUMBER PRIMARY KEY, 
    AccountID NUMBER, 
    TransactionDate DATE, 
    Amount NUMBER, 
    TransactionType VARCHAR2(10), 
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) 
);

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (1, 101, SYSDATE, 200, 'Deposit');

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (2, 102, SYSDATE, 300, 'Withdrawal');

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (3, 103, SYSDATE, 150, 'Deposit');


CREATE OR REPLACE PROCEDURE SafeTransferFunds(
    p_from_account_id IN NUMBER,
    p_to_account_id IN NUMBER,
    p_amount IN NUMBER
) IS
    v_balance NUMBER;
    insufficient_funds EXCEPTION;
BEGIN
    BEGIN
        SELECT Balance INTO v_balance
        FROM Accounts
        WHERE AccountID = p_from_account_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        
            DBMS_OUTPUT.PUT_LINE('Error: Source account does not exist.');
            
            RETURN;
    END;

    IF v_balance < p_amount THEN
        RAISE insufficient_funds;
    END IF;

    BEGIN
        UPDATE Accounts
        SET Balance = Balance - p_amount
        WHERE AccountID = p_from_account_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Source account does not exist.');
            RETURN;
    END;

    BEGIN
        UPDATE Accounts
        SET Balance = Balance + p_amount
        WHERE AccountID = p_to_account_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Destination account does not exist.');
            RETURN;
    END;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transfer completed successfully.');

EXCEPTION
    WHEN insufficient_funds THEN
        -- Handle insufficient funds error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient funds in the source account.');
    WHEN OTHERS THEN
        -- Handle all other errors
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred during the transfer.');
        
END SafeTransferFunds;

