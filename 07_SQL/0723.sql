SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID < 90
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY 1;

SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID < 90
GROUP BY ROLLUP (DEPARTMENT_ID, JOB_ID);

SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID < 90
GROUP BY CUBE (DEPARTMENT_ID, JOB_ID);
--GROUPING 00�̸� �������� 01�̸� �Ұ� 11�̸� �հ�
SELECT DEPARTMENT_ID, JOB_ID JOB, SUM(SALARY),
        GROUPING(DEPARTMENT_ID) GRP_DEPT,
        GROUPING(JOB_ID) GRP_JOB
FROM EMPLOYEES
WHERE DEPARTMENT_ID < 50
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID);
--GROUPING SET = UNION ALL
SELECT DEPARTMENT_ID, JOB_ID, MANAGER_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY GROUPING SETS
((DEPARTMENT_ID,JOB_ID),(JOB_ID,MANAGER_ID));
--���� GROUP BY ��
SELECT DEPARTMENT_ID, JOB_ID, MANAGER_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY GROUPING SETS
(DEPARTMENT_ID,ROLLUP(JOB_ID,MANAGER_ID));

SELECT DEPARTMENT_ID, JOB_ID, MANAGER_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY GROUPING SETS
(DEPARTMENT_ID,JOB_ID,MANAGER_ID);
--���� �÷��� ���
SELECT DEPARTMENT_ID, JOB_ID, MANAGER_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP (DEPARTMENT_ID,(JOB_ID,MANAGER_ID));
--���� GROUPING  1.D-J-M 2.D-J 3.D-M 4.D ������ ���� 
SELECT DEPARTMENT_ID, JOB_ID, MANAGER_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID,ROLLUP(JOB_ID),CUBE(MANAGER_ID);

--RANK() OVER(ORDER BY )
SELECT * FROM SALE_HIST;
SELECT EMP_ID, EMP_NAME, SALARY,
        RANK() OVER(ORDER BY SALARY) C1,
        RANK() OVER(ORDER BY SALARY DESC) C2,
        DENSE_RANK() OVER(ORDER BY SALARY DESC) C3
FROM TEMP;
--DEPT_CODE�� PARTITION�� ��
SELECT DEPT_CODE, EMP_ID, EMP_NAME, SALARY,
        RANK() OVER(
            PARTITION BY DEPT_CODE
            ORDER BY SALARY DESC
            ) C3
FROM TEMP;

SELECT DEPT_CODE, EMP_ID, SUM(SALARY),
        RANK() OVER(
            PARTITION BY GROUPING(DEPT_CODE),
                        GROUPING(EMP_ID)
            ORDER BY SUM(SALARY) DESC) C1
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE, EMP_ID);
--1. SALE_HIST�� �ڷḦ �̿��Ͽ� ���ں� ��������� ������ �����, ǰ���� �����ֱ�
SELECT * FROM SALE_HIST;
SELECT SALE_DATE, SALE_ITEM, SALE_SITE, SALE_AMT,
        RANK() OVER(
            PARTITION BY SALE_DATE
            ORDER BY SALE_AMT DESC)
FROM SALE_HIST;
--
SELECT EMP_ID, EMP_NAME, SALARY,
        RANK() OVER(ORDER BY SALARY) C1,
        CUME_DIST() OVER(ORDER BY SALARY) C2,
        PERCENT_RANK() OVER(ORDER BY SALARY) C3
FROM TEMP;

PERCENT_RANK = (�ڽ��� ���� PARTITION���� �ڽ��� RANK -1) /
                (�ڽ��� ���� PARTITION���� ROW ���� -1);
CUME_DIST
        SALARY�� ���� ����� ������ ���
        �ش� ROW�� SALARY�� ������ ���� ���� ���� �� / 52(ROW��)���� ������ ������ ���´�.;
--
SELECT EMP_ID, EMP_NAME, SALARY,
        NTILE(4) OVER (PARTITION BY SUBSTR(EMP_ID,1,4)
                        ORDER BY SALARY DESC) C4
