# Introduction

This project focuses on extensive cleaning and manipulation of data related to the job market to prepare it for analysis. The SQL queries utilized for cleaning and transforming the dataset can be found in the  [project_sql folder](/project_sql/)

# Background

The objective of this project is to use SQL for cleaning and manipulating job market data, making it suitable for analysis. This clean dataset will enable data analysts to gain valuable insights for informed decision-making.

The raw/uncleaned data can be downloaded from here: [Data](https://1x1kjh-my.sharepoint.com/:x:/g/personal/kenpeter_1x1kjh_onmicrosoft_com/Efyzf9P7jw5Hm3IaFhHO1dIByhEo0WzIfnWPD1beEBQEQg?e=z3OfRw).

The dataset contains information on various attributes such as job title, salary estimates, job description, rating, company name, location, headquarters, company size, year founded, type of ownership, industry, sector, revenue, and competitors.


# The data cleaning steps/process.
The data cleaning process involves the following steps.

1. **Preparation:**

    -  Creating a database.

    -  Creating a table .

    -  Loading the raw data.

2. **Droping the index column.**
Dropping the index column as it is not needed.
3. **Cleaning the salary_estimate column:** Extracting minimum salary, maximum salary, and average salary, storing them in new columns.
4. **Cleaning the rating column:** Replacing '-1' with '1'.
5. **Cleaning the country_name column:** Removing numbers at the end of each country name.
6. **Transforming the location column:** Extracting city, state, and country into new columns and dropping the original location column.
7. **Transforming the headquarters column:** Removing '-1' records and extracting city, state, and country into new columns, then dropping the original headquarters column.
8.  **Cleaning the size column:** Replacing '-1' with 'unknown' and removing ' employees' from entries.
9. **Cleaning the founded column:** Replacing '-1' values with 'unknown'.
10. **Cleaning the type_of_ownership column:** 

    a. Replaceing *'-1'* with *'Unknown'*.

    b. Replaceing *'Nonprofit Organization'* with *'NPO'*.

    c. Replaceing *'Other Organization'* with *'Other'*.

    d. Replaceing *'Company - Public'* with *'Public Company'*. 

    e. Replaceing *'Company - PrivatePrivate Company'* with *'Private Company'*. 

    f. Replaceing *'Subsidiary or Business Segment'* with *'Subsidiary'*. 

    g. Rename the column to *'ownership'*.

11. **Cleaning the industry column:** Replacing *'-1'* with *'Unknown'*.

12. **Cleaning the sector column:** Replacing *'-1'* with *'Unknown'*.
13. **Cleaning the revenue column:** 
    Extracting minimum and maximum revenue, calculating average revenue, standardizing data into billions, and dropping unwanted columns.
14. **Extracting skills:** 
Creating new columns for skills such as Python, Excel, Hadoop, SQL, Spark, AWS, and Tableau from the job description column.

# Tools Used

To analyze the data, the following tools were used:

- **SQL:** For creating and querying the database to gain insights into the data.
- **PostgreSQL:** Chosen for cleaning and transforming the data.
- **Visual Studio Code:** For executing SQL queries.


# Data Cleaning
The database was created and then cleaned, manipulated, and transformed to make it useful for analysis.

## 1. Preparation:
In this phase, a database was created, a table was defined, and raw data was loaded for further processing.

*SQL code for creating database:*
```sql
CREATE DATABASE data_cleaning;
```
*SQL code for creating table:*

```sql
CREATE TABLE data_jobs (
    index INT,
    job_title TEXT,
    salary_estimate VARCHAR(250),
    job_description TEXT,
    rating VARCHAR(250),
    company_name TEXT,
    location TEXT,
    headquarters TEXT,
    size VARCHAR(250),
    founded VARCHAR(10),
    type_of_ownership TEXT,
    industry TEXT,
    sector TEXT,
    revenue VARCHAR(250),
    competitors VARCHAR(250)
);

```

*SQL code for loading the csv file:*

```sql
COPY data_jobs
FROM 'E:\Data Analysis\Portfolio\SQL\sql_project_job_data_cleaning\job_data\Uncleaned_data_jobs.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
```

## 2. Dropping the Index Column
The table had an index column that was not required, hence it was dropped.

```sql
ALTER TABLE data_jobs 
DROP index;
```

## 3. Cleaning the Salary Estimate Column 

Extracting data on minimum and maximum salary and saving it into new columns. Calculating the average salary and saving it into a new column, then dropping the original salary_estimate column.


```sql
-- Creating a column for minimum salary
ALTER TABLE data_jobs
ADD COLUMN min_salary INTEGER;

    -- Populating the min_salary column with data on minimum salary.
    UPDATE data_jobs
    SET min_salary = CAST(TRIM(SUBSTRING(SPLIT_PART(salary_estimate, '-' , 1) FROM '\$(\d+)K')) AS INTEGER);

-- Creating column for maximum data.
ALTER TABLE data_jobs
ADD COLUMN max_salary INTEGER;

    -- Populating the max_salary with data on maximum salary.
    UPDATE data_jobs
    SET max_salary = CAST(TRIM(SUBSTRING(SPLIT_PART(salary_estimate, '-' , -1) FROM '\$(\d+)K')) AS INTEGER);

```

## 4. Cleaning the Rating Column 
Replacing '-1' values with '1'.

```sql
UPDATE data_jobs
SET rating = '1'
WHERE rating = '-1';
```

## 5. Cleaning the Country Name Column

Removing numbers at the end of each country name.

 
```sql
UPDATE data_jobs
SET company_name = TRIM(regexp_replace(company_name, '[0-9]+(\.[0-9]+)?', '','g'));
```

## 6. Transforming the Location Column

Extracting city, state, and country information into new columns and dropping the original location column.

*SQL code for creating and populating columns:*


```sql
-- Creating new columns
ALTER TABLE data_jobs
ADD COLUMN job_state TEXT,
ADD COLUMN job_country TEXT
ADD COLUMN job_country TEXT;

-- Populating job_city and job_state columns.
UPDATE data_jobs
SET job_state = TRIM(SPLIT_PART(location, ',', -1)),
SET job_city = TRIM(SPLIT_PART(location, ',', 1));

-- Populating job_country column.
UPDATE data_jobs
SET job_country = CASE
        WHEN LENGTH(TRIM(SPLIT_PART(location, ',', -1))) = 2 THEN 'United States'
        ELSE TRIM(SPLIT_PART(location, ',', -1))
        END;

-- Droping the location column
ALTER TABLE data_jobs
DROP location;
```

## 7. Transforming the Headquarters Column 

Removing '-1' records and extracting city, state, and country information into new columns, then dropping the original headquarters column.

*SQL code for creating and populating columns:*

```sql
-- Replacing '-1' with null values
UPDATE data_jobs
SET headquarters = ''
WHERE headquarters = '-1';

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

-- Droping the headquarters column
ALTER TABLE data_jobs
DROP headquarters;
```

## 8. Cleaning the Size Column 

Replacing '-1' with 'unknown' and removing 'employees' from entries.

*SQL code for cleaning the size column:*


```sql
-- Replacing '-1' with 'unknown'.
UPDATE data_jobs
SET size = 'unknown'
WHERE size = '-1';

-- Removing the 'employee' occuring at the end of each entry.
UPDATE data_jobs
SET size =  REPLACE(size, ' employees', '');
```

## 9. Cleaning the Founded Column

Replacing '-1' values with 'unknown'.
*SQL code for cleaning the size column:*

```sql
UPDATE data_jobs
SET founded = 'unknown'
WHERE founded = '-1';
```

## 10. Cleaning the Type of Ownership Column

Performing the following replacements and then renaming the column to 'ownership'.
- Replace the  *'-1'* values in the column with *'unknown'*.
- Replace *'Nonprofit Organization'* with *'NPO'*.
- Replace *'Other Organization'* with *'Other'*.
- Replace *'Company - Public'* with *'Public Company'*.
- Replace *'Company - Private'* with *'Private Company'*.
- Replace *'Private Practice / Firm'* with *'Private Practice'*.
- Replace *'Subsidiary or Business Segment'* with *'Subsidiary'*.
- Rename the column as *'ownership'*.

*SQL code for cleaning the size column:*

```sql

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
```

## 11. Cleaning the Industry Column 

Replacing '-1' with 'unknown'.

```sql
UPDATE data_jobs
SET industry = 'Unknown'
WHERE industry = '-1';
```

## 12. Cleaning the Sector Column

Replacing '-1' with 'unknown'.

```sql
UPDATE data_jobs
SET sector = 'Unknown'
WHERE
    sector = '-1';
```

## 13. Cleaning the Revenue Column

Extracting minimum and maximum revenue, calculating average revenue, standardizing data into billions, and dropping unwanted columns.

SQL code for cleaning the revenue column:

```sql
-- Creating temporary columns
ALTER TABLE data_jobs
ADD COLUMN mill_bill BOOLEAN DEFAULT FALSE,
ADD COLUMN min_rev FLOAT,
ADD COLUMN max_rev FLOAT;

-- Populating the columns
    -- In column mill_bill, if the data is in billion then TRUE otherwise FALSE.
UPDATE data_jobs
SET mill_bill = CASE
         WHEN revenue LIKE '%billion%' THEN TRUE
            ELSE FALSE
        END,
    min_rev = CAST(TRIM(SUBSTRING(SPLIT_PART(revenue, ' to ' , 1) FROM '\$(\d+)' )) AS INTEGER),
    max_rev = CAST(TRIM(SUBSTRING(SPLIT_PART(revenue, ' to ' , -1) FROM '\$(\d+)' )) AS INTEGER);


-- Creating columns for minimum revenue, maximum revenue in billions.
ALTER TABLE data_jobs
ADD COLUMN min_revenue FLOAT,
ADD COLUMN max_revenue FLOAT;

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

-- Droping the unwanted columns
ALTER TABLE data_jobs
DROP COLUMN mill_bill,
DROP COLUMN min_revenue,
DROP COLUMN max_revenue;
```

## 14. Extracting Skills 

Creating new columns for skills such as Python, Excel, Hadoop, SQL, Spark, AWS, and Tableau from the job description column.

*SQL code for extracting skills:*

```sql
-- Creating new columns for skills
ALTER TABLE data_jobs
ADD COLUMN python BOOLEAN DEFAULT FALSE,
ADD COLUMN excel BOOLEAN DEFAULT FALSE,
ADD COLUMN hadoop BOOLEAN DEFAULT FALSE,
ADD COLUMN sql BOOLEAN DEFAULT FALSE,
ADD COLUMN spark BOOLEAN DEFAULT FALSE,
ADD COLUMN aws BOOLEAN DEFAULT FALSE,
ADD COLUMN tableau BOOLEAN DEFAULT FALSE;

-- Populating skill columns based on job descriptions
UPDATE data_jobs
SET python = CASE WHEN job_description ILIKE '%python%' THEN TRUE ELSE FALSE END,
    excel = CASE WHEN job_description ILIKE '%excel%' THEN TRUE ELSE FALSE END,
    hadoop = CASE WHEN job_description ILIKE '%hadoop%' THEN TRUE ELSE FALSE END,
    sql = CASE WHEN job_description ILIKE '%sql%' THEN TRUE ELSE FALSE END,
    spark = CASE WHEN job_description ILIKE '%spark%' THEN TRUE ELSE FALSE END,
    aws = CASE WHEN job_description ILIKE '%aws%' THEN TRUE ELSE FALSE END,
    tableau = CASE WHEN job_description ILIKE '%tableau%' THEN TRUE ELSE FALSE END;
```

## 15. Cleaning the Competitors Column

Replacing '-1' with 'unknown'.

```sql
UPDATE data_jobs
SET competitors = 'Unknown'
WHERE 
    competitors = '-1';
```

# Closing Remarks
This project demonstrated a comprehensive approach to data cleaning and transformation using SQL, with a focus on preparing job market data for insightful analysis. Through meticulous steps, we addressed various data quality issues, standardized formats, and extracted valuable information to create a clean and well-structured dataset.

## Key Achievements

1. **Structured Database Creation:**
Established a robust database and table schema to accommodate raw job market data. Efficiently loaded the dataset, ensuring readiness for subsequent transformations.

2. **Data Cleaning and Transformation:**
Successfully removed redundant columns and standardized entries across multiple fields, such as salary_estimate, rating, location, and headquarters.
Transformed complex text-based data into meaningful numerical and categorical variables, enhancing data usability.

3. **Information Extraction:**
Extracted detailed insights from composite columns like salary_estimate and location, facilitating more granular analysis.
Created new columns for skills mentioned in job descriptions, enabling skill-specific trend analysis.

4. **Standardization and Normalization:**
Standardized revenue data into consistent units, aiding in comparative analysis.
Replaced inconsistent and placeholder values with standardized entries, ensuring data integrity.

## Impact

The cleaned and transformed dataset is now ready for thorough analysis, enabling data analysts to derive meaningful insights. By addressing data inconsistencies and extracting critical information, this project enhances the potential for informed decision-making in the job market domain.

Future analysis can leverage this refined dataset to:

- Identify key trends and patterns in job market demands.
- Evaluate salary distributions and correlations with company characteristics.
- Explore the prevalence of specific skills across job roles and industries.

## Final Thoughts
The successful completion of this project underscores the importance of rigorous data cleaning and transformation processes. By leveraging SQL, I have ensured that the dataset is not only clean but also structured in a way that maximizes its analytical potential. This project serves as a strong foundation for any subsequent data analysis, providing a clear pathway from raw data to actionable insights.

Thank you for reviewing this project.
