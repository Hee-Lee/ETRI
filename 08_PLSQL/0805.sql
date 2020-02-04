DECLARE
    V_FNAME VARCHAR2(20);
BEGIN
    SELECT FIRST_NAME
    INTO V_FNAME
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE('THE FIRST Name of the employee is: '||V_FNAME);
END;
--1. ���� PL/SQL ��� �� ���������� ����Ǵ� ����� �����Դϱ�? D

a. BEGIN
END;
b. DECLARE
amount INTEGER(10);
END;
c. DECLARE
BEGIN
END;
d. DECLARE
amount INTEGER(10);
BEGIN
DBMS_OUTPUT .PUT_LINE(amount);
END;
--2
DECLARE
    HI VARCHAR2(10);
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD'||HI);
END;

--3. ������ ������ ������ �����Ͽ� �� �� �߸��� ������ �Ǻ��ϰ� �� ������ �����մϴ�.
a. DECLARE
name,dept VARCHAR2(14)
b. DECLARE
test NUMBER(5); 
c. DECLARE
MAXSALARY NUMBER(7,2) = 5000;
d. DECLARE
JOINDATE BOOLEAN := SYSDATE; 
--3.�ڽ��� �̸��� ������ ���� �ٰ� �ٸ� �ٿ� ����ϴ� ������ �͸� ��� ���� �ϱ�
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('����');
    DBMS_OUTPUT.PUT_LINE('���ѹα�');
END;
--4.�͸� ��Ͽ��� V$ �� V1 �̶�� ������ �����ϰ�, 
--  V$�� ���������� �ʱ�ȭ�ϰ�, V1�� �ʱ�ȭ ���� BEGIN���� �� ���� �� ����ϱ�
DECLARE
-- V$ NUMBER DEFAULT 0;
    V$ NUMBER := 0;
    V1 NUMBER;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('V$: '||V$);
    DBMS_OUTPUT.PUT_LINE('V1: '||V1);
END;
--5. TEMP ���� �ڱ��̸��� ����� �˻��� ����ϱ�
DECLARE
INFO NUMBER;
INFO1 VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO INFO, INFO1
    FROM TEMP
    WHERE EMP_NAME = '����';
    DBMS_OUTPUT.PUT_LINE('���: '||INFO);
    DBMS_OUTPUT.PUT_LINE('�̸�: '||INFO1);
END;
--6. 5������ �����, �޿��� �Բ� ���
DECLARE
INFO NUMBER;
INFO1 NUMBER;
BEGIN
    SELECT EMP_ID, SALARY
    INTO INFO, INFO1
    FROM TEMP
    WHERE EMP_NAME = '����';
    DBMS_OUTPUT.PUT_LINE('���: '||INFO);
    DBMS_OUTPUT.PUT_LINE('�޿�: '||INFO1);
END;
--7. 5�� ���� ������� ȫ�浿�� �̼����� ����� ��½õ�
DECLARE
    INFO NUMBER;
BEGIN
    SELECT EMP_ID
    INTO INFO
    FROM TEMP
    WHERE EMP_NAME IN ('ȫ�浿', '�̼���');
    DBMS_OUTPUT.PUT_LINE('���: '||INFO);
END;
--8. �͸� ��Ͽ��� NUMBER(10), VARCHAR2(10) , CHAR(10), DATE Ÿ���� ������  
--   ���� �� ���� 8�� ������ ��, �� ����(4���� ���� ������ 1����)�� 
--   �ʱⰪ �Ҵ��ϰ� �������� �ʱⰪ �Ҵ� ���� 8�� ���� ������ VALUE�� LENGTH ���� ����Ͽ� 
--   �ڽ��� ���� ġ�� ���غ��� 
DECLARE
    V1 NUMBER(10) := 1;
    V2 NUMBER(10);
    V3 VARCHAR2(10) := 'HI';
    V4 VARCHAR2(10);
    V5 CHAR(10) := 'HELLO';
    V6 CHAR(10);
    V7 DATE := SYSDATE;
    V8 DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('V1: '||V1);
    DBMS_OUTPUT.PUT_LINE('V1: '||LENGTH(V1));
    DBMS_OUTPUT.PUT_LINE('V2: '||V2);
    DBMS_OUTPUT.PUT_LINE('V2: '||LENGTH(V2));
    DBMS_OUTPUT.PUT_LINE('V3: '||V3);
    DBMS_OUTPUT.PUT_LINE('V3: '||LENGTH(V3));
    DBMS_OUTPUT.PUT_LINE('V4: '||V4);
    DBMS_OUTPUT.PUT_LINE('V4: '||LENGTH(V4));
    DBMS_OUTPUT.PUT_LINE('V5: '||V5);
    DBMS_OUTPUT.PUT_LINE('V5: '||LENGTH(V5));
    DBMS_OUTPUT.PUT_LINE('V6: '||V6);
    DBMS_OUTPUT.PUT_LINE('V6: '||LENGTH(V6));
    DBMS_OUTPUT.PUT_LINE('V7: '||V7);
    DBMS_OUTPUT.PUT_LINE('V7: '||LENGTH(V7));
    DBMS_OUTPUT.PUT_LINE('V8: '||V8);
    DBMS_OUTPUT.PUT_LINE('V8: '||LENGTH(V8));
