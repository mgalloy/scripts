#!/bin/sh

LOG_DIR=/Users/mgalloy/data
LOG=$LOG_DIR/wp.sh.log

/usr/bin/php /Users/mgalloy/bin/wp.php >> $LOG 2>&1

/usr/bin/scp -i ~mgalloy/.ssh/id_dsa2 $LOG_DIR/sitestats.csv idldev.com:~/data.idldev.com >> $LOG 2>&1

d=`date`
user=`whoami`
echo "Performed wp.sh as $user at $d" >> $LOG
