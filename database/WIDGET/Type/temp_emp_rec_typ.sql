ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

CREATE OR REPLACE TYPE temp_emp_rec_typ AS OBJECT ( 
    emp_name   VARCHAR2(50 CHAR), 
    job_title  VARCHAR2(50 CHAR), 
    manager_id NUMBER(10, 0), 
    date_hired DATE, 
    salary     NUMBER(10, 0), 
    dept_id    NUMBER(5, 0) 
); 
/

GRANT EXECUTE on temp_emp_rec_typ to widget_rw;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
