USE PRACTICE;

/****************************************************************************/
/******************************SQL 활용 단원 정리*******************************/
/****************************************************************************/

/***************연산자 및 함수***************/

/* 1. CUSTOMER 테이블을 활용하여, 가입일자가 2019년이며 생일이 4~6월생인 회원수를 조회하시오.*/

SELECT  COUNT(MEM_NO) AS 회원수
  FROM  CUSTOMER
 WHERE  YEAR(JOIN_DATE) = 2019
   AND  MONTH(BIRTHDAY) BETWEEN 4 and 6;
  

/* 2. SALES 및 PRODUCT 테이블을 활용하여, 1회 주문시 평균 구매금액를 구하시오.(비회원 9999999 제외)*/

SELECT  SUM(A.SALES_QTY * B.PRICE) / COUNT(A.ORDER_NO) AS 평균구매금액
  FROM  SALES AS A
  LEFT
  JOIN  PRODUCT AS B
	ON  A.PRODUCT_CODE = B.PRODUCT_CODE
 WHERE  A.MEM_NO <> 9999999;

/* 1회 주문시 구매금액 */


    
/* 3. SALES 테이블을 활용하여, 구매수량이 높은 상위 10명을 조회하시오.(비회원 9999999 제외)*/
 
/* 회원별 구매수량 순위 */  

SELECT  *
  FROM  (
		SELECT  MEM_NO
				,RANK () OVER (ORDER BY SUM(SALES_QTY) DESC) AS 순위
		  FROM  SALES
		 WHERE  MEM_NO <> '9999999'
		 GROUP
            BY  MEM_NO
		) AS A
 WHERE  순위 < 10;

/* 회원별 구매수량 순위 + 상위 10위 이하 필터링 */  




/***************View 및 Procedure***************/

/* 1. View를 활용하여, Sales 테이블 기준으로 CUSTOMER 및 PRODUCT 테이블을 LEFT JOIN 결합한 가상 테이블을 생성하시오.*/
/* 열은 SALES 테이블의 모든 열 + CUSTOMER 테이블의 GENDER + PRODUCT 테이블의 BRAND*/

SELECT  *
  FROM  CUSTOMER;

CREATE VIEW SALES_GENDER_BRAND AS
SELECT  A.*
		,C.GENDER
        ,B.BRAND
  FROM  SALES AS A
  LEFT
  JOIN  PRODUCT AS B
    ON  A.PRODUCT_CODE = B.PRODUCT_CODE
  LEFT
  JOIN  CUSTOMER AS C
    ON  A.MEM_NO = C.MEM_NO;

/* 2. Procedure를 활용하여, CUSTOMER의 몇월부터 몇월까지의 생일인 회원을 조회하는 작업을 저장하시오.*/

CREATE PROCEDURE FIND_CUSTOMER_BIRTH(IN MONTH1 INT(8), IN MONTH2 INT(8))
SELECT  *
  FROM  (
		SELECT  *
		  FROM  CUSTOMER 
		 WHERE  MONTH(BIRTHDAY) BETWEEN MONTH1 AND MONTH2
		) AS A;
        
DELIMITER //    
CREATE PROCEDURE FIND_CUSTOMER_BIRTH(IN MONTH1 INT, IN MONTH2 INT)
BEGIN
SELECT  *
  FROM  CUSTOMER 
 WHERE  MONTH(BIRTHDAY) BETWEEN MONTH1 AND MONTH2;
END//
DELIMITER ;

/* 확인 */

CALL FIND_CUSTOMER_BIRTH(1, 6);


DROP PROCEDURE FIND_CUSTOMER_BIRTH;

/***************데이터 마트***************/

/* 1. SALES 및 PRODUCT 테이블을 활용하여, SALES 테이블 기준으로 PRODUCT 테이블을 LEFT JOIN 결합한 테이블을 생성하시오.*/
/* 열은 SALES 테이블의 모든 열 + PRODUCT 테이블의 CATEGORY, TYPE + SALES_QTY * PRICE 구매금액 */


CREATE TABLE SALES_MART AS
SELECT  A.*
		,B.CATEGORY
        ,B.TYPE
        ,A.SALES_QTY * B.PRICE AS 구매금액
  FROM  SALES AS A
  LEFT
  JOIN  PRODUCT AS B
    ON  A.PRODUCT_CODE = B.PRODUCT_CODE;

/* 확인 */
SELECT *
  FROM SALES_MART;

/* 2. (1)에서 생성한 데이터 마트를 활용하여, CATEGORY 및 TYPE별 구매금액 합계를 구하시오*/

SELECT  CATEGORY
       ,TYPE
       ,SUM(구매금액)
  FROM  SALES_MART
 GROUP
    BY  CATEGORY
        ,TYPE;
  
