SET SERVEROUTPUT ON
DECLARE
    EVENT VARCHAR2(15);
BEGIN
    EVENT := Q'!FATHER'S DAY!';
    DBMS_OUTPUT.PUT_LINE('3RD SUNDAY IN JUNE IS :'||EVENT);
    EVENT := Q'[MOTHER'S DAY]';
    DBMS_OUTPUT.PUT_LINE('2ND SUNDAY IN MAY IS :'||EVENT);
END;

SET SERVEROUTPUT ON
DECLARE
    bf_var BINARY_FLOAT;
    bd_var BINARY_DOUBLE;
BEGIN
    bf_var := 270/35f;
    bd_var := 140d/0.35;
    DBMS_OUTPUT.PUT_LINE('bf: '||bf_var);
    DBMS_OUTPUT.PUT_LINE('bd: '||bd_var);
END;
--���ε� ����
VARIABLE result NUMBER
BEGIN
    SELECT (SALARY*12) + NVL(COMMISSION_PCT,0)
    INTO :result
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 144;
END;
PRINT result
--
VARIABLE emp_salary NUMBER
SET AUTOPRINT ON
BEGIN
    SELECT salary 
    INTO :emp_salary
    FROM employees
    WHERE employee_id = 178;
END;
--ġȯ����
SET VERIFY OFF
VARIABLE emp_salary NUMBER
ACCEPT empno PROMPT 'Please enter a valid employee number: '
SET AUTOPRINT ON
DECLARE
    empno NUMBER(6) := &empno;
BEGIN
    SELECT salary
    INTO :emp_salary
    FROM employees
    WHERE employee_id = empno;
END;
--���� ������ DEFINE
SET VERIFY OFF
DEFINE lname = Urman
DECLARE
    fname VARCHAR2(25);
BEGIN
    SELECT first_name 
    INTO fname 
    FROM employees
    WHERE last_name='&lname';
END;
--����
--1. ������ �ĺ��ڿ� �������� �ĺ��� �̸��� �����մϴ�. A,B,E,G,H
-- a. today
-- b. last_name
-- c. today��s_date
-- d. Number_of_days_in_February_this_year
-- e. Isleap$year
-- f. #number
-- g. NUMBER#
-- h. number1to7
--2. ���� ���� ���� �� �ʱ�ȭ�� �������� �ĺ��մϴ�.  A, D
-- a. number_of_copies PLS_INTEGER;
-- b. printer_name constant VARCHAR2(10);
-- c. deliver_to VARCHAR2(10):=Johnson;
-- d. by_when DATE:= SYSDATE+1;
--3. ���� �͸� ����� �����ϰ� �ùٸ� ������ �����մϴ�. C
 SET SERVEROUTPUT ON
 DECLARE
  fname VARCHAR2(20);
  lname VARCHAR2(15) DEFAULT 'fernandez';
 BEGIN
  DBMS_OUTPUT.PUT_LINE( FNAME ||' '||lname);
 END;
 /
--  a. ����� ���������� ����ǰ� "fernandez"�� ��µ˴ϴ�.
--  b. fname ������ �ʱ�ȭ���� �ʰ� ���Ǿ��� ������ ������ �߻��մϴ�.
--  c. ����� ���������� ����ǰ� "null fernandez"�� ��µ˴ϴ�.
--  d. VARCHAR2 ������ ������ �ʱ�ȭ�ϴ� �� DEFAULT Ű���带 ����� �� ���� ������
--     ������ �߻��մϴ�.
--  e. ��Ͽ��� FNAME ������ ������� �ʾұ� ������ ������ �߻��մϴ�.
--4. �͸� ����� �����մϴ�. SQL Developer���� ���� 1�� 2�� �������� ������
--   lab_01_02_soln.sql ��ũ��Ʈ�� ���ϴ�.
--  a. �� PL/SQL ��Ͽ� ���� ������ �߰��մϴ�. ���� ���ǿ��� ���� ������ �����մϴ�.
--    1. DATE ������ today ����. today�� SYSDATE�� �ʱ�ȭ�մϴ�.
--    2. today ������ tomorrow ����. %TYPE �Ӽ��� ����Ͽ� �� ������
--       �����մϴ�.
--  b. ���� ���ǿ��� ���� ��¥�� ����ϴ� ǥ����(today ���� 1 �߰�)�� ����Ͽ�
--     tomorrow ������ �ʱ�ȭ�մϴ�. "Hello World"�� ����� �� today�� tomorrow��
--     ���� ����մϴ�.
--  c. �� ��ũ��Ʈ�� �����ϰ� lab_02_04_soln.sql�� �����մϴ�.
DECLARE
    TODAY DATE := SYSDATE;
    TOMORROW TODAY%TYPE;
