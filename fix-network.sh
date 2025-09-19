#!/bin/bash

# Script de Correção de Rede - ARP Manutenções
# Corrige problemas de rede do Docker Compose

set -e

echo "🔧 Correção de Rede - ARP Manutenções"
echo "===================================="

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 1. Parar containers
log "1. Parando containers..."
docker-compose down
success "Containers parados"

# 2. Limpar redes antigas
log "2. Limpando redes antigas..."
docker network prune -f
success "Redes antigas removidas"

# 3. Verificar configuração de rede
log "3. Verificando configuração de rede..."
if grep -q "arp_app-network" docker-compose.yml; then
    success "Configuração de rede já está correta"
else
    warning "Configuração de rede precisa ser ajustada"
fi

# 4. Rebuild e restart
log "4. Fazendo rebuild e restart..."
docker-compose --profile production up --build -d
success "Containers reiniciados"

# 5. Aguardar inicialização
log "5. Aguardando inicialização..."
sleep 15

# 6. Verificar status
log "6. Verificando status..."
docker-compose ps

# 7. Verificar redes
log "7. Verificando redes..."
echo ""
echo "=== REDES DISPONÍVEIS ==="
docker network ls

echo ""
echo "=== DETALHES DA REDE ==="
docker network inspect arp_app-network 2>/dev/null || echo "Rede arp_app-network não encontrada"

# 8. Verificar logs do Traefik
log "8. Verificando logs do Traefik..."
echo ""
echo "=== LOGS DO TRAEFIK (últimas 10 linhas) ==="
docker-compose logs --tail=10 traefik

# 9. Testar conectividade
log "9. Testando conectividade..."
echo ""
echo "=== TESTES DE CONECTIVIDADE ==="

# Testar localhost:3000
if curl -f -s http://localhost:3000 > /dev/null 2>&1; then
    success "Aplicação responde em localhost:3000"
else
    warning "Aplicação não responde em localhost:3000"
fi

# Testar localhost:80
if curl -f -s http://localhost:80 > /dev/null 2>&1; then
    success "Traefik responde em localhost:80"
else
    warning "Traefik não responde em localhost:80"
fi

# Testar localhost:8080
if curl -f -s http://localhost:8080 > /dev/null 2>&1; then
    success "Dashboard Traefik responde em localhost:8080"
else
    warning "Dashboard Traefik não responde em localhost:8080"
fi

# 10. Verificar se ainda há warnings de rede
log "10. Verificando warnings de rede..."
echo ""
echo "=== VERIFICAÇÃO DE WARNINGS ==="
if docker-compose logs traefik | grep -q "Could not find network"; then
    warning "Ainda há warnings de rede nos logs"
    echo "Últimos logs do Traefik:"
    docker-compose logs --tail=20 traefik
else
    success "Não há warnings de rede nos logs"
fi

echo ""
echo "🔧 Correção de rede concluída!"
echo "=============================="
echo ""
echo "📋 Próximos passos:"
echo "1. Verificar se não há mais warnings nos logs"
echo "2. Testar conectividade externa"
echo "3. Configurar DNS se ainda não foi feito"
echo ""
echo "📊 Comandos úteis:"
echo "- Ver logs: docker-compose logs -f traefik"
echo "- Ver redes: docker network ls"
echo "- Ver status: docker-compose ps"
echo "- Reiniciar: docker-compose restart"
