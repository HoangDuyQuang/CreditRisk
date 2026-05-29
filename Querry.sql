--- 1. loan_percent_income (Tỷ lệ Khoản vay / Thu nhập)

SELECT DISTINCT
	PERCENTILE_CONT(0.25)
		WITHIN GROUP (
			ORDER BY loan_percent_income
		) OVER () AS Q1,

    PERCENTILE_CONT(0.5)
    WITHIN GROUP (
        ORDER BY loan_percent_income
    ) OVER () AS median_dti,

	PERCENTILE_CONT(0.75)
    WITHIN GROUP (
        ORDER BY loan_percent_income
    ) OVER () AS Q3
FROM CreditRiskData;

WITH RatioDeciles AS (
    SELECT 
        loan_percent_income,
        loan_status,
        NTILE(10) OVER (ORDER BY loan_to_income_ratio ASC) AS decile_group
    FROM CreditRiskData
    WHERE loan_to_income_ratio IS NOT NULL
)
SELECT 
    decile_group,
    ROUND(MIN(loan_percent_income), 2) AS min_ratio,
    ROUND(MAX(loan_percent_income), 2) AS max_ratio,
    COUNT(*) AS total_loans,
    SUM(loan_status) AS total_defaults,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS default_rate_pct
FROM RatioDeciles
GROUP BY decile_group
ORDER BY decile_group ASC;

WITH LPIBrackets AS (
    SELECT 
        CASE 
            WHEN loan_percent_income < 0.25              THEN '<25%'
            WHEN loan_percent_income < 0.3             THEN '<30%'
            WHEN loan_percent_income < 0.32             THEN '<32%'
            WHEN loan_percent_income < 0.33            THEN '<33%'
            ELSE                                    ' >= 33%'
        END AS lpi_group,
        loan_status
    FROM CreditRiskData
)
SELECT 
    lpi_group,
    COUNT(*)        AS total_loans,
    SUM(loan_status) AS total_defaults,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS default_rate_pct
FROM LPIBrackets
GROUP BY lpi_group
ORDER BY lpi_group ASC;

--- 2.loan_grade
Select 
	loan_grade,
	Count(*) as total_loans,
	Sum(loan_status) as total_defaults,
	ROUND(Sum(loan_status) * 100.0 / Count(*), 2) as default_rate_percentage
From CreditRiskData
Group by loan_grade
Order by loan_grade ASC

--- 3. person_income
WITH IncomeDeciles AS (
    SELECT 
        person_income,
        loan_status,
        NTILE(10) OVER (ORDER BY person_income ASC) AS decile_group
    FROM CreditRiskData
)
SELECT 
    decile_group,
    MIN(person_income) AS min_income,
    MAX(person_income) AS max_income,
    COUNT(*) AS total_loans,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS default_rate_pct
FROM IncomeDeciles
GROUP BY decile_group
ORDER BY decile_group ASC;


--- 4. loan_int_rate
SELECT 
    FLOOR(loan_int_rate) AS interest_rate_floor,
    COUNT(*) AS total_loans,
    SUM(loan_status) AS total_defaults,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS default_rate_pct
FROM CreditRiskData
WHERE loan_int_rate IS NOT NULL 
GROUP BY FLOOR(loan_int_rate)
ORDER BY interest_rate_floor ASC;

--- 5. loan_to_income_ratio
WITH RatioDeciles AS (
    SELECT 
        loan_to_income_ratio,
        loan_status,
        NTILE(10) OVER (ORDER BY loan_to_income_ratio ASC) AS decile_group
    FROM CreditRiskData
    WHERE loan_to_income_ratio IS NOT NULL
)
SELECT 
    decile_group,
    ROUND(MIN(loan_to_income_ratio), 4) AS min_ratio,
    ROUND(MAX(loan_to_income_ratio), 4) AS max_ratio,
    COUNT(*) AS total_loans,
    SUM(loan_status) AS total_defaults,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS default_rate_pct
