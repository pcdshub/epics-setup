#==============================================================
#
#  Abs:  Set up AFS based EPICS environment for Test Facilities
#
#  Name: envSet_acctest.bash
#
#  Facility: Test Facilities 
#
#  Auth: dd-mmm-yyyy, J. Zhou       (USERNAME)
#--------------------------------------------------------------
#  Mod:
#        01-Nov-2011, J. Zhou
#        Updated for Test Facilities
#        19-Mar-2012, J. Zhou
#        Commented out host check
#==============================================================
ACCTEST_ROOT=/afs/slac/g/acctest
if [ ! -d $ACCTEST_ROOT ]; then
	echo "ERROR: $ACCTEST_ROOT not available"
	exit 1	
fi
#if [ -z `echo $HOSTNAME | grep testfac-` ]; then
#        echo "ERROR: $HOSTNAME is not supported for Test Facilities" 
#        exit 1	 
#fi
# set up Channel Access
export EPICS_CA_AUTO_ADDR_LIST=NO
export EPICS_CA_ADDR_LIST="172.27.99.255"
export EPICS_CA_REPEATER_PORT="5059"
export EPICS_CA_SERVER_PORT="5058"
export EPICS_CA_MAX_ARRAY_BYTES="80000000"
export EPICS_CA_CONN_TMO="30.0"
export EPICS_CA_BEACON_PERIOD="15.0"
export EPICS_TS_MIN_WEST="480"
export EPICS_CAS_BEACON_ADDR_LIST="172.27.99.255" 
#
export EPICS_TS_NTP_INET="134.79.18.40"
export EPICS_IOC_LOG_INET="172.27.99.14"
export EPICS_IOC_LOG_PORT="7004"
export EPICS_IOC_LOG_FILE_LIMIT="1000000"
export EPICS_IOC_LOG_FILE_COMMAND=""
export EPICS_CMD_PROTO_PORT=""
export EPICS_AR_PORT="7002"

