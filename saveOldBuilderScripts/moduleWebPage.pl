#!/usr/local/bin/perl -w

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
my $prevModuleName = "none";
my %moduleHash = ();
my @moduleOrderList;
my @currDeps = ();

sub usage()
{
        print "===================================================================\n";
	print "Usage:\n";
        print "moduleWebPage.pl\n";
        print "\n";
        print "   Parameter1 = html filename\n";
        print "=====================================================================\n";
        print " These environment variables must be defined:\n";
        print "    EPICS_MODULES_TOP\n";
        print "=====================================================================\n";
	exit;
}

sub outputModuleBuildOrder()
{
  my $buildOrderFilename = "./moduleBuildOrder.txt";
  if (!(open(BUILDORDER, '>'.$buildOrderFilename)))
   {
   print "Error opening BUILDORDER file\n";
   return 0;
   }
 
  print BUILDORDER "# Module Build Order\n";
  print BUILDORDER "#  This is one build order that will work!\n\n";
  print BUILDORDER "# First build:\n";
  print BUILDORDER "#   EPICS Base\n";
  print BUILDORDER "#   EPICS Extensions\n\n";

  my $i = 1;
  foreach my $mod (@moduleOrderList)
     {
     print BUILDORDER "$mod\n";
     }

  close BUILDORDER;
}

sub startHTMLFILE()
{
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $idst) = localtime(time);

  my $time = sprintf("%2d",$hour) . ":" . sprintf("%2d",$min) . ":" . sprintf("%2d",$sec);
  $time =~ s/ /0/g;
  my $now = ($mon+1) . "/" . $mday . "/" . ($year+1900) . " " . $time;
  
  print HTMLFILE "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
  print HTMLFILE "<html>\n";
  print HTMLFILE "<head>\n";
#  print HTMLFILE "<title>EPICS Software Modules</title>\n";
#  print HTMLFILE "<h2><font color=blue>EPICS Software Modules</font></h2>\n";
#  print HTMLFILE "</head>\n";
#  print HTMLFILE "<p>\n";
  
  if (!open(TOPFILE, "moduleWebPageTop.html"))
     {
     print "WARNING: moduleWebPageTop.html file was not found\n";
     print HTMLFILE "<title>EPICS Software Modules</title>\n";
     print HTMLFILE "<h2><font color=blue>EPICS Software Modules</font></h2>\n";
     print HTMLFILE "</head>\n";
     print HTMLFILE "<body>\n";
     print HTMLFILE "<p>\n";
     }
  else
     {
     # read top in from file
     my @topLines = <TOPFILE>;
     close(TOPFILE);
     my $topLine;
     foreach $topLine (@topLines) 
        {
        print HTMLFILE $topLine;
        }
     }
 
  
  print HTMLFILE "<p style=\"margin: 5pt 0.5in;\">\n";
  print HTMLFILE "<b>EPICS Base:</b> base-R3.14.8.2-lcls2 (rtems-4.7.1)<br>\n";
  print HTMLFILE "<b>Operating system:</b> RTEMS<br>\n";
  print HTMLFILE "<b>CVS Root:</b> /afs/slac/g/lcls/cvs<br>\n";
  print HTMLFILE "<b>Build directory:</b> /usr/local/lcls/epics/modules<br>\n";
  print HTMLFILE "<b>Host:</b> lcls-builder<br>\n";
  print HTMLFILE "<b>Last updated: </b>" . $now . "<br>\n";
  print HTMLFILE "<p style=\"margin: 5pt 0.5in;\">\n";
  print HTMLFILE "<a href=\"http://www.slac.stanford.edu/cgi-wrap/cvsweb/epics/site/src/?cvsroot=LCLS\">Modules CVSWEB</a><br>\n";
  print HTMLFILE "<a href=\"./moduleBuildOrder.txt\">Build Order</a><br>\n";
  print HTMLFILE "<p>\n";

  print HTMLFILE "<p style=\"margin: 5pt 0.5in;\">\n";
  print HTMLFILE "<table border=1 width=90%>\n";
  print HTMLFILE "<tr><td align=center><b>Software Module</b></td>\n";
  print HTMLFILE "<td align=center><b>Release Version</b></td>\n";
  print HTMLFILE "<td align=center><b>Module Dependencies</b></td>\n";
  print HTMLFILE "<td align=center><b>Module Maintainer</b></td></tr>\n";
  print HTMLFILE "</p>\n";
}

sub finishHTMLFILE
{
  print HTMLFILE "</table>\n";
  print HTMLFILE "</body>\n";
  print HTMLFILE "</html>\n";

}
sub backwards { $b cmp $a };

sub outputDependsOn ($)
{
   my @deps = @_;
   my $dep;

   for $dep (@deps)
      { 
      print "   DEP: $dep\n"; 
      if (!($dep =~ /base-/) &&
          !($dep =~ /extensions-/) &&
          ($dep =~ /\-R/))
         {  
         &outputDependsOn (@{ $moduleHash{$dep} });

         my @modNames = split /\-/, $dep;
         my $modName = $modNames[0];
         if (!(modInList($modName)))
            { push @moduleOrderList, $modName; }
         }
      } 
}

