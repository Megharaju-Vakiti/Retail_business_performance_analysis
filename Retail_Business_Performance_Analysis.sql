# CREATE & USE DATABASE --
CREATE DATABASE sales_analysis;

USE sales_analysis;

# CREATE SALES TABLE --
CREATE TABLE sales (
    Order_ID VARCHAR(50),
    Order_Date VARCHAR(50),
    Order_Month VARCHAR(50),
    Customer_ID VARCHAR(50),
    Product_ID VARCHAR(50),
    Product_Name VARCHAR(100),
    Category VARCHAR(100),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Discount DECIMAL(5,2),
    Sales_Amount DECIMAL(12,2),
    Sales_Channel VARCHAR(50),
    Order_Status VARCHAR(50),
    Order_Year VARCHAR(50)
);

# CREATE CUSTOMERS TABLE --
CREATE TABLE customers (
Customer_ID	VARCHAR(50),
Customer_Name VARCHAR(50),
Email VARCHAR(100),
City VARCHAR(50),
State_ VARCHAR(50),
Customer_Segment VARCHAR(50)
);

# VIEW SALES TABLE --
SELECT * 
FROM sales;

# VIEW CUSOMERS TABLE --
SELECT * 
FROM customers 
LIMIT 10;

# DESCRIBE SALES --
DESCRIBE sales;

# DESCRIBE CUSTOMERS --
DESCRIBE customers;

# COUNT TOTAL SALES ROWS --
SELECT COUNT(*) AS total_sales_rows 
FROM sales;


# ORDER DATE RANGES IN SALES --
SELECT MIN(Order_Date) AS First_Order,
       MAX(Order_Date) AS Last_Order
FROM sales;

# SALES_AMOUNT CALCULATIONS --
SELECT 
     SUM(Sales_Amount) AS Total_sales,
     AVG(Sales_Amount) AS Average_sales,
     MIN(Sales_Amount) AS Lowest_sale,
     MAX(Sales_Amount) AS Highest_sales
FROM sales;


# SALES AMOUNT BY EACH CATEGORY --
SELECT Category, 
       SUM(Sales_Amount) AS Total_sales_Amount
FROM sales 
GROUP BY Category
ORDER BY SUM(Sales_Amount) DESC;


# MONTLY SALES AMOUNT AND AVERAGE UNIT PRICE --
SELECT Order_Month,
	   COUNT(Order_ID) AS Total_Orders,
       AVG(Unit_Price) AS AVG_Unit_Price,
       SUM(Sales_Amount) AS Total_Sales
FROM sales 
GROUP BY Order_Month 
ORDER BY COUNT(Order_ID) DESC;


# TOTAL SALES AMOUNT CATEGORIZED BY SALES CHANNEL --
SELECT Sales_Channel,
	SUM(Sales_Amount) AS Total_Sales_Amount
FROM sales
GROUP BY Sales_Channel
ORDER BY Total_Sales_Amount DESC;


# TOTAL ORDER COUNT IN CATEGORIZED ORDER STATUS --
SELECT Order_Status,
       COUNT(Order_ID) AS Order_Count
FROM sales 
GROUP BY Order_Status
ORDER BY Order_Count DESC;


# JOIN CUSTOMERS AND SALES TABLE --
SELECT s.Order_ID,
	s.Order_Date,
    s.Customer_ID,
    c.Customer_Name,
    c.City,
    c.State_,
    s.Product_Name,
    s.Category,
    s.Sales_Amount
FROM sales s 
INNER JOIN customers c
ON s.Customer_ID = c.Customer_ID;

--------------------------------------------------------------------------------------------------------

## STATE AND CITY ANALYSIS
SELECT City, 
	State_ 
FROM customers
WHERE LOWER(State_) <> 'unknown'
      AND LOWER(City) <> 'unknown'
GROUP BY City,
         State_;
         
# TOTAL SALES AMOUNT IN EACH STATE
SELECT c.State_,
      SUM(s.Sales_Amount) AS Total_Sales_AMT
FROM sales s 
INNER JOIN customers c
ON s.Customer_ID = c.Customer_ID 
WHERE LOWER(State_) <> 'unknown'
GROUP BY c.State_
ORDER BY Total_Sales_AMT DESC;
      
