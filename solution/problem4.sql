WITH countryCodeGDP AS (
SELECT gp.country_code,gp.year,gp.gdp_per_capita
,cm.continent_code, ce.country_name
FROM PerCapita gp 
LEFT JOIN Countries ce  on gp.country_code = ce.country_code
LEFT JOIN ContinentMap cm  on gp.country_code = cm.country_code
WHERE TRUE 
) 

## 4.1 What is the count of countries and sum of their related gdp_per_capita values for the year 2007 where the string 'an' (case insensitive) appears anywhere in the country name
SELECT  year,count(country_name) as country_count, sum( gdp_per_capita) as total 
FROM countryCodeGDP
WHERE TRUE 
AND year = 2007
AND LOWER(country_name) LIKE '%an%'
GROUP BY 1
;
## repeat question 4a, but this time make the query case sensitive.
SELECT year,count(country_name) as country_count, sum( gdp_per_capita) as total 
FROM countryCodeGDP
WHERE TRUE 
AND year = 2007
AND  LOWER(country_name) like BINARY 'an%'
GROUP BY 1
;




