DECLARE 
    myage number:=31; 
BEGIN 
    IF myage < 11 
    THEN 
        DBMS_OUTPUT.PUT_LINE(' I am a child ');  
    END IF; 
END; 
--null�� ��� else�� �̵���
DECLARE 
    myage number; 
BEGIN 
    IF myage < 11 
    THEN 
        DBMS_OUTPUT.PUT_LINE(' I am a child ');  
    ELSE 
        DBMS_OUTPUT.PUT_LINE(' I am not a child '); 
    END IF; 
END;
--case
DECLARE 
    grade CHAR(1) := UPPER('&grade'); 
    appraisal VARCHAR2(20); 
BEGIN  
    appraisal := 
        CASE grade 
            WHEN 'A' THEN 'Excellent' 
            WHEN 'B' THEN 'Very Good' 
            WHEN 'C' THEN 'Good' 
            ELSE 'No such grade' 
        END; 
DBMS_OUTPUT.PUT_LINE ('Grade: '|| grade || ' Appraisal ' || appraisal); 
END;
--LOOP
DECLARE 
    countryid    locations.country_id%TYPE := 'CA'; 
    loc_id       locations.location_id%TYPE; 
    counter NUMBER(2) := 1; 
    new_city     locations.city%TYPE := 'Montreal'; 
BEGIN 
    SELECT MAX(location_id) 
    INTO loc_id 
    FROM locations 
    WHERE country_id = countryid; 
    LOOP 
        INSERT INTO locations(location_id, city, country_id)   
        VALUES((loc_id + counter), new_city, countryid); 
        counter := counter + 1; 
        EXIT WHEN counter > 3; 
    END LOOP; 
END; 
--WHILE
DECLARE 
    countryid    locations.country_id%TYPE := 'CA'; 
    loc_id       locations.location_id%TYPE; 
    counter NUMBER(2) := 1; 
    new_city     locations.city%TYPE := 'Montreal'; 
BEGIN 
    SELECT MAX(location_id) 
    INTO loc_id 
    FROM locations 
    WHERE country_id = countryid; 
    WHILE COUNTER <= 3 LOOP
        INSERT INTO locations(location_id, city, country_id)   
        VALUES((loc_id + counter), new_city, countryid); 
        counter := counter + 1; 
    END LOOP; 
END;
--FOR
DECLARE 
    countryid    locations.country_id%TYPE := 'CA'; 
    loc_id       locations.location_id%TYPE; 
    new_city     locations.city%TYPE := 'Montreal'; 
BEGIN 
    SELECT MAX(location_id) 
    INTO loc_id 
    FROM locations 
    WHERE country_id = countryid; 
    FOR I IN 1..3 LOOP
        INSERT INTO locations(location_id, city, country_id)   
        VALUES((loc_id + I), new_city, countryid);   
        END LOOP; 
END;
--STUDY04
--JIT_DELIVERY_PLAN ���̺� �ʿ��� ������
--��� PARAMETER�� �޾� �� �Ǿ� �����͸� ���� �Ǵ� �����ϴ�
--PROCEDURE P_JITCHANGE_BYROW
SELECT * FROM STUDY04.JIT_DELIVERY_PLAN;
--1.JIT_CHANGE_BYROW ���ν����� �����ϵ� ��ǲ ���ڴ� ��������. JIT����, ����, ITEM, ������
CREATE OR REPLACE PROCEDURE P_JITCHANGE_BYROW(YM , JITNUM, LINE, ITEM, QTY)
AS

--2. ��ǲ���ڸ� ��� �÷��� ������ ������ �����Ͽ� ���� �Ҵ�
--3. BEGIN���� ��ǲ������ QTY�� �̿��Ͽ� JIT_DELIVERY_PLAN�� QTY�� ������Ʈ �ϵ�
--����� PK�� INPUT���ڷ� ���� ���ǰ� ���� ���ڵ�
--4. SQL%NOTFOUND �̿����� ������ ���� �� INSERT ����
CREATE OR REPLACE PROCEDURE P_JITCHANGE_BYROW(DINPUT JIT_DELIVERY_PLAN.DELIVERY_DATE%TYPE,
                                                JITNUM NUMBER, 
                                                LINE JIT_DELIVERY_PLAN.LINE_NO%TYPE, 
                                                ITEM JIT_DELIVERY_PLAN.ITEM_CODE%TYPE, 
                                                QTY NUMBER)
AS
BEGIN
    UPDATE JIT_DELIVERY_PLAN
    SET ITEM_QTY = ITEM_QTY + QTY
    WHERE DELIVERY_DATE = DINPUT
    AND DELIVERY_SEQ = JITNUM
    AND ITEM_CODE = ITEM
    AND LINE_NO = LINE;
    
    IF SQL%NOTFOUND 
    THEN
        INSERT INTO JIT_DELIVERY_PLAN
        VALUES(DINPUT, LINE, JITNUM,ITEM, QTY, NULL);
    END IF;
