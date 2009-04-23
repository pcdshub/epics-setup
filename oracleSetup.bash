#-*-sh-*-
#====================================================================
#                                                
#  Title: oracleSetup.bash                       
#                                                           
#  Purpose: '.' this file to set your environment for Oracle and 
#           oracle clients.
#        
#--------------------------------------------------------------------
#  History:
#  $id$
#  23-Apr-09 jrock set TWO_TASK to SLACDEV for dev version
#  07-Dec-07 Greg Added ORACLE_PATH
#  $log$ 
#====================================================================
if [ -d /usr/local/lcls/package/oracle/product/10.2.0/client_1 ]; then
   export ORACLE_HOME=/usr/local/lcls/package/oracle/product/10.2.0/client_1
   export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
   export PATH=$ORACLE_HOME/bin:$PATH
   export TWO_TASK=MCCO
   export ORACLE_PATH=/usr/local/lcls/tools/oracle
else
   source /afs/slac/package/oracle/common/oraenv_new
   export TWO_TASK=SLACDEV
fi

