USE PRACTICE;

/****************************************************************************/
/************************************연산자***********************************/
/****************************************************************************/

/***************비교 연산자***************/

/* = : 같음 */
SELECT  *
  FROM  CUSTOMER
 WHERE  GENDER = 'MAN';
 
/* <> : 같지 않음 */ 
SELECT  *
  FROM  CUSTOMER
 WHERE  GENDER <> 'MAN';

/* >= : ~보다 크거나 같음 */  
SELECT  *
  FROM  CUSTOMER
 WHERE  YEAR(JOIN_DATE) >= 2020;

/* <= : ~보다 작거나 같음 */  
SELECT  *
  FROM  CUSTOMER
 WHERE  YEAR(JOIN_DATE) <= 2019;
 
/* > : ~보다 큼 */  
SELECT  *
  FROM  CUSTOMER
 WHERE  YEAR(JOIN_DATE) > 2019;
 
/* < : ~보다 작음 */  
SELECT  *
  FROM  CUSTOMER
 WHERE  YEAR(JOIN_DATE) < 2020;
 
/***************논리 연산자***************/

/* AND : 앞, 뒤 조건 모두 만족 */
SELECT  *
  FROM  CUSTOMER
 WHERE  GENDER = 'MAN'
   AND  ADDR = 'Gyeonggi';

/* NOT : 뒤에 오는 조건과 반대 */ 
SELECT  *
  FROM  CUSTOMER
 WHERE  NOT GENDER = 'MAN'
   AND  ADDR = 'Gyeonggi';

/* OR : 하나라도 만족 */    
SELECT  *
  FROM  CUSTOMER
 WHERE  GENDER = 'MAN'
    OR  ADDR = 'Gyeonggi';
    

/***************특수 연산자***************/  

/* BETWEEN a AND b : a와 b의 값 사이 */
SELECT  *
  FROM  CUSTOMER
 WHERE  YEAR(BIRTHDAY) BETWEEN 2010 AND 2011;

/* NOT BETWEEN a AND b : a와 b의 값 사이가 아님 */
SELECT  *
  FROM  CUSTOMER
 WHERE  YEAR(BIRTHDAY) NOT BETWEEN 1950 AND 2020;

/* IN (List) : 리스트 값 */ 
SELECT  *
  FROM  CUSTOMER
 WHERE  YEAR(BIRTHDAY) IN (2010,2011);
 
/* NOT IN (List) : 리스트 값이 아님 */  
SELECT  *
  FROM  CUSTOMER
 WHERE  YEAR(BIRTHDAY) NOT IN (2010, 2011);

/* LIKE ‘비교문자열’ */   
SELECT  *
  FROM  CUSTOMER
 WHERE  ADDR LIKE 'D%'; /* ~로 시작하는 */

SELECT  *
  FROM  CUSTOMER
 WHERE  ADDR LIKE '%N'; /* ~로 끝나는 */
 
SELECT  *
  FROM  CUSTOMER
 WHERE  ADDR LIKE '%EO%'; /* ~를 포함하는 */

/* NOT LIKE ‘비교문자열’ */   
SELECT  *
  FROM  CUSTOMER
 WHERE  ADDR NOT LIKE '%EO%'; /* ~를 제외하는 */ 
 
/* IS NULL : NULL */   
SELECT  *
  FROM  CUSTOMER AS A
  LEFT
  JOIN  SALES AS B
    ON  A.MEM_NO = B.MEM_NO
 WHERE  B.MEM_NO IS NULL;
 
/* 확인 */ 
SELECT  *
  FROM  SALES
 WHERE  MEM_NO = '1001736';
 
/* IS NOT NULL : NOT NULL */   
SELECT  *
  FROM  CUSTOMER AS A
  LEFT
  JOIN  SALES AS B
    ON  A.MEM_NO = B.MEM_NO
 WHERE  B.MEM_NO IS NOT NULL;
 
 
/***************산술 연산자***************/
  
