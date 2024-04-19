SET SERVEROUTPUT ON;
SET DEFINE OFF;
ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
----------------------------------------------
@Type\temp_emp_rec_typ.sql
@Type\temp_emp_tbl_typ.sql
@Sequences\seq_temp_dept_id.sql
@Sequences\seq_temp_emp_id.sql
@Tables\temp_dept_master.sql
@Tables\temp_dept_master_audit.sql
@Tables\temp_emp_master.sql
@Tables\temp_emp_master_audit.sql
@Triggers\trg_temp_dept_master_audit_ins_udt.sql
@Triggers\trg_temp_emp_master_audit_ins_udt.sql
@Scripts\insert_temp_dept_master.sql
@Scripts\insert_temp_emp_master.sql
@Procedures\get_department_wise_details.sql
@Functions\show_salary.sql
@Packages\PKG_OPERATIONS_SPEC.sql
@Packages\PKG_OPERATIONS_BODY.sql

----------------------------------------------


