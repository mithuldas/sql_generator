#!/bin/csh

#Updates division joined date for crew who have moved out from CTN rank (become experienced) to EC or BCA rank.

setenv ENVFILE /opt/app/aircrews/data_alerts/ACENV.su
setenv MONTH `date| cut -d ' ' -f2`
source $ENVFILE

sqlplus -s / <<SQL
set linesize 90;
set pagesize 1000;
SET HEADING OFF FEEDBACK OFF PAGESIZE 0;

spool ./forward.sql
@generate_forward.sql
spool off

spool ./fallback.sql
@generate_fallback.sql
spool off
SQL

mv forward.sql forward_$MONTH.sql
mv fallback.sql fallback_$MONTH.sql

