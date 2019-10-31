#-*-sh-*-
#==============================================================
#
#  Abs:  Setup EPICS CA and PVA environment variables to access
#        PVs on the development network
#
#  Name: envSet_dev.bash
#
#  Facility:  SLAC
#
#--------------------------------------------------------------
#  Mod:
#        11-Jul-2018, B. Hill (bhill)
#        Reworked envSet.bash script to simplify, also breaking out separate files envSet_prod.bash and envSet_prodOnDev.bash
# Set LCLS CA and PVA environment variables to access
# PVs from the development network
#

# Use Default PVA PORT numbers
export EPICS_PVA_SERVER_PORT=5075
export EPICS_PVA_BROADCAST_PORT=5076

# Use explicit EPICS_PVA_ADDR_LIST
export EPICS_PVA_AUTO_ADDR_LIST=FALSE
# LCLSDEV subnet
export EPICS_PVA_ADDR_LIST="134.79.219.255"
# B130-PUB1-CTRLDEV
#export EPICS_PVA_ADDR_LIST="${EPICS_PVA_ADDR_LIST} 172.26.97.63"

export EPICS_CA_AUTO_ADDR_LIST=NO
export EPICS_CA_ADDR_LIST="134.79.219.255 172.26.97.63"
export EPICS_CA_REPEATER_PORT="5067"
export EPICS_CA_SERVER_PORT="5066"

export EPICS_TS_NTP_INET="134.79.18.40"
export EPICS_IOC_LOG_INET="134.79.219.136"


