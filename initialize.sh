#!/bin/bash
echo "🟢 A iniciar os serviços..."

SERVICES=("piHole" "dashy" "nextCloud")

for SERVICE in "${SERVICES[@]}"; do
  echo "➡️ Subindo $SERVICE..."
  docker compose --env-file .env -f "docker/$SERVICE/docker-compose.yml" up -d
done

echo "✅ Todos os serviços foram iniciados!"