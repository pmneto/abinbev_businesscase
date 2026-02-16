#!/bin/bash


echo "Iniciando provisionamento do ambiente Docker..."


if ! command -v docker &> /dev/null; then
    echo "Erro: Docker não encontrado. Instale o Docker e o Docker Compose antes de prosseguir."
    exit 1
fi


echo "Limpando estados anteriores e liberando portas..."
docker-compose down -v --remove-orphans
docker system prune -f


echo "Executando build das imagens e subindo stack (Spark/Postgres)..."
docker-compose up --build -d

echo "Aguardando prontidão dos serviços..."
sleep 5

echo "Status dos containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "Acesse o Jupyter Lab em: http://localhost:8888"
