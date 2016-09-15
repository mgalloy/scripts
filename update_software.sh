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
  $ECHO_CMD "$3 $1" >> $OUTFILE
  $ECHO_CMD `date` >> $OUTFILE
  $ECHO_CMD "$LINE\n" >> $OUTFILE
}


if [ ! -d $DATA_DIR ]; then
  $ECHO_CMD "Creating data directory at $DATA_DIR..."
  mkdir -p $DATA_DIR
fi


CONDA_FOUND=`which conda 2> /dev/null`
if [ -n "$CONDA_FOUND" ]; then
  stamp conda clean Cleaning
  if conda clean -tipsy >> $DATA_DIR/conda-clean.log 2>&1; then
    $ECHO_CMD "conda cleaned"
  else
    $ECHO_CMD "problem cleaning conda"
  fi

  stamp conda update
  if conda update -yq conda >> $DATA_DIR/conda-update.log 2>&1; then
    $ECHO_CMD "conda updated"
    stamp anaconda update Updating
    if conda update -yq anaconda >> $DATA_DIR/anaconda-update.log 2>&1; then
      $ECHO_CMD "anaconda updated"
      # either use anaconda package or update --all
      # stamp conda-packages update
      # if conda update -yq --all >> $DATA_DIR/conda-packages-update.log 2>&1; then
      #   $ECHO_CMD "conda packages updated"
      # else
      #   $ECHO_CMD "problem updating conda packages"
      # fi
      conda list > $DATA_DIR/conda-list.log 2>&1
      conda list --export > $DATA_DIR/conda-list-export.log 2>&1
    else
      $ECHO_CMD "problem updating anaconda"
    fi
  else
    $ECHO_CMD "problem updating conda"
  fi
fi


BREW_FOUND=`which brew 2> /dev/null`
if [ -n "$BREW_FOUND" ]; then
  stamp brew cleanup Cleaning
  if brew cleanup -s >> $DATA_DIR/brew-update.log 2>&1; then
    $ECHO_CMD "homebrew cleaned"
  else
    $ECHO_CMD "Problem cleaning homebrew"
  fi
  stamp brew update Updating
  if brew update >> $DATA_DIR/brew-update.log 2>&1; then
    $ECHO_CMD "homebrew updated"
    TO_BE_UPGRADED=`brew outdated`
    if [ ${#TO_BE_UPGRADED} -gt 0 ]; then
      $ECHO_CMD "homebrew formula to be upgraded:"
      for item in $TO_BE_UPGRADED; do
        $ECHO_CMD "$INDENT$item"
      done
      stamp brew upgrade Upgrading
      if brew upgrade >> $DATA_DIR/brew-upgrade.log 2>&1; then
        $ECHO_CMD "homebrew formulas upgraded"
        brew leaves > $DATA_DIR/brew-leaves.log 2>&1
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
