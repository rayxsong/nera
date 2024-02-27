#!/bin/bash

# Update and install build-essential
sudo apt-get update
sudo apt-get install -y build-essential

# Download and install CUDA
wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda_12.3.2_545.23.08_linux.run
sudo sh cuda_12.3.2_545.23.08_linux.run --silent --toolkit

# Download and install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -u

# Add Miniconda to PATH in .zshrc
echo 'export PATH="~/miniconda3/bin:$PATH"' >> ~/.zshrc

# Source .zshrc to update environment
source ~/.zshrc

# Initialize Conda
conda init

# Source .bashrc to update environment
source ~/.bashrc

# Create a new Conda environment
conda vera create -f environment.yml
conda activate vera