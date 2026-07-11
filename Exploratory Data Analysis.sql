-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

# 1 MEANS 100%, MEANS 100% COMPANY LAID OFF

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC
;
# TO SEE WHICH COMPANY WENT OFF THE LARGEST

-- company who hit the most during layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- industry who hit the most in layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
;

-- checking country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;


SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1
;

-- ROLLING, SHOWING LAID OFF PROGRESSION MONTHLY

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1
)
SELECT `Month`, total_laid,
SUM(total_laid) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_total
;


-- ranking companies with highest laid off per year

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
;

-- top 5 companies with highest laid off for every year

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), 
Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;

select *
from layoffs_staging2;

SELECT 
    company,
    industry,
    SUM(total_Laid_Off) AS Total_Laid_Off
FROM layoffs_staging2
WHERE company IN ('Amazon', 'Google', 'Meta', 'Salesforce', 'Microsoft', 'Philips', 'Ericsson', 'Uber', 'Dell')
GROUP BY company, industry
ORDER BY Total_Laid_Off DESC;


SELECT 
    YEAR(`date`) AS Year, industry,
    SUM(Total_Laid_Off) AS Total_Laid_Off
FROM layoffs_staging2
WHERE industry = 'Consumer'
GROUP BY YEAR(`date`)
ORDER BY Year;


-- industry with highest layoffs per year
SELECT 
    `Year`,
    industry,
    total_laid_off
FROM (
    SELECT 
        YEAR(`date`) AS `Year`,
        industry,
        SUM(total_laid_off) AS total_laid_off,
        RANK() OVER(PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off) DESC) AS rnk
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY YEAR(`date`), industry
) ranked
WHERE rnk = 1
ORDER BY `Year`;
