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
#  07-Dec-07 Greg Added ORACLE_PATH
#  $log$ 
#====================================================================
export ORACLE_HOME=/usr/local/lcls/package/oracle/product/10.2.0/client_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME/bin:$PATH
export TWO_TASK=MCCO
export ORACLE_PATH=/usr/local/lcls/tools/oracle
