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


if [ ! -d $DATA_DIR ]; then
  echo "Creating data directory at $DATA_DIR..."
  mkdir -p $DATA_DIR
fi


CONDA_FOUND=`which conda 2> /dev/null`
if [ -n "$CONDA_FOUND" ]; then
  stamp conda update
  if yes | conda update conda >> $DATA_DIR/conda-update.log 2>&1; then
    echo "conda updated"
    stamp anaconda update
    if yes | conda update anaconda >> $DATA_DIR/anaconda-update.log 2>&1; then
      echo "anaconda updated"
    else
      echo "Problem updating anaconda"
    fi
  else
    echo "Problem updating conda"
  fi
fi


BREW_FOUND=`which brew 2> /dev/null`
if [ -n "$BREW_FOUND" ]; then
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
fi
