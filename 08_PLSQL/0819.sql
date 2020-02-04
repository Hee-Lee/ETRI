CREATE TABLE retired_emps
AS
SELECT EMPLOYEE_ID EMPNO, LAST_NAME ENAME, JOB_ID JOB, MANAGER_ID MGR, HIRE_DATE HIREDATE, HIRE_DATE LEAVEDATE, SALARY SAL, COMMISSION_PCT COMM, DEPARTMENT_ID DEPTNO
FROM EMPLOYEES
WHERE ROWNUM < 1;
--
DEFINE employee_number = 124
DECLARE
emp_rec   employees%ROWTYPE;
BEGIN
SELECT * INTO emp_rec FROM employees
WHERE  employee_id = &employee_number;
INSERT INTO retired_emps(empno, ename, job, mgr,
hiredate, leavedate, sal, comm, deptno)
VALUES (emp_rec.employee_id, emp_rec.last_name,
emp_rec.job_id,emp_rec.manager_id,
emp_rec.hire_date, SYSDATE, emp_rec.salary,   
emp_rec.commission_pct, emp_rec.department_id);
END;

SELECT * FROM retired_emps;
--2���� ���ڵ�
DECLARE
    TYPE EMP_SAL IS RECORD (EMP_ID TEMP.EMP_ID%TYPE, SALARY NUMBER);
    TYPE EMP_TAB IS RECORD(REC1 EMP_SAL, REC2 EMP_SAL);
    TAB_SAL EMP_TAB;
