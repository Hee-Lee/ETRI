--���߿��������� PAIRWISE
SELECT EMPLOYEE_ID, MANAGER_ID, DEPARTMENT_ID
FROM EMPLOYEES
WHERE (MANAGER_ID, DEPARTMENT_ID) IN
        (SELECT MANAGER_ID,DEPARTMENT_ID
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID IN (174,178))
AND EMPLOYEE_ID NOT IN(174, 178);
--NONPAIRWISE
SELECT EMPLOYEE_ID, MANAGER_ID, DEPARTMENT_ID
FROM EMPLOYEES
WHERE MANAGER_ID IN
        (SELECT MANAGER_ID
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID IN (174,178))
AND     DEPARTMENT_ID IN
       (SELECT DEPARTMENT_ID
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID IN (174,178))
AND EMPLOYEE_ID NOT IN(174, 178);
--��Į�� �������� CASE
SELECT EMPLOYEE_ID, LAST_NAME,
        (CASE
        WHEN DEPARTMENT_ID =
                        (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE LOCATION_ID = 1800)
        THEN 'Canada' ELSE 'USA' END) LOCATION
FROM EMPLOYEES;
--��Į�� �������� ORDER BY
SELECT EMPLOYEE_ID, LAST_NAME
FROM EMPLOYEES E
ORDER BY (SELECT DEPARTMENT_NAME
            FROM DEPARTMENTS D
            WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID);
--���� ��������
SELECT LAST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES OUTER
WHERE SALARY >
                (SELECT AVG(SALARY)
                FROM EMPLOYEES
                WHERE DEPARTMENT_ID = OUTER.DEPARTMENT_ID);
--���� ��������
SELECT E.EMPLOYEE_ID, LAST_NAME, E.JOB_ID
FROM EMPLOYEES E
WHERE 2 <= (SELECT COUNT(*)
            FROM JOB_HISTORY
            WHERE EMPLOYEE_ID = E.EMPLOYEE_ID);
--���� UPDATE
ALTER TABLE EMPLOYEES
MODIFY (DEPARTMENT_NAME VARCHAR2(20));

UPDATE EMPLOYEES E
SET DEPARTMENT_NAME = 
            (SELECT DEPARTMENT_NAME
            FROM DEPARTMENTS D
            WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID);
SELECT * FROM EMPLOYEES;
COMMIT;
--���� DELETE
DELETE EMPLOYEES E
WHERE DEPARTMENT_NAME = 
            (SELECT DEPARTMENT_NAME
            FROM DEPARTMENTS D
            WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID);
ROLLBACK;
--WITH��
WITH
DEPT_COSTS AS (
            SELECT D.DEPARTMENT_NAME, SUM(E.SALARY) AS DEPT_TOTAL
            FROM EMPLOYEES E, DEPARTMENTS D
            WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
            GROUP BY D.DEPARTMENT_NAME),
AVG_COST AS (
        SELECT SUM(DEPT_TOTAL) / COUNT(*) AS DEPT_AVG
        FROM DEPT_COSTS)
SELECT *
FROM DEPT_COSTS
WHERE DEPT_TOTAL >
    (SELECT DEPT_AVG
    FROM AVG_COST)
ORDER BY DEPARTMENT_NAME;
--
CREATE TABLE TEST09 (LINE VARCHAR2(3),
                    SPEC VARCHAR2(10),
                    ITEM VARCHAR2(8),
                    QTY NUMBER,
                    CONSTRAINTS TEST09_PK PRIMARY KEY (LINE,SPEC,ITEM)
                    );
CREATE TABLE TEST10 (IDATE VARCHAR2(8) NOT NULL,
                    IN_SEQ VARCHAR2(3) NOT NULL,
                    LINE VARCHAR2(3) NOT NULL,
                    SPEC VARCHAR2(10) NOT NULL,
                    CONSTRAINTS TEST10_PK
                                PRIMARY KEY (IDATE,IN_SEQ,LINE)
                    );
--
SELECT * FROM TEST09;
SELECT * FROM TEST10;
--1.������������(TEST10)�� ������ SPEC ������ �̿��� BOM(TEST09) ���̺��� �ʿ� ��ǰ ����Ʈ �̱�
-- SUBQUERY 
--1.1 NON-PAIRWISING
SELECT DISTINCT ITEM
FROM TEST09 
WHERE LINE IN (SELECT LINE
                FROM TEST10
                WHERE IDATE = '19990203')
AND      SPEC IN (SELECT SPEC
                FROM TEST10
                WHERE IDATE = '19990203')