END;
--����� CURSOR  <-> �Ͻ���Ŀ�� SQL%FOUND ....
DECLARE
    VEMP NUMBER;
    VNM TEMP.EMP_NAME%TYPE;
    VSAL NUMBER;
    CURSOR CUR1 IS
    SELECT EMP_ID, EMP_NAME, SALARY
    FROM TEMP;
BEGIN
    OPEN CUR1;
    LOOP
        FETCH CUR1
        INTO VEMP, VNM, VSAL;
        EXIT WHEN CUR1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID:'||VEMP||' NAME: '||VNM||' SALARY: '||VSAL);
    END LOOP;
    CLOSE CUR1;
END;
--
/*1.  V_SECONDS ��� VARCHAR2 ������ �����ϰ� �ش� ������ 
    SYSDATE�� �ʿ� �ش��ϴ� ����
    2�ڸ� �Ҵ� �� BEGIN SECTION���� if���� �̿��� �ش� ������ 
    10���� �۰ų� ������ 10���� 
    11�� 20���̸� 20����  ��. 
    51�� 60 ���̸� 60���� �̶�� ������ ����ϴ� �͸� ����ۼ�( IF�� �̿�)*/
DECLARE
    V_SECONDS VARCHAR2(2) := TO_CHAR(SYSDATE,'SS');
BEGIN
    IF V_SECONDS <= 10  
    THEN
        DBMS_OUTPUT.PUT_LINE('10����');
    ELSIF V_SECONDS <= 20 AND V_SECONDS > 10
    THEN
        DBMS_OUTPUT.PUT_LINE('20����');
    ELSIF V_SECONDS <= 30 AND V_SECONDS > 20
    THEN
        DBMS_OUTPUT.PUT_LINE('30����');
    ELSIF V_SECONDS <= 40 AND V_SECONDS > 30
    THEN
        DBMS_OUTPUT.PUT_LINE('40����');
    ELSIF V_SECONDS <= 50 AND V_SECONDS > 40
    THEN
        DBMS_OUTPUT.PUT_LINE('50����');
    ELSIF V_SECONDS <= 60 AND V_SECONDS > 50
    THEN
        DBMS_OUTPUT.PUT_LINE('60����');
    END IF;
END;
--2. 1�� ������ CASE ������ ����;
DECLARE
    V_SECONDS VARCHAR2(2) := TO_CHAR(SYSDATE,'SS');
BEGIN
    CASE    
    WHEN V_SECONDS <= 10 THEN
        DBMS_OUTPUT.PUT_LINE('10����');
    WHEN V_SECONDS <= 20 AND V_SECONDS > 10
    THEN
        DBMS_OUTPUT.PUT_LINE('20����');
    WHEN V_SECONDS <= 30 AND V_SECONDS > 20
    THEN
        DBMS_OUTPUT.PUT_LINE('30����');
    WHEN V_SECONDS <= 40 AND V_SECONDS > 30
    THEN
        DBMS_OUTPUT.PUT_LINE('40����');
    WHEN V_SECONDS <= 50 AND V_SECONDS > 40
    THEN
        DBMS_OUTPUT.PUT_LINE('50����');
    WHEN V_SECONDS <= 60 AND V_SECONDS > 50
    THEN
        DBMS_OUTPUT.PUT_LINE('60����');
    END CASE;
END;
/*3. TEMP�� Ŀ���� �о� �ش� ������ SALARY�� ������ ���� ������
   SALARY����� ���� �� �ݾ��� ���̿� ���̱ݾ��� ���̳ʽ����� �÷��������� 
   ���� ������ �Ҵ�.
   �Ҵ�� ���� ���� �̿��� IF���� ���� ���� ���� ����
   ��հ��� GAP�� 1õ500�������� ũ�� ���� �޴� ���¸� ���ϸ��� �޳�!�� 
   ���� �޴� ���¸� ����ɱ�γ�!��
   GAP�� 1õ500�������� �۰ų� �����鼭 ���� ������ '�� �޳�!�� 
   ���� ������ '�ƽ��� �޳ס� ��հ� ������
   '�� ����̳�!�� �� ��� ��� �͸� ��� �ۼ�*/
DECLARE
    ENM TEMP.EMP_NAME%TYPE;
    SAL NUMBER;
    ASAL NUMBER;
    CURSOR TCUR IS
    SELECT A.EMP_NAME, SALARY, SAL_AVG
    FROM TEMP A,
        (SELECT LEV, ROUND(AVG(SALARY)) SAL_AVG
        FROM TEMP
        GROUP BY LEV)B
    WHERE A.LEV = B.LEV;