FROM RatioDeciles
GROUP BY decile_group
ORDER BY decile_group ASC;

--- 6. debt-to-income
SELECT DISTINCT
	PERCENTILE_CONT(0.25)
		WITHIN GROUP (
			ORDER BY debt_to_income_ratio
		) OVER () AS Q1,

    PERCENTILE_CONT(0.5)
    WITHIN GROUP (
        ORDER BY debt_to_income_ratio
    ) OVER () AS median_dti,

	PERCENTILE_CONT(0.75)
    WITHIN GROUP (
        ORDER BY debt_to_income_ratio
    ) OVER () AS Q3

FROM CreditRiskData;

WITH DTI_Brackets AS (
    SELECT 
		CASE 
            WHEN debt_to_income_ratio < 0.25             THEN '1. < 25%'
            WHEN debt_to_income_ratio < 0.33             THEN '2. 25% - 33%'
            WHEN debt_to_income_ratio < 0.42             THEN '3. 33% - 42%'
            WHEN debt_to_income_ratio < 0.60             THEN '4. 42% - 60%'
            ELSE                                              '5. >= 60%'
        END AS risk_bracket,

        loan_status
    FROM CreditRiskData
    WHERE debt_to_income_ratio IS NOT NULL
)
SELECT 
    risk_bracket,
    COUNT(*) AS total_loans,
    SUM(loan_status) AS total_defaults,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS default_rate_pct
FROM DTI_Brackets
GROUP BY risk_bracket
ORDER BY default_rate_pct ASC;

--- 7. loan_amnt
Select DISTINCT 
	Min(loan_amnt)	OVER()											AS min_val,
	PERCENTILE_CONT(0.25) within group (Order by loan_amnt) OVER()  AS Q1,
	PERCENTILE_CONT(0.5) within group (Order by loan_amnt) OVER()   AS Median,
	PERCENTILE_CONT(0.75) within group (Order by loan_amnt) OVER()  AS Q3,
	Max(loan_amnt) OVER()											AS max_val,
	ROUND(AVG(loan_amnt) Over(),2)									AS mean_val
FROM CreditRiskData;

With LoanDeciles AS (
	Select 
		loan_amnt,
		loan_status,
		NTILE(15) Over(Order by loan_amnt ASC) as decile_group
	From CreditRiskData
)
Select 
	decile_group,
	Min(loan_amnt)   as min_amnt,
	Max(loan_amnt)   as max_amnt,
	Count(*)	     as total_loans,
	Sum(loan_status) as total_defaults,
	ROUND(Sum(loan_status) * 100.0 / Count(*), 2) as default_rate_pct
From LoanDeciles
Group by decile_group
Order by decile_group ASC

/*
5000 < loan_amnt < 7750 có tỷ lệ thấp hơn (15.52 - 17.5%)
Các khoản vay thấp 500-3425 hoặc cao hơn 10500 cần đặc biệt lưu ý
*/

-------------------------------------------------------------------------------------

--- 8. loan_intent
SELECT 
    loan_intent,
	Count(*) as total_loans,
	Sum(loan_status) as total_defaults,
	ROUND(Sum(loan_status)* 100.0 / Count(*) , 2) as default_rate_pct
From CreditRiskData
Group by loan_intent
Order by default_rate_pct DESC

--- 9. person_home_ownership
SELECT 
    person_home_ownership,
    COUNT(*) AS total_loans,
    SUM(loan_status) AS total_defaults,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS default_rate_pct
FROM CreditRiskData
GROUP BY person_home_ownership
ORDER BY default_rate_pct DESC;

--- 10.cb_person_default_on_file 
SELECT 
    cb_person_default_on_file,
    COUNT(*) AS total_loans,
    SUM(loan_status) AS total_defaults,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS default_rate_pct
FROM CreditRiskData
GROUP BY cb_person_default_on_file
ORDER BY default_rate_pct DESC;


