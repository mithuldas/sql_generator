#!/bin/csh

setenv ENVTP "PROD"
setenv ENVFILE "/opt/app/env/ACENV.su"
setenv MAILBOXES "Mithul.Mangaldas@sabre.com"
setenv TMPFILE "/tmp/flightinfo.tmp"
setenv DATE `date '+%d-%b-%Y'`
setenv ATTACHFILE "Flight_Info_$DATE.xls"
setenv WEEKDAY `date | awk '{split($0,a," "); print a[1]}'`

## Run query
source $ENVFILE
if( $WEEKDAY == 'Wed' ) then
    #Run Query
    sqlplus -s / <<SQL
alter session set nls_date_format = 'DD-MON-YYYY HH24MI';
set linesize 90;
set pagesize 1000;
SET MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;
spool /tmp/flightinfo.tmp
select sofl_flt_nr as Flt_nr,assigned_tail_nr as Reg,FIRST_LEG_FLT_DT as Flt_dt,asg_acf_eqp_cd as EQP,act_flt_dt as dep_dt ,act_dep_arp_cd as dep_arp, ACT_FLT_DT + BLK_TM_MIN/60/24 as arv_dt,arv_arp_cd as arv_arp
    from crewside_sofl_v where FIRST_LEG_FLT_DT in (TO_CHAR(sysdate+1, 'DD-MON-YYYY'),TO_CHAR(sysdate+2, 'DD-MON-YYYY'))
    order by act_flt_dt;
spool off;
SQL
else
    #Run Query
    sqlplus -s / <<SQL
alter session set nls_date_format = 'DD-MON-YYYY HH24MI';
set linesize 90;
set pagesize 1000;
SET MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF;
spool /tmp/flightinfo.tmp
select sofl_flt_nr as Flt_nr,assigned_tail_nr as Reg,FIRST_LEG_FLT_DT as Flt_dt,asg_acf_eqp_cd as EQP,act_flt_dt as dep_dt ,act_dep_arp_cd as dep_arp, ACT_FLT_DT + BLK_TM_MIN/60/24 as arv_dt,arv_arp_cd as arv_arp
    from crewside_sofl_v where FIRST_LEG_FLT_DT= TO_CHAR(sysdate+1, 'DD-MON-YYYY')
    order by act_flt_dt;
spool off;
SQL
endif

## Error check
if( $status <> 0 ) then
    mailx -s "AirCrews SV-"$ENVTP" Flight Information ERROR running Query" mithul.mangaldas@sabre.com <<MAIL 
There was an error running FlightInfo query for $DATE.
Please check DB connectivity and locks on database.

The AirCrews Team
MAIL
endif


## Send Mail

(printf "Please check the Flight Information attached for $WEEKDAY $DATE.\n\n Regards\n The AirCrews Team\n" ; uuencode $TMPFILE `basename $ATTACHFILE`)| mailx -s "AirCrews SV-"$ENVTP" Flight Information" $MAILBOXES
#uuencode $TMPFILE `basename $ATTACHFILE`| mailx -s "AirCrews SV-"$ENVTP" Flight Information" $MAILBOXES
#Please check the Flight Information attached for $WEEKDAY $DATE.

#Regards
#The AirCrews Team
#~< ! uuencode $TMPFILE `basename $ATTACHFILE`
#~.
#MAIL

## Error check
if( $status <> 0 ) then
    mailx -s "AirCrews SV-"$ENVTP" Flight Information ERROR sending EMail." aircrews.page@sabre.com <<MAIL 
There was an error sending FlightInfo email to customer for $DATE.
Try to run FlightInfo.csh script manually.

The AirCrews Team
MAIL
endif

rm $TMPFILE

