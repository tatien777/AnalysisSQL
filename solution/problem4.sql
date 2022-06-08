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

## 4.1 What is the count of countries and sum of their related gdp_per_capita values for the year 2007 where the string 'an' (case insensitive) appears anywhere in the country name
-- SELECT year,country_name, gdp_per_capita
-- FROM countryCodeGDP
-- WHERE TRUE 
-- AND year = 2007
-- AND LOWER(country_name) LIKE '%an%';

## repeat question 4a, but this time make the query case sensitive.
SELECT year,country_name, gdp_per_capita
FROM countryCodeGDP
WHERE TRUE 
AND year = 2007
AND LOWER(country_name) = 'an';

##  Must have a table to show us the result on your visualization tool.