# TOP 20 HIGHEST SALES BY STATE, CITY --
SELECT 
    c.State_,
    c.City,
	COUNT(Order_Date) AS Order_Counts,
    SUM(s.Sales_Amount) AS Total_Sales_AMT
 FROM sales s
 INNER JOIN customers c 
 ON s.Customer_ID = c.Customer_ID
 WHERE LOWER(State_) <> 'unknown'
      AND LOWER(City) <> 'unknown'
 GROUP BY c.State_, c.City
 ORDER BY Total_Sales_AMT DESC
 LIMIT 20;
 
 -----------------------------------------------------------------------------------------------------
 
 ## CUSTOMER ANALYSIS
 SELECT COUNT(c.Customer_ID) AS ID_Counts, 
       c.Customer_Name 
 FROM sales s 
 INNER JOIN customers c
 ON c.Customer_ID = s.Customer_ID
 GROUP BY c.Customer_ID,
       c.Customer_Name
ORDER BY COUNT(c.Customer_ID) DESC;

 # TOP 10 CUSTOMERS BY SALES --
 SELECT c.Customer_ID,
      c.Customer_Name,
      SUM(s.Sales_Amount) AS Total_Sales_AMT
FROM sales s
INNER JOIN customers c
ON c.Customer_ID = s.Customer_ID
GROUP BY Customer_ID,
     Customer_Name 
ORDER BY Total_Sales_AMT DESC
LIMIT 10;

# TOP 10 CUSTOMERS WITH HIGHEST ORDERS --
SELECT c.Customer_Name,
    c.Customer_ID,
    COUNT(s.Order_ID) AS Order_Count
FROM sales s
INNER JOIN customers c
ON s.Customer_ID = c.Customer_ID 
GROUP BY Customer_Name,
        Customer_ID 
ORDER BY Order_Count DESC
LIMIT 10 OFFSET 1;

-------------------------------------------------------------------------------------------------------

## ORDER DATE ANALYSIS
SELECT Order_Date
FROM sales 
GROUP BY Order_Date;

# MONTLY SALES --
SELECT MONTH(Order_Date) AS Month_Number,
    MONTHNAME(Order_Date) AS Month_Name,
    SUM(Sales_Amount) AS Total_Sales_AMT
FROM sales
WHERE Order_Date IS NOT NULL
GROUP BY
    MONTH(Order_Date),
    MONTHNAME(Order_Date)
ORDER BY Month_Number;

# MONTLY ORDER VOLUME   --
SELECT MONTH(Order_Date) AS Month_Number,
      MONTHNAME(Order_Date) AS Month_Name,
      COUNT(*) AS Total_Orders_AMT
FROM sales
WHERE Order_Date IS NOT NULL
GROUP BY MONTH(Order_Date),
      MONTHNAME(Order_Date) 
ORDER BY Month_Number;

-------------------------------------------------------------------------------------------------------

## PRODUCT ANALYSIS
SELECT Product_Name FROM sales GROUP BY Product_Name;

 # SALES BY PRODUCTS --
 SELECT Product_Name,
        SUM(Sales_Amount) AS Total_Sales_AMT
FROM sales 
WHERE Product_Name IS NOT NULL
GROUP BY Product_Name
ORDER BY Total_Sales_AMT DESC
LIMIT 10;

# ORDER COUNTS BY PRODUCTS --
SELECT
    Product_Name,
    COUNT(*) AS Total_Orders
FROM sales
WHERE Product_Name IS NOT NULL
      AND LOWER(Product_Name) <> 'unknown'
GROUP BY Product_Name
ORDER BY Total_Orders DESC;

------------------------------------------------------------------------------------------------------

## CATEGORY ANALYSIS
SELECT Category FROM sales GROUP BY Category;

# CATEGORY PERFORMANCE --
SELECT Category,
    SUM(Sales_Amount) AS Total_Sales_AMT
FROM sales
WHERE Category IS NOT NULL
GROUP BY Category
ORDER BY Total_Sales_AMT DESC
LIMIT 4;

# ORDER COUNTS BY CATEGORY --
SELECT
    Category,
    COUNT(*) AS Total_Orders
FROM sales
WHERE Category IS NOT NULL
GROUP BY Category
ORDER BY Total_Orders DESC
LIMIT 4;

-----------------------------------------------------------------------------------------------------

## SALES CHANNEL ANALYSIS 
SELECT Sales_Channel FROM sales GROUP BY Sales_Channel;

# TOTAL SALES BY SALES CHANNEL --
SELECT TRIM(LOWER(Sales_Channel)) AS Sales_Channel,
	 SUM(Sales_Amount) AS Total_Sales_AMT,
     COUNT(Order_ID) AS Order_Counts
FROM sales 
WHERE Sales_Channel IS NOT NULL
      AND LOWER(Sales_Channel) <> 'unknown'
