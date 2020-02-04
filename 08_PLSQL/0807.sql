BEGIN
    DBMS_OUTPUT.PUT_LINE(LOWER('WWww'));
    DBMS_OUTPUT.PUT_LINE(UPPER('WWww'));
    DBMS_OUTPUT.PUT_LINE(INITCAP('WWww'));
    DBMS_OUTPUT.PUT_LINE(LPAD('AA',4,'B'));
    DBMS_OUTPUT.PUT_LINE(LTRIM('ABC','A'));
    DBMS_OUTPUT.PUT_LINE(LTRIM('ABC','A'));
    DBMS_OUTPUT.PUT_LINE(LAST_DAY(SYSDATE));
END;
--��ø���
DECLARE 
    outer_variable VARCHAR2(20):='GLOBAL VARIABLE'; 
BEGIN 
    DECLARE inner_variable VARCHAR2(20):='LOCAL VARIABLE'; 
    BEGIN DBMS_OUTPUT.PUT_LINE(inner_variable); 
          DBMS_OUTPUT.PUT_LINE(outer_variable); 
END; 
    DBMS_OUTPUT.PUT_LINE(outer_variable); 
END;
--���� ���� �� ���ü�
DECLARE 
    father_name VARCHAR2(20):='Patrick'; 
    date_of_birth DATE:='1972-04-29'; 
BEGIN 
    DECLARE 
        child_name VARCHAR2(20):='Mike'; 
        date_of_birth DATE:='2002-01-01'; 
    BEGIN DBMS_OUTPUT.PUT_LINE('Father''s Name: '||father_name); 
        DBMS_OUTPUT.PUT_LINE('Date of Birth: '||date_of_birth); 
        DBMS_OUTPUT.PUT_LINE('Child''s Name: '||child_name); 
    END; 
    DBMS_OUTPUT.PUT_LINE('Date of Birth: '||date_of_birth); 
END;
--�ĺ����� ��Ȯ�� ����
<<OUTER>>
DECLARE
    FATHER_NAME VARCHAR2(20) := 'PATRICK';
    DATE_OF_BIRTH DATE := '2002-12-12';
BEGIN
    DECLARE
        CHILD_NAME VARCHAR2(20) := 'MIKE';
        DATE_OF_BIRTH DATE := '1972-04-28';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('FATHER''S NAME: '||FATHER_NAME);
        DBMS_OUTPUT.PUT_LINE('DATE OF BIRTH: '||OUTER.DATE_OF_BIRTH);
        DBMS_OUTPUT.PUT_LINE('CHILD''S NAME: '||CHILD_NAME);
    END;
    DBMS_OUTPUT.PUT_LINE('DATE OF BIRTH: '||DATE_OF_BIRTH);
END;

--���� ���� ����
<<outer>> 
DECLARE 
    sal      NUMBER(7,2) := 60000; 
    comm     NUMBER(7,2) := sal * 0.20; 
    message  VARCHAR2(255) := ' eligible for commission'; 
BEGIN 
    DECLARE 
        sal NUMBER(7,2) := 50000; 
        comm  NUMBER(7,2) := 0; 
        total_comp  NUMBER(7,2) := sal + comm; 
    BEGIN 
        message := 'CLERK not'||message; 
        outer.comm := sal * 0.30;
        DBMS_OUTPUT.PUT_LINE(message);
        DBMS_OUTPUT.PUT_LINE(comm);
        DBMS_OUTPUT.PUT_LINE(outer.comm);
    END; 
    message := 'SALESMAN'||message; 
    DBMS_OUTPUT.PUT_LINE(message);
    DBMS_OUTPUT.PUT_LINE(comm);
END;
--1. PL/SQL ���
DECLARE
 weight NUMBER(3) := 600;
 message VARCHAR2(255) := 'Product 10012';
BEGIN
 DECLARE
  weight NUMBER(3) := 1;
  message VARCHAR2(255) := 'Product 11001';
  new_locn VARCHAR2(50) := 'Europe';
 BEGIN
  weight := weight + 1;
  new_locn := 'Western ' || new_locn;
  -- (1)��
 END;
 weight := weight + 1;
 message := message || ' is in stock';
 new_locn := 'Western ' || new_locn;
  -- (2)��
