#!/bin/sh
#
# This script sets EPICS CA environment variables for
# a working PCDS EPICS Channel Access environment.
#

export EPICS_CA_SERVER_PORT=5064
export EPICS_CA_REPEATER_PORT=5065
export EPICS_CA_MAX_ARRAY_BYTES=40000000
export EPICS_CA_AUTO_ADDR_LIST=YES
export EPICS_CA_BEACON_PERIOD=15.0
export EPICS_CA_CONN_TMO=30.0
export EPICS_CA_MAX_SEARCH_PERIOD=300

# EPICS pvAccess env variables
export EPICS_PVA_SERVER_PORT=5075
export EPICS_PVA_BROADCAST_PORT=5076
export EPICS_PVA_AUTO_ADDR_LIST=YES

if [ ! -d /reg/neh ];
then
	# Setup LCLS Channel Access environment
	source /afs/slac/g/pcds/setup/lcls-ca-env.sh
fi

# Do host based setup of EPICS_CA_ADDR_LIST
# Prevents EPICS channel access network traffic from being seen by
# the data acquisition FEZ networks.
# It only affects the hutch console machines listed below with
# network adapters on the FEZ network.
HOSTNAME=`hostname`
case $HOSTNAME in
	ioc-fee-rec* )
		EPICS_CA_AUTO_ADDR_LIST=NO
		#EPICS_CA_ADDR_LIST=172.21.36.255
		EPICS_CA_ADDR_LIST=172.21.91.255
		;;
	amo-console | amo-daq | amo-monitor | amo-control )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.37.255
		;;
	tmo-console | tmo-daq | tmo-monitor | tmo-control | tmo-hutch01 )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.135.255
		;;
	sxr-console | sxr-daq | sxr-monitor | sxr-control | sxr-elog )
		EPICS_CA_AUTO_ADDR_LIST=NO
		#EPICS_CA_ADDR_LIST=172.21.39.255
		EPICS_CA_ADDR_LIST=172.21.95.255
		;;
	rix-console | rix-daq | rix-monitor | rix-control )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.143.255
		;;
	xpp-daq | xpp-daq2 | xpp-control )
		EPICS_CA_AUTO_ADDR_LIST=NO
		#EPICS_CA_ADDR_LIST=172.21.38.255
		EPICS_CA_ADDR_LIST=172.21.87.255
		;;
	xcs-console | xcs-daq | xcs-control | ioc-xcs-misc1 )
		EPICS_CA_AUTO_ADDR_LIST=NO
		#EPICS_CA_ADDR_LIST=172.21.43.255
		EPICS_CA_ADDR_LIST=172.21.83.255
		;;
	cxi-console | cxi-daq | cxi-monitor | cxi-control )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.71.255
		;;
	mec-console | mec-daq | mec-monitor | mec-control | ioc-mec-rec01 )
		EPICS_CA_AUTO_ADDR_LIST=NO
		#EPICS_CA_ADDR_LIST=172.21.45.255
		EPICS_CA_ADDR_LIST=172.21.79.255
		;;
	mfx-console | mfx-daq | mfx-monitor | mfx-control | mfx-hutch01 )
		EPICS_CA_AUTO_ADDR_LIST=NO
		#EPICS_CA_ADDR_LIST=172.21.62.255
		EPICS_CA_ADDR_LIST=172.21.75.255
		;;
	pscaa0* | pscaesrv | pscaasrv )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=134.79.165.255
		#EPICS_CA_ADDR_LIST=172.21.32.255
		;;
esac
export EPICS_CA_AUTO_ADDR_LIST
export EPICS_CA_ADDR_LIST

# URL and firefox launcher for the PCDS Archiver Appliance Management web U/I
# Recommend firefox version 43 or newer or google-chrome version 44 or newer
export ARCHIVER_URL=http://pscaa02.slac.stanford.edu:17665/mgmt/ui/index.html
alias Archiver="firefox --no-remote $ARCHIVER_URL 2>1 > /dev/null&"
alias ArchiveManager="firefox --no-remote $ARCHIVER_URL 2>1 > /dev/null&"

# Archiver Appliance Viewer URL:
# Recommend firefox version 60 or newer or google-chrome version 44 or newer
export ARCHIVE_VIEWER_URL=https://pswww.slac.stanford.edu/archiveviewer/retrieval/ui/viewer/archViewer.html
alias ArchiveViewer="firefox --no-remote $ARCHIVE_VIEWER_URL 2>1 > /dev/null&"

