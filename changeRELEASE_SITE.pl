#!/usr/local/bin/perl -w

use strict;
use File::Path;
use File::stat;
use File::Copy;
use FileHandle;
use Cwd;

my @filelist;
my $moduleListFileName;
my $makeParam = "";
my $currDir;
my $strNew;

sub usage()
{
        print "===================================================================\n";
	print "Usage:\n";
        print "changeRELEASESITE.pl Parameter1 Parameter2\n";
        print "\n";
        print "   Parameter1 = new EPICS_SITE_TOP directory\n";
        print "                e.g. /usr/local/lcls\n";
        print "\n";
        print "   Parameter2 = FULLY QUALIFIED directory with modules dirs\n";
        print "                e.g. /usr/local/epics/modules/fastFeedback/modules\n";
        print "=====================================================================\n";
        print " Script calling example:\n";
        print "   changeRELEASESITE.pl /usr/local /usr/local/epics/modules/fastFeedback/modules\n";
        print "=====================================================================\n";
        print " operates on all RELEASE_SITE files starting at the Parameter2 dir\n";
        print "=====================================================================\n";
	exit;
}

sub confirmVars()
{
        print "--------------------------------------------------------------\n";
        print "Will change all RELEASE_SITE files found in the directory tree\n"; 
        print "starting here: $currDir\n";
        print "--------------------------------------------------------------\n";

        print "Please enter go or GO to continue, any other key to EXIT NOW  ==> ";
        my $continue = <STDIN>;
        unless ($continue eq "GO\n" || $continue eq "go\n")
           { die "exiting now!\n" };
}

sub backwards { $b cmp $a };


sub modRELEASE_SITEFile
{
   my $fName = "RELEASE_SITE";
   if (!open (INP, "RELEASE_SITE"))
      {
      print ">>>ERROR opening $fName file for reading\n";
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
         print OUT "EPICS_SITE_TOP=$strNew\n"; 
         }
      else
         { print OUT $line; }

      }

   close OUT;
   return 1;

}


##################################################
# code start
#
##################################################
print ">>>moduleBuilder.pl\n";
if ($#ARGV < 1) { usage(); }
if ($ARGV[0] eq "help" || $ARGV[0] eq "HELP" || $ARGV[0] eq "Help" || $ARGV[0] eq "-help" || $ARGV[0] eq "-HELP" || $ARGV[0] eq "-Help" ) { usage(); } 


$strNew = $ARGV[0];
$currDir = $ARGV[1];
confirmVars;

print ">>>Changing all RELEASE_SITE files in $currDir: setting EPICS_SITE_TOP to $strNew\n";
print ">>>\n";

chdir($currDir);

opendir MODTOPDIR, $currDir or die "couldnt open directory $currDir\n";
my @moduleLines = grep !/^\./, readdir MODTOPDIR;
closedir MODTOPDIR;

MODULE: foreach my $moduleLine (@moduleLines)
   {
   chomp $moduleLine;

   # remove whitespace
   $moduleLine =~ s/^\s+//;

   my $version;
   my $moduleName = $moduleLine;
print "MODULENAME = $moduleName\n";

   # operate on non-blank non-comment lines
    print ">>>\n";
    print ">>>Processing $moduleLine\n";

    # parse out the module name and list of versions
    my @versions = split /\s/, $moduleLine;

    my $moduleDir = $currDir . "/" . $moduleLine;
    if (!(-d $moduleDir))
       { print "$moduleDir not a directory\n"; next MODULE; }

    opendir MODDIR, $moduleDir or die "couldnt open directory $moduleDir\n";
    @versions = grep !/^\./, readdir MODDIR;
    closedir MODDIR;
    my @versionsSorted = sort backwards @versions;

    VERSION: foreach $version (@versionsSorted)
       {
       my $moduleBuildDir =  $currDir . "/" . $moduleName . "/" . $version;
       print ">>>" . $moduleBuildDir . "\n";

       if (!(-d $moduleBuildDir))
          { print ">>>$moduleBuildDir is not a directory\n"; next VERSION; }

       # search for dependencies in configure/RELEASE
       #my $releaseConfigDir = $moduleBuildDir . "/configure";

       #print "$moduleName  $version  $releaseConfigDir\n";
       #ACTION HERE
       #addModuleToHTML($moduleName, $version, $releaseConfigDir);
       chdir($moduleBuildDir);
       modRELEASE_SITEFile;
       chdir($currDir);
       }

   }

chdir $currDir;

print ">>>FINISHED\n";

