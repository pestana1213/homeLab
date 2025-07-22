echo "🟢 A iniciar os serviços..."

SERVICES=("piHole")

for SERVICE in "${SERVICES[@]}"; do
  echo "➡️ Subindo $SERVICE..."
  sudo docker compose -f "docker/$SERVICE/docker-compose.yml" up -d
done

echo "✅ Todos os serviços foram iniciados!"