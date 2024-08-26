CREATE OR REPLACE PACKAGE CustomerManagement AS
    PROCEDURE AddCustomer(p_CustomerID NUMBER, p_Name VARCHAR2, p_DOB DATE, p_Balance NUMBER);
    PROCEDURE UpdateCustomerDetails(p_CustomerID NUMBER, p_Name VARCHAR2, p_DOB DATE, p_Balance NUMBER);
    FUNCTION GetCustomerBalance(p_CustomerID NUMBER) RETURN NUMBER;
END CustomerManagement;
/

CREATE OR REPLACE PACKAGE BODY CustomerManagement AS
    PROCEDURE AddCustomer(p_CustomerID NUMBER, p_Name VARCHAR2, p_DOB DATE, p_Balance NUMBER) IS
    BEGIN
        INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
        VALUES (p_CustomerID, p_Name, p_DOB, p_Balance, SYSDATE);
    END AddCustomer;
    
    PROCEDURE UpdateCustomerDetails(p_CustomerID NUMBER, p_Name VARCHAR2, p_DOB DATE, p_Balance NUMBER) IS
    BEGIN
        UPDATE Customers
        SET Name = p_Name, DOB = p_DOB, Balance = p_Balance, LastModified = SYSDATE
        WHERE CustomerID = p_CustomerID;
    END UpdateCustomerDetails;
    
    FUNCTION GetCustomerBalance(p_CustomerID NUMBER) RETURN NUMBER IS
        v_Balance NUMBER;
    BEGIN
        SELECT Balance INTO v_Balance FROM Customers WHERE CustomerID = p_CustomerID;
        RETURN v_Balance;
    END GetCustomerBalance;
END CustomerManagement;
/
