#!/bin/sh

LOG=/Users/mgalloy/data/check_speed.py.log

/Users/mgalloy/anaconda/bin/python /Users/mgalloy/bin/check_speed.py >> $LOG 2>&1
/usr/bin/scp -i ~mgalloy/.ssh/id_rsa2 ~/data/speed.json idldev.com:~/data.idldev.com/ >> $LOG 2>&1

d=`date`
user=`whoami`
echo "Performed check_speed.sh as $user at $d" >> $LOG
