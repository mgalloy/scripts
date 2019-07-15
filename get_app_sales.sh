#!/bin/sh

LOG=/Users/mgalloy/data/get_app_sales.py.log
APP_DIR=$(dirname $0)

/Users/mgalloy/anaconda3/bin/python $APP_DIR/get_app_sales.py

/usr/bin/scp -i ~mgalloy/.ssh/id_rsa2 ~/data/ios-app-sales.json idldev.com:~/data.idldev.com/ >> $LOG 2>&1
