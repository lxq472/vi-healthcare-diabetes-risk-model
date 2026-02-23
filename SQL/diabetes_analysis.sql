/*
============================================================
Healthcare Diabetes Risk Model
Tools: PostgreSQL
Description:
Exploratory Data Analysis and Risk Stratification
for Diabetes Prediction Dataset
============================================================
*/

------------------------------------------------------------
-- 1. Basic Dataset Overview
------------------------------------------------------------

SELECT COUNT(*) AS total_patients
FROM patients;

SELECT *
FROM patients
LIMIT 10;


------------------------------------------------------------
-- 2. Diabetes Prevalence
------------------------------------------------------------

SELECT
    "Outcome",
    COUNT(*) AS patients,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM patients
GROUP BY "Outcome"
ORDER BY "Outcome";


------------------------------------------------------------
-- 3. Data Quality Check (Zero Values)
------------------------------------------------------------

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN "Glucose" = 0 THEN 1 ELSE 0 END) AS zero_glucose,
    SUM(CASE WHEN "BloodPressure" = 0 THEN 1 ELSE 0 END) AS zero_bp,
    SUM(CASE WHEN "SkinThickness" = 0 THEN 1 ELSE 0 END) AS zero_skin,
    SUM(CASE WHEN "Insulin" = 0 THEN 1 ELSE 0 END) AS zero_insulin,
    SUM(CASE WHEN "BMI" = 0 THEN 1 ELSE 0 END) AS zero_bmi
FROM patients;


------------------------------------------------------------
-- 4. Feature Importance (Average by Outcome)
------------------------------------------------------------

SELECT
    "Outcome",
    ROUND(AVG("Glucose")::numeric, 2) AS avg_glucose,
    ROUND(AVG("BMI")::numeric, 2) AS avg_bmi,
    ROUND(AVG("Age")::numeric, 2) AS avg_age,
    ROUND(AVG("Insulin")::numeric, 2) AS avg_insulin
FROM patients
GROUP BY "Outcome"
ORDER BY "Outcome";


------------------------------------------------------------
-- 5. Risk Segment Distribution
------------------------------------------------------------

SELECT
    risk_segment,
    COUNT(*) AS patients,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM patients
GROUP BY risk_segment
ORDER BY patients DESC;


------------------------------------------------------------
-- 6. Probability vs Outcome (Model Sanity Check)
------------------------------------------------------------

SELECT
    "Outcome",
    ROUND(AVG(diabetes_probability)::numeric, 3) AS avg_probability,
    MIN(diabetes_probability) AS min_probability,
    MAX(diabetes_probability) AS max_probability,
    COUNT(*) AS patients
FROM patients
GROUP BY "Outcome"
ORDER BY "Outcome";


------------------------------------------------------------
-- 7. High Risk Precision (Model Performance)
------------------------------------------------------------

SELECT
    COUNT(*) AS high_risk_patients,
    SUM(CASE WHEN "Outcome" = 1 THEN 1 ELSE 0 END) AS true_diabetes,
    ROUND(
        100.0 *
        SUM(CASE WHEN "Outcome" = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS precision_percent
FROM patients
WHERE risk_segment = 'High_Risk';
