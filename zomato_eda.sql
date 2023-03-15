select * from bhushandb.zomato_dataset;
SELECT (RestaurantID),COUNT((RestaurantID)) FROM 
bhushandb.zomato_dataset
GROUP BY (RestaurantID)
ORDER BY 2 DESC
;
-- country code column
;

update bhushandb.zomato_dataset 
join bhushandb.country_code 
on bhushandb.zomato_dataset.CountryCode = bhushandb.country_code.Country_Code
set country_name = bhushandb.country_code.Country

;
select * from bhushandb.country_code;
select distinct city from bhushandb.zomato_dataset
where city like '%?%';

Update bhushandb.zomato_dataset set city = REPLACE(City,'?','i') where city like '%?%';

select distinct city from bhushandb.zomato_dataset
where city like '%?%';
select country_name, city, count(city) total_rest
from bhushandb.zomato_dataset
group by country_name, city
order by 1,2,3 DESC;
select city, locality, count(locality) count_locality,
sum(count(locality)) over(partition by city order by city,locality) roll_count
from bhushandb.zomato_dataset
where country_name = 'India'
group by locality, city
order by 1,2,3 desc;
alter table bhushandb.zomato_dataset drop column address;
alter table bhushandb.zomato_dataset drop column localityverbose;

select cuisines, count(cuisines) from bhushandb.zomato_dataset
where cuisines is null or Cuisines = ' '
group by Cuisines order by 2 desc;

select currency, count(currency) from bhushandb.zomato_dataset
group by currency
order by 2 desc;


alter table bhushandb.zomato_dataset drop column switch_to_order_menu;
select distinct (price_range) from bhushandb.zomato_dataset;
alter table bhushandb.zomato_dataset modify votes int;
describe bhushandb.zomato_dataset;
alter table bhushandb.zomato_dataset modify average_cost_for_two float;
select min(votes) min_vt, avg(votes)avg_vt, max(votes)max_vt from bhushandb.zomato_dataset;
select currency, min(average_cost_for_two)min_cst,
avg(average_cost_for_two) avg_cst,
max(average_cost_for_two) max_cst
from bhushandb.zomato_dataset
group by currency;

select min(rating),
round(avg(rating)),
max(rating)
from bhushandb.zomato_dataset;
select (rating)NUM from bhushandb.zomato_dataset where Rating >= 4;

select rating, case
when rating >= 1 and rating  < 2.5 then 'poor'
when rating >= 2.5 and rating  < 3.5 then 'good'
when rating >= 3.5 and rating  < 4.5 then 'great'
when rating >= 4.5  then 'excellent'
end Rate_Category
from bhushandb.zomato_dataset;
alter table bhushandb.zomato_dataset add rate_categrory varchar(20);

select * from bhushandb.zomato_dataset;




update bhushandb.zomato_dataset set rate_categrory = (case								     	-- UPDATE WITH CASE-WHEN STATEMENT
when Rating >= 1 and Rating < 2.5 THEN 'POOR'
WHEN Rating >= 2.5 and Rating < 3.5 THEN 'GOOD'
WHEN Rating >= 3.5 and Rating < 4.5 THEN 'GREAT'
WHEN Rating >= 4.5 THEN 'EXCELLENT'
END);
alter table bhushandb.zomato_dataset rename column rate_categrory to rate_category;
select * from bhushandb.zomato_dataset;

--zomato data analysis;

select country_name, city, locality, count(locality) total_rest,
sum(count(locality)) over(partition by city order by locality desc)
from bhushandb.zomato_dataset
where country_name = 'India'
group by country_name, city, locality;
create view total_count
as
(
select distinct country_name, count(restaurantid) over() total_rest
from bhushandb.zomato_dataset
)
;
show create view total_count;
select *from total_count
with ct1 as
(
SELECT COUNTRY_NAME, COUNT(RestaurantIDAS) REST_COUNT
FROM bhushandb.zomato_dataset
GROUP BY [COUNTRY_NAME]
);
SELECT bhushandb.zomato_dataset.COUNTRY_NAME,bhushandb.zomato_dataset.REST_COUNT ,ROUND(bhushandb.zomato_dataset.REST_COUNT)/(bhushandb.tcountry_name.TOTAL_REST)*100,2)
FROM CT1 bhushandb.zomato_dataset JOIN TOTAL_COUNT bhushandb.country_name
ON bhushandb.zomato_dataset.[COUNTRY_NAME] = bhushandb.country_name.[COUNTRY_NAME]
ORDER BY 3 DESC



--WHICH COUNTRIES AND HOW MANY RESTAURANTS WITH PERCENTAGE PROVIDES ONLINE DELIVERY OPTION
CREATE OR ALTER VIEW COUNTRY_REST
AS(
SELECT [COUNTRY_NAME], COUNT(RestaurantID) REST_COUNT
FROM bhushandb.zomato_dataset
GROUP BY [COUNTRY_NAME]
)
SELECT * FROM COUNTRY_REST
ORDER BY 2 DESC

SELECT bhushandb.zomato_dataset.COUNTRY_NAME,COUNT(bhushandb.zomato_dataset.[RestaurantID]) TOTAL_REST, 
ROUND(COUNT(bhushandb.zomato_dataset.RestaurantID)/(bhushandb.country_name.[REST_COUNT] AS DECIMAL)*100, 2)
FROM  bhushandb.zomato_dataset JOIN COUNTRY_REST bhushandb.country_name
ON bhushandb.zomato_dataset.COUNTRY_NAME= bhushandb.zomato_dataset.COUNTRY_NAME
WHERE bhushandb.zomato_dataset.[Has_Online_delivery] = 'YES'
GROUP BY bhushandb.zomato_dataset.COUNTRY_NAME,bhushandb.country_name.REST_COUNT
ORDER BY 2 DESC



