/*
    OBJECTIVE: Cleaning the sector column.
    - Deal with the '-1' records in the column.
*/

-- Checking the column
SELECT
    sector
FROM
    data_jobs;

-- Checking the distinct values
SELECT
    DISTINCT(sector)
FROM
    data_jobs;

-- There are records entered as '-1'. It is assumed that the correct value is 'unknown'

UPDATE data_jobs
SET sector = 'Unknown'
WHERE
    sector = '-1';

-- Checking the updated column
SELECT
    DISTINCT(sector)
FROM
    data_jobs;