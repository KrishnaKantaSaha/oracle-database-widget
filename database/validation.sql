SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS DY';
ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
SET DEFINE OFF;
SET SQLFORMAT CSV;

/**************************************************************************************************
--Object Validation
**************************************************************************************************/

with master_objects_data as ( 
select 1 row#, 'TABLE' OBJECT_TYPE, 'TEMP_EMP_MASTER' OBJECT_NAME from dual union 
select 2 row#, 'TABLE' OBJECT_TYPE, 'TEMP_EMP_MASTER_AUDIT' OBJECT_NAME from dual union 
select 3 row#, 'TABLE' OBJECT_TYPE, 'TEMP_DEPT_MASTER_AUDIT' OBJECT_NAME from dual union 
select 4 row#, 'TABLE' OBJECT_TYPE, 'TEMP_DEPT_MASTER' OBJECT_NAME from dual union 
select 5 row#, 'INDEX' OBJECT_TYPE, 'TEMP_DEPT_MASTER_PK' OBJECT_NAME from dual union 
select 6 row#, 'INDEX' OBJECT_TYPE, 'TEMP_EMP_MASTER_PK' OBJECT_NAME from dual union 
select 7 row#, 'SEQUENCE' OBJECT_TYPE, 'SEQ_TEMP_EMP_ID' OBJECT_NAME from dual union 
select 8 row#, 'SEQUENCE' OBJECT_TYPE, 'SEQ_TEMP_DEPT_ID' OBJECT_NAME from dual union 
select 9 row#, 'TRIGGER' OBJECT_TYPE, 'TRG_TEMP_EMP_MASTER_AUDIT_INS_UDT' OBJECT_NAME from dual union 
select 10 row#, 'TRIGGER' OBJECT_TYPE, 'TRG_TEMP_DEPT_MASTER_AUDIT_INS_UDT' OBJECT_NAME from dual union 
select 11 row#, 'TYPE' OBJECT_TYPE, 'TEMP_EMP_TBL_TYP' OBJECT_NAME from dual union 
select 12 row#, 'TYPE' OBJECT_TYPE, 'TEMP_EMP_REC_TYP' OBJECT_NAME from dual union 
select 1 row#, 'TABLE' OBJECT_TYPE, 'TEMP_EMP_MASTER' OBJECT_NAME from dual where 1=2 
) 
select 
sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'CURRENT_SCHEMA') db_schema,sysdate, 
master.OBJECT_TYPE 
,COUNT(master.OBJECT_NAME) CNT_TOTAL_OBJECT 
,COUNT(nvl2(local.OBJECT_NAME,local.OBJECT_NAME,NULL)) CNT_OBJECT_PRESENT, listagg(nvl2(local.OBJECT_NAME,local.OBJECT_NAME,NULL),',') WITHIN GROUP (order by row#) OBJECT_PRESENT 
,COUNT(nvl2(local.OBJECT_NAME,NULL,master.OBJECT_NAME)) CNT_OBJECT_MISSING, listagg(nvl2(local.OBJECT_NAME,NULL,master.OBJECT_NAME),',') WITHIN GROUP (order by row#) OBJECT_MISSING 
from master_objects_data master left join dba_objects local 
ON (master.OBJECT_TYPE=local.OBJECT_TYPE and local.OWNER='WIDGET' and master.OBJECT_NAME=local.OBJECT_NAME) 
--WHERE local.OBJECT_NAME is NULL 
group by master.OBJECT_TYPE 
order by CNT_OBJECT_MISSING desc, decode(OBJECT_TYPE,'TABLE',1,'VIEW',2,'INDEX',3,'SEQUENCE',4,'MATERIALIZED VIEW',5,'TRIGGER',6,'PACKAGE',7,'PACKAGE BODY',8,'PROCEDURE',9,'FUNCTION',10,11) 


/**************************************************************************************************
--Count Validation
**************************************************************************************************/

select sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'CURRENT_SCHEMA') db_schema,sysdate,decode(cnt,10,'SUCCESS: all '||cnt||' present','FAILURE: '||cnt||' present') status 
from (select count(1) cnt from TEMP_EMP_MASTER);

select sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'CURRENT_SCHEMA') db_schema,sysdate,decode(cnt,4,'SUCCESS: all '||cnt||' present','FAILURE: '||cnt||' present') status 
from (select count(1) cnt from TEMP_DEPT_MASTER);

select sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'CURRENT_SCHEMA') db_schema,sysdate,decode(cnt,10,'SUCCESS: all '||cnt||' present','FAILURE: '||cnt||' present') status 
from (select count(1) cnt from TEMP_EMP_MASTER_AUDIT);

select sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'CURRENT_SCHEMA') db_schema,sysdate,decode(cnt,4,'SUCCESS: all '||cnt||' present','FAILURE: '||cnt||' present') status 
from (select count(1) cnt from TEMP_DEPT_MASTER_AUDIT);

