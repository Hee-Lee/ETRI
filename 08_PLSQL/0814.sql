CREATE TABLE JIT_CHECK AS
SELECT * FROM JIT_DELIVERY_PLAN
WHERE DELIVERY_DATE = '20000000';

SELECT * FROM JIT_CHECK;
TRUNCATE TABLE JIT_CHECK;
UPDATE JIT_DELIVERY_PLAN
SET ITEM_QTY = ITEM_QTY-1
WHERE DELIVERY_DATE = '20191001'
AND DELIVERY_SEQ = 5;

SELECT COUNT(*) FROM JIT_DELIVERY_PLAN;

SELECT A.SPEC_CODE, A.LINE_NO, A.INPUT_PLAN_DATE, ITEM_CODE, ITEM_QTY, CEIL(PLAN_SEQ/2)
FROM INPUT_PLAN A, BOM B
WHERE A.SPEC_CODE = B.SPEC_CODE;
/*
��¥�� parameter�� �޾Ƽ� �ش� ��¥�� jit_delivery_plan table
������ ����� �Է� �Ǿ� �ִ��� Ȯ���Ͽ� ���� ��ġ�� �ٸ��ٸ� 
��� ����, ��� ����, ��� jit ����, ��� item���� �󸶸�ŭ�� ������ ���̰� ������
Ȯ���Ͽ� jit_check table�� �ش� ��¥ �����Ϳ� ���̳��� �κ��� 
insert ���ִ� procedure (p_jit_plan_check)*/
EXECUTE P_JIT_PLAN_CHECK(20191001);
CREATE OR REPLACE PROCEDURE P_JIT_PLAN_CHECK(P1 JIT_DELIVERY_PLAN.DELIVERY_DATE%TYPE)
AS
    L1  JIT_DELIVERY_PLAN.LINE_NO%TYPE;
    L2  JIT_DELIVERY_PLAN.LINE_NO%TYPE;
    D1  JIT_DELIVERY_PLAN.DELIVERY_DATE%TYPE;
    D2  JIT_DELIVERY_PLAN.DELIVERY_DATE%TYPE;
    I1  JIT_DELIVERY_PLAN.ITEM_CODE%TYPE;
    I2  JIT_DELIVERY_PLAN.ITEM_CODE%TYPE;
    S1  JIT_DELIVERY_PLAN.DELIVERY_SEQ%TYPE;
    S2  JIT_DELIVERY_PLAN.DELIVERY_SEQ%TYPE;
    Q1  JIT_DELIVERY_PLAN.ITEM_QTY%TYPE;
    Q2  JIT_DELIVERY_PLAN.ITEM_QTY%TYPE;
    CURSOR CUR1 IS
    SELECT A.LINE_NO LINE_NO, 
            A.INPUT_PLAN_DATE INPUT_PLAN_DATE, 
            ITEM_CODE, 
            SUM(ITEM_QTY) ITEM_QTY, CEIL(PLAN_SEQ/2) PLAN_SEQ
    FROM INPUT_PLAN A, BOM B
    WHERE A.SPEC_CODE = B.SPEC_CODE
    AND A.INPUT_PLAN_DATE = P1
    GROUP BY A.LINE_NO, A.INPUT_PLAN_DATE, ITEM_CODE, CEIL(PLAN_SEQ/2);
BEGIN
    OPEN CUR1;
    LOOP    
        FETCH CUR1
        INTO L1, D1, I1, Q1, S1;
        SELECT DELIVERY_DATE, LINE_NO, DELIVERY_SEQ, ITEM_CODE, ITEM_QTY
        INTO D2, L2, S2, I2, Q2
        FROM JIT_DELIVERY_PLAN
        WHERE DELIVERY_DATE = D1
        AND LINE_NO = L1
        AND DELIVERY_SEQ = S1
        AND ITEM_CODE = I1
        AND DELIVERY_DATE = P1;
        EXIT WHEN CUR1%NOTFOUND;
        IF L1=L2 AND D1=D2 AND I1=I2 AND S1=S2 AND Q1!=Q2
        THEN
            INSERT INTO JIT_CHECK
            VALUES(D1,L1,S1,I1,Q1-Q2,NULL);
        END IF;
    END LOOP;
    CLOSE CUR1;
END;

SELECT * FROM TEMP;
/*����1. �ְ��� �ݾװ� �� ����ڵ� ����ϱ� (LOOP ������)
  1-1. �ְ�޿� �ݾװ� �޿��� �޴� ���� �̸��� ������ ���� ���� 
  1-2. ���� ������ SALARY ������ �� �ְ� ������  ���� �Ҵ�
  1-3. ���� ������ ���ʷ� FETCH�� ���� ������ �ְ�SALARY���� �� �� SALARY�� ������ �ְ� SALARY ������ �̹� SALARY �Ҵ�
        ���� �̹� SALARY�� ���ΰ��� �ְ����� ������ �Ҵ� 
        (���� SALARY�� ���� MAX SALARY�� ������ ����� ���� �� �ڿ� �ĸ�(,)�ٿ� �̹� ����ID APPEND)
  1-4. �� ���� ��� */
DECLARE
    E_SAL NUMBER;
    E_EMP VARCHAR2(200);
    M_SAL NUMBER;
    M_EMP VARCHAR2(200);
    CURSOR CUR IS
    SELECT EMP_NAME, SALARY
    FROM (SELECT ROWNUM A, EMP_NAME, SALARY
                FROM TEMP)
    WHERE A > 1 ;
