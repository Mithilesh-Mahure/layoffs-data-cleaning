# 📊 Layoffs Data Cleaning & Analysis

> SQL script for cleaning, standardizing, and analyzing layoff dataset with comprehensive data preparation and exploratory insights.

![MySQL](https://img.shields.io/badge/MySQL-8.0+-00758F?style=flat-square&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Data%20Engineering-FF6B6B?style=flat-square&logo=database)
![Status](https://img.shields.io/badge/Status-Active-00B894?style=flat-square)

---

## 📋 Overview

This repository contains a structured SQL project for **data cleaning**, **standardization**, and **exploratory data analysis (EDA)** of a global tech layoffs dataset. The project demonstrates professional data engineering practices including deduplication, null handling, and meaningful business insights extraction.

---

## 🚀 Features

### Data Cleaning Module (`data_cleaning.sql`)
- ✅ Removes duplicates using `ROW_NUMBER()` window functions
- ✅ Standardizes text fields (company, industry, country)
- ✅ Converts date strings to proper `DATE` format
- ✅ Replaces blank/invalid values in industry using inference logic
- ✅ Removes rows with missing critical layoff information
- ✅ Handles edge cases and data inconsistencies

### Data Analysis Module (`layoff-EDA.sql`)
- 📈 Calculates total and maximum layoffs across companies
- 📅 Analyzes yearly and monthly trends in layoffs
- 🏆 Identifies top industries and countries affected
- 🔍 Finds companies with 100% workforce reduction
- 📊 Computes rolling monthly totals by year
- ⭐ Ranks top 5 companies with most layoffs per year

---

## 📂 Project Structure

```
layoffs-data-cleaning/
├── data_cleaning.sql         # Data cleaning pipeline with 5 steps
├── layoff-EDA.sql            # Exploratory data analysis queries
└── README.md                 # Project documentation
```

---

## 🗃️ Dataset Schema

The dataset includes the following key fields:

| Field | Type | Description |
|-------|------|-------------|
| `company` | VARCHAR | Name of the company |
| `location` | VARCHAR | Location of the layoff |
| `industry` | VARCHAR | Industry sector |
| `country` | VARCHAR | Country where layoff occurred |
| `total_laid_off` | INT | Number of employees laid off |
| `percentage_laid_off` | DECIMAL | Proportion of workforce laid off (0-1) |
| `date` | DATE | Date of the layoff event |
| `stage` | VARCHAR | Company funding stage |
| `funds_raised_millions` | DECIMAL | Capital raised before layoff |

---

## 🛠️ Technical Stack

- **Database**: MySQL 8.0+
- **Language**: SQL
- **Key Techniques**: 
  - Window Functions (`ROW_NUMBER`, `DENSE_RANK`, `SUM() OVER`)
  - Common Table Expressions (CTEs)
  - Aggregations & Group By Operations
  - String & Date Functions
  - Data Cleaning & Transformation

---

## 📋 Data Cleaning Pipeline

### Step 0: View Raw Data
Inspect the original layoffs dataset before cleaning

### Step 1: Remove Duplicates
Identify and remove duplicate records using window functions

### Step 2: Standardize Fields
Normalize text fields for consistency and accuracy

### Step 3: Handle NULLs and Inconsistencies
Fill missing industry values and resolve data inconsistencies

### Step 4: Remove Irrelevant Rows
Filter out incomplete records with missing critical information

---

## 💡 How to Use

### Prerequisites
- MySQL Server 8.0 or higher
- MySQL Workbench or any compatible SQL client
- A `layoffs_raw` table with raw data imported

### Installation & Execution

1. **Import the raw data**
   ```sql
   -- Create and populate the layoffs_raw table with your dataset
   ```

2. **Run the cleaning script**
   ```bash
   # Execute data_cleaning.sql in chunks by step
   # Start with Step 0 to inspect raw data
   # Proceed through Steps 1-4 sequentially
   ```

3. **Access cleaned data**
   ```sql
   -- Final cleaned data available in layoff_staging2 table
   SELECT * FROM layoff_staging2 LIMIT 10;
   ```

4. **Run analysis queries**
   ```bash
   # Execute layoff-EDA.sql for insights
   ```

---

## 📊 Key Insights Generated

- Total layoffs across all companies and time periods
- Year-over-year and month-over-month trends
- Most affected industries and geographic regions
- Companies with complete workforce reductions
- Rolling averages and trend analysis
- Top performers by layoff metrics

---

## 🔍 Sample Queries

```sql
-- Total layoffs by country
SELECT country, SUM(total_laid_off) as total_layoffs
FROM layoff_staging2
GROUP BY country
ORDER BY total_layoffs DESC;

-- Trend by year
SELECT YEAR(date) as year, SUM(total_laid_off) as yearly_total
FROM layoff_staging2
GROUP BY YEAR(date)
ORDER BY year DESC;

-- Top 5 companies by layoffs
SELECT company, SUM(total_laid_off) as total
FROM layoff_staging2
GROUP BY company
ORDER BY total DESC
LIMIT 5;
```

---

## 📈 Performance Considerations

- Uses efficient window functions instead of self-joins
- Leverages indexes on key columns (company, date, country)
- Handles NULL values systematically
- Optimized for datasets with 1000+ records

---

## 🎯 Use Cases

- 📊 Business Intelligence & Analytics
- 📉 Economic trend analysis
- 💼 HR and workforce planning insights
- 🏢 Industry benchmarking
- 📚 SQL learning and data engineering practice

---

## 📝 License

This project is provided as-is for educational and analytical purposes.

---

## 👤 Author

[Mithilesh-Mahure](https://github.com/Mithilesh-Mahure)

---

## 📞 Questions or Suggestions?

Feel free to open an issue or reach out for collaboration opportunities!