--FINDING FROM WHICH CITY AND LOCALITY IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
WITH CT1
AS
(
SELECT [City],[Locality],COUNT([RestaurantID]) REST_COUNT
FROM bhushandb.zomato_dataset
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
)
SELECT Locality,REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)



--TYPES OF FOODS ARE AVAILABLE IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
WITH CT1
AS
(
SELECT City,Locality,COUNT(RestaurantID) REST_COUNT
FROM bhushandb.zomato_dataset
WHERE COUNTRY_NAME = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
),
CT2 AS (
SELECT Locality,REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)
),
CT3 AS (
SELECT Locality,Cuisines FROM bhushandb.zomato_dataset
)
SELECT  bhushandb.zomato_dataset.Locality, bhushand.country_name.Cuisines
FROM  CT2 bhushandb.zomato_dataset JOIN CT3 bhushandb.country_name
ON bhushandb.zomato_dataset.Locality = bhushandb.country_name.Locality



--MOST POPULAR FOOD IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
CREATE VIEW VF 
AS
(
SELECT COUNTRY_NAME,City,Locality,N.Cuisines FROM bhushandb.zomato_dataset
CROSS APPLY (SELECT VALUE AS [Cuisines] FROM string_split([Cuisines],'|')) N
)

WITH CT1
AS
(
SELECT City,Locality,COUNT(RestaurantID) REST_COUNT
FROM bhushandb.zomato_dataset
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
),
CT2 AS (
SELECT Locality,REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)
)
SELECT bhushandb.zomato_dataset.Cuisines, COUNT(bhushandb.zomato_dataset.Cuisines)
FROM VF bhushandb.zomato_dataset JOIN CT2 bhushandb.country_name
ON bhushandb.zomato_dataset.Locality = country_name.Locality
GROUP BY bhushandb.country_name.Locality,bhushandb.zomato_dataset.Cuisines
ORDER BY 2 DESC



--WHICH LOCALITIES IN INDIA HAS THE LOWEST RESTAURANTS LISTED IN ZOMATO
WITH CT1 AS
(
SELECT City,Locality, COUNT(RestaurantID) REST_COUNT
FROM bhushandb.zomato_dataset
WHERE COUNTRY_NAME = 'INDIA'
GROUP BY City,Locality
-- ORDER BY 3 DESC
)
SELECT * FROM CT1 WHERE REST_COUNT = (SELECT MIN(REST_COUNT) FROM CT1) ORDER BY CITY



--HOW MANY RESTAURANTS OFFER TABLE BOOKING OPTION IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
WITH CT1 AS (
SELECT City,Locality,COUNT(RestaurantID) REST_COUNT
FROM bhushandb.zomato_dataset
WHERE COUNTRY_NAME = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
),
CT2 AS (
SELECT Locality,REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)
),
CT3 AS (
SELECT Locality,Has_Table_booking TABLE_BOOKING
FROM bhushandb.zomato_dataset
)
SELECT bhushandb.zomato_dataset.Locality, COUNT(bhushandb.zomato_dataset.TABLE_BOOKING) TABLE_BOOKING_OPTION
FROM CT3 bhushandb.zomato_dataset JOIN CT2 bhushandb.country_name
ON bhushandb.zomato_dataset.Locality = bhushandb.country_name.Locality
WHERE bhushandb.zomato_dataset.TABLE_BOOKING = 'YES'
GROUP BY .Locality



-- HOW RATING AFFECTS IN MAX LISTED RESTAURANTS WITH AND WITHOUT TABLE BOOKING OPTION (Connaught Place)
SELECT 'WITH_TABLE' TABLE_BOOKING_OPT,COUNT(Has_Table_booking) TOTAL_REST, ROUND(AVG(Rating),2) AVG_RATING
FROM bhushandb.zomato_dataset
WHERE Has_Table_booking = 'YES'
AND Locality = 'Connaught Place'
UNION
SELECT 'WITHOUT_TABLE' TABLE_BOOKING_OPT,COUNT(Has_Table_booking) TOTAL_REST, ROUND(AVG(Rating),2) AVG_RATING
FROM bhushandb.zomato_dataset
WHERE Has_Table_booking = 'NO'
AND Locality = 'Connaught Place'



--AVG RATING OF RESTS LOCATION WISE
SELECT COUNTRY_NAME,City,Locality, 
COUNT(RestaurantID) TOTAL_REST ,ROUND(AVG(CAST(Rating AS DECIMAL)),2) AVG_RATING
FROM bhushandb.zomato_dataset
GROUP BY COUNTRY_NAME,City,Locality
ORDER BY 4 DESC



--FINDING THE BEST RESTAURANTS WITH MODRATE COST FOR TWO IN INDIA HAVING INDIAN CUISINES
SELECT *
FROM bhushandb.zomato_dataset
WHERE COUNTRY_NAME = 'INDIA'
AND Has_Table_booking = 'YES'
AND Has_Online_delivery = 'YES'
AND Price_range <= 3
AND Votes > 1000
AND Average_Cost_for_two < 1000
AND Rating > 4
AND Cuisines LIKE '%INDIA%'



--FIND ALL THE RESTAURANTS THOSE WHO ARE OFFERING TABLE BOOKING OPTIONS WITH PRICE RANGE AND HAS HIGH RATING
SELECT Price_range, COUNT(Has_Table_booking) NO_OF_REST
FROM bhushandb.zomato_dataset
WHERE Rating >= 4.5
AND Has_Table_booking = 'YES'
GROUP BY Price_range



    

