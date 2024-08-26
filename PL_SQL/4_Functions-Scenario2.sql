CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment (
    p_loan_amnt NUMBER,
    p_annual_interest_rate NUMBER,
    p_duration NUMBER
) RETURN NUMBER IS
    v_monthly_interest_rate NUMBER;
    v_total_months NUMBER;
    v_monthly_installment NUMBER;
BEGIN
    
    v_monthly_interest_rate := p_annual_interest_rate / 12 / 100;
    
    -- Calculate total number of months for the loan duration
    v_total_months := p_duration * 12;
    
    
    IF v_monthly_interest_rate = 0 THEN
        v_monthly_installment := p_loan_amnt / v_total_months;
    ELSE
        v_monthly_installment := p_loan_amnt * v_monthly_interest_rate *
                                POWER(1 + v_monthly_interest_rate, v_total_months) /
                                (POWER(1 + v_monthly_interest_rate, v_total_months) - 1);
    END IF;

    RETURN v_monthly_installment;
END CalculateMonthlyInstallment;

