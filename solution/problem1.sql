#question1 
SELECT 
case when country_code = "" or country_code is null then "FOO" else country_code end as country_code,
cotinent_code as continent_code 
FROM (
SELECT 
country_code,cotinent_code
FROM GlobalDataset.ContinentMap
WHERE TRUE 
ORDER BY country_code ASC ) as source 
GROUP BY 1,2 
having count(country_code) > 1
;
-- DELETE FROM ( 
SELECT 
case when country_code = "" or country_code is null then "FOO" else country_code end as country_code,
cotinent_code as continent_code 
FROM (
SELECT 
country_code,cotinent_code
FROM GlobalDataset.ContinentMap
WHERE TRUE 
ORDER BY country_code ASC ) as source 
GROUP BY 1,2 
HAVING count(country_code) > 1;

