create or replace package var as
    i number := 0;
    s varchar2(20) := 'A';
end;

declare
begin
    dbms_output.put_line(var.i);
    dbms_output.put_line(var.s);
end;


declare
begin
    var.i := 1;  --�ٲﰪ���� ��µȴ�.
    var.s := 'B';
    dbms_output.put_line(var.i);
    dbms_output.put_line(var.s);
end;

rollback; --�ѹ��ص� 1,B�� ���´�.

create or replace package var as
 i number := 0;
 s varchar2(20) := 'A';
    cursor c1 is
    select * from temp;
end; --Ŀ���� �����.

-- 1. cursor�� ����� ����� open �� �����Ǵ���
-- 2. Ʈ������� �����ص� �����Ǵ���
-- 3. �ٸ� ���ǿ����� �����Ǵ���
declare
begin
    open var.c1;
    if var.c1%isopen then
        var.s := 'open';
    else
        var.s := 'close';
    end if;
    dbms_output.put_line(var.s);
end;
-- 1. cursor�� ����� ����� open �� �����Ǵ��� : YES
--2.Ʈ������� �����ص� �����Ǵ��� : YES
--3.�ٸ� ���ǿ����� �����Ǵ��� : NO
declare
begin
    if var.c1%isopen then
        var.s := 'open';
    else
        var.s := 'close';
    end if;
    dbms_output.put_line(var.s);
    close var.c1;
END;
--
CREATE OR REPLACE PROCEDURE PR1(P1 OUT NUMBER, P2 IN OUT NUMBER) IS
BEGIN
    P1 := P2;
    P2 := P2*2;
END;

DECLARE
    V NUMBER;
    P NUMBER;
BEGIN
    P := 100;
    PR1(V,P);
    DBMS_OUTPUT.PUT_LINE(V);
    DBMS_OUTPUT.PUT_LINE(P);
END;
--1. ������ ���ν����� �Ķ���� �޴� ���ν���
--    1.1 TEST04 ���̺� YMD:20181201 US_AMOUNT:3000�� �Է�/�����ϴ� P_TEST1 PROCEDURE �ۼ�
create or replace PROCEDURE P_TEST1 as
begin 
    insert into test04 values('20181201', 300);
end; 

execute P_TEST1;
--    1.2 ���ڿ� �ݾ��� PARAMETER�� �޾� TEST04�� INSERT�ϴ� P_TEST02 PROCEDURE �ۼ�
CREATE OR REPLACE PROCEDURE P_TEST02(PYMD OUT NUMBER, PUS IN OUT NUMBER) IS
BEGIN
INSERT INTO TEST04 VALUES(PYMD, PUS);
END;

--2. TID VARCHAR2(10) PK, MESEQ NUMBER �� �÷��� ���� TESQ ���̺� ���� �� TID:KEY1 MSEQ:0 INSERT
CREATE TABLE TSEQ(
    TID VARCHAR2(10),
    MSEQ NUMBER);

ALTER TABLE TSEQ ADD CONSTRAINT TESQ_PK2 PRIMARY KEY(TID);

INSERT INTO TSEQ VALUES('KEY1', 0);
--    2.1 TID�� IN PARAMETER�� �޾� TSEQ���� �ش� TID�� ���� MSEQ�� 1������Ű�� ������ ���� OUT
--    PARAMETER�� �Ѱ��ִ� P_TEST3 PROCEDURE �ۼ�*/  
CREATE OR REPLACE PROCEDURE P_TEST3(pTID IN VARCHAR2, pMSEQ OUT NUMBER) IS
BEGIN
    UPDATE TSEQ 
    SET MSEQ = MSEQ+1;
    
    SELECT MSEQ 
    INTO pMSEQ
    FROM TSEQ
    WHERE TID = pTID;
END;
DECLARE
    V VARCHAR2(08);
    N NUMBER;
BEGIN
    V := 'KEY1';
    P_TEST3(V, N);
    DBMS_OUTPUT.PUT_LINE(N);
END;

