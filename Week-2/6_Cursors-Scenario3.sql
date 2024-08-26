DECLARE
    new_interest_rate CONSTANT NUMBER := 5;  -- Define the new interest rate
    CURSOR UpdateLoanInterestRates IS
        SELECT LoanID, InterestRate
        FROM Loans
        FOR UPDATE OF InterestRate;
    
    loan_id Loans.LoanID%TYPE;
    current_interest_rate Loans.InterestRate%TYPE;
BEGIN
    FOR rec IN UpdateLoanInterestRates LOOP
        loan_id := rec.LoanID;
        current_interest_rate := rec.InterestRate;
        
        -- Update the interest rate
        current_interest_rate := new_interest_rate;
        
        -- Update the loan interest rate
        UPDATE Loans
        SET InterestRate = current_interest_rate,
            StartDate = StartDate  -- Keeping the original start date
        WHERE LoanID = loan_id;
        
        DBMS_OUTPUT.PUT_LINE('Loan ID: ' || loan_id || ' - Interest rate updated to: ' || current_interest_rate);
    END LOOP;
END;
/
