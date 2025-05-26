USE library_db;

-- Index for rentals  by customer
CREATE INDEX idx_rentals_customer_id ON rentals(customer_id);

-- Index for rentals by book
CREATE INDEX idx_rentals_book_id ON rentals(book_id);

-- Index for rental_date queries (e.g., recent activity)
CREATE INDEX idx_rentals_rental_date ON rentals(rental_date);

-- Index for returns by rental
CREATE INDEX idx_returns_rental_id ON returns(rental_id);

-- Index for penalty lookups
CREATE INDEX idx_returns_days_late ON returns(days_late);

-- Index for checking available books
CREATE INDEX idx_books_copies_available ON books(copies_available);
