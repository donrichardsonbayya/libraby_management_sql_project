USE library_db;

-- 1. Table: penalty_log (tracks late returns)
CREATE TABLE IF NOT EXISTS penalty_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    return_id INT,
    customer_id INT,
    book_id INT,
    days_late INT,
    penalty_amount DECIMAL(10,2),
    log_time DATETIME
);

-- Trigger: After a return is inserted, log penalties if applicable
DELIMITER $$
CREATE TRIGGER trg_after_return
AFTER INSERT ON returns
FOR EACH ROW
BEGIN
    DECLARE cust_id INT;
    DECLARE b_id INT;

    SELECT customer_id, book_id INTO cust_id, b_id
    FROM rentals
    WHERE rental_id = NEW.rental_id;

    IF NEW.days_late > 0 THEN
        INSERT INTO penalty_log(return_id, customer_id, book_id, days_late, penalty_amount, log_time)
        VALUES (
            NEW.return_id,
            cust_id,
            b_id,
            NEW.days_late,
            NEW.days_late * 5.00,  -- ₹5 penalty per day late
            NOW()
        );
    END IF;
END$$
DELIMITER ;

-- 2. Table: book_update_log (tracks changes in copies_available)
CREATE TABLE IF NOT EXISTS book_update_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    old_copies INT,
    new_copies INT,
    update_time DATETIME
);

-- Trigger: After book copies are updated
DELIMITER $$
CREATE TRIGGER trg_after_book_update
AFTER UPDATE ON books
FOR EACH ROW
BEGIN
    IF OLD.copies_available <> NEW.copies_available THEN
        INSERT INTO book_update_log(book_id, old_copies, new_copies, update_time)
        VALUES (
            NEW.book_id,
            OLD.copies_available,
            NEW.copies_available,
            NOW()
        );
    END IF;
END$$
DELIMITER ;
