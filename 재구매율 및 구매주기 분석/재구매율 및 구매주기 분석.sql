USE PRACTICE;

/****************************************************************************/
/****************************재구매율 및 구매주기 분석*****************************/
/****************************************************************************/

/***************재구매율 및 구매주기 분석용 데이터 마트***************/

CREATE TABLE RE_PUR_CYCLE AS
SELECT  *
		,CASE WHEN DATE_ADD(최초구매일자, INTERVAL +1 DAY) <= 최근구매일자 THEN 'Y' ELSE 'N' END AS 재구매여부
        
        ,DATEDIFF(최근구매일자, 최초구매일자) AS 구매간격
        ,CASE WHEN 구매횟수 -1 = 0 OR DATEDIFF(최근구매일자, 최초구매일자) = 0 THEN 0
              ELSE DATEDIFF(최근구매일자, 최초구매일자) / (구매횟수 -1) END AS 구매주기 
  FROM  (
		SELECT  MEM_NO
                ,MIN(ORDER_DATE) AS 최초구매일자        
				,MAX(ORDER_DATE) AS 최근구매일자
                ,COUNT(ORDER_NO) AS 구매횟수
          FROM  SALES
		 WHERE  MEM_NO <> '9999999' /* 비회원 제외 */
		 GROUP
            BY  MEM_NO
		)AS A;


/* 확인 */
SELECT  *
  FROM  RE_PUR_CYCLE;
  
/* 회원(1000021)의 구매정보 */
/* 최초구매일자: 2019-05-07 / 최근구매일자: 2019-05-21 / 구매횟수: 3 */
SELECT  *
  FROM  RE_PUR_CYCLE
 WHERE  MEM_NO = '1000021';

SELECT  *
  FROM  SALES
 WHERE  MEM_NO = '1000021';


/* 1. 재구매 회원수 비중(%) */
SELECT  COUNT(DISTINCT MEM_NO) AS 구매회원수
		,COUNT(DISTINCT CASE WHEN 재구매여부 = 'Y' THEN MEM_NO END) AS 재구매회원수
  FROM  RE_PUR_CYCLE;


/* 2. 평균 구매주기 및 구매주기 구간별 회원수 */
SELECT  AVG(구매주기)
  FROM  RE_PUR_CYCLE
 WHERE  구매주기 > 0;

SELECT  *
		,CASE WHEN 구매주기 <= 7 THEN '7일 이내'
			  WHEN 구매주기 <= 14 THEN '14일 이내'
			  WHEN 구매주기 <= 21 THEN '21일 이내'
			  WHEN 구매주기 <= 28 THEN '28일 이내'
			  ELSE '29일 이후' END AS 구매주기_구간
  FROM  RE_PUR_CYCLE
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
		  FROM  RE_PUR_CYCLE
		 WHERE  구매주기 > 0
		 )AS A
  GROUP
     BY  구매주기_구간;