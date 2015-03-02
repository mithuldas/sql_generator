SELECT Q.STAFF_NUM, B.RANK_CD, Q.QUAL_CD, Q.ISSUED_DTS, Q.EXPIRY_DTS, Q.FLEET_CD, Q.ACTUALS_STATUS, Q.REFERENCE, Q.ISSUING_AUTHORITY, Q.COMMENTS, Q.QUALIFICATION_LAST_NAME, Q.QUALIFICATION_FIRST_NAME, Q.PASSPORT_REFERENCE
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
	AND (
		(
			TO_DATE(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI') < P.EXP_DT
			OR P.EXP_DT IS NULL
			)
		AND TO_DATE(to_char(trunc(last_day(add_months(sysdate,&1)),'DD'),'YYYYMMDD')||'2359', 'YYYYMMDDHH24MI') > P.EFF_DT
		) and (q.expiry_dts> to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI')  or q.expiry_dts is null)
and q.issued_dts < to_date(to_char(trunc(add_months(sysdate,&1), 'MON'),'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI') and q.qual_cd ='PARU' order by qual_cd, staff_num;