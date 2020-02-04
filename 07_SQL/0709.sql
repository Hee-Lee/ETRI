--���� ������ �������� ���̿� ���ԵǴ� ����� ������ ���� ���޿� ������� �о����(���,����,����,�������� �� ���� �ּ���)
SELECT T.EMP_ID, T.EMP_NAME, 
        (SYSDATE-T.BIRTH_DATE)/365 AGE, 
        T.LEV
FROM TEMP T, EMP_LEVEL L
WHERE T.BIRTH_DATE BETWEEN ADD_MONTHS(SYSDATE,-1*L.TO_AGE*12) 
AND ADD_MONTHS(SYSDATE,-1*L.FROM_AGE*12)
AND L.LEV = '����';
--
UPDATE TDEPT
    SET BOSS_ID = DECODE(DEPT_CODE, 'AA0001', 19970101, 'BA0001', 19930331)
    WHERE DEPT_CODE IN ('AA0001', 'BA0001');
--
SELECT B.EMP_ID, A.NO||'��' MONTH, DECODE(MOD(A.NO,2),1,B.SAL01,B.SAL02) SALARY
FROM T1_DATA A, T2_DATA B
WHERE A.NO <= 12
ORDER BY 1, A.NO;

SELECT EMP_ID, 
        NO||'��' MONTH, 
        DECODE(NO,1,SAL01,
                    2,SAL02,
                    3,SAL03,
                    4,SAL04,
                    5,SAL05,
                    6,SAL06,
                    7,SAL07,
                    8,SAL08,
                    9,SAL09,
                    10,SAL10,
                    11,SAL11,
                    12,SAL12
                ) SALARY
FROM T1_DATA , T2_DATA 
WHERE NO <= 12
ORDER BY 1, NO;
--�������� ��뿹
SELECT LAST_NAME
FROM EMPLOYEES
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEES
                WHERE LAST_NAME = 'Kochhar');
--�񱳿����ڿ� ������ ������ ���������� ����ؾ��Ѵ�
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                        FROM EMPLOYEES
                        WHERE EMPLOYEE_ID = 101)
AND SALARY > (SELECT SALARY
                FROM EMPLOYEES
                WHERE EMPLOYEE_ID = 141);
--
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY = (SELECT MAX(SALARY)
                FROM EMPLOYEES);
--
SELECT DEPARTMENT_ID, MIN(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING MIN(SALARY) > (SELECT MIN(SALARY)
                        FROM EMPLOYEES
                        WHERE DEPARTMENT_ID = 60);
--IN ����
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY IN (SELECT MAX(SALARY)
                FROM EMPLOYEES
                GROUP BY DEPARTMENT_ID);
--ANY--<ANY �ִ밪���� �۴� >ANY�ּҰ�����ũ��
SELECT LAST_NAME, JOB_ID,SALARY
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY
                    FROM EMPLOYEES
                    WHERE JOB_ID='IT_PROG')
AND JOB_ID <> 'IT_PROG';
--�������� ������� NULL�� ���
SELECT FIRST_NAME, DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                        FROM EMPLOYEES
                        WHERE FIRST_NAME = 'Kimberely');
--ġȯ���� &
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY = &SAL;

SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY = '&NAME';

SELECT LAST_NAME, SALARY, &COL
FROM EMPLOYEES
WHERE &CONDITION
ORDER BY &ORDER;
--&&
SELECT LAST_NAME, SALARY, &&COL
FROM EMPLOYEES
ORDER BY &COL;
--DEFINE
DEFINE V_EMPID = 200
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE EMPLOYEE_ID = &V_EMPID;

--1. SALARY �� ���������� ���� ������ �̸�,SALARY ��������
SELECT EMP_NAME, SALARY
FROM TEMP
WHERE SALARY > (SELECT SALARY
                FROM TEMP
                WHERE EMP_NAME = '������');
--2. �μ��� ��浿�� ���� SALARY�� ���������� ���� ���,����,�μ��ڵ�,SALARY ��������
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM TEMP
WHERE DEPT_CODE = (SELECT DEPT_CODE
                FROM TEMP
                WHERE EMP_NAME = '��浿')
AND SALARY > (SELECT SALARY
                FROM TEMP
                WHERE EMP_NAME = '������');
--3. ���� ������ ���� �޴� ����� �̸�, SALARY �˻� (��������)
SELECT EMP_NAME, SALARY
FROM TEMP 
WHERE SALARY  >=ALL (SELECT SALARY
                    FROM TEMP);
--4. �μ��� ���������� ����ϵ� BC0001�μ��� �������޺��ٴ� ū ���� ��������
SELECT DEPT_CODE, MIN(SALARY)
FROM TEMP
GROUP BY DEPT_CODE
HAVING MIN(SALARY) > (SELECT MIN(SALARY)
                FROM TEMP
                WHERE DEPT_CODE = 'BC0001')
ORDER BY 1;
--5. �� �μ� ���� SALARY�� SALARY�� ���� ���� ���� �˻�
SELECT *
FROM TEMP
WHERE SALARY IN (SELECT MIN(SALARY)
                FROM TEMP
                GROUP BY DEPT_CODE);
--6. ������ ������ ����� �� ������ ��� �� ������ٴ� �޿��� ���� �޴� ��� ���� �������� 
SELECT *
FROM TEMP
WHERE SALARY >ANY (SELECT SALARY
                    FROM TEMP
                    WHERE LEV = '����');

--7. ������ ����� ��� �������� �޿��� ���� �޴� ��� ���� �������� 
SELECT *
FROM TEMP
WHERE SALARY >ALL (SELECT SALARY
                    FROM TEMP
                    WHERE LEV = '���');
