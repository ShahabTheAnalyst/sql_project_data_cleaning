/*
    OBJECTIVE: Cleaning the industry column.
    - Deal with the '-1' records in the column.
*/

-- Checking the column
SELECT
    industry
FROM
    data_jobs;


SELECT
    DISTINCT(industry)
FROM
    data_jobs;

-- The column has records enterd as '-1'. It is assumed that the correct value of the record is 'unkhown'.

UPDATE data_jobs
SET industry = 'Unknown'
WHERE industry = '-1';

-- Checking the updated column
SELECT
    DISTINCT(industry)
FROM
    data_jobs
ORDER BY 
    industry;
