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
				'330',
				'777'
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
				'330',
				'777'
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
		) order by rank_cd, Staff_Number;