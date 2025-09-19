#!/bin/bash

# Script de Correção da Conectividade da Aplicação
# ARP Manutenções

set -e

echo "🔧 Correção da Conectividade da Aplicação - ARP Manutenções"
echo "=========================================================="

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

# 1. Verificar se aplicação está rodando
log "1. Verificando status da aplicação..."
echo ""
echo "=== STATUS DA APLICAÇÃO ==="
docker-compose ps app

# 2. Verificar logs da aplicação
log "2. Verificando logs da aplicação..."
echo ""
echo "=== LOGS DA APLICAÇÃO ==="
docker-compose logs app

# 3. Verificar se aplicação está respondendo internamente
log "3. Testando conectividade interna da aplicação..."
echo ""

# Testar se aplicação responde dentro do container
if docker-compose exec app curl -f -s http://localhost:3000 > /dev/null 2>&1; then
    success "Aplicação responde dentro do container"
else
    error "Aplicação NÃO responde dentro do container"
    
    # Verificar se curl está instalado no container
    if docker-compose exec app which curl > /dev/null 2>&1; then
        success "curl está instalado no container"
    else
        warning "curl não está instalado no container, instalando..."
        docker-compose exec app apt update && docker-compose exec app apt install -y curl
    fi
    
    # Testar novamente
    if docker-compose exec app curl -f -s http://localhost:3000 > /dev/null 2>&1; then
        success "Aplicação responde após instalar curl"
    else
        error "Aplicação ainda não responde"
        
        # Verificar se o processo Next.js está rodando
        log "Verificando processos dentro do container..."
        docker-compose exec app ps aux
        
        # Verificar se a porta 3000 está sendo usada
        log "Verificando portas dentro do container..."
        docker-compose exec app netstat -tulpn | grep :3000 || echo "Porta 3000 não está em uso"
    fi
fi

# 4. Verificar configuração do Dockerfile
log "4. Verificando configuração do Dockerfile..."
echo ""
echo "=== CONTEÚDO DO DOCKERFILE ==="
head -20 Dockerfile

# 5. Verificar se há problemas de build
log "5. Verificando se há problemas de build..."
echo ""
echo "=== VERIFICANDO BUILD ==="
docker-compose build app

# 6. Reiniciar aplicação
log "6. Reiniciando aplicação..."
echo ""
docker-compose restart app

# Aguardar inicialização
log "Aguardando inicialização..."
sleep 10

# 7. Verificar logs após reinicialização
log "7. Verificando logs após reinicialização..."
echo ""
echo "=== LOGS APÓS REINICIALIZAÇÃO ==="
docker-compose logs --tail=10 app

# 8. Testar conectividade novamente
log "8. Testando conectividade novamente..."
echo ""
echo "=== TESTES DE CONECTIVIDADE ==="

# Testar aplicação dentro do container
if docker-compose exec app curl -f -s http://localhost:3000 > /dev/null 2>&1; then
    success "✅ Aplicação responde dentro do container"
else
    error "❌ Aplicação ainda não responde dentro do container"
fi

# Testar Traefik acessando a aplicação
if docker-compose exec traefik curl -f -s http://arp-app-1:3000 > /dev/null 2>&1; then
    success "✅ Traefik consegue acessar a aplicação"
else
    error "❌ Traefik não consegue acessar a aplicação"
fi

# Testar localhost
if curl -f -s http://localhost:3000 > /dev/null 2>&1; then
    success "✅ Aplicação responde em localhost:3000"
else
    warning "⚠️  Aplicação não responde em localhost:3000"
fi

# Testar Traefik
if curl -f -s http://localhost:80 > /dev/null 2>&1; then
    success "✅ Traefik responde em localhost:80"
else
    warning "⚠️  Traefik não responde em localhost:80"
fi

# 9. Verificar configuração do Traefik
log "9. Verificando configuração do Traefik..."
echo ""
echo "=== CONFIGURAÇÃO DO TRAEFIK ==="
docker-compose exec traefik cat /etc/traefik/traefik.yml 2>/dev/null || echo "Arquivo de configuração não encontrado"

# 10. Verificar se há rotas configuradas
log "10. Verificando rotas do Traefik..."
echo ""
echo "=== ROTAS DO TRAEFIK ==="
docker-compose exec traefik wget -qO- http://localhost:8080/api/http/routers 2>/dev/null || echo "Não foi possível acessar API do Traefik"

# 11. Sugestões de correção
log "11. Sugestões de correção..."
echo ""
echo "=== SUGESTÕES ==="

# Verificar se aplicação está rodando
if ! docker-compose ps | grep -q "app.*Up"; then
    echo "🔧 Aplicação não está rodando:"
    echo "   docker-compose up -d app"
fi

# Verificar se há erros nos logs
if docker-compose logs app | grep -qi "error\|failed\|exception"; then
    echo "🔧 Aplicação com erros:"
    echo "   docker-compose logs app"
    echo "   Verificar configuração do .env"
fi

# Verificar se Traefik está configurado corretamente
if ! docker-compose logs traefik | grep -q "Starting provider"; then
    echo "🔧 Traefik não está configurado corretamente:"
    echo "   docker-compose restart traefik"
fi

# Verificar se há problemas de rede
if ! docker-compose exec traefik ping -c 1 arp-app-1 > /dev/null 2>&1; then
    echo "🔧 Problema de rede entre containers:"
    echo "   docker-compose down"
    echo "   docker-compose --profile production up --build -d"
fi

echo ""
echo "🔧 Correção da conectividade concluída!"
echo "======================================"
echo ""
echo "📋 Próximos passos:"
echo "1. Verificar se a aplicação está respondendo"
echo "2. Verificar se o Traefik consegue acessar a aplicação"
echo "3. Testar conectividade externa"
echo ""
echo "📊 Comandos úteis:"
echo "- Ver logs: docker-compose logs -f app"
echo "- Reiniciar app: docker-compose restart app"
echo "- Rebuild: docker-compose up --build -d app"
echo "- Ver status: docker-compose ps"
