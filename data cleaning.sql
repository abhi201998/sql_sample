SELECT * FROM world_layoffs2.layoffs;
create table layoff_staging
like layoffs;
insert into layoff_staging
select* from layoffs; 

select * from layoff_staging;
with duplicate_cte AS 
(select*, row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoff_staging)
select * from duplicate_cte
where row_num>1;
CREATE TABLE `layoff_staging2` (
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
select * from layoff_staging2; 

insert into layoff_staging2
select*, row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoff_staging
delete
  from layoff_staging2
where row_num>1
update layoff_staging2
set company = trim(company);
select distinct industry
from layoff_staging2;
select * from layoff_staging2
where industry like 'crypto%';
update layoff_staging2
set industry ='crypto'
where industry like 'crypto%';
SELECT DISTINCT 
    country,
    TRIM(TRAILING '.' FROM country) AS trimmed_country
FROM 
    layoff_staging2
ORDER BY 
    country;
update layoff_staging2
set country = TRIM(TRAILING '.' FROM country)
where country like 'Unite states';
UPDATE layoff_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
alter table layoff_staging2
modify column `date` date;
select * from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;
select * from layoff_staging2
where industry is null
OR industry = '';
select * from layoff_staging2
where company = 'Airbnb';
select * from layoff_staging2 t1
join layoff_staging2 t2
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;
update layoff_staging2
set industry = null
where industry = '';
update layoff_staging2 t1
join layoff_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;
select * from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;
delete  from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;
alter table layoff_staging2
drop column row_num;
select * from layoff_staging2;




