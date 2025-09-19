#!/bin/bash

# Deploy Super Rápido - ARP Manutenções
# Para quando Docker já está instalado e configurado

set -e

echo "🚀 Deploy Rápido - ARP Manutenções"
echo "=================================="

# Ir para diretório da aplicação
cd /opt/arpmanutencoes

# Parar containers
echo "⏹️  Parando containers..."
docker-compose down

# Atualizar código (se for repositório git)
if [ -d ".git" ]; then
    echo "📥 Atualizando código..."
    git pull origin main
fi

# Deploy
echo "🚀 Fazendo deploy..."
docker-compose --profile production up --build -d

# Aguardar
echo "⏳ Aguardando containers iniciarem..."
sleep 10

# Status
echo "📊 Status dos containers:"
docker-compose ps

echo ""
echo "✅ Deploy concluído!"
echo "🌐 Site: https://arpmanutencoes.com"
echo "📱 Dashboard: http://SEU_IP:8080"
echo ""
echo "📋 Comandos úteis:"
echo "- Logs: docker-compose logs -f"
echo "- Parar: docker-compose down"
echo "- Reiniciar: docker-compose restart"
