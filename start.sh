#!/bin/bash
set -e

echo "🚀 Iniciando contenedor..."
xhost +local:docker 2>/dev/null

if docker ps -a --format '{{.Names}}' | grep -q "^pioneer3at_ros$"; then
    docker start pioneer3at_ros
else
    docker run -d \
        --name pioneer3at_ros \
        --privileged \
        --network host \
        -e DISPLAY=$DISPLAY \
        -e QT_X11_NO_MITSHM=1 \
        -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
        -v /dev:/dev:rw \
        --device /dev/dri:/dev/dri \
        -it \
        pioneer3at_utalca:latest
fi

echo "✅ Iniciado! Accede con: docker exec -it pioneer3at_ros bash"