# https://github.com/Spectator-Health/openpose-docker 
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

RUN echo "Installing dependencies..." && \
	apt-get -y --no-install-recommends update && \
	apt-get -y --no-install-recommends upgrade && \
	apt-get install -y --no-install-recommends \
	wget \
	vim \
	build-essential \
	cmake \
	git \
	libatlas-base-dev \
	libprotobuf-dev \
	libleveldb-dev \
	libsnappy-dev \
	libhdf5-serial-dev \
	protobuf-compiler \
	libboost-all-dev \
	libgflags-dev \
	libgoogle-glog-dev \
	liblmdb-dev \
	pciutils \
	python3-setuptools \
	python3-dev \
	python3-pip \
	opencl-headers \
	ocl-icd-opencl-dev \
	libviennacl-dev \
	libcanberra-gtk-module \
	libopencv-dev && \
	python3 -m pip install \
	numpy \
	protobuf \
	opencv-python3 \ 
	opencv-contrib-python

# Replace CMake as old version has CUDA variable bugs
RUN echo "Downloading and buiiding CMake..." && \
	wget https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-Linux-x86_64.tar.gz && \
	tar xzf cmake-3.16.0-Linux-x86_64.tar.gz -C /opt && \
	rm cmake-3.16.0-Linux-x86_64.tar.gz
ENV PATH="/opt/cmake-3.16.0-Linux-x86_64/bin:${PATH}"

RUN echo "Downloading and building OpenPose with Python support..." && \
	git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git && \
	mkdir -p /openpose/build && \
	cd /openpose/build && \
	cmake -DBUILD_PYTHON=ON .. && \
	make -j`nproc` && \
	wget -P /openpose/models/pose/coco/ https://github.com/foss-for-synopsys-dwc-arc-processors/synopsys-caffe-models/raw/master/caffe_models/openpose/caffe_model/pose_iter_440000.caffemodel

WORKDIR /openpose