MINUS;
SELECT DISTINCT ITEM
FROM TEST09 
WHERE (LINE, SPEC) IN (SELECT LINE, SPEC
                FROM TEST10
                WHERE IDATE = '19990203');
SELECT * FROM TEST09
WHERE ITEM = 'P16';
SELECT * FROM TEST10
WHERE LINE = 03 AND SPEC = 'A002';
SELECT * FROM TEST10 WHERE SPEC = 'A002';
--2.1999�� 2�� 3�� �ҿ俹�� ��ǰ�� ��ǰ�� ������ �ľ��� ���ָ� ���� �մϴ�.
--  �ش� ��¥�� ��ü ������ ���Ե� ��ǰ����Ʈ�� ��ǰ�� ���� ������ �����ÿ�.
SELECT ITEM, SUM(QTY)
FROM TEST09 A, TEST10 B
WHERE A.LINE = B.LINE
AND A.SPEC = B.SPEC
GROUP BY ITEM
ORDER BY 1;
--3. 1999�� 2�� 3�� ������ �����ϱ� ���� ���� ���� �ش� ���� ���θ��� �ʿ��� ��ǰ�� ��Ȯ�� �����ؾ� �մϴ�.
--3.1 ������θ��� �ʿ��� ��ǰ�� �ҿ� ���� �ľ�
SELECT A.LINE, A.ITEM, SUM(QTY)
FROM TEST09 A, TEST10 B
WHERE A.LINE = B.LINE
AND A.SPEC = B.SPEC
GROUP BY A.LINE, A.ITEM
ORDER BY 1;
--3.2 JUST IN TIME ������ ���� �Ϸ� 2�ð����� 5�� ������ �̷�����ٸ� ���� ������ ���� �� �ð����� ���κ��� ���ԵǾ�� �� ��ǰ�� ������ ���Ͻÿ�
SELECT CEIL(B.IN_SEQ/2), A.LINE, A.ITEM, SUM(A.QTY)
FROM TEST09 A, TEST10 B
WHERE A.LINE = B.LINE
AND A.SPEC = B.SPEC
GROUP BY CEIL(B.IN_SEQ/2), A.LINE, A.ITEM,A.LINE, A.ITEM
ORDER BY 1,2,3;
--����
--1. ���,����, �μ��ڵ带 ���ؿ��� �μ��� ����� ���� ������ ���� (JOIN ���� �������� ���)
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM TEMP A
ORDER BY (SELECT BOSS_ID
          FROM TDEPT 
          WHERE A.DEPT_CODE = DEPT_CODE);
--2. �Ҽӵ� �μ��� ��� ���޺��� ���� ������ �޴� ������ �̸�, �޿�, �μ��ڵ� 
SELECT EMP_NAME, SALARY, DEPT_CODE
FROM TEMP A
WHERE SALARY > (SELECT AVG(SALARY)
                FROM TEMP
                WHERE DEPT_CODE = A.DEPT_CODE);
--3. �μ��� 3������ ���� ��ġ�� �ִ� ������ ��ġ�� �μ��� �ٹ��ϴ� ����� ���,�̸�,�μ��ڵ�
select a.emp_id, a.emp_name, a.dept_code
from temp a, tdept b
where a.dept_code = b.dept_code
and 3 < (select count(dept_code) 
            from TDEPT d 
            where b.area = d.area 
            group by area);
--4. �̼����� SALARY�� ���� ������ ������ ������� �����ϴ� ���� �ۼ� �� COMMIT;
UPDATE TEMP A
SET SALARY = (SELECT (FROM_SAL+TO_SAL)/2 
              FROM EMP_LEVEL 
              WHERE LEV = A.LEV)
WHERE EMP_NAME = '�̼���';
--5 �ٹ����� ��õ�̸� 10%, �����̸� 7%, �������� 5% �λ��Ͽ� UPDATE
UPDATE TEMP A
SET SALARY = (SELECT DECODE(AREA,'��õ',A.SALARY*1.1,DECODE(AREA,'����',A.SALARY*1.07,A.SALARY*1.05))
                FROM TDEPT
                WHERE A.DEPT_CODE = DEPT_CODE
                );
ROLLBACK;
--6. �ڽ��� �����ϰ� �ڽŰ� ������ ���� ���� �������ٵ� �� ���� �޿��� �޴� ���� ����
SELECT * FROM TEMP1 A
WHERE SALARY > ALL(SELECT SALARY 
                   FROM TEMP B
                   WHERE B.LEV = A.LEV
                   AND A.EMP_ID <> B.EMP_ID);
--
