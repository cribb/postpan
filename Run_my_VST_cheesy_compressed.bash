#!/bin/bash

# Expected input arguments for this script:
#   $0 names the calling script
#   $1 is the burst image 
#   $2 is the first frame of the video (e.g. frame0001.pgm) or the video filename itself
#   $3 is the path where the output file will be located
#

wd=`pwd`
extension=".vrpn"

vst_dir="/home/cribb/bin"
# video_spot_tracker="video_spot_tracker_CUDA_v8p01-regionsize"
video_spot_tracker="video_spot_tracker_nogui_v8p01-regionsize"

config_dir="/home/cribb/bin"
config_file="VST_cheesy_compressed.cfg"
state=""$config_dir"/"$config_file""

temptraj="$3"_tmp$extension
trajoutfile="$3"$extension

# pulls out the radius value from the cfg file. 
rline=( `grep -i "set radius" $state` ) 
r=${rline[2]}

# Set return value to 254(-2 in C code)
export RET=254

echo
echo "Run_VST with parameters..." # $0 $1 $2 $3
echo "  This tracking script called by: $0"
echo "  Autofind (burst) image:         $1"
echo "  First frame of video:           $2"
echo "  Trajectory data saved to:       $3"
echo 

echo
echo "Finding beads in first video..."
while [ $RET -eq 254 ]
do
  "$vst_dir"/"$video_spot_tracker" -nogui -enable_internal_values -lost_all_colliding_trackers -load_state $state -tracker 0 0 $r -outfile $temptraj "$1"
  let "RET=$?"
done


echo
echo "Tracking resulting beads in second video ($2)..."
echo "Saving trajectories to file: $trajoutfile"
echo
"$vst_dir"/"$video_spot_tracker" -nogui -enable_internal_values -lost_all_colliding_trackers -load_state $state -maintain_fluorescent_beads 0 -log_video 300   -tracker 0 0 $r -continue_from "$temptraj".csv -outfile $trajoutfile "$2"


# Delete temporary files 
rm -f "$temptraj".csv
rm -f "$temptraj"_tmp.vrpn.vrpn

echo
echo "Done tracking!"

