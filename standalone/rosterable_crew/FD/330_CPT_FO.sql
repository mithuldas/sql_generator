with roster_str as (select '01MAR15' as dt from dual),
	 min_working_days as (select '5' as non_leave_days from dual),
     roster_end as (select last_day(to_date(dt,'DDMONYY HH24MI')+86399/86400) as  end_dt from roster_str)
SELECT /* +RULE*/ DISTINCT A.STAFF_NUM as Staff_Number,
	A.PREFERRED_NAME,
	A.FIRST_NAME,
	A.SURNAME,
	B.RANK_CD,
	C.BASE,
	P.RSRC_GRP_CD
FROM CREW_RANK_V B,
	CREW_BASE_V C,
	CREW_RSRC_GRP_V P,
	CREW_V A
WHERE A.STAFF_NUM = B.STAFF_NUM
	AND A.STAFF_NUM = C.STAFF_NUM
	AND A.STAFF_NUM = P.STAFF_NUM
	AND (
		A.TERM_DT >= to_date((select dt from roster_str),'DDMONYY')
		OR A.TERM_DT IS NULL
		)
	AND (
		A.RETR_DT >= to_date((select dt from roster_str),'DDMONYY')
		OR A.RETR_DT IS NULL
		)
	AND (
		(
			to_date((select dt from roster_str),'DDMONYY') < B.EXP_DT
			OR B.EXP_DT IS NULL
			)
		AND (select end_dt from roster_end) > B.EFF_DT
		)
	AND (
		(
			to_date((select dt from roster_str),'DDMONYY') < C.EXP_DT
			OR C.EXP_DT IS NULL
			)
		AND (select end_dt from roster_end) > C.EFF_DT
		)
	AND A.STAFF_NUM IN (
		SELECT STAFF_NUM
		FROM CREW_FLEET_V
		WHERE VALID_IND = 'Y'
			AND FLEET_CD IN (
				'330'
				)
			AND (
				(
					to_date((select dt from roster_str),'DDMONYY') BETWEEN EFF_DT
						AND NVL(EXP_DT, TO_DATE('31-DEC-2999', 'DD-MON-YYYY'))
					)
				OR (
					(select end_dt from roster_end) BETWEEN EFF_DT
						AND NVL(EXP_DT, TO_DATE('31-DEC-2999', 'DD-MON-YYYY'))
					)
				)
		GROUP BY STAFF_NUM
		)
	AND B.RANK_CD IN (
		'CPT'
		)
	AND (
		(
			to_date((select dt from roster_str),'DDMONYY') < P.EXP_DT
			OR P.EXP_DT IS NULL
			)
		AND (select end_dt from roster_end) > P.EFF_DT
		)
		-- make sure that each crew has all the mandatory qualifications and expiry date is at least 05th of the month (i.e. 5 rosterable "qualification" days) and is not a STAG (ST**)    
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33EG' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33EW' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd in ('33G1','ALG1') and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33G2' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33PC' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33LC' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33VA' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd in ('ENG4','ENG5','ENG6') and NVL(q.expiry_dts,TO_DATE('31-DEC-2999','DD-MON-YYYY'))>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='INTF' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MC' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440) )
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MCH' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
	and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='PARU' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
	and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='ATPL' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
   -- make sure that crew with total days off>25 are excluded
   and a.staff_num not in(
   SELECT DISTINCT A.STAFF_NUM FROM   CREW_RANK_V B,CREW_BASE_V C , CREW_RSRC_GRP_V P,  CREW_V A, 
(select round(sum(days_off_in_period)) as total_days_off, staff_num from (select r.*, (select end_dt from roster_end)- to_date((select dt from roster_str),'DDMONYY') as days_off_in_period from roster_v r where ACT_STR_DT<to_date((select dt from roster_str),'DDMONYY') and act_end_dt>(select end_dt from roster_end) and duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and delete_ind='N'
union all
select r.*, act_end_dt-to_date((select dt from roster_str),'DDMONYY') as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT<to_date((select dt from roster_str),'DDMONYY') and act_end_dt between to_date((select dt from roster_str),'DDMONYY') and (select end_dt from roster_end) and delete_ind='N'
union all
select r.*, (select end_dt from roster_end)-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT between to_date((select dt from roster_str),'DDMONYY') and (select end_dt from roster_end) and act_end_dt> (select end_dt from roster_end) and delete_ind='N'
union all
select r.*, ACT_END_DT-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT >=to_date((select dt from roster_str),'DDMONYY') and act_end_dt<= (select end_dt from roster_end) and delete_ind='N')
group by staff_num order by total_days_off desc) day_off
WHERE A.STAFF_NUM = B.STAFF_NUM  AND A.STAFF_NUM = C.STAFF_NUM  AND A.STAFF_NUM = P.STAFF_NUM and day_off.staff_num=a.staff_num AND (A.TERM_DT >= to_date((select dt from roster_str),'DDMONYY') OR A.TERM_DT IS NULL )  AND (A.RETR_DT >= to_date((select dt from roster_str),'DDMONYY') OR A.RETR_DT IS NULL )  AND ((to_date((select dt from roster_str),'DDMONYY') < B.EXP_DT OR B.EXP_DT is NULL) AND (select end_dt from roster_end) > B.EFF_DT)  AND ((to_date((select dt from roster_str),'DDMONYY') < C.EXP_DT OR C.EXP_DT is NULL) AND (select end_dt from roster_end) > C.EFF_DT)   AND A.STAFF_NUM IN  (  SELECT STAFF_NUM FROM CREW_FLEET_V  WHERE VALID_IND = 'Y' AND  FLEET_CD IN ('320','330','767','IL9','SU9','M1F','777','737') AND  ( (to_date((select dt from roster_str),'DDMONYY') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) OR  ((select end_dt from roster_end) BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) )  GROUP BY STAFF_NUM  )  AND (C.BASE IN ('KRR','VVO','KHV','LED','SVO','OVB','CEK','OMS','SVX','IKT','KJA','KGD','BAX','EVN','MRV')  AND C.PRIM_BASE = 'Y')  AND B.RANK_CD IN ('CPT','FO','ENG','NVG','FDT','PA','GM','BCA','EC','CDT','CTN','CIN')  AND ((to_date((select dt from roster_str),'DDMONYY') < P.EXP_DT OR P.EXP_DT is NULL) AND (select end_dt from roster_end) > P.EFF_DT)
and total_days_off> to_char((select end_dt from roster_end),'DD')- (select non_leave_days from min_working_days) 
)
union
SELECT /* +RULE*/ DISTINCT A.STAFF_NUM as Staff_Number,
	A.PREFERRED_NAME,
	A.FIRST_NAME,
	A.SURNAME,
	B.RANK_CD,
	C.BASE,
	P.RSRC_GRP_CD
