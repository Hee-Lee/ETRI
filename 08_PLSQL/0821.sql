--forĿ��
SET SERVEROUTPUT ON 
DECLARE 
    CURSOR emp_cursor IS 
    SELECT employee_id, last_name 
    FROM employees 
    WHERE department_id =30; 
BEGIN 
    FOR emp_record IN emp_cursor 
    LOOP 
        DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' ' ||emp_record.last_name);   
    END LOOP; 
END;
--%ROWCOUNT
SET SERVEROUTPUT ON 
DECLARE 
    empno employees.employee_id%TYPE; 
    ename employees.last_name%TYPE; 
    CURSOR emp_cursor IS 
    SELECT employee_id, last_name 
    FROM employees; 
BEGIN 
    OPEN emp_cursor; LOOP 
    FETCH emp_cursor INTO empno, ename; 
    EXIT WHEN emp_cursor%ROWCOUNT > 10 OR  emp_cursor%NOTFOUND; 
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(empno) ||' '|| ename); 
    END LOOP; 
    CLOSE emp_cursor; 
END;
--�Ķ���Ͱ� ���Ե� Ŀ��
SET SERVEROUTPUT ON 
DECLARE 
    CURSOR   emp_cursor (deptno NUMBER) IS 
    SELECT  employee_id, last_name 
    FROM    employees
    WHERE   department_id = deptno; 
    dept_id NUMBER; 
    lname   VARCHAR2(15);
BEGIN 
    OPEN emp_cursor (10);
    FETCH EMP_CURSOR INTO DEPT_ID, LNAME;
    DBMS_OUTPUT.PUT_LINE(DEPT_ID||LNAME);
    CLOSE emp_cursor; 
END;
--FOR UPDATE
SELECT ... FROM ... FOR UPDATE [OF column_reference][NOWAIT | WAIT n]

/*1. ���� n��°������ ��� �޿��� �Ǻ��ϴ� PL/SQL ����� �����մϴ�. 
    a. ����� �޿��� �����ϱ� ���� lab_07_01.sql ��ũ��Ʈ�� �����Ͽ� �� ���̺� top_salaries�� �����մϴ�. 
    b. ���� n�� ������ �Է��ϴ� ���Դϴ�. ���⼭ n�� employees ���̺��� �޿� �� ���� n��°�� ��Ÿ���ϴ�. 
    ���� ���, ���� �ټ� ���� �޿��� ������ 5�� �Է��մϴ�. 
    ��: n�� ���� ���� �����Ϸ��� DEFINE ����� ����Ͽ� ���� p_num�� �����մϴ�. 
    ġȯ ������ ���� PL/SQL ������� ���� ���޵˴ϴ�. 
    c. ���� ���ǿ��� ġȯ ���� p_num�� ������ NUMBER ������ num ������ employees.salary ������ sal ������ �����մϴ�. 
    ����� �޿��� ������������ �о� ���̴� emp_cursor Ŀ���� �����մϴ�. �޿��� �ߺ��� �� �����ϴ�. 
    d. ���� ���ǿ��� ������ ���� ���� n��°������ �޿��� ��ġ(fetch)�� ���� top_salaries ���̺� �����մϴ�. 
    ������ ������ ����Ͽ� �����͸� ������ �� �ֽ��ϴ�. ���� ���� ���ǿ� %ROWCOUNT �� %FOUND �Ӽ��� ����մϴ�. 
    e. top_salaries ���̺� ������ �� SELECT ���� ����Ͽ� ���� ����մϴ�. 
    ����� employees ���̺��� ���� 5���� �޿��� ��µ˴ϴ�.
    f. n�� 0�̰ų� n�� employees ���̺��� ��� ������ �� ū ���� ���� �پ��� ��츦 �׽�Ʈ�� ���ϴ�. 
    �� �׽�Ʈ ���Ŀ��� top_salaries ���̺��� ���ϴ�. */
CREATE TABLE top_salaries
AS
SELECT SALARY FROM EMPLOYEES;
--
DEFINE P_NUM = &N;
DECLARE
    NUM NUMBER := &P_NUM + 1;
    SAL EMPLOYEES.SALARY%TYPE;
    
    CURSOR CUR IS
    SELECT DISTINCT SALARY
    FROM EMPLOYEES
    WHERE ROWNUM <= NUM
    ORDER BY SALARY DESC;
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR INTO SAL;
        EXIT WHEN CUR%ROWCOUNT > NUM OR CUR%NOTFOUND;
        INSERT INTO top_salaries
        VALUES (SAL);
        DBMS_OUTPUT.PUT_LINE(SAL);
    END LOOP;
    CLOSE CUR;
END;

