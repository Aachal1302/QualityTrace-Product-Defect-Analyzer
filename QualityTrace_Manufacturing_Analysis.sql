CREATE TABLE production_quality (
    batch_id VARCHAR(20) PRIMARY KEY,
    production_date DATE,
    shift VARCHAR(10),
    line_id VARCHAR(10),
    machine_id VARCHAR(10),
    operator_id VARCHAR(10),
    parts_produced INT,
    defects_found INT,
    defect_type VARCHAR(30),
    mold_temp_c NUMERIC(6,2),
    pour_temp_c NUMERIC(6,2),
    moisture_pct NUMERIC(6,2),
    sand_ratio NUMERIC(6,2)
);


SELECT * FROM production_quality;


-- Business Problem: Which machine has the highest defect rate?
-- Purpose: To compare machine performance and identify machines with higher defect rates.
SELECT
    machine_id,
    SUM(parts_produced) AS total_parts_produced,
    SUM(defects_found) AS total_defects,
    ROUND(
        SUM(defects_found) * 100.0 / NULLIF(SUM(parts_produced), 0),
        2
    ) AS defect_rate_pct
FROM production_quality
GROUP BY machine_id
ORDER BY defect_rate_pct DESC;



-- Business Problem: Which shift has the highest defect rate?
-- Purpose: To compare defect rates between Day and Night shifts and identify which shift needs quality improvement.
SELECT
    shift,
    SUM(parts_produced) AS total_parts_produced,
    SUM(defects_found) AS total_defects,
    ROUND(
        SUM(defects_found) * 100.0
        / NULLIF(SUM(parts_produced), 0),
        2
    ) AS defect_rate_pct
FROM production_quality
GROUP BY shift
ORDER BY defect_rate_pct DESC;



-- Business Problem: Which production line has the highest defect rate?
-- Purpose: To compare production line performance and identify the line that requires quality improvement.
SELECT
    line_id,
    SUM(parts_produced) AS total_parts_produced,
    SUM(defects_found) AS total_defects,
    ROUND(
        SUM(defects_found) * 100.0
        / NULLIF(SUM(parts_produced), 0),
        2
    ) AS defect_rate_pct
FROM production_quality
GROUP BY line_id
ORDER BY defect_rate_pct DESC;



-- Business Problem: Which defect type occurs most frequently?
-- Purpose: To identify the most common defect types and help prioritize quality improvement efforts.
SELECT
    defect_type,
    SUM(defects_found) AS total_defects
FROM production_quality
GROUP BY defect_type
ORDER BY total_defects DESC;



-- Business Problem: How are mold temperature, pour temperature, moisture, and sand ratio associated with defects?
-- Purpose: To analyze process parameter patterns and identify combinations associated with higher defect rates.
SELECT
    ROUND(mold_temp_c / 10) * 10 AS mold_temp_range,
    ROUND(pour_temp_c / 50) * 50 AS pour_temp_range,
    ROUND(moisture_pct, 1) AS moisture_level,
    ROUND(sand_ratio, 2) AS sand_ratio_level,
    SUM(parts_produced) AS total_parts_produced,
    SUM(defects_found) AS total_defects,
    ROUND(
        SUM(defects_found) * 100.0
        / NULLIF(SUM(parts_produced), 0),
        2
    ) AS defect_rate_pct
FROM production_quality
GROUP BY
    ROUND(mold_temp_c / 10) * 10,
    ROUND(pour_temp_c / 50) * 50,
    ROUND(moisture_pct, 1),
    ROUND(sand_ratio, 2)
ORDER BY defect_rate_pct DESC;