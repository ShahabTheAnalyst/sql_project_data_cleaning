/* 
    OBJECTIVE: To clean the location column.
    - Extract information on job city and creating a new column for it.
    - Extract information on job state and creating a new column for it.
*/

-- Checking the location column
SELECT
    location
FROM
    data_jobs;


-- Developing query for extracting information on job city and job state with ',' as delimiter.
SELECT 
    location,
    TRIM(SPLIT_PART(location, ',', 1)) AS job_city,
    TRIM(SPLIT_PART(location, ',', -1)) AS job_state,
    CASE
        WHEN LENGTH(TRIM(SPLIT_PART(location, ',', -1))) = 2 THEN 'United States'
        ELSE TRIM(SPLIT_PART(location, ',', -1))
        END AS job_country
FROM
    data_jobs;

-- Creating columns
ALTER TABLE data_jobs
ADD COLUMN job_city TEXT,
ADD COLUMN job_state TEXT,
ADD COLUMN job_country TEXT;

-- Populating job_city column with information on job city.
UPDATE data_jobs
SET job_city = TRIM(SPLIT_PART(location, ',', 1)),
    job_state = TRIM(SPLIT_PART(location, ',', -1)),
    job_country = CASE
            WHEN LENGTH(TRIM(SPLIT_PART(location, ',', -1))) = 2 THEN 'United States'
            ELSE TRIM(SPLIT_PART(location, ',', -1))
            END;

-- Droping the location column
ALTER TABLE data_jobs
DROP location;

-- Checking the newly created columns
SELECT
    job_city,
    job_state,
    job_country
FROM
    data_jobs;