#!/usr/local/bin/perl -w

use strict;
use File::Path;
use File::stat;
use FileHandle;
use Cwd;
use moduleCVS;

my @filelist;
my $moduleListFileName;
my $epicsModulesTop;

sub usage()
{
        print "===================================================================\n";
	print "Usage:\n";
        print "moduleExporter.pl Parameter1\n";
        print "\n";
        print "   Parameter1 = file containing list of modules to export with list of cvs\n";
        print "                version tags in this format:   \n";
        print "      ModuleName  CVS_module_tag1  CVS_module_tag2 CVS_module_tag3 ... \n";
        print "=====================================================================\n";
        print " Script calling example:\n";
        print "   moduleExporter.pl ModulesList.txt\n";
        print "=====================================================================\n";
        print " File format example:\n";
        print "  # comment\n";
        print "  LeCroy_ENET LeCroy_ENET-R1-0-0   LeCroy_ENET-R1-0-1\n";
        print "  hytecMotor8601 hytecMotor8601-R1-1-1\n";
        print "=====================================================================\n";
        print " These environment variables must be defined:\n";
        print "    EPICS_MODULES_TOP\n";
        print "    CVSROOT\n";
        print "    CVS_RSH\n";
        print "=====================================================================\n";
	exit;
}


sub confirmVars()
{
        print "---------------------------------------------------------\n";
        print "Will operate with these environment settings:\n";
        print "   EPICS_MODULES_TOP:  $epicsModulesTop\n";
        print "   CVSROOT:            $ENV{CVSROOT}\n";
        print "   CVS_RSH:            $ENV{CVS_RSH}\n";
        print "---------------------------------------------------------\n";

        print "Please enter go or GO to continue, any other key to EXIT NOW  ==> ";
        my $continue = <STDIN>;
        unless ($continue eq "GO\n" || $continue eq "go\n")
           { die "exiting now!\n" };
}

##################################################
# code start
#  the arguments are (for now):
#   1. filename of modules list to cvs export of this format:
#     moduleName moduleVersion1 moduleVersion2 ...
#
# lines starting with "#" are comments and are not processed
#
# this script assumes that a module version directory with
# Makefile is:
#  moduleName-moduleVersion
#  for example restore-R1-0-2
#
##################################################
print ">>>moduleExporter.pl\n";
if ($#ARGV < 0) { usage(); }
if ($ARGV[0] eq "help" || $ARGV[0] eq "HELP" || $ARGV[0] eq "Help" || $ARGV[0] eq "-help" || $ARGV[0] eq "-HELP" || $ARGV[0] eq "-Help" ) { usage(); } 
my $startDir = getcwd();
print ">>>running in $startDir\n";

# first test to see if CVS_RSH and CVSROOT are defined
# export will fail if they are not.
if (!(defined $ENV{CVSROOT}))
   { die ">>>CVSROOT is not defined; export will fail, so exiting now!\n"; }

if (!(defined $ENV{CVS_RSH}))
   { die "CVS_RSH is not defined; export will fail, so exiting now!\n"; }

if (!(defined $ENV{EPICS_MODULES_TOP}))
   { die "EPICS_MODULES_TOP is not defined; exiting now!\n"; }
$epicsModulesTop = $ENV{EPICS_MODULES_TOP};
die ">>>ERROR:  Directory $epicsModulesTop does not exist!\n" unless -d $epicsModulesTop;
$epicsModulesTop = $ENV{EPICS_MODULES_TOP}; 

confirmVars;

$moduleListFileName = $ARGV[0];
die ">>>ERROR: $moduleListFileName does not exist!\n" unless -e $moduleListFileName;

print ">>>CVS exporting modules listed in $moduleListFileName\n";
print ">>>CVSROOT is $ENV{CVSROOT}\n";
print ">>>CVS_RSH is $ENV{CVS_RSH}\n";
print ">>>exporting into directory $epicsModulesTop\n";
print ">>>\n";

# FOR INTERACTIVE CONFIRMATION UNCOMMENT THE NEXT 2 LINES
#print "    ctrl-C to exit now, enter to continue\n"; 
#my $key = getc();

my $exportCmd = "cvs export ";
moduleCVS::doCVSOperation($exportCmd, $epicsModulesTop, $moduleListFileName);

chdir $startDir;

print ">>>FINISHED with moduleExporter\n";

