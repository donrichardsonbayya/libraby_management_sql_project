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
