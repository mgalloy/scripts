#!/bin/sh

USAGE="Usage: $0 name1 name2 name3 ... nameN"
if [ "$#" == "0" ]; then
  echo "$USAGE"
  exit 1
fi

FILENAME=consolidated_party_list_final.txt
URL=http://www.bis.doc.gov/images/consolidated_list/$FILENAME

# only download if file is not already present
if [ ! -e "$FILENAME" ]; then
  echo "Downloading consolidated export list..."
  wget $URL -o $FILENAME.log
fi

# loop through all names, checking for each one
while (( "$#" )); do
  grep -i $1 $FILENAME
  if [ $? == 1 ]; then
    echo "'$1' not found"
  fi
  shift
done