FROM TEMP;
--
SELECT SALE_DATE, SALE_SITE, SALE_ITEM, SALE_AMT,
        SUM(SALE_AMT) OVER
                    (PARTITION BY SALE_ITEM
                    ORDER BY SALE_ITEM
                    ROWS UNBOUNDED PRECEDING) AS C1
FROM SALE_HIST
WHERE SALE_SITE = '01';
--���ں� ����庰 ����� �հ� ����3�� �̵����
SELECT SALE_DATE, SALE_SITE, SUM(SALE_AMT),
       AVG(SUM(SALE_AMT)) OVER (
        PARTITION BY SALE_SITE
        ORDER BY TO_DATE(SALE_DATE, 'YYYYMMDD')
        RANGE INTERVAL '2' DAY PRECEDING) AS S_SUM
FROM SALE_HIST
GROUP BY SALE_DATE, SALE_SITE;

SELECT * FROM SALE_HIST;

SELECT EMP_ID, SALARY,
        SUM(SALARY) OVER(ORDER BY EMP_ID ROWS 3 PRECEDING) SUM_SAL,
        COUNT(SALARY) OVER(ORDER BY EMP_ID ROWS 3 PRECEDING) CNT,
        AVG(SALARY) OVER(ORDER BY EMP_ID ROWS 3 PRECEDING) AVG
FROM TEMP;
--�� ROW�� �Ǹž�, ��������/����ǰ���� �ִ��Ǹž�
SELECT SALE_DATE, SALE_ITEM, SALE_SITE, SALE_AMT,
        FIRST_VALUE(SALE_AMT) OVER(
            PARTITION BY SALE_DATE, SALE_ITEM
            ORDER BY SALE_AMT DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
                AND      UNBOUNDED FOLLOWING
        ) FIRST_AMT
FROM SALE_HIST;
--
select sale_date, sale_item, sale_site, sale_amt,
        first_value(sale_amt) over(
        partition by sale_date, sale_item
        order by sale_amt desc
        rows between unbounded preceding
            and             unbounded following
        ) max_amt,
                first_value(sale_site) over(
        partition by sale_date, sale_item
        order by sale_amt desc
        rows between unbounded preceding
            and             unbounded following
        ) max_site,
                first_value(sale_amt) over(
        partition by sale_date, sale_item
        order by sale_amt
        rows between unbounded preceding
            and             unbounded following
        ) min_amt,
                first_value(sale_site) over(
        partition by sale_date, sale_item
        order by sale_amt
        rows between unbounded preceding
            and             unbounded following
        ) min_site
from sale_hist;
--TOT���� SALAMT�� �����ϴ� ����
SELECT SALE_DATE, SUM(SALE_AMT) SAMT,
        SUM(SUM(SALE_AMT)) OVER() AS TOT1,
        RATIO_TO_REPORT(SUM(SALE_AMT)) OVER() AS RAT1
FROM SALE_HIST
GROUP BY SALE_DATE;
--LAG�� ������ LEAD�� ���İ�
SELECT SALE_DATE, SALE_SITE, SALE_ITEM, SALE_AMT,
        LAG(SALE_AMT,1) OVER(
            PARTITION BY SALE_SITE, SALE_ITEM
            ORDER BY SALE_DATE, SALE_SITE, SALE_ITEM
            ) LAG_AMT,
            LEAD(SALE_AMT,1) OVER(
                PARTITION BY SALE_SITE, SALE_ITEM
                ORDER BY SALE_DATE, SALE_SITE, SALE_ITEM
            ) LAG_AMT
FROM SALE_HIST;
--����
--1.SALE_HIST�� �ڷḦ �̿��Ͽ� '01' ����� 'PENCIL' ǰ���� ���ں� ���� �Ǹűݾ��� ���϶�.
SELECT SALE_DATE, SALE_SITE, SALE_ITEM,
         SUM(SALE_AMT) OVER(ORDER BY SALE_DATE ROWS 5 PRECEDING) SUM_AMT