BEGIN
    SELECT EMP_ID, SALARY
    INTO TAB_SAL.REC1
    FROM TEMP
    WHERE ROWNUM < 2;

    SELECT EMP_ID, SALARY
    INTO TAB_SAL.REC2
    FROM TEMP
    WHERE EMP_NAME = 'ȫ�浿';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID1 : '||TAB_SAL.REC1.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('SALARY1 : '||TAB_SAL.REC1.SALARY);
    DBMS_OUTPUT.PUT_LINE('EMP_ID2 : '||TAB_SAL.REC2.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('SALARY2 : '||TAB_SAL.REC2.SALARY);
END;
--%ROWTYPE�� ����Ͽ� ���ڵ� ����
DEFINE employee_number = 124
DECLARE
emp_rec  retired_emps%ROWTYPE;
BEGIN
SELECT employee_id, last_name, job_id, manager_id, 
hire_date, hire_date, salary, commission_pct,
department_id INTO emp_rec FROM employees
WHERE  employee_id = &employee_number;
INSERT INTO retired_emps VALUES emp_rec;
END;
/
SELECT * FROM retired_emps;

--���ڵ带 ����Ͽ� ���̺��� �� ����
SET SERVEROUTPUT ON
SET VERIFY OFF
DEFINE employee_number = 124
DECLARE
emp_rec retired_emps%ROWTYPE;
BEGIN
SELECT * INTO emp_rec FROM retired_emps;
emp_rec.leavedate:=SYSDATE;
UPDATE retired_emps SET ROW = emp_rec WHERE 
empno=&employee_number; 
END;

SELECT * FROM retired_emps;
--
DECLARE 
    TYPE ename_table_type IS TABLE OF 
        employees.last_name%TYPE INDEX BY PLS_INTEGER; 
    TYPE hiredate_table_type IS TABLE OF    
        DATE INDEX BY PLS_INTEGER; 
    ename_table ename_table_type; 
    hiredate_table hiredate_table_type; 
BEGIN 
    ename_table(1) := 'CAMERON'; 
    hiredate_table(8) := SYSDATE + 7; 
    IF ename_table.EXISTS(1) THEN 
    DBMS_OUTPUT.PUT_LINE(ENAME_TABLE(1));
    END IF;
    IF HIREDATE_table.EXISTS(8) THEN 
    DBMS_OUTPUT.PUT_LINE(HIREDATE_TABLE(8));
    END IF;
END;

DECLARE
    TYPE T1_TAB IS TABLE OF T1_DATA%ROWTYPE
    INDEX BY PLS_INTEGER;
    TAB1 T1_TAB;
    CNT NUMBER := 0;
BEGIN 
    FOR I IN -4..5
    LOOP
        CNT := CNT + 1;
        TAB1(I).NO := CNT;
        DBMS_OUTPUT.PUT_LINE('INDEX: '||I);
        DBMS_OUTPUT.PUT_LINE('COUNT: '||TAB1.COUNT);
        DBMS_OUTPUT.PUT_LINE('FIRST: '||TAB1.FIRST);
        DBMS_OUTPUT.PUT_LINE('LAST: '||TAB1.LAST);
        DBMS_OUTPUT.PUT_LINE('PRIOR: '||TAB1.PRIOR(I));
        DBMS_OUTPUT.PUT_LINE('NEXT: '||TAB1.NEXT(I));
        IF I=0 THEN
            TAB1.DELETE(1);
        END IF;
    END LOOP;
    --
    FOR J IN -4..5 LOOP
        DBMS_OUTPUT.PUT_LINE(J|| ' ''S VALUES ===========START');
        IF TAB1.EXISTS(J) THEN
           DBMS_OUTPUT.PUT_LINE(J|| ' INDEX''S VALUE NO: '||TAB1(J).NO);
        ELSE
            DBMS_OUTPUT.PUT_LINE(J|| ' INDEX''S VALUE NO NOT FOUND=!!!!!');  
        END IF;
        DBMS_OUTPUT.PUT_LINE(J|| ' INDEX''S VALUE =======================END'); 
    END LOOP;
END;
--
SET SERVEROUTPUT ON 
DECLARE 
    TYPE location_type IS TABLE OF 
    locations.city%TYPE; 
    offices location_type; 
    table_count NUMBER; 
BEGIN 
    offices := location_type('Bombay', 'Tokyo','Singapore', 'Oxford'); 
    table_count := offices.count(); 
    FOR i in 1..table_count 
        LOOP DBMS_OUTPUT.PUT_LINE(offices(i)); 
    END LOOP; 
END;
--PLSQL  188������
/*1. ������ ������ ���� ������ ����ϴ� PL/SQL ����� �ۼ��մϴ�. 
    a. countries ���̺��� ������ �°� PL/SQL ���ڵ带 �����մϴ�.
    b. DEFINE ����� ����Ͽ� countryid ������ �����մϴ�. countryid�� CA�� �Ҵ��մϴ�. �� ���� ġȯ ������ ����Ͽ� PL/SQL ��Ͽ� �����մϴ�. 
    c. ���� ���ǿ��� %ROWTYPE �Ӽ��� ����Ͽ� countries ������ country_record ������ �����մϴ�. 
    d. ���� ���ǿ��� countryid�� ����Ͽ�countries ���̺��� ��� ������ �����ɴϴ�. ������ ������ ������ ǥ���մϴ�. ������ ��� ���Դϴ�.*/
SELECT * FROM COUNTRIES;

DEFINE COUNTRYID = "'CA'";
DECLARE
    COUNTRY_REC COUNTRIES%ROWTYPE;
BEGIN
    SELECT * 
    INTO COUNTRY_REC
    FROM COUNTRIES
    WHERE COUNTRY_ID = &COUNTRYID;
END;
/*
2. INDEX BY ���̺�� �����Ͽ� departments ���̺��� �Ϻ� �μ� �̸��� �˻��Ͽ� �� �μ� �̸��� ȭ�鿡 ����ϴ� PL/SQL ����� �����մϴ�. 
    ��ũ��Ʈ�� lab_06_02_soln.sql�� �����մϴ�. 
a. departments.department_name ������ INDEX BY ���̺� dept_table_type�� �����մϴ�. 
    dept_table_type ������ my_dept_table ������ �����Ͽ� �μ� �̸��� �ӽ÷� �����մϴ�. 
b. NUMBER ������ �� ����loop_count �� deptno�� �����մϴ�. loop_count�� 10�� �Ҵ��ϰ� deptno�� 0�� �Ҵ��մϴ�. 
c. ������ ����Ͽ� 10���� �μ� �̸��� �˻��ϰ� INDEX BY ���̺� �̸��� �����մϴ�. department_id�� 10���� �����մϴ�. 
    ������ �ݺ��� ������ deptno�� 10�� ������ŵ�ϴ�. 
    ���� ���̺��� department_name�� �˻��ϰ� INDEX BY ���̺� ������ department_id�� �����ݴϴ�.
d. �ٸ� ������ ����Ͽ� INDEX BY ���̺��� �μ� �̸��� �˻��� ���� ������ ����մϴ�. 
e. ��ũ��Ʈ�� �����ϰ� lab_06_02_soln.sql�� �����մϴ�. ��� ����� ������ �����ϴ�*/
SELECT * FROM DEPARTMENTS;
DECLARE
    TYPE dept_table_type IS TABLE OF 
    departments.department_name%TYPE
    INDEX BY PLS_INTEGER;
    my_dept_table dept_table_type;
    LOOP_COUNT NUMBER := 10;
    DEPTNO NUMBER := 0;
BEGIN
    FOR I IN 1..10 LOOP
        DEPTNO := DEPTNO + LOOP_COUNT;
        SELECT DEPARTMENT_NAME
        INTO  my_dept_table(I)
        FROM DEPARTMENTS
        WHERE DEPARTMENT_ID = DEPTNO;
    END LOOP;
    FOR J IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT_NAME: '|| my_dept_table(J));
    END LOOP;
END;
/*3. departments ���̺��� �� �μ� ������ ��� �˻��Ͽ� ����ϵ��� 2�� �������� ������ ����� �����մϴ�. 
    INDEX BY ���ڵ� ���̺��� ����մϴ�. 
a. lab_06_02_soln.sql ��ũ��Ʈ�� ���ϴ�. 
b. INDEX BY ���̺��� departments.department_name �������� ����� �����Դϴ�. 
    �μ��� ��ȣ, �̸�, manager_id �� ��ġ�� �ӽ÷� �����ϵ��� INDEX BY ���̺��� ������ �����մϴ�. 
    %ROWTYPE �Ӽ��� ����մϴ�. 
c. departments ���̺��� ���� ��� �μ� ������ �˻��ϵ��� select ���� �����ϰ� INDEX BY ���̺� �����մϴ�. 
d. �ٸ� ������ ����Ͽ� INDEX BY ���̺��� �μ� ������ �˻��� ���� ������ ����մϴ�. ������ ��� ���Դϴ�.*/
DECLARE
    TYPE dept_table_type IS TABLE OF 
    departments%ROWTYPE
    INDEX BY PLS_INTEGER;
    my_dept_table dept_table_type;
    LOOP_COUNT NUMBER := 10;
    DEPTNO NUMBER := 0;
BEGIN
    FOR I IN 1..10 LOOP
        DEPTNO := DEPTNO + LOOP_COUNT;
        SELECT *
        INTO  my_dept_table(I)
        FROM DEPARTMENTS
        WHERE DEPARTMENT_ID = DEPTNO;
    END LOOP;
    FOR J IN my_dept_table.FIRST..my_dept_table.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT_ID: '||my_dept_table(J).DEPARTMENT_ID||
                            ' DEPARTMENT_NAME: '||my_dept_table(J).DEPARTMENT_NAME||
                            ' MANAGER_ID: '||my_dept_table(J).MANAGER_ID||
                            ' LOCATION_ID: '||my_dept_table(J).LOCATION_ID);
    END LOOP;
