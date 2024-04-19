ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

DROP TYPE temp_emp_tbl_typ;

DROP TYPE temp_emp_rec_typ;

DROP PACKAGE pkg_operations;

DROP PROCEDURE get_department_wise_details;

DROP FUNCTION show_salary;

DROP TRIGGER trg_temp_dept_master_audit_ins_udt;

DROP TRIGGER trg_temp_emp_master_audit_ins_udt;

DROP TABLE temp_dept_master_audit CASCADE CONSTRAINTS;

DROP TABLE temp_emp_master_audit CASCADE CONSTRAINTS;

DROP TABLE temp_dept_master CASCADE CONSTRAINTS;

DROP TABLE temp_emp_master CASCADE CONSTRAINTS;

DROP SEQUENCE seq_temp_dept_id;

DROP SEQUENCE seq_temp_emp_id;

PURGE RECYCLEBIN;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