END;
--1. ���� ���õ� PL/SQL ����� �����Ͽ� ���� ���� ��Ģ�� ���� ���� �� ������ ������ ����
--�� ���� �Ǻ��մϴ�.
--a. 1 ��ġ������ weight ��: 2
--b. 1 ��ġ������ new_locn ��: Westren Europe
--c. 2 ��ġ������ weight ��: 1
--d. 2 ��ġ������ message ��: Product 11001
--e. 2 ��ġ������ new_locn ��: ����
--2. 
--���� ����
DECLARE
 customer VARCHAR2(50) := 'Womansport';
 credit_rating VARCHAR2(50) := 'EXCELLENT';
BEGIN
 DECLARE
  customer NUMBER(7) := 201;
  name VARCHAR2(25) := 'Unisports';
 BEGIN
  credit_rating :='GOOD';
  ��
 END;
��
END;
--2. ���� ���õ� PL/SQL ��Ͽ��� ���� �� ��쿡 �ش��ϴ� �� �� ������ ������ �Ǻ��մϴ�.
--a. ��ø ����� customer ��: 201
--b. ��ø�� ����� name ��: Unisports
--c. ��ø ����� credit_rating ��: GOOD
--d. �� ����� customer ��: EXCELLENT
--e. �� ����� name ��: ����
--f. �� ����� credit_rating ��: Womansport

--3. 
--a. ������ ������ VARCHAR2�̰� ũ�Ⱑ 15�� fname �� ������ ������ NUMBER�̰�
--ũ�Ⱑ 10�� emp_sal�̶�� �� ������ �����մϴ�.
--b. ���� SQL ���� ���� ���ǿ� ���Խ�ŵ�ϴ�.
SELECT first_name, salary
INTO fname, emp_sal FROM employees
WHERE employee_id=110;
--c. 'Hello'�� �̸��� ���. �ʿ��� ��� ��¥�� ǥ��
--d. ���� ���(PF)�� ���� ����� �δ���� ����մϴ�. PF�� �⺻ �޿��� 12%�̸� �⺻
--�޿��� �޿��� 45%�Դϴ�. ����� ���� ���ε� ������ ����մϴ�. ǥ������ �ϳ���
--����Ͽ� PF�� ����մϴ�. ����� �޿� �� PF �δ���� ����մϴ�.
VARIABLE PF NUMBER;
DECLARE
    FNAME VARCHAR2(15);
    EMP_SAL NUMBER(10);
BEGIN
    SELECT first_name, salary
    INTO FNAME, EMP_SAL
    FROM employees
    WHERE employee_id=110;
    DBMS_OUTPUT.PUT_LINE('HELLO '||FNAME);
    :PF := (EMP_SAL * 0.45) * 0.12;
    DBMS_OUTPUT.PUT_LINE('�޿� :'||EMP_SAL||'PF :'||:PF);
END;
--e. ��ũ��Ʈ�� ����
PRINT PF;
--
--1.  ù ��° ������ ���ּ�: ����Ư���� ���ʱ� ���絿 XXX������ ���� �ʱ� �� �Ҵ�
--    �� ��° ������ ù ��° ������ ���̸� �ʱ� ������ �Ҵ�
--    �� ��° ������ ��:�� ���ڰ� ��Ÿ���� ��ġ �� �Ҵ�
--    �� ��° ������ ù ��° �������� �ݷ�(:) ���� ���ں��� ������ ���ڱ��� �Ҵ�
--    BEGIN SECTION���� �� ��° ���� �� ���
DECLARE
    V1 VARCHAR2(100) := '�ּ�: �����Ư���� ���ʱ� ���絿 XXX����';
    V2 NUMBER := LENGTH(V1);
    V3 NUMBER := INSTR(V1,':');
    V4 VARCHAR2(100) := SUBSTR(V1, V3+1);
BEGIN
    DBMS_OUTPUT.PUT_LINE('�� ��° ���� ��: '||V4);
END;
--2.  VARCHAR2(02) ���� �� �� ���� ��3������ �ʱ�ȭ, NUMBER ���� 2�� ���� 20���� �ʱ�ȭ
--    ����1 ������ ����1�� ����2 ���� �Ҵ��ϰ� ����1 ���� ���
--    ����1 ������ ����1�� ����1 ���� �Ҵ��ϰ� ����1 ���� ���    
--    ����1 ������ ����1�� ����2 ���� �Ҵ��ϰ� ����1 ���� ���
DECLARE 
    V1 VARCHAR2(02) := '3';
    V2 VARCHAR2(02) := '3';
    N1 NUMBER := 20;
    N2 NUMBER := 20;
