--1. 권한관리 모델의 테이블들 생성을 위한 script 직접 작성 및 조별 발표 (150분)
--1,2번
CREATE TABLE USERS(
    USER_ID VARCHAR2(20) NOT NULL PRIMARY KEY
);

CREATE TABLE ROLES(
    ROLE_NAME VARCHAR2(20) NOT NULL PRIMARY KEY
);

CREATE TABLE PRIVS(
    PRIV_CD VARCHAR2(20) NOT NULL PRIMARY KEY
);

CREATE TABLE OBJ(
    TABLE_NAME VARCHAR2(20)
);

ALTER TABLE OBJ
ADD CONSTRAINT OBJ_TABLE_NAME PRIMARY KEY(TABLE_NAME);

ALTER TABLE OBJ
MODIFY TABLE_NAME NOT NULL;


CREATE TABLE USER_ROLES(
    USER_ID VARCHAR2(20),
    ROLE_NAME VARCHAR2(20)
);

ALTER TABLE USER_ROLES
ADD CONSTRAINT USER_ROLE_USER_ID_PK PRIMARY KEY(USER_ID);

ALTER TABLE USER_ROLES
MODIFY USER_ID NOT NULL;

ALTER TABLE USER_ROLES
ADD CONSTRAINT FK_FROM_ROLES FOREIGN KEY(ROLE_NAME) REFERENCES ROLES(ROLE_NAME);

ALTER TABLE USER_ROLES
MODIFY ROLE_NAME NOT NULL;

CREATE TABLE ROLE_OBJ_PRIVS(
    ROLE_NAME VARCHAR2(20),
    PNUM NUMBER
);
ALTER TABLE ROLE_OBJ_PRIVS
ADD CONSTRAINT FK_FROM_ROLE FOREIGN KEY(ROLE_NAME) REFERENCES ROLES(ROLE_NAME);

ALTER TABLE ROLE_OBJ_PRIVS
MODIFY ROLE_NAME NOT NULL;

ALTER TABLE ROLE_OBJ_PRIVS
ADD CONSTRAINT FK_FROM_OBJ_PRIVS FOREIGN KEY(PNUM) REFERENCES OBJ_PRIVS(PNUM);

ALTER TABLE ROLE_OBJ_PRIVS
MODIFY PNUM NOT NULL;

CREATE TABLE OBJ_PRIVS(
    TABLE_NAME VARCHAR2(20),
    PRIV_CD VARCHAR2(20)
);
ALTER TABLE OBJ_PRIVS
ADD PNUM NUMBER;

ALTER TABLE OBJ_PRIVS
ADD CONSTRAINT OBJ_PRIVS_PNUM_PK PRIMARY KEY(PNUM);

ALTER TABLE OBJ_PRIVS
MODIFY PNUM NOT NULL;

ALTER TABLE OBJ_PRIVS
ADD CONSTRAINT FK_FROM_OBJ FOREIGN KEY(TABLE_NAME) REFERENCES OBJ(TABLE_NAME);

ALTER TABLE OBJ_PRIVS
ADD CONSTRAINT FK_FROM_PRIVS FOREIGN KEY(PRIV_CD) REFERENCES PRIVS(PRIV_CD);
--3번 COMMENT
COMMENT ON COLUMN USERS.USER_ID IS '사용자 아이디';
COMMENT ON COLUMN USER_ROLES.USER_ID IS '사용자 아이디';
COMMENT ON COLUMN USER_ROLES.ROLE_NAME IS '롤 이름';
COMMENT ON COLUMN ROLES.ROLE_NAME IS '롤 이름';
COMMENT ON COLUMN ROLE_OBJ_PRIVS.ROLE_NAME IS '롤 이름';
COMMENT ON COLUMN ROLE_OBJ_PRIVS.PNUM IS '테이블 권한 번호';
COMMENT ON COLUMN OBJ_PRIVS.PNUM IS '테이블 권한 번호';
COMMENT ON COLUMN OBJ_PRIVS.TABLE_NAME IS '테이블 이름';
COMMENT ON COLUMN OBJ_PRIVS.PRIV_CD IS '권한 코드';
COMMENT ON COLUMN PRIVS.PRIV_CD IS '권한 코드';
COMMENT ON COLUMN OBJ.TABLE_NAME IS '테이블 이름';

COMMENT ON TABLE USERS IS '사용자 정보';
COMMENT ON TABLE USER_ROLES IS '사용자 롤';
COMMENT ON TABLE ROLES IS '롤 정보';
COMMENT ON TABLE OBJ_PRIVS IS '테이블 권한 정보';
COMMENT ON TABLE ROLE_OBJ_PRIVS IS '롤 테이블 권한 정보';
COMMENT ON TABLE PRIVS IS '권한 정보';
COMMENT ON TABLE OBJ IS '테이블 정보';
--COMMENT 확인
SELECT * FROM ALL_COL_COMMENTS 
WHERE TABLE_NAME = 'ROLE_OBJ_PRIVS';

--4번 CHECK 
ALTER TABLE PRIVS
ADD CONSTRAINT PRIV_CD_CK CHECK (PRIV_CD IN('I','D','U','S'));
--조회
SELECT *
FROM USER_CONS_COLUMNS
WHERE TABLE_NAME = 'PRIVS';

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'PRIVS';
-------------------------------------------------------------------------------------
SELECT  A.CONSTRAINT_NAME,
        B.TABLE_NAME, B.COLUMN_NAME,
        A.R_CONSTRAINT_NAME, 
        C.TABLE_NAME, C.COLUMN_NAME
FROM USER_CONSTRAINTS A, USER_CONS_COLUMNS B, USER_CONS_COLUMNS C
WHERE A.CONSTRAINT_TYPE = 'R'
AND B.CONSTRAINT_NAME = A.CONSTRAINT_NAME
AND C.CONSTRAINT_NAME = A.R_CONSTRAINT_NAME
ORDER BY A.TABLE_NAME;