WITH countryCodeGDP AS (
SELECT gp.country_code,gp.year,gp.gdp_per_capita
,cm.continent_code, ce.country_name
FROM PerCapita gp 
LEFT JOIN Countries ce  on gp.country_code = ce.country_code
LEFT JOIN ContinentMap cm  on gp.country_code = cm.country_code
WHERE TRUE 
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
ORDER BY year,country_code
) as table1
)
,CotinentPercent as (
SELECT 
CASE WHEN continent_name like "Asia%"  then "Asia" 
WHEN continent_name like "Europe%"  then "Europe" ELSE "Rest of World" END as continent_name
-- ,continent_name
,year,totalGDP
,ROUND(totalGDP / sum(totalGDP) over (partition by year order by year)*100,2) as percent 
FROM (
SELECT  continent_name, year, sum(gdp_per_capita) as totalGDP  # total values of each contient / total values of all continent in each country.
FROM LagCountry 
GROUP BY 1,2
ORDER BY 2,1
) as Table1
GROUP BY 1,2,3
ORDER BY 2
)

SELECT 
year 
, CONCAT(Asia,"%") as Asia
, CONCAT(Europe,"%") as Europe
, CONCAT(ROUND(Rest,2),"%") as "Rest of World"
FROM (SELECT 
year 
,SUM(CASE
  WHEN continent_name = 'Asia' THEN percent ELSE 0 END
) AS Asia
,SUM(CASE
  WHEN continent_name = 'Europe' THEN percent ELSE 0 END
) AS Europe
,SUM(CASE
  WHEN continent_name not in ('Europe' ,'Asia' ) THEN percent ELSE 0 END
) AS Rest 
FROM CotinentPercent
GROUP BY 1) as table2

; 



