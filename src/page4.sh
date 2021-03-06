#!/bin/sh
#
# Page 4, hippocampus/brainstem

# Working directory
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# mri directory
MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri



##########################################################################
# Hipp snaps

# Get RAS mm coords of region centroid
# https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems
#    17   L hippocampus
#    53   R hippocampus
RASL=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 16.5 -u 17.5 -c`
RASR=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 52.5 -u 53.5 -c`

# View selected slices on T1, with surfaces
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/lh.hippoAmygLabels-T1.v21.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 2.5 --viewport sag \
    -ras ${RASL} \
    -ss "${TMP}"/Lhipp_sag.png

freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/rh.hippoAmygLabels-T1.v21.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 2.5 --viewport sag \
    -ras ${RASR} \
    -ss "${TMP}"/Rhipp_sag.png



##########################################################################
# Brainstem snaps

# Get RAS mm coords of region centroid
# https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems
#    16   brainstem
RAS=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 15.5 -u 16.5 -c`

# View selected slices on T1, with surfaces
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/brainstemSsLabels.v12.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 2.5 --viewport sagittal \
    -ras ${RAS} \
    -ss "${TMP}"/brainstem_sag.png

freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/brainstemSsLabels.v12.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 2.5 --viewport coronal \
    -ras ${RAS} \
    -ss "${TMP}"/brainstem_cor.png



##########################################################################
# Join up
cd "${TMP}"

montage -mode concatenate \
Lhipp_sag.png Rhipp_sag.png brainstem_sag.png brainstem_cor.png \
-tile 2x -quality 100 -background black -gravity center \
-trim -border 10 -bordercolor black -resize 300x page4.png

convert page4.png \
-background white -resize 1194x1479 -extent 1194x1479 -bordercolor white \
-border 15 -gravity SouthEast -background white -splice 0x15 -pointsize 24 \
-annotate +15+10 "$(date)" \
-gravity SouthWest -annotate +15+10 \
"`cat $FREESURFER_HOME/build-stamp.txt`" \
-gravity NorthWest -background white -splice 0x60 -pointsize 24 -annotate +15+0 \
'FreeSurfer segmentBS.sh' \
-gravity NorthWest -background white -splice 0x60 -pointsize 24 -annotate +15+10 \
'FreeSurfer segmentHA_T1.sh' \
-gravity NorthEast -pointsize 24 -annotate +15+10 \
"${SUBJECT}" \
page4.png
