--Displaying data--
Select * from blinkit_grocery_data

--Count of data--
select COUNT(*) from blinkit_grocery_data

/* Cleaning the data (Data Preprocessing for the analysis)*/

-- Change the name of Item_Fat_Content values using UPDATE--
update blinkit_grocery_data
set Item_Fat_Content = 
CASE 
when Item_Fat_Content in ('LF', 'low fat') then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end

-- Checking the distinct values of Item_Fat_Content after updating--
select distinct(Item_Fat_Content) from blinkit_grocery_data

-- Querying for KPI's --
-- 1. Finding totat sale--
select cast(cast(sum(Total_Sales) / 1000000 as decimal(10,2)) as varchar(20)) + 'M' as [Total Sales in Millions]
from blinkit_grocery_data

-- 2. Finding Average sales--
select cast(avg(Total_Sales) as int)  as [Average Sales] from blinkit_grocery_data

-- 3. Finding No. of Items--
select count(*) as 'No. Of Orders' from blinkit_grocery_data

-- 4. Finding Average Rating--
select cast(avg(Rating) as decimal(10,1)) as 'Average Rating' from blinkit_grocery_data


-- (A) Total Sales by Item_Fat_Content--
select Item_Fat_Content, cast(sum(Total_Sales) as decimal(10,2)) as 'Total Sales' 
from blinkit_grocery_data group by Item_Fat_Content

-- (B) Total Sales by Item Type
select Item_Type, cast(sum(Total_Sales) as decimal(10,2)) as 'Total Sales'
from blinkit_grocery_data group by Item_Type order by [Total Sales] desc

-- (C) Fat Content by Outlet for Total Sales
select Outlet_Location_Type, 
       isnull([Low Fat], 0) AS Low_Fat, 
       isnull([Regular], 0) AS Regular
from 
(
    select Outlet_Location_Type, Item_Fat_Content, 
           cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales
    from blinkit_grocery_data
    group by Outlet_Location_Type, Item_Fat_Content
) as SourceTable
pivot 
(
    sum(Total_Sales) 
    for Item_Fat_Content IN ([Low Fat], [Regular])
) as PivotTable
order by Outlet_Location_Type

-- (D) Total Sales by Outlet Establishment--
select Outlet_Establishment_Year, cast(sum(Total_Sales) as decimal(10,2)) as 'Total Sales'
from blinkit_grocery_data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year

-- (E) Percentage of Sales by Outlet Size--
select
    Outlet_Size, 
    cast(sum(Total_Sales) as decimal(10,2)) as 'Total Sales',
    cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) as decimal(10,2)) as 'Sales Percentage'
from blinkit_grocery_data
group by Outlet_Size
order by [Total Sales] desc

-- (F) Sales by Outlet Location--
select Outlet_Location_Type, cast(sum(Total_Sales) as decimal(10,2)) as 'Total Sales'
from blinkit_grocery_data
group by Outlet_Location_Type
order by [Total Sales] desc

-- (G) All metrics by Outlet Type
select Outlet_Type, 
	cast(sum(Total_Sales) as decimal(10,2)) as 'Total Sales',
	cast(avg(Total_Sales) as decimal(10,2)) as 'Average Sales',
	count(*) as 'No. of Items',
	cast(avg(Rating) as decimal(10,2)) as 'Average Rating',
	cast(sum(Item_Visibility) as decimal(10,2)) as 'Item Visibility'
from blinkit_grocery_data
group by Outlet_Type
order by [Total Sales] desc

