GROUP BY TRIM(LOWER(Sales_Channel))
ORDER BY Total_sales_AMT DESC;

# AVERAGE ORDER VALUE BY CHANNEL -- 
SELECT
    Sales_Channel,
    ROUND(AVG(Sales_Amount), 2) AS Average_Order_Value
FROM sales
WHERE Sales_Channel IS NOT NULL
  AND TRIM(Sales_Channel) <> ''
GROUP BY Sales_Channel
ORDER BY Average_Order_Value DESC;

-----------------------------------------------------------------------------------------------------

# ORDER STATUS ANALYSIS -- 
SELECT Order_Status FROM sales GROUP BY Order_Status;

# ORDER COUNT ON STATUS --
SELECT Order_Status,
       COUNT(Order_ID) AS Order_Count
FROM sales 
WHERE LOWER(Order_Status) <> 'unknown'
GROUP BY Order_Status
ORDER BY Order_Status DESC;

# SALES AMOUNT BY EACH STATUS;
SELECT Order_Status,
       SUM(Sales_Amount) AS Total_Sales_AMT
FROM sales 
WHERE LOWER(Order_Status) <> 'unknown'
GROUP BY Order_Status
ORDER BY Order_Status DESC;

-------------------------------------------------------------------------------------------------------

## DISCOUNT ANALYSIS
# AVERAGE DISCOUNT BY CATEGORY --
SELECT Category,
    ROUND(AVG(Discount) * 100, 2) AS Average_Discount_Percent
FROM sales
WHERE Category IS NOT NULL
  AND TRIM(Category) <> ''
GROUP BY Category
ORDER BY Average_Discount_Percent DESC;

# SALES BY DISCOUNT LEVEL --
SELECT Discount * 100 AS Discount_Percent,
    COUNT(*) AS Total_Orders,
    SUM(Sales_Amount) AS Total_Sales
FROM sales
GROUP BY Discount
ORDER BY Discount;

# DISCOUNT BY MONTHLY
SELECT
    Order_Month,
    ROUND(SUM(Quantity * Unit_Price * Discount), 2) AS Total_Discount_Amount
FROM sales
GROUP BY Order_Month
ORDER BY Total_Discount_Amount DESC;

--------------------------------------------------------------------------------------------------------

## TOP/BOTTOM CUSTOMERS ANALYSIS
# TOP 10 WITH HIGHEST SALES --
SELECT
    Customer_ID,
    ROUND(SUM(Quantity * Unit_Price), 2) AS Total_Sales_AMT
FROM sales
GROUP BY Customer_ID
ORDER BY Total_Sales_AMT DESC
LIMIT 10 OFFSET 1;

# BOTTOM 10 CUSTOMER ANALYSIS --
SELECT
    Customer_ID,
    ROUND(SUM(Quantity * Unit_Price), 2) AS Total_Sales
FROM sales_orders
GROUP BY Customer_ID
ORDER BY Total_Sales ASC
LIMIT 10;

----------------------------------------------------------------------------------------------------------

## CUSTOMER SEGMENT ANALYSIS 
 SELECT Customer_Segment FROM customers GROUP BY Customer_Segment;
 
 # TOTAL SALES AMOUNT IN CUSTOMER SEGMENT
 SELECT c.Customer_Segment,
       SUM(s.Sales_Amount) AS Total_Sales_AMT
FROM sales s 
INNER JOIN customers c
ON c.Customer_ID = s.Customer_ID
WHERE LOWER(c.Customer_Segment) <> 'unknown'
GROUP BY c.Customer_Segment
ORDER BY Total_SAles_AMT DESC;

# ORDER COUNT IN EACH CUSTOMER SEGMENT 
SELECT c.Customer_Segment,
      COUNT(Order_ID) AS Order_Count
FROM sales s 
INNER JOIN customers c
ON c.Customer_ID = s.Customer_ID
WHERE LOWER(c.Customer_Segment) <> 'unknown'
GROUP BY c.Customer_Segment
ORDER BY Order_Count DESC;

-------------------------------------------------------------------------------------------------------------

## KPI 

#TOTAL SALES 
SELECT ROUND(SUM(Quantity * Unit_Price), 2) AS Total_Sales
FROM sales;

# TOTAL ORDERS
SELECT COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales;

# TOTAL CUSTOMERS 
SELECT COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM sales;

# TOTAL PRODUCTS 
SELECT COUNT(DISTINCT Product_Name) AS Total_Products
FROM sales;




