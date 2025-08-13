select * from books;
select * from members;
select * from issued_status;
select * from return_status;
select * from employees;
select * from branch;


-- Task 1. Create a New Book Record 
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books(isbn, book_title, category, rental_price, status, author, publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

-- Task 2: Update an Existing Member's Address
update members
set member_address = '125 Oak St'
where member_id = 'C103';

-- Delete a Record from the Issued Status Table
-- Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issued_status
where issued_id = 'IS121'

-- Select all books issued by the employee with emp_id = 'E101'.
select *
from issued_status
where issued_emp_id='E101'

-- Find members who have issued more than one book.
select issued_member_id, count(*) as books_issued
from issued_status
group by issued_member_id
having count(*) > 1
order by books_issued desc

-- Creates a table showing each book’s ISBN, title, and how many times it was issued.
create table book_issued_cnt as
select books.isbn, books.book_title, count(issued_status.issued_id) as issued_count
from books
join issued_status on books.isbn = issued_status.issued_book_isbn
group by books.isbn, books.book_title
order by issued_count desc

select * from book_issued_cnt;

-- Data Analysis & Findings
-- Retrieve All Books from Category 'Classic'
select * from books 
where category='Classic'

-- Find total rental income and total issued books per category
select books.category, sum(rental_price) as rental_income, count(*) as books_issued
from books
join issued_status on issued_status.issued_book_isbn = books.isbn
group by books.category
order by rental_income desc

-- List Members Who Registered in the Last 180 Days
select * from members
where reg_date >= current_date - interval '180 days';

-- List Employees with Their Branch Manager's Name and their branch details
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id

-- Create a Table of Books with Rental Price Above a Certain Threshold

create table expensive_books as
select * from books where rental_price > 
(select avg(rental_price) from books);

select * from expensive_books;

-- Retrieve the List of Books Not Yet Returned
select i.issued_book_name, i.issued_id from issued_status i
left join return_status r on i.issued_id = r.issued_id
where r.issued_id is null

-- Advanced SQL Operations
-- Finds all members who have not returned books within 30 days and show how many days they are overdue.
select m.member_id, m.member_name, 
i.issued_book_name, i.issued_date,
r.return_date,
(r.return_date - i.issued_date - 30) as days_overdue
from members m
join issued_status i on i.issued_member_id = m.member_id
join return_status r on r.issued_id = i.issued_id
where (r.return_date - i.issued_date) > 30;

-- For every book that has a return entry in return_status, change its status in books to ‘Yes’
select * from return_status
select * from issued_status
select * from books	

UPDATE books
SET status = 'Yes'
WHERE isbn IN (
    SELECT i.issued_book_isbn
    FROM issued_status i
    INNER JOIN return_status r ON i.issued_id = r.issued_id
);

-- Create a report showing each branch’s total books issued, books returned, and rental income.

select
b.branch_id,
count(i.issued_id) as books_issued, 
count(r.return_id) as books_returned, 
sum(bk.rental_price) as rental_income
from issued_status as i
join employees as e on e.emp_id = i.issued_emp_id  
join branch as b on e.branch_id = b.branch_id
left join return_status as r on r.issued_id = i.issued_id
join books as bk on i.issued_book_isbn = bk.isbn
group by b.branch_id

-- Create a new table active_members containing members who issued at least one book in the last 2 months using CTAS.

create table as active_members
SELECT *
FROM members
JOIN issued_status ON members.member_id = issued_status.issued_member_id
WHERE issued_status.issued_date >= CURRENT_DATE - INTERVAL '2 months';

-- Find the top 3 employees who issued the most books, showing their name, books processed, and branch.

select
e.emp_name, e.branch_id,
count(i.issued_id) as books_issued
from employees as e
join issued_status as i on i.issued_emp_id = e.emp_id
group by e.emp_name, e.branch_id
order by books_issued desc
limit 3

-- Questions
-- List all books with their current status and rental price.
select book_title, status, rental_price from books

-- Find the total number of members registered each year.
select count(*) as members_registered , extract(year from reg_date) as reg_year from members 
group by reg_year
order by members_registered desc

-- Show the names of employees along with the branch address where they work.
select e.emp_name, b.branch_address
from employees as e
join branch b on e.branch_id = b.branch_id

-- Find all books issued but not yet returned
select i.issued_id, i.issued_book_name
from issued_status as i
left join return_status as r on r.issued_id = i.issued_id
where r.issued_id is null

-- List members who have issued more than 3 books.
select m.*, count(i.issued_id) as books_issued 
from members as m
join issued_status as i on i.issued_member_id = m.member_id
group by m.member_id
having count(i.issued_id) > 3
order by books_issued desc

-- Find the employee who has issued the most books.
select e.*, count(i.issued_id) as books_issued
from employees as e
join issued_status as i on i.issued_emp_id = e.emp_id
group by e.emp_id
order by books_issued desc
limit 1;

-- Calculate the average salary of employees in each branch.
select avg(salary) as avg_salary, branch_id
from employees
group by branch_id
order by avg_salary desc

-- Find the branch that has issued the highest number of books.
select e.branch_id, count(i.issued_id) as books_issued
from employees as e
join issued_status as i on i.issued_emp_id = e.emp_id
group by e.branch_id
order by books_issued desc

-- List the details of books that have never been issued.
select bk.* from books as bk
left join issued_status as i on bk.isbn = i.issued_book_isbn
where i.issued_book_isbn is null

-- Show the total rental price for all books issued by each employee.
select i.issued_emp_id, sum(bk.rental_price) as rental_price
from issued_status as i
join books as bk on bk.isbn = i.issued_book_isbn
group by i.issued_emp_id
order by rental_price desc

-- Retrieve the list of members along with the number of books they have returned
select 
    m.member_id,
    m.member_name,
    count(r.issued_id) as books_returned
from members m
join issued_status i 
    on i.issued_member_id = m.member_id
join return_status r 
    on r.issued_id = i.issued_id
group by m.member_id, m.member_name
order by books_returned desc;

-- Find the top 5 most frequently issued book titles.
select issued_book_name, count(issued_id) as issue_frequency
from issued_status
group by issued_book_name
order by issue_frequency desc
limit 5

-- Show the details of members who have never returned any book.
select
m.*
from members as m
join issued_status as i on i.issued_member_id = m.member_id
left join return_status as r on r.issued_id = i.issued_id
where r.issued_id is null

-- Find the overdue books assuming books should be returned within 30 days of issue date.

SELECT 
    bk.*,
    i.issued_date,
    r.return_date,
	(r.return_date - i.issued_date) as overdue
FROM books AS bk
JOIN issued_status AS i 
    ON i.issued_book_isbn = bk.isbn
JOIN return_status AS r 
    ON r.issued_id = i.issued_id
WHERE (r.return_date - i.issued_date) > 30;

-- find the average rental price for each category
SELECT 
    category, 
    ROUND(AVG(rental_price)::numeric, 2) AS avg_price
FROM books
GROUP BY category
ORDER BY avg_price DESC;

-- Show the number of books issued per month for the current year.
select * from books
select * from issued_status

select count(issued_book_name) as books_count,
extract(month from issued_date) as issued_month
from issued_status
WHERE EXTRACT(YEAR FROM issued_date) = extract(year from current_date)
group by issued_month
order by books_count

-- Display employees earning above the average salary of their branch.
select * from employees;

with high_salary_emp as (
	select 
	branch_id,
	emp_id,
	emp_name,
	salary,
	avg(salary) over(partition by branch_id) as avg_salary
	from employees
)
select * from high_salary_emp
where salary > avg_salary

-- Retrieve books issued in the last 7 days along with the issuing employee's name.
SELECT
    i.issued_book_isbn,
    i.issued_book_name,
    e.emp_name
FROM issued_status AS i
JOIN employees AS e 
    ON e.emp_id = i.issued_emp_id
WHERE i.issued_date >= current_date - INTERVAL '7 days';

-- Find the member who spent the most on rental prices (sum of rental_price for all issued books).
select
m.member_id, m.member_name,
sum(bk.rental_price) as total_spent
from members as m
join issued_status as i on i.issued_member_id = m.member_id
join books as bk on bk.isbn = i.issued_book_isbn
group by m.member_id, m.member_name
order by total_spent desc
limit 1

-- Show branches with no employees assigned
SELECT 
    b.branch_id,
    b.branch_address
FROM branch AS b
LEFT JOIN employees AS e 
    ON e.branch_id = b.branch_id
WHERE e.branch_id IS NULL;







