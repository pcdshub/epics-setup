#! /bin/bash 
#
# This is the calling script for moduleWebPage.pl for production lcls
#
#######################################################################
# for now, moduleBuilder.pl is in the current working directory

source /usr/local/lcls/tools/script/ENVS.bash

export RTEMS_VER=
cp /usr/local/lcls/epics/setup/moduleWebPageTop.html /tmp/.

# cd to tmp so that the build order link in the web page points to "./"
cd /tmp

/usr/local/lcls/epics/setup/moduleWebPage.pl ./lcls_modules.html ./lcls_modules_order.txt GO

source /usr/local/lcls/epics/setup/go_epics_3-14-12.bash

/usr/local/lcls/epics/setup/moduleWebPage.pl ./lcls_modules_12.html ./lcls_modules_order_12.txt GO

#scp the files to web dir
cp lcls_modules* /u1/lcls/tools/moduleWebPages/.

#end of script

