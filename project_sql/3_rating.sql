/* OBJECTIVE: Cleaning of the rating column.
*/


-- Checking if the column has null values
SELECT 
    rating
FROM 
    data_jobs
WHERE
    rating IS NULL;
-- There are not null values.

-- Checking the distinct values.
SELECT
    DISTINCT(rating)
FROM 
    data_jobs
ORDER BY
    1;
-- The result of the query shows that the range of rating is from -1 to 5. However the rating cannot be negative and -1 may be incorrectly recorded instead of 1.

-- Replacing -1 with 1
UPDATE data_jobs
SET rating = '1'
WHERE rating = '-1';

-- Checking the updated column
SELECT
    rating
FROM
    data_jobs;