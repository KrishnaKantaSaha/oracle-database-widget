ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


REM ===================================================================== 
REM auditing employee data 
REM ===================================================================== 



CREATE OR REPLACE TRIGGER trg_temp_emp_master_audit_ins_udt AFTER 
    INSERT OR UPDATE ON temp_emp_master 
    FOR EACH ROW
/*************************************************
auditing employee data
*************************************************/
BEGIN 
    INSERT INTO temp_emp_master_audit ( 
        emp_id, 
        emp_name, 
        job_title, 
		manager_id, 
        date_hired, 
        salary, 
        dept_id, 
        active_flag, 
        created_by, 
        created_date, 
        modified_by, 
        modified_date 
    ) VALUES ( 
        :new.emp_id, 
        :new.emp_name, 
        :new.job_title, 
        :new.manager_id, 
        :new.date_hired, 
        :new.salary, 
        :new.dept_id, 
        :new.active_flag, 
        :new.created_by, 
        :new.created_date, 
        :new.modified_by, 
        :new.modified_date 
    ); 
 
EXCEPTION 
    WHEN OTHERS THEN 
-- Log 
        dbms_output.put_line('Trigger failed "trg_temp_emp_master_audit_ins_udt" - ' 
                             || systimestamp 
                             || to_char(sqlerrm(sqlcode)) 
                             || chr(10) 
                             || dbms_utility.format_error_backtrace); 
END; 
/

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

