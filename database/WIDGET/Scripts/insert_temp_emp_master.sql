ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


SET DEFINE OFF;


REM ===================================================================== 
REM inserting employee data 
REM ===================================================================== 

insert into temp_emp_master ( emp_name, job_title, manager_id, date_hired, salary, dept_id ) 
with emp_static_insert as 
( 
select 90001 employee_id, 'John Smith' employee_name, 'CEO' job_title, NULL manager_id, date'1995-01-01' date_hired, 100000 salary, 1 dept_id from dual union all 
select 90002 employee_id, 'Jimmy Wills' employee_name, 'Manager' job_title, 90001 manager_id, date'2003-09-23' date_hired, 52500 salary, 4 dept_id from dual union all 
select 90003 employee_id, 'Roxy Jones' employee_name, 'Salesperson' job_title, 90002 manager_id, date'2017-02-11' date_hired, 35000 salary, 4 dept_id from dual union all 
select 90004 employee_id, 'Selwyn Field' employee_name, 'Salesperson' job_title, 90003 manager_id, date'2015-05-20' date_hired, 32000 salary, 4 dept_id from dual union all 
select 90005 employee_id, 'David Hallet' employee_name, 'Engineer' job_title, 90006 manager_id, date'2018-04-17' date_hired, 40000 salary, 2 dept_id from dual union all 
select 90006 employee_id, 'Sarah Phelps' employee_name, 'Manager' job_title, 90001 manager_id, date'2015-03-21' date_hired, 45000 salary, 2 dept_id from dual union all 
select 90007 employee_id, 'Louise Harper' employee_name, 'Engineer' job_title, 90006 manager_id, date'2013-01-01' date_hired, 47000 salary, 2 dept_id from dual union all 
select 90008 employee_id, 'Tina Hart' employee_name, 'Engineer' job_title, 90009 manager_id, date'2014-07-28' date_hired, 45000 salary, 3 dept_id from dual union all 
select 90009 employee_id, 'Gus Jones' employee_name, 'Manager' job_title, 90001 manager_id, date'2018-05-15' date_hired, 50000 salary, 3 dept_id from dual union all 
select 90010 employee_id, 'Mildred Hall' employee_name, 'Secretary' job_title, 90001 manager_id, date'1996-10-12' date_hired, 35000 salary, 1 dept_id from dual 
) 
select employee_name, job_title, manager_id, date_hired, salary, dept_id from emp_static_insert 
where (employee_name, job_title, NVL(manager_id,-1), date_hired, salary, dept_id) NOT IN (select emp_name, job_title, NVL(manager_id,-1), date_hired, salary, dept_id from temp_emp_master) 
order by employee_id;

commit;


REM ===================================================================== 
REM Audit table insert if trigger disabled 
REM ===================================================================== 

INSERT INTO temp_emp_master_audit (emp_id, emp_name, job_title, manager_id, date_hired, salary, dept_id, active_flag, created_by, created_date, modified_by, modified_date) 
    SELECT 
        emp_id, emp_name, job_title, manager_id, date_hired, salary, dept_id, active_flag, created_by, created_date, modified_by, modified_date 
    FROM 
        temp_emp_master 
    WHERE 
        NOT EXISTS ( 
            SELECT 
                1 
            FROM 
                temp_emp_master_audit 
        );

commit;


------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
