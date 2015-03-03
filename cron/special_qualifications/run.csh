#!/bin/csh

if( $#argv == 0 ) then
	echo "Specify the month to run for. 1=next month, 2=m+2 etc..."
	exit
endif

setenv ENVFILE /opt/app/aircrews/data_alerts/ACENV.su
setenv MONTH `date| cut -d ' ' -f2`
setenv FILE_SUFFIX Special_Quals
source $ENVFILE

sqlplus -s / <<SQL
set linesize 90;
set pagesize 1000;
SET FEEDBACK OFF VERIFY OFF MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;

spool ./acting_rank.xls
@acting_rank.sql $1
spool off

spool ./language_quals.xls
@language_quals.sql $1
spool off

spool ./nkz_punishment.xls
@nkz_punishment.sql $1
spool off

spool ./passport.xls
@passport.sql $1
spool off

spool ./visa_has_passport.xls
@visa_has_passport.sql $1
spool off

spool ./div4.xls
@div4.sql $1
spool off

spool ./yel.xls
@yel.sql $1
spool off

spool ./st_stag.xls
@st_stag.sql $1
spool off
SQL

zip $MONTH"_"$FILE_SUFFIX.zip ./*.xls
rm *.xls
