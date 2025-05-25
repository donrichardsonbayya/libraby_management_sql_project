USE library_db;

-- 1. Procedure: Rent a book
DELIMITER $$
CREATE PROCEDURE rent_book(IN p_customer_id INT, IN p_book_id INT)
BEGIN
    DECLARE available_copies INT;

    SELECT copies_available INTO available_copies
    FROM books
    WHERE book_id = p_book_id;

    IF available_copies > 0 THEN
        INSERT INTO rentals (customer_id, book_id, rental_date)
        VALUES (p_customer_id, p_book_id, CURDATE());

        UPDATE books
        SET copies_available = copies_available - 1
        WHERE book_id = p_book_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book not available for rent';
    END IF;
END$$
DELIMITER ;

-- 2. Procedure: Return a book
DELIMITER $$
CREATE PROCEDURE return_book(IN p_rental_id INT)
BEGIN
    DECLARE rental_day DATE;
    DECLARE days_late INT;

    SELECT rental_date INTO rental_day
    FROM rentals
    WHERE rental_id = p_rental_id;

    SET days_late = DATEDIFF(CURDATE(), rental_day) - 14;

    INSERT INTO returns (rental_id, return_date, days_late)
    VALUES (p_rental_id, CURDATE(), IF(days_late > 0, days_late, 0));

    UPDATE books
    SET copies_available = copies_available + 1
    WHERE book_id = (
        SELECT book_id FROM rentals WHERE rental_id = p_rental_id
    );
END$$
DELIMITER ;

-- 3. Function: Check copies available
DELIMITER $$
CREATE FUNCTION get_copies_available(p_book_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE copies INT;

    SELECT copies_available INTO copies
    FROM books
    WHERE book_id = p_book_id;

    RETURN copies;
END$$
DELIMITER ;
