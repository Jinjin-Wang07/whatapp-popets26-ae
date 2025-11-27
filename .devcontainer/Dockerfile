FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install Python and essential packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    curl \
    wget \
    git \
    vim \
    nano \
    iproute2 \
    software-properties-common \
    tmux \
    iperf3 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    python3 -m pip install --upgrade pip

# Install specific Python packages with required versions
RUN pip install --no-cache-dir\
    numpy==1.24.3 \
    python-dateutil==2.8.2 \
    pandas==1.4.3 \
    matplotlib==3.5.2 \
    seaborn==0.13.2 \
    scikit-learn==1.6.1 \
    jupyter \
    ipython==8.15.0 \
    keras==2.15.0 \
    tensorflow==2.15.0 \
    tqdm

RUN pip install --no-cache-dir\
    torch==1.12.1+cpu \
    torchvision==0.13.1+cpu \
    --index-url https://download.pytorch.org/whl/cpu

# srsRAN requirements
RUN apt-get install -y \
    build-essential \
    cmake \
    libfftw3-dev \
    libmbedtls-dev \
    libboost-program-options-dev \
    libconfig++-dev \
    libsctp-dev \
    libzmq3-dev

# UHD drivers for USRP
RUN add-apt-repository ppa:ettusresearch/uhd && \
    apt update && apt -y install libuhd-dev uhd-host && \
    uhd_images_downloader && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspaces

# Fetch the fingerprinting defense code
RUN git clone https://github.com/Jinjin-Wang07/whatapp-pdcp-defense.git && \
    cd whatapp-pdcp-defense && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make -j"$(( $(nproc) - 1 ))"

# Fetch the fingerprinting attack code
RUN git clone https://github.com/Jinjin-Wang07/whatapp-app-fingerprinting.git fingerprinting

# Download and extract PDCP dataset
COPY whatapp-pdcp-dataset.tar.gz /tmp/whatapp-pdcp-dataset.tar.gz
RUN mkdir -p /dataset/raw && \
    tar -xzf /tmp/whatapp-pdcp-dataset.tar.gz -C /dataset/raw && \
    rm /tmp/whatapp-pdcp-dataset.tar.gz

COPY 2_run_attack_models.sh /workspaces/2_run_attack_models.sh
COPY 3_run_defense_demo.sh /workspaces/3_run_defense_demo.sh
COPY env_test.sh /workspaces/env_test.sh

# wget -O /tmp/whatapp-pdcp-dataset.tar.gz "https://zenodo.org/records/17722145/files/whatapp-pdcp-dataset.tar.gz?download=1&preview=1" 
    
    # && \
    # tar -xzf /tmp/whatapp-pdcp-dataset.tar.gz -C /dataset/raw && \
    # rm /tmp/whatapp-pdcp-dataset.tar.gz && \
    # echo "Dataset extracted to /dataset/raw"