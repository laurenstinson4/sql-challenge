--Create tables with headers from CSV files
--Name primary keys and foreign keys using ERD

CREATE TABLE titles (
	title_id VARCHAR(8) NOT NULL,
	title TEXT NOT NULL,
	PRIMARY KEY (title_id)
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
	emp_title_id VARCHAR(8),
	birth_date DATE NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	sex CHAR(1) NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name TEXT NOT NULL,
	PRIMARY KEY (dept_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)	
);


--import data into all tables using PGAdmin import/export tool


--#1
--List the following details of each employee: employee number, 
--last name, first name, sex, and salary.

SELECT employees.emp_no, 
employees.last_name, 
employees.first_name, 
employees.sex,
salaries.salary
FROM employees
INNER JOIN salaries
     ON employees.emp_no = salaries.emp_no;


--#2
--List first name, last name, and hire date for employees who were hired 
--in 1986.

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1986/01/01' AND '1986/12/31';


--#3
--List the manager of each department with the following information:
--department number, department name, the manager's employee number, 
--last name, first name.

SELECT departments.dept_no, 
departments.dept_name, 
employees.emp_no, 
employees.last_name, 
employees.first_name
FROM ((departments
INNER JOIN dept_manager 
	   ON departments.dept_no = dept_manager.dept_no)
INNER JOIN employees 
	  ON dept_manager.emp_no = employees.emp_no);


--#4
--List the department of each employee with the following information: 
--employee number, last name, first name, and department name.

SELECT employees.emp_no, 
employees.last_name, 
employees.first_name,
departments.dept_name
FROM ((departments
INNER JOIN dept_emp
	   ON departments.dept_no = dept_emp.dept_no)
INNER JOIN employees 
	  ON dept_emp.emp_no = employees.emp_no);


--#5
--List first name, last name, and sex for employees whose first name 
--is "Hercules" and last names begin with "B."

SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' and last_name LIKE 'B%';


--#6
--List all employees in the Sales department, including their employee 
--number, last name, first name, and department name.

SELECT employees.emp_no, 
employees.last_name, 
employees.first_name,
departments.dept_name
FROM ((departments
INNER JOIN dept_emp
	   ON departments.dept_no = dept_emp.dept_no)
INNER JOIN employees 
	  ON dept_emp.emp_no = employees.emp_no)
	  WHERE dept_name = 'Sales';


--#7
--List all employees in the Sales and Development departments, including their 
--employee number, last name, first name, and department name.

SELECT employees.emp_no, 
employees.last_name, 
employees.first_name,
departments.dept_name
FROM ((departments
INNER JOIN dept_emp
	   ON departments.dept_no = dept_emp.dept_no)
INNER JOIN employees 
	  ON dept_emp.emp_no = employees.emp_no)
	  WHERE dept_name = 'Sales' OR dept_name = 'Development';


--#8
--In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.

SELECT COUNT(emp_no), last_name
FROM employees
GROUP BY last_name 
ORDER BY COUNT(emp_no) DESC;


