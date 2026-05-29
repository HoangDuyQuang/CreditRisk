--- 1. loan_percent_income 

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

--- 2. loan_grade

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
            WHEN debt_to_income_ratio < 0.25 THEN '< 25%'
            WHEN debt_to_income_ratio >= 0.25 AND debt_to_income_ratio < 0.33 THEN ' (25% - 33%)'
            WHEN debt_to_income_ratio >= 0.33 AND debt_to_income_ratio < 0.42 THEN ' (33% - 42%)'
            WHEN debt_to_income_ratio >= 0.42 AND debt_to_income_ratio < 0.60 THEN ' (42% - 60%)'
            ELSE  '(>= 60%)'
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

