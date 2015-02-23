#!/bin/csh

#Generates 1 zip file. Each zip contains a list of all crew with >1 day off for that roster period, and total # of days off for for M+1, M+2 and M+3 roster periods

setenv ENVFILE /opt/app/aircrews/data_alerts/ACENV.su
setenv MONTH `date| cut -d ' ' -f2`
setenv FILE_SUFFIX _Crew_On_Leave.xls
source $ENVFILE

sqlplus -s / <<SQL
set linesize 90;
set pagesize 1000;
SET MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;

spool ./m1.xls
@m1.sql
spool off

spool ./m2.xls
@m2.sql
spool off

spool ./m3.xls
@m3.sql
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

mv m1.xls $M1$FILE_SUFFIX
mv m2.xls $M2$FILE_SUFFIX
mv m3.xls $M3$FILE_SUFFIX

zip Crew_On_Leave.zip $M1$FILE_SUFFIX $M2$FILE_SUFFIX $M3$FILE_SUFFIX

rm $M1$FILE_SUFFIX $M2$FILE_SUFFIX $M3$FILE_SUFFIX
