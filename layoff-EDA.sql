/*************************************************************
 * Layoff Data Analysis using MySQL
 * Dataset Table: layoff_staging2
 * Description: This script performs exploratory analysis on 
 * startup layoff data including aggregations by company, year,
 * month, country, industry, and more.
 *************************************************************/

-- View entire dataset
SELECT * 
FROM layoff_staging2;

-- Get maximum layoffs and maximum layoff percentage
SELECT 
    MAX(total_laid_off) AS max_laid_off, 
    MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoff_staging2;

-- Companies with 100% workforce laid off, sorted by funds raised
SELECT * 
FROM layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Total layoffs by company (cumulative)
SELECT 
    company, 
    SUM(total_laid_off) AS total_laid_off_by_company
FROM layoff_staging2
GROUP BY company
ORDER BY total_laid_off_by_company DESC;

-- Date range in the dataset
SELECT 
    MIN(`date`) AS earliest_date, 
    MAX(`date`) AS latest_date
FROM layoff_staging2;

-- Total layoffs by industry
SELECT 
    industry, 
    SUM(total_laid_off) AS total_laid_off_by_industry
FROM layoff_staging2
GROUP BY industry
ORDER BY total_laid_off_by_industry DESC;

-- Total layoffs by country
SELECT 
    country, 
    SUM(total_laid_off) AS total_laid_off_by_country
FROM layoff_staging2
GROUP BY country
ORDER BY total_laid_off_by_country DESC;

-- Yearly layoffs
SELECT 
    YEAR(`date`) AS layoff_year, 
    SUM(total_laid_off) AS total_laid_off_per_year
FROM layoff_staging2
GROUP BY layoff_year
ORDER BY layoff_year DESC;

-- Layoffs by funding stage
SELECT 
    stage, 
    SUM(total_laid_off) AS total_laid_off_by_stage
FROM layoff_staging2
GROUP BY stage
ORDER BY total_laid_off_by_stage DESC;

-- Monthly layoffs summary
SELECT 
    SUBSTRING(`date`, 1, 7) AS month, 
    SUM(total_laid_off) AS total_laid_off_per_month
FROM layoff_staging2
WHERE `date` IS NOT NULL
GROUP BY month
ORDER BY month;

-- Monthly rolling total of layoffs (reset each year)
WITH Monthly_Layoffs AS (
    SELECT 
        SUBSTRING(`date`, 1, 7) AS layoff_month,
        YEAR(`date`) AS layoff_year,
        SUM(total_laid_off) AS monthly_total
    FROM layoff_staging2
    WHERE `date` IS NOT NULL
    GROUP BY layoff_month, layoff_year
)
SELECT 
    layoff_year,
    layoff_month,
    monthly_total,
    SUM(monthly_total) OVER (
        PARTITION BY layoff_year 
        ORDER BY layoff_month
    ) AS rolling_total_per_year
FROM Monthly_Layoffs
ORDER BY layoff_year, layoff_month;

-- Total layoffs by company and year
SELECT 
    company,
    YEAR(`date`) AS layoff_year, 
    SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY company, layoff_year
ORDER BY total_laid_off DESC;

-- Top 5 companies with most layoffs per year
WITH Company_Year AS (
    SELECT 
        company,
        YEAR(`date`) AS year,
        SUM(total_laid_off) AS total_laid_off
    FROM layoff_staging2
    GROUP BY company, year
),
Company_Year_Rank AS (
    SELECT 
        *,
        DENSE_RANK() OVER(PARTITION BY year ORDER BY total_laid_off DESC) AS rank
    FROM Company_Year
    WHERE year IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE rank <= 5;
