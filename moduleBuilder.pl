#!/usr/local/bin/perl -w

use strict;
use File::Path;
use File::stat;
use File::Copy;
use FileHandle;
use Cwd;

my @filelist;
my $moduleListFileName;
my $epicsModulesTop;
my $makeParam = "";
my $epicsSiteTop;

sub usage()
{
        print "===================================================================\n";
	print "Usage:\n";
        print "moduleBuilder.pl Parameter1\n";
        print "\n";
        print "   Parameter1 = file containing list of modules to build with list of cvs\n";
        print "                version tags in this format:   \n";
        print "      ModuleName  CVS_module_tag1  CVS_module_tag2 CVS_module_tag3 ... \n";
        print "\n";
        print "   Parameter2 (optional) = make action (defaults to nothing):\n";
        print "      all\n";
        print "      clean\n";
        print "      clean uninstall\n";
        print "=====================================================================\n";
        print " Script calling example:\n";
        print "   moduleBuilder.pl ModulesList.txt clean\n";
        print "=====================================================================\n";
        print " File format example:\n";
        print "  # comment\n";
        print "  LeCroy_ENET LeCroy_ENET-R1-0-0   LeCroy_ENET-R1-0-1\n";
        print "  hytecMotor8601 hytecMotor8601-R1-1-1\n";
        print "=====================================================================\n";
        print " These environment variables must be defined:\n";
        print "    EPICS_SITE_TOP\n";
        print "    EPICS_MODULES_TOP\n";
        print "=====================================================================\n";
	exit;
}

sub confirmVars()
{
        print "---------------------------------------------------------\n";
        print "Will build with these environment settings:\n";
        print "   EPICS_SITE_TOP:    $epicsSiteTop\n";
        print "   EPICS_MODULES_TOP: $epicsModulesTop\n";
        print "---------------------------------------------------------\n";

        print "Please enter go or GO to continue, any other key to EXIT NOW  ==> ";
        my $continue = <STDIN>;
        unless ($continue eq "GO\n" || $continue eq "go\n")
           { die "exiting now!\n" };
}


sub makeReleaseSiteFile($)
{
   my $fName = shift;
 
   print ">>>RELEASE_SITE file is " . $fName . "\n";

   if (!open (OUT, '>' . $fName)) 
      { 
      print ">>>ERROR opening $fName for write\n"; 
      return 0;
      }
   else
      {
      print OUT "#RELEASE Location of external products\n";
      print OUT "# Run \"gnumake clean uninstall install\" in the application\n";
      print OUT "# top directory each time this file is changed.\n";
      print OUT "\n";
      print OUT "# =============================================================\n";
      print OUT "# Define the top of the EPICS tree for your site.\n";
      print OUT "# We will build some tools/scripts that allow us to\n";
      print OUT "# change this easily when relocating software.\n";
      print OUT "# ==============================================================\n";
      print OUT "EPICS_SITE_TOP=" . $epicsSiteTop . "\n";
      print OUT "\n";
      close OUT;
      return 1;
      }
}

