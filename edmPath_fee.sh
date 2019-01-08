source $SETUP_SITE_TOP/pathmunge.sh

# Setup EDMDATAFILES path for fee
export EDM=$EPICS_SITE_TOP/../lcls/tools/edm/display
export TOOLS=$EPICS_SITE_TOP/../3.14-fee/tools
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
edmpathmunge $EDM
edmpathmunge ..
edmpathmunge .
edmpathmunge $EDM/xray

# For alarm handler
export ALHCONFIGFILES=$TOOLS/alh/config
export ALARMHANDLER=$ALHCONFIGFILES
export ALHLOGFILES=$TOOLS_DATA/alh/log

