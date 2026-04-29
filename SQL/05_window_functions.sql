WITH specialty_stats AS (
    SELECT
        medical_specialty,
        age,
        COUNT(encounter_id)                            AS total_encounters,
        ROUND(AVG(time_in_hospital)::NUMERIC, 2)       AS avg_time_in_hospital,
        ROUND(AVG(num_medications)::NUMERIC, 2)        AS avg_medications,
        ROUND(AVG(number_diagnoses)::NUMERIC, 2)       AS avg_diagnoses,
        COUNT(CASE WHEN readmitted = '<30' THEN 1 END) AS readmitted_under_30,
        COUNT(CASE WHEN readmitted = '>30' THEN 1 END) AS readmitted_over_30,
        COUNT(CASE WHEN readmitted = 'NO' THEN 1 END)  AS not_readmitted
    FROM encounters
    WHERE medical_specialty IS NOT NULL
    GROUP BY 
		medical_specialty, 
		age
),
ranked AS (
    SELECT *,
        ROUND(readmitted_under_30 * 100.0 / NULLIF(total_encounters, 0), 2) 
			AS early_readmission_rate,
        RANK() OVER (ORDER BY readmitted_under_30 DESC) 
			AS early_readmission_rank,
        RANK() OVER (PARTITION BY age ORDER BY readmitted_under_30 DESC) 
			AS rank_within_age_group
    FROM specialty_stats
)
SELECT *
FROM ranked
ORDER BY early_readmission_rate DESC
LIMIT 50;