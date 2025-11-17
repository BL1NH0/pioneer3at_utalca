#!/bin/bash
set -e

echo "🔨 Construyendo imagen Docker..."
docker build -t pioneer3at_utalca:latest .

echo "✅ Imagen construida exitosamente!"
echo ""
echo "Para iniciar: ./start.sh"
