/*1. 사번, 부서코드, SALARY를 조합으로 가지는 INDEX BY 테이블형 변수 선언 카운트 할당용 넘버 변수 선언
실행부 에서 사번, 부서코드, TEMP2의 SALARY를 FOR LOOP 서브쿼리로 SELECT하되 HINT를 사용하여 EMP_ID 컬럼에 걸려있는 인덱스를 탈 수 있도록
유도하여 EMP_ID로 SORT 한 후
INDEX BY 테이블에 한 건씩 저장.
INDEX BY 테이블을 읽어 출력.*/
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
--PACKAGE는 BEGIN을 써도 되지만 대게 쓰지않음
CREATE OR REPLACE PACKAGE TYPE_PACK AS
    TYPE E_REC IS RECORD(EID NUMBER, DC TDEPT.DEPT_CODE%TYPE, SAL NUMBER);
    TYPE E_TAB IS TABLE OF E_REC
    INDEX BY PLS_INTEGER;
    TYPE ETAB IS TABLE OF TEMP%ROWTYPE INDEX BY PLS_INTEGER;
    CURSOR C1 IS
    SELECT *
    FROM TEMP;
END;
--1번 문제 패키지이용
DECLARE
    TAB1 TYPE_PACK.E_TAB; --패키지에 선언한거 사용
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
/*과제1. 
    1.1 TEMP 의 ROW TYPE을 구조로 가지는 INDEX BY 레코드 테이블 TYPE
        TY1, TY2를 선언 합니다.
    1.2 각각의 타입을 이용해 두 개의 TAB11,TAB12(TY1 이용) , TAB21(TY2 이용) 
        변수를 선언합니다
    1.3 TAB11에 TEMP의 자료를 모두 읽어 저장합니다
    1.4 TAB12와 TAB21에 TAB11을 할당합니다
        할당이 잘되는지 확인하고 잘 된다면 TAB12와 TAB21의 내용을 출력합니다.*/
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
/*과제2.
  다음 기능을 가지는 패키지를 정의하고 잘 작동하는지 검증합니다.
  기능1. 일자 정보를 매개변수로 주면 투입계획의 해당 일자의 
        일자, 라인, 투입순번, 스펙 정보를 컬렉션 타입으로 리턴해주는 FUNCTION
  기능2. 기능1의 컬렉션 타입의 한 건을(레코드형)을 매개변수로 주면
        해당 정보를 BOM과 엮어 조달계획에 입력할 수 있는 구조의 컬렉션 타입으로
   정보를 리턴해주는 FUNCTION
  기능3. 기능2의 리턴 정보를 받아 조달계획에 UPDATE후 없으면 INSERT를 수행하는
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