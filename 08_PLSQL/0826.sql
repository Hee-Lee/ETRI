SET SERVEROUTPUT ON
DECLARE
lname VARCHAR2(15);
BEGIN
SELECT last_name INTO lname FROM employees WHERE     
first_name='John'; 
DBMS_OUTPUT.PUT_LINE ('John''s last name is : ' ||lname);
END;
--������ ����
SET SERVEROUTPUT ON
DECLARE
lname VARCHAR2(15);
BEGIN
SELECT last_name INTO lname FROM employees WHERE     
first_name='John'; 
DBMS_OUTPUT.PUT_LINE ('John''s last name is : ' ||lname);
EXCEPTION
WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.PUT_LINE (' Your select statement retrieved multiple rows. Consider using a cursor.');
END;
--���� �������� ���� 
SET SERVEROUTPUT ON
DECLARE
insert_excep EXCEPTION;
PRAGMA EXCEPTION_INIT   (insert_excep, -01400);
BEGIN
INSERT INTO departments (department_id, department_name) VALUES (280, NULL);
EXCEPTION
WHEN insert_excep THEN
DBMS_OUTPUT.PUT_LINE('INSERT OPERATION FAILED');
DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
--���� ���ǿ��� Ʈ��
ACCEPT deptno PROMPT 'Please enter the department number:' 
ACCEPT name   PROMPT 'Please enter the department name:' 
DECLARE 
    invalid_department EXCEPTION; 
    name VARCHAR2(20):='&name'; 
    deptno NUMBER :=&deptno; 
BEGIN 
    UPDATE  departments 
    SET     department_name = name
    WHERE   department_id = deptno; 
    IF SQL%NOTFOUND 
    THEN 
        RAISE invalid_department; 
    END IF;
    COMMIT; 
    EXCEPTION WHEN invalid_department  
    THEN 
        DBMS_OUTPUT.PUT_LINE('No such department id.');
END; 
/
create table messages ( m_user varchar2(100), m_date date, m_code number, m_cont varchar2(200), constraint message_pk primary key(m_user, m_date));

--����1
/* �� ������ ������ �̸� ���ǵ� ���ܿ� ���� ������ �����ϴ� ���Դϴ�. ������ �޿�
���� ���� ����� �̸��� �����ϴ� PL/SQL ����� �ۼ��մϴ�.
a. messages ���̺��� ��� ���ڵ带 �����մϴ�. DEFINE ����� ����Ͽ� sal
������ �����ϰ� 6000���� �ʱ�ȭ�մϴ�. 
b. ���� ���ǿ��� employees.last_name ������ ename ������
employees.salary ������ emp_sal ������ �����մϴ�. ��ü ������
���� emp_sal�� �����մϴ�.
c. ���� ���ǿ��� �޿��� emp_sal�� ���� ������ ����� �̸��� �˻��մϴ�.
��: ����� Ŀ���� ������� ���ʽÿ�. �Էµ� �޿��� ���� �ϳ��� ��ȯ�ϴ�
��� messages ���̺� ��� �̸� �� �޿��� �����Ͻʽÿ�.
d. �Էµ� �޿��� ���� ��ȯ���� ������ ������ ���� ó����� ���ܸ� ó���ϰ�
messages ���̺� "No employee with a salary of <salary>" �޽����� �����մϴ�.
e. �Էµ� �޿��� �� �̻��� ���� ��ȯ�ϸ� ������ ���� ó����� ���ܸ� ó���ϰ�
messages ���̺� "More than one employee with a salary of <salary>" �޽�����
�����մϴ�.
f. ��Ÿ ������ ��� ������ ���� ó����� ó���ϰ� messages ���̺� "Some other
error occurred" �޽����� �����մϴ�.
g. messages ���̺��� ���� ǥ���Ͽ� PL/SQL ����� ���������� ����Ǿ�����
Ȯ���մϴ�. ������ ��� ���Դϴ�. */
DEFINE SAL = 6000
DECLARE
    ENAME EMPLOYEES.LAST_NAME%TYPE;
    EMP_SAL EMPLOYEES.SALARY%TYPE := &SAL;
