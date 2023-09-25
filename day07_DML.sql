--day07_DML.sql

CREATE TABLE EMP2
AS
SELECT * FROM EMP;

SELECT * FROM EMP2;

CREATE TABLE DEPT2
AS
SELECT * FROM DEPT;

DEPT2에 DEPTNO 컬럼에 PRIMARY KEY 제약조건 추가하기

alter table dept2 add constraint dept2_pk primary key (deptno);

EMP2에 EMPNO컬럼에 PRIMARY KEY 제약조건 추가하기

alter table emp2 add constraint emp2_pk primary key (empno);

EMP2에 DEPTNO 컬럼에 FOREIGN KEY 제약조건 추가하기

alter table emp2 add constraint emp2_fk foreign key (deptno) references dept2(deptno);

# INSERT 문
INSERT INTO 테이블명(컬럼명1,컬럼명2,...)
            VALUES(값1, 값2,...)
            
INSERT INTO 테이블명
VALUES(값1, 값2,...)
=> 모든 컬럼값을 넣어야 함. 테이블 생성시 만든 컬럼 순서대로 값을 넣자

EMP2에 사번,이름,입사일, 부서번호를 INSERT 하자

INSERT INTO EMP2(EMPNO, ENAME, HIREDATE, DEPTNO)
VALUES(8001,'TOM',SYSDATE,10);

SELECT * FROM EMP2;


INSERT INTO EMP2
VALUES(8002,'PETER','MANAGER',7788,SYSDATE, 2500,NULL,20);

SELECT * FROM EMP2;

DEPT2에 50번부서 'EDUCATION','SEOUL'  데이터를 추가하세요

SELECT * FROM DEPT2;

INSERT INTO DEPT2
VALUES(50,'EDUCATION','SEOUL');

COMMIT;

# INSERT 문에서 SUBQUERY 사용
INSERT INTO 테이블명
SUBQUERY

SELECT * FROM PRODUCTS;

 PRODUCTS 테이블을 카피하여 PRODUCTS_TEMP 테이블을 생성하되,
 테이블 구조만 복사하세요

CREATE TABLE PRODUCTS_TEMP
AS SELECT * FROM PRODUCTS WHERE 1=0;

SELECT * FROM PRODUCTS_TEMP;

PRODUCTS_TEMP 테이블에 데이터를 삽입하되,
PRODUCTS에 있는 전자제품군에 속하는 데이터만 삽입하세요
'0001xxxx'

INSERT INTO PRODUCTS_TEMP
SELECT * FROM PRODUCTS WHERE CATEGORY_FK LIKE '0001%';

SELECT * FROM PRODUCTS_TEMP;
COMMIT;

# UPDATE 문
UPDATE 테이블명 SET 컬럼명1=값1, 컬럼명2=값2,...;

UPDATE 테이블명 SET 컬럼명1=값1, 컬럼명2=값2,... WHERE 조건절;


[1] EMP2에서 사번이 7788인 사원의 부서번호를 10번으로 수정하세요
SELECT * FROM EMP2;

UPDATE EMP2 SET DEPTNO=10 WHERE EMPNO=7788;

[2] emp2 테이블에서 사번이 7788인 사원의 부서를 20,
	급여를 3500으로 변경하여라.
    
    UPDATE EMP2 SET DEPTNO=20, SAL=3500 WHERE EMPNO=7788;
    
    SELECT * FROM EMP2 WHERE EMPNO=7788;

    ROLLBACK;
[3] emp2테이블에서 부서를 모두 10으로 변경하여라.
    
    UPDATE EMP2 SET DEPTNO=10;

    SELECT * FROM EMP2;
    
    ROLLBACK;
    
    
[4] 고객(MEMBER) 테이블 중 이름이 '홍길동'인 사람의 이름을 
	      '박길동'으로 변경하세요.      
      SELECT * FROM MEMBER;    
      
      UPDATE MEMBER SET NAME='박길동'
      WHERE NAME='홍길동';
      ROLLBACK;
[5] 고객 중 13/09/01이후 등록한 고객들의 마일리지를 350점씩 올려주세요.   
    UPDATE MEMBER SET MILEAGE=MILEAGE+350
    WHERE REG_DATE >= '13/09/01';    
    ROLLBACK;
    SELECT * FROM MEMBER;

[6] 등록되어 있는 고객 정보 중 이름에 '김'자가 들어있는 모든 이름을 '김' 대신
	     '최'로 변경하세요.
         ==> REPLACE(컬럼, 값1, 값2)
    UPDATE MEMBER SET NAME=REPLACE(NAME,'김','최')
    WHERE NAME LIKE '김%';
    
    SELECT * FROM MEMBER;
    ROLLBACK;
