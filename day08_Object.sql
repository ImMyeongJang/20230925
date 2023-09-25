--day08_Object.sql
# ORACLE의 객체
[1] SEQUENCE
[2] VIEW
[3] INDEX
[4] SYNONYM

#[1] 시퀀스란? 

◈ 유일(UNIQUE)한 값을 생성해주는 오라클 객체다. 
◈ 시퀀스를 생성하면 기본키와 같이 순차적으로 
   증가하는 컬럼을 
   자동적으로 생성할수 있다. 
◈ 보통 primary key 값을 생성하기 위해 사용한다. 
◈ 메모리에 Cache되었을 때 Sequence 값의 
   액세스 효율이 증가 한다. 
◈ Sequence는 테이블과는 독립적으로 저장되고 생성됩니다. 
    따라서 하나의 sequence를  여러 테이블에서 쓸 수 있다
구문
CREATE SEQUENCE 시퀀스명
[INCREMENT BY n] -- 증가치
[START WITH n]   -- 시작값
[{MAXVALUE n | NOMAXVALE}] -- 최대값 지정
[{MINVALUE n | NOMINVALUE}]-- 최소값
[{CYCLE | NOCYCLE}] -- 반복여부
[{CACHE | NOCACHE}] -- 캐시 사용 여부


SELECT * FROM DEPT2;

CREATE SEQUENCE DEPT2_SEQ
START WITH 60
INCREMENT BY 10
MAXVALUE 99
NOCACHE
NOCYCLE;

PRIMARY KEY 에는 CYCLE 옵션 사용 불가

데이터 사전에서 조회
- USER_OBJECTS
- USER_SEQUENCES

SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE='SEQUENCE';

SELECT * FROM USER_SEQUENCES;

DEPT2에 'SALES2' 부서를 삽입하세요 위치: 'BUSAN'

INSERT INTO DEPT2 (DEPTNO,DNAME, LOC)
VALUES(DEPT2_SEQ.NEXTVAL,'SALES2','BUSAN');

SELECT * FROM DEPT2 ORDER BY DEPTNO ASC;

'RESEARCH2' 'SUWON' 삽입하세요

INSERT INTO DEPT2
VALUES(DEPT2_SEQ.NEXTVAL,'RESEARCH2','SUWON');

DESC DEPT2;

- 시퀀스 속성
[1] NEXTVAL : NEXT VALUE (다음값)
[2] CURRVAL : CURRENT VALUE (현재값)

# SEQUENCE 사용법

- NEXTVAL, CURRVAL을 사용하여 시퀀스 값을 참조한다.
- NEXTVAL은 다음 사용가능한 시퀀스 값을 반환한다.
- 시퀀스가 참조될 때마다 다른 사용자에게 조차도 유일한 값을 반환한다.
- CURRVAL은 현재 SEQUENCE값을 얻는다.
- CURRVAL이 참조되기 전에 NEXTVAL이 사용되어야 한다.

**참고]
어떤 세션에서 NEXTVAL 을 하지 않은 채 CURRVAL 을 요구하게 되면 에러가 
난다. 그것은 CURRVAL 은 바로 그 세션이 지금 현재 가지고 있는 최종 시퀸스 값을 의미 
하므로 한번도 NEXTVAL 을 요구한 적이 없다면 보유하고 있는 CURRVAL 값이 없기 
때문이다. 

SELECT DEPT2_SEQ.CURRVAL FROM DUAL;

시퀀스명:  TEMP_SEQ
시작값: 100
증가치: -5씩 감소
최소값: 0
CYCLE옵션주기
CACHE사용하기

CREATE SEQUENCE TEMP_SEQ
START WITH 100
INCREMENT BY -5
MINVALUE 0
MAXVALUE 100
CYCLE
CACHE 20;

SELECT TEMP_SEQ.CURRVAL FROM DUAL;

SELECT TEMP_SEQ.NEXTVAL FROM DUAL;

