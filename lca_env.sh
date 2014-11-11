#!/bin/bash
# Run from psdev105 to use lcaGet() and lcaPut()
# from matlab to access PCDS EPICS PV's
source /reg/g/pcds/setup/pathmunge.sh

MATLAB_HOST=psdev105
HOSTNAME=`hostname`
if [ $HOSTNAME != $MATLAB_HOST ]; then
	echo "For EPICS PV access, run this script on $MATLAB_HOST"
fi
export LABCA_ROOT=/reg/g/pcds/package/epics/3.14/extensions/R3.14.12
ldpathmunge $LABCA_ROOT/lib/linux-x86_64
ldpathmunge $LABCA_ROOT/bin/linux-x86_64/labca
pathmunge /reg/common/package/matlab/r2013a/bin
export MATLABPATH=$LABCA_ROOT/lib/linux-x86_64:$LABCA_ROOT/bin/linux-x86_64/labca

if [ "$EPICS_BASE" == "" ]; then
	source /reg/g/pcds/setup/epicsenv-3.14.12.sh
fi

echo To launch matlab just run the command: matlab
# matlab

