/* 
    OBJECTIVE: Cleaning and transforming the revenue column.
    - Extract the information on minimum, maximum revenue into separate columns.
    - Standardize the data into billions.
*/


-- Checking the data
SELECT
    revenue
FROM
    data_jobs;

SELECT
    DISTINCT(revenue)
FROM
    data_jobs;

DROP TABLE
data_jobs;


-- Creating temporary columns
ALTER TABLE data_jobs
ADD COLUMN mill_bill BOOLEAN DEFAULT FALSE,
ADD COLUMN min_rev FLOAT,
ADD COLUMN max_rev FLOAT;

    -- Developing query.
    SELECT
        revenue,
        CAST(TRIM(SUBSTRING(SPLIT_PART(revenue, ' to ' , 1) FROM '\$(\d+)' )) AS INTEGER) AS min_rev,
        CAST(TRIM(SUBSTRING(SPLIT_PART(revenue, ' to ' , -1) FROM '\$(\d+)' )) AS INTEGER) AS max_rev,
        CASE
            WHEN revenue LIKE '%billion%' THEN TRUE
            ELSE FALSE
        END AS mill_bill
    FROM 
        data_jobs;


-- Populating the columns
    -- In column mill_bill 1 is for billion while 0 is for millions
UPDATE data_jobs
SET mill_bill = CASE
        WHEN revenue LIKE '%billion%' THEN TRUE
            ELSE FALSE
        END,
    min_rev = CAST(TRIM(SUBSTRING(SPLIT_PART(revenue, ' to ' , 1) FROM '\$(\d+)' )) AS INTEGER),
    max_rev = CAST(TRIM(SUBSTRING(SPLIT_PART(revenue, ' to ' , -1) FROM '\$(\d+)' )) AS INTEGER);

-- Checking the new columns
SELECT
    min_rev,
    max_rev,
    mill_bill
FROM
    data_jobs;

-- Creating columns for minimum revenue, maximum revenue in billions.
ALTER TABLE data_jobs
ADD COLUMN min_revenue FLOAT,
ADD COLUMN max_revenue FLOAT;


-- STANDARDIZING THE DATA INTO BILLIONS (USD)

    -- Developing a query
    SELECT
        revenue,
        mill_bill,
        CASE
            WHEN mill_bill = FALSE THEN min_rev/ 1000 
            ELSE min_rev
            END AS revenue_min,
        CASE
            WHEN mill_bill = FALSE THEN max_rev/ 1000 
            ELSE max_rev
            END AS revenue_max
    FROM data_jobs;


-- Populating the columns
UPDATE data_jobs
SET min_revenue = CASE
        WHEN mill_bill = FALSE THEN min_rev/ 1000 
        ELSE min_rev
    END,
    max_revenue = CASE
        WHEN mill_bill = FALSE THEN max_rev/ 1000 
        ELSE max_rev
    END;

-- Checking the revenue newly created columns
SELECT
    revenue,
    min_revenue,
    max_revenue
FROM 
    data_jobs;

-- Droping the unwanted columns
ALTER TABLE data_jobs
DROP COLUMN revenue,
DROP COLUMN mill_bill,
DROP COLUMN min_rev,
DROP COLUMN max_rev;
