USE PRACTICE;

/****************************************************************************/
/*********************************RFM 분석************************************/
/****************************************************************************/

/***************RFM 분석용 데이터 마트***************/
CREATE TABLE RFM AS
SELECT  A.*
		,B.구매금액
        ,B.구매횟수
  FROM  CUSTOMER AS A
  LEFT
  JOIN  (
		SELECT  A.MEM_NO
				,SUM(A.SALES_QTY * B.PRICE) AS 구매금액 /* Monetary: 구매 금액 */
				,COUNT(A.ORDER_NO) AS 구매횟수 /* Frequency: 구매 빈도 */
		  FROM  SALES AS A
		  LEFT
		  JOIN  PRODUCT AS B
			ON  A.PRODUCT_CODE = B.PRODUCT_CODE
		 WHERE  YEAR(A.ORDER_DATE) = '2020' /* Recency: 최근성 */
		 GROUP
			BY  A.MEM_NO
		)AS B
    ON  A.MEM_NO = B.MEM_NO;

/* 확인 */
SELECT  *
  FROM  RFM;


/* 1. RFM 세분화별 회원수 */

SELECT  *
		,CASE WHEN 구매금액 >  5000000 THEN 'VIP'
			  WHEN 구매금액 >  1000000 OR 구매횟수 > 3 THEN '우수회원'
			  WHEN 구매금액 >        0 THEN '일반회원'
			  ELSE '잠재회원' END AS 회원세분화
  FROM  RFM;

SELECT  회원세분화
		,COUNT(MEM_NO) AS 회원수
  FROM  (
		SELECT  *
				,CASE WHEN 구매금액 >  5000000 THEN 'VIP'
					  WHEN 구매금액 >  1000000 OR 구매횟수 > 3 THEN '우수회원'
					  WHEN 구매금액 >        0 THEN '일반회원'
					  ELSE '잠재회원' END AS 회원세분화
		  FROM  RFM
		)AS A
 GROUP
    BY  회원세분화
 ORDER
    BY  회원수 ASC;


/* 2. RFM 세분화별 매출액 */

SELECT  회원세분화
		,SUM(구매금액) AS 구매금액
  FROM  (
		SELECT  *
				,CASE WHEN 구매금액 >  5000000 THEN 'VIP'
					  WHEN 구매금액 >  1000000 OR 구매횟수 > 3 THEN '우수회원'
					  WHEN 구매금액 >        0 THEN '일반회원'
					  ELSE '잠재회원' END AS 회원세분화
		  FROM  RFM
		)AS A
 GROUP
    BY  회원세분화
 ORDER
    BY  구매금액 DESC;


/* 3. RFM 세분화별 인당 구매금액 */

SELECT  회원세분화
		,SUM(구매금액) / COUNT(MEM_NO) AS 인당_구매금액
  FROM  (
		SELECT  *
				,CASE WHEN 구매금액 >  5000000 THEN 'VIP'
					  WHEN 구매금액 >  1000000 OR 구매횟수 > 3 THEN '우수회원'
					  WHEN 구매금액 >        0 THEN '일반회원'
					  ELSE '잠재회원' END AS 회원세분화
		  FROM  RFM
		)AS A
 GROUP
    BY  회원세분화
 ORDER
    BY  구매금액 DESC;    
