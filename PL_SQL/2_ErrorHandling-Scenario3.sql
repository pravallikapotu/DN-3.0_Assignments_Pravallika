CREATE OR REPLACE PROCEDURE AddNewCustomer(
    p_customer_id IN NUMBER,
    p_name IN VARCHAR2,
    p_dob IN DATE,
    p_balance IN NUMBER
) IS
    customer_exists EXCEPTION;
    v_dummy NUMBER; -- Dummy variable for checking existence
BEGIN
    -- Check if the customer already exists
    BEGIN
        SELECT 1 INTO v_dummy
        FROM Customers
        WHERE CustomerID = p_customer_id;
        
        -- If we get here, it means the customer exists
        RAISE customer_exists;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    BEGIN
        INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
        VALUES (p_customer_id, p_name, p_dob, p_balance, SYSDATE);
        
        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE('Customer added successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred while adding the customer.');
    END;

EXCEPTION
    WHEN customer_exists THEN
        DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || p_customer_id || ' already exists.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred during the insertion.');
        ROLLBACK;
END AddNewCustomer;

