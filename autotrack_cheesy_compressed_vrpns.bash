#!/bin/bash

# WHAT DOES THIS SCRIPT DO?

extension=".vrpn"
rootdir=`pwd`;
autofindframename="frame0001.pgm"
findFLburst=$(find . -name '*FLburst*')
TRACKED_suffix="_TRACKED"

echo "The root directory is $rootdir"

echo
echo "findFLburst"
echo "--------"
echo "$findFLburst"
echo

# For each of the videos in the root directory...
for i in $findFLburst; do 

   mydate=`date`
   thisFLburstfile="$i/$autofindframename"
   thisvideofile="${i/FLburst/video}$TRACKED_suffix"
   thisbz2file="$thisvideofile$extension.bz2"
   thislogfile="$rootdir/${thisvideofile/.\//}"

   echo
   echo "Starting time for analyzing this tracking file: $mydate"   

   echo
   echo "TO DO list..."
   echo "  Finding beads in FLburst file:    $thisFLburstfile"
   echo "  Decompressing this tracking file: $thisbz2file"
   echo "  Tracking begins in this video:    $thisvideofile$extension"
   echo "  Tracking logfile will be set to:  $thislogfile$extension$extension"
   echo

   echo
   echo "Converting the auto find frame to a background context image for later use in evt_GUI"
   convert -verbose $thisFLburstfile $thislogfile.0001.bmp

   echo
   echo "Decompressing zipped video file"
   bzip2 -dvk $thisbz2file

   echo
   echo "Copying over support files for Video Spot Tracker (temporary and deleted later)"
   cp -vn ~/bin/russ_widgets.tcl ~/bin/video_spot_tracker.tcl $rootdir

   #
   # Parameter list for Run_VST
   # $0 is the name of the calling script (here "~/bin/Run_my_VST_cheesy_compressed")
   # $1 is the filename containing the first 'video' (frame) that's used for identifying/finding beads (e.g. fluo_burst)
   # $2 is the name of the second video (in which to to track beads)
   # $3 is the name of the tracking file that will be saved at the output
   #
   echo 
   echo "Running Video Spot Tracker on Compressed video file"
   ~/bin/Run_my_VST_cheesy_compressed.bash $thisFLburstfile $thisvideofile$extension $thislogfile
   
   echo 
   echo "Deleting VST support files we no longer need"
   rm $rootdir/russ_widgets.tcl $rootdir/video_spot_tracker.tcl
   
   echo
   echo "Deleting uncompressed video (and keeping compressed bz2 file)"
   rm $thisvideofile$extension

#   read -rsp $'Press any key to continue...\n' -n1 key
   cd $rootdir
done

echo
echo "Done!"


