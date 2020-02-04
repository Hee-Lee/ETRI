SELECT * FROM USER_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'R';

ALTER TABLE TPRIVS
RENAME CONSTRAINT FK_FROM_OBJ TO R_OBJ_PRIV_1;

ALTER TABLE TPRIVS
RENAME CONSTRAINT FK_FROM_PRIVS TO R_CRUD_PRIV_1;

ALTER TABLE TROL_USER
RENAME CONSTRAINT FK_FROM_ROLES TO R_ROLE_USER_1;

ALTER TABLE TROL_USER
RENAME CONSTRAINT FK_FROM_USERS TO R_USER_ROLE_1;

ALTER TABLE TROL_PRIV
RENAME CONSTRAINT FK_FROM_OBJ_PRIVS TO R_PRIV_ROLE_1;

ALTER TABLE TROL_PRIV
RENAME CONSTRAINT FK_FROM_ROLE TO R_ROLE_PRIV_1;
--DATA����
INSERT INTO TCRUD
VALUES ('I');
INSERT INTO TCRUD
VALUES ('S');
INSERT INTO TCRUD
VALUES ('D');
INSERT INTO TCRUD
VALUES ('U');
--
SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'TABLE' 
OR OBJECT_TYPE = 'VIEW'
OR OBJECT_TYPE = 'PROCEDURE'; 
--
INSERT INTO TOBJECT(OBJ_NM)
SELECT OBJECT_NAME FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'TABLE'
OR OBJECT_TYPE = 'VIEW'
OR OBJECT_TYPE = 'PROCEDURE';

TRUNCATE TABLE TOBJECT;
--STUDY01�� ���̺� ���� ��������
INSERT INTO TOBJECT(OBJ_NM)
SELECT OBJECT_NAME
FROM ALL_OBJECTS
WHERE OWNER = 'STUDY01'
AND(OBJECT_TYPE = 'TABLE' 
OR OBJECT_TYPE = 'VIEW'
OR OBJECT_TYPE = 'PROCEDURE'); 

----
INSERT INTO TUSER(USER_NM)
SELECT USERNAME FROM ALL_USERS
WHERE USER_ID BETWEEN 91 AND 97;

INSERT INTO TUSER(USER_NM)
SELECT USERNAME FROM ALL_USERS
WHERE USERNAME = 'CONG';
---

INSERT INTO TPRIVS(PRIV_ID, OBJ_NM, CRUD_CD)
SELECT ROWNUM, OBJ_NM, CRUD_CD
FROM TCRUD, TOBJECT;

SELECT * FROM TCRUD;
SELECT * FROM TOBJECT;

SELECT * FROM USER_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'P';
--TROLE
INSERT INTO TROLE VALUES('DEPT_SUI', '�μ���������(����, ����)');
INSERT INTO TROLE VALUES('DEPT_SUID', '�μ���������(����)');
INSERT INTO TROLE VALUES('DEPT_S', '�μ�������ȸ');
INSERT INTO TROLE VALUES('EMP_SUI', '������������(����, ����)');
INSERT INTO TROLE VALUES('EMP_I', '���������Է�');
INSERT INTO TROLE VALUES('EMP_SUID', '������������(����)');
INSERT INTO TROLE VALUES('EMP_S', '����������ȸ');
INSERT INTO TROLE VALUES('DE_SUI', '�����μ���κ���');
INSERT INTO TROLE VALUES('DE_SUID', '�����μ���λ���');
INSERT INTO TROLE VALUES('DE_S', '�����μ������ȸ');
INSERT INTO TROLE VALUES('ALL_S', 'STUDY01 ������ ��� ���̺��� ���� ��ȸ');
INSERT INTO TROLE VALUES('ALL_SUI', 'STUDY01 ������ ��� ���̺��� ���� ����');
INSERT INTO TROLE VALUES('ALL_SUID', 'STUDY01 ������ ��� ���̺��� ���� ��� ����');

--TROL_PRIV
INSERT INTO TROL_PRIV(PRIV_ID, ROLE_CD)
SELECT A.PRIV_ID, B.ROLE_CD
FROM TPRIVS A, TROLE B
WHERE CRUD_CD IN ('S','U','I')
AND OBJ_NM = 'TDEPT'
AND ROLE_CD = 'DEPT_SUI';

INSERT INTO TROL_PRIV(PRIV_ID, ROLE_CD)
SELECT A.PRIV_ID, B.ROLE_CD
FROM TPRIVS A, TROLE B
WHERE CRUD_CD IN ('I')
AND OBJ_NM = 'TEMP'
AND ROLE_CD = 'EMP_I';

INSERT INTO TROL_PRIV(PRIV_ID, ROLE_CD)
SELECT A.PRIV_ID, B.ROLE_CD
FROM TPRIVS A, TROLE B
WHERE CRUD_CD IN ('S')
AND OBJ_NM = 'DE'
AND ROLE_CD = 'DE';

INSERT INTO TROL_PRIV(PRIV_ID, ROLE_CD)
SELECT A.PRIV_ID, B.ROLE_CD
FROM TPRIVS A, TROLE B
WHERE CRUD_CD IN ('S','U','I','D')
AND OBJ_NM IN ('TEMP', 'TDEPT')
AND ROLE_CD = 'DE_SUID';

INSERT INTO TROL_PRIV(PRIV_ID, ROLE_CD)
SELECT A.PRIV_ID, B.ROLE_CD
FROM TPRIVS A, TROLE B
WHERE CRUD_CD IN ('S','U','I','D')
AND ROLE_CD = 'ALL_SUID';

