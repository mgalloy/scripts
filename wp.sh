#!/bin/sh

LOG_DIR=/Users/mgalloy/data
LOG=$LOG_DIR/wp.sh.log
PYTHON=/Users/mgalloy/anaconda3/bin/python

$PYTHON /Users/mgalloy/bin/wp.py --data_dir $LOG_DIR >> $LOG 2>&1

/usr/bin/scp -i ~mgalloy/.ssh/id_rsa2 $LOG_DIR/sitestats.json idldev.com:~/data.idldev.com >> $LOG 2>&1

d=`date`
user=`whoami`
echo "Performed wp.sh as $user at $d" >> $LOG
