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

CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP(pENAME TEMP.EMP_NAME%TYPE) AS
    vEMP NUMBER;
    vSAL NUMBER;
    vLEV TEMP1.LEV%TYPE;
    vDCD TEMP1.DEPT_CODE%TYPE;
    vDCD1   TEMP1.DEPT_CODE%TYPE;
    vBOSS   NUMBER;
    vTAG    NUMBER :=0;
BEGIN
-- ���1
    SELECT EMP_ID, SALARY, LEV, DEPT_CODE
    INTO vEMP, vSAL, vLEV, vDCD
    FROM TEMP2
    WHERE EMP_NAME = pENAME;
--TCOM1�� INSERT
/*
WORK_YEAR   NOT NULL    VARCHAR2(4)
EMP_ID      NOT NULL    NUMBER
BONUS_RATE              NUMBER
COMM                    NUMBER
*/
    INSERT INTO TCOM1(WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
    SELECT '2019', vEMP, 1, vSAL*0.1
    FROM TEMP2
    WHERE EMP_NAME = pENAME;
    --
    DBMS_OUTPUT.PUT_LINE('INSERT INTO TCOM1 COMPLETE!');
-- ���2 EMP_LEVEL1 UPDATE
    --����� ���� �ű��Է°��� UPDATE �� Ŀ���Ӽ� Ȯ��
    UPDATE EMP_LEVEL1
    SET FROM_SAL    = LEAST(vSAL, FROM_SAL),
        TO_SAL      = GREATEST(vSAL, TO_SAL)
    WHERE   LEV = vLEV;
--���� ���� ���
    DBMS_OUTPUT.PUT_LINE('UPDATE EMP_LEVEL1 COMPLETE!');
    -- Ŀ�� �Ӽ��� NOT FOUND�� ���� INSERT ����
    IF SQL%NOTFOUND THEN
        INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL)
        VALUES (vLEV, vSAL, vSAL);
        DBMS_OUTPUT.PUT_LINE('INSERT INTO EMP_LEVEL1 COMPLETE!');
    END IF;
    
-- ���3
    BEGIN
        SELECT A.DEPT_CODE, DECODE(vEMP, A.BOSS_ID, B.BOSS_ID, A.BOSS_ID)
        INTO vDCD1, vBOSS
        FROM TDEPT2 A, TDEPT B
        WHERE A.DEPT_CODE = vDCD
        AND A.PARENT_DEPT = B.DEPT_CODE;
-- ����
        INSERT INTO TEVAL(YM_EV, EMP_ID, EV_CD, EV_EMP)
        SELECT '201902', vEMP, KNO, vBOSS
        FROM    TCODE
        WHERE   MCD = 'A002';
        DBMS_OUTPUT.PUT_LINE('TEVAL INSERT');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('����ã�� ����');
    END;
    COMMIT;
END;    
-- Ȯ��
SELECT * FROM TCOM1;
SELECT * FROM EMP_LEVEL1;
SELECT * FROM TEVAL
WHERE YM_EV = '201902';
BEGIN
    CHANGE_BY_EMP('������');
END;
ROLLBACK;
TRUNCATE TABLE TCOM1;
TRUNCATE TABLE EMP_LEVEL1;
TRUNCATE TABLE TEVAL;

/*����1. �� �ǽ������� 4�� ���� �����ϴ�.
   - �� ��⿡ �ʿ��� ������ ��ø ��⿡�� ���� �����ϰ� �ֻ��� ��� 
     GLOBAL ������ ��ø ��� ���ο��� ������� �ʽ��ϴ�.
     (�۷ι� ������ ����ϰ� ������ �ݵ�� ���� ������ �Ҵ� �� ���)
   - ���1 : MAIN BLOCK => TEMP���� SELECT => ��ø ������� ���� �ʽ��ϴ�.
   - ���2 : TCOM1�� INSERT
   - ���3 : EMP_LEVEL1 UPDATE OR INSERT
   - ���4 : TEVAL INSERT
   - 2,3�� ����� ���� �� ������ �߻��ϸ� �ܺη� ������ �����մϴ�.
   - 4�� ����� ������ �߻��ϸ� ������� �±� ���� �����Ͽ� ������� ������ �����մϴ�*/
CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP(P1 TEMP2.EMP_NAME%TYPE) AS
    vEMP TEMP1.EMP_ID%TYPE;
    vSAL TEMP1.SALARY%TYPE;
    vLEV TEMP1.LEV%TYPE;
    vDCD TEMP1.DEPT_CODE%TYPE;
    vDCD1 TDEPT2.DEPT_CODE%TYPE;
    vBOSS TDEPT2.BOSS_ID%TYPE;
    vTAG NUMBER := 0;