# 시퀀스 수정
ALTER SEQUENCE 시퀀스명
INCREMENT BY N
MINVALUE N|NOMINVALUE
MAXVALUE N|NOMAXVALUE
CYCLE|NOCYCLE
CACHE|NOCACHE

[주의] 시작값(START WITH)은 수정할 수 없다.

# 시퀀스 삭제
DROP SEQUENCE 시퀀스명;

TEMP_SEQ를 다음과 같이 수정하세요
증가치: 2
MINVALUE : 현재 시퀀스값
MAXVALUE: 100
NOCYCLE
NOCACHE
로 수정하세요

SELECT TEMP_SEQ.CURRVAL FROM DUAL;

ALTER SEQUENCE TEMP_SEQ
INCREMENT BY 2
MINVALUE 70
MAXVALUE 100
NOCYCLE
NOCACHE;

# USER_SEQUENCES에서 조회하기

SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME='TEMP_SEQ';

SELECT TEMP_SEQ.NEXTVAL FROM DUAL;

SELECT 2*8 FROM DUAL;

# TEMP_SEQ 시퀀스를 삭제하세요
DROP SEQUENCE TEMP_SEQ;

SELECT * FROM DUAL;
--------------------------------------------------------------------
# [2] VIEW

- 가상의 테이블
- 복잡한 쿼리문을 단순화시킬 수 있다.
- 데이터를 다양한 관점으로 볼 수 있다


 # 뷰를 만드는 규칙
	CREATE VIEW 뷰이름
	AS
	SELECT 컬럼명1, 컬럼명2...
	FROM 뷰에 사용할 테이블명
	WHERE 조건

** 서브쿼리는 조인,그룹 등 복합 SELECT문을 포함할 수 있고 ORDER BY절을
	    포함할 수 없다.
	    VIEW를 삭제하거나 재생산 하지 않고VIEW의 정의를 변경하려면
	    OR REPLACE옵션을 사용한다.
	...주의] view를 만들기 위해서는 권한이 필요[dba권한으로 CREATE VIEW권한을 주자]


-------------------------------------------------
먼저 dba계정으로 접속해서 scott에게 create view 권한을 부여하자

conn system/oracle

show user

grant create view to scott;

-- Grant을(를) 성공했습니다.

conn scott/tiger
show user

[실습]
	EMP테이블에서 20번 부서의 모든 컬럼을 포함하는 EMP20_VIEW를 생성하라.
    
    create view emp20_view
    as
    select * from emp where deptno=20;
    
    
    select * from emp20_view;
    
    emp20_view에 사번,부서번호,이름,업무만 포함되도록 수정하세요
    
    #view의 수정은 or replace 옵션을 준다
    
    create or replace view emp20_view
    as select empno,deptno,ename,job from emp where deptno=20;
    
    select * from emp20_view;
    
    
    [1] EMP테이블에서 30번 부서만 EMPNO를 EMP_NO로 ENAME을 NAME으로
	SAL를 SALARY로 바꾸어 EMP30_VIEW를 생성하여라.
    
    create or replace view emp30_view(emp_no, name, salary)
    as
    select empno, ename, sal from emp
    where deptno=30;
    
    select * from emp30_view;
    
    [2] 고객테이블의 고객 정보 중 나이가 19세 이상인
	고객의 정보를 확인하는 뷰를 만들어보세요.
	단 뷰의 이름은 MEMBER_19로 하세요.
    
    create or replace view member_19
    as
    (select userid id, name, age, job, addr address from member  where age>=19);

select * from member_19;
select * from member;
# 데이터 사전에서 조회: USER_VIEWS

SELECT * FROM USER_VIEWS WHERE VIEW_NAME=UPPER('MEMBER_19');

# 뷰 삭제
DROP VIEW 뷰이름

MEMBER_19  뷰를 삭제하세요

DROP VIEW MEMBER_19;



