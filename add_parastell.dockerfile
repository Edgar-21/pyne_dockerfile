FROM ejpflug/openmc_chtc:12

# Install base utilities
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir h5py
RUN pip install --no-cache-dir netcdf4

WORKDIR /opt

RUN git clone https://github.com/svalinn/parastell.git
ENV PYTHONPATH=$PYTHONPATH:/opt/parastell

# Install PyStell-UW
RUN git clone https://github.com/aaroncbader/pystell_uw.git
ENV PYTHONPATH=$PYTHONPATH:/opt/pystell_uw

WORKDIR /