BEGIN
    OPEN TCUR;
    LOOP
        FETCH TCUR
        INTO ENM, SAL, ASAL;
        IF (SAL - ASAL) > 15000000 AND SAL > ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM|| ' �ϸ��� �޳�!');
        ELSIF (SAL - ASAL) > 15000000 AND SAL < ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM||' ��� ��γ�');    
        ELSIF (SAL - ASAL) <= 15000000 AND SAL > ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM||' �� �޳�!'); 
        ELSIF (SAL - ASAL) <= 15000000 AND SAL < ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM||' �ƽ��� �޳�');
        ELSIF SAL = ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM||' �� ����̳�!');
        END IF;
        EXIT WHEN TCUR%NOTFOUND;
    END LOOP;
END;

--����
DECLARE
    VNM TEMP.EMP_NAME%TYPE;
    VSAL NUMBER;
    VLEV TEMP.LEV%TYPE;
    VGAP NUMBER;
    VSIGN NUMBER;
    PAVG NUMBER;
    VMSG VARCHAR2(200);
    CURSOR C1 IS
    SELECT EMP_NAME, SALARY, LEV
    FROM TEMP;
BEGIN
    OPEN C1;
    LOOP
        FETCH C1 INTO VNM, VSAL, VLEV;
        EXIT WHEN C1%NOTFOUND;
        SELECT AVG(SALARY)
        INTO PAVG
        FROM TEMP
        WHERE LEV = VLEV;
        VGAP := ABS(VSAL-PAVG);
        VSIGN := SIGN(VSAL-PAVG);
        
        IF VGAP > 15000000 THEN
            IF VSIGN = 1 THEN
                VMSG := '�� ���� �޳�!';
            ELSE
                VMSG := '��ɱ�γ�!';
            END IF;
        ELSE
            IF VSIGN = 1 THEN
                VMSG := '�� �޳�!';
            ELSIF VSIGN =-1 THEN
                VMSG := '�ƽ��� �޳�!';
            ELSE
                VMSG := '�� ����̳�!';
            END IF;
        END IF;
        DBMS_OUTPUT.PUT_LINE(VNM||' '||VMSG);
    END LOOP;
END;
/*4. 2 �� �������� ��� ���� CASE���� �̿��� ������ ���� �Ҵ��ϰ� 
   DBMS_OUTPUT ��� ������ �ѹ��� ����ϵ��� ���� */
DECLARE
    V_SECONDS VARCHAR2(2) := TO_CHAR(SYSDATE,'SS');
    V1 VARCHAR2(20);
BEGIN
    CASE    
    WHEN V_SECONDS <= 10 THEN
        V1 := '10����';
    WHEN V_SECONDS <= 20 AND V_SECONDS > 10
    THEN
        V1 := '20����';
    WHEN V_SECONDS <= 30 AND V_SECONDS > 20
    THEN
        V1 := '30����';
    WHEN V_SECONDS <= 40 AND V_SECONDS > 30
    THEN
        V1 := '40����';
    WHEN V_SECONDS <= 50 AND V_SECONDS > 40
    THEN
        V1 := '50����';
    WHEN V_SECONDS <= 60 AND V_SECONDS > 50
    THEN
        V1 := '60����';
    END CASE;
    DBMS_OUTPUT.PUT_LINE(V1);
END;
/*5. NUMBER ������ �����ϰ� �ʱ�ȭ ���� BEGIN SECTION���� 
   IF ���� ���� ������ 10���� ū ���� ����
   TRUE �̸� ��10���� ū ���� �� ����ϰ� 
   10���� �۰ų� ������  ��10���� �۰ų� ���� ���� ��� 
   ELSE �� ���׷� ���� ��? �� ���*/
DECLARE
    N NUMBER;
BEGIN
    IF N >10
    THEN
        DBMS_OUTPUT.PUT_LINE('10���� ū ��');
    ELSIF N <= 10
        DBMS_OUTPUT.PUT_LINE('10���� �۰ų� ���� ��');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�׷� ���� ��?');
    END IF;
END;
/*6. PL_A �� PL_B ��� �� NUMBER ������ �ʱ�ȭ ���� �����ϰ�, 
   IF������ PL_A = PL_B ���� ���� ������ ' ���� ���� �� ��  ����ϰ�, 
  IF ���� ������ �ٷ� ' IF ���� �̹� ������ ! �� �� ����Ͽ� IF ���� Ÿ����
 ����ϴ��� Ȯ��. */

DECLARE
    PL_A NUMBER;
    PL_B NUMBER;
BEGIN
    IF PL_A = PL_B 
    THEN
        DBMS_OUTPUT.PUT_LINE('���� ���� ��');
    END IF;
    DBMS_OUTPUT.PUT_LINE('IF���� �̹� ������!');
