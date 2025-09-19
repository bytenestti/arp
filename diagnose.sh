#!/bin/bash

# Script de Diagnóstico - ARP Manutenções
# Use quando houver problemas de conexão

set -e

echo "🔍 Diagnóstico do Sistema - ARP Manutenções"
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

# 1. Verificar Docker
log "1. Verificando Docker..."
if command -v docker &> /dev/null; then
    success "Docker está instalado"
    docker --version
else
    error "Docker não está instalado!"
    exit 1
fi

if command -v docker-compose &> /dev/null; then
    success "Docker Compose está instalado"
    docker-compose --version
else
    error "Docker Compose não está instalado!"
    exit 1
fi

# 2. Verificar arquivos necessários
log "2. Verificando arquivos necessários..."
if [ -f "docker-compose.yml" ]; then
    success "docker-compose.yml encontrado"
else
    error "docker-compose.yml não encontrado!"
    exit 1
fi

if [ -f ".env" ]; then
    success ".env encontrado"
else
    warning ".env não encontrado, copiando env.docker..."
    if [ -f "env.docker" ]; then
        cp env.docker .env
        success ".env criado a partir de env.docker"
    else
        error "env.docker não encontrado!"
        exit 1
    fi
fi

# 3. Verificar status dos containers
log "3. Verificando status dos containers..."
echo ""
echo "=== STATUS DOS CONTAINERS ==="
docker-compose ps

echo ""
echo "=== CONTAINERS EM EXECUÇÃO ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 4. Verificar portas
log "4. Verificando portas..."
echo ""
echo "=== PORTAS EM USO ==="
netstat -tulpn | grep -E ":(80|443|3000|8080)" || echo "Nenhuma porta relevante em uso"

# 5. Verificar logs da aplicação
log "5. Verificando logs da aplicação..."
echo ""
echo "=== ÚLTIMOS LOGS DA APLICAÇÃO ==="
docker-compose logs --tail=20 app

# 6. Verificar logs do Traefik
log "6. Verificando logs do Traefik..."
echo ""
echo "=== ÚLTIMOS LOGS DO TRAEFIK ==="
docker-compose logs --tail=10 traefik

# 7. Verificar recursos do sistema
log "7. Verificando recursos do sistema..."
echo ""
echo "=== RECURSOS DO SISTEMA ==="
echo "Memória:"
free -h
echo ""
echo "Disco:"
df -h /
echo ""
echo "CPU:"
top -bn1 | grep "Cpu(s)" || echo "Não foi possível verificar CPU"

# 8. Verificar conectividade
log "8. Testando conectividade..."
echo ""
echo "=== TESTES DE CONECTIVIDADE ==="

# Testar localhost:3000
if curl -f -s http://localhost:3000 > /dev/null 2>&1; then
    success "Aplicação responde em localhost:3000"
else
    error "Aplicação NÃO responde em localhost:3000"
fi

# Testar localhost:80
if curl -f -s http://localhost:80 > /dev/null 2>&1; then
    success "Traefik responde em localhost:80"
else
    warning "Traefik NÃO responde em localhost:80"
fi

# Testar localhost:8080
if curl -f -s http://localhost:8080 > /dev/null 2>&1; then
    success "Dashboard Traefik responde em localhost:8080"
else
    warning "Dashboard Traefik NÃO responde em localhost:8080"
fi

# 9. Sugestões de correção
log "9. Sugestões de correção..."
echo ""
echo "=== SUGESTÕES ==="

# Verificar se containers estão rodando
if ! docker-compose ps | grep -q "Up"; then
    echo "🔧 Containers não estão rodando:"
    echo "   docker-compose --profile production up --build -d"
fi

# Verificar se aplicação está com erro
if docker-compose logs app | grep -qi "error\|failed\|exception"; then
    echo "🔧 Aplicação com erros:"
    echo "   docker-compose logs app"
    echo "   docker-compose restart app"
fi

# Verificar se Traefik está com erro
if docker-compose logs traefik | grep -qi "error\|failed\|exception"; then
    echo "🔧 Traefik com erros:"
    echo "   docker-compose logs traefik"
    echo "   docker-compose restart traefik"
fi

# Verificar recursos
MEMORY_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ "$MEMORY_USAGE" -gt 80 ]; then
    echo "🔧 Alta utilização de memória (${MEMORY_USAGE}%):"
    echo "   docker system prune -f"
    echo "   docker-compose restart"
fi

DISK_USAGE=$(df / | awk 'NR==2{printf "%.0f", $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "🔧 Alta utilização de disco (${DISK_USAGE}%):"
    echo "   docker system prune -f"
    echo "   df -h"
fi

echo ""
echo "🎯 Diagnóstico concluído!"
echo "Use os comandos sugeridos acima para resolver os problemas encontrados."