--8. 19950303 ������ ��̿� ��̰� ���� ��� ���� ��������
SELECT *
FROM TEMP
WHERE NVL(HOBBY,0) = (SELECT NVL(HOBBY,0)
                    FROM TEMP
                    WHERE EMP_ID = '19950303');
--9. &SAL �̶�� ġȯ������ �Է¹޾� �������� SALARY�� ���� ��� �˻� ���� �ۼ� �� 
--   (���� ���� 50000000, ��50000000��, ��5õ������ �� �־� ���� �����غ��� 
SELECT *
FROM TEMP
WHERE SALARY = &SAL;
--10. 9�� ġȯ������ �յڷ� ���� ����ǥ �ٿ� �����
--   (���� ���� 50000000, ��50000000�� �� �־� ���� �����)
SELECT *
FROM TEMP
WHERE SALARY = '&SAL';
--11. HOBBY�� &HOBBY�� ���� �Է¹޾�  HOBBY�� �Է°��� ���� ���� �˻� ���� �ۼ� ��
--   (���� ���� ���, ����ꡯ �� �־� ���� �����)
SELECT *
FROM TEMP
WHERE HOBBY = &HOBBY;
--12. 11�� ġȯ������ �յڷ� ���� ����ǥ �ٿ� �����
--   (���� ���� ���, ����ꡯ �� �־� ���� �����)
SELECT *
FROM TEMP
WHERE HOBBY = '&HOBBY';
--13. �ڱ� ������ ��� �������� �޿��� ���� �������� �������� 
SELECT A.EMP_NAME, A.SALARY, A.LEV
FROM TEMP A
WHERE SALARY < (SELECT AVG(SALARY)
                    FROM TEMP B
                    WHERE B.LEV = A.LEV);
--14. ��õ�� �ٹ��ϴ� ���� �������� (�������� �̿�) 
SELECT *
FROM  TEMP
WHERE DEPT_CODE IN (SELECT DEPT_CODE
                    FROM TDEPT
                    WHERE AREA = '��õ');
--���ʽ�
--1.TCOM�� ���� �ܿ� COMMISSION�� �޴� ������ ����� �����Ǿ� �ִ�.
--  �� ������ SUB QUERY SELECT �Ͽ� �μ� ��Ī���� COMMISIOIN�� �޴� �ο����� ���� ���� �����
--1�� 4���� ������
SELECT B.DEPT_NAME, COUNT(*)
FROM TEMP A, TDEPT B
WHERE A.DEPT_CODE = B.DEPT_CODE 
AND EMP_ID IN (SELECT EMP_ID
                 FROM TCOM 
                 WHERE WORK_YEAR = '2019')
GROUP BY B.DEPT_NAME;
--2�� �ٳ�����
SELECT B.DEPT_NAME, COUNT(A.EMP_ID)
FROM
    (SELECT B.DEPT_CODE, EMP_ID
    FROM TEMP A, TDEPT B
    WHERE A.DEPT_CODE = B.DEPT_CODE 
    AND EMP_ID IN (SELECT EMP_ID
                     FROM TCOM 
                     WHERE WORK_YEAR = '2019')) A,
    TDEPT B
WHERE B.DEPT_CODE = A.DEPT_CODE(+)
GROUP BY B.DEPT_NAME;
--2.ġȯ������ ���ڸ� �� ���� �Է¹޾� �Է°�, �Է°� +1, �Է°� * 10�� ���ϴ� ����
SELECT &&VAR, &VAR*10, &VAR+10
FROM DUAL;
--3. �ԷµǴ� PARAMETER ���� ���� GROUP BY�� �ϰ� ���� ��� QUERY�ۼ�
--����1: �ԷµǴ� GROUPING ������ �� �� ���� ������(�� ��̺� �μ���)
--     �ϳ��� ���� �� ����(��. ���޺�)
--���� 2: ���� �ڷ�� �׷캰 SALARY ���, �ش��ο���, �׷캰 SALARY ����
--���� 3: �Է� ������ GROUP ������ ������ ����
--
SELECT &IN, AVG(A.SALARY), SUM(A.SALARY), COUNT(A.&IN)
FROM TEMP A, TDEPT B
WHERE A.DEPT_CODE = B.DEPT_CODE AND &IN = A.LEV OR &IN = B.DEPT_CODE OR &IN = B.DEPT_NAME OR &IN = A.HOBBY
GROUP BY &IN;
--
SELECT DECODE(&IN1,'�μ��ڵ�', A.DEPT_CODE,
                   '�μ���', B.DEPT_NAME,
                   '���', A.HOBBY,
                   '����', A.LEV,
                   'ä������', A.EMP_TYPE) GR1,
       DECODE(&IN2,'�μ��ڵ�', A.DEPT_CODE,
                   '�μ���', B.DEPT_NAME,
                   '���', A.HOBBY,
                   '����', A.LEV,
                   'ä������', A.EMP_TYPE) GR2,        
       AVG(SALARY) ���,
       COUNT(EMP_ID) �ش��ο���,
       SUM(SALARY) ��
FROM   TEMP A, TDEPT B
WHERE  A.DEPT_CODE = B.DEPT_CODE
GROUP BY DECODE(&IN1, '�μ��ڵ�', A.DEPT_CODE,
                      '�μ���', B.DEPT_NAME,
                      '���', A.HOBBY,
                      '����', A.LEV,
                      'ä������', A.EMP_TYPE),
         DECODE(&IN2, '�μ��ڵ�', A.DEPT_CODE,
                      '�μ���', B.DEPT_NAME,
                      '���', A.HOBBY,
                      '����', A.LEV,
                      'ä������', A.EMP_TYPE);
SELECT * FROM TEMP
WHERE HOBBY = '����';