/*
    OBJECTIVE: Cleaning the founded column.
    - Dealing with '-1' records in the column.
*/

SELECT 
    founded
FROM
    data_jobs;

-- In the column there are '-1'. It is assumed that the year of founding is unknown. Thus replacing '-1' with 'unknown'.

UPDATE data_jobs
SET founded = 'unknown'
WHERE founded = '-1'


