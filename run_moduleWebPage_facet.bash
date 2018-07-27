#! /bin/bash
#
# This is the calling script for moduleWebPage.pl for facet setups
#
#######################################################################
# for now, moduleBuilder.pl is in the current working directory

cd /usr/local/facet/epics/setup
cp /usr/local/facet/epics/setup/moduleWebPageTop.html /tmp/.
source /usr/local/facet/epics/setup/go_epics_3-14-8-2-lcls6_p1_facet.bash
export RTEMS_VER=

cd /tmp

/usr/local/facet/epics/setup/moduleWebPage.pl ./facet_modules.html ./facet_modules_order.txt GO

source /usr/local/facet/epics/setup/go_epics_3-14-12_facet.bash
/usr/local/facet/epics/setup/moduleWebPage.pl ./facet_modules_12.html ./facet_modules_order_12.txt GO

#scp the files to web dir
cp ./facet_modules* /u1/facet/tools/moduleWebPages/.

#end of script


