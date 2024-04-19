ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


REM ===================================================================== 
REM procedure to provide report about department count of employees and salary
REM ===================================================================== 

CREATE OR REPLACE PROCEDURE get_department_wise_details ( 
    pi_dept_id   IN temp_dept_master.dept_id%TYPE DEFAULT NULL, 
    pi_dept_name IN temp_dept_master.dept_name%TYPE DEFAULT NULL, 
    po_cur_data  OUT SYS_REFCURSOR 
) AS 
/*************************************************************************************************** 
----Procedure:		GET_DEPARTMENT_WISE_DETAILS 
----Description:	Get department wise total salary, employee count, and employee_names 
----				Parameter: 
----				pi_dept_id: department id 
----				pi_dept_name: department name 
----				For all departments: GET_DEPARTMENT_WISE_EMPLOYEES( PO_CUR_DATA => PO_CUR_DATA ); 
----				For a specfic department_id: GET_DEPARTMENT_WISE_EMPLOYEES( PI_DEPT_ID => PI_DEPT_ID, PO_CUR_DATA => PO_CUR_DATA ); 
----				For a specfic department_name: GET_DEPARTMENT_WISE_EMPLOYEES( PI_DEPT_NAME => PI_DEPT_NAME, PO_CUR_DATA => PO_CUR_DATA ); 
----				Based on both department_id & department_name: GET_DEPARTMENT_WISE_EMPLOYEES( PI_DEPT_ID => PI_DEPT_ID, PI_DEPT_NAME => PI_DEPT_NAME, PO_CUR_DATA => PO_CUR_DATA ); 
----JIRA:			JIRA-10001 
***************************************************************************************************/ 
BEGIN 
    OPEN po_cur_data FOR SELECT 
                             dept.dept_id            department_id, 
                             dept.dept_name          department_name, 
                             dept.dept_loc           department_location, 
                             nvl(SUM(emp.salary), 0) department_total_salary, 
                             COUNT(emp.emp_id)       count#_employees, 
                             LISTAGG(ALL emp.emp_name, ', ' ON OVERFLOW TRUNCATE '...' WITH COUNT) WITHIN GROUP( 
                             ORDER BY 
                                 emp.emp_id 
                             )                       employees 
                         FROM 
                             temp_dept_master dept 
                             LEFT JOIN temp_emp_master  emp ON ( dept.dept_id = emp.dept_id ) 
                         WHERE 
                                 1 = 1 
                             AND dept.dept_id = nvl(pi_dept_id, dept.dept_id) 
                             AND dept.dept_name = nvl(pi_dept_name, dept.dept_name) 
                             AND dept.active_flag = 1 
                             AND nvl(emp.active_flag, 1) = 1 
                         GROUP BY 
                             dept.dept_id, 
                             dept.dept_name, 
                             dept.dept_loc; 
 
EXCEPTION 
    WHEN OTHERS THEN 
-- Log 
        dbms_output.put_line('Procedure failed "get_department_wise_details" - ' 
                             || systimestamp 
                             || to_char(sqlerrm(sqlcode)) 
                             || chr(10) 
                             || dbms_utility.format_error_backtrace); 
END get_department_wise_details; 
/

GRANT EXECUTE on get_department_wise_details to widget_rw;
GRANT EXECUTE on get_department_wise_details to widget_ro;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

