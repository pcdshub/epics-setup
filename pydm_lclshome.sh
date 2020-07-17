#!/usr/bin/env bash

shopt -s extglob

source /reg/g/pcds/pyps/conda/dev_conda
LCLS_TOOLS=/reg/g/pcds/package/epics/lcls/tools

export EDMDATAFILES=
for dir in $PACKAGE_SITE_TOP/epics/lcls/tools/edm/display/!(CVS|*old*)
do
	if [ -d "$dir" ]; then
		export EDMDATAFILES=${dir}:${EDMDATAFILES}
	fi
done

export EDMDATAFILES=.:..:${EDMDATAFILES}

PYDM_DISPLAYS_PATH=$LCLS_TOOLS/pydm/display/:$PYDM_DISPLAYS_PATH PYDM_DEFAULT_PROTOCOL=ca pydm --stylesheet $LCLS_TOOLS/pydm/stylesheet/default.qss $LCLS_TOOLS/pydm/display/lcls/lclshome/lclshome.py ${@}

