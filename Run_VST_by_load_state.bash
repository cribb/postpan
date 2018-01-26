#!/bin/bash

echo "Run_VST with parameters $0 $1 $2 $3"
# $1 is the burst image 
# $2 is the first frame of the video (e.g. frame0001.pgm) or the video filename itself
# $3 is the path where the output file will be located
#



wd=`pwd`
vst_dir="/cygdrive/c/Program Files/CISMM/video_spot_tracker_v08.01"
video_spot_tracker="video_spot_tracker.exe"
config_dir="/cygdrive/c/Users/phoebelee/Desktop"
config_file="testconfig.cfg"

state="$config_dir"/"$config_file"

# Set return value to 254(-2 in C code)
export RET=254

echo
echo "Finding beads in first video ($1)..."
while [ $RET -eq 254 ]
do
  "$vst_dir"/"$video_spot_tracker" -load_state $state -tracker 0 0 $r -outfile "$3"_tmp "$1"
  let "RET=$?"
done


echo
echo "Tracking resulting beads in second video ($2)..."



# set up for fluorescence in Panoptes
echo
ls "$3"_tmp*
echo

"$vst_dir"/"$video_spot_tracker" -log_video 300 -lost_behavior 1 -load_state  $state -maintain_fluorescent 0 -tracker 0 0 $r -continue_from "$3"_tmp.csv -outfile "$3" "$2"

# Delete temporary files 
rm -f "$3"_tmp.csv
rm -f "$3"_tmp.vrpn

echo "Done tracking!"

