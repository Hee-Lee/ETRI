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
--GROUPING 00이면 원데이터 01이면 소계 11이면 합계
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
--향상된 GROUP BY 정
SELECT DEPARTMENT_ID, JOB_ID, MANAGER_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY GROUPING SETS
(DEPARTMENT_ID,ROLLUP(JOB_ID,MANAGER_ID));

SELECT DEPARTMENT_ID, JOB_ID, MANAGER_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY GROUPING SETS
(DEPARTMENT_ID,JOB_ID,MANAGER_ID);
--복합 컬럼의 사용
SELECT DEPARTMENT_ID, JOB_ID, MANAGER_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP (DEPARTMENT_ID,(JOB_ID,MANAGER_ID));
--연쇄 GROUPING  1.D-J-M 2.D-J 3.D-M 4.D 식으로 나옴 
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
--DEPT_CODE로 PARTITION을 줌
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
--1. SALE_HIST의 자료를 이용하여 일자별 매출순위와 순위별 사업장, 품목을 보여주기
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

PERCENT_RANK = (자신이 속한 PARTITION내의 자신의 RANK -1) /
                (자신이 속한 PARTITION내의 ROW 숫자 -1);
CUME_DIST
        SALARY에 의해 결과를 정렬할 경우
        해당 ROW의 SALARY의 동일한 값과 이전 값의 수 / 52(ROW수)으로 구해진 값들이 나온다.;
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
--일자별 사업장별 매출액 합과 매출3일 이동평균
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
--각 ROW의 판매액, 동일일자/동일품목의 최대판매액
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
--TOT에서 SALAMT가 차지하는 비율
SELECT SALE_DATE, SUM(SALE_AMT) SAMT,
        SUM(SUM(SALE_AMT)) OVER() AS TOT1,
        RATIO_TO_REPORT(SUM(SALE_AMT)) OVER() AS RAT1
FROM SALE_HIST
GROUP BY SALE_DATE;
--LAG가 이전값 LEAD가 이후값
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
--문제
--1.SALE_HIST의 자료를 이용하여 '01' 사업장 'PENCIL' 품목의 일자별 누적 판매금액을 구하라.
SELECT SALE_DATE, SALE_SITE, SALE_ITEM,
         SUM(SALE_AMT) OVER(ORDER BY SALE_DATE ROWS 5 PRECEDING) SUM_AMT
FROM SALE_HIST
WHERE SALE_SITE = '01'
AND SALE_ITEM = 'PENCIL';
--2.품목별/일자별로 과거판매액을 모두 이용하는 이동평균값을 구하라
SELECT SALE_DATE, SALE_ITEM, SUM(SALE_AMT),
        AVG(SUM(SALE_AMT)) OVER (
        PARTITION BY SALE_ITEM
        ORDER BY TO_DATE(SALE_DATE, 'YYYYMMDD')
        RANGE INTERVAL '4' DAY PRECEDING) AS S_SUM
FROM SALE_HIST
GROUP BY SALE_DATE, SALE_ITEM;
--3.SALE_HIST의 자료를 이용하여 '01' 사업장 'PENCIL' 품목에 대해
--  일자별 매출액과 전일 매출, 당일과 전일의 매출액 차이를 구하시오.
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

--1. 직원정보에서 부서별,채용 구분 별로 SALARY의 합계, 대상건수, 평균을 구해오는 쿼리
SELECT * FROM TEMP;
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY DEPT_CODE, EMP_TYPE
ORDER BY 1;
--2. 직원정보에서 부서별,채용 구분 별로 SALARY의 합계, 대상건수, 평균을 구해오되 부서별 중간 소계와
--   전체 합계를 함께 보여주는 쿼리
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE, EMP_TYPE)
ORDER BY 1;
--3. 직원정보에서 부서별,채용 구분 별로 SALARY의 합계, 대상건수, 평균을 구해오되 
--   부서별 중간 소계, 채용 구분별 소계, 합계를 함께 보여주는 쿼리
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE), ROLLUP(EMP_TYPE)
ORDER BY 1;
--4. 3번쿼리에서 2번 쿼리를 집합연산자 MINUS를 이용하여 차이 나는 DATA 알아보기  
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE), ROLLUP(EMP_TYPE)
MINUS
SELECT DEPT_CODE, EMP_TYPE, SUM(SALARY), COUNT(EMP_ID), AVG(SALARY)
FROM TEMP
GROUP BY ROLLUP(DEPT_CODE, EMP_TYPE);
--5. 2번과 3번 쿼리에서 부서코드와 채용구분에 각각 GROUPING 함수를 적용할 경우 어떤 값들을 리턴 되는지 확인
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
--6. TEMP 의 자료를 SALARY로 분류 하여 30000000 이하는 'D',
--                                      30000000 초과 50000000 이하는 'C'
--                                      50000000 초과 70000000 이하는 'B' 
--                                      70000000 초과는 'A'
--    라고 등급을 분류하여 등급별 인원수 확인
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
            
--7. 직원정보에서 부서코드, 채용구분, 직급과 SALARY 평균을 가져오되 
--   1).부서,채용구분 2).채용구분,직급 3).부서,직급 의 세 가지 조합으로 
--      GROUP BY 결과가 나올 수 있도록 GROUPING SETS 적용
SELECT DEPT_CODE, EMP_TYPE, LEV, AVG(SALARY)
FROM TEMP
GROUP BY GROUPING SETS ((DEPT_CODE,EMP_TYPE),(EMP_TYPE,LEV),(DEPT_CODE,LEV));
--8. 직원정보에서 부서코드가 A로 시작하는 부서 소속 직원의 부서코드, 채용구분, 직급과 SALARY 평균을 가져오되 
--   1).부서,채용구분 2).채용구분,직급 의 두 가지 조합으로 
--      GROUP BY 결과가 나올 수 있도록 GROUPING SETS 적용
SELECT DEPT_CODE, EMP_TYPE, LEV, AVG(SALARY)
FROM TEMP
WHERE DEPT_CODE LIKE 'A%'
GROUP BY GROUPING SETS ((DEPT_CODE,EMP_TYPE),(EMP_TYPE,LEV)); 
--9. 8번과 같은 결과가 나오는 집합연산자를 이용한 GROUP BY 쿼리 작성
SELECT DEPT_CODE, EMP_TYPE, TO_CHAR(NULL), AVG(SALARY)
FROM TEMP
WHERE DEPT_CODE LIKE 'A%'
GROUP BY DEPT_CODE,EMP_TYPE
UNION ALL
SELECT TO_CHAR(NULL), EMP_TYPE, LEV, AVG(SALARY)
FROM TEMP
WHERE DEPT_CODE LIKE 'A%'
GROUP BY LEV,EMP_TYPE;
--1.TEMP 의 자료를 이용해 한 행에 5명의 사번과 성명을 보여주는 QUERY 를 작성
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
--2.TEMP에서 사번별 정렬을 수행한 사번, 급여, 누적급여를 구하되
--  조인을 이용한 방법과 WINDOWING 함수를 이용한 방법으로 각각 해결
--조인 방법
SELECT B.EMP_ID, B.SALARY, SUM(A.SALARY)
FROM TEMP A, TEMP B
WHERE A.EMP_ID <= B.EMP_ID
GROUP BY B.EMP_ID, B.SALARY
ORDER BY 1;
--WINDOWING함수 방법
SELECT EMP_ID, SALARY, 
        SUM(SALARY) OVER(ORDER BY EMP_ID ROWS 51 PRECEDING) SUM_SAL
FROM TEMP;