END;
SELECT * FROM DEPARTMENTS;
/*4.
����ο��� TEMP �� EMP_ID�� SALARY ������ ���� �� �ִ� PL/SQL RECORD TYPE ����
   ����� Ÿ������ ���� ����
   TEMP ���� EMP_ID�� SALARY�� ���� 3�Ǹ� �о���� Ŀ�� ����
   ����� Ŀ���� FETCH �ϸ� PL/SQL RECORD ������ ���, �ش� ������ ���� 
   �о� ����� �޿� ���� ��� */
DECLARE
    TYPE REC IS RECORD(EMP_ID TEMP.EMP_ID%TYPE, SALARY TEMP.SALARY%TYPE);
    EMP_REC REC;
    
    CURSOR CUR IS
    SELECT EMP_ID, SALARY
    FROM(
        SELECT EMP_ID, SALARY
        FROM TEMP
        ORDER BY SALARY DESC, EMP_ID)
    WHERE ROWNUM < 4;
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR
        INTO EMP_REC;
        EXIT WHEN CUR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('EMP_ID :'||EMP_REC.EMP_ID ||'SALARY :'||EMP_REC.SALARY);
    END LOOP;
END;
/*5. BOM_R_TYPE �̸����� BOM�� ROW�� ������ ������ PL/SQL ���ڵ� TYPE ����
   BOM_REC ������ BOM_R_TYPE �������� ���� �� BEGIN SECTION����
   BOM ���̺��� ROWNUM=1 �� �� ���� SELECT �Ͽ� BOM_REC�� �Ҵ�
   BOM_REC ���� ���� ���� ���� ���� ���*/
