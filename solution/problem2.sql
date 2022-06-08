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
AND gp.year in (2011,2012)
)

-- SELECT * from countryCodeGDP;
,LagCountry as (SELECT 
country_code,continent_name ,continent_code,country_name,year,gdp_per_capita
 , LAG( gdp_per_capita)  OVER (
 PARTITION BY country_code
 ORDER BY year asc 
) as lag_value 
FROM ( 
SELECT cdg.*
,ct.cotinent_name as continent_name
FROM countryCodeGDP cdg
INNER JOIN GlobalDataset.Continents ct on cdg.continent_code = ct.contient_code
) as a  
WHERE TRUE 
ORDER BY year,country_code
)
SELECT * FROM (
SELECT country_code, country_name,continent_name
, ROUND((gdp_per_capita - lag_value)/lag_value,2) as  growth_percent
, RANK() OVER (PARTITION BY continent_name  ORDER BY gdp_per_capita desc ) as rankContinent
FROM LagCountry
WHERE TRUE 
AND year = 2012 
) as FINAL
WHERE TRUE 
AND rankContinent >= 10 AND rankContinent <= 12
;