----------------------------------    
# UPDATE문에서 SUBQUERY
    UPDATE 테이블명 SET (컬럼명1, 컬럼명2) = (SUBQUERY ) WHERE 조건절
    
   [1] EMP2테이블에서 SCOTT의 업무와 급여가 일치하도록
		JONES의 업무와 급여를 변경하여라.

    UPDATE EMP2 SET (JOB,SAL) = (SELECT JOB,SAL FROM EMP2 WHERE ENAME='SCOTT')
    WHERE ENAME='JONES';

    SELECT * FROM EMP2 WHERE ENAME IN ('JONES','SCOTT');

    ROLLBACK;

# UPDATE 시 무결성 제약조건 에러

[2] EMP2에서 부서번호가 10번인 사원들의 부서번호를 90번으로 수정하세요

UPDATE EMP2 SET DEPTNO=90 WHERE DEPTNO=10;

-- ORA-02291: integrity constraint (SCOTT.EMP2_FK) violated - parent key not found

SELECT * FROM DEPT2;

UPDATE EMP2 SET DEPTNO=40 WHERE DEPTNO=10;

SELECT * FROM EMP2;

ROLLBACK;
---------------------------------------------------------

 #DELETE 문장-자료 삭제하기

	- 현재 저장된 컬럼의 데이터 중 필요에 의해 해당 데이터를 삭제하는 구문.
	- UPDATE문과 마찬가지로 WHERE 조건을 이용하여 원하는 데이터들만 삭제 가능
	- 모든 데이터를 삭제하려면 WHERE 구문을 빼고 사용하면 된다.

	-DELETE FROM 테이블명  WHERE 조건(컬럼)='조건값'
	-DELETE FROM 테이블명

	[실습]
	- EMP2테이블에서 사원번호가 7499인 사원의 정보를 삭제하라.
    
    DELETE FROM EMP2 WHERE EMPNO=7499;
     
    SELECT * FROM EMP2;
    
    ROLLBACK;
        
    - EMP2테이블에서 입사일자가 83년인 사원의 정보를 삭제하라.
    
    DELETE FROM EMP2 WHERE HIREDATE LIKE '83%';
    
    SELECT * FROM EMP2;
    
    ROLLBACK;
    
    DELETE FROM EMP2 WHERE TO_CHAR(HIREDATE,'YY') ='23';
---------------------------------------    
# DELETE 문에서 SUBQUERY

DELETE FROM 테이블명 WHERE 컬럼명=(SUBQUERY);

[1] EMP2테이블의 자료 중 부서명이 'SALES'인 사원의 정보를 삭제하라.

SELECT * FROM DEPT2;

    DELETE FROM EMP2 WHERE DEPTNO = ( SELECT DEPTNO FROM DEPT2 WHERE DNAME='SALES'  );

SELECT * FROM EMP2;

ROLLBACK;


[2] 상품(PRODUCTS) 테이블에 있는 상품 중 상품의 대분류가 도서인 상품을 삭제하세요.

DELETE FROM PRODUCTS 
WHERE CATEGORY_FK IN ( SELECT CATEGORY_CODE FROM CATEGORY WHERE CATEGORY_NAME LIKE '%도서%');

SELECT * FROM PRODUCTS;

SELECT * FROM CATEGORY;

ROLLBACK;

# DELETE문 사용시 무결성 제약조건 에러

[1] DEPT2 테이블에서 'SALES' 부서를 삭제하세요 ==> ERROR발생

DELETE FROM DEPT2 WHERE DNAME='SALES';

ORA-02292: integrity constraint (SCOTT.EMP2_FK) violated - child record found

SELECT * FROM EMP2 WHERE DEPTNO =(SELECT DEPTNO FROM DEPT2 WHERE DNAME='SALES');

자식테이블에서 FK를 줄때 ON DELETE CASCADE 옵션을주면 자식 레코드가 있어도
부모 레코드를 삭제할 수 있다. 이 때 자식 레코드도 같이 삭제된다.

[2] DEPT2 테이블에서 'OPERATIONS' 부서를 삭제하세요

SELECT * FROM DEPT2;
SELECT * FROM EMP2 WHERE DEPTNO=(SELECT DEPTNO FROM DEPT2 WHERE DNAME='OPERATIONS');

DELETE FROM DEPT2 WHERE DNAME='OPERATIONS';

ROLLBACK;    

# TCL (Transaction Control Language)
- commit
- rollback
- savepoint

UPDATE EMP2 SET ENAME='CHARSE', DEPTNO=30 WHERE EMPNO=7788;

SELECT * FROM EMP2;

ROLLBACK;

-- SAVEPOINT 설정
-- SAVEPOINT 저장점이름
UPDATE EMP2 SET ENAME='CHARSE', DEPTNO=30 WHERE EMPNO=7788;

SAVEPOINT POINT_1;

UPDATE EMP2 SET JOB='MANAGER';

SELECT * FROM EMP2;

ROLLBACK TO SAVEPOINT POINT_1;

SELECT * FROM EMP2;
COMMIT;
	