SELECT * FROM BOM;
DECLARE
    TYPE BOM_R_TYPE IS RECORD(SPEC_CODE BOM.SPEC_CODE%TYPE,
                            ITEM_CODE BOM.ITEM_CODE%TYPE,
                            ITEM_QTY BOM.ITEM_QTY%TYPE);
    BOM_REC BOM_R_TYPE;
BEGIN
    SELECT *
    INTO BOM_REC
    FROM BOM
    WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('SPEC_CODE :'||BOM_REC.SPEC_CODE||
                        ' ITEM_CODE :'||BOM_REC.ITEM_CODE||
                        ' ITEM_QTY :'||BOM_REC.ITEM_QTY);
END;
/*6. EMP_TYPE �̸����� ROWNUM, EMP_ID, EMP_NAME�� ������ PL/SQL ���ڵ� TYPE ����
   EREC ������ EMP_TYPE �������� ���� �� 
   TEMP�� ��ü ���ڵ带 ������ �ش� �� ���� ������ ���ʷ� ���� ��, ���� ���.*/
DECLARE
    TYPE EMP_TYPE IS RECORD(NO NUMBER, EMP_ID TEMP.EMP_ID%TYPE, EMP_NAME TEMP.EMP_NAME%TYPE);
    EREC EMP_TYPE;
    CNT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CNT
    FROM TEMP;
    
    FOR I IN 1..CNT LOOP
        SELECT NO, A.EMP_ID, A.EMP_NAME
        INTO EREC
        FROM TEMP A, (SELECT ROWNUM NO, EMP_ID FROM TEMP) B
        WHERE  NO = I
        AND A.EMP_ID = B.EMP_ID;
        DBMS_OUTPUT.PUT_LINE('ROWNUM :'||EREC.NO||
                            ' EMP_ID :'||EREC.EMP_ID||
                            ' EMP_NAME :'||EREC.EMP_NAME);      
    END LOOP;
END;
/*7. TEMP�� %ROWTYPE ���� ���� �� TEMP���� �μ��� CEO001�� ���� ��ȸ�� ����ϱ�*/
DECLARE
    T TEMP%ROWTYPE;
BEGIN
    SELECT * 
    INTO T 
    FROM TEMP
    WHERE DEPT_CODE = 'CEO001';
    DBMS_OUTPUT.PUT_LINE(T.EMP_ID);
END;
/*
8. 7�� �ڵ忡 �߰�: 7���� TDEPT�� %ROWTYPE ���� �߰� ���� �� 7���� ��� 
   DEPT_CODE�� PARENT_DEPT�� ������ TDEPT �ڷḦ ��ȸ�� �ش� �μ� 1�Ǹ� 
   �о� �μ��ڵ�, �μ���� BOSS_ID ����ϱ�*/
DECLARE
    TTEMP TEMP%ROWTYPE;
    TTDEPT TDEPT%ROWTYPE;
BEGIN
    SELECT * 
    INTO TTEMP 
    FROM TEMP
    WHERE DEPT_CODE = 'CEO001';
    
    SELECT *
    INTO TTDEPT
    FROM TDEPT
    WHERE PARENT_DEPT = TTEMP.DEPT_CODE
    AND ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('�μ��ڵ� : '||TTDEPT.DEPT_NAME||' �������̵� :'||TTDEPT.BOSS_ID);
END;

/*9. 8�� �ڵ忡 �߰�: TDEPT���� �о� %ROWTYPE ������ ��� �ִ� ������ 
   �ϳ��� �÷��� ��Ī���� TDEPT1�� INSERT */
DECLARE
    TTEMP TEMP%ROWTYPE;
    TTDEPT TDEPT%ROWTYPE;
BEGIN    
    SELECT *
    INTO TTDEPT
    FROM TDEPT
    WHERE ROWNUM = 1;
    INSERT INTO TDEPT1
    VALUES (TTDEPT.DEPT_CODE, TTDEPT.DEPT_NAME, TTDEPT.PARENT_DEPT, TTDEPT.USE_YN, TTDEPT.AREA, TTDEPT.BOSS_ID);
END;
SELECT * FROM TDEPT1;
/* 
10. TDEPT1���� DELETE �� 9�� INSERT ���� %ROWTYPE ���� ��°�� INSERT*/
DECLARE
    TTEMP TEMP%ROWTYPE;
    TTDEPT TDEPT%ROWTYPE;
BEGIN    
    SELECT *
    INTO TTDEPT
    FROM TDEPT
    WHERE ROWNUM = 1;
    INSERT INTO TDEPT1
    VALUES TTDEPT;
END;