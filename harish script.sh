#!/bin/ksh

#Script to cleanup and purge logs for Commercial Intelligence.

LOG_DIR=/opt/mw/tomcat/commint/instances/ciinstance/logs/
ARCH_DIR=$LOG_DIR/archieve
DT_FORMAT=`date +%d%h%Y`
TEMP_DIR=$LOG_DIR/templogs
EMAIL_BODY="The CI log files more than 45 days old are purged. Attached file contains the files purged."
EMAIL_ARCH="The CI logs files more than 15 days are cleaned up. Please check the log file for results."
DT=`date +\%Y-\%m-\%d`
ARCH_LOG=`echo Archieve.log."$DT"`

echo "Finding logs older than 15 days"
for i in `find $LOG_DIR/ -type f -name '*.log*' -mtime +15`
do
mv $i $TEMP_DIR/
done

# Compressing logs

echo "Compressing the logs ...."
cd $TEMP_DIR/
tar -cvf cilogs`date +%d%h%Y`.tar *.log*
gzip cilogs`date +%d%h%Y`.tar
mv cilogs`date +%d%h%Y`.tar.gz $ARCH_DIR/
rm *
echo "Compressed file cilogs`date +%d%h%Y`.tar.gz is created."

# Purging the logs in Archieve directory older than 45 days

cd $ARCH_DIR/
echo "Purging of logs older than 45 days"
for i in `find $ARCH_DIR/ -type f -name '*gz*' -mtime +45`
do
touch purge.txt
echo $i "\n" >> purge.txt
rm $i
echo "$i is purged"
done
if [ -f purge.txt ]
then
{
echo "Sending email.."
(echo $EMAIL_BODY "\n" "\n" $EMAIL_ARCH "\n" "\n" "Thanks" "\n" "ArchieveScript" ; uuencode purge.txt purge.txt ; uuencode $ARCH_LOG $ARCH_LOG) | mailx -s "CI logs cleanup" harish.k@sabre.com shashitej.gururaja@sabre.com chetan.jayanna@sabre.com Abdul.AzeezThiruthimmal@sabre.com Ganesan.Rajamani@sabre.com
rm purge.txt
}
else
{
echo "The log files older than 15 days have been archieved. Please check the log file."
(echo $EMAIL_ARCH "\n" "\n" "Thanks" "\n" "ArchieveScript" ; uuencode $ARCH_LOG $ARCH_LOG) | mailx -s "CI logs cleanup" harish.k@sabre.com shashitej.gururaja@sabre.com chetan.jayanna@sabre.com Abdul.AzeezThiruthimmal@sabre.com Ganesan.Rajamani@sabre.com
}
fi