END;
--
DECLARE
    LC NUMBER != 0;
BEGIN
    LOOP
        LC := LC+1;
        EXIT WHEN 1C >= 10;
    END LOOP;
END;
--9. temp���� ��ü �ο��� ���,�̸�,salary �� ����ϴ� pl/sql  block ����
DECLARE
    PL_ID NUMBER := 0;
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(20);
    SALARY NUMBER;
BEGIN
    LOOP 
        EXIT WHEN PL_ID IS NULL;
        SELECT EMP_ID, EMP_NAME, SALARY
        INTO EMP_ID, EMP_NAME, SALARY
        FROM TEMP
        WHERE EMP_ID = (SELECT MIN(EMP_ID)
                        FROM TEMP
                        WHERE EMP_ID > PL_ID);
        DBMS_OUTPUT.PUT_LINE('�����ȣ: '||EMP_ID||'����̸�: '||EMP_NAME||'SAL: '||SALARY);
        PL_ID := EMP_ID;
    END LOOP;
END;
--
DECLARE
    PL_ID NUMBER := 0;
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(20);
    SALARY NUMBER;
    CNT NUMBER;
    LCNT NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO CNT FROM TEMP;
    LOOP 
        LCNT := LCNT +1;
        EXIT WHEN LCNT > CNT;
        SELECT EMP_ID, EMP_NAME, SALARY
        INTO EMP_ID, EMP_NAME, SALARY
        FROM TEMP
        WHERE EMP_ID = (SELECT MIN(EMP_ID)
                        FROM TEMP
                        WHERE EMP_ID > PL_ID);
        DBMS_OUTPUT.PUT_LINE('�����ȣ: '||EMP_ID||' ����̸�: '||EMP_NAME||' SAL: '||SALARY);
        PL_ID := EMP_ID;
    END LOOP;
END;
--10. N1, N2�̶�� NUMBER Ÿ�� ������ �����ϵ� N2�� �� �� �����ϰ� N1���� �ʱⰪ�� �Ҵ��� N1 �� ����ϱ�
DECLARE 
    N1 NUMBER := 1;
    N2 NUMBER;
    N2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('N1: '||N1);
END;
--11. 10������ N2�� �߰��� ����ϱ� ���� �� ���� Ȯ��
DECLARE 
    N1 NUMBER := 1;
    N2 NUMBER;
    N2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('N1: '||N1);
    DBMS_OUTPUT.PUT_LINE('N2: '||N2);
END;
--12. 10������ N1 ������Ī�� 1N���� �ٲٰ� ���� �� ���� Ȯ��
DECLARE 
    N1 NUMBER := 1;
    N2 NUMBER;
    N2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('N1: '||1N);
END;
--13. CONS1 �̶�� NUMBER�� ����� �����ϰ� �ʱ� �� �Ҵ� ���� ��� �� �������� Ȯ���ϱ�
--  ����̸� CONSTANT VARCHAR2(10);
DECLARE
    CONS1 CONSTANT NUMBER ;
BEGIN
    DBMS_OUTPUT.PUT_LINE('CONS: '||CONS1);
END;
--
DECLARE 
    PL_ID NUMBER;
BEGIN
    SELECT EMP_ID
    INTO PL_ID
    FROM TEMP
    WHERE EMP_ID =0;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ã���ô� ����� �����ϴ�. Ȯ�ιٶ��ϴ�.');
END;
--CREATE �Ѱ��� ������Ʈ ��
CREATE OR REPLACE PROCEDURE P_TEST1 AS
BEGIN
    INSERT INTO TDATE VALUES(SYSDATE);
END;
--Ȯ��
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE'
AND OBJECT_NAME = 'P_TEST1';
--���ν��� ȣ��-- PL/SQL BLOCK���� �̷���� ���α׷�?
EXECUTE P_TEST1;
--
CREATE OR REPLACE FUNCTION F_TEST1 RETURN NUMBER IS
RES NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO RES
    FROM TDATE;
    
    RETURN RES;
