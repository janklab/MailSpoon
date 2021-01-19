#!env bash
#
# package_toolbox.sh - Package this project as a toolbox

uname=$(uname)

case "$uname" in
  Darwin*)
    # TODO: Detect Matlab from multiple versions
    # TODO: Allow project to specify a Matlab version
    MATLAB="/Applications/MATLAB_R2019b.app/bin/matlab"
    ;;
  *)
    MATLAB="matlab"
    ;;
esac

"$MATLAB" -batch 'batch_package_toolbox'
