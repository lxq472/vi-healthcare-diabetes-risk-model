-- Diabetes Prevalence
SELECT
    "Outcome",
    COUNT(*) AS patients,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM patients
GROUP BY "Outcome"
ORDER BY "Outcome";


-- Data Quality Check
SELECT
    COUNT(*) AS total_rows,

    SUM(CASE WHEN "Glucose" = 0 THEN 1 ELSE 0 END) AS zero_glucose,
    SUM(CASE WHEN "BloodPressure" = 0 THEN 1 ELSE 0 END) AS zero_bp,
    SUM(CASE WHEN "SkinThickness" = 0 THEN 1 ELSE 0 END) AS zero_skin,
    SUM(CASE WHEN "Insulin" = 0 THEN 1 ELSE 0 END) AS zero_insulin,
    SUM(CASE WHEN "BMI" = 0 THEN 1 ELSE 0 END) AS zero_bmi
FROM patients;


-- Feature Importance
SELECT
    "Outcome",

    ROUND(AVG("Glucose")::numeric, 2) AS avg_glucose,
    ROUND(AVG("BMI")::numeric, 2) AS avg_bmi,
    ROUND(AVG("Age")::numeric, 2) AS avg_age,
    ROUND(AVG("Insulin")::numeric, 2) AS avg_insulin

FROM patients
GROUP BY "Outcome"
ORDER BY "Outcome";


--Risk Segment Distribution
SELECT
    risk_segment,
    COUNT(*) AS patients,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM patients
GROUP BY risk_segment
ORDER BY patients DESC;


-- Probability vs Outcome (Model sanity check)
SELECT
    "Outcome",
    ROUND(AVG(diabetes_probability)::numeric, 3) AS avg_probability,
    MIN(diabetes_probability) AS min_prob,
    MAX(diabetes_probability) AS max_prob,
    COUNT(*) AS patients
FROM patients
GROUP BY "Outcome"
ORDER BY "Outcome";


-- High Risk Accuracy
SELECT
    COUNT(*) AS high_risk_patients,

    SUM(CASE WHEN "Outcome" = 1 THEN 1 ELSE 0 END) AS true_diabetic,

    ROUND(
        100.0 * SUM(CASE WHEN "Outcome" = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS accuracy_percent

FROM patients
WHERE risk_segment = 'High_Risk';
