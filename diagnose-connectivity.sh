#!/bin/bash

# Diagnóstico de Conectividade - ARP Manutenções
# Diagnostica problemas de conectividade após correção de rede

set -e

echo "🔍 Diagnóstico de Conectividade - ARP Manutenções"
echo "==============================================="

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

# 1. Verificar status dos containers
log "1. Verificando status dos containers..."
echo ""
echo "=== STATUS DOS CONTAINERS ==="
docker-compose ps

echo ""
echo "=== CONTAINERS EM EXECUÇÃO ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 2. Verificar logs da aplicação
log "2. Verificando logs da aplicação..."
echo ""
echo "=== LOGS DA APLICAÇÃO (últimas 20 linhas) ==="
docker-compose logs --tail=20 app

# 3. Verificar logs do Traefik
log "3. Verificando logs do Traefik..."
echo ""
echo "=== LOGS DO TRAEFIK (últimas 20 linhas) ==="
docker-compose logs --tail=20 traefik

# 4. Verificar portas
log "4. Verificando portas..."
echo ""
echo "=== PORTAS EM USO ==="
netstat -tulpn | grep -E ":(80|443|3000|8080)" || echo "Nenhuma porta relevante em uso"

echo ""
echo "=== PORTAS DOS CONTAINERS ==="
docker port arp-app-1 2>/dev/null || echo "Container app não tem portas expostas"
docker port arp-traefik-1 2>/dev/null || echo "Container traefik não tem portas expostas"

# 5. Verificar conectividade interna
log "5. Verificando conectividade interna..."
echo ""
echo "=== TESTES DE CONECTIVIDADE INTERNA ==="

# Testar aplicação diretamente no container
if docker-compose exec app curl -f -s http://localhost:3000 > /dev/null 2>&1; then
    success "Aplicação responde dentro do container"
else
    error "Aplicação NÃO responde dentro do container"
fi

# Testar Traefik diretamente no container
if docker-compose exec traefik curl -f -s http://localhost:80 > /dev/null 2>&1; then
    success "Traefik responde dentro do container"
else
    error "Traefik NÃO responde dentro do container"
fi

# 6. Verificar conectividade entre containers
log "6. Verificando conectividade entre containers..."
echo ""
echo "=== TESTES DE CONECTIVIDADE ENTRE CONTAINERS ==="

# Testar se Traefik consegue acessar a aplicação
if docker-compose exec traefik curl -f -s http://arp-app-1:3000 > /dev/null 2>&1; then
    success "Traefik consegue acessar a aplicação"
else
    error "Traefik NÃO consegue acessar a aplicação"
fi

# 7. Verificar configuração do Traefik
log "7. Verificando configuração do Traefik..."
echo ""
echo "=== CONFIGURAÇÃO DO TRAEFIK ==="
docker-compose exec traefik cat /etc/traefik/traefik.yml 2>/dev/null || echo "Arquivo de configuração não encontrado"

# 8. Verificar labels dos containers
log "8. Verificando labels dos containers..."
echo ""
echo "=== LABELS DO CONTAINER APP ==="
docker inspect arp-app-1 | grep -A 20 '"Labels"' | grep -E '"traefik|"com.docker.compose'

# 9. Verificar redes
log "9. Verificando configuração de rede..."
echo ""
echo "=== CONFIGURAÇÃO DE REDE ==="
docker network inspect arp_app-network | grep -A 10 '"Containers"'

# 10. Testar conectividade externa
log "10. Testando conectividade externa..."
echo ""
echo "=== TESTES DE CONECTIVIDADE EXTERNA ==="

# Testar localhost
for port in 3000 80 443 8080; do
    if curl -f -s http://localhost:$port > /dev/null 2>&1; then
        success "Porta $port responde em localhost"
    else
        warning "Porta $port NÃO responde em localhost"
    fi
done

# Testar IP da VPS
VPS_IP="177.153.51.81"
for port in 80 443 8080; do
    if curl -f -s http://$VPS_IP:$port > /dev/null 2>&1; then
        success "Porta $port responde no IP $VPS_IP"
    else
        warning "Porta $port NÃO responde no IP $VPS_IP"
    fi
done

# 11. Verificar firewall
log "11. Verificando firewall..."
echo ""
echo "=== STATUS DO FIREWALL ==="
ufw status 2>/dev/null || echo "UFW não está instalado"

# 12. Sugestões de correção
log "12. Sugestões de correção..."
echo ""
echo "=== SUGESTÕES ==="

# Verificar se containers estão rodando
if ! docker-compose ps | grep -q "Up"; then
    echo "🔧 Containers não estão rodando:"
    echo "   docker-compose --profile production up -d"
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

# Verificar se portas estão expostas
if ! netstat -tulpn | grep -q ":80\|:443\|:3000\|:8080"; then
    echo "🔧 Portas não estão expostas:"
    echo "   Verificar docker-compose.yml"
    echo "   docker-compose restart"
fi

echo ""
echo "🎯 Diagnóstico de conectividade concluído!"
echo "Use as sugestões acima para resolver os problemas encontrados."
