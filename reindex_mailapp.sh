#!/bin/sh

# check to see if Mail.app is running already...

n_mailapp_processes=`ps x | grep -v grep | grep -c "Mail.app"`

if [ "$n_mailapp_processes" -eq "1" ]; then
  echo "Quit Mail.app first"
else
  rm -f ~/Library/Mail/V2/MailData/Envelope\ Index
  echo "Deleted Envelope Index, restart Mail.app to reindex"
fi
