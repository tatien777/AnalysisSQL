WITH countryCodeGDP AS (
SELECT gp.country_code,gp.year,gp.gdp_per_capita
,cm.continent_code, ce.country_name
FROM PerCapita gp 
LEFT JOIN Countries ce  on gp.country_code = ce.country_code
LEFT JOIN ContinentMap cm  on gp.country_code = cm.country_code
WHERE TRUE 
AND gp.year in (2011,2012)
) 

,LagCountry as (
SELECT 
country_code,continent_name ,continent_code,country_name,year,gdp_per_capita
 , LAG( gdp_per_capita)  OVER (
 PARTITION BY country_code
 ORDER BY year asc 
) as lag_value 
FROM ( 
SELECT cdg.*
,ct.continent_name 
FROM countryCodeGDP cdg
LEFT JOIN Continents ct on rpad(cdg.continent_code, 2, 'ABC') = rpad(ct.continent_code, 2, 'ABC') #cdg.continent_code = ct.continent_code # rpad(cm.continent_code, 2, 'ABC') = rpad(c.continent_code, 2, 'ABC')`
ORDER BY country_code,year
) as table1
)
SELECT 
*
FROM (
SELECT country_code, country_name,continent_name
-- , CONCAT(ROUND((gdp_per_capita - lag_value)/lag_value * 100,2) ,"%")  as  growth_percent
, ROUND((gdp_per_capita - lag_value)/lag_value * 100,2)   as  growth_percent
, RANK() OVER (PARTITION BY continent_name  ORDER BY gdp_per_capita desc ) as rankContinent
FROM LagCountry
WHERE TRUE 
AND year = 2012 
) as FINAL
WHERE TRUE 
AND rankContinent >= 10 AND rankContinent <= 12

