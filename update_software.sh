#!/usr/bin/env sh

DATA_DIR=$HOME/data
LINE=`printf %80s | tr " " "="`
INDENT="  "

stamp() {
  OUTFILE=$DATA_DIR/$1-$2.log
  echo "\n$LINE" >> $OUTFILE
  echo "Updating $1" >> $OUTFILE
  echo `date` >> $OUTFILE
  echo "$LINE\n" >> $OUTFILE
}

stamp conda update
if conda update conda >> $DATA_DIR/conda-update.log 2>&1; then
  echo "conda updated"
  stamp anaconda update
  if conda update anaconda >> $DATA_DIR/anaconda-update.log 2>&1; then
    echo "anaconda updated"
  else
    echo "Problem updating anaconda"
  fi
else
  echo "Problem updating conda"
fi


stamp brew update
if brew update >> $DATA_DIR/brew-update.log 2>&1; then
  echo "homebrew updated"
  TO_BE_UPGRADED=`brew outdated`
  if [ ${#TO_BE_UPGRADED} -gt 0 ]; then
    echo "homebrew formula to be upgraded:"
    for item in $TO_BE_UPGRADED; do
      echo "$INDENT$item"
    done
    stamp brew upgrade
    if brew upgrade >> $DATA_DIR/brew-upgrade.log 2>&1; then
      echo "homebrew formulas upgraded"
    else
      echo "Problem upgrading homebrew formula"
    fi
  else
    echo "no homebrew formulas to upgrade"
  fi
else
  echo "Problem updating homebrew"
fi
