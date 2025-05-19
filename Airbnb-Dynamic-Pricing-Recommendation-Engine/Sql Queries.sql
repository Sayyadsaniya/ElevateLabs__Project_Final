-- 1. Average Price by Neighbourhood Group
SELECT neighbourhood_group, AVG(price) AS avg_price
FROM listings
WHERE price > 0
GROUP BY neighbourhood_group;

-- 2. Room Type Distribution
SELECT room_type, COUNT(*) AS total_listings
FROM listings
GROUP BY room_type;

-- 3. Reviews vs Price for Scatter Chart
SELECT number_of_reviews, price
FROM listings
WHERE number_of_reviews > 0 AND price < 1000;

-- 4. Geographic Map Data
SELECT latitude, longitude, price
FROM listings
WHERE price > 0;

-- 5. Top 10 Most Profitable Cities (Total Revenue Proxy)
SELECT city, 
       SUM(price * minimum_nights) AS estimated_revenue,
       COUNT(*) AS total_listings
FROM listings
GROUP BY city
ORDER BY estimated_revenue DESC
LIMIT 10;

-- 6. Average Price and Review Score by Room Type and City
SELECT city, room_type, 
       AVG(price) AS avg_price, 
       AVG(number_of_reviews) AS avg_reviews
FROM listings
GROUP BY city, room_type
ORDER BY city, avg_price DESC;

-- 7. Monthly Review Activity Trend
SELECT DATE_TRUNC('month', last_review) AS review_month,
       COUNT(*) AS reviews_count
FROM listings
WHERE last_review IS NOT NULL
GROUP BY review_month
ORDER BY review_month;

-- 8. High Availability Listings (Potential Business Focus)
SELECT id, name, city, room_type, availability_365
FROM listings
WHERE availability_365 = 365
ORDER BY price DESC
LIMIT 20;

-- 9. Overpriced Listings Flag (Price Outliers)
SELECT id, name, city, price, room_type
FROM listings
WHERE price > 1000
ORDER BY price DESC;
