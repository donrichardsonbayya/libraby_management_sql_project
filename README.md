# Library Management SQL Project

## Overview

This project simulates a relational database system for managing a library’s core operations — tracking books, customers, rentals, returns, penalties, and inventory changes.

It demonstrates SQL expertise across schema design, stored procedures, triggers, indexing, analytical queries, and advanced SQL concepts such as CTEs and window functions.

---

## Tech Stack

- SQL (MySQL)
- GitHub & GitHub Desktop
- Visual Studio Code

---

## Dataset Summary

| File | Description |
|------|-------------|
| `books.csv` | Book inventory (500 rows across 10 genres) |
| `customers.csv` | Library members with age/gender data |
| `rentals.csv` | 1000 historical rental events |
| `returns.csv` | Return history including late returns |

---

## Database Design

- **4 primary tables**: `books`, `customers`, `rentals`, `returns`
- **2 logging tables** via triggers: `penalty_log`, `book_update_log`
- Enforced constraints, relationships, and normalization

---

## Stored Procedures & Functions

- `rent_book`: Updates rentals and inventory
- `return_book`: Logs return, calculates penalty
- `get_copies_available`: Returns available inventory

---

## Triggers

- `trg_after_return`: Logs penalties into `penalty_log`
- `trg_after_book_update`: Tracks stock changes in `book_update_log`

---

## Indexes

Optimized for performance on:
- Joins (`customer_id`, `book_id`)
- Filters (`rental_date`, `days_late`, `copies_available`)

---

## Sample Queries (Analytics)

- Most rented books and genres
- Customers with frequent late returns
- Books never rented or fully rented
- Monthly rental/return trends
- Penalty totals and averages
- Age-wise genre preferences

---

## Advanced SQL Highlights

- **Common Table Expressions (CTEs)** for modular logic
- **Window Functions** for ranking and partitioning
- **Recursive CTE** demonstration
- **Subqueries and HAVING clauses** for segmentation
- **Multi-join filt**


---

## Project Structure
library_management_sql_project/
├── sample_dataset/
│ ├── books.csv
│ ├── customers.csv
│ ├── rentals.csv
│ └── returns.csv
├── library_db_creation.sql
├── functions_and_procedures.sql
├── triggers.sql
├── indexes.sql
├── sample_queries.sql
└── README.md


---

## How to Use

1. Run `library_db_creation.sql` to create schema
2. Load CSVs into corresponding tables
3. Execute procedures, triggers, and indexes scripts
4. Explore insights using `sample_queries.sql`

---

## Author

**Don Richardson Bayya**  

---

> 💡 This project is part of a growing portfolio to demonstrate real-world SQL applications and analytics.

