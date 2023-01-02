USE PRACTICE;

/****************************************************************************/
/*******************************회원 프로파일 분석********************************/
/****************************************************************************/

/***************회원 프로파일 분석용 데이터 마트***************/
CREATE TABLE CUSTOMER_PROFILE AS
SELECT  A.*
		,DATE_FORMAT(JOIN_DATE, '%Y-%m') AS 가입년월

        ,2021 - YEAR(BIRTHDAY) + 1 AS 나이
        ,CASE WHEN 2021 - YEAR(BIRTHDAY) + 1 < 20 THEN '10대 이하'
              WHEN 2021 - YEAR(BIRTHDAY) + 1 < 30 THEN '20대'
              WHEN 2021 - YEAR(BIRTHDAY) + 1 < 40 THEN '30대'
              WHEN 2021 - YEAR(BIRTHDAY) + 1 < 50 THEN '40대'
              ELSE '50대 이상' END AS 연령대

		,CASE WHEN B.MEM_NO IS NOT NULL THEN '구매'
			  ELSE '미구매' END AS 구매여부
  FROM  CUSTOMER AS A
  LEFT
  JOIN  (
		SELECT  DISTINCT MEM_NO
          FROM  SALES
		)AS B
    ON  A.MEM_NO = B.MEM_NO;

/* 확인 */
SELECT  *
  FROM  CUSTOMER_PROFILE;

/* 1. 가입년월별 회원수 */
SELECT  가입년월
		,COUNT(MEM_NO) AS 회원수
  FROM  CUSTOMER_PROFILE
 GROUP
    BY  가입년월;

/* 2. 성별 평균 연령 / 성별 및 연령대별 회원수 */
SELECT  GENDER AS 성별
		,AVG(나이) AS 평균나이
  FROM  CUSTOMER_PROFILE
 GROUP
    BY  GENDER;

SELECT  GENDER AS 성별
		,연령대
		,COUNT(MEM_NO) AS 회원수
  FROM  CUSTOMER_PROFILE
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
  FROM  CUSTOMER_PROFILE
 GROUP
    BY  GENDER
		,연령대
        ,구매여부
 ORDER
    BY  구매여부
		,GENDER
		,연령대;
        
        
