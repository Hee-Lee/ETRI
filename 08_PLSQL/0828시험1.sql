/*1.
  ����� Ŀ���� �Ͻ��� Ŀ���� �Ӽ��� �̿��ϴ� �͸����� �ۼ��ϰ�
  ���� ����� ���̽ÿ�.*/
DECLARE 
    E1 NUMBER;
    
    CURSOR CUR1 IS
    SELECT EMP_ID 
    FROM TEMP;
BEGIN
    OPEN CUR1;
    LOOP
        FETCH CUR1 INTO E1;
        EXIT WHEN  CUR1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(E1);
    END LOOP;
    CLOSE CUR1;
END;
/*2. 
  tcom�� 2019�� �ڷ��� comm�� temp salary�� 2%�� �����ϰ��� �մϴ�.
  �̶� �ٸ� ���α׷��̳� ������ �۾� �� �� �ٸ� ������ �� �� ���� �ϰ��� �մϴ�.
  ���� �䱸�� �����ϴ� �͸� ����� �ۼ��Ͻÿ�*/
DECLARE
     W1 NUMBER;
     E1 NUMBER;
     S1 NUMBER;
     C1 NUMBER;
    
    CURSOR CUR IS
    SELECT A.WORK_YEAR, A.EMP_ID, B.SALARY, A.COMM
    FROM TCOM A, TEMP B
    WHERE A.EMP_ID = B.EMP_ID
    AND A.WORK_YEAR = 2019
    FOR UPDATE;
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR INTO W1, E1, S1, C1;
        EXIT WHEN CUR%NOTFOUND;
        UPDATE TCOM
        SET COMM = E1 * 0.02
        WHERE EMP_ID = E1;
    END LOOP;
    CLOSE CUR;
END;

SELECT * FROM TEMP;
/*3.
  ����� �Ű������� �ָ�
  �ش� ����� �̿��� temp�� �ش� row ������ �о� �� ���� 
  record�� ������ �����ϴ� �Լ��� �ۼ��ϰ�
  �ش� �Լ��� ȣ���� ������ִ� �͸� ����� �ۼ��Ͽ� ���� ����� ���̽ÿ�.*/
CREATE OR REPLACE FUNCTION F1(P1 NUMBER) RETURN TEMP%ROWTYPE IS
    REC TEMP%ROWTYPE;
    
BEGIN
    SELECT *
    INTO REC
    FROM TEMP
    WHERE EMP_ID = P1;
    
    RETURN REC;
END;

DECLARE
    A TEMP%ROWTYPE;
BEGIN
    A := F1(19970101);
    DBMS_OUTPUT.PUT_LINE(A.EMP_ID ||A.EMP_NAME|| A.DEPT_CODE);
END;
/*4. 
  �μ��� �Ҽ��ο� ����� �̱�����
  tdept �� �д� Ŀ����  temp�� �д� Ŀ���� �����ϰ� �̸� �̿���
  �� �μ���� �μ��� ���� ����� ������ ����ϴ� �͸� ����� �ۼ��Ͻÿ�.
  �̶� temp�� �д� Ŀ���� tdept�� �μ��ڵ带 �Ű������� �޾� �ش� �μ��� ������ �о�� ��*/
DECLARE
    CURSOR CUR1 IS
    SELECT *
    FROM TEMP;
    
    CURSOR CUR2 IS
    SELECT *
    FROM TDEPT;
BEGIN
    FOR I IN CUR2 LOOP
        FOR J IN CUR1 LOOP
            IF J.DEPT_CODE = I.DEPT_CODE THEN
                DBMS_OUTPUT.PUT_LINE('�μ��� :'||I.DEPT_NAME||'����� :'||J.EMP_NAME);
            END IF;
        END LOOP;
    END LOOP;
END;
/*5. 
  ���� �� ���� �Ű������� �ָ� 
  t1_data���� �ְ� ���� ã�� ù��° �Ű������� ���� ���� insert�� ��
  ���� insert�� ���� ����ϴ� ���ν��� p_t1_in procedure�ۼ��ϰ�
  ���� ����� ���̽ÿ�.
  �̶� �Ű� ������ �Էµ� ���ڰ� 1���� �۰ų� �ڿ����� �ƴ� ���� ������ ������ �����ϰ�
  ���ǵ� ������ �߻����� exception���� ������ Ʈ���� �� 
  '�ڿ����� �ƴϰų� 0�̹Ƿ� �۾��� ������ �� �����ϴ�.' ��� �޼��� �Ѹ��� ����.
  5�� ����  �߰� ���� : (��: ���� 20000 �� �ְ� ���ε� 3�� �Ű������� �ָ� 20001,20002,20003 �� ���� 
  ���ο� NO ���� ���ܾ� ��) */
CREATE OR REPLACE PROCEDURE P_T1_IN(P1 NUMBER) IS
    MX NUMBER;
    ER EXCEPTION;
BEGIN
    SELECT MAX(NO)
    INTO MX
    FROM T1_DATA;
    
    IF P1<1 OR MOD(P1,1) != P1 THEN
        RAISE ER;
    END IF;
    
    FOR I IN 1..P1 LOOP
        INSERT INTO T1_DATA(NO)
        VALUES (MX+I);
    END LOOP;

EXCEPTION 
    WHEN ER THEN
    DBMS_OUTPUT.PUT_LINE('�ڿ����� �ƴϰų� 0�̹Ƿ� �۾��� ������ �� �����ϴ�.');
END;

/*6.
  temp�� �ڷḦ ��������� Ŀ���� �о� �� �Ǿ� fetch�ϸ�(��� loop�� ����ص� ok)
  tcom1�� 2019�⵵ �ڱ� ����� �ش��ϴ� comm�� select�ؼ�
  temp Ŀ���� salary/12 ���� ���� ����� ���� �޿��� �ϴ� ������ ���
  (���, ���ޱ޿�)
  �̶� select �� ����� ��� ��ü ����� �޿��� ��� ��� �Ǿ�� �մϴ�.
  comm select �ÿ��� �׷��Լ� ����� �����ϸ� ���ߺ������ ó���ؾ� �մϴ�.*/
DECLARE
    CURSOR CUR IS
        SELECT * 
        FROM TEMP
        ORDER BY EMP_ID;

    EID NUMBER;
    COM NUMBER;
BEGIN
    FOR I IN CUR LOOP
    BEGIN
            SELECT EMP_ID, COMM
            INTO EID, COM
            FROM TCOM1
            WHERE WORK_YEAR = 2019
            AND I.EMP_ID = EMP_ID;
            IF I.EMP_ID = EID  THEN
                DBMS_OUTPUT.PUT_LINE('��� :'||I.EMP_ID||'���ޱ޿� :'||ROUND((COM + (I.SALARY/12))));
            ELSE
                DBMS_OUTPUT.PUT_LINE('��� :'||I.EMP_ID||'���ޱ޿� :'||I.SALARY);
            END IF;
            EXCEPTION
            WHEN no_data_found THEN
                DBMS_OUTPUT.PUT_LINE('����');  
    END;
    END LOOP;
END;
