FROM ghcr.io/pyne/pyne_ubuntu_22.04_py3_hdf5/pyne-dev 

ENV HOME=/root

RUN mkdir -p $HOME/root/openmc/build && \
    cd $HOME/root/openmc && \
    git clone --recurse-submodules https://github.com/openmc-dev/openmc.git && \
    cd build && \
    cmake ../openmc \
    -DCMAKE_INSTALL_PREFIX=$HOME/opt/openmc \
    -DOPENMC_USE_DAGMC=ON \
    -DDAGMC_ROOT=$HOME/opt/dagmc \
    -DCMAKE_BUILD_TYPE=Release .. && \
    make install -j18

RUN	cd $HOME/root/openmc/openmc && \
    python -m pip install .

ENV PATH=/root/opt/openmc/bin:$PATH

RUN chmod -R 777 /root
RUN chmod -R 777 /usr
RUN chmod -R 777 /sbin

RUN pip install --no-cache-dir progress
RUN pip install --no-cache-dir vtk
RUN pip install --no-cache-dir openmc-plasma-source
RUN pip install --no-cache-dir PyYAML

WORKDIR "/root"
RUN wget -O fendl.xz https://anl.box.com/shared/static/3cb7jetw7tmxaw6nvn77x6c578jnm2ey.xz 
RUN tar -xf fendl.xz
RUN rm -f fendl.xz
RUN echo 'export OPENMC_CROSS_SECTIONS=/root/fendl-3.2-hdf5/cross_sections.xml' >> ~/.bashrc
RUN git clone --single-branch -b add_toroidal_model https://github.com/Edgar-21/radial_build_tools.git
ENV PYTHONPATH=/root/radial_build_tools

RUN chmod -R 777 /root

WORKDIR "/"