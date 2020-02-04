SET SERVEROUTPUT ON 
DECLARE    
    sum_sal  NUMBER(10,2); 
    deptno   NUMBER NOT NULL := 60;           
BEGIN 
    SELECT  SUM(salary)  -- group function 
    INTO sum_sal 
    FROM employees 
    WHERE  department_id = deptno; 
    DBMS_OUTPUT.PUT_LINE ('The sum of salary is ' || sum_sal); 
END; 
--
DECLARE
empno EMPLOYEES.EMPLOYEE_ID%TYPE := 100;
BEGIN
    MERGE INTO copy_emp c
    USING employees e
    ON (e.employee_id = c.EMPLOYEE_ID)
    WHEN MATCHED THEN
    UPDATE SET
        c.first_name = e.first_name,
        c.last_name = e.last_name,
        c.email = e.email,
        c.phone_number = e.phone_number,
        c.hire_date = e.hire_date,
        c.job_id = e.job_id,
        c.salary = e.salary,
        c.commission_pct = e.commission_pct,
        c.manager_id = e.manager_id,
        c.department_id = e.department_id
    WHEN NOT MATCHED THEN
    INSERT VALUES(e.employee_id, e.first_name, e.last_name,
                    e.email, e.phone_number, e.hire_date, e.job_id,
                    e.salary, e.commission_pct, e.manager_id, 
                    e.department_id, E.DEPARTMENT_NAME);
END;
--ROWCOUNT
VARIABLE rows_deleted VARCHAR2(30) 
DECLARE 
    empno employees.employee_id%TYPE := 176; 
BEGIN 
    DELETE FROM COPY_EMP 
    WHERE employee_id = empno; 
    :rows_deleted := (SQL%ROWCOUNT || ' row deleted.'); 
END;
PRINT rows_deleted

--1.departments ���̺��� �ִ� �μ� ID�� �����Ͽ� max_deptno ������ �����ϴ�
--PL/SQL ����� �����մϴ�. �ִ� �μ� ID�� ǥ���մϴ�.
--a. ���� ���ǿ��� NUMBER ������ max_deptno ������ �����մϴ�.
--b. BEGIN Ű����� ���� ������ �����ϰ� departments ���̺��� �ִ�
--department_id�� �˻��ϴ� SELECT ���� ���Խ�ŵ�ϴ�.
--c. max_deptno�� ǥ���ϰ� ���� ����� �����մϴ�.
--d. ��ũ��Ʈ�� �����ϰ� lab_04_01_soln.sql�� �����մϴ�. ������ ���
--����� ������ �����ϴ�.
SELECT * FROM DEPARTMENTS;
DECLARE
    MAX_DEPTNO NUMBER;
BEGIN
    SELECT MAX(DEPARTMENT_ID)
    INTO MAX_DEPTNO
    FROM DEPARTMENTS;
    DBMS_OUTPUT.PUT_LINE(MAX_DEPTNO);
END;
/*2. ���� 1���� ������ PL/SQL ����� departments ���̺� �� �μ��� �����ϵ���
�����մϴ�.
a. ��ũ��Ʈ lab_04_01_soln.sql�� ���ϴ�.
departments.department_name ������ dept_name �� NUMBER
������ dept_id��� �� ���� ������ �����մϴ�. ���� ���ǿ��� dept_name��
"Education"�� �Ҵ��մϴ�.
b. �տ��� �̹� departments ���̺��� ���� �ִ� �μ� ��ȣ�� �˻��߽��ϴ�.
�� �μ� ��ȣ�� 10�� ���Ͽ� �ش� ����� dept_id�� �Ҵ��մϴ�.
c. departments ���̺��� department_name, department_id ��
location_id ���� �����͸� �����ϴ� INSERT ���� ���Խ�ŵ�ϴ�.
department_name, department_id���� dept_name, dept_id�� ����
����ϰ� location_id���� NULL�� ����մϴ�.
d. SQL �Ӽ� SQL%ROWCOUNT�� ����Ͽ� ����Ǵ� �� ���� ǥ���մϴ�.
e. select ���� �����Ͽ� �� �μ��� ���ԵǾ����� Ȯ���մϴ�. "/"�� PL/SQL �����
�����ϰ� ��ũ��Ʈ�� SELECT ���� ���Խ�ŵ�ϴ�.
f. ��ũ��Ʈ�� �����ϰ� lab_04_02_soln.sql�� �����մϴ�. ������ ��� �����
������ �����ϴ�.*/
SELECT * FROM DEPARTMENTS;
DECLARE
    MAX_DEPTNO NUMBER;
    DEPT_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'Education';
    DEPT_ID NUMBER;
