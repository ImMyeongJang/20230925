--day08_Object.sql
# ORACLE�� ��ü
[1] SEQUENCE
[2] VIEW
[3] INDEX
[4] SYNONYM

#[1] ��������? 

�� ����(UNIQUE)�� ���� �������ִ� ����Ŭ ��ü��. 
�� �������� �����ϸ� �⺻Ű�� ���� ���������� 
   �����ϴ� �÷��� 
   �ڵ������� �����Ҽ� �ִ�. 
�� ���� primary key ���� �����ϱ� ���� ����Ѵ�. 
�� �޸𸮿� Cache�Ǿ��� �� Sequence ���� 
   �׼��� ȿ���� ���� �Ѵ�. 
�� Sequence�� ���̺���� ���������� ����ǰ� �����˴ϴ�. 
    ���� �ϳ��� sequence��  ���� ���̺��� �� �� �ִ�
����
CREATE SEQUENCE ��������
[INCREMENT BY n] -- ����ġ
[START WITH n]   -- ���۰�
[{MAXVALUE n | NOMAXVALE}] -- �ִ밪 ����
[{MINVALUE n | NOMINVALUE}]-- �ּҰ�
[{CYCLE | NOCYCLE}] -- �ݺ�����
[{CACHE | NOCACHE}] -- ĳ�� ��� ����


SELECT * FROM DEPT2;

CREATE SEQUENCE DEPT2_SEQ
START WITH 60
INCREMENT BY 10
MAXVALUE 99
NOCACHE
NOCYCLE;

PRIMARY KEY ���� CYCLE �ɼ� ��� �Ұ�

������ �������� ��ȸ
- USER_OBJECTS
- USER_SEQUENCES

SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE='SEQUENCE';

SELECT * FROM USER_SEQUENCES;

DEPT2�� 'SALES2' �μ��� �����ϼ��� ��ġ: 'BUSAN'

INSERT INTO DEPT2 (DEPTNO,DNAME, LOC)
VALUES(DEPT2_SEQ.NEXTVAL,'SALES2','BUSAN');

SELECT * FROM DEPT2 ORDER BY DEPTNO ASC;

'RESEARCH2' 'SUWON' �����ϼ���

INSERT INTO DEPT2
VALUES(DEPT2_SEQ.NEXTVAL,'RESEARCH2','SUWON');

DESC DEPT2;

- ������ �Ӽ�
[1] NEXTVAL : NEXT VALUE (������)
[2] CURRVAL : CURRENT VALUE (���簪)

# SEQUENCE ����

- NEXTVAL, CURRVAL�� ����Ͽ� ������ ���� �����Ѵ�.
- NEXTVAL�� ���� ��밡���� ������ ���� ��ȯ�Ѵ�.
- �������� ������ ������ �ٸ� ����ڿ��� ������ ������ ���� ��ȯ�Ѵ�.
- CURRVAL�� ���� SEQUENCE���� ��´�.
- CURRVAL�� �����Ǳ� ���� NEXTVAL�� ���Ǿ�� �Ѵ�.

**����]
� ���ǿ��� NEXTVAL �� ���� ���� ä CURRVAL �� �䱸�ϰ� �Ǹ� ������ 
����. �װ��� CURRVAL �� �ٷ� �� ������ ���� ���� ������ �ִ� ���� ������ ���� �ǹ� 
�ϹǷ� �ѹ��� NEXTVAL �� �䱸�� ���� ���ٸ� �����ϰ� �ִ� CURRVAL ���� ���� 
�����̴�. 

SELECT DEPT2_SEQ.CURRVAL FROM DUAL;

��������:  TEMP_SEQ
���۰�: 100
����ġ: -5�� ����
�ּҰ�: 0
CYCLE�ɼ��ֱ�
CACHE����ϱ�

CREATE SEQUENCE TEMP_SEQ
START WITH 100
INCREMENT BY -5
MINVALUE 0
MAXVALUE 100
CYCLE
CACHE 20;

