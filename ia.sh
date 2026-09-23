#!/bin/bash
set -e

echo "Iniciando instalación de Ollama y Open WebUI..."

# 1. Instalar dependencias básicas
sudo apt-get update && sudo apt-get install -y curl

# 2. Instalar Docker si no está presente en el sistema
if ! command -v docker &> /dev/null; then
    echo "Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# 3. Instalar Ollama para el procesamiento de los modelos
if ! command -v ollama &> /dev/null; then
    echo "Instalando motor Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

# 4. Descargar el modelo base
echo "Descargando Llama 3.2..."
ollama pull llama3.2

# 5. Desplegar la interfaz Open WebUI conectada a la red local de Docker
echo "Levantando contenedor gráfico..."
sudo docker run -d -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main

echo "============================================================"
echo "Instalación completada. Abre http://localhost:3000 en tu navegador."
echo "La primera cuenta que crees tendrá privilegios de administrador."
echo "============================================================"
