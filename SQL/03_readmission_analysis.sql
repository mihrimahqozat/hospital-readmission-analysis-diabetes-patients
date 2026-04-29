WITH readmission_stats AS (
    SELECT
        readmitted,
        COUNT(encounter_id)                            AS total_encounters,
        ROUND(AVG(time_in_hospital)::NUMERIC, 2)       AS avg_time_in_hospital,
        ROUND(AVG(num_lab_procedures)::NUMERIC, 2)     AS avg_lab_procedures,
        ROUND(AVG(num_procedures)::NUMERIC, 2)         AS avg_procedures,
        ROUND(AVG(num_medications)::NUMERIC, 2)        AS avg_medications,
        ROUND(AVG(number_diagnoses)::NUMERIC, 2)       AS avg_diagnoses,
        ROUND(AVG(number_emergency)::NUMERIC, 2)       AS avg_emergency_visits,
        ROUND(AVG(number_inpatient)::NUMERIC, 2)       AS avg_inpatient_visits,
        ROUND(AVG(number_outpatient)::NUMERIC, 2)      AS avg_outpatient_visits
    FROM encounters
    GROUP BY readmitted
),
totals AS (
    SELECT SUM(total_encounters) AS grand_total
    FROM readmission_stats
)
SELECT
    r.*,
    ROUND(r.total_encounters * 100.0 / t.grand_total, 2) AS pct_of_total
FROM readmission_stats r
CROSS JOIN totals t
ORDER BY total_encounters DESC;