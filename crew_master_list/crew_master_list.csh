#!/bin/csh

#Generates a zip file containing all crew data for the current month.

setenv ENVFILE /opt/app/aircrews/data_alerts/ACENV.su
setenv MONTH `date| cut -d ' ' -f2`
setenv FILE_SUFFIX _Crew_Manager_SU_Crew_Details.xls
source $ENVFILE

sqlplus -s / <<SQL
set linesize 90;
set pagesize 1000;
SET MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;

spool ./crew_list.xls
@crew_list.sql
spool off
SQL

mv crew_list.xls $MONTH$FILE_SUFFIX

zip Crew_Manager_Crew_List.zip $MONTH$FILE_SUFFIX
rm  $MONTH$FILE_SUFFIX
