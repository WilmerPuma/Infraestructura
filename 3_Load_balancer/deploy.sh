#!/bin/bash
# Habilitar el modo estricto para detectar errores
set -e

echo "🚀 Iniciando la instalación y configuración del servidor web con Docker Compose..."

# Actualizar paquetes
echo "🔄 Actualizando paquetes..."
sudo apt update -y

# Instalar Docker
echo "🐳 Instalando Docker..."
sudo apt install -y docker.io

# Habilitar y verificar que Docker está corriendo
sudo systemctl enable docker
sudo systemctl start docker
echo "✅ Docker instalado y en ejecución."

# Agregar usuario actual al grupo Docker para evitar uso de sudo en cada comando
sudo usermod -aG docker $USER
newgrp docker

# Instalar Docker Compose
echo "🛠️ Instalando Docker Compose..."
sudo apt install -y docker-compose
echo "✅ Docker Compose instalado."

# Crear el directorio del proyecto
echo "📂 Creando directorio para el servidor web..."
mkdir -p ~/webserver
cd ~/webserver

# Crear el archivo docker-compose.yml
echo "📄 Creando el archivo docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    restart: always
EOF

# Iniciar el contenedor con Docker Compose
echo "🚀 Desplegando el servidor web con Docker Compose..."
docker-compose up -d

# Mostrar contenedores en ejecución
echo "📋 Contenedores en ejecución:"
docker ps

# Obtener la IP Pública de la máquina
IP_PUBLICA=$(curl -s ifconfig.me)

echo "✅ Despliegue completado. Puedes acceder al servidor web en:"
echo "🌍 http://$IP_PUBLICA"

