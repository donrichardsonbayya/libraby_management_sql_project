USE library_db;

-- 1. Top 5 most rented books
SELECT b.title, COUNT(*) AS rental_count
FROM rentals r
JOIN books b ON r.book_id = b.book_id
GROUP BY b.title
ORDER BY rental_count DESC
LIMIT 5;

-- 2. Customers who rented the most books
SELECT c.full_name, COUNT(*) AS books_rented
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY books_rented DESC
LIMIT 5;

-- 3. Books with 0 available copies (fully rented out)
SELECT title, copies_available
FROM books
WHERE copies_available = 0;

-- 4. Total penalties collected (₹5/day late)
SELECT SUM(days_late * 5) AS total_penalties_collected
FROM returns
WHERE days_late > 0;

-- 5. Rentals and returns per month (last year)
SELECT
  MONTH(r.rental_date) AS rental_month,
  COUNT(DISTINCT r.rental_id) AS total_rentals,
  COUNT(DISTINCT rt.return_id) AS total_returns
FROM rentals r
LEFT JOIN returns rt ON r.rental_id = rt.rental_id
WHERE r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY rental_month
ORDER BY rental_month;

-- 6. Average age of customers renting books by genre
SELECT b.genre, ROUND(AVG(c.age), 1) AS avg_age
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
JOIN books b ON r.book_id = b.book_id
GROUP BY b.genre
ORDER BY avg_age DESC;

-- 7. Customers who returned books late more than 3 times
SELECT c.full_name, COUNT(rn.days_late) AS late_returns
FROM returns rn
JOIN rentals rt ON rn.rental_id = rt.rental_id
JOIN customers c ON rt.customer_id = c.customer_id
WHERE rn.days_late > 0
GROUP BY c.customer_id
HAVING late_returns > 3
ORDER BY late_returns DESC;

-- 8. Books that have never been rented
SELECT b.book_id, b.title
FROM books b
LEFT JOIN rentals r ON b.book_id = r.book_id
WHERE r.rental_id IS NULL;

-- 9. Customers who rented 5+ different genres
SELECT c.full_name, COUNT(DISTINCT b.genre) AS genre_count
FROM rentals r
JOIN books b ON r.book_id = b.book_id
JOIN customers c ON r.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING genre_count >= 5
ORDER BY genre_count DESC;

-- 10. Most common genre rented each month (last 6 months)
SELECT
  MONTH(r.rental_date) AS rental_month,
  b.genre,
  COUNT(*) AS rental_count
FROM rentals r
JOIN books b ON r.book_id = b.book_id
WHERE r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY rental_month, b.genre
ORDER BY rental_month, rental_count DESC;

-- 11. Average penalty amount per customer
SELECT c.full_name, ROUND(AVG(rn.days_late * 5), 2) AS avg_penalty
FROM returns rn
JOIN rentals rt ON rn.rental_id = rt.rental_id
JOIN customers c ON rt.customer_id = c.customer_id
WHERE rn.days_late > 0
GROUP BY c.customer_id
ORDER BY avg_penalty DESC;

-- 12. Books returned late more than 10 times
SELECT b.title, COUNT(*) AS late_return_count
FROM returns rn
JOIN rentals rt ON rn.rental_id = rt.rental_id
JOIN books b ON rt.book_id = b.book_id
WHERE rn.days_late > 0
GROUP BY b.book_id
HAVING late_return_count > 10
ORDER BY late_return_count DESC;

-- 13. Rental-to-return gap (in days) for each rental
SELECT
  rt.rental_id,
  DATEDIFF(rn.return_date, rt.rental_date) AS rental_duration_days
FROM rentals rt
JOIN returns rn ON rt.rental_id = rn.rental_id
ORDER BY rental_duration_days DESC;

-- 14. CTE: Monthly rental totals using a Common Table Expression
WITH monthly_rentals AS (
    SELECT
        MONTH(rental_date) AS rental_month,
        COUNT(*) AS total_rentals
    FROM rentals
    GROUP BY MONTH(rental_date)
)
SELECT * FROM monthly_rentals
ORDER BY rental_month;

--  15. Window Function: RANK most rented books

SELECT 
    title, 
    COUNT(*) AS total_rentals,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rental_rank
FROM rentals r
JOIN books b ON r.book_id = b.book_id
GROUP BY b.book_id, b.title;

-- 16. Window Function: ROW_NUMBER for each customer’s rentals
SELECT
    customer_id,
    book_id,
    rental_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_sequence
FROM rentals;

-- 17. CTE + Aggregate: Top genre per customer
WITH genre_counts AS (
    SELECT
        r.customer_id,
        b.genre,
        COUNT(*) AS genre_rentals
    FROM rentals r
    JOIN books b ON r.book_id = b.book_id
    GROUP BY r.customer_id, b.genre
)
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY genre_rentals DESC) AS genre_rank
    FROM genre_counts
) ranked
WHERE genre_rank = 1;

-- 18.Recursive CTE (Simulation): Counting down days late
WITH RECURSIVE late_days_counter(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM late_days_counter WHERE n < 10
)
SELECT * FROM late_days_counter;


