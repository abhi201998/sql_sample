-- Exploratory data analysis
select * from layoff_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoff_staging2;

select * from layoff_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company , sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;

select industry , sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

select min(`date`) , max(`date`)
from layoff_staging2;

select country , sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc;

select `date` country , sum(total_laid_off)
from layoff_staging2
group by `date`
order by 2 desc;

select  year(`date`) , sum(total_laid_off)
from layoff_staging2
group by year(`date`)
order by 1 desc;
select stage, sum(total_laid_off)
from layoff_staging2
group by stage
order by 1 desc;
select substring(`date`,1,7) as `month`,sum(total_laid_off) as laid_off
from layoff_staging2
where substring(`date`,1,7) is not null 
group by `month`
order by 1 asc;
with rolling_total as
(select substring(`date`,1,7) as `month`,sum(total_laid_off) as laid_off
from layoff_staging2
where substring(`date`,1,7) is not null 
group by `month`
order by 1 asc)
select `month`,laid_off,sum(laid_off) over(order by `month`) as laid_off
from rolling_total;

select year(`date`) ,company , sum(total_laid_off)
from layoff_staging2
group by year(`date`) ,company
order by 3 desc;


with company_years(company,years,total_laid_off) as
(select  company , year(`date`),sum(total_laid_off)
from layoff_staging2
group by year(`date`), company),
company_year_rank as 
(select *,dense_rank()  over (partition by years order by total_laid_off desc) as ranking
from company_years
where years is not null)
select * from company_year_rank
where ranking <= 5

