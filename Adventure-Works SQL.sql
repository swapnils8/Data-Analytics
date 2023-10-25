create database adventureworks;
use adventureworks;
show tables;
select * from sales limit 10;
select * from product limit 10;
select * from customer limit 10;
select * from productsubcategory;
select * from productcategory;
select * from salesterritory;

-- Total Sales, Cost, Profit, Orders -----------------------------------------------------------------------------------------------------
select round(sum(SalesAmount),2) as Total_Sales, 
	   round(sum(TotalProductCost),2) as Total_Cost, 
	   round(sum(SalesAmount - TotalProductCost),2) as Total_Profit,
       count(*) as Total_Orders
       from sales;
       
-- Sales by Year -----------------------------------------------------------------------------------------------------
select Year(Order_Date) as Year, round(sum(SalesAmount),2) as Sales from sales group by 1 order by 1;

-- Sales by Month Name -----------------------------------------------------------------------------------------------------
select round(sum(SalesAmount),2) as Sales, Month_Name, Year from sales group by 2,3 order by 2;

-- Sales by Quarter -----------------------------------------------------------------------------------------------------
select Quarter(Order_Date), round(sum(SalesAmount),2) as Sales from sales group by 1 order by 1;

-- Sales, Cost, Profit by Year -----------------------------------------------------------------------------------------------------
select Year(Order_Date) as Year, 
		round(sum(SalesAmount),2) as Sales, 
		round(sum(TotalProductCost),2) as Cost, 
		round(sum(SalesAmount - TotalProductCost),2) as Profit
		from sales group by 1 order by 1;

-- Sales by Product Category -----------------------------------------------------------------------------------------------------
with s as (select * from Sales join Product using(ProductKey) 
           join ProductSubCategory using(ProductSubCategoryKey) 
           join ProductCategory using(ProductCategoryKey))
           select EnglishProductCategoryName, round(sum(SalesAmount),2) as Sales
           from s group by 1 order by 2 desc;

-- Sales by Product Sub-Category -----------------------------------------------------------------------------------------------------
with t as (select * from Sales join Product using(ProductKey) 
           join ProductSubCategory using(ProductSubCategoryKey) 
           join ProductCategory using(ProductCategoryKey))
           select EnglishProductCategoryName,EnglishProductSubcategoryName, round(sum(SalesAmount),2) as Sales
           from t group by 2,1 order by 1;

-- Sales, Cost, Profit by Country -----------------------------------------------------------------------------------------------------
select SalesTerritoryCountry as Country, 
		round(sum(SalesAmount),2) as Sales, 
		round(sum(TotalProductCost),2) as Cost, 
		round(sum(SalesAmount - TotalProductCost),2) as Profit
		from sales join salesterritory using(SalesTerritoryKey)
        group by 1 order by 2 desc;
        
	-- Average sales per customer
SELECT CONCAT(FirstName,' ', LastName) AS `Customer Name`, round(AVG(SalesAmount),2) as `Average Sales`
FROM customer JOIN sales  using (CustomerKey) GROUP BY 1 ORDER BY 1;

-- Total Customers
SELECT DISTINCT(COUNT(CustomerKey))  `Total Customers`
FROM customer;

-- Ranking of customers by sales
SELECT CONCAT(FirstName, ' ', LastName) as `Customer Name`, round(SUM(SalesAmount), 2) AS `Total Sales`,
CASE WHEN SUM(SalesAmount) > 10000 THEN 'Diamond'
  WHEN SUM(SalesAmount) BETWEEN 5000 AND 9999 THEN 'Gold'
  WHEN SUM(SalesAmount) BETWEEN 1000 AND 4999 THEN 'Silver'
  ELSE 'Bronze'
  END AS Ranking
FROM sales
JOIN customer using (CustomerKey)
GROUP BY 1 ORDER BY 2 DESC;

-- Top 10 most sale product
SELECT EnglishProductName AS Product, EnglishProductCategoryName AS Category,
EnglishProductSubcategoryName AS `Product Subcategory`, 
ROUND(SUM(SalesAmount), 2) AS Sales
from sales 
JOIN Product using (ProductKey) 
JOIN ProductSubcategory using (ProductSubcategoryKey)
JOIN ProductCategory using (ProductCategoryKey)
GROUP BY 1, 2, 3 ORDER BY  Sales DESC limit 10;





        