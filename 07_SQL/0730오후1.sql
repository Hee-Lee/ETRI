--8. �μ����� �μ����� �����ϰ� ��ݱݾ��� �˾Ƴ������� �μ��ڵ�,�μ���,���,����, ��ݱݾ��� ���ϴ� ������ �ۼ��ϰ����մϴ�.
--   �� �μ����� 10������ ����ϱ� ���� ������ �δ��ؾ��ϴ� �ݾ��� ��ݱݾ��Դϴ�.
--   (�� : �μ����� 5���̸� �� 2������ 4���̸� 2��5õ���� ��ݱݾ��� �������ϴ�)  (�Ҽ��� �Ʒ��� �ø�ó��)
SELECT B.DEPT_CODE, A.DEPT_NAME, EMP_ID, EMP_NAME, B.CO 
FROM TDEPT A,
    (
    SELECT DEPT_CODE, CEIL(100000/COUNT(*)) CO
    FROM TEMP 
    GROUP BY DEPT_CODE) B,
    TEMP C
WHERE A.DEPT_CODE = B.DEPT_CODE
AND A.DEPT_CODE = C.DEPT_CODE;

--9. TEMP���� LEV�� '����'�� ���� ������ ���,����, �޿�, ���, �μ��ڵ�, ��ȭ��ȣ�� �����ִ� VIEW�� ����� 
--   STUDY04 �������� ������ �����Դϴ�.
--   �̶� ���,����, �޿��� READ ONLY�� UPDATE�� ������� ���� �����̸� HOBBY, DEPT_CODE, TEL
--   �� �÷��� ������Ʈ�� ����� �����Դϴ�.
--   VIEW���� �̿��� �� ������ ���� ��Ű�� �� �� �ʿ��� VIEW�� �����.
CREATE OR REPLACE VIEW VIEW9
AS
SELECT EMP_ID, EMP_NAME, SALARY
FROM TEMP
WHERE LEV = '����'
WITH READ ONLY;

CREATE OR REPLACE VIEW VIEW10
AS
SELECT EMP_ID,  HOBBY, DEPT_CODE ,TEL
FROM TEMP
WHERE LEV = '����';

CREATE OR REPLACE VIEW VIEW11
AS
SELECT A.EMP_ID, A.EMP_NAME, A.SALARY, B.HOBBY, B.DEPT_CODE, B.TEL
FROM VIEW9 A, VIEW10 B
WHERE A.EMP_ID = B.EMP_ID;
--10. TEMP�� �÷��鿡 ������ COMMENT�� ���̴� ����� COMMENT�� ���� ����� DICTIONARY���� ��ȸ�ϴ� ������ �ۼ�
COMMENT ON COLUMN TEMP.EMP_ID IS '��� ���̵�';
COMMENT ON COLUMN TEMP.EMP_NAME IS '��� �̸�';
SELECT *
FROM ALL_COL_COMMENTS
WHERE TABLE_NAME = 'TEMP';
--11. SEQ10  �̶�� �������� �����ϵ� 1���� ������ ������ 1�� �ִ� 1000���� �����ϴ� �ٽ� 1�� ��ȯ ä�� �ǵ��� �����ϸ� 
--    �޸𸮿� CACHE ���� �ʰ� �մϴ�.
CREATE SEQUENCE SEQ10
        INCREMENT BY 1
        START WITH 1
        MAXVALUE 1000
        NOCACHE
        CYCLE;
--12. SPEC, ITEM, QTY �� �÷����� ������ BOM ���̺��� �ֽ��ϴ�.
--    T1_DATA�� �̿��� BOM�� ������ ���� �����͸� �ڵ����� �Է��ϰ��� �մϴ�. 
--    (QTY ��  CEIL(DBMS_RANDOM.VALUE(0,3)) �� �̿��� �������� �־����ϴ�)
--    �ش� ������ �ۼ��ϼ���  
SELECT 'S'||A.NO SPEC, 
        'I0'||B.NO ITEM,
        CEIL(DBMS_RANDOM.VALUE(0,3))
FROM T1_DATA A, T1_DATA B
WHERE A.NO <6 AND B.NO<6;
--13. ���̺��, �ó��, �ۺ��ó�� ���� ��Ī ������ ������ �� ���� ���Ǵ� ������ 
--  ����ϰ� ���� Ȯ�� �� �� �ֵ��� ���� �Ͻÿ�.
--��
--���̺�� > �ó�� > �ۺ��ó��
CREATE SYNONYM TEMP1
FOR TDEPT;
CREATE PUBLIC SYNONYM TEMP1
FOR TEVAL;
SELECT * FROM TEMP1;
--�ó�� > �ۺ��ó��
CREATE SYNONYM TEMP200
FOR TDEPT;
CREATE PUBLIC SYNONYM TEMP200
FOR TEVAL;
SELECT * FROM TEMP200;
--14. DAED LOCK �߻��ϴ� ��츦 �� ���� ���� ��� �����ϰ� �����մϴ�.
--�Ѱ����� �������� ���̺�(COMMIT���� ����)�� �ٸ� ������ �����Ϸ��Ҷ� Ʈ������� ������� �ʾ� DAED LOCK�� �߻�
UPDATE TEMP1
SET EMP_NAME = '�������'
WHERE EMP_NAME = '����';
--ADMIN(DBA����)
UPDATE TEMP1
SET EMP_NAME = '�������'
WHERE EMP_NAME = '����'; --�̶� DAED LOCK�� �߻�
--15. �Ҽӵ� �μ��� ��� ���޺��� ���� ������ �޴� ������ �̸�, �޿�, �μ��ڵ� 
SELECT A.EMP_NAME, A.SALARY, A.DEPT_CODE
FROM TEMP A,
    (SELECT DEPT_CODE, AVG(SALARY) AVG_SAL
    FROM TEMP
    GROUP BY DEPT_CODE) B
WHERE A.DEPT_CODE = B.DEPT_CODE
AND A.SALARY>B.AVG_SAL;
