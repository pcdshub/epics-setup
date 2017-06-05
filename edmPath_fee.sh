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
edmpathmunge $EDM/xray
edmpathmunge $EDM/mgnt
edmpathmunge $EDM/slc
edmpathmunge $EDM/pps
edmpathmunge $EDM/bcs
edmpathmunge $EDM/bpms
edmpathmunge $EDM/llrf
edmpathmunge $EDM/prof
edmpathmunge $EDM/laser
edmpathmunge $EDM/mc
edmpathmunge $EDM/ws
edmpathmunge $EDM/watr
edmpathmunge $EDM/temp
edmpathmunge $EDM/blm
edmpathmunge $EDM/toroid
edmpathmunge $EDM/fbck
edmpathmunge $EDM/und
edmpathmunge $EDM/cud
edmpathmunge $EDM/cf
edmpathmunge $EDM/knob
edmpathmunge $EDM/autosave
edmpathmunge $EDM/ads
edmpathmunge $EDM/camac
edmpathmunge $EDM/photon_diag
edmpathmunge $EDM/klys
edmpathmunge $EDM
edmpathmunge ..
edmpathmunge .

# For alarm handler
export ALHCONFIGFILES=$TOOLS/alh/config
export ALARMHANDLER=$ALHCONFIGFILES
export ALHLOGFILES=$TOOLS_DATA/alh/log

