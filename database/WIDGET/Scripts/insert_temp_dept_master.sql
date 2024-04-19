ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


SET DEFINE OFF;


REM ===================================================================== 
REM inserting department data 
REM ===================================================================== 

insert into temp_dept_master (dept_name, dept_loc) 
with dept_static_insert as 
( 
select 1 rnk, 'Management' name, 'London' location from dual 
union all 
select 2 rnk, 'Engineering' name, 'Cardiff' location from dual 
union all 
select 3 rnk, 'Research & Development' name, 'Edinburgh' location from dual 
union all 
select 4 rnk, 'Sales' name, 'London' location from dual 
) 
select name, location from dept_static_insert 
where (name, location) NOT IN (SELECT dept_name, dept_loc from temp_dept_master) 
order by rnk;

commit;


REM ===================================================================== 
REM Audit table insert if trigger disabled 
REM ===================================================================== 

INSERT INTO temp_dept_master_audit ( dept_id, dept_name, dept_loc, active_flag, created_by, created_date, modified_by, modified_date ) 
    SELECT 
        dept_id, dept_name, dept_loc, active_flag, created_by, created_date, modified_by, modified_date 
    FROM 
        temp_dept_master 
    WHERE 
        NOT EXISTS ( 
            SELECT 
                1 
            FROM 
                temp_dept_master_audit 
            WHERE 
                ROWNUM = 1 
        );

commit;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