BEGIN
    SELECT LAST_NAME
    INTO ENAME
    FROM EMPLOYEES
    WHERE SALARY = EMP_SAL;
    
    INSERT INTO MESSAGES(M_USER)
    VALUES (ENAME);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
    insert into messages(m_user, m_date, m_cont)
    select sys_context('USERENV', 'IP_ADDRESS'), sysdate, 'name:' || ename||',salary :'|| emp_sal
    from dual;
    WHEN NO_DATA_FOUND THEN
    insert into messages(m_user, m_date, m_coNt)
    select sys_context('USERENV', 'IP_ADDRESS'), sysdate, 'name:' || ename||',salary :'|| emp_sal
    from dual;
    WHEN OTHERS THEN
    insert into messages(m_user, m_date, m_cont)
    select sys_context('USERENV', 'IP_ADDRESS'), sysdate, 'name:' || ename||',salary :'|| emp_sal
    from dual;
END;

SELECT * FROM MESSAGES;
--����2
/*2. �� ������ ������ ǥ�� Oracle ���� ������ ����Ͽ� ���ܸ� �����ϴ� ����� �����ϴ� ���Դϴ�. 
Oracle ���� ���� ORA-02292(���Ἲ ���� ���� ���� ? ���� ���ڵ� �߰�)�� ����մϴ�. 
a. ���� ���ǿ��� childrecord_exists ���ܸ� �����մϴ�. ����� ���ܸ� ǥ�� Oracle ���� ���� ?02292�� �����մϴ�. 
b. ���� ���ǿ��� "Deleting department 40...."�� ����մϴ�. department_id�� 40�� �μ��� �����ϴ� DELETE ���� ���Խ�ŵ�ϴ�. 
c. childrecord_exists ���ܸ� ó���ϰ� ������ �޽����� ����ϴ� ���� ������ ���Խ�ŵ�ϴ�. ������ ��� ���Դϴ�.*/
DECLARE
    childrecord_exists  EXCEPTION;
    PRAGMA EXCEPTION_INIT
    (childrecord_exists, -02292);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Deleting department 40....');
    
    DELETE DEPARTMENTS
    WHERE DEPARTMENT_ID = 40;
EXCEPTION 
    WHEN childrecord_exists THEN
    DBMS_OUTPUT.PUT_LINE('����');
END;
/
SELECT * FROM DEPARTMENTS;
--3. �͸��Ͽ��� EMP_ID�� �Ҵ��� ���� �����ϰ� ����ο��� HOBBY�� ����� ��� ��ȸ�Ͽ� 
--   ������ �Ҵ� �� ��� ����ϴ� ���๮ �ۼ��ϰ� �����Ͽ� ���� ���� Ȯ��.
declare
    empid temp.emp_id%type;

begin
    select emp_id
    into empid
    from temp
    where hobby = '���';

    dbms_output.put_line('���: '||empid);
end;
/
--4. EXCEPTION���� TOO_MANY_ROWS EXCEPTION�� �����ϰ� 
--   ����ȸ ��� 1�ຸ�� ���� ROW�� �˻��Ǿ� ������ �����մϴ�.�� ��� �޽��� ���
declare
    empid temp.emp_id%type;
begin
    select emp_id
    into empid
    from temp
    where hobby = '���';

    dbms_output.put_line('���: '||empid);
exception
    when too_many_rows then
        dbms_output.put_line('��ȸ ��� 1�ຸ�� ���� ROW�� �˻��Ǿ� ������ �����մϴ�.');  
end;
/
--5. TEMP���� �������� �ʴ� ��� SELECT �� NO_DATA_FOUND ���� �߻���Ű�� 
--   EXCEPTION ó���ϱ� 
declare
    empid temp.emp_id%type;
begin
    select emp_id
    into empid
    from temp
    where EMP_ID = 1;

    dbms_output.put_line('���: '||empid);
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('���Ŀ��');  
end;
/
--6. ZERO_DIVIDE ���� �߻���Ű�� EXCEPTION ó���ϱ� 
DECLARE
    N NUMBER;