SELECT * FROM TSEQ;
--3. TEST0 ���̺� ���� : KEY1 NUMBER PRIMARY KEY, REMARK VARCHAR2(200)
CREATE TABLE TEST0(
    KEY1 NUMBER PRIMARY KEY,
    REMARK VARCHAR2(200)
);
--  3.1 ���ڿ��� PARAMETER �� �޾� TEST0 ���̺� INSERT�ϴ�
--      P_TEST4 PROCEDURE�� ����� PK���� P_TEST3 PROCEDURE�� ���� �޾ƿ� ��
CREATE OR REPLACE PROCEDURE P_TEST4(P1 VARCHAR2) IS
    N NUMBER;
BEGIN
    P_TEST3('KEY1',N);
    INSERT INTO TEST0
    VALUES(P1,N);
END;

--  3.2 TEMP�� EMP_NAME�� FOR LOOP SUBQUERY CURSOR�� �о LOOP ����
--      P_TEST4�� EMP_NAME�� PARAMETER�� �ְ� ȣ���ϴ� P_TEST5 ���ν��� ����
CREATE OR REPLACE PROCEDURE P_TEST5 IS
BEGIN
  FOR I IN (SELECT EMP_NAME FROM TEMP) LOOP
    P_TEST4(I.EMP_NAME);
  END LOOP;
END;
/
EXEC P_TEST4();
--1.function������ update
--    1.1 ������ 1�� �����ϴ� f_test1 �̸��� function �ۼ� �� dual�� �̿� �Լ� ��� select 
        --select f_test1 from dual;
CREATE OR REPLACE FUNC
--    1.2 f_test1�� test04���̺� (20181203, 2000)��  insert�ϴ� ���� �߰� �� �� ���� �� ���� Ȯ��
--2. sub program ���
--    2.1 �ǽ�����1�� 2.1 p_test3 procedure �����Ͽ� select ���� �������α׷� �Լ��� ����ϰ�
--    mseq�� ���� select�ϴ� ���忡�� ���� ���α׷� �Լ� ȣ���ϵ��� �ٲٰ� ������
--3. sub program �̿�
--    3.1 p_test5 ����� �� tseq select �Ͽ� ������ p_test3�� �� ����Ǵ��� Ȯ���ϰ� rollback
--    3.2 select get_mseq from dual;
--    ���� �����Ͽ� ���ν��� ���� ���� ���α׷��� pl_sql block �ۿ��� ȣ���� �� �ִ��� Ȯ��

CREATE TABLE TEMP10 AS
SELECT * FROM TEMP
WHERE ROWNUM < 1;

CREATE OR REPLACE TRIGGER TEMP10_UPDATE
    AFTER UPDATE ON TEMP10 FOR EACH ROW
BEGIN
--1. �μ��� ������ ����� �� �ִ�
    IF  (:OLD.DEPT_CODE <> :NEW.DEPT_CODE) OR
        (:OLD.LEV <> :NEW.LEV)  THEN
            UPD(-1, :OLD.DEPT_CODE, :OLD.LEV);
    --OLD���� �μ�/���޿��� 1 ���� : UPDATE��
            UPD(1, :NEW.DEPT_CODE, :NEW.LEV);
    --NEW���� �μ�/���޿� 1�� ���� : UPDATE �� INSERT
            IF SQL%NOTFOUND THEN
                INS(:NEW.DEPT_CODE, :NEW.LEV);
            END IF;
    END IF;
--2. USE_YN����
    IF :OLD.USE_YN = 'Y' THEN
        IF :NEW.USE_YN <> 'Y' THEN
            UPD(-1, :OLD.DEPT_CODE, :OLD.LEV);
        -- 'Y' => �ٸ� �� : OLD�� �μ�/���޿��� 1 ����
        END IF;
    ELSE
        IF :NEW.USE_YN = 'Y' THEN
            UPD(1, :NEW.DEPT_CODE, :NEW.LEV);
            IF SQL%NOTFOUND THEN
                INS(:NEW.DEPT_CODE, :NEW.LEV);
            END IF;
        -- �ٸ� �� => 'Y' : NEW�� �μ�/���޿� 1�� ����
        END IF;
    END IF;
END;

UPDATE TEMP10
SET USE_YN = 'Y';