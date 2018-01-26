#!/bin/bash

# inpute parameters
# $0 name of script
# $1 path of original dataset

# compute mips
# insert the calibration data into the ExperimentConfig file
# copy everything but original video to 'novideo' directory
# move to new 'novideo' directory
# zip up the new "novideo" directory as a backup and put in parent directory of novideo direction (this zip file represents the closest to original PanopticNerve run output, i.e. only the video has been deleted)
# rename FLburst files with the directory name instead of image0001.pgm
# remove FLburst directories
# remove empty directories (*video*) where the video is deleted
# remove .vrpn and .vrpn.mat files


# This directory is where ImageMagick stores its temporary files and can be changed so long as the directory exists
MAGICK_TMPDIR=/data-sdd/cribb/datatmp 

DATAPATH="$1"
NOVIDPATH="$DATAPATH_novideo"
EXPTFILE=`ls *ExperimentConfig*`
CALIBFILE="/home/cribb/bin/monoptes_lengthscales.txt"

cd $DATAPATH

# compute mips
echo find . -type d -iname "*video*" -exec env MAGICK_TMPDIR=$MAGICK_TMPDIR nice -5 convert -limit memory 1GiB -limit map 1GiB {}/*.pgm -evaluate-sequence Max {}.mip.pgm \;

# Insert calibration data into the ExperimentConfig file
awk 'NR==FNR{bfile = bfile $0 RS; next} /wells /{printf "%s", bfile} {print}' $CALIBFILE $EXPTFILE > $EXPTFILE

echo find ../$DATAPATH -depth ! -iname *.pgm -print0 | echo cpio -0pdv --quiet ../$NOVIDPATH


