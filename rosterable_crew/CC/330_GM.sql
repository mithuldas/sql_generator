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
		A.TERM_DT >= TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI')
		OR A.TERM_DT IS NULL
		)
	AND (
		A.RETR_DT >= TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI')
		OR A.RETR_DT IS NULL
		)
	AND (
		(
			TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') < B.EXP_DT
			OR B.EXP_DT IS NULL
			)
		AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI') > B.EFF_DT
		)
	AND (
		(
			TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') < C.EXP_DT
			OR C.EXP_DT IS NULL
			)
		AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI') > C.EFF_DT
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
					TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') BETWEEN EFF_DT
						AND NVL(EXP_DT, TO_DATE('31-DEC-2999', 'DD-MON-YYYY'))
					)
				OR (
					TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI') BETWEEN EFF_DT
						AND NVL(EXP_DT, TO_DATE('31-DEC-2999', 'DD-MON-YYYY'))
					)
				)
		GROUP BY STAFF_NUM
		)
	AND B.RANK_CD IN (
		'GM'
		)
	AND (
		(
			TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') < P.EXP_DT
			OR P.EXP_DT IS NULL
			)
		AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI') > P.EFF_DT
		)
		-- make sure that each crew has all the mandatory qualifications and expiry date is at least 05th of the month (i.e. 5 rosterable "qualification" days) and is not a STAG (ST**)    
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='AC33' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='E33' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='K33' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MC' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MCH' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='DGS' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MKK' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='FAL' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='FCHK' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='GO' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440) )
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='PARU' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))-- make sure that crew with total days off>25 are excluded
   and a.staff_num not in(
   SELECT DISTINCT A.STAFF_NUM FROM   CREW_RANK_V B,CREW_BASE_V C , CREW_RSRC_GRP_V P,  CREW_V A, 
(select round(sum(days_off_in_period)) as total_days_off, staff_num from (select r.*, to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI')- to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') as days_off_in_period from roster_v r where ACT_STR_DT<to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and act_end_dt>to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and delete_ind='N'
union all
select r.*, act_end_dt-to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT<to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and act_end_dt between to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and delete_ind='N'
union all
select r.*, to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI')-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT between to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and act_end_dt> to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and delete_ind='N'
union all
select r.*, ACT_END_DT-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT >=to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and act_end_dt<= to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and delete_ind='N')
group by staff_num order by total_days_off desc) day_off
WHERE A.STAFF_NUM = B.STAFF_NUM  AND A.STAFF_NUM = C.STAFF_NUM  AND A.STAFF_NUM = P.STAFF_NUM and day_off.staff_num=a.staff_num AND (A.TERM_DT >= TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') OR A.TERM_DT IS NULL )  AND (A.RETR_DT >= TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') OR A.RETR_DT IS NULL )  AND ((TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') < B.EXP_DT OR B.EXP_DT is NULL) AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') > B.EFF_DT)  AND ((TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') < C.EXP_DT OR C.EXP_DT is NULL) AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') > C.EFF_DT)   AND A.STAFF_NUM IN  (  SELECT STAFF_NUM FROM CREW_FLEET_V  WHERE VALID_IND = 'Y' AND  FLEET_CD IN ('320','330','767','IL9','SU9','M1F','777','737') AND  ( (TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) OR  (TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) )  GROUP BY STAFF_NUM  )  AND (C.BASE IN ('KRR','VVO','KHV','LED','SVO','OVB','CEK','OMS','SVX','IKT','KJA','KGD','BAX','EVN','MRV')  AND C.PRIM_BASE = 'Y')  AND B.RANK_CD IN ('CPT','FO','ENG','NVG','FDT','PA','GM','BCA','EC','CDT','CTN','CIN')  AND ((TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') < P.EXP_DT OR P.EXP_DT is NULL) AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') > P.EFF_DT)
and total_days_off> to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'DD')-5 
)
union SELECT /* +RULE*/ DISTINCT A.STAFF_NUM,
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
		A.TERM_DT >= TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI')
		OR A.TERM_DT IS NULL
		)
	AND (
		A.RETR_DT >= TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI')
		OR A.RETR_DT IS NULL
		)
	AND (
		(
			TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') < B.EXP_DT
			OR B.EXP_DT IS NULL
			)
		AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI') > B.EFF_DT
		)
	AND (
		(
			TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') < C.EXP_DT
			OR C.EXP_DT IS NULL
			)
		AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI') > C.EFF_DT
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
					TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') BETWEEN EFF_DT
						AND NVL(EXP_DT, TO_DATE('31-DEC-2999', 'DD-MON-YYYY'))
					)
				OR (
					TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI') BETWEEN EFF_DT
						AND NVL(EXP_DT, TO_DATE('31-DEC-2999', 'DD-MON-YYYY'))
					)
				)
		GROUP BY STAFF_NUM
		)
	AND B.RANK_CD IN (
		'BCA',
		'EC'
		)
	AND (
		(
			TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') < P.EXP_DT
			OR P.EXP_DT IS NULL
			)
		AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI') > P.EFF_DT
		)
	AND A.STAFF_NUM IN (
		SELECT STAFF_NUM
		FROM CREW_QUALIFICATIONS_V
		WHERE QUAL_CD IN (
				'GM1'
				)
			AND (
				(EXPIRY_DTS IS NULL)
				OR EXPIRY_DTS > TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI')
				)
			AND ISSUED_DTS < TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI')
		) 
		-- make sure that each crew has all the mandatory qualifications and expiry date is at least 05th of the month (i.e. 5 rosterable "qualification" days) and is not a STAG (ST**)    
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='AC33' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='E33' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='K33' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MC' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MCH' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='DGS' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='MKK' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='FAL' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='FCHK' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='GO' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440) )
    and exists (select 1 from crew_qualifications_v q where a.staff_num=q.staff_num and qual_cd='PARU' and q.expiry_dts>(TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') + 4 + 23/24 + 59/1440))-- make sure that crew with total days off>25 are excluded
   and a.staff_num not in(
   SELECT DISTINCT A.STAFF_NUM FROM   CREW_RANK_V B,CREW_BASE_V C , CREW_RSRC_GRP_V P,  CREW_V A, 
(select round(sum(days_off_in_period)) as total_days_off, staff_num from (select r.*, to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI')- to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') as days_off_in_period from roster_v r where ACT_STR_DT<to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and act_end_dt>to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and delete_ind='N'
union all
select r.*, act_end_dt-to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT<to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and act_end_dt between to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and delete_ind='N'
union all
select r.*, to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI')-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT between to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and act_end_dt> to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and delete_ind='N'
union all
select r.*, ACT_END_DT-ACT_STR_DT as days_off_in_period from roster_v r where duty_cd in (select duty_cd from assignment_types_v where duty_type in ('L','O')) and ACT_STR_DT >=to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and act_end_dt<= to_date(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') and delete_ind='N')
group by staff_num order by total_days_off desc) day_off
WHERE A.STAFF_NUM = B.STAFF_NUM  AND A.STAFF_NUM = C.STAFF_NUM  AND A.STAFF_NUM = P.STAFF_NUM and day_off.staff_num=a.staff_num AND (A.TERM_DT >= TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') OR A.TERM_DT IS NULL )  AND (A.RETR_DT >= TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') OR A.RETR_DT IS NULL )  AND ((TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') < B.EXP_DT OR B.EXP_DT is NULL) AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') > B.EFF_DT)  AND ((TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') < C.EXP_DT OR C.EXP_DT is NULL) AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') > C.EFF_DT)   AND A.STAFF_NUM IN  (  SELECT STAFF_NUM FROM CREW_FLEET_V  WHERE VALID_IND = 'Y' AND  FLEET_CD IN ('320','330','767','IL9','SU9','M1F','777','737') AND  ( (TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) OR  (TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') BETWEEN EFF_DT AND NVL(EXP_DT,TO_DATE('31-DEC-2999','DD-MON-YYYY'))) )  GROUP BY STAFF_NUM  )  AND (C.BASE IN ('KRR','VVO','KHV','LED','SVO','OVB','CEK','OMS','SVX','IKT','KJA','KGD','BAX','EVN','MRV')  AND C.PRIM_BASE = 'Y')  AND B.RANK_CD IN ('CPT','FO','ENG','NVG','FDT','PA','GM','BCA','EC','CDT','CTN','CIN')  AND ((TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') < P.EXP_DT OR P.EXP_DT is NULL) AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359','YYYYMMDDHH24MI') > P.EFF_DT)
and total_days_off> to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'DD')-5 
)order by rank_cd, Staff_Number;