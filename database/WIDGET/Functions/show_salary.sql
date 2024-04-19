ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


REM ===================================================================== 
REM function to return employees salary 
REM ===================================================================== 

CREATE OR REPLACE FUNCTION show_salary ( 
    pi_emp_id NUMBER DEFAULT NULL 
) RETURN CLOB SQL_MACRO IS 
/*************************************************************************************************** 
----Function:		show_salary 
----Description:	It displays salary for passed employee id 
----				uses SQL_MACRO to avoid SQL and PLSQL context switch (Oracle 19c onwards feature) 
----				run as a sql 
----				For a specific EMPLOYEE ID: select * from show_salary ( pi_emp_id => 90002 ); 
----				For all active employees: select * from show_salary (); OR select * from TABLE(show_salary ()); 
----				No result for inactive or missing employee id: select * from show_salary ( pi_emp_id => 900021 ); 
----JIRA:			JIRA-10001 
***************************************************************************************************/ 
BEGIN 
    RETURN q'{ 
     SELECT 
			inn.emp_id, 
			inn.emp_name, 
			inn.salary 
		FROM 
			temp_emp_master inn 
		WHERE 
				1 = 1 
			AND inn.active_flag = 1 
			AND inn.emp_id = nvl(show_salary.pi_emp_id, inn.emp_id) 
  }'; 
END show_salary; 
/

GRANT EXECUTE on show_salary to widget_rw;
GRANT EXECUTE on show_salary to widget_ro;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

