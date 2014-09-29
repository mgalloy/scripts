#!/bin/sh

LOG=/Users/mgalloy/data/moves.py.log

/Users/mgalloy/anaconda/bin/python /Users/mgalloy/bin/moves.py
/usr/bin/scp -i ~mgalloy/.ssh/id_dsa2 ~/data/movesapp.json idldev.com:~/data.idldev.com/ >> $LOG 2>&1

d=`date`
user=`whoami`
echo "Performed movesapp.sh as $user at $d" >> $LOG
