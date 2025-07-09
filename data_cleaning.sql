-- DATA CLEANING SQL --
# STEP0: View original data
SELECT * 
FROM layoffs_raw;
# STEP1: REMOVING DUPLICATES
# STEP2: STANDARDIZE THE DATA
# STEP3: NULL VALUES OR BLANK VALUES
# STEP4: REMOVE ROWS AND COLUMNS THAT ARE IRRELEVANT


-- ************************************************
-- STEP 1: REMOVING DUPLICATES
-- ************************************************

/******************************************
 * 1.1 CREATE STAGING TABLE AND COPY RAW DATA
 ******************************************/
-- Create staging table with same structure
CREATE TABLE layoff_staging LIKE layoffs_raw;

-- Copy raw data into staging table
INSERT INTO layoff_staging
SELECT * 
FROM layoffs_raw;

-- Preview staging data
SELECT * 
FROM layoff_staging;


/******************************************
 * 1.2 CREATE STAGING2 TABLE WITH 'row_num' FOR DEDUPLICATION
 ******************************************/
-- Create new table with additional row_num column
CREATE TABLE layoff_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
);


/******************************************
 * 1.3 INSERT DATA WITH ROW_NUMBER FOR DUPLICATE IDENTIFICATION
 ******************************************/
-- Use window function to mark duplicates
INSERT INTO layoff_staging2
SELECT *,
  ROW_NUMBER() OVER (
    PARTITION BY 
      company,
      location,
      industry,
      total_laid_off,
      percentage_laid_off,
      `date`,
      stage,
      country,
      funds_raised_millions
    ORDER BY company
  ) AS row_num
FROM layoff_staging;


/******************************************
 * 1.4 IDENTIFY DUPLICATES
 ******************************************/
-- View records marked as duplicates (row_num > 1)
SELECT *  
FROM layoff_staging2
WHERE row_num > 1;


/******************************************
 * 1.5 REMOVE DUPLICATES
 ******************************************/
-- Delete duplicate rows based on row_num
DELETE  
FROM layoff_staging2
WHERE row_num > 1;


/******************************************
 * 1.6 VIEW FINAL CLEANED DATA
 ******************************************/
SELECT *  
FROM layoff_staging2;



-- ************************************************
-- STEP 2: STANDARDIZE THE DATA
-- ************************************************


/******************************************
 * 2.1 REMOVE LEADING/TRAILING SPACES IN 'company'
 ******************************************/
-- View before trimming
SELECT company, TRIM(company) AS trimmed_company
FROM layoff_staging2;

-- Apply trimming
UPDATE layoff_staging2
SET company = TRIM(company);


/******************************************
 * 2.2 STANDARDIZE INDUSTRY NAMES (e.g., Crypto variants)
 ******************************************/
-- View unique industry values
SELECT DISTINCT industry
FROM layoff_staging2
ORDER BY industry;

-- View affected rows
SELECT *
FROM layoff_staging2
WHERE industry LIKE 'Crypto%';

-- Standardize to single format
UPDATE layoff_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Confirm change
SELECT *
FROM layoff_staging2
WHERE industry LIKE 'Crypto%';

-- Recheck unique industries
SELECT DISTINCT industry
FROM layoff_staging2
ORDER BY industry;


/******************************************
 * 2.3 CLEANUP 'location' AND 'country' FIELDS
 ******************************************/
-- View unique locations
SELECT DISTINCT location
FROM layoff_staging2
ORDER BY location;

-- View unique countries
SELECT DISTINCT country
FROM layoff_staging2
ORDER BY country;

-- Fix inconsistent 'United States' entries
UPDATE layoff_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- Remove trailing periods or spaces
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) AS cleaned_country
FROM layoff_staging2
ORDER BY country;

UPDATE layoff_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


/******************************************
 * 2.4 CONVERT 'date' FIELD TO PROPER DATE FORMAT
 ******************************************/
-- Check raw dates
SELECT `date`
FROM layoff_staging2;

-- Convert to MySQL DATE type
UPDATE layoff_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Change column datatype to DATE
ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;


/******************************************
 * 2.5 FINAL REVIEW OF STANDARDIZED DATA
 ******************************************/
SELECT *
FROM layoff_staging2;

-- ************************************************
-- STEP 3: HANDLE NULL VALUES AND BLANK FIELDS
-- ************************************************

/******************************************
 * 3.1 FIND RECORDS WITH NULL 'total_laid_off' AND 'percentage_laid_off'
 ******************************************/
SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


/******************************************
 * 3.2 IDENTIFY BLANK OR NULL 'industry' VALUES
 ******************************************/
SELECT *
FROM layoff_staging2
WHERE industry IS NULL 
   OR industry = '';


/******************************************
 * 3.3 CROSS-CHECK SIMILAR COMPANIES WITH NON-BLANK INDUSTRY VALUES
 ******************************************/
-- Example: Checking industry of Airbnb
SELECT *
FROM layoff_staging2
WHERE company = 'Airbnb';

-- Compare blank/zero industries with valid ones
SELECT t1.industry AS blank_industry, t2.industry AS valid_industry 
FROM layoff_staging2 AS t1
JOIN layoff_staging2 AS t2
  ON t1.company = t2.company
 AND t1.location = t2.location
WHERE (t1.industry = '0' OR t1.industry = '')
  AND t2.industry != '0';


/******************************************
 * 3.4 CLEANUP BLANK OR ZERO 'industry' VALUES USING NON-BLANK MATCHES
 ******************************************/

-- Step 1: Set '0' and '' to NULL
UPDATE layoff_staging2
SET industry = NULL
WHERE industry IN ('0', '');


-- Step 2: Fill NULL 'industry' by matching on company & location
UPDATE layoff_staging2 AS t1
JOIN (
    SELECT company, location, MAX(industry) AS industry
    FROM layoff_staging2
    WHERE industry IS NOT NULL
    GROUP BY company, location
) AS t2
ON t1.company = t2.company
AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL;


/******************************************
 * 3.5 VALIDATION: REMAINING NULL OR BLANK 'industry'
 ******************************************/
SELECT *
FROM layoff_staging2
WHERE industry IS NULL
   OR industry = '';


-- ************************************************
-- STEP 4: REMOVE IRRELEVANT ROWS AND COLUMNS
-- ************************************************

/******************************************
 * 4.1 REMOVE ROWS WITH NO LAYOFF DATA
 ******************************************/
-- Drop rows where both 'total_laid_off' and 'percentage_laid_off' are NULL
DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

SELECT *
FROM layoff_staging2;
