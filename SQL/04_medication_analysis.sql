WITH medication_stats AS (
    SELECT
        insulin,
        metformin,
        change_in_meds,
        diabetes_med,
        readmitted,
        COUNT(encounter_id)                            AS total_encounters,
        ROUND(AVG(time_in_hospital)::NUMERIC, 2)       AS avg_time_in_hospital,
        ROUND(AVG(num_medications)::NUMERIC, 2)        AS avg_medications
    FROM encounters
    WHERE insulin IS NOT NULL 
		AND metformin IS NOT NULL
    GROUP BY 
		insulin, 
		metformin, 
		change_in_meds, 
		diabetes_med, 
		readmitted
)
SELECT *,
    ROUND(total_encounters * 100.0 / SUM(total_encounters) OVER (PARTITION BY insulin), 2) 
		AS pct_within_insulin_group
FROM medication_stats
ORDER BY total_encounters DESC;