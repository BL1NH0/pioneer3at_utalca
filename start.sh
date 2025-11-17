#!/bin/bash
set -e

echo "🚀 Iniciando contenedor..."

# Permitir X11
xhost +local:docker 2>/dev/null

# Iniciar con docker-compose
docker-compose up -d

echo "✅ Contenedor iniciado!"
echo ""
echo "Para acceder: docker exec -it pioneer3at_ros bash"
echo "Para simulación: roslaunch simulacion example-pioneer3at-world.launch"
