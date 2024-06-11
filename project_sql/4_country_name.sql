
/* OBJECTIVE: Cleaning the company_name column.
    - At the end of the company name there is the rating which needs to be removed.
*/

-- Checking the column
SELECT 
    company_name
FROM 
    data_jobs;

-- Developing query for removing the trailing numbers from the company name
SELECT 
    TRIM(regexp_replace(company_name, '[0-9]+(\.[0-9]+)?', '', 'g')) AS cleaned_company_name,
    company_name
FROM data_jobs;

-- Populating the new column with the data
UPDATE data_jobs
SET company_name = TRIM(regexp_replace(company_name, '[0-9]+(\.[0-9]+)?', '', 'g'));


-- Checking the updated column
SELECT 
    company_name
FROM 
    data_jobs;