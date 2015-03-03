#!/bin/csh

#Generates 3 zip files for M+1, M+2 and M+3 roster periods. Each zip contains a FD and CC XLS file with missing or expiring qualification data.

setenv ENVFILE /opt/app/aircrews/data_alerts/ACENV.su
setenv MONTH `date| cut -d ' ' -f2`
setenv FD_FILE_SUFFIX _FD_Missing_Expired.xls
setenv CC_FILE_SUFFIX _CC_Missing_Expired.xls
source $ENVFILE

sqlplus -s / <<SQL
set linesize 90;
set pagesize 1000;
SET MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;

spool ./m1_fd.xls
@m1_fd.sql
spool off

spool ./m2_fd.xls
@m2_fd.sql
spool off

spool ./m3_fd.xls
@m3_fd.sql
spool off

spool ./m1_cc.xls
@m1_cc.sql
spool off

spool ./m2_cc.xls
@m2_cc.sql
spool off

spool ./m3_cc.xls
@m3_cc.sql
spool off
SQL

if( $MONTH == 'Jan' ) then 
setenv M1 'Feb'; setenv M2 'Mar'; setenv M3 'Apr'; 
endif
if( $MONTH == 'Feb' ) then 
setenv M1 'Mar'; setenv M2 'Apr'; setenv M3 'May'; 
endif
if( $MONTH == 'Mar' ) then 
setenv M1 'Apr'; setenv M2 'May'; setenv M3 'Jun'; 
endif
if( $MONTH == 'Apr' ) then 
setenv M1 'May'; setenv M2 'Jun'; setenv M3 'Jul'; 
endif
if( $MONTH == 'May' ) then 
setenv M1 'Jun'; setenv M2 'Jul'; setenv M3 'Aug'; 
endif
if( $MONTH == 'Jun' ) then 
setenv M1 'Jul'; setenv M2 'Aug'; setenv M3 'Sep'; 
endif
if( $MONTH == 'Jul' ) then 
setenv M1 'Aug'; setenv M2 'Sep'; setenv M3 'Oct'; 
endif
if( $MONTH == 'Aug' ) then 
setenv M1 'Sep'; setenv M2 'Oct'; setenv M3 'Nov'; 
endif
if( $MONTH == 'Sep' ) then 
setenv M1 'Oct'; setenv M2 'Nov'; setenv M3 'Dec'; 
endif
if( $MONTH == 'Oct' ) then 
setenv M1 'Nov'; setenv M2 'Dec'; setenv M3 'Jan'; 
endif
if( $MONTH == 'Nov' ) then 
setenv M1 'Dec'; setenv M2 'Jan'; setenv M3 'Feb'; 
endif
if( $MONTH == 'Dec' ) then 
setenv M1 'Jan'; setenv M2 'Feb'; setenv M3 'Mar'; 
endif

mv m1_fd.xls $M1$FD_FILE_SUFFIX
mv m2_fd.xls $M2$FD_FILE_SUFFIX
mv m3_fd.xls $M3$FD_FILE_SUFFIX
mv m1_cc.xls $M1$CC_FILE_SUFFIX
mv m2_cc.xls $M2$CC_FILE_SUFFIX
mv m3_cc.xls $M3$CC_FILE_SUFFIX

zip FD_Missing_or_Expired_Quals.zip $M1$FD_FILE_SUFFIX $M2$FD_FILE_SUFFIX $M3$FD_FILE_SUFFIX
zip CC_Missing_or_Expired_Quals.zip $M1$CC_FILE_SUFFIX $M2$CC_FILE_SUFFIX $M3$CC_FILE_SUFFIX
rm  $M1$FD_FILE_SUFFIX $M2$FD_FILE_SUFFIX $M3$FD_FILE_SUFFIX $M1$CC_FILE_SUFFIX $M2$CC_FILE_SUFFIX $M3$CC_FILE_SUFFIX
