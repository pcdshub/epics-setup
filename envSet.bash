#==============================================================
#
#  Abs:  Setup EPICS build environment variables
#
#  Name: envSet.sh
#
#  Facility:  SLAC
#
#  Auth: dd-mmm-yyyy, Babar Collaboration (USERNAME)
#  Rev:  dd-mmm-yyyy, Reviewer's Name     (USERNAME)
#
#--------------------------------------------------------------
#  Mod:
#        30-Oct-2007, J Zhou (jingchen) 
#        Updated to support standalone production environment.            
#        29-Mar-2007, T Lahey (lahey)
#         Add lcls-s20* nodes to list of production nodes. These
#         are located at sector 20, for commissioning.
#        27-Feb-2007, K. Luchini (LUCHINI):
#          Add lcls-ioc03 and replaced ip addresses
#          for lclsdev-65,lclsdev-78 and lclsdev-79 with nodenames
#        28-Dec-2006, K. Luchini (LUCHINI):
#          Add lclstst-01 on DMZ to EPICS_CA_ADDR_LIST 
#        15-Nov-2006, DROGIND
#          Added EPICS_CA_MAX_ARRAY_BYTES="30000"
#        6-July-2006, DROGIND;
#          Added lclsdev-17 
#        7-Apri-2006, DROGIND;
#          Added noric02 for mgnt soft ioc testing
#        27-Mar-2006, DROGIND:
#          Added slcsun1 for XL01
#        08-Mar-2006, Mike Zelazny (zelazny):
#          Added lclsdev-26
#        25-Jul-2005, S. Norum  (SNORUM):
#          changed location of EPICS_IOC_LOG_FILE_NAME
#          set EPICS_IOC_LOG_INET host to noric01
#          set EPICS_TS_NTP_INET to ns1
#        29-Mar-2003, K. Luchini  (LUCHINI):
#          Added lcls-ioc06,cdvw4 and cdvw5 to EPCIS_CA_ADDR_LIST
#        07-Feb-2005, K. Luchini  (LUCHINI):
#          Added lcls-ioc01 thru lcls-ioc05 to EPICS_CA_ADDR_LIST
#        18-Feb-2003, K. Luchini  (LUCHINI):
#          Changed EPCIS_CA_ADDR_LIST to list nodenames rather 
#          than ip addresses
#
#==============================================================
#
# Set LCLS environment based on if the system is a 
# standalone for production or public machine for development
#
if [ -d /nfs/slac/g/lcls ]; then
    if [ -z `echo $HOSTNAME | grep lcls-prod` ] && [ -z `echo $HOSTNAME | grep lcls-arch` ] && [ -z `echo $HOSTNAME | grep lcls-mcc` ] && [ -z `echo $HOSTNAME | grep lcls-s20` ];then
	export EPICS_CA_ADDR_LIST; EPICS_CA_ADDR_LIST="lcls-dev2 mccdev lclsdev-26 cdioc3 cdioc4 cdioc5 lcls-fairley lclsdev-17 lcls-ioc03 lclsdev-65 lclsdev-78 lclsdev-79"
	export EPICS_CA_REPEATER_PORT; EPICS_CA_REPEATER_PORT="5067"
	export EPICS_CA_SERVER_PORT; EPICS_CA_SERVER_PORT="5066"
	export EPICS_TS_NTP_INET; EPICS_TS_NTP_INET="134.79.16.9"
	export EPICS_IOC_LOG_INET; EPICS_IOC_LOG_INET="134.79.219.12"
    else
	export EPICS_CA_ADDR_LIST; EPICS_CA_ADDR_LIST="mcc lclstst-01"
	export EPICS_CA_REPEATER_PORT; EPICS_CA_REPEATER_PORT="5069"
	export EPICS_CA_SERVER_PORT; EPICS_CA_SERVER_PORT="5068"
	export EPICS_TS_NTP_INET; EPICS_TS_NTP_INET="134.79.48.11"
	export EPICS_IOC_LOG_INET; EPICS_IOC_LOG_INET="134.79.151.21"
    fi
elif [ -d /usr/local/lcls ]; then
	export EPICS_CA_ADDR_LIST; EPICS_CA_ADDR_LIST="mcc lclstst-01"
	export EPICS_CA_REPEATER_PORT; EPICS_CA_REPEATER_PORT="5069"
	export EPICS_CA_SERVER_PORT; EPICS_CA_SERVER_PORT="5068"
	export EPICS_TS_NTP_INET; EPICS_TS_NTP_INET="134.79.151.11"
	export EPICS_IOC_LOG_INET; EPICS_IOC_LOG_INET="134.79.151.21"   
else
   echo "ERROR: this ${HOSTNAME} is not supported for LCLS dev/prod" 
   exit 1
fi

export EPICS_CA_CONN_TMO; EPICS_CA_CONN_TMO="30.0"
export EPICS_CA_BEACON_PERIOD; EPICS_CA_BEACON_PERIOD="15.0"
export EPICS_CA_AUTO_ADDR_LIST; EPICS_CA_AUTO_ADDR_LIST="YES"
export EPICS_CAS_INTF_ADDR_LIST; EPICS_CAS_INTF_ADDR_LIST=""
export EPICS_CAS_BEACON_ADDR_LIST; EPICS_CAS_BEACON_ADDR_LIST=""
export EPICS_CAS_AUTO_ADDR_LIST; EPICS_CAS_AUTO_ADDR_LIST=""
export EPICS_CAS_SERVER_PORT; EPICS_CAS_SERVER_PORT=""
export EPICS_TS_MIN_WEST; EPICS_TS_MIN_WEST="480"
export EPICS_IOC_LOG_PORT; EPICS_IOC_LOG_PORT="7004"
export EPICS_IOC_LOG_FILE_LIMIT; EPICS_IOC_LOG_FILE_LIMIT="1000000"
export EPICS_IOC_LOG_FILE_COMMAND; EPICS_IOC_LOG_FILE_COMMAND=""
export EPICS_CMD_PROTO_PORT; EPICS_CMD_PROTO_PORT=""
export EPICS_AR_PORT; EPICS_AR_PORT="7002"
export EPICS_CA_MAX_ARRAY_BYTES="30000"
