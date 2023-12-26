--1) start 
select distinct State 
 from (
 select state , year(Date) as year_ 
 from DIM_LOCATION as a 
 join FACT_TRANSACTIONS as b on a.IDLocation = b.IDLocation 
 where year(Date) >= 2005
 group by state ,  year(Date)
 ) as x
--1) end 


--2) start
select top 1 country , state , quantity , manufacturer_name , SUM(quantity) as cnt
from DIM_LOCATION as a
join FACT_TRANSACTIONS as b on a.IDLocation = b.IDLocation 
join DIM_MODEL as c on b.IDModel = c.IDModel 
join DIM_MANUFACTURER as d on c.IDManufacturer = d.IDManufacturer 
where Country = 'us' and Manufacturer_Name = 'samsung'
group by country , state , quantity , manufacturer_name
order by cnt desc 
--2) end 


--3) start 
select idmodel , state, zipcode ,count(*) as total_trasn
from FACT_TRANSACTIONS as a 
join DIM_LOCATION as b on a.IDLocation = b.IDLocation 
group by idmodel , state, zipcode
--3) end 


--4) start 
select top 1 Model_Name , min( unit_price)
from [dbo].[DIM_MODEL]
group by Model_Name
--4) end 


--5) start 
select Model_Name , AVG (totalprice) as avg_ , sum(quantity) as qty_ , Manufacturer_Name
from FACT_TRANSACTIONS as a
join DIM_MODEL as b on a.IDModel = b.IDModel 
join DIM_MANUFACTURER as c on b.IDManufacturer = c.IDManufacturer 
where Manufacturer_Name in (select  top 5 Manufacturer_Name 
                            from FACT_TRANSACTIONS as a
                             join DIM_MODEL as b on a.IDModel = b.IDModel 
                              join DIM_MANUFACTURER as c on b.IDManufacturer = c.IDManufacturer 
                               group by  Manufacturer_Name
                                order by sum(totalprice) desc)
group by Model_Name , Manufacturer_Name
order by avg_ desc
--5) end 


--6) start 
select Customer_Name , YEAR , avg(totalprice) as avgprice
from DIM_CUSTOMER as a 
join FACT_TRANSACTIONS as b on a.IDCustomer = b.IDCustomer 
join DIM_DATE as c on b.Date = c.DATE
where YEAR = 2009 
group by Customer_Name , YEAR
having avg(totalprice) > 500
--6) end 


--7) start 
select *
from (
select top 5 Model_Name 
from DIM_MODEL as a 
join FACT_TRANSACTIONS as b on a.IDModel = b.IDModel 
join DIM_DATE as c on b.Date = c.DATE 
where year = 2008
group by Model_Name , year 
order by sum(quantity) desc 
) as x
intersect 

select *
from (
select top 5 Model_Name 
from DIM_MODEL as a 
join FACT_TRANSACTIONS as b on a.IDModel = b.IDModel 
join DIM_DATE as c on b.Date = c.DATE 
where year = 2009
group by Model_Name , year 
order by sum(quantity) desc 
) as y
intersect 
select * 
from (
select top 5 Model_Name 
from DIM_MODEL as a 
join FACT_TRANSACTIONS as b on a.IDModel = b.IDModel 
join DIM_DATE as c on b.Date = c.DATE 
where year = 2010
group by Model_Name , year 
order by sum(quantity) desc 
) as z
--7) end 


--8) start 
select *
from (
select top 1 *
from (
select top 2 Manufacturer_Name , sum(totalprice) as sales , year 
from DIM_MANUFACTURER as a 
join DIM_MODEL as b on a.IDManufacturer = b.IDManufacturer 
join FACT_TRANSACTIONS as c on b.IDModel = c.IDModel 
join DIM_DATE as d on c.Date = d.DATE 
where year = 2009 
group by Manufacturer_Name  , year 
order by sales desc
) as x 
order by sales
) as aa 

union 
select *
from (
select top 1 *
from (
select top 2 Manufacturer_Name , sum(totalprice) as sales , year 
from DIM_MANUFACTURER as a 
join DIM_MODEL as b on a.IDManufacturer = b.IDManufacturer 
join FACT_TRANSACTIONS as c on b.IDModel = c.IDModel 
join DIM_DATE as d on c.Date = d.DATE 
where year = 2010
group by Manufacturer_Name  , year 
order by sales desc
) as x 
order by sales
) as ab
--8_ end 


--9) start 
select  IDManufacturer 
from DIM_MODEL as a
join FACT_TRANSACTIONS as b on a.IDModel = b.IDModel 
join DIM_DATE as c on b.Date = c.DATE 
where year = 2010
group by  IDManufacturer 
except 
select  IDManufacturer 
from DIM_MODEL as a
join FACT_TRANSACTIONS as b on a.IDModel = b.IDModel 
join DIM_DATE as c on b.Date = c.DATE 
where year = 2009
group by  IDManufacturer 
--9) end 


--10) start 
 select *, ((avg_spend-lag_)/avg_spend)*100 as perc_change
 from(
 select * , lag(avg_spend,1) over (partition by idcustomer order by year_  ) as lag_
 from (
 select IDCustomer, avg(TotalPrice) as avg_spend  , avg(Quantity) as avg_quantity , year(date) as Year_
 from FACT_TRANSACTIONS
 where IDCustomer in 
 
 (select top 10 IDCustomer 
 from FACT_TRANSACTIONS
 group by IDCustomer
 order by sum(TotalPrice) desc)

group by IDCustomer, year(date)
) as x
) as y 
--10) end 


 

















