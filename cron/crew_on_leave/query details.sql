-- days off starting before and ending after roster period
select * from roster_v where ACT_STR_DT<to_date('201502010000','YYYYMMDDHH24MI') and act_end_dt>to_date('201502282359','YYYYMMDDHH24MI') and duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and delete_ind='N';

-- days off starting before roster period and ending in roster period // portion in march=total days off- portion in march= (act_end_dt-act_str_dt)-(to_date('01MAR150000','DDMONYYHH24MI')-act_str_dt)
select r.*, ((act_end_dt-act_str_dt)-(to_date('201502010000','YYYYMMDDHH24MI')-act_str_dt)) as days_off_in_march from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT<to_date('201502010000','YYYYMMDDHH24MI') and act_end_dt between to_date('201502010000','YYYYMMDDHH24MI') and to_date('201502282359','YYYYMMDDHH24MI') and delete_ind='N' order by DAYS_OFF_IN_MARCH desc;

-- days off starting in roster period and ending outside roster period// portion in march=
select r.*, ACT_END_DT-ACT_STR_DT as total_days_off from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT between to_date('201502010000','YYYYMMDDHH24MI') and to_date('201502282359','YYYYMMDDHH24MI') and act_end_dt> to_date('201502282359','YYYYMMDDHH24MI');

--days off starting in roster period and ending in roster period//
select r.*, ACT_END_DT-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT >=to_date('201502010000','YYYYMMDDHH24MI') and act_end_dt<= to_date('201502282359','YYYYMMDDHH24MI') and delete_ind='N';

--final query
select sum(days_off_in_period), staff_num from (select r.*, to_date('201502282359','YYYYMMDDHH24MI')- to_date('201502010000','YYYYMMDDHH24MI') as days_off_in_period from roster_v r where ACT_STR_DT<to_date('201502010000','YYYYMMDDHH24MI') and act_end_dt>to_date('201502282359','YYYYMMDDHH24MI') and duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and delete_ind='N'
union all
select r.*, act_end_dt-to_date('201502010000','YYYYMMDDHH24MI') as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT<to_date('201502010000','YYYYMMDDHH24MI') and act_end_dt between to_date('201502010000','YYYYMMDDHH24MI') and to_date('201502282359','YYYYMMDDHH24MI') and delete_ind='N'
union all
select r.*, to_date('201502282359','YYYYMMDDHH24MI')-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT between to_date('201502010000','YYYYMMDDHH24MI') and to_date('201502282359','YYYYMMDDHH24MI') and act_end_dt> to_date('201502282359','YYYYMMDDHH24MI'))
group by staff_num;

-- with staff_info

SELECT /* +RULE*/  DISTINCT A.STAFF_NUM, A.PREFERRED_NAME ,A.FIRST_NAME, A.SURNAME, B.RANK_CD, C.BASE ,P.RSRC_GRP_CD, day_off.total_days_off  FROM   CREW_RANK_V B,CREW_BASE_V C , CREW_RSRC_GRP_V P,  CREW_V A, 
(select round(sum(days_off_in_period)) as total_days_off, staff_num from (select r.*, to_date('201502282359','YYYYMMDDHH24MI')- to_date('201502010000','YYYYMMDDHH24MI') as days_off_in_period from roster_v r where ACT_STR_DT<to_date('201502010000','YYYYMMDDHH24MI') and act_end_dt>to_date('201502282359','YYYYMMDDHH24MI') and duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and delete_ind='N'
union all
select r.*, act_end_dt-to_date('201502010000','YYYYMMDDHH24MI') as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT<to_date('201502010000','YYYYMMDDHH24MI') and act_end_dt between to_date('201502010000','YYYYMMDDHH24MI') and to_date('201502282359','YYYYMMDDHH24MI') and delete_ind='N'
union all
select r.*, to_date('201502282359','YYYYMMDDHH24MI')-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT between to_date('201502010000','YYYYMMDDHH24MI') and to_date('201502282359','YYYYMMDDHH24MI') and act_end_dt> to_date('201502282359','YYYYMMDDHH24MI') and delete_ind='N'
union all
select r.*, ACT_END_DT-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT >=to_date('201502010000','YYYYMMDDHH24MI') and act_end_dt<= to_date('201502282359','YYYYMMDDHH24MI') and delete_ind='N')
group by staff_num order by total_days_off desc) day_off
WHERE A.STAFF_NUM = B.STAFF_NUM  AND A.STAFF_NUM = C.STAFF_NUM  AND A.STAFF_NUM = P.STAFF_NUM and day_off.staff_num=a.staff_num AND (A.TERM_DT >= TO_DATE('201502010000','YYYYMMDDHH24MI') OR A.TERM_DT IS NULL )  AND (A.RETR_DT >= TO_DATE('201502010000','YYYYMMDDHH24MI') OR A.RETR_DT IS NULL )  AND ((TO_DATE('201502010000','YYYYMMDDHH24MI') < B.EXP_DT OR B.EXP_DT is NULL) AND TO_DATE('201502282359','YYYYMMDDHH24MI') > B.EFF_DT)  AND ((TO_DATE('201502010000','YYYYMMDDHH24MI') < C.EXP_DT OR C.EXP_DT is NULL) AND TO_DATE('201502282359','YYYYMMDDHH24MI') > C.EFF_DT)   AND A.STAFF_NUM IN  (  SELECT STAFF_NUM FROM CREW_FLEET_V  WHERE VALID_IND = 'Y' AND  FLEET_CD IN ('320','330','767','IL9','SU9','M1F','777','737') AND  ( (TO_DATE('201502010000','YYYYMMDDHH24MI') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) OR  (TO_DATE('201502282359','YYYYMMDDHH24MI') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) )  GROUP BY STAFF_NUM  )  AND (C.BASE IN ('KRR','VVO','KHV','LED','SVO','OVB','CEK','OMS','SVX','IKT','KJA','KGD','BAX','EVN','MRV')  AND C.PRIM_BASE = 'Y')  AND B.RANK_CD IN ('CPT','FO','ENG','NVG','FDT','PA','GM','BCA','EC','CDT','CTN','CIN')  AND ((TO_DATE('201502010000','YYYYMMDDHH24MI') < P.EXP_DT OR P.EXP_DT is NULL) AND TO_DATE('201502282359','YYYYMMDDHH24MI') > P.EFF_DT)
;