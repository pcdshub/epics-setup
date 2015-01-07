source /reg/g/pcds/setup/pathmunge.sh

# Setup EDMDATAFILES path for fee
export EDM=/reg/g/pcds/package/epics/lcls/tools/edm/display
export TOOLS=/reg/g/pcds/package/epics/3.14-fee/tools
#export XTOD=$TOOLS/edm/display
#export EDMFILES=$TOOLS/edm/config

export EDMDATAFILES=
edmpathmunge $EDM/mps
edmpathmunge $EDM/misc
edmpathmunge $EDM/alh
edmpathmunge $EDM/lcls
edmpathmunge $EDM/vac
edmpathmunge $EDM/event
#edmpathmunge $XTOD/xtod
edmpathmunge $EDM/xray
edmpathmunge $EDM
edmpathmunge ..
edmpathmunge .

# For alarm handler
export ALHCONFIGFILES=$TOOLS/alh/config
export ALARMHANDLER=$ALHCONFIGFILES
export ALHLOGFILES=$TOOLS_DATA/alh/log