FROM CREW_RANK_V B,
	CREW_BASE_V C,
	CREW_RSRC_GRP_V P,
	CREW_V A
WHERE A.STAFF_NUM = B.STAFF_NUM
	AND A.STAFF_NUM = C.STAFF_NUM
	AND A.STAFF_NUM = P.STAFF_NUM
	AND (
		A.TERM_DT >= to_date((select dt from roster_str),'DDMONYY')
		OR A.TERM_DT IS NULL
		)
	AND (
		A.RETR_DT >= to_date((select dt from roster_str),'DDMONYY')
		OR A.RETR_DT IS NULL
		)
	AND (
		(
			to_date((select dt from roster_str),'DDMONYY') < B.EXP_DT
			OR B.EXP_DT IS NULL
			)
		AND (select end_dt from roster_end) > B.EFF_DT
		)
	AND (
		(
			to_date((select dt from roster_str),'DDMONYY') < C.EXP_DT
			OR C.EXP_DT IS NULL
			)
		AND (select end_dt from roster_end) > C.EFF_DT
		)
	AND A.STAFF_NUM IN (
		SELECT STAFF_NUM
		FROM CREW_FLEET_V
		WHERE VALID_IND = 'Y'
			AND FLEET_CD IN (
				'330'
				)
			AND (
				(
					to_date((select dt from roster_str),'DDMONYY') BETWEEN EFF_DT
						AND NVL(EXP_DT, TO_DATE('31-DEC-2999', 'DD-MON-YYYY'))
					)
				OR (
					(select end_dt from roster_end) BETWEEN EFF_DT
						AND NVL(EXP_DT, TO_DATE('31-DEC-2999', 'DD-MON-YYYY'))
					)
				)
		GROUP BY STAFF_NUM
		)
	AND B.RANK_CD IN (
		'FO'
		)
	AND (
		(
			to_date((select dt from roster_str),'DDMONYY') < P.EXP_DT
			OR P.EXP_DT IS NULL
			)
		AND (select end_dt from roster_end) > P.EFF_DT
		)
