USE PRACTICE;

/****************************************************************************/
/********************************제품 성장률 분석********************************/
/****************************************************************************/

/***************제품 성장률 분석용 데이터 마트***************/

CREATE TABLE PRODUCT_GROWTH AS
SELECT  A.MEM_NO
        ,B.CATEGORY
        ,B.BRAND
        ,A.SALES_QTY * B.PRICE AS 구매금액
        ,CASE WHEN DATE_FORMAT(ORDER_DATE, '%Y-%m') BETWEEN '2020-01' AND '2020-03' THEN '2020_1분기'
			  WHEN DATE_FORMAT(ORDER_DATE, '%Y-%m') BETWEEN '2020-04' AND '2020-06' THEN '2020_2분기'
              END AS 분기
  FROM  SALES AS A
  LEFT
  JOIN  PRODUCT AS B
    ON  A.PRODUCT_CODE = B.PRODUCT_CODE
 WHERE  DATE_FORMAT(ORDER_DATE, '%Y-%m') BETWEEN '2020-01' AND '2020-06';

/* 확인 */
SELECT  *
  FROM  PRODUCT_GROWTH;


/* 1. 카테고리별 구매금액 성장률(2020년 1분기 -> 2020년 2분기) */

SELECT  *
		,2020_2분기_구매금액 / 2020_1분기_구매금액 -1 AS 성장률
  FROM  (
		SELECT  CATEGORY
				,SUM(CASE WHEN 분기 = '2020_1분기' THEN 구매금액 END) AS 2020_1분기_구매금액
				,SUM(CASE WHEN 분기 = '2020_2분기' THEN 구매금액 END) AS 2020_2분기_구매금액
		  FROM  PRODUCT_GROWTH
		 GROUP
			BY  CATEGORY
		)AS A
 ORDER
    BY  4 DESC;

/* 2. Beauty 카테고리 중, 브랜드별 구매지표 */

SELECT  BRAND
        ,COUNT(DISTINCT MEM_NO) AS 구매자수
        ,SUM(구매금액) AS 구매금액_합계
        ,SUM(구매금액) / COUNT(DISTINCT MEM_NO) AS 인당_구매금액
  FROM  PRODUCT_GROWTH
 WHERE  CATEGORY = 'beauty'
 GROUP
    BY  BRAND
 ORDER
    BY  4 DESC;