sub modRELEASEFile($$)
{
   my $fName = shift;
   my $epicsSiteTop = shift;

   if (!open (INP, $fName))
      {
      print ">>>ERROR opening RELEASE file $fName for reading\n";
      return 0;
      }

   my @lines = <INP>;
   my $line;
   close(INP);

   # make a backup copy of the Makefile.inc first
   copy ($fName, $fName . "SAVE");

   if (!open (OUT, '>' . $fName))
      {
      print ">>>ERROR opening $fName for write\n";
      return 0;
      }

   foreach $line (@lines)
      {
      if ($line =~ /^\s*EPICS_SITE_TOP\s*=\s*/)
         { 
         print OUT "#" . $line; 
         print OUT "EPICS_SITE_TOP = $epicsSiteTop\n"; 
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
#   1. filename of modules list to build of this format:
#     moduleName moduleVersion1 moduleVersion2 ...
#   2. make action which has to be one of:
#     all
#     clean
#     clean uninstall
#
# lines starting with "#" are comments and are not processed
#
# this script assumes that a module version directory with
# Makefile is:
#  moduleName-moduleVersion
#  for example restore-R1-0-2
#
##################################################
print ">>>moduleBuilder.pl\n";
if ($#ARGV < 0) { usage(); }
if ($ARGV[0] eq "help" || $ARGV[0] eq "HELP" || $ARGV[0] eq "Help" || $ARGV[0] eq "-help" || $ARGV[0] eq "-HELP" || $ARGV[0] eq "-Help" ) { usage(); } 

# first test to see if EPICS_HOST_ARCH and SITE_TOP are defined
# build will fail if they are not.
if (!(defined $ENV{EPICS_HOST_ARCH}))
   { print ">>>WARNING:  EPICS_HOST_ARCH is not defined; build - there may be errors in the build!\n"; }

if (!(defined $ENV{EPICS_SITE_TOP}))
   { die "EPICS_SITE_TOP is not defined; build will fail, so exiting now!\n"; }
else
   { $epicsSiteTop = $ENV{EPICS_SITE_TOP}; }

if (!(defined $ENV{EPICS_MODULES_TOP}))
   { die "EPICS_MODULES_TOP is not defined; build will fail, so exiting now!\n"; }
else
   { $epicsModulesTop = $ENV{EPICS_MODULES_TOP}; }

confirmVars;

die ">>>ERROR:  Directory $epicsSiteTop does not exist!\n" unless -d $epicsSiteTop;
die ">>>ERROR:  Directory $epicsModulesTop does not exist!\n" unless -d $epicsModulesTop;

$moduleListFileName = $ARGV[0];
if (!open(MODULELIST, $moduleListFileName))
   { die ">>>ERROR:  Could not open $moduleListFileName\n"; }

if ($#ARGV > 0)
   { $makeParam = $ARGV[1]; } 
         
if ($#ARGV > 1)
   { $makeParam .= " " . $ARGV[2]; }

# anything else on the command line is irrelevant
if ($makeParam ne "" &&
    $makeParam ne "all" &&
    $makeParam ne "clean" &&
    $makeParam ne "clean uninstall")
   { die "optional make argument must be one of:\n   all\n   clean\n   clean uninstall\n"; } 

print ">>>Building modules in $epicsModulesTop with list in $moduleListFileName using \"make $makeParam\"\n";
print ">>>EPICS_SITE_TOP is $epicsSiteTop\n";
print ">>>EPICS_MODULES_TOP is $epicsModulesTop\n";
print ">>>\n";

# FOR INTERACTIVE CONFIRMATION UNCOMMENT THE NEXT 2 LINES
#print "    ctrl-C to exit now, enter to continue\n"; 
#my $key = getc();

my $startDir = getcwd();
print (">>>Executing from " . $startDir . "\n");

# get all the module lines and process them 1 by 1
my @moduleLines = <MODULELIST>;
my $moduleLine;

MODULES: foreach $moduleLine (@moduleLines)
   {
   chomp $moduleLine;

   # remove whitespace
   $moduleLine =~ s/^\s+//;

   # operate on non-blank non-comment lines
   if (substr($moduleLine,0,1) ne "#" && length($moduleLine) > 0)
      {
      print ">>>\n";
      print ">>>Processing $moduleLine\n";
      
      # parse out the module name and list of versions 
      my @versions = split /\s/, $moduleLine;

      my $currVersion = 0;
      my $moduleName;
      my $version;
      foreach $version (@versions)       
          { 
          # module name is the first item on the line
          if ($currVersion == 0)
             { 
             $moduleName = $version;
             }
          else
             { 
             # otherwise version: cd to directory and do a make command there
             if (length($version) > 0)
                { 
                my $moduleBuildDir =  $epicsModulesTop . "/" . $moduleName . "/" . $version;
                print ">>>Building in " . $moduleBuildDir . "\n";

                if (!(chdir $moduleBuildDir))
                   { print ">>>ERROR doing cd to $moduleBuildDir\n"; }
                else
                   {
                   # make the RELEASE_SITE file
                   my $releaseSiteFileName = $moduleBuildDir . "/RELEASE_SITE";
                   makeReleaseSiteFile($releaseSiteFileName);
                   my $releaseFileName = $moduleBuildDir . "/configure/RELEASE";
                   modRELEASEFile($releaseFileName, $epicsSiteTop);

                   # now do the make
                   my $sysErr = system("make " . $makeParam);
                   
                   if ($sysErr > 0)
                      { 
                      # pop out of the modules loop and bail at the first sign of trouble!
                      print ">>>ERROR $sysErr doing make in directory $moduleBuildDir\n>>>EXITING moduleBuilder now...\n"; 
                      last MODULES;
                      }

                   # return to starting point, in case of relative directory specification
                   chdir $startDir;
                   }
                }
             }
          ++$currVersion;
          }
       
      }
   }
 

chdir $startDir;
close MODULELIST;

print ">>>FINISHED with moduleBuilder\n";

