source $SETUP_SITE_TOP/pathmunge.sh

# Setup EDMDATAFILES path for LCLS Maps
export EDM=$EPICS_SITE_TOP/../lcls/tools/edm/display
export EDMFONTFILE=/reg/g/pcds/epics/extensions/R3.14.12/svn_templates/edm/fonts.list

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

