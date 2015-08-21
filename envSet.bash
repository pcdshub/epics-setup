#-*-sh-*-
#==============================================================
#
#  Abs:  Setup EPICS build environment variables
#
#  Name: envSet.bash
#
#  Facility:  SLAC
#
#  Auth: dd-mmm-yyyy, Babar Collaboration (USERNAME)
#  Rev:  dd-mmm-yyyy, Reviewer's Name     (USERNAME)
#
#--------------------------------------------------------------
#  Mod:
#        21-Aug-0215, Greg White 
#        Added EPICS V4 MEME Servers (mccas0) talking pvAccess (EPICS_PVA).
#        07-Aug-2013, J. Zhou
#        Added 172.27.3.255:5068 to EPICS_CA_ADDR_LIST
#        Will remove 172.27.11.255:5068 after the network splitting
#        is completed.
#        01-Aug-2013, J. Zhou
#        Added EPICS_CA_AUTO_ADDR_LIST=NO on DMZ
#        28-Jun-2011, J. Rock
#        Updated EPICS_CA_ADDR_LIST to include facet gateway host
#        18-May-2011, J. Zhou
#        Updated EPICS_CA_ADDR_LIST for prod on dev 
#        07-Jan-2011, brobeck
#	 Added MCCLOGIN check for env setup
#        09-Aug-2010, J. Zhou
#        explicitly defining EPICS_CAS_BEACON_ADDR_LIST to prevent softIOCs 
#        started from command line via st.cmd from sending beacon messages 
#        to wrong port. 
#        add lcls-prod01:5061 to  EPICS_CA_ADDR_LIST temporarily to help with
#        Linac Upgrade transition. Will be taken off when the transition is 
#        done. 
#        comment out EPICS_CAS_ as defult
#        01-Apr-2010, J. Zhou
#         updated EPICS_CA_ADDR_LIST to use Photon gateway 
#        04-Aug-2009, J Zhou
#         added 172.21.40.63:5068 to access the undulator IOCs through a gateway
#        29-Jul-2009, J Zhou
#         removed lcls-daemon3 from EPICS_CA_ADDR_LIST for prod and prodondev
#         added 172.21.40.63 (Photon broadcast) to  prod 
#        25-Jun-2009, J Rock
#         added lcls-daemon3 (Photon PV gateways) to EPICS_CA_ADDR_LIST for production and lcls-prod02
#        27-Aug-2008, J Zhou
#         Changed EPICS_IOC_LOG_INET to lcls-daemon2's IP.
#        21-Apr-2008, J Zhou
#         Updated to support AFS based development environment
#        17-Jan-2008, Ron M (ronm)
#         Changed EPICS_IOC_LOG_INET to lcls-daemon1's IP.
#        30-Oct-2007, J Zhou (jingchen) 
#         Updated to support standalone production environment.            
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
if [ -d /afs/slac/g/lcls ]; then
    # setup for dev
    if [ -z `echo $HOSTNAME | grep lcls-prod` ] && [ -z `echo $HOSTNAME | grep mcclogin` ] ; then
	export EPICS_PVA_ADDR_LIST="lcls-dev1.slac.stanford.edu"
	export EPICS_PVA_BROADCAST_PORT=5056
	export EPICS_PVA_AUTO_ADDR_LIST=FALSE
	export EPICS_CA_ADDR_LIST; EPICS_CA_ADDR_LIST="134.79.219.255"
	export EPICS_CA_REPEATER_PORT; EPICS_CA_REPEATER_PORT="5067"
	export EPICS_CA_SERVER_PORT; EPICS_CA_SERVER_PORT="5066"
	export EPICS_TS_NTP_INET; EPICS_TS_NTP_INET="134.79.16.9"
	export EPICS_IOC_LOG_INET; EPICS_IOC_LOG_INET="134.79.219.12"
    # setup for prod on dev
    else
	export EPICS_PVA_ADDR_LIST="mccas0.slac.stanford.edu"
	export EPICS_PVA_BROADCAST_PORT=5056
	export EPICS_PVA_AUTO_ADDR_LIST=FALSE
	export EPICS_CA_AUTO_ADDR_LIST=NO
	export EPICS_CA_ADDR_LIST; EPICS_CA_ADDR_LIST="lcls-prod01:5068 lcls-prod01:5063 mcc-dmz"
	export EPICS_CA_REPEATER_PORT; EPICS_CA_REPEATER_PORT="5069"
	export EPICS_CA_SERVER_PORT; EPICS_CA_SERVER_PORT="5068"
	export EPICS_TS_NTP_INET; EPICS_TS_NTP_INET="134.79.48.11"
	export EPICS_IOC_LOG_INET; EPICS_IOC_LOG_INET="134.79.151.21"
    fi
elif [ -d /usr/local/lcls ]; then
	export EPICS_PVA_ADDR_LIST="mccas0.slac.stanford.edu"
	export EPICS_PVA_BROADCAST_PORT=5056
	export EPICS_PVA_AUTO_ADDR_LIST=FALSE
	export EPICS_CA_AUTO_ADDR_LIST=NO
	export EPICS_CA_ADDR_LIST; EPICS_CA_ADDR_LIST="172.27.3.255:5068 mcc-dmz 172.21.40.63:5064 134.79.151.21:5061 172.27.72.24:5070"
	export EPICS_CA_REPEATER_PORT; EPICS_CA_REPEATER_PORT="5069"
	export EPICS_CA_SERVER_PORT; EPICS_CA_SERVER_PORT="5068"
	export EPICS_TS_NTP_INET; EPICS_TS_NTP_INET="134.79.151.11"
	export EPICS_IOC_LOG_INET; EPICS_IOC_LOG_INET="172.27.8.31"
        export EPICS_CAS_BEACON_ADDR_LIST; EPICS_CAS_BEACON_ADDR_LIST="172.27.11.255 mcc-dmz"  
else
   echo "ERROR: this ${HOSTNAME} is not supported for LCLS dev/prod" 
   exit 1
fi

export EPICS_CA_CONN_TMO; EPICS_CA_CONN_TMO="30.0"
export EPICS_CA_BEACON_PERIOD; EPICS_CA_BEACON_PERIOD="15.0"
#export EPICS_CAS_INTF_ADDR_LIST; EPICS_CAS_INTF_ADDR_LIST=""
#export EPICS_CAS_BEACON_ADDR_LIST; EPICS_CAS_BEACON_ADDR_LIST=""
#export EPICS_CAS_AUTO_ADDR_LIST; EPICS_CAS_AUTO_ADDR_LIST=""
#export EPICS_CAS_SERVER_PORT; EPICS_CAS_SERVER_PORT=""
export EPICS_TS_MIN_WEST; EPICS_TS_MIN_WEST="480"
export EPICS_IOC_LOG_PORT; EPICS_IOC_LOG_PORT="7004"
export EPICS_IOC_LOG_FILE_LIMIT; EPICS_IOC_LOG_FILE_LIMIT="1000000"
export EPICS_IOC_LOG_FILE_COMMAND; EPICS_IOC_LOG_FILE_COMMAND=""
export EPICS_CMD_PROTO_PORT; EPICS_CMD_PROTO_PORT=""
export EPICS_AR_PORT; EPICS_AR_PORT="7002"
export EPICS_CA_MAX_ARRAY_BYTES="80000000"
