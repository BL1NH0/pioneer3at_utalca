# Pioneer 3-AT UTalca - Docker

Workspace ROS Noetic completo para robot Pioneer 3-AT en contenedor Docker.

## 📋 Tabla de Contenidos

- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Solución de Problemas](#solución-de-problemas)
- [Contribuir](#contribuir)

---

## 🔧 Requisitos

### Sistema Operativo
- **Linux** (Ubuntu 20.04/22.04 recomendado)
- Otros Linux también funcionan

### Software Necesario

#### 1. Docker
```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Agregar usuario al grupo docker (evita usar sudo)
sudo usermod -aG docker $USER

# Cerrar sesión y volver a entrar, luego verificar
docker --version
```

#### 2. X11 (para interfaz gráfica)
Ya viene instalado en Ubuntu Desktop. Verificar:
```bash
echo $DISPLAY
# Debería mostrar algo como: :0 o :1
```

### Hardware Recomendado
- **CPU**: 4 cores o más
- **RAM**: 8 GB mínimo
- **Disco**: 20 GB libres
- **GPU**: Con aceleración OpenGL (para Gazebo)

---

## 🚀 Instalación

### Paso 1: Clonar el repositorio

```bash
git clone https://github.com/BL1NH0/pioneer3at_utalca.git
cd pioneer3at_utalca
```

### Paso 2: Dar permisos a los scripts

```bash
chmod +x build.sh start.sh
```

### Paso 3: Construir la imagen Docker

```bash
./build.sh
```

⏱️ **Tiempo estimado**: 15-30 minutos (primera vez)

Este proceso:
- Descarga imagen base de ROS Noetic
- Instala todas las dependencias
- Clona RosAria y AriaCoda desde GitHub
- Compila AriaCoda
- Compila el workspace completo

---

## 🎮 Uso

### Iniciar el Contenedor

```bash
./start.sh
```

Este comando:
- Configura permisos X11 para GUI
- Inicia el contenedor en segundo plano
- Mantiene el contenedor corriendo

### Acceder al Contenedor

```bash
docker exec -it pioneer3at_ros bash
```

---

## 🎯 Casos de Uso

### 1. Simulación en Gazebo

#### Opción A: Todo en una terminal

```bash
# Acceder al contenedor
docker exec -it pioneer3at_ros bash

# Dentro del contenedor
source devel/setup.bash
roslaunch simulacion example-pioneer3at-world.launch
```

#### Opción B: Con interfaz de control (2 terminales)

**Terminal 1 - Simulación:**
```bash
docker exec -it pioneer3at_ros bash
source devel/setup.bash
roslaunch simulacion example-pioneer3at-world.launch
```

**Terminal 2 - Interfaz gráfica:**
```bash
docker exec -it pioneer3at_ros bash
source devel/setup.bash
rqt
```

En rqt:
1. Ir a `Perspectives` → `Import`
2. Seleccionar: `~/pioneer3at_utalca/src/simulacion/launch/drive_rqt.perspective`
3. Configurar tópico: `/sim_p3at/cmd_vel`

### 2. Robot Físico

**Requisitos previos:**
- Pioneer 3-AT conectado por USB
- Motores activados
- Parada de emergencia desactivada
- Cable USB conectado (aparece como `/dev/ttyUSB0`)

#### Terminal 1 - ROS Master
```bash
docker exec -it pioneer3at_ros bash
roscore
```

#### Terminal 2 - RosAria
```bash
docker exec -it pioneer3at_ros bash
source devel/setup.bash
rosrun rosaria RosAria
```

#### Terminal 3 - Control
```bash
docker exec -it pioneer3at_ros bash
source devel/setup.bash
rqt
```

---

## 📂 Estructura del Proyecto

```
pioneer3at_utalca/
├── Dockerfile              # Definición de la imagen Docker
├── docker-compose.yml      # Configuración de servicios (opcional)
├── .dockerignore          # Archivos excluidos de la imagen
├── .gitignore             # Archivos excluidos del repositorio
├── build.sh               # Script para construir la imagen
├── start.sh               # Script para iniciar el contenedor
├── README.md              # Este archivo
└── src/
    └── simulacion/        # Paquete de simulación personalizado
        ├── CMakeLists.txt
        ├── package.xml
        ├── gazebo/
        │   ├── models/
        │   └── example-pioneer3at-world.launch
        └── launch/
            └── drive_rqt.perspective
```

### Workspace dentro del contenedor

```
/home/rosuser/pioneer3at_utalca/
├── src/
│   ├── rosaria/           # Clonado desde GitHub
│   ├── AriaCoda/          # Clonado desde GitHub
│   └── simulacion/        # Tu paquete personalizado
├── build/                 # Archivos de compilación
└── devel/                 # Espacio de desarrollo
```

---

## 🔧 Comandos Útiles

### Gestión del Contenedor

```bash
# Ver contenedores en ejecución
docker ps

# Ver todos los contenedores (incluyendo detenidos)
docker ps -a

# Iniciar contenedor detenido
docker start pioneer3at_ros

# Detener contenedor
docker stop pioneer3at_ros

# Reiniciar contenedor
docker restart pioneer3at_ros

# Eliminar contenedor
docker rm pioneer3at_ros

# Ver logs del contenedor
docker logs pioneer3at_ros

# Ver logs en tiempo real
docker logs -f pioneer3at_ros
```

### Gestión de Imágenes

```bash
# Ver imágenes
docker images

# Eliminar imagen
docker rmi pioneer3at_utalca:latest

# Limpiar imágenes no usadas
docker image prune -a
```

### Dentro del Contenedor

```bash
# Listar paquetes ROS
rospack list

# Ver tópicos activos
rostopic list

# Ver nodos activos
rosnode list

# Info de un tópico
rostopic info /sim_p3at/cmd_vel

# Monitorear un tópico
rostopic echo /sim_p3at/odom
```

---

## 🐛 Solución de Problemas

### Problema: No se muestra la interfaz gráfica (Gazebo/rqt)

**Solución:**
```bash
# En el host (fuera del contenedor)
xhost +local:docker
```

Si persiste:
```bash
# Verificar variable DISPLAY
echo $DISPLAY

# Debería mostrar :0 o :1
```

### Problema: Error "Permission denied" al ejecutar scripts

**Solución:**
```bash
chmod +x build.sh start.sh
```

### Problema: Robot físico no conecta

**Verificar conexión USB:**
```bash
ls /dev/ttyUSB*
# Debería mostrar: /dev/ttyUSB0
```

**Agregar usuario al grupo dialout:**
```bash
sudo usermod -aG dialout $USER
# Cerrar sesión y volver a entrar
```

### Problema: Gazebo va muy lento

**Verificar aceleración gráfica:**
```bash
glxinfo | grep "direct rendering"
# Debería mostrar: direct rendering: Yes
```

Si dice "No", instalar drivers de GPU correctos.

### Problema: Error de compilación al construir

**Limpiar y reconstruir:**
```bash
# Eliminar imagen vieja
docker rmi pioneer3at_utalca:latest

# Limpiar cache de Docker
docker builder prune -a

# Reconstruir
./build.sh
```

### Problema: Error con docker-compose

Si aparece error tipo:
```
TypeError: request() got an unexpected keyword argument 'chunked'
```

**Solución:** El `start.sh` actual ya no usa docker-compose. Si el error persiste, verificar que tu `start.sh` no tenga la línea `docker-compose`.

---

## 📦 Contenido del Workspace

### RosAria
- **Descripción**: Interfaz ROS para comunicación con robot Pioneer
- **Origen**: https://github.com/amor-ros-pkg/rosaria
- **Uso**: Control del robot físico

### AriaCoda
- **Descripción**: Biblioteca de control para robots móviles
- **Origen**: https://github.com/reedhedges/AriaCoda
- **Uso**: Comunicación de bajo nivel con hardware Pioneer

### Simulacion
- **Descripción**: Paquete personalizado para simulación en Gazebo
- **Contenido**:
  - Modelos 3D del robot
  - Mundos de Gazebo
  - Archivos launch personalizados
  - Configuración de interfaz rqt

---

## 🔄 Actualizar el Proyecto

### Actualizar código desde GitHub

```bash
cd ~/pioneer3at_utalca
git pull origin main

# Reconstruir imagen con cambios
./build.sh
```

### Modificar tu código

Si modificas archivos en `src/simulacion/`:

```bash
# Reconstruir imagen para incluir cambios
./build.sh

# Reiniciar contenedor
docker restart pioneer3at_ros
```

---

## 🌐 Variables de Entorno

El contenedor configura automáticamente:

```bash
ROS_MASTER_URI=http://localhost:11311
ROS_HOSTNAME=localhost
LD_LIBRARY_PATH=/home/rosuser/pioneer3at_utalca/src/AriaCoda/lib:/usr/local/lib
GAZEBO_MODEL_PATH=/home/rosuser/pioneer3at_utalca/src/simulacion/gazebo/models
```

---

## 🤝 Contribuir

### Reportar Problemas

Abre un [Issue](https://github.com/BL1NH0/pioneer3at_utalca/issues) describiendo:
- Sistema operativo
- Versión de Docker
- Comando ejecutado
- Error completo

### Proponer Mejoras

1. Fork el proyecto
2. Crea una rama: `git checkout -b feature/AmazingFeature`
3. Commit: `git commit -m 'Add AmazingFeature'`
4. Push: `git push origin feature/AmazingFeature`
5. Abre un Pull Request

---

## 📚 Recursos Adicionales

- [ROS Wiki](http://wiki.ros.org/)
- [Gazebo Tutorials](http://gazebosim.org/tutorials)
- [Docker Documentation](https://docs.docker.com/)
- [Pioneer 3-AT Manual](http://www.mobilerobots.com/ResearchRobots/P3AT.aspx)

---

## 👥 Autores

**BL1NH0** - Universidad de Talca, Chile

---

## 📄 Licencia

Este proyecto se distribuye bajo licencia MIT. Ver archivo `LICENSE` para más detalles.

---

## 🎓 Universidad de Talca

Proyecto desarrollado en la Universidad de Talca, Chile.

**Año**: 2024-2025

---

## ⚡ Inicio Rápido (TL;DR)

```bash
# 1. Clonar
git clone https://github.com/BL1NH0/pioneer3at_utalca.git
cd pioneer3at_utalca

# 2. Construir (15-30 min)
chmod +x build.sh start.sh
./build.sh

# 3. Iniciar
./start.sh

# 4. Usar
docker exec -it pioneer3at_ros bash
source devel/setup.bash
roslaunch simulacion example-pioneer3at-world.launch
```

---

**¿Preguntas?** Abre un [Issue](https://github.com/BL1NH0/pioneer3at_utalca/issues) 🚀
