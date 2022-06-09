
USE GlobalDataset;
CREATE TABLE  ContinentMapDuplicate  (
 SELECT 
(case when country_code = "" or country_code is null then "FOO" else country_code end) as country_code,
continent_code , RowNumber
FROM (
SELECT 
*
,ROW_NUMBER() OVER (
PARTITION BY country_code
ORDER BY country_code) AS rowNumber
FROM ContinentMap
WHERE TRUE 
ORDER BY country_code , 3 ASC
 ) as source 
 WHERE TRUE) ;
 
 SELECT * FROM ContinentMapDuplicate;
 
DELETE  From ContinentMap;

insert into ContinentMap
  select country_code, continent_code from ContinentMapDuplicate WHERE rowNumber = 1; 
-- select country_code, continent_code from DuplicateCoCode WHERE rowNumber > 1 ;
--  
