#-*-sh-*-
#==============================================================
#
#  Abs:  Setup EPICS CA and PVA environment variables to access
#        production PVs from production hosts
#
#  Name: envSet_prod.bash
#
#  Facility:  SLAC
#
#--------------------------------------------------------------
#  Mod:
#    10-Oct-2019, J. Zhou (jingchen)
#   Updated EPICS_CA_ADDR_LIST to use 172.27.43.255:5068 instead of 
#    cryo-daemon1:5061
#    02-Oct-2019, J. Zhou (jingchen)
#   Updated EPICS_CA_ADDR_LIST to include cryo-daemon1:5061 for cryo subnet 
#    01-Oct-2019, M. Gibbs (mgibbs)
#   Fixed missing item in EPICS_CA_ADDR_LIST needed for LCLS-II PVs
#    10-Jul-2018, B. Hill (bhill)
#	Created new env script for accessing production PVs from production hosts
#
#==============================================================
#
# Set LCLS CA and PVA environment variables to access production PVs
#

# Use Default PVA PORT numbers
export EPICS_PVA_SERVER_PORT=5075
export EPICS_PVA_BROADCAST_PORT=5076

# Use explicit EPICS_PVA_ADDR_LIST
export EPICS_PVA_AUTO_ADDR_LIST=FALSE
# LCLSDEV subnet
export EPICS_PVA_ADDR_LIST="172.27.3.255"
# LCLS2IOC subnet
export EPICS_PVA_ADDR_LIST="${EPICS_PVA_ADDR_LIST} 172.27.131.255"
# facet-daemon1
#export EPICS_PVA_ADDR_LIST="${EPICS_PVA_ADDR_LIST} 172.27.72.24"
# CRYOSRV subnet
export EPICS_PVA_ADDR_LIST="${EPICS_PVA_ADDR_LIST} 172.27.43.255"
# Broadcast addr for PCDS MCC-EPICS/26 subnet
export EPICS_PVA_ADDR_LIST="${EPICS_PVA_ADDR_LIST} 172.21.40.63"
# Add mcc-dmz and mccas0
export EPICS_PVA_ADDR_LIST="${EPICS_PVA_ADDR_LIST} mcc-dmz mccas0.slac.stanford.edu"

export EPICS_CA_AUTO_ADDR_LIST=NO
export EPICS_CA_ADDR_LIST="172.27.3.255:5068 mcc-dmz 172.21.40.63:5064 172.27.72.24:5070 172.27.131.255:5068 172.27.43.255:5068"
export EPICS_CA_REPEATER_PORT="5069"
export EPICS_CA_SERVER_PORT="5068"
export EPICS_TS_NTP_INET="134.79.151.11"
export EPICS_IOC_LOG_INET="172.27.8.31"
export EPICS_CAS_BEACON_ADDR_LIST="172.27.11.255 mcc-dmz"  
