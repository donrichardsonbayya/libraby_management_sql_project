-- Create Database
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Table: Books
CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    copies_available INT CHECK (copies_available >= 0)
);

-- Table: Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    age INT CHECK (age BETWEEN 5 AND 120)
);

-- Table: Rentals
CREATE TABLE rentals (
    rental_id INT PRIMARY KEY,
    customer_id INT,
    book_id INT,
    rental_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Table: Returns
CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    rental_id INT,
    return_date DATE,
    days_late INT DEFAULT 0,
    FOREIGN KEY (rental_id) REFERENCES rentals(rental_id)
);
