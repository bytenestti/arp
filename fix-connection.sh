#!/bin/bash

# Script de Correção - Connection Refused
# Corrige automaticamente problemas de conexão

set -e

echo "🔧 Correção Automática - Connection Refused"
echo "=========================================="

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

# 2. Limpar cache Docker (opcional)
log "2. Limpando cache Docker..."
docker system prune -f
success "Cache limpo"

# 3. Verificar arquivos
log "3. Verificando arquivos..."
if [ ! -f ".env" ]; then
    if [ -f "env.docker" ]; then
        cp env.docker .env
        success ".env criado"
    else
        error "Arquivo env.docker não encontrado!"
        exit 1
    fi
else
    success ".env encontrado"
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

# 7. Testar conectividade
log "7. Testando conectividade..."
echo ""
for i in {1..5}; do
    if curl -f -s http://localhost:3000 > /dev/null 2>&1; then
        success "✅ Aplicação está respondendo!"
        break
    else
        warning "Tentativa $i/5 - Aguardando aplicação..."
        sleep 5
    fi
done

# 8. Mostrar logs se ainda não funcionar
if ! curl -f -s http://localhost:3000 > /dev/null 2>&1; then
    error "Aplicação ainda não está respondendo"
    echo ""
    echo "=== LOGS DA APLICAÇÃO ==="
    docker-compose logs --tail=20 app
    echo ""
    echo "=== LOGS DO TRAEFIK ==="
    docker-compose logs --tail=10 traefik
else
    success "🎉 Problema resolvido!"
    echo ""
    echo "🌐 URLs disponíveis:"
    echo "- Aplicação: http://localhost:3000"
    echo "- Dashboard Traefik: http://localhost:8080"
fi
