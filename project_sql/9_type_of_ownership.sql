/*
    OBJECTIVE: Cleaning of the type_of_ownership_column.
    - The column cannot have '-1' values. It is assumed that the type of ownership is unknow therefore it is replaced with 'Unknown'.
    - Replace 'Nonprofit Organization' with 'NPO'
    - Replace 'Other Organization' with 'Other'
    - Replace 'Company - Public' with 'Public Company'
    - Replace 'Company - Private' with 'Private Company'
    - Replace 'Private Practice / Firm' with 'Private Practice'
    - Replace 'Subsidiary or Business Segment' with 'Subsidiary'
    - Change the name of the column to 'ownership'.
*/

-- Checking the column
SELECT
    DISTINCT(type_of_ownership)
FROM
    data_jobs;

-- Various replacements
UPDATE data_jobs
SET type_of_ownership = CASE
    WHEN type_of_ownership = '-1' THEN 'Unknown'
    WHEN type_of_ownership = 'Nonprofit Organization' THEN 'NPO'
    WHEN type_of_ownership = 'Other Organization' THEN 'Other'
    WHEN type_of_ownership = 'Company - Public' THEN 'Public Company'
    WHEN type_of_ownership = 'Company - PrivatePrivate Company' THEN 'Private Company'
    WHEN type_of_ownership = 'Private Practice / Firm' THEN 'Private Practice'
    WHEN type_of_ownership = 'Subsidiary or Business Segment' THEN 'Subsidiary'
    ELSE type_of_ownership
END;

-- Renaming the column
ALTER TABLE data_jobs
RENAME COLUMN type_of_ownership TO ownership;


-- Checking the udated column
SELECT
    DISTINCT(ownership)
FROM
    data_jobs;
