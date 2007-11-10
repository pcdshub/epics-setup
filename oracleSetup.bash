#####################################################################
#                                                                   #
#  Title: oracleSetup.bash                                          #
#                                                                   #
#  Purpose: '.' this file to set your environment for Oracle        #
#                                                                   #
#  History:                                                         #
#                                                                   #
#  09nov2007 starting this initial version                          #
#                                                                   #
# oracle is in /usr/local/lcls/package/oracle                       #

 export ORACLE_HOME=/usr/local/lcls/package/oracle/product/10.2.0/client_1
 export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
 export PATH=$ORACLE_HOME/bin:$PATH
 export TWO_TASK=MCCO