END;
--Ȯ��
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION'
AND OBJECT_NAME = 'F_TEST1';

SELECT F_TEST1 FROM DUAL;
--BONUS
--1. �Ʒ��� ������ �����ϴ� �͸��� �ۼ�
--1). TEMP1 DATA ��λ���
DECLARE
BEGIN 
    DELETE TEMP1;
END;
--2). TEMP���� ��̰� NULL�� ������ �о TEMP1�� INSERT...SELECT
SELECT * FROM TEMP;
DECLARE
BEGIN
    
    INSERT INTO TEMP1
    SELECT *
    FROM TEMP
    WHERE HOBBY IS NULL;
END;
--3). TEMP1���� SALARY�� 10% �λ�
DECLARE
BEGIN
    UPDATE TEMP1
    SET SALARY = SALARY * 1.1;
END;

SELECT * FROM TEMP1;
--2.TEMP2 ���̺��� �����ϸ� DROP �� �۾�
--  TEMP���� ��� �����͸� �о� TEMP2�� CREATE �ϴ� �͸�� �ۼ� => ����Ȯ��;
CREATE OR REPLACE TABLE TEMP2
AS
DECLARE
BEGIN
    SELECT *
    FROM TEMP;
END;
--3. TEMP1�� DROP�ϴ� �͸�� �ۼ� => ����Ȯ��
DECLARE
BEGIN
    DROP TABLE TEMP1;
END;
--4. CONG ������ TDEPT�� SELECT ������ �ִ� �͸�� �ۼ� >����Ȯ��
--5. STUDY04���� INPUT_PLAN�� 2019�� 10�� 1���� 1�������� �����͸� �о� 11�� 1���� 1�� �������� INSERT�ϰ�, 
--  10�� 1���� 1������ �ڷ� �����ϴ� �͸��� �ۼ�. �͸��� �ۼ� �� INPUT_PLAN�� SELECT�Ͽ� ���� ��� Ȯ�� �� ROLLBACK;
DECLARE
BEGIN 
    INSERT INTO STUDY04.INPUT_PLAN
    SELECT LINE_NO, SPEC_CODE, 20191101, PLAN_SEQ
    FROM STUDY04.INPUT_PLAN
    WHERE INPUT_PLAN_DATE = 20191001 
    AND LINE_NO = 'L01';
    DELETE STUDY04.INPUT_PLAN
    WHERE INPUT_PLAN_DATE = 20191001;
END;
--6. �͸��Ͽ��� TDATE DATA ��� �����ϰ� P_TEST1�� ȣ�� �� COMMIT;
--  �͸�� ���� �� ��� Ȯ�� P_TEST1;
BEGIN
    DELETE TDATE;
    P_TEST1;
END;
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE'
AND OBJECT_NAME = 'P_TEST1';
--7. 1 ���� 1 ���� ���� ���� 1 �Դϴ�.
--1 ���� 2 ���� ���� ���� 3 �Դϴ�.
--1 ���� 3 ���� ���� ���� 6 �Դϴ�.
--1 ���� 4 ���� ���� ���� 10 �Դϴ�.
--1 ���� 5 ���� ���� ���� 15 �Դϴ�.
--1 ���� 6 ���� ���� ���� 21 �Դϴ�.
--1 ���� 7 ���� ���� ���� 28 �Դϴ�.
--1 ���� 8 ���� ���� ���� 36 �Դϴ�.
--1 ���� 9 ���� ���� ���� 45 �Դϴ�.
--1 ���� 10 ���� ���� ���� 55 �Դϴ�.
DECLARE
    CNT NUMBER := 0;
    LCNT NUMBER := 1;
BEGIN
    LOOP
        EXIT WHEN CNT >= 55;
        CNT := CNT + LCNT;
        DBMS_OUTPUT.PUT_LINE('1����' ||LCNT||'���� ���� ����'||CNT|| '�Դϴ�.');
        LCNT := LCNT+1;
    END LOOP;
END;
--
BEGIN
    DBMS_OUTPUT.PUT_LINE('�ܺκ� START !!!!!!!!!!!!!!!!!!!!!!!');
    DECLARE 
        PL_ID NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('���κ� ����');
        --
        SELECT EMP_ID
        INTO PL_ID
        FROM TEMP
        WHERE EMP_ID = 0;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('���κ� ���� CATCH !!!!!!!!!!!!!!!!!!!');
            RAISE; --���� ����
    END;
    DBMS_OUTPUT.PUT_LINE('�ܺθ��� ���� ����');
    EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('�ܺκ����� ERROR ����');
END;