BEGIN
    V1 := N1+N2;
    DBMS_OUTPUT.PUT_LINE('V1 :'||V1);
    V1 := N1+V1;
    DBMS_OUTPUT.PUT_LINE('V1 :'||V1);
    N1 := V1+V2;
    DBMS_OUTPUT.PUT_LINE('N1 :'||N1);
END;
--5.
-- ������ �޾Ƶ��̴� PL/SQL ����� �ۼ��ϰ� ������ �������� ���θ� Ȯ���մϴ�. ����
--���, �Է��� ������ 1990 �̸� "1990 is not a leap year"�� ��µǾ�� �մϴ�.
--��Ʈ: ������ 4�� ��Ȯ�� ������ �������� 100�� ����� �ƴմϴ�. �׷�����
--400�� ����� �����Դϴ�.
--���� ������ �ַ���� �׽�Ʈ�մϴ�.
--1990 Not a leap year
--2000 Leap year
--1996 Leap year
--1886 Not a leap year
--1992 Leap year
--1824 Leap year
DECLARE
    YEAR NUMBER := &YEAR;
BEGIN
    CASE  
        WHEN (MOD(YEAR,4)=0 AND MOD(YEAR,100)!=0) OR MOD(YEAR,400)=0 
        THEN DBMS_OUTPUT.PUT_LINE(YEAR||' LEAP YEAR');
        ELSE DBMS_OUTPUT.PUT_LINE(YEAR||' NOT A LEAP YEAR');
    END CASE;
END;
--6. PL_C VARCHAR2(02) �������� ��3�� ���� �ʱ�ȭ,  PL_N NUMBER�� ���� ���� 20���� �ʱ�ȭ
--    ����ο��� PL_N�� TO_CHAR�� ��ȯ �� PL_C�� IF ������ �� �Ͽ� ū �� Ȯ�� 
if ���� then
else
end if;
DECLARE
    PL_C VARCHAR2(02) := '3';
    PL_N NUMBER := 20;
BEGIN
    IF PL_C>TO_CHAR(PL_N) THEN DBMS_OUTPUT.PUT_LINE('3�� 20���� ũ�ٴ� ���ڸ� ���߱���!');
    ELSE DBMS_OUTPUT.PUT_LINE('20�� 3���� ũ�ٴ� ���ڸ� ���߱���!');
    END IF;
END; 
--7.  1�� ����� ����ȯ ���� ���Ͽ� ��� ����(IF ������ �� ������ �񱳼��� �ٲ㰡�� Ȯ��)
DECLARE
    PL_C VARCHAR2(02) := '3';
    PL_N NUMBER := 20;
BEGIN
    IF PL_C>PL_N THEN DBMS_OUTPUT.PUT_LINE('3�� 20���� ũ�ٴ� ���ڸ� ���߱���!');
    ELSE DBMS_OUTPUT.PUT_LINE('3�� 20���� �۴ٴ� ���ڸ� ���߱���!');
    END IF;
    IF PL_N>PL_C THEN DBMS_OUTPUT.PUT_LINE('20�� 3���� ũ�ٴ� ���ڸ� ���߱���!');
    ELSE DBMS_OUTPUT.PUT_LINE('3�� 20���� ũ�ٴ� ���ڸ� ���߱���!');
    END IF;
END;
--8.  2�� IF������ GREATEST�� �־� �� (�� ������ ���� �ٲ㰡�� ��) ��� ����
DECLARE
    PL_C VARCHAR2(02) := '3';
    PL_N NUMBER := 20;
BEGIN
    IF GREATEST(PL_C, PL_N) = PL_C THEN DBMS_OUTPUT.PUT_LINE('3�� 20���� �۴ٴ� ���ڸ� ���߱���!');
    ELSE DBMS_OUTPUT.PUT_LINE('3�� 20���� ũ�ٴ� ���ڸ� ���߱���!');
    END IF;
    IF GREATEST(PL_N,PL_C) = PL_N THEN DBMS_OUTPUT.PUT_LINE('3�� 20���� ũ�ٴ� ���ڸ� ���߱���!');
    ELSE DBMS_OUTPUT.PUT_LINE('3�� 20���� �۴ٴ� ���ڸ� ���߱���!');
    END IF;
END; 
--9.  HINT�̿� SALARY INDEX�̿� ��ȸ�ϱ�
--  (���ǿ��� 0���� ũ��, ��0������ ũ��, TO_CHAR(SALARY) > ��0�� ���� ����)
SELECT *
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'TEMP'
AND COLUMN_NAME = 'SALARY';

