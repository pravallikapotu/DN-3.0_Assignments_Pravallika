CREATE TABLE Employees ( 
    EmployeeID NUMBER PRIMARY KEY, 
    Name VARCHAR2(100), 
    Position VARCHAR2(50), 
    Salary NUMBER, 
    Department VARCHAR2(50), 
    HireDate DATE 
); 

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
VALUES (1, 'Alice Johnson', 'Software Engineer', 70000, 'IT', TO_DATE('2020-05-15', 'YYYY-MM-DD'));

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
VALUES (2, 'Bob Smith', 'Data Analyst', 60000, 'Finance', TO_DATE('2019-08-22', 'YYYY-MM-DD'));

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
VALUES (3, 'Charlie Brown', 'HR Manager', 75000, 'HR', TO_DATE('2018-12-01', 'YYYY-MM-DD'));

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
VALUES (4, 'Diana Prince', 'Marketing Specialist', 65000, 'Marketing', TO_DATE('2021-03-10', 'YYYY-MM-DD'));



CREATE OR REPLACE PROCEDURE UpdateSalary(
    p_employee_id IN NUMBER,
    p_percentage IN NUMBER
) IS
    v_current_salary NUMBER;
    v_new_salary NUMBER;
    employee_not_found EXCEPTION;
BEGIN
    -- Check if the employee exists and retrieve the current salary
    BEGIN
        SELECT Salary INTO v_current_salary
        FROM Employees
        WHERE EmployeeID = p_employee_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Employee with ID ' || p_employee_id || ' does not exist.');
            RETURN;
    END;

    v_new_salary := v_current_salary + (v_current_salary * p_percentage / 100);

    BEGIN
        UPDATE Employees
        SET Salary = v_new_salary
        WHERE EmployeeID = p_employee_id;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred while updating the salary.');
            ROLLBACK;
            RETURN;
    END;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Salary updated successfully for employee ID ' || p_employee_id);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred during the salary update.');
        ROLLBACK;
END UpdateSalary;
