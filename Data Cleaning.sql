-- DATA CLEANING

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standarized the Data
-- 3. Null values or blank values
-- 4. Remove unecessary columns

CREATE TABLE layoffs_stagging
LIKE layoffs; -- copying the database/ schema
-- all work will be done on the dummy database, if any things gone wrong we can still restart

SELECT *
FROM layoffs_stagging;

INSERT layoffs_stagging
select *
from layoffs;

SELECT *, 
ROW_NUMBER() OVER(
	partition by company, industry,total_laid_off, percentage_laid_off, `date`) as row_num
FROM layoffs_stagging;
-- if the row number is >1 that means there is duplicacy


WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
	partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_stagging
)
SELECT * 
FROM duplicate_cte
where row_num > 1;


select *
from layoffs_stagging
WHERE company = 'Casper';

WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
	partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_stagging
)
SELECT * 
FROM duplicate_cte
where row_num > 1;


CREATE TABLE `layoffs_stagging2` (
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

INSERt into layoffs_stagging2
SELECT *, 
ROW_NUMBER() OVER(
	partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_stagging;

SELECT *
FROM layoffs_stagging2
where row_num >1;

DELETE
FROM layoffs_stagging2
where row_num >1;

SELECT *
FROM layoffs_stagging2
where row_num >1;

SELECT *
FROM layoffs_stagging2;


-- 2. Standarized the Data

SELECT company, TRIM(company)
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET company = TRIM(company);

SELECT industry
FROM layoffs_stagging2
ORDER BY 1;

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_stagging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_stagging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_stagging2
WHERE country LIKE 'United States%';

UPDATE layoffs_stagging2
SET country = 'United States'
WHERE country LIKE 'United States%';
-- 0r
SELECT DISTINCT country, TRIM(TRAILING '.' from country)
FROM layoffs_stagging2
ORDER BY 1;
UPDATE layoffs_stagging2
SET country = TRIM(TRAILING '.' from country)
WHERE country LIKE 'United States%';

SELECT `date`,
str_to_date(`date` , '%m/%d/%Y')
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET `date` = str_to_date(`date` , '%m/%d/%Y');

SELECT `date`
FROM layoffs_stagging2;

ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_stagging2;

-- remove NULL
SELECT * 
FROM layoffs_stagging2
WHERE total_laid_off IS NULL;

-- useless rows
SELECT * 
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_stagging2
SET industry = null
WHERE industry  = '';

select *
FROM layoffs_stagging2
where industry IS NULL
OR industry ='';

select *
FROM layoffs_stagging2
where company = 'Airbnb';

SELECT t1.industry , t2.industry
FROM layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	on t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	on t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL )
AND t2.industry IS NOT NULL;

select *
FROM layoffs_stagging2
where company LIKE 'Bally%';

SELECT * 
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE 
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_stagging2;

ALTER TABLE layoffs_stagging2
DROP column row_num;