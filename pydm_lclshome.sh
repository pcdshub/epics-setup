#!/usr/bin/env bash

shopt -s extglob

source /reg/g/pcds/pyps/conda/dev_conda
LCLS_TOOLS=/reg/g/pcds/package/epics/lcls/tools

if [ -z "$SETUP_SITE_TOP" ]; then
	SETUP_SITE_TOP=/reg/g/pcds/setup
fi
source $SETUP_SITE_TOP/edmPath_lclsHome.sh

PYDM_DISPLAYS_PATH=$LCLS_TOOLS/pydm/display/:$PYDM_DISPLAYS_PATH PYDM_DEFAULT_PROTOCOL=ca pydm --stylesheet $LCLS_TOOLS/pydm/stylesheet/default.qss $LCLS_TOOLS/pydm/display/lcls/lclshome/lclshome.py ${@}