BEGIN
    N := 10/0;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('ZERO_DIVIDE ����');    
END;
--
CREATE TABLE ELOG(
    EMP_ID NUMBER,
    LEV VARCHAR2(08),
    FLAG VARCHAR2(01),
    SAL_FLAG VARCHAR2(01),
    AGE_FLAG VARCHAR2(01),
    ECODE NUMBER,
    ERRM VARCHAR2(1000)
    );
--7. ��� �����߻� ��Ȳ�� ����Ŭ �� �޽��� �̿��Ͽ� ����ڿ��� ������ ������Ű�� 
DECLARE
    E1 ELOG.EMP_ID%TYPE;
BEGIN
    SELECT EMP_ID 
    INTO E1
    FROM ELOG;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM); 
END;
/*8. TEMP�� Ŀ���� �о �� �Ǿ� FETCH�ϸ� ELOG�� INSERT
   EMP_LEVEL�� SELECT �غ��� �ش� ������ �����ϸ� ELAG �� 1,
   SALARY�� �����ȿ� ��� 1, �ƴϸ� 0,
   AGE�� ���� �ȿ� ��� 1 �ƴϸ� 0, 
   ������ �������� ������ NO_DATA_FOUND EXCEPTION���� ����߷���
   FLAG 0, ECODE �� SQLCODE, ERRM�� SQLERRM INSERT
  (�߰��� ���� �߻��ص� ������ ����Ǿ�� ��)*/
SELECT * FROM ELOG;
declare
    emplev emp_level%rowtype;
    v_lev VARCHAR2(8);
    v_sal number := 0;
    v_age number := 0;  
    v_ecode elog.ecode%type;
    v_errm elog.errm%type;
    cursor c1 is
    select *
    from temp;
begin
    for i in c1 loop
        begin
            select *
            into emplev
            from emp_level
            where lev = i.lev;        
            if i.salary between emplev.from_sal and emplev.to_sal then
                v_sal := 1;
            end if;
            if 2019-to_char(i.birth_date,'yyyy')+1 between emplev.from_age and emplev.to_age then
                v_age :=1;
            end if;
            insert into elog(emp_id, lev, flag, sal_flag,age_flag)
            values (i.emp_id, i.lev, 1, v_sal, v_age);                 
        exception
            when no_data_found then
                v_ecode := sqlcode;
                v_errm := sqlerrm;
                insert into elog(emp_id, lev, flag, sal_flag, age_flag, ecode, errm)
                values(i.emp_id, i.lev, 0, 0,0, v_ecode, v_errm );
        end;   
    end loop;
end;
/*9. ����ο� ����� ���ܸ� �����ϰ� ����� �������� ���� ����� ���� 
   EXCEPTION �߻���Ű��
   EXCEPTION���� ����� ���� EXCEPTION�� �޾� �������ڰ� ������ �����Դϴ�.�� 
   �޽��� ���*/
DECLARE
    T1 NUMBER;
    UE EXCEPTION;
BEGIN
    UPDATE  departments 
    SET     department_name = 11 
    WHERE   department_id = -1; 
    IF SQL%NOTFOUND THEN
        RAISE UE;
    END IF;
EXCEPTION WHEN UE THEN
    DBMS_OUTPUT.PUT_LINE('�����ڰ� ������ �����Դϴ�.');
END;
/*10. 9���� RAISE ���� NO_DATA_FOUND �� ��ü�ϰ� EXCEPTION���� 
    NO_DATA_FOUND�� ���� ��
   '�����ڰ� �߻���Ų NO DATA FOUND ���� �Դϴ�. �� ���  */
DECLARE
    U_EXCEPTION EXCEPTION;
BEGIN
    RAISE NO_DATA_FOUND;
EXCEPTION
    WHEN U_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE('�����ڰ� ������ �����Դϴ�.');
    WHEN NO_DATA_FOUND
    THEN DBMS_OUTPUT.PUT_LINE('�����ڰ� ������ �����Դϴ�.');
