#!/bin/csh

if( $#argv == 0 ) then
	echo "Specify the month to run for. 1=next month, 2=m+2 etc..."
	exit
endif

setenv ENVFILE /opt/app/aircrews/data_alerts/ACENV.su
setenv MONTH `date| cut -d ' ' -f2`
setenv FD_FILE_SUFFIX _FD_Eligible_Crew
source $ENVFILE

sqlplus -s / <<SQL
set linesize 90;
set pagesize 1000;
SET FEEDBACK OFF VERIFY OFF MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;

spool ./FD_320_CPT_FO.xls
@./FD/320_CPT_FO.sql $1
spool off

spool ./FD_330_CPT_FO.xls
@./FD/330_CPT_FO.sql $1
spool off

spool ./FD_737_CPT_FO.xls
@./FD/737_CPT_FO.sql $1
spool off

spool ./FD_777_CPT_FO.xls
@./FD/777_CPT_FO.sql $1
spool off

spool ./FD_SU9_CPT_FO.xls
@./FD/SU9_CPT_FO.sql $1
spool off
SQL

zip $MONTH$FD_FILE_SUFFIX"_for_M_"$1.zip ./FD_*.xls
rm FD_*.xls
