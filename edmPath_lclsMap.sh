source /reg/g/pcds/setup/pathmunge.sh

# Setup EDMDATAFILES path for LCLS Maps
export EDM=/reg/g/pcds/package/epics/lcls/tools/edm/display
export EDMFILES=/reg/g/pcds/package/epics/lcls/tools/edm/config

export EDMDATAFILES=
edmpathmunge $EDM/mps
edmpathmunge $EDM/misc
edmpathmunge $EDM/alh
edmpathmunge $EDM/lcls
edmpathmunge $EDM/vac
edmpathmunge $EDM/xray
edmpathmunge $EDM/event
edmpathmunge $EDM
edmpathmunge ..
edmpathmunge .

