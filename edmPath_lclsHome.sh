source $SETUP_SITE_TOP/pathmunge.sh

# Setup EDMDATAFILES path for LCLS Home
export EDM=$EPICS_SITE_TOP/../lcls/tools/edm/display

export EDMDATAFILES=
edmpathmunge $EDM/klys
edmpathmunge $EDM/photon_diag
edmpathmunge $EDM/camac
edmpathmunge $EDM/ads
edmpathmunge $EDM/autosave
edmpathmunge $EDM/knob
edmpathmunge $EDM/xray
edmpathmunge $EDM/cf
edmpathmunge $EDM/cud
edmpathmunge $EDM/und
edmpathmunge $EDM/fbck
edmpathmunge $EDM/misc
edmpathmunge $EDM/toroid
edmpathmunge $EDM/blm
edmpathmunge $EDM/alh
edmpathmunge $EDM/temp
edmpathmunge $EDM/watr
edmpathmunge $EDM/ws
edmpathmunge $EDM/mc
edmpathmunge $EDM/laser
edmpathmunge $EDM/prof
edmpathmunge $EDM/llrf
edmpathmunge $EDM/bpms
edmpathmunge $EDM/mps
edmpathmunge $EDM/bcs
edmpathmunge $EDM/pps
edmpathmunge $EDM/lcls
edmpathmunge $EDM/lcls2
edmpathmunge $EDM/vac
edmpathmunge $EDM/event
edmpathmunge $EDM/slc
edmpathmunge $EDM/mgnt
edmpathmunge $EDM
edmpathmunge ..
edmpathmunge .
