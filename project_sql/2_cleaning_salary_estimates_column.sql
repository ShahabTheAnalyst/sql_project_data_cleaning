/* 
    OBJECTIVE: 
    - To extract information on the minimum salary, maximum salary, and average salary from the information contained
      in the salary_estimate column.
    - Creating a new column for the minimum salary, maximum salary, and average salary.
    - Populating the columns with data.
    */

-- Checking the column
SELECT
    salary_estimate
FROM
    data_jobs;

-- Creating column for minimum salary
ALTER TABLE data_jobs
ADD COLUMN min_salary INTEGER,
ADD COLUMN max_salary INTEGER;

-- Developing a query to extract the minimum and maximum salary from the salary_estimate column.
SELECT 
    CAST(TRIM(SUBSTRING(SPLIT_PART(salary_estimate, '-' , 1) FROM '\$(\d+)K')) AS INTEGER) AS min_salary,
    CAST(TRIM(SUBSTRING(SPLIT_PART(salary_estimate, '-' , -1) FROM '\$(\d+)K')) AS INTEGER) AS max_salary,
        salary_estimate
FROM 
    data_jobs;

-- Populating the min_salary and max_salary columns
UPDATE data_jobs
SET min_salary = CAST(TRIM(SUBSTRING(SPLIT_PART(salary_estimate, '-' , 1) FROM '\$(\d+)K')) AS INTEGER),
    max_salary = CAST(TRIM(SUBSTRING(SPLIT_PART(salary_estimate, '-' , -1) FROM '\$(\d+)K')) AS INTEGER);


-- To calculate average salary.
SELECT
    min_salary,
    max_salary,
    (min_salary + max_salary)/2
FROM
    data_jobs;

-- Creating column for average salary.
ALTER TABLE data_jobs
ADD COLUMN average_salary FLOAT;

-- Populating the average_salary column.
UPDATE data_jobs
SET average_salary = (min_salary + max_salary)/2;

-- Droping the salary_estimate column from the table.
ALTER TABLE data_jobs
DROP COLUMN salary_estimate;

-- Checking the newly created columns.
SELECT
    min_salary,
    max_salary,
    average_salary
FROM
    data_jobs;
