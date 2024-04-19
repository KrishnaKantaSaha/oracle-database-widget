ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_OPERATIONS AS 
/********************************************************* 
The package 'PKG_OPERATIONS' specifies: 
-- PROCEDURE ACTION_REVISE_SALARY			: to increase or decrease a salary for an active employee 
-- PROCEDURE ACTION_TRANSFER_EMPLOYEE		: transfes an active employee to a department 
-- PROCEDURE ACTION_ADD_EMPLOYEES			: add new employee[s] 
*********************************************************/ 
	-- Global variables 
	-- WIDGET Ltd. SALARY LIMIT 
    min_sal_limit CONSTANT temp_emp_master.emp_id%TYPE := 2000; 
    max_sal_limit CONSTANT temp_emp_master.emp_id%TYPE := 10000000; 
 
    PROCEDURE action_revise_salary ( 
        pi_emp_id           IN temp_emp_master.emp_id%TYPE, 
        pi_revision_type    IN VARCHAR2, 
        pi_revision_percent IN NUMBER 
    ); 
 
    PROCEDURE action_transfer_employee ( 
        pi_emp_id      IN temp_emp_master.emp_id%TYPE, 
        pi_old_dept_id IN temp_emp_master.dept_id%TYPE DEFAULT NULL, 
        pi_new_dept_id IN temp_emp_master.dept_id%TYPE 
    ); 
 
    PROCEDURE action_add_employees ( 
        pi_emp_data IN temp_emp_tbl_typ 
    ); 
 
END PKG_OPERATIONS; 
/

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


