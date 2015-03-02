#!/bin/csh

if( $#argv == 0 ) then
	echo "Specify the month to run for. 1=next month, 2=m+2 etc..."
	exit
endif

setenv ENVFILE /opt/app/aircrews/data_alerts/ACENV.su
setenv MONTH `date| cut -d ' ' -f2`
setenv CC_FILE_SUFFIX _CC_Eligible_Crew
source $ENVFILE

sqlplus -s / <<SQL
set linesize 90;
set pagesize 1000;
SET FEEDBACK OFF VERIFY OFF MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;

spool ./CC_320_BCA.xls
@./CC/320_BCA.sql $1
spool off

spool ./CC_320_EC.xls
@./CC/320_EC.sql $1
spool off

spool ./CC_320_PA.xls
@./CC/320_PA.sql $1
spool off

spool ./CC_330_BCA.xls
@./CC/330_BCA.sql $1
spool off

spool ./CC_330_EC.xls
@./CC/330_EC.sql $1
spool off

spool ./CC_330_GM.xls
@./CC/330_GM.sql $1
spool off

spool ./CC_330_PA.xls
@./CC/330_PA.sql $1
spool off

spool ./CC_737_BCA.xls
@./CC/737_BCA.sql $1
spool off

spool ./CC_737_EC.xls
@./CC/737_EC.sql $1
spool off

spool ./CC_737_PA.xls
@./CC/737_PA.sql $1
spool off

spool ./CC_777_BCA.xls
@./CC/777_BCA.sql $1
spool off

spool ./CC_777_EC.xls
@./CC/777_EC.sql $1
spool off

spool ./CC_777_GM.xls
@./CC/777_GM.sql $1
spool off

spool ./CC_777_PA.xls
@./CC/777_PA.sql $1
spool off

spool ./CC_SU9_EC.xls
@./CC/SU9_EC.sql $1
spool off

spool ./CC_SU9_PA.xls
@./CC/SU9_PA.sql $1
spool off

SQL

zip $MONTH$CC_FILE_SUFFIX"_for_M_"$1.zip ./CC_*.xls
rm CC_*.xls