DROP INDEX SALARY1;

CREATE INDEX SAL_IND ON TEMP(SALARY);
--
SELECT /*+ INDEX(TEMP SAL_IND)*/ *
FROM TEMP
WHERE SALARY > 0;
--1. ��ø �ܺκ�Ͽ� PL_OUT ���� ���� ���� �� 'GLOBAL ���� '�Ҵ�,
--��ø ���� ��Ͽ� PL_IN���� ���� ���� �� 'LOCAL ����'�Ҵ�
--���� ���� ��Ͽ��� PL_OUT�� PL_IN ���� ���
DECLARE
    PL_OUT VARCHAR2(20) := 'GLOBAL ����';
BEGIN
    DECLARE
        PL_IN VARCHAR2(20) := 'LOCAL ����';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_OUT);
        DBMS_OUTPUT.PUT_LINE(PL_IN);
    END;
END;
--2. 1������ ��ø���κ�Ͽ� PL_OUT ���� �̸�/�������� �缱�� �� 'OUT�� �̸� ���� LOCAL' �ʱ� �� �Ҵ� �� ����� �Ͽ� ��� ��� Ȯ��
DECLARE
    PL_OUT VARCHAR2(100) := 'GLOBAL ����';
BEGIN
    DECLARE
        PL_IN VARCHAR2(100) := 'LOCAL ����';
        PL_OUT VARCHAR2(100) := 'OUT�� �̸� ���� LOCAL';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_OUT);
        DBMS_OUTPUT.PUT_LINE(PL_IN);
    END;
END;
--3.2���� ��ø���� ��Ϥ��� ���������� ���� PL_OUT�� ��� �߰� �� ���� ��� Ȯ��
DECLARE
    PL_OUT VARCHAR2(100) := 'GLOBAL ����';
BEGIN
    DECLARE
        PL_IN VARCHAR2(100) := 'LOCAL ����';
        PL_OUT VARCHAR2(100) := 'OUT�� �̸� ���� LOCAL';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_OUT);
        DBMS_OUTPUT.PUT_LINE(PL_IN);
    END;
    DBMS_OUTPUT.PUT_LINE(PL_OUT);
END;
--4. �͸��� ����ο� PL_G VARCHAR2(40) ���� �� ;GLOBAL'�� �ʱ�ȭ
--����ο� �Ѱ��� ��ø��� ���� �� ��ø��� ����ο��� PL_L1 VARCHAR2(40)����
--'LOCAL BEGIN 1ST BLOCK'���� �ʱ�ȭ. ��ø��� ����ο��� GLOBAL�� �ڽ��� LOCAL���� ���
DECLARE
    PL_G VARCHAR2(40) := 'GLOBAL';
BEGIN
    DECLARE
        PL_LI VARCHAR2(40) := 'LOCAL BEGIN 1ST BLOCK';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_LI);
    END;
END;
--5. 4�� ����ο� �ι�° ��ø ��� ����� ����ο� PL_L2���� �� 'LOCAL BEGIN 2ND BLOCK'���� �ʱ�ȭ �� �ι�° 
--    ��ø ��� ����ο��� PL_G,PL_L1,PL_L2���(����Ȯ�� �� ���� Ȯ��)
DECLARE
    PL_G VARCHAR2(40) := 'GLOBAL';
BEGIN
    DECLARE
        PL_L1 VARCHAR2(40) := 'LOCAL BEGIN 1ST BLOCK';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_L1);
    END;
    DECLARE 
        PL_L2 VARCHAR2(40) := 'LOCAL BEGIN 2ND BLOCK';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_L1);  
        DBMS_OUTPUT.PUT_LINE(PL_L2); 
    END;
END;
--6. �ܺ� ��Ͽ� <<OUTER>>��� �� ���� �� ��ø ���� ��ϰ� �ܺ� ��Ͽ��� ������ �̸��� ���� ������ �� ���� ��Ͽ��� ������ ��½� 
--  �ϳ��� ���� �տ� OUTER.�ٿ� ����ϰ� �ϳ��� ������ �ʰ� ������ �״�� ���
<<OUTER>>
DECLARE
    PL_G VARCHAR2(40) := 'GLOBAL';
BEGIN
    DECLARE
        PL_G VARCHAR2(40) := 'LOCAL';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(OUTER.PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_G);
    END;
