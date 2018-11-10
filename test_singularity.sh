singularity run \
--contain --cleanenv \
--bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
test.simg \
--outdir /OUTPUTS \
--t1_nii INPUTS/T1.nii.gz \
--project TESTPROJ \
--subject TESTSUBJ \
--session TESTSESS \
--scan TESTSCAN
