#! /bin/bash -f
#
# This is the calling script for moduleBuilder.pl
# It runs moduleBuilder.pl, appending all stdout and stderr to
# the logfile
#
# parameters are:
#  1. logfile name (e.g. ./moduleBuilder.log)
# The rest of the parameters are passed straight into moduleBuilder.pl, and
# are:
#  2. EPICS_SITE_TOP, e.g. /usr/local/epics
#  3. top-level modules directory containing a directory
#     for each module to be built
#  4. file containing list of modules to build with list of cvs
#                version tags in this format:   
#      ModuleName  CVS_module_tag1  CVS_module_tag2 CVS_module_tag3 ... 
#  5. (optional) = make action (defaults to nothing):
#      all
#      clean
#      clean uninstall
#
#######################################################################
# for now, moduleBuilder.pl is in the current working directory

export logfile=$1

echo moduleBuilder logging/appending to $logfile

echo //////////////////////////////////////////// >> $logfile 2>&1
echo moduleBuilder starting... >> $logfile 2>&1
date >> $logfile 2>&1
date

moduleBuilder.pl $2 $3 $4 $5 $6 >> $logfile 2>&1

echo moduleBuilder finished! >> $logfile 2>&1
echo moduleBuilder finished!
date >> $logfile 2>&1
date

echo Please see $logfile for log output.

#end of script

