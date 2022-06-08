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
,CotinentPercent as (
SELECT 
CASE WHEN continent_name = "Asia" then "Asia" 
WHEN continent_name = "Europe" then "Europe" ELSE "Rest of World" END as continent_name
,year,totalGDP
,ROUND(totalGDP / sum(totalGDP) over (partition by year order by year),2) as percent 
FROM (
SELECT  continent_name, year, sum(gdp_per_capita) as totalGDP  # total values of each contient / total values of all continent in each country.
FROM LagCountry 
GROUP BY 1,2
ORDER BY 2,1
) as Table1
GROUP BY 1,2,3
ORDER BY 2
)

SELECT year 
,
SUM(CASE
  WHEN continent_name = 'Asia' THEN percent ELSE 0 END
) AS Asia,
SUM(CASE
  WHEN continent_name = 'Europe' THEN percent ELSE 0 END
) AS Europe,
SUM(CASE
  WHEN continent_name not in ('Europe' ,'Asia' ) THEN percent ELSE 0 END
) AS "Rest of World"

FROM CotinentPercent
GROUP BY 1
; 





-- SELECT  0.04 + 0.17+ 0.58 + 0.16 + 0.04 + 0.02 
-- SELECT 0.17 + 0.58 + 0.26;