#! /bin/bash 
#
# This is the calling script for moduleWebPage.pl for development setups
#
#######################################################################
# for now, moduleBuilder.pl is in the current working directory

source /afs/slac/g/lcls/tools/script/ENVS.bash
source /afs/slac/g/lcls/epics/setup/go_epics_3-14-8-2-lcls6_p1.bash
cp /afs/slac/g/lcls/epics/setup/moduleWebPageTop.html /tmp/.
export RTEMS_VER=
cd /tmp
/afs/slac/g/lcls/epics/setup/moduleWebPage.pl ./dev_modules.html ./dev_modules_order.txt GO

source /afs/slac/g/lcls/epics/setup/go_epics_3-14-12.bash
/afs/slac/g/lcls/epics/setup/moduleWebPage.pl ./dev_modules_12.html ./dev_modules_order_12.txt GO

#source /afs/slac/g/acctest/tools/script/ENVS_acctest.bash
# set the env vars explicitly!
export EPICS_MODULES_TOP=/afs/slac/g/acctest/epics/modules/R3-14-12
export EPICS_BASE_VER=base-R3-14-12
/afs/slac/g/lcls/epics/setup/moduleWebPageACCTEST.pl ./acctest_modules.html ./acctest_modules_order.txt GO

#cp the files to web dir
cp dev_modules* /afs/slac/www/grp/lcls/controls/epicsModulesLists/.
cp acctest_modules* /afs/slac/www/grp/lcls/controls/epicsModulesLists/.

#end of script


