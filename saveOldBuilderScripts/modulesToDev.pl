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
my $baseVer;
my $extensionsVer;
my $devModuleDir;

sub usage()
{
        print "============================================================================\n";
	print "Usage:\n";
        print "modulesToDev.pl Parameter1 Parameter2 Parameter3\n";
        print "\n";
        print "   Parameter1 = file containing list of modules to checkout\n";
        print "   Parameter2 = working directory name\n";
        print "   Parameter3 (optional) = working version name (will default to Development)\n";
        print "\n";
        print "For each module listed in the file, the script does this: \n";
        print "1. CVS checkout into the working directory structure like this:\n";
        print "     ./Parameter2/ModuleName/Parameter3\n";
        print "   for example\n";
        print "     ./sandbox/dbrestore/Development\n";
        print "\n";
        print "2. Updates configure/RELEASE:\n";
        print "   BASE_MODULE_VERSION\n"; 
        print "   EXTENSIONS_MODULE_VERSION\n";
        print "   <module>_MODULE_VERSION\n";
        print "   EPICS_MODULES\n";
        print "============================================================================\n";
        print " Script calling examples:\n";
        print "   modulesToDev.pl ModulesList.txt sandbox\n";
        print "\n";
        print "   modulesToDev.pl ModulesList.txt sandbox Devl\n";
        print "============================================================================\n";
        print " These environment variables must be defined:\n";
        print "    EPICS_BASE_VER\n";
        print "    EXTENSIONS_VER\n";
        print "    CVSROOT\n";
        print "    CVS_RSH\n";
        print "============================================================================\n";
	exit;
}

sub updateRELEASEFile($$$$$)
{
   my $fName = shift;
   my $baseVer = shift;
   my $extensionsVer = shift;
   my $verStr = shift;
   my $devModuleDir = shift;

   if (!open (INP, $fName))
      {
      print ">>>ERROR opening file $fName for reading\n";
      return 0;
      }

   my @lines = <INP>;
   my $line;
   close(INP);

   # make a backup copy of the RELEASE first
   copy ($fName, $fName . "SAVE");

   if (!open (OUT, '>' . $fName))
      {
      print ">>>ERROR opening $fName for write\n";
      return 0;
      }

   foreach $line (@lines)
      {
      if (substr($line,0,1) eq "#" || length($line) == 0)
         { 
         print OUT $line; 
         next;
         }

      if ($line =~ /^\s*BASE_MODULE_VERSION\s*=\s*/)
         { 
         print OUT "#" . $line; 
         print OUT "BASE_MODULE_VERSION=$baseVer\n"; 
         }
      elsif ($line =~ /^\s*EXTENSIONS_MODULE_VERSION\s*=\s*/)
         { 
         print OUT "#" . $line; 
         print OUT "EXTENSIONS_MODULE_VERSION=$extensionsVer\n"; 
         }
      elsif ($line =~ /^\s*EPICS_MODULES\s*=\s*/)
         { 
         print OUT "#" . $line; 
         print OUT "EPICS_MODULES=$devModuleDir\n"; 
         }
      elsif ($line =~ /_MODULE_VERSION\s*=\s*/)
         { 
         print OUT "#" . $line; 
         my @verLine = split /=/, $line;
         print OUT "$verLine[0]=$verStr\n"; 
         }
      else
         { print OUT $line; }
      }

   close OUT;
   return 1;

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
if ($ARGV[0] eq "help" || $ARGV[0] eq "HELP" || $ARGV[0] eq "Help") { usage(); } 
my $startDir = getcwd();
print ">>>running in $startDir\n";

# first test to see if EPICS_BASE_VER, EXTENSIONS_VER, CVS_RSH and CVSROOT are defined
# checkout will fail if they are not.
if (!(defined $ENV{EPICS_BASE_VER}))
   { die ">>>EPICS_BASE_VER is not defined so exiting now!\n"; }
$baseVer = $ENV{EPICS_BASE_VER};

if (!(defined $ENV{EXTENSIONS_VER}))
   { die ">>>EXTENSIONS_VER is not defined so exiting now!\n"; }
$extensionsVer = $ENV{EXTENSIONS_VER};

if (!(defined $ENV{CVSROOT}))
   { die ">>>CVSROOT is not defined; checkout will fail, so exiting now!\n"; }

if (!(defined $ENV{CVS_RSH}))
   { die "CVS_RSH is not defined; checkout will fail, so exiting now!\n"; }

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

      my $CVSCmd = "cvs co -d " . $workingVer . " " . $moduleName . " -dP";
      print "checkout command: " . $CVSCmd . "\n";
      my $sysErr = system($CVSCmd);
      if ($sysErr > 0)
         { 
         print ">>>ERROR $sysErr doing $CVSCmd\n"; 
         last MODULE; 
         }

      my $releaseFile = $workingDir . "/" . $moduleName . "/" . $workingVer . "/configure/RELEASE";
      print "updating RELEASE file $releaseFile\n";
      chdir $startDir;
      if (!(updateRELEASEFile($releaseFile, $baseVer, $extensionsVer, $workingVer, $devModuleDir)))
         {
         print ">>> ERROR updating RELEASE file $releaseFile\n";
         last MODULE;
         }
      }
   }

chdir $startDir;
close MODULELIST;

print ">>>FINISHED with modulesToDev\n";