BEGIN
    SELECT EMP_ID, SALARY, LEV, DEPT_CODE
    INTO vEMP, vSAL, vLEV, vDCD
    FROM TEMP1
    WHERE EMP_NAME = P1;
    --���1
    ---TCOM1�� INSERT
    DECLARE
        lEMP NUMBER := vEMP;
        lSAL NUMBER := vSAL;
    BEGIN
        INSERT INTO TCOM1(WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
        VALUES('2019', lEMP, 1, lSAL*0.1);
        DBMS_OUTPUT.PUT_LINE('INSERT INTO TCOM1 COMPLETE!');
    END;
    --���2
    DECLARE
        lSAL NUMBER := vSAL;
        lLEV TEMP1.LEV%TYPE := vLEV;
    BEGIN
        UPDATE EMP_LEVEL1
        SET FROM_SAL = LEAST(lSAL, FROM_SAL),
            TO_SAL = GREATEST(lSAL, TO_SAL)
        WHERE LEV = lLEV;
        DBMS_OUTPUT.PUT_LINE('UPDATE EMP_LEVEL1 COMPLETE!');
        IF SQL%NOTFOUND THEN
            INSERT INTO EMP_LEVEL1(LEV, FROM_SAL, TO_SAL)
            VALUES(lLEV, lSAL, lSAL);
            DBMS_OUTPUT.PUT_LINE('INSERT INTO EMP_LEVEL1 COMPLETE!');
        END IF;
    END;
    --���3
    DECLARE
        lEMP TEMP1.EMP_ID%TYPE :=vEMP;
        lDCD1 TDEPT2.DEPT_CODE%TYPE := vDCD1;
        lBOSS TDEPT2.BOSS_ID%TYPE := vBOSS;
        lDCD TEMP1.DEPT_CODE%TYPE := vDCD;
    BEGIN
        SELECT A.DEPT_CODE, DECODE(lEMP, A.BOSS_ID, B.BOSS_ID, A.BOSS_ID) BOSS
        INTO lDCD1, lBOSS
        FROM TDEPT A, TDEPT B
        WHERE A.DEPT_CODE = lDCD
        AND A.PARENT_DEPT = B.DEPT_CODE;
        INSERT INTO TEVAL(YM_EV, EMP_ID, EV_CD, EV_EMP)
        SELECT '201902', lEMP, KNO, lBOSS
        FROM TCODE
        WHERE MCD = 'A002';
        DBMS_OUTPUT.PUT_LINE('TEVAL INSERT');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('���� ã�� ����');
    END;
    EXCEPTION 
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('---�ܺ� ������ ���� ����---'); 
        RAISE;
    COMMIT;
END;
/*2. TCOM1�� INSERT �ϴ� ����� CHANGE_BY_EMP ���ο����� ���� ������ �Ǵܵǰ�
   EMP_LEVEL1 �� TEVAL�� DATA ���� ����� Ÿ ���α׷������� ���� ȣ��� ������
   �Ǵܵ˴ϴ�.
   ���� 1�� ����� ���� ���α׷����� ������ �����̸�,
   2,3�� ����� ������ ���ν����� �����Ͽ� CHANGE_BY_EMP���� ȣ���� �����Դϴ�.
   ���� ������ ������ �� �ֵ��� ���α׷��� ������ ���� �ϰ� 
   ������ ����� �Ȱ��� �۵��ǵ��� �����մϴ�.*/
DECLARE
    vEMP TEMP2.EMP_ID%TYPE;
    vSAL TEMP2.SALARY%TYPE;
    ENAME TEMP2.EMP_NAME%TYPE := &NAME;
    
    PROCEDURE SUB(P1 TEMP2.EMP_NAME%TYPE) IS
    BEGIN
    INSERT INTO TCOM1(WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
    VALUES('2019', vEMP, 1, vSAL*0.1);
    DBMS_OUTPUT.PUT_LINE('INSERT INTO TCOM1 COMPLETE!');
    END SUB;
BEGIN
    SELECT EMP_ID, SALARY
    INTO vEMP, vSAL
    FROM TEMP2
    WHERE EMP_NAME = ENAME;
    SUB(ENAME);
    CHANGE_BY_EMP1(ENAME);
END;

CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP(P1 TEMP2.EMP_NAME%TYPE) AS
BEGIN
    CHANGE_BY_EMP2(P1);
    CHANGE_BY_EMP3(P1);
END;
EXECUTE CHANGE_BY_EMP('��ܺ�');
--���2
CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP2(P1 TEMP2.EMP_NAME%TYPE) AS
    vSAL TEMP2.SALARY%TYPE;
    vLEV TEMP2.LEV%TYPE;
BEGIN
    SELECT SALARY, LEV
    INTO vSAL, vLEV
    FROM TEMP2
    WHERE EMP_NAME = P1;
    
    UPDATE EMP_LEVEL1
    SET FROM_SAL = LEAST(vSAL, FROM_SAL),
        TO_SAL = GREATEST(vSAL, TO_SAL)
    WHERE LEV = vLEV;
    DBMS_OUTPUT.PUT_LINE('UPDATE EMP_LEVEL1 COMPLETE!');
    IF SQL%NOTFOUND THEN
        INSERT INTO EMP_LEVEL1(LEV, FROM_SAL, TO_SAL)
        VALUES(vLEV, vSAL, vSAL);
        DBMS_OUTPUT.PUT_LINE('INSERT INTO EMP_LEVEL1 COMPLETE!');
    END IF;
END;

CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP3(P1 TEMP2.EMP_NAME%TYPE) AS
    vEMP TEMP2.EMP_ID%TYPE;
    vDCD1 TDEPT2.DEPT_CODE%TYPE;
    vBOSS TDEPT2.BOSS_ID%TYPE;
    vDCD TEMP2.DEPT_CODE%TYPE;
BEGIN
    SELECT EMP_ID, DEPT_CODE
    INTO vEMP, vDCD
    FROM TEMP2
    WHERE EMP_NAME = P1;
    
    SELECT A.DEPT_CODE, DECODE(vEMP, A.BOSS_ID, B.BOSS_ID, A.BOSS_ID) BOSS
    INTO vDCD1, vBOSS
    FROM TDEPT A, TDEPT B
    WHERE A.DEPT_CODE = vDCD
    AND A.PARENT_DEPT = B.DEPT_CODE;
    INSERT INTO TEVAL(YM_EV, EMP_ID, EV_CD, EV_EMP)
    SELECT '201902', vEMP, KNO, vBOSS
    FROM TCODE
    WHERE MCD = 'A002';
    DBMS_OUTPUT.PUT_LINE('TEVAL INSERT');
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('���� ã�� ����');
    COMMIT;
END;
--���ʽ�
--1. �λ������� ������ ���� ��û�� �߽��ϴ�.
--  3������ �ؿ� ����Ȱ���� ���� ���� 1���� �İ��ؾ� �մϴ�.
--  �������� ���Ǹ� ��� ������ ���� �������� �����ϱ�� �߽��ϴ�.
--  ���̰� �����, ������ ��������, ������ ��������(����,����,����,�븮,�����) �����ϸ�
--  ������ ���� ������� �����մϴ�.
--  ��� ���ǿ� ����ġ�� ��� ���� ����, ����, ���� ���׸� ������ �Ű� ���� ���� ���� ����
--  5���� �����ϱ�� ������, �� 5���� ������� ���� �̱�� �� ���� ���� �� �����Դϴ�.
-- VALUE�� ���� �����̸� ���� ��� �θ��� ���� ���� 1���� ���� ������ 3���Դϴ�.
-- �ش� ���α׷� �ۼ��� ������ ���, ����, �� ����, ����, �޿�, ����, ���߼����� ����ϼ���
--  1���� 5���� ������ ������ ���� �Լ��� �̿�: DBMS_RANDOM.
SELECT *
FROM(
    SELECT EMP_ID, EMP_NAME, SUM_RK,
            AGE, SALARY, LEV,
            RANK() OVER (ORDER BY SUM_RK) AS RK
    FROM
        (SELECT EMP_ID, EMP_NAME,
                FLOOR((SYSDATE - BIRTH_DATE)/365)-1 AGE,
                RANK() OVER (ORDER BY FLOOR((SYSDATE - BIRTH_DATE)/365) -1) AS AGE_RK,
                SALARY,
                RANK() OVER (ORDER BY SALARY) AS SAL_RK,
                LEV,
                RANK() OVER (ORDER BY DECODE(LEV,'����',1,'����',2,'����',3,'�븮',4,'���',5)) AS LEV_RK,
                (RANK() OVER (ORDER BY FLOOR((SYSDATE - BIRTH_DATE)/365) -1)+
                RANK() OVER (ORDER BY SALARY)+
                RANK() OVER (ORDER BY DECODE(LEV,'����',1,'����',2,'����',3,'�븮',4,'���',5))) AS SUM_RK    
        FROM TEMP
        WHERE LEV IN ('����','����','����','�븮','���')
        ORDER BY SUM_RK)
    WHERE ROWNUM <=5
    ORDER BY CEIL(DBMS_RANDOM.VALUE(0,5)))
WHERE ROWNUM = 1;

