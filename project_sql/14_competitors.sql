/*
    OBJECTIVE: To remove '-1' entries and replacing it with 'unknown'.
*/


SELECT
    competitors
FROM
data_jobs;

-- Updating the column
UPDATE data_jobs
SET competitors = 'Unknown'
WHERE competitors = '-1';