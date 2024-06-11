/*
    OBJECTIVE: Extract information on skills such as python, excel,	hadoop,	
    spark, aws,	tableau, from the job description.
*/

SELECT
    job_description
FROM
    data_jobs;



-- Creating new columns for skills
ALTER TABLE data_jobs
ADD COLUMN python BOOLEAN DEFAULT FALSE,
ADD COLUMN excel BOOLEAN DEFAULT FALSE,
ADD COLUMN hadoop BOOLEAN DEFAULT FALSE,
ADD COLUMN sql BOOLEAN DEFAULT FALSE,
ADD COLUMN spark BOOLEAN DEFAULT FALSE,
ADD COLUMN aws BOOLEAN DEFAULT FALSE,
ADD COLUMN tableau BOOLEAN DEFAULT FALSE;

-- Populating skill columns based on job descriptions
UPDATE data_jobs
SET python = CASE WHEN job_description ILIKE '%python%' THEN TRUE ELSE FALSE END,
    excel = CASE WHEN job_description ILIKE '%excel%' THEN TRUE ELSE FALSE END,
    hadoop = CASE WHEN job_description ILIKE '%hadoop%' THEN TRUE ELSE FALSE END,
    sql = CASE WHEN job_description ILIKE '%sql%' THEN TRUE ELSE FALSE END,
    spark = CASE WHEN job_description ILIKE '%spark%' THEN TRUE ELSE FALSE END,
    aws = CASE WHEN job_description ILIKE '%aws%' THEN TRUE ELSE FALSE END,
    tableau = CASE WHEN job_description ILIKE '%tableau%' THEN TRUE ELSE FALSE END;