BEGIN
    SELECT EMP_NAME, SALARY
    INTO M_EMP, M_SAL
    FROM TEMP
    WHERE ROWNUM = 1;
    OPEN CUR;
    LOOP
        FETCH CUR INTO E_EMP, E_SAL;
        EXIT WHEN CUR%NOTFOUND;
        IF M_SAL < E_SAL THEN
            M_SAL := E_SAL;
            M_EMP := E_EMP;
        ELSIF M_SAL = E_SAL THEN
            M_SAL := E_SAL;
            M_EMP := M_EMP||','||E_EMP;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(M_EMP||' '||M_SAL);
    CLOSE CUR;
END;

--2. FOR LOOP 100ȸ ���� 1���� 100 ���� 100LINE ����ϱ�
BEGIN
    FOR I IN 1..100
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
--3. WHILE LOOP 3ȸ ���� ����ī���� ���
DECLARE
    CNT NUMBER :=1 ;
BEGIN
    WHILE CNT < 4
    LOOP
        DBMS_OUTPUT.PUT_LINE(CNT);
        CNT := CNT+1;
    END LOOP;
END;
/*4. While Loop�� �̿��� Power �Լ��� ������ ����� �ϴ� 
   SQUARE1 �Լ� ����� (�Լ� ������ 2��°
  ���ڷ� ���� ���� ������ ��� SQRT �Լ��� ����� �� ������ 
  ��� ���� ������ ��� POWER �Լ���
  ���� ��� �������� ** ��� �Ұ��ϸ� WHILE LOOP���� �ذ� �� ��)*/
CREATE OR REPLACE FUNCTION SQUARE1(P1 NUMBER, P2 NUMBER)
 RETURN NUMBER
IS
    CNT NUMBER := 0;
    NUM NUMBER := 1;
BEGIN
    IF P2 >= 0
    THEN
        WHILE CNT < P2 
        LOOP
            NUM := NUM * P1;
            CNT := CNT + 1;
        END LOOP;
    ELSIF P2 < 0
    THEN
        NUM := SQRT(P1);
    END IF;
    RETURN NUM;
END;
SELECT SQUARE1(2,4) FROM DUAL;
--5. ����ī����, �հ�� NUMBER ������ ���� �����ϰ� 0 ���� �ʱ�ȭ�� �� 
--   �⺻ LOOP�� 20ȸ �������
--   ī���͸� 1�� ���� ��Ű�� ����ī���� ���� ����ī������ ��������� ���� ���� ���
DECLARE
    CNT NUMBER := 0;
    SNUM NUMBER := 0;
BEGIN
    LOOP
    EXIT WHEN CNT >19;
        CNT := CNT + 1;
        SNUM := SNUM + CNT;
        DBMS_OUTPUT.PUT_LINE(CNT);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(SNUM);
END;
--6. 5�� ������ WHIE LOOP���� �ٲٱ�
DECLARE
    CNT NUMBER := 0;
    SNUM NUMBER := 0;
BEGIN
    WHILE CNT < 20
    LOOP
        CNT := CNT + 1;
        SNUM := SNUM + CNT;
        DBMS_OUTPUT.PUT_LINE(CNT);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(SNUM);
END;
--7. 6�� ������ FOR LOOP ���� �ٲٱ�
DECLARE
    CNT NUMBER := 0;
    SNUM NUMBER := 0;
BEGIN
    FOR I IN 1..20
    LOOP
        CNT := I;
        SNUM := SNUM + CNT;
        DBMS_OUTPUT.PUT_LINE(CNT);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(SNUM);
END;
--���ʽ� ���͵���簡���ض�
--BONUS1. INPUT_PLAN ������ IN_SEQ ���̺� ����(��� �÷� NULL ���, PK����)

--BONUS2. ���� 10�� 1���� ���� ��ȹ�� ������ ���� �Է��ϱ� ���� �͸� ��� �ۼ� ��ø������ �ذ�
BEGIN
    FOR i IN 1..3 LOOP
        FOR j IN 1..10 LOOP
                INSERT INTO IN_SEQ(INPUT_PLAN_DATE, LINE_NO, PLAN_SEQ, SPEC_CODE)
                VALUES('20191001', 'L0'||i, j, 'S0'||CEIL(j/2));
        END LOOP;
    END LOOP;
END;
--BONUS3. PL_DATE VARCHAR2(08)�� �����ϰ� �ʱⰪ���� '20191102' �Ҵ�
-- FOR LOOP�� 5ȸ ���� ����ī���͸� �̿��� DELIVERY_SEQ��
-- PLAN_DATE�� DELIVERY_SEQ �÷� �� �Է�
-- ���̺��� �Է� ���ο� ������ ���� Ȯ���ϰ� ���� �� COMMIT;



--BONUS4. �� �ڵ带 �״�� �̿��� 5ȸ ¥��
-- FOR LOOP �ܰ��� �߰��ϰ� INSERT�������� ���� �߰���
-- FOR ���� ����ī���͸� �̿��� LINE�� SPEC�÷� �߰� �Է�.
-- �Է³��� �� ���� Ȯ���ϰ� ������ ���� �� COMMIT

--BONUS5. �� INSERT������ ���� �տ� SPEC�� S LINE�� L���ڸ� �տ� ���̰�
-- LPAD ������ S01, L01 �������� ���� �� ������ Ȯ�� �� ����


--BONUS6. �� �ڵ带 �״�� �̿��� �ܰ��� 5ȸ¥�� FOR LOOP���� ���ΰ�
-- END LOOP �ٷ� ������ PL_DATE ��¥ 1�� ����
SELECT '20191102' + I - 1 IDATE,
       'L'||LPAD(J,2,'0') LINE,
       'S'||LPAD(J,2,'0') SPEC,
       K IN_SEQ
FROM (SELECT NO I FROM T1_DATA WHERE ROWNUM <= 5) A,
     (SELECT NO J FROM T1_DATA WHERE ROWNUM <= 5) B,
     (SELECT NO K FROM T1_DATA WHERE ROWNUM <= 5) C;
