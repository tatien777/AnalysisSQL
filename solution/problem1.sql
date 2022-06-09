USE GlobalDataset;
#question1 
## have a quick look distinct values in tables 
SELECT 
count(*) as total ,count(distinct(country_code)) as distinct_values
FROM GlobalDataset.ContinentMap ;


WITH ContinentMapDuplicate as (SELECT 
(case when country_code = "" or country_code is null then "FOO" else country_code end) as country_code,
continent_code , RowNumber
FROM (
SELECT 
*
,ROW_NUMBER() OVER (
PARTITION BY country_code
ORDER BY country_code) AS rowNumber
FROM GlobalDataset.ContinentMap
WHERE TRUE 
ORDER BY country_code , 3 ASC
 ) as source 
 WHERE TRUE 
 
 )
 
Delete From ContinentMap;
insert into ContinentMap
	select country_code, continent_code from ContinentMapDuplicate WHERE rowNumber = 1 ;

-- select country_code, continent_code from ContinentMapDuplicate WHERE rowNumber > 1 ;
 
