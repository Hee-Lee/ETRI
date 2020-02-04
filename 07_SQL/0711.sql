CREATE USER user01
IDENTIFIED BY pass01;

GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW
TO user01;

GRANT SELECT
ON DEPARTMENTS
TO user01, SCOTT;

GRANT UPDATE(LOCATION_ID)
ON DEPARTMENTS
TO user01;

--���ѿ� ���� ��� WITH GRANT OPTION;
GRANT UPDATE
ON HR.DEPARTMENTS
TO PUBLIC;

REVOKE SELECT, UPDATE
ON DEPARTMENTS
FROM USER01;
--ROLE
CREATE ROLE MAN_ROLE;
--ROLE�� ���Ѻο�
GRANT CREATE TABLE, CREATE VIEW
TO MAN_ROLE;
--ROLE�� ����ڿ��� �ο�
GRANT MAN_ROLE
TO user01, SCOTT;
--�ο��� ���� Ȯ��
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE = 'MAN_ROLE';
SELECT * FROM ROLE_TAB_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_TAB_PRIVS_MADE;
SELECT * FROM USER_TAB_PRIVS_RECD;
SELECT * FROM USER_COL_PRIVS_MADE;
SELECT * FROM USER_COL_PRIVS_RECD;
--
SELECT USERENV('SID') FROM DUAL;
--1. SESEION���� �̼����� ��̸� Ȱ���� ����
UPDATE TEMP
SET HOBBY = '��Ÿ��'
WHERE EMP_NAME = '�̼���';
--LOCK Ȯ��
-- LOCK ȹ�� Ȯ��
SELECT A.SESSION_ID, A.ORACLE_USERNAME,
       A.PROCESS, A.LOCKED_MODE,
       C.LOCK_TYPE, C.MODE_HELD,
       C.MODE_REQUESTED, C.BLOCKING_OTHERS
FROM   V$LOCKED_OBJECT A, DBA_LOCKS C
WHERE  A.SESSION_ID = USERENV('SID')
AND    C.SESSION_ID = A.SESSION_ID
AND    C.LOCK_ID1 = A.OBJECT_ID;

SELECT * FROM TEMP
WHERE EMP_NAME = '�̼���';

ROLLBACK;
--1 SESSION
SELECT *
FROM TEMP
WHERE EMP_NAME = '�̼���'
FOR UPDATE NOWAIT;

--����1. UPDATE DML�� TRANSACTION �����ϰ� TRANSATION�� ������ �� �ִ� ����� ��� ����ϰ�
-- �� ����� ���� Ʈ����� ���� ��Ȳ�� �����ϰ� Ȯ�� ���� �ۼ�
UPDATE TEMP
SET HOBBY = '��Ÿ��'
WHERE EMP_NAME = '�̼���';
ROLLBACK;
COMMIT;
CREATE TABLE TEMP2(
EMP_NNN VARCHAR(20) NOT NULL PRIMARY KEY
);
ALTER TABLE TEMP
MODIFY (EMP_NAME VARCHAR2(10));
DESC TEMP
SELECT * FROM TEMP2;
SELECT HOBBY FROM TEMP WHERE EMP_NAME ='�̼���';
--
UPDATE TEMP
SET HOBBY ='��Ÿ��'
WHERE EMP_NAME = '�̼���';

DESC TEMP;
--2. SAVEPOINT
--   2.1 STUDY01���� T1_DATA�� MAX(NO) Ȯ�� 
SELECT MAX(NO)
FROM T1_DATA;
--   2.2 Ȯ�ε� NO���� 1  ���� ���� �������� T1_DATA���� DELETE ����
DELETE
FROM T1_DATA
WHERE NO = (SELECT MAX(NO)-1
            FROM T1_DATA);
--   2.3 ���� ���� Ȯ�� �� SAVEPOINT T1_1 ����
SELECT *
FROM T1_DATA
WHERE NO = (SELECT MAX(NO)-1
            FROM T1_DATA);
SAVEPOINT T1_1;
--   2.4 2.1���� Ȯ���� NO ������ DELETE ����
DELETE
FROM T1_DATA
WHERE NO = (SELECT MAX(NO)
            FROM T1_DATA);
--   2.5 �������� Ȯ��
SELECT *
FROM T1_DATA
WHERE NO = (SELECT MAX(NO)
            FROM T1_DATA);
