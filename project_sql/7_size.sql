/*
    OBJECTIVE: Cleaning the size column
    - Removing the ' employees' occuring at the end of the records.
*/

-- Checking the column
SELECT
    size
FROM
    data_jobs;

-- In the column we have '-1'. Assuming the -1 values are incorrectly entered and there is no data on the variable. Thus replacing '-1' with 'unknown'.

UPDATE data_jobs
SET size = 'unknown'
WHERE size = '-1';

-- Query for removing the 'employee' occuring at the end of each entry.

SELECT 
    size,
    REPLACE(size, ' employees', '')
FROM
    data_jobs;

-- Replacing ' employee' with null values

UPDATE data_jobs
SET size =  REPLACE(size, ' employees', '');

-- Checking the column
SELECT
    size
FROM
    data_jobs;