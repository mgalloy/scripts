#!/bin/sh

INPUT=$HOME/Dropbox/driving/automatictrips.csv.txt
BIN_DIR=$HOME/bin
DATA_DIR=$HOME/data
OUTPUT=$DATA_DIR/weekly-driving.csv
LOG=$DATA_DIR/driving.log
SERVER_LOC="idldev.com:~/data.idldev.com/"

$BIN_DIR/driving.py $INPUT --output $OUTPUT >> $LOG 2>&1
/usr/bin/scp -i $HOME/.ssh/id_dsa2 $OUTPUT $SERVER_LOC >> $LOG 2>&1

d=`date`
user=`whoami`
echo "Performed driving.sh as $user on $d" >> $LOG
