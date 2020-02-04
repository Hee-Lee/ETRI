/*1. ���, �μ��ڵ�, SALARY�� �������� ������ INDEX BY ���̺��� ���� ���� ī��Ʈ �Ҵ�� �ѹ� ���� ����
����� ���� ���, �μ��ڵ�, TEMP2�� SALARY�� FOR LOOP ���������� SELECT�ϵ� HINT�� ����Ͽ� EMP_ID �÷��� �ɷ��ִ� �ε����� Ż �� �ֵ���
�����Ͽ� EMP_ID�� SORT �� ��
INDEX BY ���̺� �� �Ǿ� ����.
INDEX BY ���̺��� �о� ���.*/
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
--PACKAGE�� BEGIN�� �ᵵ ������ ��� ��������
CREATE OR REPLACE PACKAGE TYPE_PACK AS
    TYPE E_REC IS RECORD(EID NUMBER, DC TDEPT.DEPT_CODE%TYPE, SAL NUMBER);
    TYPE E_TAB IS TABLE OF E_REC
    INDEX BY PLS_INTEGER;
    TYPE ETAB IS TABLE OF TEMP%ROWTYPE INDEX BY PLS_INTEGER;
    CURSOR C1 IS
    SELECT *
    FROM TEMP;
END;
--1�� ���� ��Ű���̿�
DECLARE
    TAB1 TYPE_PACK.E_TAB; --��Ű���� �����Ѱ� ���
    C NUMBER:=0;
BEGIN
    FOR I IN (SELECT/*+ INDEX(TEMP2 TEMP2_UK)*/ EMP_ID, DEPT_CODE,SALARY
              FROM TEMP2 WHERE EMP_ID>0)
    LOOP C:=C+1;
    TAB1(C) :=I;
    DBMS_OUTPUT.PUT_LINE('EMP_ID: '|| TAB1(C).EID|| ' DEPT_CODE: '||TAB1(C).DC|| 'SALARY: '||TAB1(C).SAL);
    END LOOP;
END;
--
DECLARE
    ETAB1 TYPE_PACK.ETAB;
    C INTEGER := 0;
BEGIN
    FOR I IN TYPE_PACK.C1
    LOOP
        C := C+1;
        ETAB1(C) := I;
        DBMS_OUTPUT.PUT_LINE(ETAB1(C).EMP_NAME);
    END LOOP;
END;
--
CREATE OR REPLACE PACKAGE P_SAL AS
    TYPE T_EMP IS TABLE OF TEMP2%ROWTYPE
    INDEX BY PLS_INTEGER;
    
    CURSOR CUR IS
    SELECT * 
    FROM TEMP2;
END;

DECLARE
    TAB1 P_SAL.T_EMP;
    TAB2 P_SAL.T_EMP;
    TAB3 P_SAL.T_EMP;
    C NUMBER := 0;
    M_SAL NUMBER := 0;
    K NUMBER := 0;
BEGIN    
    FOR I IN (SELECT /*+INDEX(TEMP2 TEMP2_UK) */ EMP_ID, EMP_NAME, SALARY FROM TEMP2)  LOOP
        C := C + 1;
        TAB1(C) := I;
    END LOOP;
    
    FOR i IN 1..C LOOP
        FOR j IN TAB1.FIRST..TAB1.LAST LOOP
            IF TAB1.EXISTS(j) THEN
                IF j = 1 THEN
                    M_SAL := TAB1(j).SALARY;
                ELSIF M_SAL <= TAB1(j).SALARY THEN
                    M_SAL := TAB1(j).SALARY;
                    K := j;
                END IF;
            END IF;
        END LOOP;
        TAB2(i) := TAB1(K);
        TAB1.DELETE(K);
        DBMS_OUTPUT.PUT_LINE('EMP ID : '||TAB2(i).EMP_ID||'   EMP NAME : '||TAB2(i).EMP_NAME||'    SALARY : '||TAB2(i).SALARY);
    END LOOP; 
