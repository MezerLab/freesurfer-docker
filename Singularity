Bootstrap: docker
From: centos:7.5.1804

%help

Freesurfer recon-all pipeline with thalamic segmentation module

%files
  # Freesurfer development version. Download manually and reference a local copy
  # https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/dev/freesurfer-linux-centos7_x86_64-dev.tar.gz
  freesurfer-linux-centos7_x86_64-dev.tar.gz /usr/local
  src/run_freesurfer.sh /

%post
  
  # Install Freesurfer
  cd /usr/local
  tar -zxf freesurfer-linux-centos7_x86_64-dev.tar.gz
  rm freesurfer-linux-centos7_x86_64-dev.tar.gz
  
  # Example of binding FS license file:
  # https://github.com/bud42/dax-processors/blob/master/FS6_v1.2.0_processor.yaml
  # --bind freesurfer_license.txt:/usr/local/freesurfer/license.txt

  # Create input/output directories for binding
  mkdir /INPUTS && mkdir /OUTPUTS

%environment
  export FREESURFER_HOME=/usr/local/freesurfer
  source $FREESURFER_HOME/SetUpFreeSurfer.sh

%runscript
  bash /run_freesurfer.sh "$@"



  #xvfb-run --server-num=$(($$ + 99)) \
  #--server-args='-screen 0 1600x1200x24 -ac +extension GLX' \
  #bash \
  #"$@"
