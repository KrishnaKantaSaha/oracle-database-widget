ALTER SESSION SET CURRENT_SCHEMA = WIDGET;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

CREATE OR REPLACE 
PACKAGE BODY PKG_OPERATIONS AS 
 
  PROCEDURE action_revise_salary ( 
    pi_emp_id           IN temp_emp_master.emp_id%TYPE, 
    pi_revision_type    IN VARCHAR2, 
    pi_revision_percent IN NUMBER 
) AS 
/*************************************************************************************************** 
----Procedure:		ACTION_REVISE_SALARY 
----Description:	Raise or reduce salary of an employee within the salary limit 
----				Parameter: 
----				pi_emp_id: employee id 
----				pi_revision_type: INCREASE for raise / DECREASE for reducing 
----				pi_revision_percent: PERCENTAGE of revision between number 1 to 100 
 
----				RUN: PKG_OPERATIONS.ACTION_REVISE_SALARY( pi_emp_id => 90001, pi_revision_type => 'INCREASE', pi_revision_percent => 10 ); 
----				RUN: PKG_OPERATIONS.ACTION_REVISE_SALARY( pi_emp_id => 90008, pi_revision_type => 'DECREASE', pi_revision_percent => 10 ); 
----JIRA:			JIRA-10001 
***************************************************************************************************/ 
-- Local variable 
    v_err_msg_out   VARCHAR2(32767) := NULL; 
    v_cur_sal       temp_emp_master.salary%TYPE; 
    v_new_sal       temp_emp_master.salary%TYPE; 
-- TO RAISE VALIDATION ERROR 
    invalid_action EXCEPTION; 
    PRAGMA exception_init ( invalid_action, -20001 ); 
