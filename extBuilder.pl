#!/usr/bin/perl -w

use strict;
use File::Path;
use File::stat;
use FileHandle;
use Cwd;

my @filelist;
my $moduleListFileName;
my $moduleDir;
my $makeParam = "";
my $epicsSiteTop;
my $epicsBaseVer;
my $extensionsSiteTop;
my $extensionsVer;

sub usage()
{
        print "===================================================================\n";
	print "Usage:\n";
        print "extBuilder.pl\n";
        print "   Parameter1 (optional) = make action (defaults to nothing):\n";
        print "      all\n";
        print "      clean\n";
        print "      clean uninstall\n";
        print "=====================================================================\n";
        print " These environment variables must be defined:\n";
        print "    EPICS_SITE_TOP\n";
        print "    EPICS_BASE_VER\n";
        print "    EXTENSIONS_SITE_TOP\n";
        print "    EPICS_EXTENSIONS_VER\n";
        print "=====================================================================\n";
        print " Script calling example:\n";
        print "   extBuilder.pl clean\n";
        print "=====================================================================\n";
	exit;
}

sub confirmVars()
{
        print "---------------------------------------------------------\n";
        print "Will build with these environment settings:\n";
        print "   EPICS_SITE_TOP:       $epicsSiteTop\n";
        print "   EPICS_BASE_VER:       $epicsBaseVer\n";
        print "   EXTENSIONS_SITE_TOP:  $extensionsSiteTop\n";
        print "   EPICS_EXTENSIONS_VER: $extensionsVer\n";
        print "---------------------------------------------------------\n";

        print "Please enter go or GO to continue, any other key to EXIT NOW  ==> ";
        my $continue = <STDIN>;
        unless ($continue eq "GO\n" || $continue eq "go\n")
           { die "exiting now!\n" };
}


sub makeReleaseFile($$)
{
   my $conf = shift;
   my $baseDir = shift;
 
   my $fName = $conf . "/RELEASE";
   print ">>>RELEASE file is " . $fName . "\n";
   if (!open (OUT, '>' . $fName)) 
      { 
      print ">>>ERROR opening $fName for write\n"; 
      return 0;
      }
   else
      {
      if ($conf =~ /configure/)
         { 
         print OUT "# If you don't want to install into \$\(TOP\) dir then\n";
         print OUT "# define INSTALL_LOCATION_EXTENSIONS here\n";
         print OUT "#INSTALL_LOCATION_EXTENSIONS=<fullpathname>\n";
         print OUT "\n";
         }
      print OUT "# Location of external products\n";
      print OUT "EPICS_BASE=$baseDir\n";
      print OUT "EPICS_EXTENSIONS=\$\(TOP\)\n";
      print OUT "\n";
      close OUT;
      return 1;
      }
}


##################################################
# code start
#  the arguments are (for now):
#   1. make action which has to be one of:
#     all
#     clean
#     clean uninstall
#
# lines starting with "#" are comments and are not processed
#
##################################################
print ">>>extBuilder.pl\n";
# first check for arg of help
if ($#ARGV >= 0)
   { if ($ARGV[0] eq "help" || $ARGV[0] eq "HELP" || $ARGV[0] eq "Help" || $ARGV[0] eq "-help" || $ARGV[0] eq "-HELP" || $ARGV[0] eq "-Help") { usage(); } }

# test to see if EPICS_HOST_ARCH and SITE_TOP are defined
# build will fail if they are not.
if (!(defined $ENV{EPICS_SITE_TOP}))
   { die ">>>EPICS_SITE_TOP is not defined; build will fail, so exiting now!\n"; }
else
   { $epicsSiteTop = $ENV{EPICS_SITE_TOP}; }

if (!(defined $ENV{EPICS_BASE_VER}))
   { die ">>>EPICS_BASE_VER is not defined; build will fail, so exiting now!\n"; }
else
   { $epicsBaseVer = $ENV{EPICS_BASE_VER}; }

if (!(defined $ENV{EXTENSIONS_SITE_TOP}))
   { die ">>>ExTENSIONS_SITE_TOP is not defined; build will fail, so exiting now!\n"; }
else
   { $extensionsSiteTop = $ENV{EXTENSIONS_SITE_TOP}; }

if (!(defined $ENV{EPICS_EXTENSIONS_VER}))
   { die ">>>EPICS_EXTENSIONS_VER is not defined; build will fail, so exiting now!\n"; }
else
   { $extensionsVer = $ENV{EPICS_EXTENSIONS_VER}; }

confirmVars;

# now get and check args
my $baseDir = $epicsSiteTop . "/base/" . $epicsBaseVer; 
die ">>>ERROR:  base directory $baseDir does not exist!\n" unless -d $baseDir;

my $extDir = $epicsSiteTop . "/extensions/extensions-" . $extensionsVer; 
die ">>>ERROR:  extensions directory $extDir does not exist!\n" unless -d $extDir;

if ($#ARGV > -1)
   { $makeParam = $ARGV[0]; } 
         
if ($#ARGV > 0)
   { $makeParam .= " " . $ARGV[1]; }
print $makeParam;

# anything else on the command line is irrelevant
if ($makeParam ne "" &&
    $makeParam ne "all" &&
    $makeParam ne "clean" &&
    $makeParam ne "clean uninstall")
   { die "optional make argument must be one of:\n   all\n   clean\n   clean uninstall\n"; } 

print "\n>>>\n";
print ">>>Building extensions in $extDir using command \"make $makeParam\"\n";
print ">>>EPICS_SITE_TOP is $epicsSiteTop\n";
print ">>>EPICS_BASE_VER is $epicsBaseVer\n";
print ">>>EXTENSIONS_SITE_TOP is $extensionsSiteTop\n";
print ">>>EPICS_EXTENSIONS_VER is $extensionsVer\n";
print ">>>\n";

my $startDir = getcwd();
print (">>>Executing from " . $startDir . "\n");

if (!(chdir $extDir))
   { print ">>>ERROR doing cd to $extDir\n"; }
else
   {
   # now do the make
   # make the configure/RELEASE file
   if (!(makeReleaseFile($extDir . "/configure", $baseDir)))
      { die ">>>exiting now!!\n"; }

   # make the config/RELEASE file
   if (!(makeReleaseFile($extDir . "/config", $baseDir)))
      { die ">>>exiting now!!\n"; }

   # now do the make
   my $sysErr = system("make " . $makeParam);
                  
   if ($sysErr > 0)
      { print ">>>ERROR $sysErr doing make in directory $extDir\n"; }


  # return to starting point, in case of relative directory specification
  chdir $startDir;
  }

print ">>>FINISHED with extBuilder\n";

