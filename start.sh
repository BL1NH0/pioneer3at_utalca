#!/bin/bash

echo "🤖 Pioneer 3-AT ROS Noetic Docker Environment"
echo "=============================================="

# Permitir conexiones X11
xhost +local:docker

# Iniciar el contenedor
docker-compose up -d

# Entrar al contenedor
docker exec -it pioneer3at_ros bash

# Cleanup al salir
xhost -local:docker