END;
--7. 6������ ��ø ���� ��� �տ� <<INNER>>��� LABEL �����ϰ� ���� ��� ���� �����ڸ��� INNER.�����̸� ����Ͽ� ���� ���� Ȯ��.
<<OUTER>>
DECLARE
    PL_G VARCHAR2(40) := 'GLOBAL';
BEGIN
    <<INNER>>
    DECLARE 
        PL_G VARCHAR2(40) := 'LOCAL';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(OUTER.PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_G);
    END;
    DBMS_OUTPUT.PUT_LINE(INNER.PL_G);
END;
--8. �̸��� PARAMETER�� �ָ� EMP_LEVEL�� ã�� �ش� ������ ������, �ش� ����� ���ް� �޿�
--������ �̿��� ���� �ڷḦ �����ϸ� (�� �� FROM_SAL�� TO_SAL�� SALARY�� ������ �� �ο�),
--SALARY�� ������ ����� ��� SALARY�� �������� ������ ���� ����ġ�� SALARY�� �ٲٰ�
--SALARY�� �������� ũ�� ���� ����ġ�� SALARY�� �ٲپ� �ִ� PROCEDURE �ۼ� �� ����
--(��Ī: SAL_RANGE_CHANGE)
CREATE OR REPLACE PROCEDURE SAL_RANGE_CHANGE(P1 TEMP.EMP_NAME%TYPE) IS
    TLEV VARCHAR2(20);
    TLEV2 VARCHAR2(20);
    SAL NUMBER;
    TSAL NUMBER;
    FSAL NUMBER;
BEGIN
    SELECT A.LEV, A.SALARY, B.LEV, B.FROM_SAL, B.TO_SAL
    INTO TLEV, SAL, TLEV2, FSAL, TSAL
    FROM TEMP A, EMP_LEVEL B
    WHERE EMP_NAME = P1
    AND A.LEV = B.LEV(+);
     
    IF TLEV2 IS NULL
        THEN INSERT INTO EMP_LEVEL(LEV,FROM_SAL,TO_SAL)
                VALUES(TLEV,SAL,SAL);
    END IF;
    IF SAL < FSAL
        THEN UPDATE EMP_LEVEL SET FROM_SAL = SAL WHERE LEV = TLEV;
    END IF;
    IF SAL > TSAL
        THEN UPDATE EMP_LEVEL SET TO_SAL = SAL WHERE LEV = TLEV;
    END IF;
END;
--
EXECUTE SAL_RANGE_CHANGE('�ڽ±�');
ROLLBACK;
SELECT * FROM TEMP;
SELECT * FROM EMP_LEVEL;
--
INSERT INTO TEMP (EMP_ID, EMP_NAME, DEPT_CODE, EMP_TYPE, USE_YN, TEL, HOBBY, SALARY, LEV,EVAL_YN) 
VALUES (19800101,'���ǵ�', 'AB0001', '����','Y',12341234,'TV',0,'����','Y');
--
--9. CREATE TABLE TDEPT2 AS SELECT * FROM TDEPT WHERE DEPT_CODE <> 'AB0001';
--10. PROCEDURE�� �����ϴ� ���� �� �κп��� ���� �־��� �̸����� ����������� �μ��ڵ带 ã�� ������ �����ϰ�
--    TDEPT2�� ��ȸ�� �ش�μ� ������ ������ '�μ� ������ ������ �۾��� ������ �μ� ������ �Է����ּ���.'
--    ��� ��� �� ������ ���� �����ϵ��� �ϸ�, ������ ��� ���� ó�� �� �������� �μ��ڵ� ������ �Բ�
--    '���������� ó���Ǿ����ϴ�.' ���
BEGIN
    SELECT B.DEPT_CODE
    FROM TEMP A, TDEPT B
    WHERE A.EMP_NAME = P1
    AND B.DEPT_CODE = A.DEPT_CODE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(P1||'������ �μ������� ������ �۾��� ������ �μ� ������ �Է����ּ���.');
END;
--���ν��� ��������
IF PL_DEPT IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE(PL_DEPT||'�μ��� ������ ���������� �����Ͽ� ���������� ó���Ǿ����ϴ�.');
END IF
--11. ����Ƽ SALARY �� 1111111���� UPDATE �� ���ν��� ����
--12. ���� PROCEDURE���� ��ø BLOCK �����ϰ� ���� ���� ���� ����� ��
--    - ��ø ����� �����ص� EMP_LEVEL�� DATA�� INSERT, UPDATE �Ǵ���
--13. ��ø BLOCK�� EXCEPTION�� �����ϰ� ��� ��