sub modInList($)
{
my $modName = shift;

foreach my $mod (@moduleOrderList)
   {
   if ($mod eq $modName)
      { return 1; }
   }

return 0;
}

sub addModuleToHTML($$$)
{
   my $moduleName = shift;
   my $version = shift;
   my $releaseConfigDir= shift;
   
   my $ucVersion = uc $version;

   my @relFiles;
   my $relFile;
   my @deps = ();

print "$releaseConfigDir\n";
if (!(opendir RELDIR, $releaseConfigDir))
   {
   print "couldnt open directory $releaseConfigDir\n";
   return 0;
   }

@relFiles = grep !/^\./, readdir RELDIR;
closedir RELDIR;

   if ($ucVersion eq "DEVELOPMENT" ||
       $ucVersion eq "DEVL" ||
       $ucVersion eq "WORK" ||
       $ucVersion eq "WORKING")
      { return; }

   if (!($ucVersion =~ /\_R/ || $ucVersion =~ /\-R/))
      { return; }
   
   if ($moduleName eq $prevModuleName)
      {
      print HTMLFILE "<tr valign=top> <td><br></td><td>" . $version . "</td><td>";
      }
   else
      {
      print HTMLFILE "<tr valign=top> <td><b>" . $moduleName . "</b></td><td>" . $version . "</td><td>";
      $prevModuleName = $moduleName;
      }

   my $releaseConfigFilename;
   my $firstDep = 0;
   RELFILES: foreach $relFile (@relFiles)
      {
      #print "*$relFile*\n";
      if (($relFile =~ /\~/) || ($relFile =~ /\.win/))
         { next RELFILES; }

      if (($relFile ne "RELEASE") && !($relFile =~ /^RELEASE.Common/))
         { next RELFILES; }

      $releaseConfigFilename = $releaseConfigDir . "/" . $relFile;

      #print "RELEASE FILE: $releaseConfigFilename\n";

      if (!open(CONFIGFILE, $releaseConfigFilename))
         { 
         print ">>>ERROR:  Could not open $moduleListFileName for read\n"; 
         return 0;
         }

      my @lines = <CONFIGFILE>;
      close(CONFIGFILE);
      my $line;
      my @lineSplit;

      # added this 8/28/2008 initialize the hash entry for the version
      $moduleHash{$version} = ();

      foreach $line (@lines)
         {
         chop $line;
         # remove leading whitespace
         $line =~ s/^\s+//;

         # if the line has MODULE_VERSION in it, and doesn't start with "#" then
         # we infer that it contains a dependency
         if (($line =~ /MODULE_VERSION\s*=\s*/) &&
             (!($line =~ /^#/)))
            { 
            # first, get the name of the dependency:
            my $modIndex = index $line, "MODULE_VERSION";
            my $modLabel = substr $line, 0, $modIndex-1;

            # extract the module dependency
            @lineSplit = split /=/, $line;
            if ($firstDep > 0)
               { print HTMLFILE "<br>"; }
            else
               { ++$firstDep; }

            print HTMLFILE $modLabel . " = " . $lineSplit[1]; 
#            push @deps, $lineSplit[1];
push @{ $moduleHash{$version} }, $lineSplit[1];
            }
         }
      }

# add to the module hash for later build-ordering
#$moduleHash{$version} = @deps;

   my $maintPerson = "<br>";

   if ($moduleName =~ /^autosave/)
      { $maintPerson = "Mike Zelazny"; }
   elsif ($moduleName =~ /^EDT_CL/)
      { $maintPerson = "Sheng Peng"; }
   elsif ($moduleName =~ /^caenADC/)
      { $maintPerson = "Arturo Alarcon"; }
   elsif ($moduleName =~ /^vmeCardRecord/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^ether_ip/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^sub/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^seq/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^VHSxOx/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^generalTime/)
      { $maintPerson = "Sheng Peng"; }
   elsif ($moduleName =~ /^genSub/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^ipac/)
      { $maintPerson = "Sheng Peng"; }
   elsif ($moduleName =~ /^sSubRecord/)
      { $maintPerson = "Stepanie Allison"; }
   elsif ($moduleName =~ /^iocAdmin/)
      { $maintPerson = "Stepanie Allison"; }
   elsif ($moduleName =~ /^asyn/)
      { $maintPerson = "Stephen Schuh"; }
   elsif ($moduleName =~ /^ip231/)
      { $maintPerson = "Sheng Peng"; }
   elsif ($moduleName =~ /^ip330/)
      { $maintPerson = "Sheng Peng"; }
   elsif ($moduleName =~ /^xy244/)
      { $maintPerson = "Sheng Peng"; }
   elsif ($moduleName =~ /^streamdevice/)
      { $maintPerson = "Stephen Schuh"; }
   elsif ($moduleName =~ /^event/)
      { $maintPerson = "Stepanie Allison"; }
   elsif ($moduleName =~ /^hytecMotor/)
      { $maintPerson = "Arturo Alarcon"; }
   elsif ($moduleName =~ /^hytec/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^vsam/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^etherPSC/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^LeCroy_ENET/)
      { $maintPerson = "Diane Fairley"; }
   elsif ($moduleName =~ /^ip470/)
      { $maintPerson = "Sonya Hoobler"; }
   elsif ($moduleName =~ /^miscUtils/)
      { $maintPerson = "Kristi Luchini"; }
   elsif ($moduleName =~ /^highlandLVDTV/)
      { $maintPerson = "Arturo Alarcon"; }
   elsif ($moduleName =~ /^motor/)
      { $maintPerson = "Arturo Alarcon"; }
   elsif ($moduleName =~ /^restore/)
      { $maintPerson = "Stephanie Allison"; }
   elsif ($moduleName =~ /^devBusMapped/)
      { $maintPerson = "Till Straumann"; }
   elsif ($moduleName =~ /^micro/)
      { $maintPerson = "Diane Fairley"; }
   
   print HTMLFILE "</td><td>" . $maintPerson . "</td></tr>\n";
   return 1;
}
   
##################################################
# code start
#
##################################################
print ">>>moduleWebPage.pl\n";
if ($#ARGV < 0) { usage(); }
if ($ARGV[0] eq "help" || $ARGV[0] eq "HELP" || $ARGV[0] eq "Help") { usage(); } 

my $htmlFilename = $ARGV[0];

die ">>>ERROR:  Could not open $htmlFilename for write\n" unless (open(HTMLFILE, '>'.$htmlFilename));

if (!(defined $ENV{EPICS_MODULES_TOP}))
   { die "EPICS_MODULES_TOP is not defined; build will fail, so exiting now!\n"; }
else
   { $epicsModulesTop = $ENV{EPICS_MODULES_TOP}; }

die ">>>ERROR:  Directory $epicsModulesTop does not exist!\n" unless -d $epicsModulesTop;

# This version won't use a module list file
# It will start in EPICS_MODULES_TOP
# For each directory:
#   For each release
#     examine configure/RELEASE file to get dependencies
startHTMLFILE();

my $startDir = getcwd();
print (">>>Executing from " . $startDir . "\n");

# get all the module lines and process them 1 by 1
my $moduleLine;
my @moduleLines;

print "$epicsModulesTop\n";
opendir MODTOPDIR, $epicsModulesTop or die "couldnt open directory $epicsModulesTop\n";
@moduleLines = grep !/^\./, readdir MODTOPDIR;
closedir MODTOPDIR;
my @moduleLinesSorted = sort @moduleLines;

MODULE: foreach $moduleLine (@moduleLinesSorted)
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


    my $moduleDir = $epicsModulesTop . "/" . $moduleLine;
    if (!(-d $moduleDir))
       { print "$moduleDir not a directory\n"; next MODULE; }
      
#    opendir MODDIR, $moduleDir or die "couldnt open directory $moduleDir\n";
# TESTING - CONTINUE ANYWAY
opendir MODDIR, $moduleDir or die "couldnt open directory $moduleDir\n";
    @versions = grep !/^\./, readdir MODDIR;
    closedir MODDIR;
    my @versionsSorted = sort backwards @versions;

    VERSION: foreach $version (@versionsSorted)       
       { 
       my $moduleBuildDir =  $epicsModulesTop . "/" . $moduleName . "/" . $version;
       print ">>>" . $moduleBuildDir . "\n";

       if (!(-d $moduleBuildDir))
          { print ">>>$moduleBuildDir is not a directory\n"; next VERSION; }

       # search for dependencies in configure/RELEASE
       my $releaseConfigDir = $moduleBuildDir . "/configure";

       print "$moduleName  $version  $releaseConfigDir\n";
       addModuleToHTML($moduleName, $version, $releaseConfigDir);

       # return to starting point, in case of relative directory specification
       #chdir $startDir;
       }
       
   }
# now create order list
print "MODULES LIST:\n";
foreach my $mod ( keys %moduleHash )
    {
    print "MODULE: $mod\n";
    foreach my $dep (@{ $moduleHash{$mod} })
       { print "   $dep\n"; }
#   print "@{ $moduleHash{$mod} }\n";
    }

foreach my $mod ( keys %moduleHash )
    {
    print "MODULE: $mod\n";
    # use the ampersand to call this, otherwise the array is not 
    # passed correctly!!!
    &outputDependsOn (@{ $moduleHash{$mod} });
    my @modNames = split /\-/, $mod;
    my $modName = $modNames[0];
    if (!(modInList($modName)))
       { 
# TESTING 828
print "PUSHING $modName onto moduleOrderList\n";
       push @moduleOrderList, $modName; 
       }
    }


finishHTMLFILE();
outputModuleBuildOrder();
chdir $startDir;
close HTMLFILE;

print ">>>FINISHED with moduleWebPage\n";

