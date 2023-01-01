USE PRACTICE;

/****************************************************************************/
/************************************VIEW************************************/
/****************************************************************************/

/***************테이블 결합***************/
/* 주문(Sales) 테이블 기준, 상품(Product) 테이블 LEFT JOIN 결합 */

SELECT  A.*
        ,A.SALES_QTY * B.PRICE AS 결제금액
  FROM  SALES AS A
  LEFT
  JOIN  PRODUCT AS B
    ON  A.PRODUCT_CODE = B.PRODUCT_CODE;


/***************VIEW 생성***************/
    
CREATE VIEW SALES_PRODUCT AS
SELECT  A.*
        ,A.SALES_QTY * B.PRICE AS 결제금액
  FROM  SALES AS A
  LEFT
  JOIN  PRODUCT AS B
    ON  A.PRODUCT_CODE = B.PRODUCT_CODE;


/***************VIEW 실행***************/

SELECT  *
  FROM  SALES_PRODUCT;


/***************VIEW 수정***************/
  
ALTER VIEW SALES_PRODUCT AS
SELECT  A.*
        ,A.SALES_QTY * B.PRICE * 1.1 AS 결제금액_수수료포함
  FROM  SALES AS A
  LEFT
  JOIN  PRODUCT AS B
    ON  A.PRODUCT_CODE = B.PRODUCT_CODE;  
    
/* 확인 */    
SELECT  *
  FROM  SALES_PRODUCT;   
  

/***************VIEW 삭제***************/

DROP VIEW SALES_PRODUCT;
    

/***************VIEW 특징(중복되는 열 저장 안됨)***************/
       
CREATE VIEW SALES_PRODUCT AS
SELECT  *
  FROM  SALES AS A
  LEFT
  JOIN  PRODUCT AS B
    ON  A.PRODUCT_CODE = B.PRODUCT_CODE;
    
    
    
/****************************************************************************/
/********************************PROCEDURE***********************************/
/****************************************************************************/

/***************IN 매개변수***************/    

DELIMITER //
CREATE PROCEDURE CST_GEN_ADDR_IN( IN INPUT_A VARCHAR(20), INPUT_B VARCHAR(20) )
BEGIN
	SELECT  *
	  FROM  CUSTOMER
	 WHERE  GENDER = INPUT_A
	   AND  ADDR = INPUT_B;
END //
DELIMITER ;

/* DELIMITER: 여러 명령어들을 하나로 묶어줄때 사용 */

/***************PROCEDURE 실행***************/
    
CALL CST_GEN_ADDR_IN('MAN', 'SEOUL');

CALL CST_GEN_ADDR_IN('WOMEN', 'INCHEON');


/***************PROCEDURE 삭제***************/
    
DROP PROCEDURE CST_GEN_ADDR_IN;


/**************OUT 매개변수***************/    

DELIMITER //
CREATE PROCEDURE CST_GEN_ADDR_IN_CNT_MEM_OUT( IN INPUT_A VARCHAR(20), INPUT_B VARCHAR(20), OUT CNT_MEM INT )
BEGIN
	SELECT  COUNT(MEM_NO)
	  INTO  CNT_MEM
	  FROM  CUSTOMER
	 WHERE  GENDER = INPUT_A
	   AND  ADDR = INPUT_B;
END //
DELIMITER ;


/***************PROCEDURE 실행***************/
    
CALL CST_GEN_ADDR_IN_CNT_MEM_OUT('WOMEN', 'INCHEON', @CNT_MEM);
SELECT  @CNT_MEM;


/**************IN/OUT 매개변수***************/    

DELIMITER //
CREATE PROCEDURE IN_OUT_PARAMETER( INOUT COUNT INT)
BEGIN
	SET COUNT = COUNT + 10;
END //
DELIMITER ;


/***************PROCEDURE 실행***************/

SET @counter = 1;
CALL IN_OUT_PARAMETER(@counter);
SELECT  @counter;
