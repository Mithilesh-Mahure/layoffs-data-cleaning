# Layoffs Data Cleaning

This repository contains a structured SQL script used to clean, standardize, and prepare a layoffs dataset for analysis. 

## 📋 Features

- Removes duplicates using `ROW_NUMBER()`
- Standardizes text fields (`company`, `industry`, `country`)
- Converts date strings to proper `DATE` format
- Replaces blank/invalid values in `industry` using inference logic
- Removes rows with missing layoff information

## 🗃️ File Structure

- `data_cleaning.sql`: Full SQL script with clearly defined steps:
  - Step 0: View Raw Data
  - Step 1: Remove Duplicates
  - Step 2: Standardize Fields
  - Step 3: Handle NULLs and Inconsistencies
  - Step 4: Remove Irrelevant Rows

## 🛠️ Requirements

- MySQL 8.0+ (for `ROW_NUMBER()` window function)
- A `layoffs_raw` table to serve as the base

## 💡 Usage

1. Run the script in chunks by step in MySQL Workbench or any compatible client.
2. Ensure `layoffs_raw` table exists before running.
3. The final cleaned data will be available in `layoff_staging2`.



# 📊 Layoff Data Analysis using MySQL

This project contains a structured SQL script to perform **Exploratory Data Analysis (EDA)** on a layoff dataset. The goal is to derive meaningful insights about global tech layoffs — such as which companies, industries, and countries were most affected, and how layoffs evolved over time.

## 🗂️ Dataset Overview

The dataset (`layoff_staging2`) includes information on startup and tech layoffs, with the following key fields:

- `company`: Name of the company
- `industry`: Industry to which the company belongs
- `country`: Country where the layoff took place
- `total_laid_off`: Number of employees laid off
- `percentage_laid_off`: Proportion of the workforce laid off
- `date`: Date of the layoff
- `stage`: Funding stage of the company
- `funds_raised_millions`: Capital raised prior to layoffs

> **Note**: The data was cleaned and standardized before running this analysis (handled separately in a data-cleaning script).

---

## 📌 Key SQL Techniques Used

- **Aggregations** (`SUM`, `MAX`, `MIN`)
- **Grouping** (`GROUP BY`)
- **Window Functions** (`DENSE_RANK`, `SUM(...) OVER (...)`)
- **Common Table Expressions (CTEs)** for modular queries
- **Date functions** like `YEAR()`, `SUBSTRING()`

---

## 📈 Insights Uncovered

✅ Total and maximum layoffs across companies  
✅ Yearly and monthly trends in layoffs  
✅ Top industries and countries affected  
✅ Companies with 100% layoffs  
✅ Rolling monthly totals by year  
✅ Top 5 companies with most layoffs per year

---

## 🛠️ How to Use

1. Import the dataset into your MySQL environment.
2. Open the `layoff_data_analysis.sql` file.
3. Run the queries step-by-step to explore the dataset and derive insights.

---

## 📂 File Structure

```plaintext
layoff_data_analysis.sql   # Main SQL analysis script
README.md                  # Project overview and documentation



