#!/bin/csh

if( $#argv == 0 ) then
	echo "Specify the month to run for. 1=next month, 2=m+2 etc..."
	exit
endif

setenv ENVFILE /opt/app/aircrews/data_alerts/ACENV.su
setenv MONTH `date| cut -d ' ' -f2`
setenv FD_FILE_SUFFIX _FD_Active_Crew
setenv CC_FILE_SUFFIX _CC_Active_Crew
source $ENVFILE

sqlplus -s / <<SQL
set linesize 90;
set pagesize 1000;
SET FEEDBACK OFF VERIFY OFF MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;

spool ./320_CPT_FO.xls
@./FD/320_CPT_FO.sql $1
spool off

spool ./330_CPT_FO.xls
@./FD/330_CPT_FO.sql $1
spool off

spool ./737_CPT_FO.xls
@./FD/737_CPT_FO.sql $1
spool off

spool ./777_CPT_FO.xls
@./FD/777_CPT_FO.sql $1
spool off

spool ./SU9_CPT_FO.xls
@./FD/SU9_CPT_FO.sql $1
spool off
SQL

zip $MONTH$FD_FILE_SUFFIX.zip ./*.xls
rm *.xls

sqlplus -s / <<SQL
set linesize 90;
set pagesize 1000;
SET FEEDBACK OFF VERIFY OFF MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;

spool ./320_BCA.xls
@./CC/320_BCA.sql $1
spool off

spool ./320_EC.xls
@./CC/320_EC.sql $1
spool off

spool ./320_PA.xls
@./CC/320_PA.sql $1
spool off

spool ./737_BCA.xls
@./CC/737_BCA.sql $1
spool off

spool ./737_EC.xls
@./CC/737_EC.sql $1
spool off

spool ./737_PA.xls
@./CC/737_PA.sql $1
spool off

spool ./770_330_BCA.xls
@./CC/770_330_BCA.sql $1
spool off

spool ./770_330_GM.xls
@./CC/770_330_GM.sql $1
spool off

spool ./770_330_PA.xls
@./CC/770_330_PA.sql $1
spool off

spool ./SU9_EC.xls
@./CC/SU9_EC.sql $1
spool off

spool ./SU9_PA.xls
@./CC/SU9_PA.sql $1
spool off
SQL

zip $MONTH$CC_FILE_SUFFIX"_for_M_"$1.zip ./*.xls
rm *.xls
