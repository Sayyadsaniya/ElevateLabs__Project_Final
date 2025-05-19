CREATE TABLE Retail_Transactions (
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    CostPrice DECIMAL(10,2),
    Price DECIMAL(10,2), -- Selling Price
    TotalAmount DECIMAL(10,2),
    Profit DECIMAL(10,2),
    Season VARCHAR(100),
    TransactionDate DATE,
    Year INT,
    Month INT,
    PaymentMethod VARCHAR(50),
    StoreLocation VARCHAR(100),
    State VARCHAR(100),
    ProductCategory VARCHAR(100),
    DiscountApplied DECIMAL(5,2)
);

--  Profit by Product Category
SELECT 
    ProductCategory,
    SUM(Profit) AS Total_Profit
FROM Retail_Transactions
GROUP BY ProductCategory
ORDER BY Total_Profit DESC;

--  Monthly Sales and Profit Trend
SELECT 
    Year,
    Month,
    SUM(TotalAmount) AS Monthly_Sales,
    SUM(Profit) AS Monthly_Profit
FROM Retail_Transactions
GROUP BY Year, Month
ORDER BY Year, Month;

--  Regional Performance (Sales & Profit by State)
SELECT 
    State,
    SUM(TotalAmount) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM Retail_Transactions
GROUP BY State
ORDER BY Total_Sales DESC;

--  Top 10 Products by Total Profit
SELECT 
    ProductID,
    ProductCategory,
    SUM(Profit) AS Total_Profit
FROM Retail_Transactions
GROUP BY ProductID, ProductCategory
ORDER BY Total_Profit DESC
LIMIT 10;

--  Seasonal Performance Analysis
SELECT 
    Season,
    SUM(TotalAmount) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM Retail_Transactions
GROUP BY Season
ORDER BY Total_Sales DESC;

--  Discount Impact on Profitability
SELECT 
    DiscountApplied,
    COUNT(*) AS Transactions,
    SUM(TotalAmount) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM Retail_Transactions
GROUP BY DiscountApplied
ORDER BY Total_Profit DESC;

--  Most Common Payment Methods
SELECT 
    PaymentMethod,
    COUNT(*) AS Transaction_Count,
    SUM(TotalAmount) AS Total_Sales
FROM Retail_Transactions
GROUP BY PaymentMethod
ORDER BY Transaction_Count DESC;

--  Most Profitable Store Locations
SELECT 
    StoreLocation,
    SUM(TotalAmount) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM Retail_Transactions
GROUP BY StoreLocation
ORDER BY Total_Profit DESC;

-- High-Value Customers (Repeat Purchasers)
SELECT 
    CustomerID,
    COUNT(*) AS Transaction_Count,
    SUM(TotalAmount) AS Total_Spend
FROM Retail_Transactions
GROUP BY CustomerID
HAVING Transaction_Count > 1
ORDER BY Total_Spend DESC;

--  Average Order Value by Month
SELECT 
    Year,
    Month,
    SUM(TotalAmount) / COUNT(DISTINCT CustomerID) AS Avg_Order_Value
FROM Retail_Transactions
GROUP BY Year, Month
ORDER BY Year, Month;

--  Best-Selling Products by Quantity
SELECT 
    ProductID,
    ProductCategory,
    SUM(Quantity) AS Total_Units_Sold
FROM Retail_Transactions
GROUP BY ProductID, ProductCategory
ORDER BY Total_Units_Sold DESC
LIMIT 10;

--  Total Revenue Per Year
SELECT 
    Year, 
    SUM(TotalAmount) AS Total_Revenue
FROM Retail_Transactions
GROUP BY Year
ORDER BY Year DESC;

--  High-Value Customers (Top Spenders)
SELECT 
    CustomerID,
    SUM(TotalAmount) AS Total_Spend,
    COUNT(*) AS Transaction_Count
FROM Retail_Transactions
GROUP BY CustomerID
ORDER BY Total_Spend DESC
LIMIT 10;

--  Low-Selling Products (Potential Discontinuation)
SELECT 
    ProductID, 
    ProductCategory, 
    SUM(Quantity) AS Total_Units_Sold
FROM Retail_Transactions
GROUP BY ProductID, ProductCategory
HAVING Total_Units_Sold < 50
ORDER BY Total_Units_Sold ASC;

--  Profit Percentage Per Product Category
SELECT 
    ProductCategory,
    SUM(Profit) / SUM(TotalAmount) * 100 AS Profit_Percentage
FROM Retail_Transactions
GROUP BY ProductCategory
ORDER BY Profit_Percentage DESC;

--  Most Active Sales Months
SELECT 
    Month,
    SUM(TotalAmount) AS Total_Sales
FROM Retail_Transactions
GROUP BY Month
ORDER BY Total_Sales DESC;

--  Repeat vs One-Time Buyers
SELECT 
    CASE 
        WHEN COUNT(*) > 1 THEN 'Repeat Buyer'
        ELSE 'One-Time Buyer'
    END AS Customer_Type,
    COUNT(DISTINCT CustomerID) AS Customer_Count
FROM Retail_Transactions
GROUP BY Customer_Type;
