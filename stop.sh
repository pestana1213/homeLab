#!/bin/bash

# Script para parar todos os serviços docker-compose no homelab

echo "🔴 Parando todos os serviços do homelab..."

SERVICES=("piHole")

for SERVICE in "${SERVICES[@]}"; do
  echo "⏹️ Parando $SERVICE..."
  docker compose -f "docker/$SERVICE/docker-compose.yml" down
done

echo "✅ Todos os serviços foram parados!"