BEGIN
    TOMORROW := TODAY + 1;
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD '||TOMORROW||TODAY);
END;
--5. lab_02_04_soln.sql ��ũ��Ʈ�� �����մϴ�.
--  a. �� ���� ���ε� ������ �����ϴ� �ڵ带 �߰��մϴ�. NUMBER ������ ���ε� ����
--     basic_percent �� pf_percent�� �����մϴ�.
--  b. PL/SQL ����� ���� ���ǿ��� basic_percent�� pf_percent�� ���� �� 45��
--     12�� �Ҵ��մϴ�.
--  c. "/"�� PL/SQL ����� �����ϰ� PRINT ����� ����Ͽ� ���ε� ���� ���� ǥ���մϴ�.
--  d. ��ũ��Ʈ ������ �����ϰ� lab_02_05_soln.sql�� �����մϴ�. 
VARIABLE basic_percent NUMBER
VARIABLE pf_percent NUMBER
BEGIN
    :basic_percent := 45;
    :pf_percent := 12;
END;
PRINT basic_percent;
PRINT pf_percent;

--10. Pi ��� NUMBER�� ����� �����ϰ� �ʱ� �� 0 �Ҵ� �� 
--    BEGIN SECTION���� �Ҵ� �� 3.14�� �� �Ҵ� �� ����Ͽ� �������� Ȯ���ϱ�
DECLARE 
    PI CONSTANT NUMBER := 0;
BEGIN
    PI := 3.14;
    DBMS_OUTPUT.PUT_LINE('PI :'||PI);
END;
--11. ���ͷ� ���ڿ� �����ڸ� �̿��Ͽ� ������ ����ǥ�� ���� �ۡ� �̶�� ���ڿ� ����ϱ� 
BEGIN
    DBMS_OUTPUT.PUT_LINE(Q'!'���� ����ǥ�� ���� ��'!');
END;
--12. TIMESTAMP ���� �� ���� �����ϰ� INTERVAL DAY TO SECOND ���� �� �����ؼ� 
--    SYSTIMESTAMP �� SYSTIMESTAMP���� 1�� �� ���� 
--    INTERVAL DAY TO SECOND ������ �ְ� �� ���� ���� ����ϱ�
DECLARE
    A TIMESTAMP := SYSTIMESTAMP;
    B TIMESTAMP := SYSTIMESTAMP -1;
    C INTERVAL DAY TO SECOND;
BEGIN
    C := A - B;
    DBMS_OUTPUT.PUT_LINE(A);
    DBMS_OUTPUT.PUT_LINE(B);
    DBMS_OUTPUT.PUT_LINE(C);
END;
--13. V_IS_TRUE ��� BOOLEAN Ÿ���� ������ �����ϰ� TRUE�� �ʱ�ȭ�� �� 
--    BEGIN SECTION ���� CASE ���� ����� V_IS_TRUE �� TRUE �� ��� �����Դϴ١� �� 
--    ����ϰ� FALSE �� ��� �������Դϴ١� �� ���
DECLARE 
    V_IS_TRUE BOOLEAN := TRUE;
BEGIN
    CASE V_IS_TRUE
        WHEN TRUE THEN DBMS_OUTPUT.PUT_LINE('���Դϴ�');
        ELSE DBMS_OUTPUT.PUT_LINE('�����Դϴ�');
    END CASE;
END;
--14. 13���� BOOLEAN ������ 3-2 > 10 �̶�� ���� �ʱ� ������ �Ҵ��ϰ� ���� �� 
--��� ��� Ȯ��
DECLARE 
    V_IS_TRUE BOOLEAN := 3-2 > 10;
BEGIN
    CASE V_IS_TRUE
        WHEN TRUE THEN DBMS_OUTPUT.PUT_LINE('���Դϴ�');
        ELSE DBMS_OUTPUT.PUT_LINE('�����Դϴ�');
    END CASE;
END;
--15. TEMP1�� EMP_NAME�� %TYPE ������ �����ϰ�, 
--    TEMP1���� �� ���� �о� ������ �ִ� TYPE_CHANGE ��� PROCEDURE ����,
CREATE OR REPLACE PROCEDURE TYPE_CHANGE 
IS E_NAME TEMP1.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_NAME
    INTO E_NAME
    FROM TEMP1;
END;
--16. USER_OBJECTS �� ���� ������ ���ν��� Ȯ�� (VALID���� ���ε� �Բ�)
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE';
--17. TEMP1�� EMP_NAME�� 30�ڸ��� Ȯ��
ALTER TABLE TEMP1
MODIFY EMP_NAME VARCHAR2(30);
--18.USER_OBJECTS�� ���� TYPE_CHANGE ���ν��� �� Ȯ�� (VALID����)
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE'
AND OBJECT_NAME = 'TYPE_CHANGE';
--19. EXECUTE TYPE_CHANGE; �� ���ν��� ���� ���� Ȯ��
EXECUTE TYPE_CHANGE;
--20. 18�� �� ����
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE'
AND OBJECT_NAME = 'TYPE_CHANGE';
--
--1.
--IS_BOSS ��� VARCHAR2�� ���ε� ���� ����
--EMP_ID ��� NUMBER�� ���ε� ���� ����
--ENAME�̶�� �������� ���� 'ȫ�浿'���� ����
--�͸� ��� �ۼ�
--    1) ENAME ���������� �̿��� ENAME�� �̸��� ���� ������ �����
--       ���� ����('T' OR 'F')�� ã�Ƽ� ���� EMP_ID, BOSS_ID ���ε� ������ 
--       ���� �Ҵ����ִ� ���� �ۼ�
VARIABLE IS_BOSS VARCHAR2(20)
VARIABLE EMP_ID NUMBER
DECLARE
    ENAME VARCHAR2(20) := 'ȫ�浿';