-- make sure that each crew has all the mandatory qualifications and expiry date is at least 05th of the month (i.e. 5 rosterable "qualification" days) and is not a STAG (ST**)    
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33EG' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33EW' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd in ('33G1','ALG1') and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33G2' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33PC' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='33LC' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd in ('ENG4','ENG5','ENG6') and NVL(q.expiry_dts,TO_DATE('31-DEC-2999','DD-MON-YYYY'))>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='INTF' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MC' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440) )
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MCH' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
	and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='PARU' and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
	and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd in ('CPL','ATPL') and q.expiry_dts>(to_date((select dt from roster_str),'DDMONYY') + 4 + 23/24 + 59/1440))
   -- make sure that crew with total days off>25 are excluded
   and a.staff_num not in(
   SELECT DISTINCT A.STAFF_NUM FROM   CREW_RANK_V B,CREW_BASE_V C , CREW_RSRC_GRP_V P,  CREW_V A, 
(select round(sum(days_off_in_period)) as total_days_off, staff_num from (select r.*, (select end_dt from roster_end)- to_date((select dt from roster_str),'DDMONYY') as days_off_in_period from roster_v r where ACT_STR_DT<to_date((select dt from roster_str),'DDMONYY') and act_end_dt>(select end_dt from roster_end) and duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and delete_ind='N'
union all
select r.*, act_end_dt-to_date((select dt from roster_str),'DDMONYY') as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT<to_date((select dt from roster_str),'DDMONYY') and act_end_dt between to_date((select dt from roster_str),'DDMONYY') and (select end_dt from roster_end) and delete_ind='N'
union all
select r.*, (select end_dt from roster_end)-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT between to_date((select dt from roster_str),'DDMONYY') and (select end_dt from roster_end) and act_end_dt> (select end_dt from roster_end) and delete_ind='N'
union all
select r.*, ACT_END_DT-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT >=to_date((select dt from roster_str),'DDMONYY') and act_end_dt<= (select end_dt from roster_end) and delete_ind='N')
group by staff_num order by total_days_off desc) day_off
WHERE A.STAFF_NUM = B.STAFF_NUM  AND A.STAFF_NUM = C.STAFF_NUM  AND A.STAFF_NUM = P.STAFF_NUM and day_off.staff_num=a.staff_num AND (A.TERM_DT >= to_date((select dt from roster_str),'DDMONYY') OR A.TERM_DT IS NULL )  AND (A.RETR_DT >= to_date((select dt from roster_str),'DDMONYY') OR A.RETR_DT IS NULL )  AND ((to_date((select dt from roster_str),'DDMONYY') < B.EXP_DT OR B.EXP_DT is NULL) AND (select end_dt from roster_end) > B.EFF_DT)  AND ((to_date((select dt from roster_str),'DDMONYY') < C.EXP_DT OR C.EXP_DT is NULL) AND (select end_dt from roster_end) > C.EFF_DT)   AND A.STAFF_NUM IN  (  SELECT STAFF_NUM FROM CREW_FLEET_V  WHERE VALID_IND = 'Y' AND  FLEET_CD IN ('320','330','767','IL9','SU9','M1F','777','737') AND  ( (to_date((select dt from roster_str),'DDMONYY') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) OR  ((select end_dt from roster_end) BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) )  GROUP BY STAFF_NUM  )  AND (C.BASE IN ('KRR','VVO','KHV','LED','SVO','OVB','CEK','OMS','SVX','IKT','KJA','KGD','BAX','EVN','MRV')  AND C.PRIM_BASE = 'Y')  AND B.RANK_CD IN ('CPT','FO','ENG','NVG','FDT','PA','GM','BCA','EC','CDT','CTN','CIN')  AND ((to_date((select dt from roster_str),'DDMONYY') < P.EXP_DT OR P.EXP_DT is NULL) AND (select end_dt from roster_end) > P.EFF_DT)
and total_days_off> to_char((select end_dt from roster_end),'DD')- (select non_leave_days from min_working_days) 
)
		order by rank_cd, Staff_Number;