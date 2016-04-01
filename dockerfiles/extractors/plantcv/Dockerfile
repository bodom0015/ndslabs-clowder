FROM ncsa/clowder-extractors-python-base
MAINTAINER Yan Y. Liu <yanliu@illinois.edu>

#TODO: change extractor home to plantcv after code merge
ENV CLOWDER_HOME=/home/clowder \
    EXTRACTOR_HOME=/home/clowder/extractors-plantcv/plantcv \
    RABBITMQ_URI="" \
    RABBITMQ_EXCHANGE="clowder" \
    PYTHONPATH="${CLOWDER_HOME}/opencv/lib/python2.7/dist-packages:${CLOWDER_HOME}/plantcv/lib:/usr/lib/python2.7/dist-packages:${PYTHONPATH}" \
    PATH="${CLOWDER_HOME}/opencv/bin:${PATH}" \
    LD_LIBRARY_PATH="${CLOWDER_HOME}/opencv/lib:${LD_LIBRARY_PATH}"

USER root

### plantcv part: start
# Install prerequisites
RUN apt-get -qq update && \
    apt-get -qq install -y \
      wget \
      git \
      imagemagick \
      build-essential \
      unzip \
      cmake \
      libgtk2.0-dev \
      python-dev \
      python-numpy \
      python-gtk2 \
      python-matplotlib \
      libavcodec-dev \
      libavformat-dev \
      libswscale-dev \
      libdc1394-22 \
      libjpeg-dev \
      libpng-dev \
      libjasper-dev \
      libtiff-dev \
      libtbb-dev \
      sqlite3 \
      python-opencv \
      opencv-data && \
    pip install wheel matplotlib && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER clowder

# Install opencv from source
RUN cd ${CLOWDER_HOME} && \
    mkdir software && \
    git clone -q --depth=1 --single-branch --branch 2.4.8 https://github.com/Itseez/opencv.git software/opencv && \
    mkdir -p software/opencv/build && \
    cd software/opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=${CLOWDER_HOME}/opencv -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON .. && \
    make -j10 && \
    make install && \
    rm -rf software/opencv

# Clone necessary source respoitories
RUN cd ${CLOWDER_HOME} && \
    git clone -q --depth=1 --single-branch https://github.com/danforthcenter/plantcv.git && \
    git clone -q --depth=1 --single-branch https://opensource.ncsa.illinois.edu/bitbucket/scm/cats/extractors-plantcv.git && \
    rm -rf plantcv/.git && \
    rm -rf extractors-plantcv/.git

# Prepare output folder
RUN cd ${CLOWDER_HOME}/ && \
    mkdir -p plantcv-output && \
    mkdir -p data/Lemnatec-Indoor && \
    wget -o data/Lemnatec-Indoor/NIR_SV_90_z2500_338998.jpg http://datastore2.cigi.illinois.edu:8008/webdata/arpae/Lemnatec-Indoor/NIR_SV_90_z2500_338998.jpg && \
    wget -o data/Lemnatec-Indoor/VIS_SV_180_z700_379476.jpg  http://datastore2.cigi.illinois.edu:8008/webdata/arpae/Lemnatec-Indoor/VIS_SV_180_z700_379476.jpg && \
    wget -o data/Lemnatec-Indoor/VIS_TV_z3000_329934.jpg  http://datastore2.cigi.illinois.edu:8008/webdata/arpae/Lemnatec-Indoor/VIS_TV_z3000_329934.jpg

# Copy the source and execute the helper script
COPY . ${EXTRACTOR_HOME}/
WORKDIR ${EXTRACTOR_HOME}
CMD ["./start.sh"]


