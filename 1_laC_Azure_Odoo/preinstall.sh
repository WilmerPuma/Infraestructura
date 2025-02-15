#!/bin/bash
# Actualizar el sistema
sudo apt-get update -y

# Instalar Docker
sudo apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Instalar Docker Compose
sudo apt-get install -y docker-compose

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Instalar Git
sudo apt-get install -y git

# Verificar las instalaciones
terraform -version
docker --version
docker-compose --version
git --version

# Clonar el repositorio y ejecutar Docker Compose
git clone https://github.com/docker-compose-marlon/odoo-docker-compose
cd odoo-docker-compose
docker-compose up -d