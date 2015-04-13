#!/usr/bin/env sh

DATA_DIR=$HOME/data
LINE=`printf %80s | tr " " "="`
INDENT="  "
case `uname` in
  Linux)
    ECHO_CMD="echo -e"
    ;;
  Darwin)
    ECHO_CMD="echo"
    ;;
esac

stamp() {
  OUTFILE=$DATA_DIR/$1-$2.log
  $ECHO_CMD "\n$LINE" >> $OUTFILE
  $ECHO_CMD "Updating $1" >> $OUTFILE
  $ECHO_CMD `date` >> $OUTFILE
  $ECHO_CMD "$LINE\n" >> $OUTFILE
}


if [ ! -d $DATA_DIR ]; then
  $ECHO_CMD "Creating data directory at $DATA_DIR..."
  mkdir -p $DATA_DIR
fi


CONDA_FOUND=`which conda 2> /dev/null`
if [ -n "$CONDA_FOUND" ]; then
  stamp conda update
  if yes | conda update conda >> $DATA_DIR/conda-update.log 2>&1; then
    $ECHO_CMD "conda updated"
    stamp anaconda update
    if yes | conda update anaconda >> $DATA_DIR/anaconda-update.log 2>&1; then
      $ECHO_CMD "anaconda updated"
      conda list > $DATA_DIR/conda-list.log 2>&1
    else
      $ECHO_CMD "Problem updating anaconda"
    fi
  else
    $ECHO_CMD "Problem updating conda"
  fi
fi


BREW_FOUND=`which brew 2> /dev/null`
if [ -n "$BREW_FOUND" ]; then
  stamp brew update
  if brew update >> $DATA_DIR/brew-update.log 2>&1; then
    $ECHO_CMD "homebrew updated"
    TO_BE_UPGRADED=`brew outdated`
    if [ ${#TO_BE_UPGRADED} -gt 0 ]; then
      $ECHO_CMD "homebrew formula to be upgraded:"
      for item in $TO_BE_UPGRADED; do
        $ECHO_CMD "$INDENT$item"
      done
      stamp brew upgrade
      if brew upgrade >> $DATA_DIR/brew-upgrade.log 2>&1; then
        $ECHO_CMD "homebrew formulas upgraded"
      else
        $ECHO_CMD "Problem upgrading homebrew formula"
      fi
    else
      $ECHO_CMD "no homebrew formulas to upgrade"
    fi
  else
    $ECHO_CMD "Problem updating homebrew"
  fi
fi