FROM SALE_HIST
WHERE SALE_SITE = '01'
AND SALE_ITEM = 'PENCIL';
--2.ǰ��/���ں��� �����Ǹž��� ��� �̿��ϴ� �̵���հ��� ���϶�
SELECT SALE_DATE, SALE_ITEM, SUM(SALE_AMT),
        AVG(SUM(SALE_AMT)) OVER (
        PARTITION BY SALE_ITEM
        ORDER BY TO_DATE(SALE_DATE, 'YYYYMMDD')
        RANGE INTERVAL '4' DAY PRECEDING) AS S_SUM
FROM SALE_HIST
GROUP BY SALE_DATE, SALE_ITEM;
--3.SALE_HIST�� �ڷḦ �̿��Ͽ� '01' ����� 'PENCIL' ǰ�� ����
--  ���ں� ����װ� ���� ����, ���ϰ� ������ ����� ���̸� ���Ͻÿ�.
SELECT SALE_DATE, SALE_SITE, SALE_ITEM,
      LAG(SALE_AMT,1) OVER(
            PARTITION BY SALE_SITE, SALE_ITEM
            ORDER BY SALE_DATE, SALE_SITE, SALE_ITEM
            ) LAG_AMT,
        SALE_AMT,
        (SALE_AMT-NVL(LAG(SALE_AMT,1) OVER(
            PARTITION BY SALE_SITE, SALE_ITEM
            ORDER BY SALE_DATE, SALE_SITE, SALE_ITEM
            ),0)) AMT
FROM SALE_HIST
WHERE SALE_SITE = '01'
AND SALE_ITEM = 'PENCIL';

--1. ������������ �μ���,ä�� ���� ���� SALARY�� �հ�, ���Ǽ�, ����� ���ؿ��� ����
SELECT * FROM TEMP;
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY DEPT_CODE, EMP_TYPE
ORDER BY 1;
--2. ������������ �μ���,ä�� ���� ���� SALARY�� �հ�, ���Ǽ�, ����� ���ؿ��� �μ��� �߰� �Ұ��
--   ��ü �հ踦 �Բ� �����ִ� ����
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE, EMP_TYPE)
ORDER BY 1;
--3. ������������ �μ���,ä�� ���� ���� SALARY�� �հ�, ���Ǽ�, ����� ���ؿ��� 
--   �μ��� �߰� �Ұ�, ä�� ���к� �Ұ�, �հ踦 �Բ� �����ִ� ����
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE), ROLLUP(EMP_TYPE)
ORDER BY 1;
--4. 3���������� 2�� ������ ���տ����� MINUS�� �̿��Ͽ� ���� ���� DATA �˾ƺ���  
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE), ROLLUP(EMP_TYPE)
MINUS
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE, EMP_TYPE);
--5. 2���� 3�� �������� �μ��ڵ�� ä�뱸�п� ���� GROUPING �Լ��� ������ ��� � ������ ���� �Ǵ��� Ȯ��
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY),
        GROUPING(DEPT_CODE)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE, EMP_TYPE)
ORDER BY 1;

SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY),
        GROUPING(EMP_TYPE)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE, EMP_TYPE)
ORDER BY 1;
--6. TEMP �� �ڷḦ SALARY�� �з� �Ͽ� 30000000 ���ϴ� 'D',
--                                      30000000 �ʰ� 50000000 ���ϴ� 'C'
--                                      50000000 �ʰ� 70000000 ���ϴ� 'B' 
--                                      70000000 �ʰ��� 'A'
--    ��� ����� �з��Ͽ� ��޺� �ο��� Ȯ��
SELECT CASE WHEN SALARY <= 30000000 THEN 'D'
            WHEN SALARY BETWEEN 30000001 AND 50000000 THEN 'C'
            WHEN SALARY BETWEEN 50000001 AND 70000000 THEN 'B'
            WHEN SALARY > 70000000 THEN 'A' END AS GRADE,
    COUNT(*)