END;
/*7. TRUE �� FALSE�� �� ��찡 AND�� OR�� ���� �� �ִ�
   ������ ����� ���� ���� IF������ ��� ��쿡 TRUE �Ǵ��� Ȯ��  */
DECLARE
    A NUMBER := 1;
    B NUMBER := 2;
BEGIN
    IF A = 1 AND B = 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSIF A = 1 OR B = 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSIF A = 1 AND B != 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('FALSE');
    ELSIF A = 1 OR B != 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSIF A != 1 OR B != 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('FALSE');
    END IF;
END;
/*8. ��������
   EMP_LEVEL1, TCOM1, TEVAL�� 201902 �ڷḦ ��� �����ϰ� COMMIT;
   TEMP�� ��ü ����� Ŀ���� �о� CHANGE_BY_EMP�� �̸��� �Ű������� �־�
   ȣ���� ��ü ����� ���� ������ EMP_LEVEL1, TCOM1, TEVAL�� �Է��ϴ�
   �͸� �� ����*/
DESC TEMP;
DECLARE
    ENM TEMP.EMP_NAME%TYPE;
    CURSOR TCUR IS
    SELECT EMP_NAME
    FROM TEMP;
BEGIN
    OPEN TCUR;
    LOOP
        FETCH TCUR
        INTO ENM;
        EXIT WHEN TCUR%NOTFOUND;
        CHANGE_BY_EMP(ENM);
    END LOOP;
    CLOSE TCUR;
END;
SELECT * FROM TEVAL;
DELETE TEVAL;
COMMIT;

--���ʽ�
--���԰�ȹ�� Ŀ���� �о� �Ѱ� �� FETCH�ϸ� BOM�� ã��
--JIT_PLAN�� �Ѱž� �� ������ �����Ͽ� �� �� ��
--JIT_CHANGE_BYROW�� ȣ���ϴ� ���α׷�
DECLARE
    LINE INPUT_PLAN.LINE_NO%TYPE;
    SPEC INPUT_PLAN.SPEC_CODE%TYPE;
    INDATE INPUT_PLAN.INPUT_PLAN_DATE%TYPE;
    PSEQ INPUT_PLAN.PLAN_SEQ%TYPE;
    ITEM BOM.ITEM_CODE%TYPE;
    IQTY BOM.ITEM_QTY%TYPE;
    
    CURSOR ICUR IS
    SELECT A.SPEC_CODE, A.LINE_NO, A.INPUT_PLAN_DATE, ITEM_CODE, ITEM_QTY, CEIL(PLAN_SEQ/2)
    FROM INPUT_PLAN A, BOM B
    WHERE A.SPEC_CODE = B.SPEC_CODE;
BEGIN
    OPEN ICUR;
    LOOP
        FETCH ICUR
        INTO SPEC, LINE, INDATE, ITEM, IQTY, PSEQ;
        EXIT WHEN ICUR%NOTFOUND;
        P_JITCHANGE_BYROW(INDATE, PSEQ, LINE, ITEM, IQTY);
    END LOOP;
    CLOSE ICUR;
END;
SELECT COUNT(*) FROM JIT_DELIVERY_PLAN;
--���ʽ�
--���԰�ȹ�� Ŀ���� �о� �Ѱ� �� FETCH�ϸ� BOM�� ã��
--JIT_PLAN�� �Ѱž� �� ������ �����Ͽ� �� �� ��
--JIT_CHANGE_BYROW�� ȣ���ϴ� ���α׷�
DECLARE
    LINE INPUT_PLAN.LINE_NO%TYPE;
    SPEC INPUT_PLAN.SPEC_CODE%TYPE;
    INDATE INPUT_PLAN.INPUT_PLAN_DATE%TYPE;
    PSEQ INPUT_PLAN.PLAN_SEQ%TYPE;
    ITEM BOM.ITEM_CODE%TYPE;
    IQTY BOM.ITEM_QTY%TYPE;
    
    CURSOR ICUR IS
    SELECT A.SPEC_CODE, A.LINE_NO, A.INPUT_PLAN_DATE, ITEM_CODE, ITEM_QTY, CEIL(PLAN_SEQ/2)
    FROM INPUT_PLAN A, BOM B
    WHERE A.SPEC_CODE = B.SPEC_CODE;
BEGIN
    OPEN ICUR;
    LOOP
        FETCH ICUR
        INTO SPEC, LINE, INDATE, ITEM, IQTY, PSEQ;
        EXIT WHEN ICUR%NOTFOUND;
        P_JITCHANGE_BYROW(INDATE, PSEQ, LINE, ITEM, IQTY);
    END LOOP;
    CLOSE ICUR;
END;
SELECT COUNT(*) FROM JIT_DELIVERY_PLAN;