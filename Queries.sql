-- Creating first table EmployeeInfo Table

CREATE    TABLE employeeinfo (
          empid INT PRIMARY KEY,
          empfname VARCHAR(10) NOT NULL,
          emplname VARCHAR(10) NOT NULL,
          department VARCHAR(10) NOT NULL,
          project VARCHAR(5) NOT NULL,
          address VARCHAR(20),
          dob date NOT NULL,
          gender VARCHAR(1) NOT NULL
          );

-- Inserting data in EmployeeInfo Table
INSERT    INTO employeeinfo
VALUES    (1, 'Sanjay', 'Mehra', 'HR', 'P1', 'Hyderabad(HYD)', '1976-12-01', 'M'),
          (2, 'Ananya', 'Mishra', 'Admin', 'P2', 'Delhi(DEL)', '1968-05-02', 'F'),
          (3, 'Rohan', 'Diwan', 'Account', 'P3', 'Mumbai(BOM)', '1980-01-01', 'M'),
          (4, 'Sonia', 'Kulkarni', 'HR', 'P1', 'Hyderabad(HYD)', '1992-05-02', 'F'),
          (5, 'Ankit', 'Kapoor', 'Admin', 'P2', 'Delhi(DEL)', '1994-07-03', 'M');

-- Show all the data 
SELECT    *
FROM      employeeinfo;

-- Creating second table EmployeePosition Table
CREATE    TABLE employeeposition (
          empid INT PRIMARY KEY,
          empposition VARCHAR(10) NOT NULL,
          dateofjoining date NOT NULL,
          salary INT CHECK (salary > 0) NOT NULL,
          FOREIGN key (empid) REFERENCES employeeinfo (empid)
          );

-- Inserting data in EmployeePosition Table
INSERT    INTO employeeposition
VALUES    (1, 'Manager', '2022-05-01', 500000),
          (2, 'Executive', '2022-05-02', 75000),
          (3, 'Manager', '2022-05-01', 90000),
          (4, 'Lead', '2022-05-02', 85000),
          (5, 'Executive', '2022-05-01', 300000);

-- Show all the data 
SELECT    *
FROM      employeeposition;



--Q-1 Write a query to fetch the number of employees working in the department ‘Admin’
SELECT    COUNT(empid) AS admincount
FROM      employeeinfo
WHERE     department = 'Admin';

--Q-2. Write a query to retrieve the first four characters of  EmpLname from the EmployeeInfo table.
SELECT    LEFT(emplname, 4) AS trimmedlname
FROM      employeeinfo;

--Q-3. Write q query to find all the employees whose salary is between 50000 to 100000.
SELECT    e.empfname || ' ' || e.emplname AS name,
          p.salary
FROM      employeeinfo e
JOIN      employeeposition p ON e.empid = p.empid
WHERE     p.salary BETWEEN 50000 AND 100000;

--Q-4. Write a query to find the names of employees that begin with ‘S’
SELECT    empfname AS name
FROM      employeeinfo
WHERE     empfname LIKE 'S%';

--Q-5. Write a query to fetch top N records order by salary. (ex. top 5 records)
SELECT    e.empid,
          e.empfname || ' ' || e.emplname AS name,
          p.salary
FROM      employeeinfo e
JOIN      employeeposition p ON e.empid = p.empid
ORDER BY  salary DESC
LIMIT     3;

--Q-6. Write a query to fetch details of all employees excluding the employees with first names, “Sanjay” and “Sonia” from the EmployeeInfo table.
SELECT    *
FROM      employeeinfo
WHERE     empfname NOT IN ('Sanjay', 'Sonia');

--Q-7. Write a query to fetch the department-wise count of employees sorted by department’s count in ascending order.
SELECT    department,
          COUNT(*)
FROM      employeeinfo
GROUP BY  department
ORDER BY  COUNT(department);

--Q-8. Create indexing for any particular field and show the difference in data fetching before and after indexing
EXPLAIN  
ANALYZE  
SELECT    empfname AS name
FROM      employeeinfo
WHERE     empfname = 'Sanjay';

CREATE    INDEX idx_empfname ON employeeinfo (empfname);