/*2. ������ �����ϴ� PL/SQL ����� �����մϴ�. 
a. DEFINE ����� ����Ͽ� �μ� ID�� �����ϴ� p_deptno ������ �����մϴ�. 
b. ���� ���ǿ��� NUMBER ������ deptno ������ �����ϰ� p_deptno�� ���� �Ҵ��մϴ�. 
c. deptno�� ������ �μ��� �ٹ��ϴ� ����� last_name, salary �� manager_id�� �о� ���̴�emp_cursor Ŀ���� �����մϴ�.
d. ���� ���ǿ��� Ŀ�� FOR ������ ����Ͽ� �˻��� �����Ϳ� ���� �۾��� �� �ֽ��ϴ�. 
    ����� �޿��� 5000 �̸��̰� ������ ID�� 101 �Ǵ� 124�� ��� <<last_name>> Due for a raise �޽����� ǥ���մϴ�. 
    �׷��� ���� ��� <<last_name>> Not due for a raise �޽����� ǥ���մϴ�. 
e. ���� ��쿡 ���� PL/SQL ����� �׽�Ʈ�մϴ�.*/
DEFINE P_DEPTNO = &NO;
DECLARE
    DEPTNO NUMBER := &P_DEPTNO;
    
    CURSOR EMP_CURSOR IS
    SELECT LAST_NAME, SALARY, MANAGER_ID
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = DEPTNO;
BEGIN
    FOR EMP_REC IN EMP_CURSOR
    LOOP
        IF EMP_REC.SALARY < 5000 AND (EMP_REC.MANAGER_ID = 101 OR EMP_REC.MANAGER_ID = 124)
        THEN
            DBMS_OUTPUT.PUT_LINE('<<last_name>> Due for a raise');
        ELSE
            DBMS_OUTPUT.PUT_LINE('<<last_name>> Not due for a raise');
        END IF;
    END LOOP;
END;
/*3. �Ķ���Ͱ� ���Ե� Ŀ���� �����ϰ� ����ϴ� PL/SQL ����� �ۼ��մϴ�. 
    �������� Ŀ���� ����Ͽ� departments ���̺��� department_id�� 100���� ���� �μ��� �μ� ��ȣ �� �μ� �̸��� �о� ���Դϴ�. 
    �μ� ��ȣ�� �ٸ� Ŀ���� �Ķ���ͷ� �����Ͽ� employees ���̺��� �ش� �μ��� �ٹ��ϰ� 
    employee_id�� 120���� ���� ����� ��, ����, ä�� ��¥ �� �޿� ���� �� ������ �о� ���Դϴ�. 
    a. ���� ���ǿ��� dept_cursor Ŀ���� �����Ͽ� department_id�� 100���� ���� �μ��� department_id �� department_name�� �˻��մϴ�. department_id�� ���� �����մϴ�. 
    b. �μ� ��ȣ�� �Ķ���ͷ� ����Ͽ� �ش� �μ��� �ٹ��ϰ� employee_id�� 120 ���� ���� ����� last_name, job_id, hire_date �� salary�� �˻��ϴ� �ٸ� Ŀ�� emp_cursor�� �����մϴ�. 
    c. �� Ŀ������ �˻��� ���� �����ϴ� ������ �����մϴ�. ���� ���� �� %TYPE �Ӽ��� ����մϴ�. d. dept_cursor�� ���� ������ ������ ����Ͽ� ���� ����� ������ ��ġ(fetch)�մϴ�. 
    �μ� ��ȣ �� �μ� �̸��� ����մϴ�. e. �� �μ��� ���� ���� �μ� ��ȣ�� �Ķ���ͷ� �����Ͽ� emp_cursor�� ���ϴ� . 
    �ٸ� ������ �����Ͽ� emp_cursor�� ���� ������ ��ġ�ϰ� employees ���̺��� �˻��� ��� �� ������ ����մϴ�. 
    ��: �� �μ��� �� ������ ǥ���� ���� �� ���� ����� �� �ֽ��ϴ�. ���� ���ǿ� ������ �Ӽ��� ����Ͻʽÿ�. 
    ���� Ŀ���� ���� ���� �̹� ���� �ִ��� Ȯ���Ͻʽÿ�. f. ��� ���� �� Ŀ���� �ݰ� ���� ������ �����մϴ�. ��ũ��Ʈ�� �����մϴ�*/
