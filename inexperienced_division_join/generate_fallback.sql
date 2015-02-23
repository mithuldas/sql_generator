SELECT 'update CREW_V set DIVISION_JOINED_DATE=''' || TO_CHAR(c.division_joined_date,'DDMONYY') || ''' where STAFF_NUM= ''' || c.staff_num ||''';'
FROM crew_v c, crew_rank_v r1 where c.staff_num=r1.staff_num and r1.eff_dt<>c.division_joined_date and (rank_cd='EC' AND EXISTS
  (SELECT 1 FROM crew_rank_v r2 WHERE r1.staff_num=r2.staff_num AND rank_cd='CTN') OR rank_cd='BCA' AND EXISTS
  (SELECT 1 FROM crew_rank_v r2 WHERE r1.staff_num=r2.staff_num AND rank_cd='CTN') and not exists (SELECT 1 FROM crew_rank_v r2 WHERE r1.staff_num=r2.staff_num AND rank_cd='EC'));