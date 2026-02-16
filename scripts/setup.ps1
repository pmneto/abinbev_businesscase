if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    exit 1
}

docker-compose down -v --remove-orphans
docker system prune -f
docker-compose up --build -d

Start-Sleep -Seconds 5
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

