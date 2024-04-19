ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


REM ===================================================================== 
REM auditing department data 
REM ===================================================================== 


CREATE OR REPLACE TRIGGER trg_temp_dept_master_audit_ins_udt AFTER 
    INSERT OR UPDATE ON temp_dept_master 
    FOR EACH ROW
/************************
auditing department data
***********************/
BEGIN 
    INSERT INTO temp_dept_master_audit ( 
        dept_id, 
        dept_name, 
        dept_loc, 
        active_flag, 
        created_by, 
        created_date, 
        modified_by, 
        modified_date 
    ) VALUES ( 
        :new.dept_id, 
        :new.dept_name, 
        :new.dept_loc, 
        :new.active_flag, 
        :new.created_by, 
        :new.created_date, 
        :new.modified_by, 
        :new.modified_date 
    ); 
 
EXCEPTION 
    WHEN OTHERS THEN 
-- Log 
        dbms_output.put_line('Trigger failed "trg_temp_dept_master_audit_ins_udt" - ' 
                             || systimestamp 
                             || to_char(sqlerrm(sqlcode)) 
                             || chr(10) 
                             || dbms_utility.format_error_backtrace); 
END; 
/

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

