FROM osrf/ros:noetic-desktop-full

# Instalar dependencias adicionales
RUN apt-get update && apt-get install -y \
    python3-catkin-tools \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential \
    git \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio de workspace
WORKDIR /root/catkin_ws

# Copiar el código fuente
COPY src/ /root/catkin_ws/src/

# Inicializar rosdep y instalar dependencias
RUN apt-get update && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y && \
    rm -rf /var/lib/apt/lists/*

# Compilar el workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# Configurar el entrypoint
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
    echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

# Establecer el workspace como directorio de trabajo
WORKDIR /root/catkin_ws

CMD ["bash"]
