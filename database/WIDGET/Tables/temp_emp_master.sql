ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

CREATE TABLE temp_emp_master ( 
    emp_id        NUMBER(10, 0) DEFAULT seq_temp_emp_id.NEXTVAL, 
    emp_name      VARCHAR2(50 CHAR) NOT NULL, 
    job_title     VARCHAR2(50 CHAR) NOT NULL, 
	manager_id    NUMBER(10, 0), 
    date_hired    DATE NOT NULL, 
    salary        NUMBER(10, 0) NOT NULL, 
	dept_id       NUMBER(5, 0) NOT NULL, 
    active_flag   NUMBER(1, 0) DEFAULT ON NULL 1, 
    created_by    VARCHAR2(50 CHAR) DEFAULT ON NULL upper(sys_context('USERENV', 'OS_USER')), 
    created_date  DATE DEFAULT ON NULL sysdate, 
    modified_by   VARCHAR2(50 CHAR) DEFAULT ON NULL upper(sys_context('USERENV', 'OS_USER')), 
    modified_date DATE DEFAULT ON NULL sysdate, 
    CONSTRAINT temp_emp_master_pk PRIMARY KEY ( emp_id ), 
	CONSTRAINT temp_emp_master_fk FOREIGN KEY ( dept_id ) 
        REFERENCES temp_dept_master ( dept_id ) 
);

GRANT SELECT, INSERT, UPDATE, DELETE on temp_emp_master to widget_rw;
GRANT READ on temp_emp_master to widget_ro;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
