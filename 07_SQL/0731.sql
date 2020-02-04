CREATE TABLE TEST06 ( YMD VARCHAR2(08) NOT NULL, LEASE NUMBER,
  CONSTRAINT TEST06_PK PRIMARY KEY (YMD)
);
INSERT INTO TEST06 VALUES ('20010115', 21000000);
INSERT INTO TEST06 VALUES ('20010127', 24000000);
INSERT INTO TEST06 VALUES ('20010316', 24000000);
INSERT INTO TEST06 VALUES ('20010320', 21000000);
INSERT INTO TEST06 VALUES ('20010720', 23000000);
INSERT INTO TEST06 VALUES ('20010731', 22000000);
INSERT INTO TEST06 VALUES ('20010822', 23000000);
INSERT INTO TEST06 VALUES ('20010831', 22000000);
INSERT INTO TEST06 VALUES ('20010906', 22000000);
INSERT INTO TEST06 VALUES ('20010915', 22000000);
--2001�� 1�� 15�Ͽ� 2,100,000���� ������ ���� ���� ���÷� ������ �־���.
--2001�� ���� 1������ ��ñ��� �־��� ���Աݿ� ���� ���ڸ� ����ϴµ�,
--�ſ� ������ �������� ����ؼ� �ſ� �� ���� �Ǿ���� �� ���ڸ� �˾Ƴ���.
--�� ���ڿ� ���� ���ڴ� ������� �ʴ´�.
--2001�� 01�� 31�Ͽ��� 20010115�� ������ 2,100,000���� ���� 31-15�� ��ŭ�� ���ڿ�
--2001�� 01�� 27�Ͽ��� ������ 2,400,000���� ���� 31-27��ŭ�� ���ڸ� ���ؼ� �߻������ְ�,
--2001�� 02�� 28�Ͽ��� 2001�� 1���� ������ 2,100,000 + 2,400,000���� ���� 28������ ���ڸ� �߻������ָ�,
--2001�� 03�� 31�Ͽ��� 1���� ������ 4,500,000���� ���� 31��ġ�� ���ڿ�
--3�� 16�Ͽ� ������ 2,400,000�� ���� 31-16�� ��ŭ�� ���ڿ�
--3�� 20�Ͽ� ������ 2,400,000���� ���� 31-20��ŭ�� ���ڸ� ���ؼ� �߻������ִ� ������� ����� �س�����.
--�ᱹ 1���� ������ �ݾ׿� ���� ���ڴ� 1������ 12������ 12�� �߻��ϸ�, 2���� 11�� ..
--�̷� ������ 12���� ������ �ݾ��� 12���� �ѹ��� �߻��Ǹ� �ȴ�.
--������ �� 12.5%�̴�.
SELECT LAST_DAY(A.YMD) YMD, B.NO,
        SUM(A.LEASE) ����, 
        ROUND(SUM(DECODE(B.NO,SUBSTR(A.YMD,5,2),B.LL1,B.LL2))) ������,
        SUM(ROUND(SUM(DECODE(B.NO,SUBSTR(A.YMD,5,2),B.LL1,B.LL2))))
                            OVER (PARTITION BY LAST_DAY(A.YMD)
                             ORDER BY B.NO) ������,
        SUM(A.LEASE) +  SUM(ROUND(SUM(DECODE(B.NO,SUBSTR(A.YMD,5,2),B.LL1,B.LL2)))) 
                            OVER (PARTITION BY LAST_DAY(A.YMD)
                             ORDER BY B.NO) ������������
FROM TEST06 A,
    (SELECT C.NO, LAST_DAY(A.YMD), YMD, 
            ROUND((A.LEASE * (LAST_DAY('2019'||C.NO||'01')-TO_DATE('2019'||C.NO||'01'))) * (0.125/365)) LL2,
            ((LEASE * (LAST_DAY(YMD)-TO_DATE(YMD))) * (0.125/365)) LL1
    FROM TEST06 A, 
        (SELECT LPAD(NO,2,0) NO FROM T1_DATA WHERE NO<13) C) B
WHERE B.NO >= SUBSTR(A.YMD,5,2)
AND A.YMD = B.YMD
GROUP BY LAST_DAY(A.YMD), B.NO
ORDER BY 1,2;