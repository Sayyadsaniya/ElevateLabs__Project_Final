
-- Step 1: Remove incomplete rows
DELETE FROM Retail_Transaction_Dataset
WHERE Quantity IS NULL OR Price IS NULL OR TotalAmount IS NULL;

-- Step 2: Add calculated fields
ALTER TABLE Retail_Transaction_Dataset
ADD COLUMN Estimated_Cost DECIMAL(10,2),
ADD COLUMN Profit DECIMAL(10,2),
ADD COLUMN Profit_Margin DECIMAL(5,2);

-- Step 3: Calculate cost, profit, and margin
UPDATE Retail_Transaction_Dataset
SET Estimated_Cost = ROUND(Price * 0.75, 2),
    Profit = ROUND((Price - Estimated_Cost) * Quantity, 2),
    Profit_Margin = ROUND(((Price - Estimated_Cost) / Price) * 100, 2);

-- Step 4: Profitability by product category
SELECT 
    ProductCategory,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Avg_Profit_Margin,
    SUM(Quantity) AS Total_Units_Sold
FROM Retail_Transaction_Dataset
GROUP BY ProductCategory
ORDER BY Total_Profit ASC;

-- Step 5: Seasonal/monthly profit trends
SELECT 
    MONTH(STR_TO_DATE(TransactionDate, '%m/%d/%Y %H:%i')) AS Month,
    ProductCategory,
    SUM(Profit) AS Monthly_Profit
FROM Retail_Transaction_Dataset
GROUP BY Month, ProductCategory
ORDER BY Month;

-- Step 6: High discount, low-margin detection
SELECT 
    ProductID,
    ProductCategory,
    AVG(`DiscountApplied(%)`) AS Avg_Discount,
    AVG(Profit_Margin) AS Avg_Margin
FROM Retail_Transaction_Dataset
GROUP BY ProductID, ProductCategory
HAVING Avg_Discount > 15 AND Avg_Margin < 20
ORDER BY Avg_Discount DESC;

-- Step 7: State-wise performance (from StoreLocation)
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(StoreLocation, ',', -1), ' ', 2) AS State,
    SUM(Profit) AS State_Profit,
    COUNT(*) AS Transactions
FROM Retail_Transaction_Dataset
GROUP BY State
ORDER BY State_Profit DESC;
