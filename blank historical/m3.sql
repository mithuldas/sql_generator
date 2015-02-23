SELECT /* +RULE*/  DISTINCT A.STAFF_NUM as STAFF_N,  A.PREFERRED_NAME ,A.FIRST_NAME, A.SURNAME, B.RANK_CD, C.BASE ,P.RSRC_GRP_CD  FROM   CREW_RANK_V B,CREW_BASE_V C , CREW_RSRC_GRP_V P,  CREW_V A, roster_v r WHERE A.STAFF_NUM = B.STAFF_NUM  AND A.STAFF_NUM = C.STAFF_NUM  AND A.STAFF_NUM = P.STAFF_NUM  and a.staff_num=r.staff_num AND (A.TERM_DT >= TO_DATE(to_char(trunc(add_months(sysdate,-3), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') OR A.TERM_DT IS NULL )  AND (A.RETR_DT >= TO_DATE(to_char(trunc(add_months(sysdate,-3), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') OR A.RETR_DT IS NULL )  AND ((TO_DATE(to_char(trunc(add_months(sysdate,-3), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') < B.EXP_DT OR B.EXP_DT is NULL) AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,-3)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') > B.EFF_DT)  AND ((TO_DATE(to_char(trunc(add_months(sysdate,-3), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') < C.EXP_DT OR C.EXP_DT is NULL) AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,-3)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') > C.EFF_DT)   AND A.STAFF_NUM IN  (  SELECT STAFF_NUM FROM CREW_FLEET_V  WHERE VALID_IND = 'Y' AND  FLEET_CD IN ('320','330','767','IL9','SU9','M1F','777','737') AND  ( (TO_DATE(to_char(trunc(add_months(sysdate,-3), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) OR  (TO_DATE(to_char(trunc(last_day(add_months(sysdate,-3)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) )  GROUP BY STAFF_NUM  )  AND (C.BASE IN ('KRR','VVO','KHV','LED','SVO','OVB','CEK','OMS','SVX','IKT','KJA','KGD','BAX','EVN','MRV')  AND C.PRIM_BASE = 'Y')  AND B.RANK_CD IN ('CPT','FO','ENG','NVG','FDT','PA','GM','BCA','EC','CDT','CTN','CIN')  AND ((TO_DATE(to_char(trunc(add_months(sysdate,-3), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') < P.EXP_DT OR P.EXP_DT is NULL) AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,-3)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') > P.EFF_DT) and 
not exists (select 1 from roster_v r2 where r.staff_num=r2.staff_num and staff_num in (select staff_num from roster_v where act_str_dt between to_date(to_char(trunc(add_months(sysdate,-3), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and to_date('31JAN15 2359','DDMONYY HH24MI')and delete_ind='N'
union select staff_num from roster_v where act_end_dt between to_date(to_char(trunc(add_months(sysdate,-3), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and to_date(to_char(trunc(last_day(add_months(sysdate,-3)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI')and delete_ind='N'
union select staff_num from roster_v where act_str_dt<to_date(to_char(trunc(add_months(sysdate,-3), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and act_end_dt>to_date(to_char(trunc(last_day(add_months(sysdate,-3)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and delete_ind='N')) order by a.staff_num;