BEGIN
    SELECT MAX(DEPARTMENT_ID)
    INTO MAX_DEPTNO
    FROM DEPARTMENTS;
    DBMS_OUTPUT.PUT_LINE(MAX_DEPTNO);
    DEPT_ID := MAX_DEPTNO +10;
    
    INSERT INTO DEPARTMENTS(DEPARTMENT_NAME, DEPARTMENT_ID, LOCATION_ID)
    VALUES(DEPT_NAME, DEPT_ID, NULL);
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
    
    
END;
/*3. ���� ���� 2���� location_id�� �η� �����߽��ϴ�. �� �μ��� location_id��
3000���� �����ϴ� PL/SQL ����� �����մϴ�. ���� dept_id ���� ����Ͽ� ����
�����մϴ�.
a. BEGIN Ű����� ���� ����� �����մϴ�. �� �μ�(dept_id = 280)��
location_id�� 3000���� �����ϴ� UPDATE ���� ���Խ�ŵ�ϴ�.
b. END Ű����� ���� ����� �����մϴ�. "/" �� PL/SQL ����� �����ϰ� ������ �μ���
ǥ�õǵ��� SELECT ���� ���Խ�ŵ�ϴ�.
c. �߰��� �μ��� �����ϵ��� DELETE ���� ���Խ�ŵ�ϴ�.
d. ��ũ��Ʈ�� �����ϰ� lab_04_03_soln.sql�� �����մϴ�. ������ ��� �����
������ �����ϴ�.*/
DECLARE
    DEPT_ID NUMBER := 280;
BEGIN
    UPDATE DEPARTMENTS
    SET LOCATION_ID = 3000
    WHERE DEPARTMENT_ID = DEPT_ID;
END;
DELETE DEPARTMENTS
WHERE DEPARTMENT_ID = 280;

--4.  TEMP ���� ȸ���� �̸��� SALARY�� �о� ��� �����ִ� �͸� ��� �ۼ�
DECLARE
    E_NM VARCHAR2(20);
    SAL NUMBER;
BEGIN
    SELECT EMP_NAME, SALARY 
    INTO E_NM, SAL
    FROM TEMP
    WHERE LEV = 'ȸ��';
    DBMS_OUTPUT.PUT_LINE(E_NM);
    DBMS_OUTPUT.PUT_LINE(SAL);
END;
--5.  CSO001�� ������ ���� �μ��� �ִ� ��� ������ �޿� �հ踦 ����� �ִ� 
--    �͸� ��� �ۼ�
DECLARE
    SUM_SAL NUMBER;
BEGIN
    select SUM(SALARY)
    INTO SUM_SAL
    from TEMP A, 
        (SELECT DEPT_CODE
        FROM TDEPT
        START WITH DEPT_CODE = 'CSO001'
        CONNECT BY PRIOR DEPT_CODE = PARENT_DEPT) B
    WHERE A.DEPT_CODE = B.DEPT_CODE;
    DBMS_OUTPUT.PUT_LINE(SUM_SAL);
END;
--6.  �͸� ��Ͽ��� TEMP�� ��� SELECT �ؼ� TEMP3�� CREATE �ϴ� ������ 
--    �����ϰ� ����Ȯ��
/*7.  PL/SQL ��Ͽ��� WORK_YEAR VARCHAR2(04) ������ �����ϰ� 
    �ʱ� ������ ��2000�� �Ҵ�.
    ������ �̿��Ͽ� TCOM���� �ش� ���ǿ� �´� ���ڵ� �Ǽ��� ���� ���� ���� �� ���
    ���� ���̺� �����Ϳ� ���� ���� ���̰� ������ ���ο� ���̰� ���ٸ� ������ 
    ���� Ȯ��.*/
DECLARE
    WORK_YEAR VARCHAR2(04) := '2000';
    CNT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CNT
    FROM TCOM
    WHERE WORK_YEAR = WORK_YEAR;
    DBMS_OUTPUT.PUT_LINE(CNT);
END;
--8. 7������ WORK_YEAR ���� ���� TCOM���� �ٲٰ� ��2018���� �ʱ�ȭ �� �� 
--   �ش� ������ WORK_YEAR�� ���Ͽ� ���ǿ� �´� �Ǽ� COUNT �� ��� �� ��� Ȯ��
DECLARE
    TCOM VARCHAR2(04) := '2018';
    CNT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CNT
    FROM TCOM
    WHERE WORK_YEAR = TCOM;
    DBMS_OUTPUT.PUT_LINE(CNT);
