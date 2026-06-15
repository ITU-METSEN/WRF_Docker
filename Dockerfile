FROM --platform=linux/amd64 ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

RUN apt-get update && apt-get install -y \
    sudo wget curl git neovim eza \
    file build-essential csh gfortran m4 perl \
    libpng-dev netcdf-bin libnetcdff-dev libopenmpi-dev libhdf5-openmpi-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*


RUN userdel -r ubuntu && \
    useradd -m -u 1000 -s /bin/bash wrfuser && \
    echo "wrfuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER wrfuser
WORKDIR /home/wrfuser


RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /home/wrfuser/miniconda && \
    rm ~/miniconda.sh
ENV PATH="/home/wrfuser/miniconda/bin:$PATH"

RUN conda init bash
RUN conda install -n base -c conda-forge --override-channels conda-anaconda-tos -y && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
RUN conda install -n base conda-libmamba-solver -y && \
    conda config --set solver libmamba

RUN conda create -n pywrf -c conda-forge --override-channels -y python=3.11 wrf-python netcdf4 cartopy matplotlib xarray metpy "geopandas>=0.14" && \
    conda run -n pywrf pip install "cdsapi>=0.7.7"

RUN mkdir -p /home/wrfuser/wrf_data /home/wrfuser/WPS_GEOG && \
    chown -R wrfuser:wrfuser /home/wrfuser/wrf_data /home/wrfuser/WPS_GEOG

RUN git clone https://github.com/HathewayWill/WRF_Python_Scripts.git
RUN curl -fsSL -o WRF4.8.0_Install.bash https://raw.githubusercontent.com/ITU-METSEN/WRF_Docker/master/scripts/WRF4.8.0_Install.bash \
    && chmod +x WRF4.8.0_Install.bash
RUN ./WRF4.8.0_Install.bash -arw

COPY --chown=wrfuser:wrfuser entrypoint.sh /home/wrfuser/entrypoint.sh
RUN chmod +x /home/wrfuser/entrypoint.sh
ENTRYPOINT ["/home/wrfuser/entrypoint.sh"]


RUN echo "alias ls='eza -l --color=always --group-directories-first --icons=always \$@ --git'" >> /home/wrfuser/.bashrc && \
    echo "alias la='eza -la --color=always --group-directories-first --icons=always \$@ --git'" >> /home/wrfuser/.bashrc && \
    echo "alias ll='eza -l --color=always --group-directories-first --icons=always \$@ --git'" >> /home/wrfuser/.bashrc && \
    echo "alias lt='eza -aT --color=always --group-directories-first --icons=always \$@ --git'" >> /home/wrfuser/.bashrc && \
    echo "alias l.='eza -a | grep -e \"^\.\"' " >> /home/wrfuser/.bashrc && \
    echo "alias c='clear'" >> /home/wrfuser/.bashrc && \
    echo "alias vim='nvim'" >> /home/wrfuser/.bashrc
