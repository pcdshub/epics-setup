#!/bin/sh
#
# This script sets EPICS CA environment variables for
# a working PCDS EPICS Channel Access environment.
#

setenv EPICS_CA_SERVER_PORT			5064
setenv EPICS_CA_REPEATER_PORT		5065
setenv EPICS_CA_MAX_ARRAY_BYTES		40000000
setenv EPICS_CA_AUTO_ADDR_LIST		YES
setenv EPICS_CA_BEACON_PERIOD		15.0
setenv EPICS_CA_CONN_TMO			30.0
setenv EPICS_CA_MAX_SEARCH_PERIOD	300

# Setup LCLS Channel Access environment
if ( ! -d /reg/neh ) source /afs/slac/g/pcds/setup/lcls-ca-env.csh

