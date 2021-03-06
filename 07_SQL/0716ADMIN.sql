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
--DATA삽입
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
--STUDY01의 테이블 정보 가져오기
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
INSERT INTO TROLE VALUES('DEPT_SUI', '부서정보변경(변경, 삽입)');
INSERT INTO TROLE VALUES('DEPT_SUID', '부서정보삭제(삭제)');
INSERT INTO TROLE VALUES('DEPT_S', '부서정보조회');
INSERT INTO TROLE VALUES('EMP_SUI', '직원정보변경(변경, 삽입)');
INSERT INTO TROLE VALUES('EMP_I', '직원정보입력');
INSERT INTO TROLE VALUES('EMP_SUID', '직원정보삭제(삭제)');
INSERT INTO TROLE VALUES('EMP_S', '직원정보조회');
INSERT INTO TROLE VALUES('DE_SUI', '직원부서모두변경');
INSERT INTO TROLE VALUES('DE_SUID', '직원부서모두삭제');
INSERT INTO TROLE VALUES('DE_S', '직원부서모두조회');
INSERT INTO TROLE VALUES('ALL_S', 'STUDY01 소유의 모든 테이블에 대한 조회');
INSERT INTO TROLE VALUES('ALL_SUI', 'STUDY01 소유의 모든 테이블에 대한 변경');
INSERT INTO TROLE VALUES('ALL_SUID', 'STUDY01 소유의 모든 테이블에 대한 모든 권한');

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

--과제
--ROLE
CREATE ROLE MAN_ROLE;
--ROLE에 권한부여
GRANT CREATE TABLE, CREATE VIEW
TO MAN_ROLE;
--ROLE을 사용자에게 부여
GRANT MAN_ROLE
TO user01, SCOTT;
--1.  ROLE CREATE 문장 생성 쿼리
SELECT 'CREATE ROLE '||ROLE_CD||';'
FROM TROLE;
--2.  ROLE 에 권한 부여하는 문장 생성 쿼리
SELECT 'GRANT '||DECODE(A.CRUD_CD,'S','SELECT', 'I', 'INSERT', 'U', 'UPDATE', 'D', 'DELETE')||
        ' ON STUDY01.'||A.OBJ_NM||
        ' TO '||B.ROLE_CD||';'
FROM TPRIVS A, TROL_PRIV B
WHERE A.PRIV_ID = B.PRIV_ID;
--3.  유저에 ROLE 부여하는 쿼리
SELECT 'GRANT '||ROLE_CD||
        ' TO '||USER_NM||';'
FROM TROL_USER;
SELECT * FROM TROL_USER;
--4.  STUDY03이 어떤 테이블에 대해 어떤 권한을 가졌는지 확인하는 쿼리
--모델에서 추출
SELECT C.USER_NM, C.ROLE_CD, A.CRUD_CD
FROM TPRIVS A, TROL_PRIV B, TROL_USER C
WHERE USER_NM = 'STUDY03'
AND C.ROLE_CD = B.ROLE_CD
AND A.PRIV_ID = B.PRIV_ID;
--DICTIONARY에서 추출
--ROLE-TAB-PRIVS
SELECT A.GRANTEE, A.GRANTED_ROLE, B.TABLE_NAME, B.PRIVILEGE
FROM DBA_ROLE_PRIVS A, ROLE_TAB_PRIVS B
WHERE A.GRANTED_ROLE = B.ROLE
AND A.GRANTEE = 'STUDY03';

SELECT * FROM DBA_ROLE_PRIVS;
SELECT * FROM ROLE_TAB_PRIVS;
--보너스
--STUDY01이 가진 모든 테이블의 삭제 권한을 유저로부터 회수하려고합니다.
--0.어떤 테이블이든지 삭제권한을 가진 롤과 그 롤을 부여받은 유저 확인할 수 있는 쿼리
SELECT D.ROLE_CD, C.USER_NM
FROM TROL_USER C, TROLE D
WHERE C.ROLE_CD(+) = D.ROLE_CD
AND D.ROLE_CD LIKE '%D';
--1.기존 삭제권한을 가진 유저는 모두 변경권한으로 대체
UPDATE TROL_USER
SET ROLE_CD = REPLACE(ROLE_CD, 'SUID', 'SUI')
WHERE ROLE_CD IN (SELECT D.ROLE_CD
                    FROM TROL_USER C, TROLE D
                    WHERE C.ROLE_CD = D.ROLE_CD
                    AND D.ROLE_CD LIKE '%D');

SELECT * FROM TROL_USER;
--2.삭제권한을 가진 ROLE과 유저 데이터를 모두 REVOKE
SELECT A.GRANTEE, A.GRANTED_ROLE, B.TABLE_NAME, B.PRIVILEGE
FROM DBA_ROLE_PRIVS A, ROLE_TAB_PRIVS B
WHERE A.GRANTED_ROLE = B.ROLE
AND GRANTED_ROLE LIKE '%D';
--3.삭제권한에 해당하는 모든 데이터를 DELETE하고
--4.DICTIONARY와 MODEL DATA를 비교해서 원하는 작업이 정상적으로 수행되었는지 확인