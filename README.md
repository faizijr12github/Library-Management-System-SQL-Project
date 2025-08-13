# 📚 Library Management System – SQL Project

## 📖 Overview
This project is a **Library Management System** built entirely with SQL to simulate and analyze library operations.  
It manages books, members, employees, branches, issue/return tracking, and rental incomes — and performs **data analysis** to generate valuable business insights.

The project showcases **real-world database design and SQL skills** such as:
- Data insertion, updates, and deletions
- Complex joins & subqueries
- Aggregate functions & grouping
- Common Table Expressions (CTEs)
- Window functions
- Table creation with `CTAS` (Create Table As Select)
- Advanced data analysis queries

---

## 🗄️ Database Structure
The system uses the following main tables:

| Table Name        | Description |
|-------------------|-------------|
| `books`           | Stores details of all books (ISBN, title, category, price, availability, author, publisher) |
| `members`         | Stores member details including registration date and address |
| `issued_status`   | Tracks book issues, including issuing employee and member |
| `return_status`   | Tracks returned books and return dates |
| `employees`       | Stores library employee details such as position, salary, and branch |
| `branch`          | Stores library branch details including manager info |

---

## 🚀 Key SQL Features Implemented

### 1️⃣ CRUD Operations
- **Create** – Add new books, members, and employees  
- **Read** – Retrieve data with filtering, sorting, and aggregation  
- **Update** – Modify member addresses, book statuses, etc.  
- **Delete** – Remove issued records or outdated entries  

### 2️⃣ Business Queries
- Top 3 employees who issued the most books  
- Members who issued more than 3 books  
- Total rental income by category  
- Books never issued  
- Overdue books and days overdue  
- Branch performance (books issued, returned, rental income)  
- Average salary per branch  

### 3️⃣ Analytical Tables (CTAS)
- `book_issued_cnt` – Tracks the number of times each book was issued  
- `expensive_books` – Lists books above average rental price  
- `active_members` – Tracks members active in the last 2 months  

### 4️⃣ Advanced SQL
- **Window Functions** – Average salary comparison within branches  
- **CTEs** – Identify employees with above-average salaries  
- **Date Functions** – Find recent issues, overdue returns, and seasonal trends  
- **Joins** – Combine multiple tables for richer insights  

---

## 📊 Example Insights from Queries
- **Most Popular Book:** Get top 5 most issued book titles  
- **Highest Spending Member:** Find the member who spent the most on rentals  
- **Branch Without Employees:** Detect branches that need staffing  
- **Late Returns:** Identify members delaying returns beyond 30 days  
- **Revenue by Category:** Analyze rental income across genres  

---

## 🛠️ Sample Queries

```sql
-- Find members who have issued more than one book
SELECT issued_member_id, COUNT(*) AS books_issued
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(*) > 1
ORDER BY books_issued DESC;

-- Retrieve books issued but not yet returned
SELECT i.issued_book_name, i.issued_id
FROM issued_status i
LEFT JOIN return_status r ON i.issued_id = r.issued_id
WHERE r.issued_id IS NULL;

-- Calculate total rental income by book category
SELECT books.category, SUM(rental_price) AS rental_income, COUNT(*) AS books_issued
FROM books
JOIN issued_status ON issued_status.issued_book_isbn = books.isbn
GROUP BY books.category
ORDER BY rental_income DESC;

```
---
💡 Learning Outcomes
From this project, you will:

Understand database schema design for library systems

Write efficient SQL queries for real-world problems

Use aggregate, analytical, and date functions

Create reports for business decision-making

Gain confidence in SQL for data analysis

📂 Project Files
SQL Script → All table creation, insertion, and queries

Sample Data → Simulated library records

Analysis Queries → Business intelligence & reporting SQL

🏆 Use Cases
Library operations tracking

Rental revenue reporting

Staff performance evaluation

Late return penalties

Inventory & demand analysis

🤝 Contribution
Feel free to fork this repository, add more queries, optimize existing ones, or extend the system with new features like:

Fines calculation

Book reservations

Multi-branch inter-library lending

📬 Contact
Author: Muhammad Faizan
Role: Data Analyst & SQL Developer
📧 Email: faizan.jr12@gmail.com
💼 LinkedIn: https://www.linkedin.com/in/muhammad-faizan-074575250/