SELECT TEMP_SEQ.CURRVAL FROM DUAL;

SELECT TEMP_SEQ.NEXTVAL FROM DUAL;

# ������ ����
ALTER SEQUENCE ��������
INCREMENT BY N
MINVALUE N|NOMINVALUE
MAXVALUE N|NOMAXVALUE
CYCLE|NOCYCLE
CACHE|NOCACHE

[����] ���۰�(START WITH)�� ������ �� ����.

# ������ ����
DROP SEQUENCE ��������;

TEMP_SEQ�� ������ ���� �����ϼ���
����ġ: 2
MINVALUE : ���� ��������
MAXVALUE: 100
NOCYCLE
NOCACHE
�� �����ϼ���

SELECT TEMP_SEQ.CURRVAL FROM DUAL;

ALTER SEQUENCE TEMP_SEQ
INCREMENT BY 2
MINVALUE 70
MAXVALUE 100
NOCYCLE
NOCACHE;

# USER_SEQUENCES���� ��ȸ�ϱ�

SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME='TEMP_SEQ';

SELECT TEMP_SEQ.NEXTVAL FROM DUAL;

SELECT 2*8 FROM DUAL;

# TEMP_SEQ �������� �����ϼ���
DROP SEQUENCE TEMP_SEQ;

SELECT * FROM DUAL;
--------------------------------------------------------------------
# [2] VIEW

- ������ ���̺�
- ������ �������� �ܼ�ȭ��ų �� �ִ�.
- �����͸� �پ��� �������� �� �� �ִ�


 # �並 ����� ��Ģ
	CREATE VIEW ���̸�
	AS
	SELECT �÷���1, �÷���2...
	FROM �信 ����� ���̺��
	WHERE ����

** ���������� ����,�׷� �� ���� SELECT���� ������ �� �ְ� ORDER BY����
	    ������ �� ����.
	    VIEW�� �����ϰų� ����� ���� �ʰ�VIEW�� ���Ǹ� �����Ϸ���
	    OR REPLACE�ɼ��� ����Ѵ�.
	...����] view�� ����� ���ؼ��� ������ �ʿ�[dba�������� CREATE VIEW������ ����]


-------------------------------------------------
���� dba�������� �����ؼ� scott���� create view ������ �ο�����

conn system/oracle

show user

grant create view to scott;

-- Grant��(��) �����߽��ϴ�.

conn scott/tiger
show user

[�ǽ�]
	EMP���̺��� 20�� �μ��� ��� �÷��� �����ϴ� EMP20_VIEW�� �����϶�.
    
    create view emp20_view
    as
    select * from emp where deptno=20;
    
    
    select * from emp20_view;
    
    emp20_view�� ���,�μ���ȣ,�̸�,������ ���Եǵ��� �����ϼ���
    
    #view�� ������ or replace �ɼ��� �ش�
    
    create or replace view emp20_view
    as select empno,deptno,ename,job from emp where deptno=20;
    
    select * from emp20_view;
    
    
    [1] EMP���̺��� 30�� �μ��� EMPNO�� EMP_NO�� ENAME�� NAME����
	SAL�� SALARY�� �ٲپ� EMP30_VIEW�� �����Ͽ���.
    
    create or replace view emp30_view(emp_no, name, salary)
    as
    select empno, ename, sal from emp
    where deptno=30;
    
    select * from emp30_view;
    
    [2] �����̺��� �� ���� �� ���̰� 19�� �̻���
	���� ������ Ȯ���ϴ� �並 ��������.
	�� ���� �̸��� MEMBER_19�� �ϼ���.
    
    create or replace view member_19
    as
    (select userid id, name, age, job, addr address from member  where age>=19);

select * from member_19;
select * from member;
# ������ �������� ��ȸ: USER_VIEWS

SELECT * FROM USER_VIEWS WHERE VIEW_NAME=UPPER('MEMBER_19');

# �� ����
DROP VIEW ���̸�

MEMBER_19  �並 �����ϼ���

DROP VIEW MEMBER_19;