DECLARE
    D_ID EMPLOYEES.DEPARTMENT_ID%TYPE;
    D_NAME EMPLOYEES.DEPARTMENT_NAME%TYPE;
    L_NAME EMPLOYEES.LAST_NAME%TYPE;
    J_ID EMPLOYEES.JOB_ID%TYPE;
    H_DATE EMPLOYEES.HIRE_DATE%TYPE;
    SAL EMPLOYEES.SALARY%TYPE;
    CURSOR DEPT_CURSOR IS
        SELECT DEPARTMENT_ID, DEPARTMENT_NAME
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID < 100
        GROUP BY DEPARTMENT_ID, DEPARTMENT_NAME
        ORDER BY DEPARTMENT_ID;
    CURSOR EMP_CURSOR (DEPTNO NUMBER)IS
        SELECT LAST_NAME, JOB_ID, HIRE_DATE, SALARY
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID < 120
        AND DEPARTMENT_ID = DEPTNO;
BEGIN
    OPEN DEPT_CURSOR;
    LOOP
        FETCH DEPT_CURSOR INTO D_ID, D_NAME;
        EXIT WHEN DEPT_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('�μ� ��ȣ : '||D_ID||' �μ� �̸� : '||D_NAME);
        OPEN EMP_CURSOR(D_ID);
        LOOP
            FETCH EMP_CURSOR INTO L_NAME, J_ID, H_DATE, SAL;
            EXIT WHEN EMP_CURSOR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(L_NAME||'  '||J_ID||'  '||H_DATE||'  '||SAL);
        END LOOP;
        CLOSE EMP_CURSOR;
    END LOOP;
    CLOSE DEPT_CURSOR;
END;
/*3. �͸��� ����ο��� JIT_DELIVERY_PLAN�� 2019�� 10���� ITEM�� ������ ���Ͽ� �о���̴� 
    Ŀ���� �����ϰ� ����ο��� Ŀ��%ROWCOUNT, ITEM, QTY�� ���*/
DECLARE
    CURSOR CUR IS
    SELECT ITEM_CODE, ITEM_QTY
    FROM JIT_DELIVERY_PLAN
    WHERE DELIVERY_DATE LIKE '201910%';
BEGIN
    FOR JIT_REC IN CUR
    LOOP
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||JIT_REC.ITEM_CODE||JIT_REC.ITEM_QTY);
    END LOOP;
END;
/*4. Ŀ���� �ݺ� ���
   TEMP���� EMP_ID�� ORDER BY �� Ŀ���� �����ϰ�, 
   Ŀ���� OPEN�Ͽ� �� �� FETCH �Ͽ� ��� �� CLOSE
    �ٽ� OPEN �Ͽ� �� �� FETCH �� ��� �� CLOSE �Ͽ� �� ��� ��*/
DECLARE
    E1 NUMBER;
    E2 NUMBER;
    
    CURSOR CUR IS
    SELECT EMP_ID
    FROM TEMP
    ORDER BY EMP_ID;
BEGIN
    OPEN CUR;
    FETCH CUR INTO E1;
    CLOSE CUR;
    OPEN CUR;
    FETCH CUR INTO E2;
    CLOSE CUR;
    DBMS_OUTPUT.PUT_LINE(E1||E2);
END;
 /*   
5. ����ο� ���,����� �ڽ��� ����ID, ���� ������ SELECT�ϴ� Ŀ�� �����ϰ� 
   (���� �μ����̸� ���� �μ� �μ����� ����-VEMP_BOSS VIEW ��� ����) 
   FOR LOOP ���� RECORD Ÿ�� ������ �Ҵ��Ͽ� ��� */
DECLARE
    CURSOR CUR IS
    SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE,
            DECODE(A.EMP_ID, B.BOSS_ID, C.BOSS_ID, B.BOSS_ID) BOSS_ID,
            D.EMP_NAME BOSS_NAME, D.DEPT_CODE BOSS_DEPT
    FROM TEMP A, TDEPT B, TDEPT C, TEMP D
    WHERE B.DEPT_CODE = A.DEPT_CODE
    AND C.DEPT_CODE = B.PARENT_DEPT
    AND D.EMP_ID = C.BOSS_ID;
BEGIN
    FOR EMP_REC IN CUR
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMP_REC.EMP_ID||EMP_REC.EMP_NAME||EMP_REC.BOSS_ID||EMP_REC.BOSS_NAME);
    END LOOP;
END;
/*6. 5���� FOR LOOP ���������� �ٲ㼭 ���� ���� ó��  */
/*7. 
   1) ���� �ӱݹ��� ���� TEMP2���� 2500������ �� �Ǵ� ������ SALARY�� 
   2500�������� �����Ϸ��� �մϴ�.
   Ŀ���� ������ FOR UPDATE NOWAIT�� �̿� ������Ʈ �Ϸ��� �����Ϳ� 
   LOCK�� �ɰ� �͸��Ͽ��� 
    �۾��� �����մϴ�.(UPDATE �� WHERE CURRENT OF �̿�)*/
DECLARE
    CURSOR CUR IS
    SELECT *
    FROM TEMP2
    WHERE SALARY < 25000000
    FOR UPDATE NOWAIT;
