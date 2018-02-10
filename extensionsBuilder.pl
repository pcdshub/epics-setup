#!/usr/bin/perl -w

use strict;
use File::Path;
use File::stat;
use File::Copy;
use FileHandle;
use Cwd;

my @filelist;
my $extListFileName;
my $extSiteTop;
my $makeParam = "";
my $epicsSiteTop;
my $epicsBaseVer;

sub usage()
{
        print "===================================================================\n";
	print "Usage:\n";
        print "extensionsBuilder.pl Parameter1\n";
        print "\n";
        print "   Parameter1 = file containing list of extensions to build with list of cvs\n";
        print "                version tags in this format:   \n";
        print "      Extension  CVS_tag1  CVS_tag2 CVS_tag3 ... \n";
        print "\n";
        print "   Parameter2 (optional) = make action (defaults to nothing):\n";
        print "      all\n";
        print "      clean\n";
        print "      clean uninstall\n";
        print "=====================================================================\n";
        print " Script calling example:\n";
        print "   extensionsBuilder.pl extList.txt clean\n";
        print "=====================================================================\n";
        print " File format example:\n";
        print "  # comment\n";
        print "  msi      msi-R0-1-1\n";
        print "  dbreport dbreport-R2-0-1 dbreport-R1-0-0\n";
        print "=====================================================================\n";
        print " These environment variables must be defined:\n";
        print "    EPICS_SITE_TOP\n";
        print "    EPICS_BASE_VER\n";
        print "    EXTENSIONS_SITE_TOP\n";
        print "=====================================================================\n";
	exit;
}

sub confirmVars()
{
        print "---------------------------------------------------------\n";
        print "Will build with these environment settings:\n";
        print "   EPICS_SITE_TOP:        $epicsSiteTop\n";
        print "   EPICS_BASE_VER:        $epicsBaseVer\n";
        print "   EXTENSIONS_SITE_TOP:   $epicsSiteTop\n";
        print "---------------------------------------------------------\n";

        print "Please enter go or GO to continue, any other key to EXIT NOW  ==> ";
        my $continue = <STDIN>;
        unless ($continue eq "GO\n" || $continue eq "go\n")
           { die "exiting now!\n" };
}

sub makeReleaseFile($$)
{
   my $fName = shift;
   my $baseVer = shift;
 
   print ">>>RELEASE file is " . $fName . "\n";

   if (!open (INP, $fName))
      {
      print ">>>ERROR opening makefile $fName for reading\n";
      return 0;
      }

   my @lines = <INP>;
   my $line;
   close(INP);

   # make a backup copy of the RELEASE file first
   copy ($fName, $fName . "SAVE");

   if (!open (OUT, '>' . $fName)) 
      { 
      print ">>>ERROR opening $fName for write\n"; 
      return 0;
      }
   foreach $line (@lines)
      {

      if ($line =~ /^\s*BASE_MODULE_VERSION\s*=\s*/)
         { print OUT "BASE_MODULE_VERSION = $baseVer\n"; }
      else
         { print OUT $line; }
      }

   close OUT;
   return 1;
}


##################################################
# code start
#  the arguments are (for now):
#   1. filename of extensions list to build of this format:
#     extension extVersion1 extVersion2 ...
#   2. make action which has to be one of:
#     all
#     clean
#     clean uninstall
#
# lines starting with "#" are comments and are not processed
#
##################################################
print ">>>extensionsBuilder.pl\n";
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

if (!(defined $ENV{EXTENSIONS_SITE_TOP}))
   { die "EXTENSIONS_SITE_TOP is not defined; build will fail, so exiting now!\n"; }
else
   { $extSiteTop = $ENV{EXTENSIONS_SITE_TOP}; }

if (!(defined $ENV{EPICS_BASE_VER}))
   { die "EPIS_BASE_VER is not defined; build will fail, so exiting now!\n"; }
else
   { $epicsBaseVer = $ENV{EPICS_BASE_VER}; }

confirmVars;

die ">>>ERROR:  Directory $epicsSiteTop does not exist!\n" unless -d $epicsSiteTop;
die ">>>ERROR:  Directory $extSiteTop does not exist!\n" unless -d $extSiteTop;


$extListFileName = $ARGV[0];
if (!open(EXTLIST, $extListFileName))
   { die ">>>ERROR:  Could not open $extListFileName\n"; }

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

print ">>>Building modules in $extSiteTop with list in $extListFileName using \"make $makeParam\"\n";
print ">>>EPICS_SITE_TOP is $epicsSiteTop\n";
print ">>>EXTENSIONS_SITE_TOP is $extSiteTop\n";
print ">>>EPICS_BASE_VER is $epicsBaseVer\n";
print ">>>\n";

# FOR INTERACTIVE CONFIRMATION UNCOMMENT THE NEXT 2 LINES
#print "    ctrl-C to exit now, enter to continue\n"; 
#my $key = getc();

my $startDir = getcwd();
print (">>>Executing from " . $startDir . "\n");

# get all the module lines and process them 1 by 1
my @extLines = <EXTLIST>;
my $extLine;

EXTENSIONS: foreach $extLine (@extLines)
   {
   chomp $extLine;

   # remove whitespace
   $extLine =~ s/^\s+//;

   # operate on non-blank non-comment lines
   if (substr($extLine,0,1) ne "#" && length($extLine) > 0)
      {
      print ">>>\n";
      print ">>>Processing $extLine\n";
      
      # parse out the extension and list of versions 
      my @versions = split /\s/, $extLine;

      my $currVersion = 0;
      my $extension;
      my $version;
      VERSIONS: foreach $version (@versions)       
          { 
          # module name is the first item on the line
          if ($currVersion == 0)
             { 
             $extension = $version;
             }
          else
             { 
             # otherwise version: cd to directory and do a make command there
             if (length($version) > 0)
                { 
                my $extBuildDir =  $extSiteTop . "/" . $extension . "/" . $version;
                print ">>>Building in " . $extBuildDir . "\n";

                if (!(chdir $extBuildDir))
                   { print ">>>ERROR doing cd to $extBuildDir\n"; }
                else
                   {
                   # make the RELEASE_SITE file
                   my $releaseFileName = $extBuildDir . "/configure/RELEASE";
                   makeReleaseFile($releaseFileName, $epicsBaseVer);

                   # now do the make
                   my $sysErr = system("make " . $makeParam);
                   
                   if ($sysErr > 0)
                      { 
                      # bail at the first error encountered
                      print ">>>ERROR $sysErr doing make in directory $extBuildDir\n"; 
                      last EXTENSIONS;
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
close EXTLIST;

print ">>>FINISHED with extensionsBuilder\n";

