WITH countryCodeGDP AS (
SELECT gp.country_code,gp.year,gp.gdp_per_capita
,cm.continent_code, ce.country_name
FROM PerCapita gp 
LEFT JOIN Countries ce  on gp.country_code = ce.country_code
LEFT JOIN ContinentMap cm  on gp.country_code = cm.country_code
WHERE TRUE 

) 

,ContinentCode as (
SELECT cdg.*
, continent_name
FROM countryCodeGDP cdg
LEFT JOIN Continents ct on rpad(cdg.continent_code, 2, 'ABC') = rpad(ct.continent_code, 2, 'ABC') 
WHERE TRUE 

ORDER BY year,country_code
)

-- 5. Find the sum of gpd_per_capita by year and the count of countries for each year that have non-null gdp_per_capita where 
-- (i) the year is before 2012 and (ii) the country has a null gdp_per_capita in 2012. Your result should have the columns:
-- SELECT continent_name,country_code,country_name


SELECT 
year, count(distinct country_code) as  country_count, sum(gdp_per_capita) as total
FROM ContinentCode
WHERE TRUE 
AND year < 2012
AND country_code in (select country_code from ContinentCode 
    where year = 2012 # before 2012 
    AND (gdp_per_capita is null or gdp_per_capita = 0)) # check countries with null gdp  )
GROUP BY 1
