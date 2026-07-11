-- Data Cleaning

-- Step 1: Remove Duplicates
-- Step 2: Standardize the Data
-- Step 3: Null and Blank Values
-- Step 4: Remove Unnecessary Columns


-- Step 1 only: Removing Duplicates

SELECT *
FROM layoffs;

-- copying raw table into this new table
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Adding values into this new table
INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;


-- CTE for adding a row column to check for duplicate rows
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

# cte runs query, it does not do any changes in the table
# so we will first make another table put all this data along with
# row num col, then delete duplicate row from that new table
# after deleting duplicate rows, we will no longer need roww num col


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- inserting data with row num column

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

select *
from layoffs_staging2
where row_num > 1;








