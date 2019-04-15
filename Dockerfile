From centos:7.5.1804

# For installs
RUN yum -y install unzip wget

# For Freesurfer
RUN yum -y install tcsh bc mesa-libGLU libgomp perl mesa-dri-drivers libicu

# For FSL
RUN yum -y install epel-release
RUN yum -y install openblas-devel

# For matlab runtime
RUN yum -y install java-1.8.0-openjdk

# For X
RUN yum -y install xorg-x11-server-Xvfb xorg-x11-xauth which

# For PDF outputs
RUN yum -y install ImageMagick

# Python modules
RUN yum -y install python-pip
RUN pip install pandas numpy

# We need a piece of FSL (fslstats)
RUN wget -nv https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.0-centos7_64.tar.gz
RUN tar -zxf fsl-6.0.0-centos7_64.tar.gz
RUN mkdir -p /usr/local/fsl/bin
RUN cp fsl/bin/fslstats /usr/local/fsl/bin
RUN rm -r fsl fsl-6.0.0-centos7_64.tar.gz

# Matlab runtime for brainstem, hippocampus, thalamus modules
RUN wget -nv -P /opt http://ssd.mathworks.com/supportfiles/downloads/R2014b/deployment_files/R2014b/installers/glnxa64/MCR_R2014b_glnxa64_installer.zip
RUN unzip -q /opt/MCR_R2014b_glnxa64_installer.zip -d /opt/MCR_R2014b_glnxa64_installer
RUN /opt/MCR_R2014b_glnxa64_installer/install -mode silent -agreeToLicense yes
RUN rm -r /opt/MCR_R2014b_glnxa64_installer
RUN rm /opt/MCR_R2014b_glnxa64_installer.zip

# Install Freesurfer
# Make our own build stamp since FS dev seems to not provide it sometimes
RUN wget -nv -P /usr/local https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/dev/freesurfer-linux-centos7_x86_64-dev.tar.gz
WORKDIR /usr/local
RUN tar -zxf freesurfer-linux-centos7_x86_64-dev.tar.gz
RUN md5sum freesurfer-linux-centos7_x86_64-dev.tar.gz > freesurfer/build-hash.txt
RUN rm freesurfer-linux-centos7_x86_64-dev.tar.gz
WORKDIR /usr/local/freesurfer
RUN H=$(cat build-hash.txt)
RUN echo ${H% freesurfer-linux-centos7_x86_64-dev.tar.gz} > build-hash.txt
RUN cat build-hash.txt build-stamp.txt > build-info.txt

# Freeview needs a machine id here
RUN dbus-uuidgen > /etc/machine-id

# Tell freesurfer where to find the MCR
RUN ln -s /usr/local/MATLAB/MATLAB_Compiler_Runtime/v84 /usr/local/freesurfer/MCRv84

# Create input/output directories for binding
RUN mkdir /INPUTS && mkdir /OUTPUTS


# FSL (we only use fslstats so no need for the full setup)
ENV FSLOUTPUTTYPE NIFTI_GZ

# Freesurfer
ENV FREESURFER_HOME /usr/local/freesurfer
RUN source $FREESURFER_HOME/SetUpFreeSurfer.sh

