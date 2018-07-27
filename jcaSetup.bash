#####################################################################
#                                                                   
# TITLE: jcaSetup.bash
#
# Purpose:
#
# INVOCATION: ". jcaSetup.bash <optional argument>"
# where optional argument can be one of two values, either:
#  - "local" means set up the epics addrs for your local host
#  - "remote" means set up the epics addrs for remote access
#  - If no argument is specified, the default is JCALibrary.properties
#
# Local operation of jca:
# The invocation of "jcaSetup.bash local" will be used for running xal
# Specifically, the portable channel access server needs to be
# run locally for the xal virtual accelerator. The JCALibrary.properties.local
# file must have its .addr_list set to 127.0.0.1 and its .auto_addr_list 
# set to no. In addition, EPICS_CA_ADDR_LIST must be set to 127.0.0.1 
# and EPICS_CA_AUTO_ADDR_LIST to NO for running things locally.
#
# Remote operation of jca (normal, or default)
# The invocation of "jcaSetup.bash remote" will be used by all 
# other apps, such as vdct, requiring normal channel access.
# The JCALibrary.properties.remote will be copied
#
#-------------------------------------------------------------
# History:
#           30-Nov-2008, K. Luchini (LUCHINI):
#              changed EPICSSETUP to EPISC_SETUP      
#
#####################################################################
#
#echo Number of arguments: $#
#echo First argument: $1

if [ $# -lt 1 ]; then
  echo "no argument specified - assume remote accessibility"
  set mode=remote
else if [ $1 = "local" ]; then
  mode=local
else if [ $1 = "remote" ]; then
  mode=remote
else
  echo "incorrect argument specified - assume remote accessibility"
  mode=remote
fi
fi
fi
if [ ! -e ~/.JCALibrary ]; then
  mkdir ~/.JCALibrary
fi
if [ ! -e ~/.JCALibrary/JCALibrary.properties ]; then
  isdiff=1
else
  isdiff=`diff --brief $EPICS_SETUP/JCALibrary.properties.$mode ~/.JCALibrary/JCALibrary.properties`
fi
if [ ! -z "$isdiff" ]; then
  echo "copying JCALibrary.properties.$mode to ~/.JCALibrary/JCALibrary.properties"
  cp $EPICS_SETUP/JCALibrary.properties.$mode ~/.JCALibrary/JCALibrary.properties
fi
#end of script

