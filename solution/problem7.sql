WITH countryCodeGDP AS (
SELECT gp.country_code,gp.year,gp.gdp_per_capita
,cm.continent_code, ce.country_name
FROM PerCapita gp 
LEFT JOIN Countries ce  on gp.country_code = ce.country_code
LEFT JOIN ContinentMap cm  on gp.country_code = cm.country_code
WHERE TRUE 
AND (gdp_per_capita is not null and gdp_per_capita != 0) # remove country with gdp null or zero 
) 

,ContinentCode as (
SELECT cdg.*
, continent_name
FROM countryCodeGDP cdg
LEFT JOIN Continents ct on rpad(cdg.continent_code, 2, 'ABC') = rpad(ct.continent_code, 2, 'ABC') 
WHERE TRUE 

ORDER BY year,country_code
)

## 6. All in a single query, execute all of the steps below and provide the results as your final answer:
## a.  create a single list of all per_capita records for year 2009 that includes columns: 
SELECT continent_name,country_code,country_name

, CONCAT("$ ",round(avg_gdp_per_capita,2)) as avg_gdp_per_capita 
FROM (
SELECT *
, RANK() OVER (PARTITION BY continent_name  ORDER BY avg_gdp_per_capita desc ) as rankContinent
FROM (
SELECT  continent_name,country_code,country_name
, avg( gdp_per_capita) as avg_gdp_per_capita 
FROM ContinentCode
WHERE TRUE 
GROUP BY 1,2,3
ORDER BY continent_name asc #b. order this list by: continent_name ascending
,substring(country_name,2,3) desc
) as table1 
WHERE TRUE 
AND continent_name is not null
group by 1,2,3,4
-- HAVING sum(gdp_per_capita) over( partition by continent_name)  >= 70000

) final 
WHERE TRUE 
AND rankContinent = 1 #return only the first record from the ordered list
;


