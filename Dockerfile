# Use an official PyTorch base image with CUDA and cuDNN support for GPU acceleration
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

# Set environment variables to avoid issues with apt installs
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/conda/bin:$PATH"

# Install necessary system packages and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    libsndfile1 \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda to manage Python environment
RUN curl -o ~/miniconda.sh -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install python=3.9 && \
    /opt/conda/bin/conda clean -ya

# Set working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the required Python packages using conda and pip
RUN conda install pytorch torchvision torchaudio cudatoolkit=11.7 -c pytorch -c conda-forge && \
    pip install --no-cache-dir -r requirements.txt

# Expose the necessary ports if needed
# EXPOSE 8080

# Set the entry point for the container
CMD ["bash"]
