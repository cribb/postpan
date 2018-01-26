#!/bin/bash

# Parameter list for Run_VST
# $0 
# $1 is the filename containing the first 'video' (frame) that's used for identifying/finding beads (e.g. fluo_burst)
# $2 is the name of the second video (in which to to track beads)
# $3 is the name of the tracking file that will be saved at the output

extension="_TRACKED.vrpn"
rootdir=`pwd`;
autoframename="autofind_frame.pgm"
startframename="frame0001.pgm"; 
findlist=$(find . -name $startframename)

echo
echo "findlist"
echo "--------"
echo "$findlist"
echo


# echo "The root directory is $rootdir"



for i in $(find . -name $startframename); do 

   thisvideodir=$(dirname $i)
   
   cp -vn $thisvideodir/$startframename $thisvideodir/$autoframename   
   
   abs_autoframename="$rootdir/${thisvideodir/.\//}/$autoframename"
   abs_startframename="$rootdir/${thisvideodir/.\//}/$startframename"
   logname="$rootdir/${thisvideodir/.\//}" 

#   convert $abs_startframename $logname.0001.bmp

# only track those files which do not already have tracking files   
if [ ! -e $logname$extension ]; then

   echo "autoframe:      $abs_autoframename"   
   echo "starting frame: $abs_startframename"
   echo "Tracking logfile will be: $logname$extension"
   echo 
   date
   echo
   echo
   
   cp ~/bin/russ_widgets.tcl ~/bin/video_spot_tracker.tcl $rootdir

   # track the video
  ~/bin/Run_my_VST $abs_autoframename $abs_startframename $logname"_TRACKED"

   # convert .vrpn to .vrpn.mat
   ~/bin/Run_VrpnLogToMatlab $logname$extension

   # remove VST support files
   rm $rootdir/russ_widgets.tcl $rootdir/video_spot_tracker.tcl

fi   

# If one does not already exist, generate a mip file from the stack
   if [ ! -e $logname.mip.pgm ]; then
      echo ""$logname".mip.pgm does not exist.";
      
      echo "Creating mip for "$logname"";

      env MAGICK_TMPDIR=/data-sdd/cribb/datatmp nice -5 convert -limit memory 1GiB -limit map 1GiB $logname/*.pgm -evaluate-sequence Max $logname.mip.pgm
      
      echo;      
   fi

#   read -rsp $'Press any key to continue...\n' -n1 key
   cd $rootdir
done


