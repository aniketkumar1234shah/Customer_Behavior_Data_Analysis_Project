--Q1
select * from customer_cleaned

--Q2
SELECT customer_id, purchase_amount FROM custotomer_cleaned
WHERE discount_applied = 'Yes'
AND purchase_amount >= (
    SELECT AVG(purchase_amount)
    FROM customer_cleaned
)

--Q3
SELECT item_purchased , round(avg(review_rating::numeric),2) as "Average product rating"
from customer_cleaned
group by item_purchased
order by (avg(review_rating)) desc limit 5

--Q4
select shipping_type,
round(avg(purchase_amount),2)
from customer_cleaned
where shipping_type in ('Standard','Express')
group by shipping_type

--Q5
SELECT
subscription_status,
COUNT(customer_id) AS total_customers,
ROUND(AVG(purchase_amount), 2) AS avg_spend,
ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer_cleaned
GROUP BY subscription_status
ORDER BY total_revenue, avg_spend DESC;

--Q6
SELECT
    item_purchased,
    ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
FROM customer_cleaned
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;


--Q7
WITH customer_type AS (
    SELECT
        customer_id,
        previous_purchases,
        CASE
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer_cleaned
)
SELECT
customer_segment,
COUNT(*) AS "Number of Customers"
FROM customer_type
GROUP BY customer_segment;

--Q8
WITH item_counts AS (
    SELECT
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer_cleaned
    GROUP BY category, item_purchased
)

SELECT
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;

--Q9
SELECT
    subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM customer_cleaned
WHERE previous_purchases > 5
GROUP BY subscription_status;

--Q10
SELECT
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM customer_cleaned
GROUP BY age_group
ORDER BY total_revenue DESC;
