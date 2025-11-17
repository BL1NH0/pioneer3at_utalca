FROM osrf/ros:noetic-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias (del tutorial)
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    make \
    g++ \
    doxygen \
    swig \
    default-jdk \
    python3-dev \
    python3-catkin-tools \
    ros-noetic-rqt-robot-steering \
    ros-noetic-rqt \
    ros-noetic-rqt-common-plugins \
    ros-noetic-xacro \
    ros-noetic-robot-state-publisher \
    gazebo11 \
    ros-noetic-gazebo-ros \
    ros-noetic-gazebo-ros-pkgs \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario
RUN useradd -m -s /bin/bash rosuser && \
    echo "rosuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER rosuser
WORKDIR /home/rosuser

# Crear workspace
RUN mkdir -p pioneer3at_utalca/src
WORKDIR /home/rosuser/pioneer3at_utalca/src

# Clonar paquetes estándar desde GitHub
RUN git clone https://github.com/amor-ros-pkg/rosaria.git
RUN git clone https://github.com/reedhedges/AriaCoda.git

# Copiar SOLO tu paquete simulacion personalizado
COPY --chown=rosuser:rosuser src/simulacion /home/rosuser/pioneer3at_utalca/src/simulacion

# Compilar AriaCoda
WORKDIR /home/rosuser/pioneer3at_utalca/src/AriaCoda
USER root
RUN make && make install
USER rosuser

# Variables de entorno
ENV LD_LIBRARY_PATH=/home/rosuser/pioneer3at_utalca/src/AriaCoda/lib:/usr/local/lib:$LD_LIBRARY_PATH
ENV GAZEBO_MODEL_PATH=/home/rosuser/pioneer3at_utalca/src/simulacion/gazebo/models:$GAZEBO_MODEL_PATH

# Compilar workspace
WORKDIR /home/rosuser/pioneer3at_utalca
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# Configurar bashrc
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "source /home/rosuser/pioneer3at_utalca/devel/setup.bash" >> ~/.bashrc && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/home/rosuser/pioneer3at_utalca/src/AriaCoda/lib:/usr/local/lib" >> ~/.bashrc && \
    echo "export GAZEBO_MODEL_PATH=\$GAZEBO_MODEL_PATH:/home/rosuser/pioneer3at_utalca/src/simulacion/gazebo/models" >> ~/.bashrc

CMD ["/bin/bash"]