END;
--9. TCOM�� 2019�� �ڷ� COMM UPDATE 
--   (�ڽ��� �μ����̸� SALARY�� 0.5%, �μ����� �ƴϸ� 1%��)
SELECT * FROM TCOM;
DECLARE
BEGIN
    UPDATE TCOM C
    SET COMM = (
        SELECT SALARY * DECODE(A.EMP_ID,B.BOSS_ID,0.005,0.01)
        FROM TEMP A, TDEPT B
        WHERE A.DEPT_CODE = B.DEPT_CODE
        AND A.EMP_ID = C.EMP_ID
        )
    WHERE WORK_YEAR = 2019;
END;

/*BONUS
1. TEST10�� �����ϴ� LINE�� SPEC�� �ƴ� ����
   TEST09���� ������ �����ϴ� �͸� ����� �ۼ��ϵ� COMMIT����,
   ���� ���� �� RECORD �Ǽ��� ���� �� RECORD�Ǽ� ����Ͽ� Ȯ��*/
SELECT * FROM TEST10;
DECLARE
    CNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO CNT FROM TEST09;
    DBMS_OUTPUT.PUT_LINE(CNT);
    DELETE 
    FROM TEST09 
    WHERE (LINE, SPEC) NOT IN (SELECT LINE, SPEC
                                FROM TEST10);
    SELECT COUNT(*) INTO CNT FROM TEST09;
    DBMS_OUTPUT.PUT_LINE(CNT);
END;
COMMIT;
/*2. TCOM 2019�⿡ �������� �ʴ� ����� ���� TCOM�� 2019������ �ű� INSERT
   (���ʽ� RATE = 1, COMM�� �μ����� SALARY�� 0.5% �ƴϸ� 1%��)
   COMMIT;
   
   2019�� �ڷ� ���
   19��
   55�� */
DECLARE
    CNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO CNT FROM TCOM WHERE WORK_YEAR = 2019;
    DBMS_OUTPUT.PUT_LINE(CNT);
    
    INSERT INTO TCOM
    SELECT 2019,A.EMP_ID,1, A.SALARY * DECODE(A.EMP_ID, B.BOSS_ID,0.005,0.01) COMM
    FROM TEMP A, TDEPT B
    WHERE A.DEPT_CODE = B.DEPT_CODE 
    AND A.EMP_ID NOT IN (SELECT EMP_ID FROM TCOM WHERE WORK_YEAR = 2019);
    
    SELECT COUNT(*) INTO CNT FROM TCOM WHERE WORK_YEAR = 2019;
    DBMS_OUTPUT.PUT_LINE(CNT);
END;
SELECT * FROM TDEPT;
--3.TCOM�� ��ü RECORD�� ������� BONUS_RATE�� 0���� ������Ʈ��
--������ SQL%ROWCOUNT �Ӽ����� ������ �Ҵ��Ͽ� ����ϰ�,
--SQL%NOTFOUND ���� SQL%FOUND���� Ȯ���Ͽ� ��� ��� ��
--��� ������ ROLLBACK;
DECLARE
    RC NUMBER;
BEGIN
    UPDATE TCOM
    SET BONUS_RATE = 0;
    
    RC := SQL%ROWCOUNT;
    
    IF SQL%NOTFOUND = TRUE
    THEN DBMS_OUTPUT.PUT_LINE('NOTFOUND TURE');
    ELSIF SQL%FOUND = TRUE
    THEN DBMS_OUTPUT.PUT_LINE('FOUND TURE');
    ELSE DBMS_OUTPUT.PUT_LINE('GG');
    END IF;
    ROLLBACK;
END;
--
CREATE TABLE TEMP2 AS
SELECT * FROM TEMP;

CREATE TABLE TCOM1 AS
SELECT * FROM TCOM
WHERE WORK_YEAR = 0;

CREATE TABLE EMP_LEVEL1 AS
SELECT * FROM EMP_LEVEL
WHERE LEV = '0';