SELECT  *
		,A.SALES_QTY * PRICE AS 결제금액
  FROM  SALES AS A
  LEFT
  JOIN  PRODUCT AS B
    ON  A.PRODUCT_CODE = B.PRODUCT_CODE;
    
    
 /***************집합 연산자***************/
 
CREATE TEMPORARY TABLE SALES_2019
SELECT  *
  FROM  SALES
 WHERE  YEAR(ORDER_DATE) = '2019';
 
/* 1235행 */
SELECT  *
  FROM  SALES_2019;

/* 3115행 */
SELECT  *
  FROM  SALES;

/* UNION : 2개 이상 테이블 중복된 행 제거 하여 집합(* 열 개수와 데이터 타입 일치) */
SELECT  *
  FROM  SALES_2019
UNION
SELECT  *
  FROM  SALES;

/* UNION ALL: 2개 이상 테이블 중복된 행 제거 없이 집합(* 열 개수와 데이터 타입 일치) */
SELECT 3115 + 1235;

SELECT  *
  FROM  SALES_2019
UNION ALL
SELECT  *
  FROM  SALES;
  
  
/****************************************************************************/
/********************************단일 행 함수***********************************/
/****************************************************************************/

/***************숫자형 함수***************/

/* ABS(숫자) : 절대값 반환 */
SELECT ABS(- 200); 

/* ROUND(숫자, N) : N 기준으로 반올림 값 반환 */
SELECT ROUND(2.18, 1); 

/* SQRT(숫자) : 제곱근 값 반환 */
SELECT SQRT(9);
 

/***************문자형 함수***************/

/* LOWER(문자) / UPPER(문자) : 소문자 / 대문자 반환 */
SELECT LOWER('AB');
SELECT UPPER('ab');

/* LEFT(문자, N) / RIGHT(문자, N) : 왼쪽 / 오른쪽부터 N만큼 반환 */
SELECT LEFT('AB', 1); 
SELECT RIGHT('AB', 1); 

/* LENGTH(문자) : 문자수 반환 */
SELECT LENGTH('AB');


/***************날짜형 함수***************/

/* YEAR / MONTH / DAY(날짜) : 연 / 월 / 일 반환 */
SELECT YEAR('2022-12-31');
SELECT MONTH('2022-12-31');
SELECT DAY('2022-12-31');

/* DATE_ADD(날짜, INTERVAL) : INTERVAL만큼 더한 값 반환 */
SELECT DATE_ADD('2022-12-31', INTERVAL -1 MONTH);

/* DATEDIFF(날짜a, 날짜b) : 날짜a – 날짜b 일수 반환 */
SELECT DATEDIFF('2022-12-31', '2022-12-1');


/***************형변환 함수***************/

/* DATE_FORMAT(날짜, 형식) : 날짜형식으로 변환 */
SELECT DATE_FORMAT('2022-12-31', '%m-%d-%y');
SELECT DATE_FORMAT('2022-12-31', '%M-%D-%Y');

/* CAST(형식a, 형식b) : 형식a를 형식b로 변환 */
SELECT CAST('2022-12-31 12:00:00' AS DATE);


/***************일반 함수***************/

/* IFNULL(A, B) : A가 NULL이면 B를 반환, 아니면 A 반환 */
SELECT IFNULL(NULL, 0);
SELECT IFNULL('NULL이 아님', 0);

/* 
CASE WHEN [조건1] THEN [반환1]
 	 WHEN [조건2] THEN [반환2]
     ELSE [나머지] END
: 여러 조건별로 반환값 지정
*/
SELECT  *
		,CASE WHEN GENDER = 'MAN' THEN '남성'
              ELSE '여성' END
  FROM  CUSTOMER;
  
  
/***************함수 중첩 사용***************/
  
SELECT  *
		,YEAR(JOIN_DATE) AS 가입연도
        ,LENGTH( YEAR(JOIN_DATE) ) AS 가입연도_문자수
  FROM  CUSTOMER;
  
  
/****************************************************************************/
/********************************복수 행 함수***********************************/
/****************************************************************************/
  
/***************집계 함수***************/

