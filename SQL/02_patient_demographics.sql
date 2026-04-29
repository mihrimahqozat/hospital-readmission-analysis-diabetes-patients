WITH demographics AS (
    SELECT
        race,
        gender,
        age,
        readmitted,
        COUNT(encounter_id)                        AS total_encounters,
        ROUND(AVG(time_in_hospital)::NUMERIC, 2)   AS avg_time_in_hospital,
        ROUND(AVG(num_medications)::NUMERIC, 2)    AS avg_medications,
        ROUND(AVG(num_lab_procedures)::NUMERIC, 2) AS avg_lab_procedures,
        ROUND(AVG(number_diagnoses)::NUMERIC, 2)   AS avg_diagnoses
    FROM encounters
    WHERE race IS NOT NULL AND gender != 'Unknown/Invalid'
    GROUP BY 
		race, 
		gender, 
		age, 
		readmitted
)
SELECT *,
    ROUND(total_encounters * 100.0 /
        SUM(total_encounters) OVER (PARTITION BY race), 2) AS pct_within_race
FROM demographics
ORDER BY 
	race, 
	age, 
	readmitted;