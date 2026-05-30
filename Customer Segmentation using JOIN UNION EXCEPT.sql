/* Categorizing the customers according to their activity level. 
Returns a column with the customer IDs and a column 
with the type of each one's activity (Order + Review, Order, Review, No Activity)
*/

-- Customers with both orders and reviews
SELECT
    c.customer_id,
    'Order + Review' AS activity
FROM dbo.customers c
JOIN dbo.orders o
    ON c.customer_id = o.customer_id
JOIN dbo.reviews r
    ON c.customer_id = r.customer_id

UNION

-- Customers with only orders
SELECT
    c.customer_id,
    'Order' AS activity
FROM dbo.customers c
JOIN dbo.orders o
    ON c.customer_id = o.customer_id
EXCEPT
SELECT
    c.customer_id,
    'Order'
FROM dbo.customers c
JOIN dbo.reviews r
    ON c.customer_id = r.customer_id

UNION

-- Customers with only reviews
SELECT
    c.customer_id,
    'Review' AS activity
FROM dbo.customers c
JOIN dbo.reviews r
    ON c.customer_id = r.customer_id
EXCEPT
SELECT
    c.customer_id,
    'Review'
FROM dbo.customers c
JOIN dbo.orders o
    ON c.customer_id = o.customer_id

UNION

-- Customers with no activity
SELECT
    c.customer_id,
    'No Activity' AS activity
FROM dbo.customers c
WHERE c.customer_id NOT IN (SELECT customer_id FROM dbo.orders)
  AND c.customer_id NOT IN (SELECT customer_id FROM dbo.reviews);



