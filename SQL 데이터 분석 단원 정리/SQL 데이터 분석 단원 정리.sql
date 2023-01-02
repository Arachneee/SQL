USE PRACTICE;

/****************************************************************************/
/*****************************SQL 데이터 분석 단원 정리****************************/
/****************************************************************************/

/***************SQL 데이터 분석 단원 분석용 데이터 마트***************/

CREATE TABLE SQL_DATA_ANALYSIS AS
SELECT  A.*

	    /***************1. 회원 프로파일 분석용***************/		
        ,DATE_FORMAT(A.JOIN_DATE, '%Y-%m') AS 가입년월
        ,2021 - YEAR(A.BIRTHDAY) + 1 AS 나이
        ,CASE WHEN 2021 - YEAR(A.BIRTHDAY) + 1 < 20 THEN '10대 이하'
              WHEN 2021 - YEAR(A.BIRTHDAY) + 1 < 30 THEN '20대'
              WHEN 2021 - YEAR(A.BIRTHDAY) + 1 < 40 THEN '30대'
              WHEN 2021 - YEAR(A.BIRTHDAY) + 1 < 50 THEN '40대'
              ELSE '50대 이상' END AS 연령대
		,CASE WHEN C.MEM_NO IS NOT NULL THEN '구매'
			  ELSE '미구매' END AS 구매여부
		
        
        /***************2. RFM 분석용***************/
        ,B.구매금액 AS 2020_구매금액
        ,B.구매횟수 AS 2020_구매횟수
        ,CASE WHEN B.구매금액 >  5000000 THEN 'VIP'
			  WHEN B.구매금액 >  1000000 OR B.구매횟수 > 3 THEN '우수회원'
			  WHEN B.구매금액 >        0 THEN '일반회원'
			  ELSE '잠재회원' END AS 2020_회원세분화


		/***************3. 재구매율 및 구매주기 분석용***************/
		,CASE WHEN DATE_ADD(C.최초구매일자, INTERVAL +1 DAY) <= C.최근구매일자 THEN 'Y' ELSE 'N' END AS 재구매여부
        ,DATEDIFF(C.최근구매일자, C.최초구매일자) AS 구매간격
        ,CASE WHEN C.구매횟수 -1 = 0 OR DATEDIFF(C.최근구매일자, C.최초구매일자) = 0 THEN 0
              ELSE DATEDIFF(C.최근구매일자, C.최초구매일자) / (C.구매횟수 -1) END AS 구매주기 

  FROM  CUSTOMER AS A
  LEFT
  JOIN  (
		/***************1. RFM 분석용***************/
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
    ON  A.MEM_NO = B.MEM_NO
  LEFT
  JOIN  (
		/***************2. 재구매율 및 구매주기 분석용***************/
		SELECT  MEM_NO
                ,MIN(ORDER_DATE) AS 최초구매일자        
				,MAX(ORDER_DATE) AS 최근구매일자
                ,COUNT(ORDER_NO) AS 구매횟수
          FROM  SALES
		 GROUP
            BY  MEM_NO
		)AS C
    ON  A.MEM_NO = C.MEM_NO;
   
/* 확인 */
SELECT  *
  FROM  SQL_DATA_ANALYSIS;

/***************데이터 마트 정합성 체크***************/

SELECT  COUNT(DISTINCT MEM_NO)
		,COUNT(MEM_NO)
  FROM  SQL_DATA_ANALYSIS;
  

/***************회원 프로파일 분석***************/
  
/* 1. 가입년월별 회원수 */
SELECT  가입년월
		,COUNT(MEM_NO) AS 회원수
  FROM  SQL_DATA_ANALYSIS
 GROUP
    BY  가입년월;

/* 2. 성별 평균 연령 / 성별 및 연령대별 회원수 */
SELECT  GENDER AS 성별
		,AVG(나이) AS 평균나이
  FROM  SQL_DATA_ANALYSIS
 GROUP
    BY  GENDER;

SELECT  GENDER AS 성별
		,연령대
		,COUNT(MEM_NO) AS 회원수
  FROM  SQL_DATA_ANALYSIS
 GROUP
    BY  GENDER
		,연령대
 ORDER
    BY  GENDER
		,연령대;   

/* 3. 성별 및 연령대별 회원수(+구매여부) */
SELECT  GENDER AS 성별
		,연령대
		,구매여부
        ,COUNT(MEM_NO) AS 회원수
  FROM  SQL_DATA_ANALYSIS
 GROUP
    BY  GENDER
		,연령대
        ,구매여부
 ORDER
    BY  구매여부
		,GENDER
		,연령대; 
  

/***************RFM 분석***************/

/* 1. RFM 세분화별 회원수 */
SELECT  2020_회원세분화
		,COUNT(MEM_NO) AS 회원수
  FROM  SQL_DATA_ANALYSIS
 GROUP
    BY  2020_회원세분화
 ORDER
    BY  회원수 ASC;
    
/* 2. RFM 세분화별 매출액 */
SELECT  2020_회원세분화
		,SUM(2020_구매금액) AS 구매금액
  FROM  SQL_DATA_ANALYSIS
 GROUP
    BY  2020_회원세분화
 ORDER
    BY  구매금액 DESC;


/* 3. RFM 세분화별 인당 구매금액 */

SELECT  2020_회원세분화
		,SUM(2020_구매금액) / COUNT(MEM_NO) AS 인당_구매금액
  FROM  SQL_DATA_ANALYSIS
 GROUP
    BY  2020_회원세분화
 ORDER
    BY  인당_구매금액 DESC;


/***************재구매율 및 구매주기 분석***************/

/* 1. 재구매 회원수 비중(%) */
SELECT  COUNT(DISTINCT CASE WHEN 구매여부 = '구매' THEN MEM_NO END) AS 구매회원수
		,COUNT(DISTINCT CASE WHEN 재구매여부 = 'Y' THEN MEM_NO END) AS 재구매회원수
  FROM  SQL_DATA_ANALYSIS;


/* 2. 평균 구매주기 및 구매주기 구간별 회원수 */
SELECT  AVG(구매주기)
  FROM  SQL_DATA_ANALYSIS
 WHERE  구매주기 > 0;
 
SELECT  구매주기_구간
    	,COUNT(MEM_NO) AS 회원수
  FROM  (
		SELECT  *
		     	,CASE WHEN 구매주기 <= 7 THEN '7일 이내'
					  WHEN 구매주기 <= 14 THEN '14일 이내'
					  WHEN 구매주기 <= 21 THEN '21일 이내'
					  WHEN 구매주기 <= 28 THEN '28일 이내'
					  ELSE '29일 이후' END AS 구매주기_구간
		  FROM  SQL_DATA_ANALYSIS
		 WHERE  구매주기 > 0
		 )AS A
  GROUP
     BY  구매주기_구간;
     
     
/***************회원 프로파일 + RFM + 재구매율 및 구매주기 분석***************/

/* 1. RFM 세분화별 평균 나이 및 구매주기 */
SELECT  2020_회원세분화
		,AVG(나이) 평균_나이
		,AVG(CASE WHEN 구매주기 > 0 THEN 구매주기 END) AS 평균_구매주기
  FROM  SQL_DATA_ANALYSIS
 GROUP
    BY  2020_회원세분화;
  
/* 2. 연령대별 재구매 회원수 비중(%) */
SELECT  연령대
		,COUNT(DISTINCT CASE WHEN 구매여부 = '구매' THEN MEM_NO END) AS 구매회원수
        ,COUNT(DISTINCT CASE WHEN 재구매여부 = 'Y' THEN MEM_NO END) AS 재구매회원수
  FROM  SQL_DATA_ANALYSIS
 GROUP
    BY  연령대;
  
  