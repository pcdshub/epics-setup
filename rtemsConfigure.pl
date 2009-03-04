#!/usr/bin/perl -w
use strict;
use File::Path;
use File::stat;
use File::Find;
use File::Copy;
use FileHandle;
use Cwd;

my @filelist;
my $makeParam = "";
my $epicsSiteTop;
my $epicsBaseVer;
my $rtemsSiteTop;
my $rtemsVer;
my $rtemsWhich;
my $rtemsCDTop;
my $rtemsLoc;

my @makeFileIncs;


sub usage()
{
        print "========================================================================\n";
        print "Usage:\n";
        print "rtemsConfigure.pl\n";
        print "========================================================================\n";
        print " These environment variables must be defined:\n";
        print "    RTEMS_SITE_TOP\n";
        print "    RTEMS_VER  (required format is rtems-versionnum, e.g. rtems-4.7.1)\n";
        print "========================================================================\n";
        print " Script calling example:\n";
        print "   rtemsConfigure.pl\n";
        print "========================================================================\n";
        exit;
}

sub confirmVars()
{
        print "---------------------------------------------------------\n";
        print "Will operate with these environment settings:\n";
        print "   RTEMS_SITE_TOP:  $rtemsSiteTop\n";
        print "   RTEMS_VER:       $rtemsVer\n";
        print "---------------------------------------------------------\n";

        print "Please enter go or GO to continue, any other key to EXIT NOW  ==> ";
        my $continue = <STDIN>;
        unless ($continue eq "GO\n" || $continue eq "go\n")
           { die "exiting now!\n" };
}


sub wanted
{
  # collect the full filename if it is Makefile.inc
  push @makeFileIncs, $File::Find::name if ($File::Find::name =~ /Makefile.inc$/);
}

sub modMakefileInc($$$)
{
   my $fName = shift;
   my $prefix = shift;
   my $execprefix = shift;
 
   if (!open (INP, $fName))
      { 
      print ">>>ERROR opening makefile $fName for reading\n"; 
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
      if ($line =~ /^\s*prefix\s*=\s*/)
         { print OUT "prefix = $prefix\n"; }
      elsif ($line =~ /exec_prefix\s*=\s*/)
         { print OUT "exec_prefix = $execprefix\n"; }
      else
         { print OUT $line; }
         
      }
         
   close OUT;
   return 1;

}

sub modMakefileIncSSRL($$$)
{
   my $fName = shift;
   my $rtemsWhich = shift;
   my $rtemsCDTop = shift;
 
   if (!open (INP, $fName))
      { 
      print ">>>ERROR opening makefile $fName for reading\n"; 
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

   my $whichFound = 0;
   my $rtemsCDTopFound = 0;
   foreach $line (@lines)
      {
      if ($line =~ /RTEMS_WHICH\s*=\s*/ && !($whichFound))
         { 
         # only replace the first one
         print OUT "RTEMS_WHICH = $rtemsWhich\n";  
         $whichFound = 1;
         }
      elsif ($line =~ /RTEMS_CD_TOP\s*=\s*/ && !($rtemsCDTopFound))
         { 
         # only replace the first one
         print OUT "RTEMS_CD_TOP = $rtemsCDTop\n";  
         $rtemsCDTopFound = 1;
         }
      else
         { print OUT $line; }
         
      }
         
         
   close OUT;
   return 1;

}



##################################################
# code start
#  no arguments
# lines starting with "#" are comments and are not processed
#
##################################################
print ">>>rtemsConfigure.pl\n";

# first check for arg of help
if ($#ARGV >= 0)
{ if ($ARGV[0] eq "help" || $ARGV[0] eq "HELP" || $ARGV[0] eq "Help" || $ARGV[0] eq "-help" || $ARGV[0] eq "-HELP" || $ARGV[0] eq "-Help" ) { usage(); } }

# first test to see if RTEMS_SITE_TOP is defined
if (!(defined $ENV{RTEMS_SITE_TOP}))
   { die ">>>RTEMS_SITE_TOP is not defined; exiting now!\n"; }
else
   { $rtemsSiteTop = $ENV{RTEMS_SITE_TOP}; }

if (!(defined $ENV{RTEMS_VER}))
   { die ">>>RTEMS_VER is not defined; build will fail, so exiting now!\n"; }
else
   { $rtemsVer = $ENV{RTEMS_VER}; }

confirmVars;

#extract rtemsWhich ("4.7.1") from rtemsVer ("rtems-4.7.1")
my @rtemsVerParts = split /-/, $rtemsVer;
$rtemsWhich = $rtemsVerParts[1];
#print "rtemsWhich = $rtemsWhich\n";
$rtemsCDTop = $rtemsSiteTop . "/" . $rtemsVer;
#print "rtemsCDTop = $rtemsCDTop\n";

if (!(defined $ENV{EPICS_HOST_ARCH}))
   { print ">>>WARNING:  EPICS_HOST_ARCH is not defined; subsequent build may generate ERRORS!\n"; }

$rtemsLoc = $rtemsSiteTop . "/" . $rtemsVer;

die ">>>ERROR:  rtems directory $rtemsLoc does not exist!\n" unless -d $rtemsLoc;

print ">>>RTEMS_SITE_TOP is $rtemsSiteTop\n";
print ">>>RTEMS_VER is $rtemsVer\n";
print ">>>\n";

my $startDir = getcwd();
print (">>>Executing from " . $startDir . "\n");
print ">>>\n";

print ">>>Modifying RTEMS Makefile.inc files\n";
my $rtemsDir = $rtemsSiteTop . "/" . $rtemsVer . "/target";
# prefix is the target dir
my $prefix = $rtemsDir;

# first set up the RTEMS Makefile.inc's
if (!(chdir $rtemsDir))
   { print ">>>ERROR doing cd to $rtemsDir\n"; }
else
   {
   # find all Makefile.inc's in the rtems target directory
   # and change prefix and exec_prefix and RTEMS_WHICH to be site-specific
   find(\&wanted, $rtemsDir); 
   foreach my $makeFileInc (@makeFileIncs)
      { 

      # one find result will look like this:
      # /usr/local/lcls/rtems/rtems-4.7.1/target/powerpc-rtems/psim/Makefile.inc

      print ">>>modifying:  $makeFileInc\n"; 
      # split the file and diretory into its components
      my @dirs = split /\//, $makeFileInc;
      # $#dirs has the subscript of the last element, n 
      # the n-2 item makes exec-prefix
      my $execprefix = $rtemsDir . "/" . $dirs[$#dirs-2];
      
      # then read through the Makefile.inc and replace prefix and exec-prefix.
      # except if it's ssrlApps, then do something a little different
      # replace RTEMS_WHICH instead.
      if ($makeFileInc =~ /ssrlApp/)
         { 
         print ">>>setting RTEMS_WHICH: $rtemsWhich\n";
         print ">>>setting RTEMS_CD_TOP: $rtemsCDTop\n";
         modMakefileIncSSRL($makeFileInc, $rtemsWhich, $rtemsCDTop); 
         }
      else
         { 
         print ">>>setting prefix: $prefix\n";
         print ">>>setting exec_prefix: $execprefix\n";
         modMakefileInc($makeFileInc, $prefix, $execprefix); 
         }
      }

   # return to starting point, in case of relative directory specification
   chdir $startDir;
   }
print ">>>FINISHED with RTEMS setup\n";
print ">>>\n";

