/* 
    OBJECTIVE: Cleaning and transforming the headquarters column.
    - Extract the information on the headquarters city and save it in a new column. 
    - Extract the information on the headquarters state/province and save it in a new column. 
    - Extract the information on the headquarters country and save it in a new column. 
*/

-- Checking out the column
SELECT
    headquarters
FROM
    data_jobs;

-- There some rows in which the data is entered as '-1'

SELECT
    headquarters
FROM
    data_jobs
WHERE
    headquarters = '-1';

-- Assuming that these companies are decentralized and have no headquarters.
-- Thus replacing '-1' with null values.

UPDATE data_jobs
SET headquarters = ''
WHERE headquarters = '-1';

-- Developing query for extracting information on headquarters city, headquarters state, and headquarters country  with ',' as delimiter.

SELECT 
    TRIM(SPLIT_PART(headquarters, ',', 1)) AS headquarters_city,
    CASE
        WHEN LENGTH(TRIM(SPLIT_PART(headquarters, ',', -1))) <> 2 THEN ''
        ELSE TRIM(SPLIT_PART(headquarters, ',', -1))
        END AS state,
    CASE
        WHEN LENGTH(TRIM(SPLIT_PART(headquarters, ',', -1))) = 2 THEN 'United States'
        ELSE TRIM(SPLIT_PART(headquarters, ',', -1))
        END AS country
FROM
    data_jobs;

-- Creating new columns

ALTER TABLE data_jobs
ADD COLUMN headquarters_city TEXT,
ADD COLUMN headquarters_state TEXT,
ADD COLUMN headquarters_country TEXT;

-- Populating the columns with the relevant data

UPDATE data_jobs
SET headquarters_city = TRIM(SPLIT_PART(headquarters, ',', 1)),
    headquarters_state = CASE
        WHEN LENGTH(TRIM(SPLIT_PART(headquarters, ',', -1))) <> 2 THEN ''
        ELSE TRIM(SPLIT_PART(headquarters, ',', -1))
        END,
    headquarters_country =     CASE
        WHEN LENGTH(TRIM(SPLIT_PART(headquarters, ',', -1))) = 2 THEN 'United States'
        ELSE TRIM(SPLIT_PART(headquarters, ',', -1))
        END;

-- Checking the newly created columns

SELECT
    headquarters_city,
    headquarters_state,
    headquarters_country
FROM
    data_jobs;

-- Droping the headquarters column

ALTER TABLE data_jobs
DROP headquarters;
