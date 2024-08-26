CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    DOB DATE,
    Balance NUMBER,
    LastModified DATE
);

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified) VALUES
(1, 'Krupa sagar', TO_DATE('1980-05-15', 'YYYY-MM-DD'), 15000.00, TO_DATE('2024-08-01', 'YYYY-MM-DD'));

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified) VALUES
(2, 'Carl Smith', TO_DATE('1965-11-23', 'YYYY-MM-DD'), 9500.00, TO_DATE('2024-08-01', 'YYYY-MM-DD'));

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified) VALUES
(3, 'John Vincent', TO_DATE('1949-03-30', 'YYYY-MM-DD'), 12000.00, TO_DATE('2024-08-01', 'YYYY-MM-DD'));

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified) VALUES
(4, 'Shyam', TO_DATE('1975-07-12', 'YYYY-MM-DD'), 8500.00, TO_DATE('2024-08-01', 'YYYY-MM-DD'));


CREATE TABLE Loans ( 
    LoanID NUMBER PRIMARY KEY, 
    CustomerID NUMBER, 
    LoanAmount NUMBER, 
    InterestRate NUMBER, 
    StartDate DATE, 
    EndDate DATE, 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
); 

INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate) VALUES
(1, 1, 5000.00, 5.00, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2024-01-01', 'YYYY-MM-DD'));

INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate) VALUES
(2, 2, 3000.00, 6.00, TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-01', 'YYYY-MM-DD'));

INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate) VALUES
(3, 3, 7000.00, 4.50, TO_DATE('2023-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-01', 'YYYY-MM-DD'));

INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate) VALUES
(4, 4, 2000.00, 7.00, TO_DATE('2023-08-01', 'YYYY-MM-DD'), TO_DATE('2024-08-01', 'YYYY-MM-DD'));




--SCENARIO-1
DECLARE
  CURSOR customer_cursor IS
    SELECT c.CustomerID, l.LoanID, l.InterestRate, TRUNC((SYSDATE - c.DOB) / 365) AS Age
    FROM Customers c
    JOIN Loans l ON c.CustomerID = l.CustomerID
    WHERE TRUNC((SYSDATE - c.DOB) / 365) > 60; 

BEGIN
  FOR customer_rec IN customer_cursor LOOP
    
    UPDATE Loans
    SET InterestRate = customer_rec.InterestRate * 0.99
    WHERE LoanID = customer_rec.LoanID;

  END LOOP;

  COMMIT;
END;



--SCENARIO-2
ALTER TABLE Customers ADD (IsVIP CHAR(1) DEFAULT 'N');

BEGIN
  FOR customer_rec IN (
    SELECT CustomerID, Balance
    FROM Customers
    WHERE Balance > 10000 
  ) LOOP
    UPDATE Customers
    SET IsVIP = 'Y'
    WHERE CustomerID = customer_rec.CustomerID;
  END LOOP;

  COMMIT;
END;


--SCENARIO-3


BEGIN
  FOR loan_rec IN (
    SELECT l.LoanID, l.CustomerID, c.Name, l.EndDate
    FROM Loans l
    JOIN Customers c ON l.CustomerID = c.CustomerID
    WHERE l.EndDate BETWEEN SYSDATE AND SYSDATE + 30
  ) LOOP

  DBMS_OUTPUT.PUT_LINE('Reminder: Dear ' || loan_rec.Name || 
                         ', your loan (Loan ID: ' || loan_rec.LoanID || 
                         ') is due on ' || TO_CHAR(loan_rec.EndDate, 'YYYY-MM-DD') || 
                         '. Please ensure timely payment.');
  END LOOP;
END;