--   2.6 T1_1 SAVEPOINT�� ROLLABCK ����
ROLLBACK TO T1_1;
--   2.7 ROLLBACK TO T1_1;
--   2.8 T1_1 SAVEPOINT ���� ���� �����ʹ� ���� ���� ���°� ���� �����ʹ� ROLLABACK���� ����Ȯ��
SELECT *
FROM T1_DATA
WHERE NO = (SELECT MAX(NO)
            FROM T1_DATA);
--   2.9 ROLLBACK �������� ���� ����
ROLLBACK;
SELECT *
FROM T1_DATA
WHERE NO = (SELECT MAX(NO)
            FROM T1_DATA);
--3.STUDY01�� �α����� STUDY03 ���� ���� ? PASSWORD�� ��PASS01��
CREATE USER STUDY03
IDENTIFIED BY PASS01;
--4. STUDY03�� PASSWORD�� USER��� �����ϰ� ����
ALTER USER STUDY03 IDENTIFIED BY STUDY03;
--5. STUDY03���� ���ǻ���, ���̺����, ����� ������ �ο�
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW
TO STUDY03;
--5-1 STUDY03�� CONNECT �� ������ ���̺�� �� ���� Ȯ��
CONNECT STUDY03/STUDY03; 
CREATE TABLE T1 (A NUMBER);
CREATE VIEW V1 AS SELECT A FROM T1;
--6. STUDY03���� T1_DATA INSERT, UPDATE ���� �ο�
GRANT INSERT, UPDATE
ON T1_DATA
TO STUDY03;
--7. STUDY03���� T2_DATA SELECT, UPDATE ���� �ο� (WITH GRANT OPTION ����);
GRANT SELECT, UPDATE
ON T2_DATA
TO STUDY03
WITH GRANT OPTION;
--8. STUDY03���� STUDY02���� T1_DATA �� T2_DATA�� UPDATE ���� �ο� 
GRANT UPDATE
ON T1_DATA
TO STUDY02; --�̰� �ȉ�

GRANT UPDATE
ON T2_DATA
TO STUDY02;
--9. PUBLIC�� TEMP SELECT ���� �ο�
GRANT SELECT
ON TEMP
TO PUBLIC;

REVOKE SELECT ON TEMP FROM PUBLIC;
SELECT * FROM USER_TAB_PRIVS_MADE WHERE TABLE_NAME = 'TEMP';
SELECT * FROM USER_TAB_PRIVS_MADE WHERE TABLE_NAME = 'TDEPT';

-- ���ʽ�����
CREATE ROLE AMUNA;
GRANT SELECT ON TEMP TO AMUNA;
GRANT AMUNA TO STUDY03;

--����
--study01�� �λ�ý��� user�̸�, study03�� �繫 �ý��� user�Դϴ�.
--�繫 �ý��ۿ��� �λ� �ý��ۿ� ��������, �μ������� ���� ��ȸ ���Ѱ� ���������� ���� �Է±����� ��û�մϴ�.
--������ �� �� �ٸ� �ý��ۿ��� �߻��� �� �ִ� ����� ������ ��û�� �����ϱ� ����,
--�λ�ý��� �����ڴ� �λ��������� �̿��� �� �ִ� ������ ���̺� ����
--1. �ܼ� �б� ����, 2. �������, 3. �Է±���, 4. ������������ ������ �����ϰ��� �մϴ�.
--���� �ý��ۺ� ��û�� ���� ������ ������ 4���� ������ �������� �ο��ϰ��� �մϴ�.
--(���� ������ ���̺� ���������� �մϴ�.)
--��, �λ��������� �ο��� ������ ������ �ο� ���� �ý����� �ٸ� �ý��ۿ� ��ο��� �� ���� �� �����̸�,
--���ǵ� role������ ������ ���� ������ �������� grant�� ������� ���� �����Դϴ�.
--�̿� ���� ���� ����� ������ �� �繫 �ý��ۿ� �� �����ϰ��� �մϴ�.   
--���� �λ��������� ���� ������ �ο��� ���¸� ��ȸ�� �� �־�� �մϴ�.
--���� ���õ� ���� �ο� ��å�� ������ ���̺� �����ͷ� �����Ͽ� ���� �ο����¿� ���÷� ���ϰ��� �մϴ�.
--���õ� ������ ���̺��� ������ �����ϰ�, ���� ��å�� �Է��ϸ�,
--���õ� ���� ��å�� ���� ����ǰ� �ִ��� Ȯ���ϴ� ������ �ۼ��Ͻÿ�.

SELECT * FROM USER_TABLES;
SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_USERS;
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'ROLE_MAN';