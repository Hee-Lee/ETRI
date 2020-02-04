--1. TDEPT�� �μ��ڵ�� �����μ��ڵ� ������ �̿��� CEO001���� ������ TOP-DOWN ����� ���� �˻��� �����ϵ�
--   ����� �μ������� ���ĵǵ��� ���� ����
SELECT LPAD(DEPT_CODE, LENGTH(DEPT_CODE) + (LEVEL)-1, '*'), DEPT_NAME
FROM TDEPT
START WITH DEPT_CODE = 'CEO001'
CONNECT BY PRIOR DEPT_CODE = PARENT_DEPT;
--2. TEMP1�� ��ȭ��ȣ 15�ڸ����� �����̽�(�� ��)�� ��ù�(��-��)�� �����ϰ� �������� ���� 
--���� ���ڸ��� ��� ������(��*��) �� ä��� ONE ������Ʈ ���� �ۼ� �� ���� �� 
--COMMIT (NULL�� �ڷᵵ ��� ������(��*��) �� ä������ ��) 
UPDATE TEMP1 A
SET A.TEL =
            (SELECT LPAD( NVL(REPLACE(REPLACE(TEL,'-',''),' ',''),'*'),15,'*' )
            FROM TEMP1 
            WHERE A.EMP_ID = EMP_ID);

SELECT EMP_ID, TEL FROM TEMP1;
--3. TEMP ���� ��̰� ������ ������ �ƴ� ����(�Է� �ȵ� ���� ����) �� ���� QUERY 54-7 = 47
SELECT COUNT(*)
FROM TEMP
WHERE (HOBBY != '����' AND HOBBY != '����')
OR HOBBY IS NULL;
--4. 
--   4.1 TEMP�� EMP_ID �÷��� ������ ��� �÷��� �ɸ� �ε����� ��ȸ�ϴ� ���� �ۼ�
SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS A
WHERE A.TABLE_NAME = 'TEMP'
AND COLUMN_NAME != 'EMP_ID';
--   4.2 ���� ���� ����� �����Ͽ� EMP_ID�� ������ �÷��� �ɸ� ��� �ε����� DROP �ϴ� ������ ����� ��ȯ�ϴ� �����ۼ�
SELECT 'DROP INDEX ' || C.INDEX_NAME ||';'
FROM   USER_INDEXES I, USER_IND_COLUMNS C
WHERE   C.INDEX_NAME = I.INDEX_NAME
AND      C.TABLE_NAME = 'TEMP'
AND      C.COLUMN_NAME <> 'EMP_ID';  
--   4.3 4.2�� ����� ���� ���� ���� �ε����� DROP;
DROP INDEX UK_EMP_NAME;
DROP INDEX TEMP_SAL_IDX;
--   4.4 SALARY �÷��� SALARY1 �̶�� �̸��� INDEX ����� ������ �ε����� ���̺�� �÷� Ȯ���ϴ� ���� �ۼ�
CREATE INDEX SALARY1
ON TEMP(SALARY);

SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'TEMP'
AND COLUMN_NAME = 'SALARY';
--   4.5 ������ �ε����� �̿��Ͽ� SALARY ������������ ����� �˻� ���� �ۼ�
SELECT /*+INDEX(TEMP, SALARY1)*/EMP_NAME, SALARY
FROM TEMP
ORDER BY SALARY;
--5. TEMP���� �ڹ������� �޿��� ���Թ޴� ���� �˻��Ͽ� ���,����,�޿�,�ڹ����޿� 
--    �Բ� �����ֱ�(��, ANALYTIC  FUNCTION ��� ����)
SELECT A.EMP_ID, A.EMP_NAME, A.SALARY, B.SALARY
FROM TEMP A, (SELECT SALARY FROM TEMP WHERE EMP_NAME = '�ڹ���') B
WHERE A.SALARY < B.SALARY;
--6. TEMP �� EMP_LEVEL �� �̿��� EMP_LEVEL�� ���� ������ ���� ����/���� ���� ���� 
-- ��� ��� ������ ���,����,����,SALARY, ���� ����,���� ���� �о� ����
SELECT * FROM EMP_LEVEL;

SELECT A.EMP_ID, A.EMP_NAME, A.LEV, A.SALARY, B.FROM_SAL, B.TO_SAL 
FROM TEMP A, EMP_LEVEL B, 
        (SELECT FROM_SAL, TO_SAL, LEV FROM EMP_LEVEL WHERE LEV = '����') C
WHERE A.LEV = B.LEV(+)
AND A.SALARY BETWEEN C.FROM_SAL AND C.TO_SAL;
--7. 16������ 125�� ���� ��ȣ�� �ش�Ǵ� ASCII �ڵ� ���� ���ڵ��� 1�ٿ� 5���� �ĸ�(,) �����ڷ� �����ֱ�
SELECT LISTAGG(BB, ',') within group (order by AA)
FROM(
SELECT A.NO AA, CHR(B.NO) BB
FROM T1_DATA A, T1_DATA B 
WHERE A.NO = B.NO AND B.NO BETWEEN 16 AND 125)
GROUP BY  CEIL(AA/5);

--2��°���
select 
max(decode(g, 0, c))||','|| 
max(decode(g, 1, c))||','||  
max(decode(g, 2, c))||','||  
max(decode(g, 3, c))||','||  
max(decode(g, 4, c)) 
from
(
    select no, chr(no) c, mod(rownum - 1, 5) as g, ceil(rownum / 5) as gr
    from t1_data 
    where no between 16 and 125
)
group by gr;