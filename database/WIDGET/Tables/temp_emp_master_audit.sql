ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

CREATE TABLE temp_emp_master_audit ( 
    emp_id        NUMBER(10, 0), 
    emp_name      VARCHAR2(50 CHAR), 
    job_title     VARCHAR2(50 CHAR), 
	manager_id    NUMBER(10, 0), 
    date_hired    DATE, 
    salary        NUMBER(10, 0), 
	dept_id       NUMBER(5, 0), 
    active_flag   NUMBER(1, 0), 
    created_by    VARCHAR2(50 CHAR), 
    created_date  DATE, 
    modified_by   VARCHAR2(50 CHAR), 
    modified_date DATE, 
	audit_date	  TIMESTAMP(6) WITH TIME ZONE DEFAULT ON NULL SYSTIMESTAMP, 
	audit_seq	  NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 START WITH 1  
);

GRANT SELECT, INSERT, UPDATE, DELETE on temp_emp_master_audit to widget_rw;
GRANT READ on temp_emp_master_audit to widget_ro;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
