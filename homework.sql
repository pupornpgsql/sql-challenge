CREATE DATABASE sql_challenge_db
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE sql_challenge_db
    IS 'QL Homework - Employee Database: A Mystery in Two Parts';
	

CREATE TABLE public.departments
(
    dept_no character varying,
    dept_name character varying NOT NULL,
    PRIMARY KEY (dept_no)
);

ALTER TABLE public.departments
    OWNER to postgres;
	
	
CREATE TABLE public.titles
(
    title_id character varying NOT NULL,
    title character varying NOT NULL,
    PRIMARY KEY (title_id)
);

ALTER TABLE public.titles
    OWNER to postgres;


CREATE TABLE public.employees
(
    emp_no character varying NOT NULL,
    title_id character varying,
    birth_date date,
    first_name character varying,
    last_name character varying,
    sex character varying(1),
    hire_date date,
    PRIMARY KEY (emp_no)
);

ALTER TABLE public.employees
    OWNER to postgres;

	ALTER TABLE public.employees
    ADD CONSTRAINT employees_titles FOREIGN KEY (title_id)
    REFERENCES public.titles (title_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    NOT VALID;
	
CREATE TABLE public.salaries
(
    emp_no character varying COLLATE pg_catalog."default" NOT NULL,
    salary numeric,
    CONSTRAINT salaries_pkey PRIMARY KEY (emp_no),
    CONSTRAINT salaries_employees FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.salaries
    OWNER to postgres;
	
	
	
-- DROP TABLE public.dept_manager;

CREATE TABLE public.dept_manager
(
    dept_no character varying COLLATE pg_catalog."default" NOT NULL,
    emp_no character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT dept_manager_pk PRIMARY KEY (dept_no, emp_no),
    CONSTRAINT dept_manager_employees FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.dept_manager
    OWNER to postgres;

	

-- DROP TABLE public.dept_emp;

CREATE TABLE public.dept_emp
(
    emp_no character varying COLLATE pg_catalog."default" NOT NULL,
    dept_no character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT dept_emp_pkey PRIMARY KEY (emp_no, dept_no),
    CONSTRAINT dept_departments FOREIGN KEY (dept_no)
        REFERENCES public.departments (dept_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT dept_employees FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.dept_emp
    OWNER to postgres;
	
	
--List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT 
	emp_no AS "employee number"
	, last_name
	, first_name
	, sex
	, salaries.salary
FROM public.employees
JOIN salaries USING(emp_no);



--List first name, last name, and hire date for employees who were hired in 1986.
--Sorted by first_name, last_name
SELECT 
	first_name
	, last_name
	, hire_date
FROM public.employees
WHERE EXTRACT(year from hire_date) = 1986
ORDER BY 
	first_name
	, last_name
;
	
--List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name.
SELECT 
	dept_no AS "department number"
	, dept_name
	, dept_manager.emp_no
	, employees.last_name
	, employees.first_name
FROM public.departments
JOIN public.dept_manager USING(dept_no)
JOIN public.employees USING(emp_no)
;

--List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
SELECT 
	employees.emp_no AS "employee number"
	, employees.last_name
	, employees.first_name
	, public.departments.dept_name

FROM public.employees
JOIN public.dept_emp USING(emp_no)
JOIN public.departments USING(dept_no)
;

--List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT 
	  employees.first_name
	, employees.last_name
	, employees.sex

FROM public.employees
WHERE employees.first_name = 'Hercules' AND employees.last_name LIKE 'B%'
;

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT 
	employees.emp_no AS "employee number"
	, employees.last_name
	, employees.first_name
	, public.departments.dept_name AS "department name"

FROM public.employees
JOIN public.dept_emp USING(emp_no)
JOIN public.departments USING(dept_no)
WHERE public.departments.dept_name='Sales'
;



--List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
--Ordered by department name, last name, first name
SELECT 
	employees.emp_no AS "employee number"
	, employees.last_name
	, employees.first_name
	, public.departments.dept_name AS "department name"

FROM public.employees
JOIN public.dept_emp USING(emp_no)
JOIN public.departments USING(dept_no)
WHERE public.departments.dept_name SIMILAR TO 'Sales|Development'
ORDER BY 
	public.departments.dept_name
	, employees.last_name
	, employees.first_name
;


--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT 
	employees.last_name
	, COUNT(*) AS "count of employee last names"

FROM public.employees
GROUP BY employees.last_name
ORDER BY 
	"count of employee last names" DESC
;

--Using http://www.quickdatabasediagrams.com.
# Modify this code to update the DB schema diagram.
# To reset the sample schema, replace everything with
# two dots ('..' - without quotes).

departments # Table documentation comment 2
-
dept_no PK varchar
dept_name varchar

titles
-
title_id PK varchar
title varchar

employees
----
emp_no PK varchar
title_id varchar FK >- titles.title_id
birth_date date
first_name varchar
last_name varchar
sex varchar(1)
hire_date date

salaries
-
emp_no PK varchar FK >- employees.emp_no
salary numeric

dept_manager
-
dept_no PK varchar FK >- departments.dept_no
emp_no PK varchar FK >- employees.emp_no

dept_emp
-
emp_no PK varchar FK >- employees.emp_no
dept_no PK varchar FK >- departments.dept_no

--Bonus (Optional)
-- Check bonus.jpynb

