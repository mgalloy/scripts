#!/bin/sh

# maximum age in days before needing to redownload
MAX_AGE=1
DATA_DIR=$HOME/data/export

USAGE="Usage: $0 name1 name2 name3 ... nameN"
if [ "$#" == "0" ]; then
  echo "$USAGE"
  exit 1
fi

# specify list name and URL to retrieve it
FILENAME=$DATA_DIR/consolidated_list.csv
URL=http://www.bis.doc.gov/images/consolidated_list/consolidated_party_list_final.csv
WGET_CMD="wget --no-use-server-timestamps $URL -o $FILENAME.log -O $FILENAME"

# create data directory if it does not exist already
if [ ! -d $DATA_DIR ]; then
  mkdir -p $DATA_DIR
fi

# only download if file is not already present or too old
if [ -e "$FILENAME" ]; then
  # used to determine age of any existing lists
  NOW=`date +%s`
  OLD=`/usr/bin/stat -f "%m" $FILENAME`
  ((AGE=($NOW - $OLD)/60/60/24))

  if ((AGE > $MAX_AGE)); then
    echo "Export list too old ($AGE days > $MAX_AGE days), redownloading..."
    rm $FILENAME
    $WGET_CMD
  fi
else
  echo "Downloading consolidated export list..."
  $WGET_CMD
fi

# loop through all names, checking for each one
while (( "$#" )); do
  grep --color=always -i $1 $FILENAME
  if [ $? == 1 ]; then
    echo "'$1' not found"
  fi
  shift
done