--TROL_USER
INSERT INTO TROL_USER(USER_NM, ROLE_CD)
SELECT USER_NM, ROLE_CD
FROM TROLE, TUSER;
--SCOTT
INSERT INTO TROL_USER(USER_NM, ROLE_CD)
SELECT USER_NM, ROLE_CD
FROM TUSER A, TROLE B
WHERE A.USER_NM = 'SCOTT'
AND B.ROLE_CD IN ('DE_S','EMP_SUI');
--ST01
INSERT INTO TROL_USER(USER_NM, ROLE_CD)
SELECT USER_NM, ROLE_CD
FROM TUSER A, TROLE B
WHERE A.USER_NM = 'ST01'
AND B.ROLE_CD IN ('ALL_S','EMP_SUID');
--CONG
INSERT INTO TROL_USER(USER_NM, ROLE_CD)
SELECT USER_NM, ROLE_CD
FROM TUSER A, TROLE B
WHERE A.USER_NM = 'CONG'
AND B.ROLE_CD IN ('DE_SUID');
--DM01
INSERT INTO TROL_USER(USER_NM, ROLE_CD)
SELECT USER_NM, ROLE_CD
FROM TUSER A, TROLE B
WHERE A.USER_NM = 'DM01'
AND B.ROLE_CD IN ('ALL_S');
--CONG
--STUDY02
INSERT INTO TROL_USER(USER_NM, ROLE_CD)
SELECT USER_NM, ROLE_CD
FROM TUSER A, TROLE B
WHERE A.USER_NM = 'STUDY02'
AND B.ROLE_CD IN ('DEPT_SUID','DE_S');
--STUDY03
INSERT INTO TROL_USER(USER_NM, ROLE_CD)
SELECT USER_NM, ROLE_CD
FROM TUSER A, TROLE B
WHERE A.USER_NM = 'STUDY03'
AND B.ROLE_CD IN ('DE_S','EMP_I');

--����
--ROLE
CREATE ROLE MAN_ROLE;
--ROLE�� ���Ѻο�
GRANT CREATE TABLE, CREATE VIEW
TO MAN_ROLE;
--ROLE�� ����ڿ��� �ο�
GRANT MAN_ROLE
TO user01, SCOTT;
--1.  ROLE CREATE ���� ���� ����
SELECT 'CREATE ROLE '||ROLE_CD||';'
FROM TROLE;
--2.  ROLE �� ���� �ο��ϴ� ���� ���� ����
SELECT 'GRANT '||DECODE(A.CRUD_CD,'S','SELECT', 'I', 'INSERT', 'U', 'UPDATE', 'D', 'DELETE')||
        ' ON STUDY01.'||A.OBJ_NM||
        ' TO '||B.ROLE_CD||';'
FROM TPRIVS A, TROL_PRIV B
WHERE A.PRIV_ID = B.PRIV_ID;
--3.  ������ ROLE �ο��ϴ� ����
SELECT 'GRANT '||ROLE_CD||
        ' TO '||USER_NM||';'
FROM TROL_USER;
SELECT * FROM TROL_USER;
--4.  STUDY03�� � ���̺��� ���� � ������ �������� Ȯ���ϴ� ����
--�𵨿��� ����
SELECT C.USER_NM, C.ROLE_CD, A.CRUD_CD
FROM TPRIVS A, TROL_PRIV B, TROL_USER C
WHERE USER_NM = 'STUDY03'
AND C.ROLE_CD = B.ROLE_CD
AND A.PRIV_ID = B.PRIV_ID;
--DICTIONARY���� ����
--ROLE-TAB-PRIVS
SELECT A.GRANTEE, A.GRANTED_ROLE, B.TABLE_NAME, B.PRIVILEGE
FROM DBA_ROLE_PRIVS A, ROLE_TAB_PRIVS B
WHERE A.GRANTED_ROLE = B.ROLE
AND A.GRANTEE = 'STUDY03';

SELECT * FROM DBA_ROLE_PRIVS;
SELECT * FROM ROLE_TAB_PRIVS;
--���ʽ�
--STUDY01�� ���� ��� ���̺��� ���� ������ �����κ��� ȸ���Ϸ����մϴ�.
--0.� ���̺��̵��� ���������� ���� �Ѱ� �� ���� �ο����� ���� Ȯ���� �� �ִ� ����
SELECT D.ROLE_CD, C.USER_NM
FROM TROL_USER C, TROLE D
WHERE C.ROLE_CD(+) = D.ROLE_CD
AND D.ROLE_CD LIKE '%D';
--1.���� ���������� ���� ������ ��� ����������� ��ü
UPDATE TROL_USER
SET ROLE_CD = REPLACE(ROLE_CD, 'SUID', 'SUI')
WHERE ROLE_CD IN (SELECT D.ROLE_CD
                    FROM TROL_USER C, TROLE D
                    WHERE C.ROLE_CD = D.ROLE_CD
                    AND D.ROLE_CD LIKE '%D');

SELECT * FROM TROL_USER;
--2.���������� ���� ROLE�� ���� �����͸� ��� REVOKE
SELECT A.GRANTEE, A.GRANTED_ROLE, B.TABLE_NAME, B.PRIVILEGE
FROM DBA_ROLE_PRIVS A, ROLE_TAB_PRIVS B
WHERE A.GRANTED_ROLE = B.ROLE
AND GRANTED_ROLE LIKE '%D';
--3.�������ѿ� �ش��ϴ� ��� �����͸� DELETE�ϰ�
--4.DICTIONARY�� MODEL DATA�� ���ؼ� ���ϴ� �۾��� ���������� ����Ǿ����� Ȯ��