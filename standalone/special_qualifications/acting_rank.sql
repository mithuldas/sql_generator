with roster_str as (select '01MAR15' as dt from dual),
     roster_end as (select last_day(to_date(dt,'DDMONYY HH24MI')+86399/86400) as  end_dt from roster_str)
SELECT Q.STAFF_NUM,Q.QUAL_CD, Q.ISSUED_DTS, Q.EXPIRY_DTS, Q.FLEET_CD, Q.ACTUALS_STATUS, Q.REFERENCE, Q.ISSUING_AUTHORITY, Q.COMMENTS, Q.QUALIFICATION_LAST_NAME, Q.QUALIFICATION_FIRST_NAME, Q.PASSPORT_REFERENCE
FROM CREW_RANK_V B,
	CREW_BASE_V C,
	CREW_RSRC_GRP_V P,
	CREW_V A,
  CREW_QUALIFICATIONS_V Q
WHERE A.STAFF_NUM = B.STAFF_NUM
	AND A.STAFF_NUM = C.STAFF_NUM
	AND A.STAFF_NUM = P.STAFF_NUM
  AND A.STAFF_NUM = Q.STAFF_NUM
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
	AND (
		(
			to_date((select dt from roster_str),'DDMONYY') < P.EXP_DT
			OR P.EXP_DT IS NULL
			)
		AND (select end_dt from roster_end) > P.EFF_DT
		) and (q.expiry_dts> to_date((select dt from roster_str),'DDMONYY')  or q.expiry_dts is null)
and q.issued_dts < to_date((select dt from roster_str),'DDMONYY') and q.qual_cd IN (select qual_cd from ACTING_RANK_QUALS_V) order by qual_cd, staff_num;