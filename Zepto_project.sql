drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountpercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingprice NUMERIC(8,2),
weightInGms INTEGER,
outofstock BOOLEAN,
quantity INTEGER
);

---data exploration 

---count of rows 
Select count(*) FROM zepto;

---sample data
Select * from zepto
limit 10;

--null values
select * from zepto 
where name IS NULL 
OR
category IS NULL 
OR
mrp IS NULL 
OR
discountpercent IS NULL 
OR
discountedsellingprice IS NULL
OR
availablequantity IS NULL 
OR
weightInGms IS NULL 
OR
outofstock IS NULL 
OR
quantity IS NULL 

----alter table
ALTER TABLE zepto
RENAME COLUMN Catergory TO category;

---different product categories 
select DISTINCT category 
from zepto
order by category;

---product in stock vs out of stock 
select outofstock, count(sku_id)
from zepto
group by outofstock;

---product names present multiple times 
select name, count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) DESC;

---data cleaning----

---products with price is 0 ---
select * from zepto
where mrp = 0 OR discountselling = 0;

Delete FROM zepto
where mrp = 0;

---convert paise to rupees 
update zepto 
set mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

select mrp,discountedsellingprice from zepto

---Business questions to uncover valuable insights-----

--Q1 Find the top 10 best value products based on the discount percentage--
select distinct name, mrp, discountpercent, discountedsellingprice
from zepto 
order by discountpercent DESC
LIMIT 10;

---Q2 what are the products with high mrp but out of stock ---
select distinct name, mrp
from zepto 
where outofstock = TRUE and mrp > 300
order by mrp desc

---Q3 calculate Estimated Revenue for each category---
select category,
sum(discountedsellingprice * availableQuantity) as total_revenue
from zepto 
Group by category
order by total_revenue;

---Q4 Find all products where MRP is greater than 500 and discount is less than 10%
select name, mrp, discountpercent
from zepto
where mrp > 500 and discountpercent < 10
order by mrp DESC, discountpercent DESC;

--Q5 Identify the top 5 categories offering the highest average discount percentage 
select category,
round(avg(discountpercent),2) as avg_discount
from zepto 
group by category 
order by avg_discount DESC 
limit 5;

---Q6 find the price per gram for products above 100g and sort by best value
select distinct name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram;

---Q7 Group the products into categories like low, medium, bulk
select distinct name, weightInGms,
CASE WHEN weightInGms < 1000 Then 'low'
     WHEN weightInGms < 5000 Then 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
From zepto;

---Q8 what is the total inventory weight per category
select category,
sum(weightInGms * availableQuantity) as total_weight
from zepto
Group by category
order by total_weight;
