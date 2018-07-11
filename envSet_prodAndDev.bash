#-*-sh-*-
#==============================================================
#
#  Abs:  Setup EPICS CA and PVA environment variables to access
#        production PVs from the development network as well as
#        development PVs.
#
#  Name: envSet_prodAndDev.bash
#
#  Facility:  SLAC
#
#--------------------------------------------------------------
#  Mod:
#	10-Jul-2018, B. Hill (bhill)
#		Created new env script for accessing prod and dev PVs
#
#==============================================================
#
# Set LCLS CA and PVA environment variables to access
# both production PVs and development PVs
# Note: Only works from dev hosts
#
export EPICS_PVA_ADDR_LIST="mccas0.slac.stanford.edu lcls-dev1.slac.stanford.edu"
export EPICS_PVA_BROADCAST_PORT=5056
export EPICS_PVA_AUTO_ADDR_LIST=FALSE
export EPICS_CA_ADDR_LIST="134.79.219.255 172.26.97.63 lcls-prod01:5068 lcls-prod01:5063 mcc-dmz:5068"
export EPICS_CA_AUTO_ADDR_LIST=NO
export EPICS_CA_REPEATER_PORT="5067"
export EPICS_CA_SERVER_PORT="5066"
export EPICS_TS_NTP_INET="134.79.18.40"
export EPICS_IOC_LOG_INET="134.79.219.136"