BEGIN 
    dbms_output.enable(NULL); 
    dbms_output.put_line('STARTED PROCEDURE --> action_revise_salary --> START TIME: ' || systimestamp); 
	dbms_output.put_line('RUNNING PROCEDURE --> action_revise_salary --> RUNNING TIME: ' || SYSTIMESTAMP || ' --> PARAM 1 - EMP_ID:''' || pi_emp_id || ''';PARAM 2 - REVISION_TYPE:''' || pi_revision_type || ''';PARAM 3 - REVISION_PERCENT:''' || pi_revision_percent || ''';'); 
 
     
-- Validation Start 
    IF pi_revision_type NOT IN ( 'INCREASE', 'DECREASE' ) THEN 
        v_err_msg_out := v_err_msg_out || q'< INVALID INPUT revision_type - choose amongst 'INCREASE','DECREASE';>'; 
    END IF; 
 
    IF pi_revision_percent NOT BETWEEN 1 AND 100 THEN 
        v_err_msg_out := v_err_msg_out || q'< INVALID INPUT revision_percent - should between range 1 to 100;>'; 
    END IF; 
 
    IF pi_emp_id IS NULL THEN 
        v_err_msg_out := v_err_msg_out || q'< INVALID INPUT EMP_ID - Blank Employee ID;>'; 
    END IF; 
    IF v_err_msg_out IS NOT NULL THEN 
      --FAILURE 
        v_err_msg_out := 'ACTION ERROR:' || v_err_msg_out; 
        raise_application_error(-20001, v_err_msg_out); 
    END IF; 
 
    BEGIN 
        SELECT 
            salary 
        INTO v_cur_sal 
        FROM 
            temp_emp_master 
        WHERE 
                1 = 1 
            AND active_flag = 1 
            AND emp_id = pi_emp_id; 
 
    EXCEPTION 
        WHEN no_data_found THEN 
        --FAILURE 
            v_err_msg_out := v_err_msg_out || ' THE EMP_ID ''' || pi_emp_id || ''' NOT FOUND OR INACTIVE;'; 
        WHEN OTHERS THEN 
        --FAILURE 
            v_err_msg_out := v_err_msg_out || ' ERROR: - ' || sqlcode || ' - ' || sqlerrm; 
    END; 
 
    IF 
        v_err_msg_out IS NULL 
        AND v_cur_sal IS NOT NULL 
    THEN 
        IF pi_revision_type = 'INCREASE' THEN 
            v_new_sal := v_cur_sal * ( 1 + ( pi_revision_percent / 100 ) ); 
        ELSE 
            v_new_sal := v_cur_sal * ( 1 - ( pi_revision_percent / 100 ) ); 
        END IF; 
 
        IF v_new_sal NOT BETWEEN min_sal_limit AND max_sal_limit THEN 
            v_err_msg_out := v_err_msg_out || ' The new salary(' || v_new_sal || ') is not within range limit (' || min_sal_limit || ', ' || max_sal_limit || ');'; 
        END IF; 
 
    END IF; 
 
    IF v_err_msg_out IS NOT NULL THEN 
      --FAILURE 
        v_err_msg_out := 'ACTION ERROR:' || v_err_msg_out; 
        raise_application_error(-20001, v_err_msg_out); 
    END IF; 
-- Validation End 
 
--Main 
--Raise salary 
    UPDATE temp_emp_master 
    SET 
        salary = v_new_sal 
    WHERE 
            1 = 1 
        AND active_flag = 1 
        AND salary = v_cur_sal 
        AND emp_id = pi_emp_id; 
     
    IF SQL%rowcount = 1 THEN 
        COMMIT; 
        dbms_output.put_line('COMPLETED PROCEDURE --> action_revise_salary --> The salary revised for EMP_ID ' || pi_emp_id || ' from '||v_cur_sal||' to '||v_new_sal||' --> END TIME: ' || systimestamp); 
    ELSE 
        --FAILURE 
        v_err_msg_out := 'ACTION ERROR: The salary is not raised'; 
        raise_application_error(-20001, v_err_msg_out); 
    END IF; 
 
EXCEPTION 
    WHEN OTHERS THEN 
        ROLLBACK; 
        v_err_msg_out := NULL; 
        v_err_msg_out := v_err_msg_out || to_char(sqlerrm(sqlcode)); 
        v_err_msg_out := v_err_msg_out || chr(10); 
        v_err_msg_out := v_err_msg_out || dbms_utility.format_error_backtrace; 
		v_err_msg_out := v_err_msg_out||'PARAM 1 - EMP_ID:''' || pi_emp_id ||''''; 
		v_err_msg_out := v_err_msg_out||CHR(10); 
		v_err_msg_out := v_err_msg_out||'PARAM 2 - REVISION_TYPE:''' || pi_revision_type ||''''; 
		v_err_msg_out := v_err_msg_out||CHR(10); 
		v_err_msg_out := v_err_msg_out||'PARAM 3 - REVISION_PERCENT:''' || pi_revision_percent || ''''; 
        dbms_output.put_line('ERROR PROCEDURE --> action_revise_salary --> END TIME: ' || systimestamp); 
        dbms_output.put_line(V_ERR_MSG_OUT); 
  END action_revise_salary; 

  PROCEDURE action_transfer_employee ( 
    pi_emp_id         IN temp_emp_master.emp_id%TYPE, 
    pi_old_dept_id    IN temp_emp_master.dept_id%TYPE DEFAULT NULL, 
    pi_new_dept_id    IN temp_emp_master.dept_id%TYPE 
) AS 
/*************************************************************************************************** 
----Procedure:		ACTION_TRANSFER_EMPLOYEE 
----Description:	Transfer an employee to a different department 
----				Parameter: 
----				pi_emp_id:		employee id 
----				pi_old_dept_id: old department id [OPTIONAL] 
----				pi_new_dept_id: new department id 
 
----				RUN: PKG_OPERATIONS.ACTION_TRANSFER_EMPLOYEE( pi_emp_id => 90001, pi_old_dept_id => 1, pi_new_dept_id => 2 ); 
----				RUN: PKG_OPERATIONS.ACTION_TRANSFER_EMPLOYEE( pi_emp_id => 90001, pi_new_dept_id => 2 ); 
----JIRA:			JIRA-10001 
***************************************************************************************************/ 
-- Local variable 
    v_err_msg_out   VARCHAR2(32767) := NULL; 
	v_dept_id       temp_emp_master.dept_id%TYPE; 
-- TO RAISE VALIDATION ERROR 
    invalid_action EXCEPTION; 
    PRAGMA exception_init ( invalid_action, -20001 ); 
BEGIN 
    dbms_output.enable(NULL); 
    dbms_output.put_line('STARTED PROCEDURE --> action_transfer_employee --> START TIME: ' || systimestamp); 
	dbms_output.put_line('RUNNING PROCEDURE --> action_transfer_employee --> RUNNING TIME: ' || SYSTIMESTAMP || ' --> PARAM 1 - EMP_ID:''' || pi_emp_id || ''';PARAM 2 - OLD_DEPT_ID:''' || pi_old_dept_id || ''';PARAM 3 - NEW_DEPT_ID:''' || pi_new_dept_id || ''';'); 
 
     
-- Validation Start 
    IF pi_new_dept_id IS NULL THEN 
        v_err_msg_out := v_err_msg_out || ' INVALID INPUT NEW_DEPT_ID - Blank Department ID;'; 
    END IF; 
 
    IF pi_emp_id IS NULL THEN 
        v_err_msg_out := v_err_msg_out || ' INVALID INPUT EMP_ID - Blank Employee ID;'; 
    END IF; 
 
    IF pi_new_dept_id = pi_old_dept_id THEN 
        v_err_msg_out := v_err_msg_out || ' INVALID INPUTS DEPT_ID - Cannot transfer between same Department ID;'; 
    END IF; 
	 
	IF pi_new_dept_id IS NOT NULL THEN 
		SELECT COUNT(1) INTO v_dept_id 
		FROM temp_dept_master 
		WHERE 
			1=1 
		AND active_flag = 1 
		AND dept_id = pi_new_dept_id; 
		IF v_dept_id = 0 THEN 
			v_err_msg_out := v_err_msg_out || ' INVALID INPUT NEW DEPT_ID - Inactive or missing Department ID;'; 
		END IF; 
	END IF; 
 
    IF v_err_msg_out IS NOT NULL THEN 
      --FAILURE 
        v_err_msg_out := 'ACTION ERROR:' || v_err_msg_out; 
        raise_application_error(-20001, v_err_msg_out); 
    END IF; 
 
    BEGIN 
        SELECT 
            dept_id 
        INTO v_dept_id 
        FROM 
            temp_emp_master 
        WHERE 
                1 = 1 
            AND active_flag = 1 
            AND emp_id = pi_emp_id; 
 
    EXCEPTION 
        WHEN no_data_found THEN 
        --FAILURE 
            v_err_msg_out := v_err_msg_out || ' THE EMP_ID ''' || pi_emp_id || ''' NOT FOUND OR INACTIVE;'; 
        WHEN OTHERS THEN 
        --FAILURE 
            v_err_msg_out := v_err_msg_out || ' ERROR: - ' || sqlcode || ' - ' || sqlerrm; 
    END; 
 
    IF v_err_msg_out IS NULL THEN 
        IF pi_old_dept_id IS NOT NULL AND v_dept_id <> pi_old_dept_id THEN 
            v_err_msg_out := v_err_msg_out || ' INVALID INPUT OLD_DEPT_ID - The Employee ID ('||pi_emp_id||') is in ('||v_dept_id||') but old department passed as ('||pi_old_dept_id||');'; 
        END IF; 
        IF v_dept_id = pi_new_dept_id THEN 
            v_err_msg_out := v_err_msg_out || ' INVALID INPUT OLD_DEPT_ID - The Employee ID ('||pi_emp_id||') is already in departement ('||pi_new_dept_id||');'; 
        END IF; 
    END IF; 
 
    IF v_err_msg_out IS NOT NULL THEN 
      --FAILURE 
        v_err_msg_out := 'ACTION ERROR:' || v_err_msg_out; 
        raise_application_error(-20001, v_err_msg_out); 
    END IF; 
-- Validation End 
 
--Main 
--Raise salary 
    UPDATE temp_emp_master 
    SET 
        dept_id = pi_new_dept_id 
    WHERE 
            1 = 1 
        AND active_flag = 1 
        AND dept_id <> pi_new_dept_id 
        AND emp_id = pi_emp_id; 
     
    IF SQL%rowcount = 1 THEN 
        COMMIT; 
        dbms_output.put_line('COMPLETED PROCEDURE --> action_transfer_employee --> The EMP_ID ' || pi_emp_id || ' is transferred from '||v_dept_id||' to '||pi_new_dept_id||' --> END TIME: ' || systimestamp); 
    ELSE 
        --FAILURE 
        v_err_msg_out := 'ACTION ERROR: The transferred is not completed'; 
        raise_application_error(-20001, v_err_msg_out); 
    END IF; 
 
EXCEPTION 
    WHEN OTHERS THEN 
        ROLLBACK; 
        v_err_msg_out := NULL; 
        v_err_msg_out := v_err_msg_out || to_char(sqlerrm(sqlcode)); 
        v_err_msg_out := v_err_msg_out || chr(10); 
        v_err_msg_out := v_err_msg_out || dbms_utility.format_error_backtrace; 
		v_err_msg_out := v_err_msg_out||'PARAM 1 - EMP_ID:''' || pi_emp_id ||''''; 
		v_err_msg_out := v_err_msg_out||CHR(10); 
		v_err_msg_out := v_err_msg_out||'PARAM 2 - OLD_DEPT_ID:''' || pi_old_dept_id ||''''; 
		v_err_msg_out := v_err_msg_out||CHR(10); 
		v_err_msg_out := v_err_msg_out||'PARAM 3 - NEW_DEPT_ID:''' || pi_new_dept_id || ''''; 
        dbms_output.put_line('ERROR PROCEDURE --> action_transfer_employee --> END TIME: ' || systimestamp); 
        dbms_output.put_line(V_ERR_MSG_OUT); 
  END action_transfer_employee; 
 
  PROCEDURE action_add_employees ( 
    pi_emp_data IN temp_emp_tbl_typ 
) AS 
/*************************************************************************************************** 
----Procedure:		ACTION_ADD_EMPLOYEES 
----Description:	Validate and add employee[s] 
----				Parameter: 
----				pi_emp_data: a collection or array of new employee 
 
----				RUN: PKG_OPERATIONS.ACTION_ADD_EMPLOYEES ( pi_emp_data => temp_emp_tbl_typ( temp_emp_rec_typ (emp_name  => 'Emp 1', job_title => 'Engineer', manager_id => NULL, date_hired => DATE'2024-01-01', salary  => 30000, dept_id  => 2  ) ) ); 
----				RUN: PKG_OPERATIONS.ACTION_ADD_EMPLOYEES ( pi_emp_data => temp_emp_tbl_typ( temp_emp_rec_typ (emp_name  => 'Emp 2',job_title => 'Engineer',manager_id => 90002,date_hired => DATE'2024-01-01',salary  => 40000,dept_id  => 3  ),temp_emp_rec_typ (emp_name  => 'Emp 3',job_title => 'Engineer',manager_id => 90002,date_hired => DATE'2024-01-01',salary  => 40000,dept_id  => 2  ) ) ); 
----JIRA:			JIRA-10001 
***************************************************************************************************/ 
-- Local variable 
    v_err_msg_out 	VARCHAR2(32767) := NULL; 
    v_success_cnt 	NUMBER := 0; 
    v_temp_cnt 		NUMBER := 0; 
	v_eligible 		BOOLEAN := FALSE; 
	v_valid_emps  	temp_emp_tbl_typ := temp_emp_tbl_typ(); 
-- TO RAISE VALIDATION ERROR 
    invalid_action EXCEPTION; 
    PRAGMA exception_init ( invalid_action, -20001 ); 
BEGIN 
    dbms_output.enable(NULL); 
    dbms_output.put_line('STARTED PROCEDURE --> action_add_employees --> START TIME: ' || systimestamp); 
    dbms_output.put_line('RUNNING PROCEDURE --> action_add_employees --> RUNNING TIME: ' 
                         || systimestamp 
                         || ' --> PARAM 1 - COUNT OF EMPLOYEES:''' 
                         || pi_emp_data.count 
                         || ''''); 
 
     
-- Validation Start 
    IF pi_emp_data.count = 0 THEN 
		--FAILURE 
        v_err_msg_out := 'INVALID INPUT: No employee data passed'; 
        raise_application_error(-20001, v_err_msg_out); 
    END IF; 
	 
	FOR idx in 1 .. pi_emp_data.COUNT LOOP 
		-- validate employee details 
		v_eligible := FALSE; 
		v_eligible := (pi_emp_data(idx).emp_name IS NOT NULL AND pi_emp_data(idx).job_title IS NOT NULL AND pi_emp_data(idx).salary IS NOT NULL AND pi_emp_data(idx).dept_id IS NOT NULL); 
		IF v_eligible THEN 
			-- check valid department and manager 
			SELECT COUNT(1) INTO v_temp_cnt FROM DUAL 
			WHERE 1=1 
			AND EXISTS (SELECT 1 FROM temp_dept_master d WHERE d.active_flag=1 AND d.dept_id = pi_emp_data(idx).dept_id) 
			AND (pi_emp_data(idx).manager_id IS NULL OR EXISTS (SELECT 1 FROM temp_emp_master e WHERE e.active_flag=1 AND e.emp_id = pi_emp_data(idx).manager_id)) 
			AND (pi_emp_data(idx).salary BETWEEN min_sal_limit and max_sal_limit); 
			IF v_temp_cnt = 0 THEN 
				v_eligible := FALSE; --0: False; 1: True 
			END IF; 
		END IF; 
		IF v_eligible THEN 
			-- add the valid employee 
			v_valid_emps.EXTEND; 
			v_valid_emps(v_valid_emps.LAST) := pi_emp_data(idx); 
		ELSE 
			dbms_output.put_line('RUNNING PROCEDURE --> action_add_employees --> skiping employee (' || pi_emp_data(idx).emp_name || ') at position '||idx||'  due to invalid records --> RUNNING TIME: ' || systimestamp); 
		END IF; 
	END LOOP;	 
-- Validation End 
 
--Main 
--Add employee[s] 
	IF v_valid_emps.count > 0 THEN 
		BEGIN 
			FORALL idx IN 1..v_valid_emps.count SAVE EXCEPTIONS --allow valid employee[s] to get added 
				INSERT INTO temp_emp_master ( emp_name, job_title, manager_id, date_hired, salary, dept_id ) 
					VALUES ( v_valid_emps(idx).emp_name, v_valid_emps(idx).job_title, v_valid_emps(idx).manager_id, v_valid_emps(idx).date_hired, v_valid_emps(idx).salary, v_valid_emps(idx).dept_id ); 
 
			v_success_cnt := SQL%rowcount; 
			COMMIT; 
			dbms_output.put_line('RUNNING PROCEDURE --> action_add_employees --> added ' || v_success_cnt || ' employees --> RUNNING TIME: ' || systimestamp); 
		EXCEPTION 
			WHEN OTHERS THEN 
				FOR idx IN 1..SQL%bulk_exceptions.count LOOP 
					v_err_msg_out := 'Error ('|| sqlerrm(-1 * SQL%bulk_exceptions(idx).error_code)|| ') inserting employee ('|| pi_emp_data(SQL%bulk_exceptions(idx).error_index).emp_name|| ')'; 
					dbms_output.put_line('RUNNING PROCEDURE --> action_add_employees --> '|| v_err_msg_out|| ' --> RUNNING TIME: '|| systimestamp); 
					v_err_msg_out := NULL; 
				END LOOP; 
		END; 
	END IF; 
 
    dbms_output.put_line('COMPLETED PROCEDURE --> action_add_employees --> END TIME: ' || systimestamp); 
EXCEPTION 
    WHEN OTHERS THEN 
        ROLLBACK; 
        v_err_msg_out := NULL; 
        v_err_msg_out := v_err_msg_out || to_char(sqlerrm(sqlcode)); 
        v_err_msg_out := v_err_msg_out || chr(10); 
        v_err_msg_out := v_err_msg_out || dbms_utility.format_error_backtrace; 
        v_err_msg_out := v_err_msg_out||'PARAM 1 - COUNT OF EMPLOYEES:''' || pi_emp_data.COUNT ||''''; 
        dbms_output.put_line('ERROR PROCEDURE --> action_add_employees --> END TIME: ' || systimestamp); 
        dbms_output.put_line(v_err_msg_out); 
  END action_add_employees; 
 
END PKG_OPERATIONS; 
/


GRANT EXECUTE on pkg_operations to widget_rw;


------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------



