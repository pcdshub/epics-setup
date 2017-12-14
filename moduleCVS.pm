package moduleCVS;

use strict;
use File::Path;
use File::stat;
use FileHandle;
use Cwd;

my @filelist;
my $moduleListFileName;
my $myModulesTop;

sub doCVSOperation ($$$)
{
##################################################
# code start
# this package is called by moduleCheckouter and
# moduleExporter.  It cd's to a modules top dir,
# and then reads through the ModuleList file.
# For each module it:
#   - creates a subdirectory names moduleName
#   - does a cvs command (checkout or export)
#     for each version listed.
#
#  the arguments are (for now):
#   1. the directory to cd to before CVS-ing
#   2. filename of modules list to act on of this format:
#     moduleName moduleVersion1 moduleVersion2 ...
#
# lines starting with "#" are comments and are not processed
#
##################################################

my $cvsOperation = shift;
#print ">>>CVS operation to do is $cvsOperation\n";
my $myModulesTop = shift;
my $moduleListFileName = shift;

if (!open(MODULELIST, $moduleListFileName))
   { print ">>>ERROR:  Could not open $moduleListFileName\n"; return 0; }

# get all the module lines and process them 1 by 1
my @moduleLines = <MODULELIST>;
my $moduleLine;

if (!(chdir $myModulesTop))
   { print ">>>ERROR doing cd to $myModulesTop\n"; return 0; }

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

      my $moduleDirErr = 0;
      my $currVersion = 0;
      my $moduleName;
      my $version;
      foreach $version (@versions)       
          { 
          # module name is the first item on the line
          if ($currVersion == 0)
             { 
             # make sure I'm at modulesTop
             if (!(chdir $myModulesTop)) 
                { 
                print ">>>ERROR doing cd to $myModulesTop\n"; 
                $moduleDirErr = 1;
                }
             else
                {
                # if a directory for the module doesn't exist already, mkdir it
                $moduleName = $version;
                if (!(-d $moduleName))
                   {
                   if (!(mkdir $moduleName)) 
                      { 
                      # if the module directory can't be created, then forget this module
                      # and continue to the next one in the file.
                      print ">>>ERROR mkdir-ing $moduleName!!!\n"; 
                      $moduleDirErr = 1; 
                      }
                      
                   }

                # and chdir into it
                if (!$moduleDirErr) 
                   { chdir $moduleName; }
                }
             }
          else
             { 
             # otherwise this is a version: checkout the version
             # (unless there's a problem with the module directory somehow)
             if (length($version) > 0 && !$moduleDirErr)
                { 
                my $CVSCmd = $cvsOperation . " -r " . $version . " -d " . $version . " " . $moduleName;
                print ">>>CVS command: $CVSCmd\n";
                my $sysErr = system($CVSCmd);
                
                if ($sysErr > 0)
                   { print ">>>ERROR $sysErr doing $CVSCmd\n"; }
                }
             }
          ++$currVersion;
          }
       if ($#versions == 0)
          {
          # no explicit version specified: checkout the head
          chdir $myModulesTop . "/" . $moduleName ; 
          my $CVSCmd = $cvsOperation . " -d HeadVer " . $moduleName;
          print ">>>CVS command: $CVSCmd\n";
          my $sysErr = system($CVSCmd);
               
          if ($sysErr > 0)
             { print ">>>ERROR $sysErr doing $CVSCmd\n"; }

          chdir $myModulesTop ; 
          }
      }
   }
 
close MODULELIST;
return 1;
}
1;
