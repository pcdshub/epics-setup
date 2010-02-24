#!/usr/local/bin/perl -w

use strict;
use File::Path;
use File::stat;
use File::Copy;
use FileHandle;
use Cwd;

my @filelist;
my $moduleListFileName;
my $workingDir;
my $workingVer;
my $devModuleDir;

sub usage()
{
        print "============================================================================\n";
	print "Usage:\n";
        print "modulesToDevNOWRITE.pl Parameter1 Parameter2 Parameter3\n";
        print "\n";
        print "   Parameter1 = file containing list of modules to checkout\n";
        print "   Parameter2 = working directory name\n";
        print "   Parameter3 (optional) = working version name (will default to Development)\n";
        print "\n";
        print "For each module listed in the file, the script does this: \n";
        print "CVS checkout into the working directory structure like this:\n";
        print "     ./Parameter2/ModuleName/Parameter3\n";
        print "   for example\n";
        print "     ./sandbox/dbrestore/Development\n";
        print "\n";
        print "*** NO UPDATES are done to configure/RELEASE. ***\n";
        print "============================================================================\n";
        print " Script calling examples:\n";
        print "   modulesToDev.pl ModulesList.txt sandbox\n";
        print "\n";
        print "   modulesToDev.pl ModulesList.txt sandbox Devl\n";
        print "============================================================================\n";
        print " These environment variables must be defined:\n";
        print "    CVSROOT\n";
        print "    CVS_RSH\n";
        print "============================================================================\n";
	exit;
}

sub confirmVars()
{
        print "---------------------------------------------------------\n";
        print "Will operate with these environment settings:\n";
        print "   CVSROOT:               $ENV{CVSROOT}\n";
        print "   CVS_RSH:               $ENV{CVS_RSH}\n";
        print "---------------------------------------------------------\n";

        print "Please enter go or GO to continue, any other key to EXIT NOW  ==> ";
        my $continue = <STDIN>;
        unless ($continue eq "GO\n" || $continue eq "go\n")
           { die "exiting now!\n" };
}




##################################################
# code start
#  the arguments are (for now):
#   1. filename of modules list to cvs checkout
#   2. working directory name
#
# lines in the modules list starting with "#" are 
# comments and are not processed
#
##################################################
print ">>>modulesToDev.pl\n";
if ($#ARGV < 1) { usage(); }
if ($ARGV[0] eq "help" || $ARGV[0] eq "HELP" || $ARGV[0] eq "Help" || $ARGV[0] eq "-help" || $ARGV[0] eq "-HELP" || $ARGV[0] eq "-Help" ) { usage(); } 
my $startDir = getcwd();
print ">>>running in $startDir\n";

# first test to see if CVS_RSH and CVSROOT are defined
# checkout will fail if they are not.

if (!(defined $ENV{CVSROOT}))
   { die ">>>CVSROOT is not defined; checkout will fail, so exiting now!\n"; }

if (!(defined $ENV{CVS_RSH}))
   { die "CVS_RSH is not defined; checkout will fail, so exiting now!\n"; }

confirmVars;

$moduleListFileName = $ARGV[0];
die ">>>ERROR: $moduleListFileName does not exist!\n" unless -e $moduleListFileName;

$workingDir = $ARGV[1];
die ">>>ERROR: Directory $workingDir does not exist!  mkdir $workingDir and try again.\n" unless -d $workingDir;

if ($#ARGV > 1) 
   { $workingVer = $ARGV[2]; }
else
   { $workingVer = "Development"; }


print ">>>\n";
print ">>>CVS checking out each module listed in $moduleListFileName into $workingDir\/<modulename>\/" . $workingVer . "\n";
print ">>>\n";
print ">>>CVSROOT is $ENV{CVSROOT}\n";
print ">>>CVS_RSH is $ENV{CVS_RSH}\n";
print ">>>\n";

# FOR INTERACTIVE CONFIRMATION UNCOMMENT THE NEXT 2 LINES
#print "    ctrl-C to exit now, enter to continue\n"; 
#my $key = getc();

if (!open(MODULELIST, $moduleListFileName))
   { die ">>>ERROR:  Could not open $moduleListFileName\n"; }

if (!(chdir $workingDir))
   { die ">>>ERROR doing cd to $workingDir directory\n"; }
$devModuleDir = getcwd();

# get all the module lines and process them 1 by 1
my @moduleNames = <MODULELIST>;
my $moduleName;

MODULE: foreach $moduleName (@moduleNames)
   {
   chomp $moduleName;
   if (substr($moduleName,0,1) eq "#" || length($moduleName) == 0)
      { next MODULE; }

   # remove leading whitespace
   $moduleName =~ s/^\s+//;
   # remove trailing whitespace
   my @modSplit = split / /, $moduleName;
   $moduleName = $modSplit[0];

   # operate on non-blank non-comment lines
   if (substr($moduleName,0,1) ne "#" && length($moduleName) > 0)
      {
      print ">>>\n";
      print ">>>Processing $moduleName\n";
      chdir $workingDir;

      mkdir $moduleName unless -d $moduleName;
      if (!(chdir $moduleName))
         { 
         print ">>>ERROR doing cd to $moduleName\n";
         last MODULE;
         }

      my $CVSCmd = "cvs co -d " . $workingVer . " " . $moduleName;
      print "checkout command: " . $CVSCmd . "\n";
      my $sysErr = system($CVSCmd);
      if ($sysErr > 0)
         { 
         print ">>>ERROR $sysErr doing $CVSCmd\n"; 
         last MODULE; 
         }

      }
      chdir $startDir;
   }

chdir $startDir;
close MODULELIST;

print ">>>FINISHED with modulesToDevNOWRITE\n";