END;
/*11. ���� ���� EXCEPTION�� �����ϰ� FOR LOOP���� TEMP �ڷḦ ��� 
    SELECT �ؼ� �� �Ǿ� �ش� ������ 
   EMP_LEVEL�� UPDATE(������ ���̰� FROM_AGE���� ������ 
   FROM_AGE�� ���� ���̷� ����)�ϴµ�,
   ���� �ش� ������ �������� ������ ���� ���� ������ �߻� ���� 
   ����ڰ� ���� �޽����� ���� â���� �� ��
   �ֵ��� ���� LEV || ���ڷᰡ EMP_LEVEL�� �����ϴ�. ���� �ڷḦ ����ϰ� �� ���� �ϼ��䡯*/
DECLARE
    USER_EXCEP EXCEPTION;
    L TEMP.LEV%TYPE;
    CURSOR CUR IS
    SELECT *
    FROM TEMP;
BEGIN
    FOR I IN CUR LOOP 
        UPDATE EMP_LEVEL
        SET FROM_AGE = CEIL((SYSDATE-I.BIRTH_DATE)/365)
        WHERE LEV = I.LEV
        AND FROM_AGE > CEIL((SYSDATE-I.BIRTH_DATE)/365);
        L := I.LEV;
        IF SQL%NOTFOUND THEN
            RAISE USER_EXCEP;
        END IF;
    END LOOP;
EXCEPTION
    WHEN USER_EXCEP THEN
    DBMS_OUTPUT.PUT_LINE(L||' �ڷᰡ EMP_LEVEL�� �����ϴ�. ���� �ڷḦ ����ϰ� �� ���� �ϼ���');
END;
/
--BONUS
--1. BEGIN���� ���� ������� ����� ���� �߻���Ű�� �ٷ� ���� ���� Ÿ���� �޼��� ����ϰ�
--   EXCEPTION���� OTHERS�� �޾Ƽ� �޼��� ����Ͽ� ��� �޼����� �������� Ȯ��
BEGIN
    DELETE TEMP2
    WHERE EMP_ID = 1;
    RAISE_APPLICATION_ERROR(-20202, 'This is not a valid manager');
    DBMS_OUTPUT.PUT_LINE('������');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('����� EXCEPTION���');
END;
--2. 1�� EXCEPTION���� SQLCODE�� SQLERRM ���
BEGIN
    DELETE TEMP2
    WHERE EMP_ID = 1;
    RAISE_APPLICATION_ERROR(-20202, 'This is not a valid manager');
    DBMS_OUTPUT.PUT_LINE('������');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('����� EXCEPTION��� '||SQLCODE||SQLERRM);
END;
--3. 2���� -20001������ MY_ERROR��� �̸����� PRAGMA�� �̿� �ʱ�ȭ�ϰ�
--   EXCEPTION���� MY_ERROR�� �޾� SQLCODE�� SQLERRM ���
DECLARE
    MY_ERROR EXCEPTION;
    PRAGMA EXCEPTION_INIT (MY_ERROR, -20001);
BEGIN
    DELETE TEMP2
    WHERE EMP_ID = 1;
    RAISE MY_ERROR;
EXCEPTION WHEN MY_ERROR THEN
    DBMS_OUTPUT.PUT_LINE(SQLCODE||SQLERRM);
END;
--4. TEST04�� 20181201���ڷ� NULL INSERT�ϴ� BLOCK �ۼ�
BEGIN
    INSERT INTO TEST04
    VALUES(20181201,NULL);
END;
SELECT * FROM TEST04;
--5. ���� �������� ������ ������ȣ�� ó���� �� �ִ� PRAGMA EXCEPTION_INIT�� �����ϰ� ���� ó���Ͽ�
--   ģ���� �ȳ� �޼��� ���
DECLARE
    MY_ERROR EXCEPTION;
    PRAGMA EXCEPTION_INIT (MY_ERROR, -01400);
BEGIN
    INSERT INTO TEST04
    VALUES(20181201,NULL);
    RAISE_APPLICATION_ERROR(-01400,'cannot insert NULL into (%s)');
EXCEPTION WHEN MY_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('SQLCODE: '||SQLCODE||'SQLERRM: '||SQLERRM);
END;