BEGIN
    SELECT A.EMP_ID, DECODE(B.BOSS_ID,NULL,'F',B.BOSS_ID)
    INTO :EMP_ID, :IS_BOSS
    FROM TEMP A, TDEPT B
    WHERE A.DEPT_CODE = B.DEPT_CODE 
    AND A.EMP_NAME = ENAME;
END;
--    2) EMP_NAME�� BOSS_ID�� ������ IS_BOSS�� 'T', �ٸ��� 'F' �Ҵ�
--       ���� �� EMP_ID�� IS_BOSS ���ε� ���� �� PRINT;
PRINT EMP_ID;
PRINT IS_BOSS;
--2. ���� �������� �������� ��� ġȯ������ �̿��� �̸��� �Է¹޾� ���ε� ������
--   ���� �Ҵ��ϰ� ����Ʈ�ϴ� ��� �ۼ�
VARIABLE IS_BOSS VARCHAR2(20)
VARIABLE EMP_ID NUMBER
DECLARE
    ENAME VARCHAR2(20) := &EN;
BEGIN
    SELECT A.EMP_ID, DECODE(B.BOSS_ID, A.EMP_ID,'T','F')
    INTO :EMP_ID, :IS_BOSS
    FROM TEMP A, TDEPT B
    WHERE A.DEPT_CODE = B.DEPT_CODE 
    AND A.EMP_NAME = ENAME;
END;
--3. BOM ���̺� �׽�Ʈ ������ �ڵ� �Է�
-- SPEC�� S+���� 1�ڸ��� S1���� S5����
-- ITEM�� I + ���� 1�ڸ��� I1���� I7���� ����
-- ù��° LOOP�� 5ȸ ���� S1���� S5���� ����
-- �� ��° ��ø LOOP�� ���� I1���� I7���� �����ϸ�
-- S1, S2, S3�� ��� I7����, S4, S5�� ���� I5������ INSERT
-- �̶� QTY�� DBMS_RANDOM.VALUE�� �̿��� 1���� 3������ ���� ���� �Ҵ� 
if ���� then
else
end if;
DECLARE
    CNT NUMBER := 1;
    CNT2 NUMBER := 1;
BEGIN
    LOOP
        EXIT WHEN CNT > 5;
        LOOP 
            IF CNT < 4 THEN
                EXIT WHEN CNT2 > 7;
                INSERT INTO BOM(SPEC_CODE, ITEM_CODE,ITEM_QTY)
                VALUES('S'||CNT,'I'||CNT2,CEIL(DBMS_RANDOM.VALUE(0,3)));
                CNT2 := CNT2 +1;
            ELSE
                EXIT WHEN CNT2 > 5;
                INSERT INTO BOM(SPEC_CODE, ITEM_CODE,ITEM_QTY)
                VALUES('S'||CNT,'I'||CNT2,CEIL(DBMS_RANDOM.VALUE(0,3)));
                CNT2 := CNT2 +1;
            END IF;
        END LOOP;
        CNT := CNT +1;
        CNT2 := 1;
    END LOOP;
END;
SELECT * FROM BOM;
TRUNCATE TABLE BOM;

--���ν���
CREATE OR REPLACE PROCEDURE(P1 NUMBER, P2 VARCHAR2(10)) P_TEST AS
BEGIN
END;
DECLARE
    PROCEDURE SUB1(P1 TEMP1.EMP_NAME%TYPE, P2 TEMP1.SALARY%TYPE) IS
    BEGIN
        UPDATE TEMP1
        SET SALARY = P2
        WHERE EMP_NAME = P1;
    END SUB1;
BEGIN
    SUB1('������', 88888888);
    SUB1('������', 77777777);
END;
SELECT * FROM TEMP1;
ROLLBACK;
--4. 3���� ��ø����(���η���)�� �������α׷����� ����
DECLARE
    CNT NUMBER := 1;
    CNT2 NUMBER := 1;
    PROCEDURE SUB1(P1 NUMBER, P2 NUMBER) IS
    BEGIN
        INSERT INTO BOM(SPEC_CODE, ITEM_CODE,ITEM_QTY)
                VALUES('S'||P1,'I'||P2,CEIL(DBMS_RANDOM.VALUE(0,3)));
    END SUB1;
BEGIN
    LOOP
        EXIT WHEN CNT > 5;
        IF CNT < 4 THEN
            LOOP 
                EXIT WHEN CNT2 > 7;
                SUB1(CNT,CNT2);
                CNT2 := CNT2 +1;
            END LOOP;
        ELSE
            LOOP 
                EXIT WHEN CNT2 > 5;
                SUB1(CNT,CNT2);
                CNT2 := CNT2 +1;
            END LOOP;
        END IF;
        CNT := CNT +1;
        CNT2 := 1;
    END LOOP;
END;
TRUNCATE TABLE BOM;
SELECT * FROM BOM;