FROM TEMP
GROUP BY CASE WHEN SALARY <= 30000000 THEN 'D'
            WHEN SALARY BETWEEN 30000001 AND 50000000 THEN 'C'
            WHEN SALARY BETWEEN 50000001 AND 70000000 THEN 'B'
            WHEN SALARY > 70000000 THEN 'A' END;
            
--7. ������������ �μ��ڵ�, ä�뱸��, ���ް� SALARY ����� �������� 
--   1).�μ�,ä�뱸�� 2).ä�뱸��,���� 3).�μ�,���� �� �� ���� �������� 
--      GROUP BY ����� ���� �� �ֵ��� GROUPING SETS ����
SELECT DEPT_CODE, EMP_TYPE, LEV, AVG(SALARY)
FROM TEMP
GROUP BY GROUPING SETS ((DEPT_CODE,EMP_TYPE),(EMP_TYPE,LEV),(DEPT_CODE,LEV));
--8. ������������ �μ��ڵ尡 A�� �����ϴ� �μ� �Ҽ� ������ �μ��ڵ�, ä�뱸��, ���ް� SALARY ����� �������� 
--   1).�μ�,ä�뱸�� 2).ä�뱸��,���� �� �� ���� �������� 
--      GROUP BY ����� ���� �� �ֵ��� GROUPING SETS ����
SELECT DEPT_CODE, EMP_TYPE, LEV, AVG(SALARY)
FROM TEMP
WHERE DEPT_CODE LIKE 'A%'
GROUP BY GROUPING SETS ((DEPT_CODE,EMP_TYPE),(EMP_TYPE,LEV)); 
--9. 8���� ���� ����� ������ ���տ����ڸ� �̿��� GROUP BY ���� �ۼ�
SELECT DEPT_CODE, EMP_TYPE, TO_CHAR(NULL), AVG(SALARY)
FROM TEMP
WHERE DEPT_CODE LIKE 'A%'
GROUP BY DEPT_CODE,EMP_TYPE
UNION ALL
SELECT TO_CHAR(NULL), EMP_TYPE, LEV, AVG(SALARY)
FROM TEMP
WHERE DEPT_CODE LIKE 'A%'
GROUP BY LEV,EMP_TYPE;
--1.TEMP �� �ڷḦ �̿��� �� �࿡ 5���� ����� ������ �����ִ� QUERY �� �ۼ�
SELECT 
        MIN(DECODE(MOD(C1,5),1,EMP_ID)),
        MIN(DECODE(MOD(C1,5),1,EMP_NAME)),
        MIN(DECODE(MOD(C1,5),2,EMP_ID)),
        MIN(DECODE(MOD(C1,5),2,EMP_NAME)),
        MIN(DECODE(MOD(C1,5),3,EMP_ID)),
        MIN(DECODE(MOD(C1,5),3,EMP_NAME)),
        MIN(DECODE(MOD(C1,5),4,EMP_ID)),
        MIN(DECODE(MOD(C1,5),4,EMP_NAME)),
        MIN(DECODE(MOD(C1,5),0,EMP_ID)),
        MIN(DECODE(MOD(C1,5),0,EMP_NAME))
FROM (SELECT EMP_ID, EMP_NAME, CEIL(ROWNUM/5) R1, MOD(ROWNUM,5) C1
        FROM TEMP)
GROUP BY R1
ORDER BY R1;
--2.TEMP���� ����� ������ ������ ���, �޿�, �����޿��� ���ϵ�
--  ������ �̿��� ����� WINDOWING �Լ��� �̿��� ������� ���� �ذ�
--���� ���
SELECT B.EMP_ID, B.SALARY, SUM(A.SALARY)
FROM TEMP A, TEMP B
WHERE A.EMP_ID <= B.EMP_ID
GROUP BY B.EMP_ID, B.SALARY
ORDER BY 1;
--WINDOWING�Լ� ���
SELECT EMP_ID, SALARY, 
        SUM(SALARY) OVER(ORDER BY EMP_ID ROWS 51 PRECEDING) SUM_SAL
FROM TEMP;