BEGIN
    FOR TEMP_REC IN CUR 
    LOOP
        UPDATE TEMP2
        SET SALARY = 25000000
        WHERE CURRENT OF CUR;
    END LOOP;
END;
   /*2) 1������ ����� TEMP2 �ݿ��� ���� EMP_LEVEL2 SALARY ���� ���� ����
   (FOR UPDATE NOWIT Ŀ���� WHERE CURRENT OF �̿��ϸ�, 
   ������Ʈ ���� ���⼭������ �̿�)*/
DECLARE
    CURSOR CUR IS 
        SELECT *
        FROM EMP_LEVEL1
        FOR UPDATE OF FROM_SAL, TO_SAL NOWAIT;
BEGIN
    FOR i IN CUR LOOP
        UPDATE EMP_LEVEL1
        SET FROM_SAL = (SELECT MIN(SALARY) 
                        FROM TEMP2
                        WHERE LEV = i.LEV
                        GROUP BY LEV),
            TO_SAL = (SELECT MAX(SALARY) 
                        FROM TEMP2
                        WHERE LEV = i.LEV
                        GROUP BY LEV)
        WHERE CURRENT OF CUR;
    END LOOP;
END;
/
SELECT * FROM EMP_LEVEL1;
/*   3) 1������ ����� TEMP2�� ������ ���� TCOM2 SALARY ���� ���� ����
   (FOR UPDATE NOWIT Ŀ�� ���� �� ROWID ���Խ��� UPDATE�� �̿�) */
DECLARE
    CURSOR C1 IS
    SELECT ROWID RID, EMP_ID, COMM
    FROM TCOM1
    WHERE EMP_ID IN (
        SELECT EMP_ID
        FROM TEMP A
        WHERE DEPT_CODE IN(
                SELECT DEPT_CODE
                FROM TDEPT
                START WITH DEPT_CODE = 'CSO001'
                CONNECT BY PRIOR DEPT_CODE = PARENT_DEPT)
    AND WORK_YEAR = 2019
    )
    FOR UPDATE OF COMM NOWAIT;
BEGIN
    FOR I IN C1 
    LOOP
        UPDATE TCOM1 A
        SET COMM = (SELECT SALARY * 0.01 
                    FROM TEMP B
                    WHERE A.EMP_ID = B.EMP_ID)
        WHERE ROWID = I.RID;
        --
        IF SQL%NOTFOUND THEN
            INSERT INTO TCOM1(WORK_YEAR, EMP_ID, COMM )
            VALUES(2019, I.EMP_ID, I.COMM);
        END IF;
    END LOOP;
    COMMIT;
END;
SELECT * FROM TCOM1;
/*BONUS
1. ���, �μ��ڵ�, SALARY�� �������� ������ INDEX BY ���̺��� ���� ���� ī��Ʈ �Ҵ�� �ѹ� ���� ����
����� ���� ���, �μ��ڵ�, TEMP2�� SALARY�� FOR LOOP ���������� SELECT�ϵ� HINT�� ����Ͽ� EMP_ID �÷��� �ɷ��ִ� �ε����� Ż �� �ֵ���
�����Ͽ� EMP_ID�� SORT �� ��
INDEX BY ���̺� �� �Ǿ� ����.
INDEX BY ���̺��� �о� ���.*/
DECLARE
     TYPE REC IS RECORD
    TYPE T1 IS TABLE OF 
    TEMP2.EMP_ID%TYPE INDEX BY PLS_INTEGER;
    
    V1 T1;
    V2 T2;
    V3 T3;
    CNT NUMBER;
BEGIN
    FOR I IN 1..55
    LOOP
        SELECT EMP_ID, DEPT_CODE, SALARY
        INTO V1(I), V2(I), V3(I)
        FROM TEMP2
        WHERE ROWNUM = I;
        DBMS_OUTPUT.PUT_LINE(V1(I).EMP_ID);
    END LOOP;
END;
--
DECLARE
    TYPE REC IS RECORD(EID NUMBER, DC TDEPT.DEPT_CODE%TYPE, SAL NUMBER);
    TYPE TAB IS TABLE OF REC
    INDEX BY PLS_INTEGER;
    TAB1 TAB;
    C NUMBER:=0;
BEGIN
    FOR I IN (SELECT/*+ INDEX(TEMP2 TEMP2_UK)*/ EMP_ID, DEPT_CODE,SALARY
              FROM TEMP2 WHERE EMP_ID>0)
    LOOP C:=C+1;
    TAB1(C) :=I;
    DBMS_OUTPUT.PUT_LINE('EMP_ID: '|| TAB1(C).EID|| ' DEPT_CODE: '||TAB1(C).DC|| 'SALARY: '||TAB1(C).SAL);
    END LOOP;
END;