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

if [ -f /afs/slac/g/pcds/setup/lcls-ca-env.sh ];
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
	amo-console | amo-daq | amo-monitor | amo-control )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.37.255
		;;
	sxr-console | sxr-daq | sxr-monitor | sxr-control | sxr-elog )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.39.255
		;;
	xpp-daq | xpp-daq2 | xpp-control )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.38.255
		;;
	xcs-console | xcs-daq | xcs-control )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.43.255
		;;
	cxi-console | cxi-daq | cxi-monitor | cxi-control )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.44.255
		;;
	mec-console | mec-daq | mec-monitor | mec-control )
		EPICS_CA_AUTO_ADDR_LIST=NO
		EPICS_CA_ADDR_LIST=172.21.45.255
		;;
esac


