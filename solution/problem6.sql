WITH ContinentMapDistinct AS (
SELECT 
(case when country_code = "" or country_code is null then "FOO" else country_code end) as country_code,
cotinent_code as continent_code, RowNumber
FROM (
SELECT 
*
,ROW_NUMBER() OVER  ( PARTITION BY country_code ORDER BY country_code) AS rowNumber
FROM GlobalDataset.ContinentMap
WHERE TRUE 
ORDER BY country_code ASC
 ) as source 
 WHERE TRUE 
 AND rowNumber = 1
 ),
 countryCodeGDP AS (
SELECT gp.country_code,gp.year,gp.gdp_per_capita,continent_code, ce.country_name
FROM GlobalDataset.percapita gp 
INNER JOIN GlobalDataset.Countries ce  on gp.country_code = ce.country_code
INNER JOIN ContinentMapDistinct cm  on gp.country_code = cm.country_code
WHERE TRUE 
)
,ContinentCode as (
SELECT cdg.*
,ct.cotinent_name as continent_name
FROM countryCodeGDP cdg
INNER JOIN GlobalDataset.Continents ct on cdg.continent_code = ct.contient_code
WHERE TRUE 
ORDER BY year,country_code
)

## 6. All in a single query, execute all of the steps below and provide the results as your final answer:
## a.  create a single list of all per_capita records for year 2009 that includes columns: 
-- SELECT  continent_name,country_code,country_name, sum( gdp_per_capita) as sum_gdp 
-- FROM ContinentCode
-- WHERE TRUE 
-- AND year = 2009
-- GROUP BY 1,2,3
-- ;


-- b. order this list by: continent_name ascending
-- characters 2 through 4 (inclusive) of the country_name descending
-- SELECT  continent_name,country_code,country_name
-- , sum( gdp_per_capita) as gdp_per_capita 
-- FROM ContinentCode
-- WHERE TRUE 
-- AND year = 2009
-- GROUP BY 1,2,3
-- ORDER BY 1 asc 
-- ,substring(country_name,2,3) desc
-- ;
-- c. create a running total of gdp_per_capita by continent_name
-- SELECT *, sum(gdp_per_capita) over( partition by continent_name)  as gdp_per_capita
-- FROM (
-- SELECT  continent_name,country_code,country_name
-- , sum( gdp_per_capita) as gdp_per_capita 
-- FROM ContinentCode
-- WHERE TRUE 
-- AND year = 2009
-- GROUP BY 1,2,3
-- ORDER BY 1 asc 
-- ,substring(country_name,2,3) desc
-- ) as table1 
-- group by 1,2,3,4
-- ;
-- d. return only the first record from the ordered list for which each continent's running total of gdp_per_capita 
-- meets or exceeds $70,000.00 with the following columns:
SELECT *, sum(gdp_per_capita) over( partition by continent_name)  as running_total
FROM (
SELECT  continent_name,country_code,country_name
, sum( gdp_per_capita) as gdp_per_capita 
FROM ContinentCode
WHERE TRUE 
AND year = 2009
GROUP BY 1,2,3
ORDER BY 1 asc 
,substring(country_name,2,3) desc
) as table1 
WHERE TRUE 
group by 1,2,3,4
HAVING sum(sum_gdp) over( partition by continent_name)  >= 70000
ORDER BY 1,2,3,4,5

;

-- Error Code: 3593. You cannot use the window function 'sum' in this context.'