SELECT * FROM TEVAL;
SELECT * FROM TCODE;
SELECT A.EMP_ID, A.EMP_NAME, B.BOSS_ID
FROM TEMP2 A, TDEPT B
WHERE A.DEPT_CODE = B.DEPT_CODE;
/*
�Է¹��� ������ �̿��� TEMP2�� �о� WORK_YEAR = '2019'���� �Ͽ� TCOM1�� �ش� ����� 
INSERT (COMM�� ������ 10%) �ϰ� , EMP_LEVEL1���� INSERT�մϴ�
(���ʴ� FROM, TO ���� �� ���� UPDATE�� ����Ȯ���ؼ� ������ �����ʴ� ��츸 ����Ȯ��),
���������� TEVAL�� YM_EV='201901',EMP_ID,EV_CD(=KNO)
(TCODE���� MAIN_CD = 'A002'�� 4��, EV_EMP�� �ڽ��� ������ �Է�)
TEVAL �Է´ܰ迡�� BOSS�� ã�� ���� TDEPT2�� �����Ҷ� ��Ī�ڵ尡 ����
�μ��� ã�� ���� �����ϴ� ���� TCOM2�� EMP_LEVEL2 ������ �۾��� COMMIT �ؾ��մϴ�
SAVEPOINT�� ����ϴ� �ش� PROCEDURE�� �����ϼ��� => �ѱ۷� �����帧 ���� ����
���1 
- TEMP�� �о� TCOM1�� INSERT
-�������� ���
���2 
- EMP_LEVEL1 UPDATE
-����� ���� �ű��Է°��� UPDATE�� Ŀ�� �Ӽ� Ȯ���� ���� ���� ���
-Ŀ�� �Ӽ��� NOTFOUND�� ���� INSERT ����
���3
-BOSS ã��
-INSERT ���� ���п��� ���
-�μ� ������ ��� ������ ���� ���2������ �������� ���� ������ ���� ���3���� ����*/
SELECT * FROM TCOM1;
SELECT * FROM EMP_LEVEL1;

CREATE OR REPLACE PROCEDURE QWER(P1 TEMP2.EMP_NAME%TYPE) IS
    A_ID NUMBER;
    B_ID NUMBER;
    NF VARCHAR2(20);
    L1 VARCHAR2(20);
    L2 VARCHAR2(20);
    SAL NUMBER;
    F_SAL NUMBER;
    T_SAL NUMBER;
BEGIN
    SELECT A.EMP_ID, B.EMP_ID
    INTO A_ID, B_ID
    FROM TEMP2 A, TCOM1 B 
    WHERE A.EMP_NAME = P1
    AND A.EMP_ID = B.EMP_ID(+);
    
    IF B_ID IS NULL THEN
    INSERT INTO TCOM1
    SELECT 2019, EMP_ID, 10, SALARY * 0.1
    FROM TEMP2
    WHERE EMP_NAME = P1;
    DBMS_OUTPUT.PUT_LINE('TCOM1 INSERT �Ϸ�');
    END IF;
    
    SELECT A.LEV, A.SALARY, B.LEV, B.FROM_SAL, B.TO_SAL
    INTO L1, SAL, L2, F_SAL, T_SAL
    FROM TEMP2 A, EMP_LEVEL1 B
    WHERE A.LEV = B.LEV(+)
    AND A.EMP_NAME = P1;

    IF L2 IS NULL
    THEN
        INSERT INTO EMP_LEVEL1
        SELECT LEV, SALARY, SALARY, NULL, NULL
        FROM TEMP2
        WHERE EMP_NAME = P1;
            DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 INSERT �Ϸ�');
    END IF;
    
    IF F_SAL > SAL 
    THEN
        UPDATE EMP_LEVEL1
        SET FROM_SAL = SAL
        WHERE LEV = L1;
    END IF;
    
    IF T_SAL < SAL
    THEN
        UPDATE EMP_LEVEL1
        SET TO_SAL = SAL
        WHERE LEV = L1;
    END IF;
    
    INSERT INTO TEVAL
    SELECT 201901, B.EMP_ID, B.KNO,NULL, A.BOSS_ID
    FROM TDEPT A,
        (SELECT B.EMP_ID, A.KNO, B.DEPT_CODE
        FROM TCODE A, TEMP2 B
        WHERE A.MCD = 'A002'
        AND B.EMP_NAME = P1) B
    WHERE A.DEPT_CODE = B.DEPT_CODE;
    
    SAVEPOINT SP;
END;

SELECT * FROM TCOM1;
SELECT * FROM EMP_LEVEL1;
SELECT * FROM TEVAL WHERE EMP_ID = 19960101;
SELECT * FROM TEMP2 WHERE LEV = '����';
EXECUTE QWER('ȫ�浿'); 
ROLLBACK TO SP;
ROLLBACK;




