ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

CREATE TABLE temp_dept_master ( 
    dept_id       NUMBER(5, 0) DEFAULT seq_temp_dept_id.NEXTVAL, 
    dept_name     VARCHAR2(50 CHAR) NOT NULL, 
    dept_loc      VARCHAR2(50 CHAR) NOT NULL, 
    active_flag   NUMBER(1, 0) DEFAULT ON NULL 1, 
    created_by    VARCHAR2(50 CHAR) DEFAULT ON NULL upper(sys_context('USERENV', 'OS_USER')), 
    created_date  DATE DEFAULT ON NULL sysdate, 
    modified_by   VARCHAR2(50 CHAR) DEFAULT ON NULL upper(sys_context('USERENV', 'OS_USER')), 
    modified_date DATE DEFAULT ON NULL sysdate, 
    CONSTRAINT temp_dept_master_pk PRIMARY KEY ( dept_id ) 
);

GRANT SELECT, INSERT, UPDATE, DELETE on temp_dept_master to widget_rw;
GRANT READ on temp_dept_master to widget_ro;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

