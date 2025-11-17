# Pioneer 3-AT UTALCA - ROS Noetic Docker

🤖 Entorno Docker completo para trabajar con el robot Pioneer 3-AT usando ROS Noetic.

## 📋 Requisitos

- Docker
- Docker Compose
- Sistema Linux (Ubuntu recomendado) o WSL2

## 🚀 Inicio Rápido

### 1. Clonar el repositorio
```bash
git clone <URL_DE_TU_REPO>
cd pioneer3at_utalca
```

### 2. Construir la imagen Docker
```bash
./build.sh
```

### 3. Iniciar el entorno
```bash
./start.sh
```

¡Eso es todo! Estarás dentro del contenedor con ROS Noetic y todo configurado.

## 📦 Contenido del Workspace

- **AriaCoda**: Biblioteca para comunicación con robots Pioneer
- **rosaria**: Paquete ROS para control del Pioneer 3-AT
- **simulacion**: Archivos de simulación
- **rosaria_teleop.launch**: Launch file para teleoperación

## 🎮 Uso

### Dentro del contenedor:
```bash
# El workspace ya está compilado y sourced

# Listar nodos disponibles
rospack list

# Ejecutar teleoperación
roslaunch rosaria_teleop.launch

# Recompilar si haces cambios
catkin_make
source devel/setup.bash
```

### Comandos útiles (fuera del contenedor):
```bash
# Iniciar el contenedor
./start.sh

# Detener el contenedor
docker-compose down

# Reconstruir la imagen
./build.sh

# Ver logs
docker-compose logs -f
```

## 🔧 Desarrollo

Los archivos en `src/` están montados como volumen, por lo que puedes:
1. Editar código en tu máquina host con tu editor favorito
2. Los cambios se reflejan instantáneamente en el contenedor
3. Compilar dentro del contenedor con `catkin_make`

## 📚 Workshop Tips

### Abrir múltiples terminales en el contenedor:
```bash
# Terminal 1: roscore
docker exec -it pioneer3at_ros bash
roscore

# Terminal 2: tu nodo
docker exec -it pioneer3at_ros bash
roslaunch rosaria_teleop.launch

# Terminal 3: herramientas
docker exec -it pioneer3at_ros bash
rostopic list
```

### GUI (RViz, rqt, etc.):

Las herramientas gráficas funcionan automáticamente gracias a la configuración X11.
```bash
rviz
# o
rqt_graph
```

## 🐛 Troubleshooting

### Error de X11/Display:
```bash
xhost +local:docker
```

### Recompilar desde cero:
```bash
docker-compose down
docker-compose build --no-cache
./start.sh
```

## 👥 Autor

Pablo - UTALCA

## 📝 Licencia

[Especifica tu licencia aquí]
