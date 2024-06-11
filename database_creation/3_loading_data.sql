
COPY data_jobs
FROM 'E:\Data Analysis\Portfolio\SQL\sql_project_job_data_cleaning\job_data\Uncleaned_data_jobs.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
