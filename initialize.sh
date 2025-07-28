#!/bin/bash
echo "🟢 A iniciar os serviços..."

SERVICES=("piHole" "dashy" "nextCloud" "myAi")

for SERVICE in "${SERVICES[@]}"; do
  echo "➡️ Subindo $SERVICE..."
  sudo docker compose --env-file .env -f "docker/$SERVICE/docker-compose.yml" up -d
done

echo "✅ Todos os serviços foram iniciados!"