SELECT  COUNT(ORDER_NO) AS 구매횟수 /* 행수 */
		,COUNT(DISTINCT MEM_NO) AS 구매자수 /* 중복제거된 행수  */
        ,SUM(SALES_QTY) AS 구매수량 /* 합계 */
        ,AVG(SALES_QTY) AS 평균구매수량 /* 평균 */
        ,MAX(ORDER_DATE) AS 최근구매일자 /* 최대 */
        ,MIN(ORDER_DATE) AS 최초구매일자 /* 최소 */
  FROM  SALES;
    
/* DISTINCT: 중복제거 */   

 
/***************그룹 함수***************/

/* WITH ROLLUP : GROUP BY 열들을 오른쪽에서 왼쪽순으로 그룹 (소계, 합계)*/
SELECT  YEAR(JOIN_DATE) AS 가입연도
		,ADDR
        ,COUNT(MEM_NO) AS 회원수
  FROM  CUSTOMER
 GROUP
    BY  YEAR(JOIN_DATE)
		,ADDR
WITH ROLLUP;


/***************집계 함수 + GROUP BY***************/

SELECT  MEM_NO
        ,SUM(SALES_QTY) AS 구매수량
  FROM  SALES
 GROUP
    BY  MEM_NO;
    
/* 확인 */
SELECT  *
  FROM  SALES
 WHERE  MEM_NO = '1000970';
 
 
 
/****************************************************************************/
/********************************윈도우 함수************************************/
/****************************************************************************/
  
/***************순위 함수***************/ 
/* ROW_NUMBER: 동일한 값이라도 고유한 순위 반환 (1,2,3,4,5...) */
/* RANK: 동일한 값이면 동일한 순위 반환 (1,2,3,3,5...) */
/* DENSE_RANK: 동일한 값이면 동일한 순위 반환(+ 하나의 등수로 취급) (1,2,3,3,4...) */

SELECT  ORDER_DATE
		,ROW_NUMBER() OVER (ORDER BY ORDER_DATE ASC) AS 고유한_순위_반환
        ,RANK() 	  OVER (ORDER BY ORDER_DATE ASC) AS 동일한_순위_반환
        ,DENSE_RANK() OVER (ORDER BY ORDER_DATE ASC) AS 동일한_순위_반환_하나의등수
  FROM  SALES;

/* 순위 함수+ PARTITION BY: 그룹별 순위 */

SELECT  MEM_NO
		,ORDER_DATE
		,ROW_NUMBER() OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 고유한_순위_반환
        ,RANK() 	  OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 동일한_순위_반환
        ,DENSE_RANK() OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 동일한_순위_반환_하나의등수
  FROM  SALES;

/***************집계 함수(누적)***************/ 

SELECT  ORDER_DATE
		,SALES_QTY
        ,'-' AS 구분
        ,COUNT(ORDER_NO) OVER (ORDER BY ORDER_DATE ASC) AS 누적_구매횟수
		,SUM(SALES_QTY)  OVER (ORDER BY ORDER_DATE ASC) AS 누적_구매수량
        ,AVG(SALES_QTY)  OVER (ORDER BY ORDER_DATE ASC) AS 누적_평균구매수량
        ,MAX(SALES_QTY)  OVER (ORDER BY ORDER_DATE ASC) AS 누적_가장높은구매수량
		,MIN(SALES_QTY)  OVER (ORDER BY ORDER_DATE ASC) AS 누적_가장낮은구매수량    
  FROM  SALES;
  
/* 집계 함수(누적)+ PARTITION BY: 그룹별 집계 함수(누적) */

SELECT  MEM_NO
		,ORDER_DATE
		,SALES_QTY
        ,'-' AS 구분
        ,COUNT(ORDER_NO) OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_구매횟수        
		,SUM(SALES_QTY)  OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_구매수량
        ,AVG(SALES_QTY)  OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_평균구매수량
        ,MAX(SALES_QTY)  OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_가장높은구매수량
		,MIN(SALES_QTY)  OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_가장낮은구매수량       
  FROM  SALES;
  
  
  