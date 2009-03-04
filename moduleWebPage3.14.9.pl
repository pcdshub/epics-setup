#!/usr/bin/perl -w

use strict;
use File::Path;
use File::stat;
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
        print "moduleWebPage.pl\n";
        print "\n";
        print "   Parameter1 = file containing list of modules to build with list of cvs\n";
        print "                version tags in this format:   \n";
        print "      ModuleName  CVS_module_tag1  CVS_module_tag2 CVS_module_tag3 ... \n";
        print "\n";
        print "   Parameter2 = html filename\n";
        print "=====================================================================\n";
        print " Script calling example:\n";
        print "   \n";
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
        print "Will operate with this environment setting:\n";
        print "   EPICS_MODULES_TOP:  $epicsModulesTop\n";
        print "---------------------------------------------------------\n";

        print "Please enter go or GO to continue, any other key to EXIT NOW  ==> ";
        my $continue = <STDIN>;
        unless ($continue eq "GO\n" || $continue eq "go\n")
           { die "exiting now!\n" };
}



sub startHTMLFILE
{
  print HTMLFILE "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
  print HTMLFILE "<html>\n";
  print HTMLFILE "<head>\n";
  print HTMLFILE "<title>EPICS Software Modules</title>\n";
  print HTMLFILE "<h2><font color=blue>EPICS Software Modules</font></h2>\n";
  print HTMLFILE "</head>\n";
  print HTMLFILE "<p>\n";
  
  print HTMLFILE "<body>\n";
  print HTMLFILE "<b>EPICS Base:</b> base-R3.14.9-lcls2 (rtems-4.7.1)<br>\n";
  print HTMLFILE "<b>Operating system:</b> RTEMS<br>\n";
  print HTMLFILE "<b>CVS Repository:</b> /afs/slac/g/lcls/cvs<br>\n";
  print HTMLFILE "<b>Build directory:</b> /usr/local/lcls/epics/modules<br>\n";
  print HTMLFILE "<b>Host:</b> lcls-builder<br>\n";

  print HTMLFILE "<p>\n";
  print HTMLFILE "<b>Modules in Build Order:</b><br>\n";
  print HTMLFILE "<table border=1>\n";
  print HTMLFILE "<tr><td align=center><b>Software Module</b></td>\n";
  print HTMLFILE "<td align=center><b>Release Version</b></td>\n";
  print HTMLFILE "<td align=center><b>Module Dependencies</b></td>\n";
  print HTMLFILE "<td align=center><b>Module Maintainer</b></td></tr>\n";

}

sub finishHTMLFILE
{
  print HTMLFILE "</table>\n";
  print HTMLFILE "</body>\n";
  print HTMLFILE "</html>\n";

}
sub addModuleToHTML($$$)
{
   my $moduleName = shift;
   my $version = shift;
   my $releaseConfigFilename= shift;
   
   my $spaces = "     ";

   if (!open(CONFIGFILE, $releaseConfigFilename))
      { 
      print ">>>ERROR:  Could not open $moduleListFileName for read\n"; 
      return 0;
      }

   my @lines = <CONFIGFILE>;
   close(CONFIGFILE);
   my $line;
   my @lineSplit;
   my $firstDep = 0;

   print HTMLFILE "<tr valign=top> <td>" . $moduleName . "</td><td>" . $version . "</td><td>";
   foreach $line (@lines)
      {
      chop $line;
      if ($line =~ /MODULE_VERSION\s*=\s*/)
         { 
         # extract the module dependency
         @lineSplit = split /=/, $line;
         if ($firstDep > 0)
            { print HTMLFILE "<br>"; }
         else
            { ++$firstDep; }
         print HTMLFILE @lineSplit[1]; 
         }
      }
   print HTMLFILE "</td><td></td></tr>\n";
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
if ($ARGV[0] eq "help" || $ARGV[0] eq "HELP" || $ARGV[0] eq "Help" || $ARGV[0] eq "-help" || $ARGV[0] eq "-HELP" || $ARGV[0] eq "-Help" ) { usage(); } 
if ($#ARGV < 1) { usage(); }

if (!(defined $ENV{EPICS_MODULES_TOP}))
   { die "EPICS_MODULES_TOP is not defined; build will fail, so exiting now!\n"; }
else
   { $epicsModulesTop = $ENV{EPICS_MODULES_TOP}; }

die ">>>ERROR:  Directory $epicsModulesTop does not exist!\n" unless -d $epicsModulesTop;

confirmVars;

$moduleListFileName = $ARGV[0];
if (!open(MODULELIST, $moduleListFileName))
   { die ">>>ERROR:  Could not open $moduleListFileName for read\n"; }

my $moduleListHTML = $ARGV[1];
if (!open(HTMLFILE, ">" . $moduleListHTML))
   { die ">>>ERROR:  Could not open $moduleListHTML for write\n"; }

startHTMLFILE();

my $startDir = getcwd();
print (">>>Executing from " . $startDir . "\n");

# get all the module lines and process them 1 by 1
my @moduleLines = <MODULELIST>;
my $moduleLine;

foreach $moduleLine (@moduleLines)
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
                print ">>>" . $moduleBuildDir . "\n";

                if (!(chdir $moduleBuildDir))
                   { print ">>>ERROR doing cd to $moduleBuildDir\n"; }
                else
                   {
                   # make the RELEASE_SITE file
                   my $releaseConfigFileName = $moduleBuildDir . "/configure/RELEASE";
                   print "$moduleName  $version  $releaseConfigFileName\n";
                   addModuleToHTML($moduleName, $version, $releaseConfigFileName);

                   # return to starting point, in case of relative directory specification
                   chdir $startDir;
                   }
                }
             }
          ++$currVersion;
          }
       
      }
   }
 

finishHTMLFILE();
chdir $startDir;
close MODULELIST;
close HTMLFILE;

print ">>>FINISHED with moduleWebPage\n";

