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

# URL and firefox launcher for the PCDS Archiver Appliance Management web U/I
# Recommend firefox version 43 or newer or google-chrome version 44 or newer
setenv ARCHIVER_URL http://pscaa02.slac.stanford.edu:17665/mgmt/ui/index.html
alias Archiver "firefox --no-remote $ARCHIVER_URL 2>1 > /dev/null&"
alias ArchiveManager "firefox  --no-remote $ARCHIVER_URL 2>1 > /dev/null&"

# Archiver Appliance Viewer URL:
# Recommend firefox version 60 or newer or google-chrome version 44 or newer
setenv ARCHIVE_VIEWER_URL https://pswww.slac.stanford.edu/archiveviewer/retrieval/ui/viewer/archViewer.html
alias ArchiveViewer "firefox  --no-remote $ARCHIVE_VIEWER_URL 2>1 > /dev/null&"