END;
/*����1. 
    1.1 TEMP �� ROW TYPE�� ������ ������ INDEX BY ���ڵ� ���̺� TYPE
        TY1, TY2�� ���� �մϴ�.
    1.2 ������ Ÿ���� �̿��� �� ���� TAB11,TAB12(TY1 �̿�) , TAB21(TY2 �̿�) 
        ������ �����մϴ�
    1.3 TAB11�� TEMP�� �ڷḦ ��� �о� �����մϴ�
    1.4 TAB12�� TAB21�� TAB11�� �Ҵ��մϴ�
        �Ҵ��� �ߵǴ��� Ȯ���ϰ� �� �ȴٸ� TAB12�� TAB21�� ������ ����մϴ�.*/
CREATE OR REPLACE PACKAGE PAC AS
    TYPE TY1 IS TABLE OF TEMP%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE TY2 IS TABLE OF TEMP%ROWTYPE INDEX BY PLS_INTEGER;
END;

DECLARE
    TAB11 PAC.TY1;
    TAB12 PAC.TY1;
    TAB21 PAC.TY2;
    C NUMBER := 0;
    
    CURSOR CUR IS
    SELECT *
    FROM TEMP;
BEGIN
    FOR I IN CUR
    LOOP
        C := C + 1;
        TAB11(C) := I;
    END LOOP;

    TAB12 := TAB11;
   -- TAB21 := TAB11;
    FOR I IN TAB11.FIRST..TAB11.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(TAB12(I).EMP_NAME);
        DBMS_OUTPUT.PUT_LINE(TAB21(I).EMP_NAME);
    END LOOP;
END;
--
CREATE OR REPLACE PACKAGE PACK1 AS
    FUNCTION F1(pID NUMBER) RETURN VARCHAR2;
    FUNCTION F2(pNM VARCHAR2) RETURN NUMBER;
END;

CREATE OR REPLACE PACKAGE BODY PACK1 AS
    FUNCTION F1(pID NUMBER) RETURN VARCHAR2 IS
        VNM VARCHAR2(20);
    BEGIN
        SELECT EMP_NAME
        INTO VNM
        FROM TEMP
        WHERE EMP_ID = pID;
        --
        RETURN VNM;
    END;
    --
    FUNCTION F2(pNM VARCHAR2) RETURN NUMBER IS
        VSAL NUMBER;
    BEGIN
        SELECT SALARY
        INTO VSAL
        FROM TEMP
        WHERE EMP_NAME = pNM;
        --
        RETURN VSAL;
    END;
END PACK1;

SELECT EMP_ID,
    PACK1.F1(EMP_ID) NM,
    PACK1.F2(PACK1.F1(EMP_ID)) SAL
FROM TEMP;
--
/*����2.
  ���� ����� ������ ��Ű���� �����ϰ� �� �۵��ϴ��� �����մϴ�.
  ���1. ���� ������ �Ű������� �ָ� ���԰�ȹ�� �ش� ������ 
        ����, ����, ���Լ���, ���� ������ �÷��� Ÿ������ �������ִ� FUNCTION
  ���2. ���1�� �÷��� Ÿ���� �� ����(���ڵ���)�� �Ű������� �ָ�
        �ش� ������ BOM�� ���� ���ް�ȹ�� �Է��� �� �ִ� ������ �÷��� Ÿ������
   ������ �������ִ� FUNCTION
  ���3. ���2�� ���� ������ �޾� ���ް�ȹ�� UPDATE�� ������ INSERT�� �����ϴ�
        PROCEDURE*/
CREATE OR REPLACE PACKAGE PACK2 AS
    TYPE TY1 IS TABLE OF INPUT_PLAN%ROWTYPE
    INDEX BY PLS_INTEGER;
    FUNCTION F1(pDATE VARCHAR2) RETURN TY1;   
END;
    
CREATE OR REPLACE PACKAGE BODY PACK2 AS
  FUNCTION F1(pDATE VARCHAR2) RETURN TY1 IS
     VA TY1;
     CURSOR C1 IS
     SELECT *FROM INPUT_PLAN
     WHERE INPUT_PLAN_DATE=pDATE;
     C NUMBER:=0;
  BEGIN
     FOR I IN C1 LOOP
        C:=C+1;
        VA(C):=I;         
     END LOOP;
     RETURN VA;
  END;
END;