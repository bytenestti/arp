#!/bin/bash

# Script de Correção SSL - ARP Manutenções
# Corrige problemas de certificado SSL do Let's Encrypt

set -e

echo "🔒 Correção SSL - ARP Manutenções"
echo "================================="

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

# 1. Verificar DNS
log "1. Verificando DNS..."
echo ""
echo "=== VERIFICAÇÃO DNS ==="
if nslookup arpmanutencoes.com > /dev/null 2>&1; then
    success "DNS arpmanutencoes.com resolvido"
    nslookup arpmanutencoes.com | grep "Address:"
else
    error "DNS arpmanutencoes.com não resolvido!"
    echo "Configure o DNS primeiro:"
    echo "A    arpmanutencoes.com     → IP_DA_VPS"
    echo "CNAME www.arpmanutencoes.com → arpmanutencoes.com"
fi

if nslookup www.arpmanutencoes.com > /dev/null 2>&1; then
    success "DNS www.arpmanutencoes.com resolvido"
    nslookup www.arpmanutencoes.com | grep "Address:"
else
    warning "DNS www.arpmanutencoes.com não resolvido"
fi

# 2. Parar containers
log "2. Parando containers..."
docker-compose down
success "Containers parados"

# 3. Limpar certificados antigos
log "3. Limpando certificados antigos..."
if [ -d "./letsencrypt" ]; then
    rm -rf ./letsencrypt
    success "Certificados antigos removidos"
else
    success "Nenhum certificado antigo encontrado"
fi

# 4. Criar diretório letsencrypt
log "4. Criando diretório letsencrypt..."
mkdir -p ./letsencrypt
chmod 600 ./letsencrypt
success "Diretório letsencrypt criado"

# 5. Verificar configuração do Traefik
log "5. Verificando configuração do Traefik..."
if grep -q "httpchallenge" docker-compose.yml; then
    success "Configuração HTTP Challenge encontrada"
else
    warning "Configuração HTTP Challenge não encontrada"
fi

# 6. Reiniciar containers
log "6. Reiniciando containers..."
docker-compose --profile production up -d
success "Containers reiniciados"

# 7. Aguardar inicialização
log "7. Aguardando inicialização..."
sleep 20

# 8. Verificar status
log "8. Verificando status..."
docker-compose ps

# 9. Verificar logs do Traefik
log "9. Verificando logs do Traefik..."
echo ""
echo "=== LOGS DO TRAEFIK (últimas 20 linhas) ==="
docker-compose logs --tail=20 traefik

# 10. Testar conectividade HTTP
log "10. Testando conectividade HTTP..."
echo ""
echo "=== TESTES DE CONECTIVIDADE ==="

# Testar HTTP
if curl -f -s http://arpmanutencoes.com > /dev/null 2>&1; then
    success "Site responde em HTTP"
else
    warning "Site não responde em HTTP"
fi

# Testar HTTPS
if curl -f -s -k https://arpmanutencoes.com > /dev/null 2>&1; then
    success "Site responde em HTTPS (certificado pode estar sendo gerado)"
else
    warning "Site não responde em HTTPS"
fi

# 11. Aguardar geração do certificado
log "11. Aguardando geração do certificado SSL..."
echo "Isso pode levar até 2 minutos..."
echo ""

for i in {1..12}; do
    echo -n "Tentativa $i/12... "
    
    # Verificar se certificado foi gerado
    if docker-compose logs traefik | grep -q "certificate obtained"; then
        success "Certificado SSL gerado com sucesso!"
        break
    elif docker-compose logs traefik | grep -q "error\|failed"; then
        error "Erro na geração do certificado"
        echo ""
        echo "=== ÚLTIMOS LOGS DO TRAEFIK ==="
        docker-compose logs --tail=10 traefik
        break
    else
        echo "Aguardando..."
        sleep 10
    fi
done

# 12. Teste final
log "12. Teste final do SSL..."
echo ""

# Testar HTTPS sem -k (verificar certificado válido)
if curl -f -s https://arpmanutencoes.com > /dev/null 2>&1; then
    success "🎉 SSL funcionando corretamente!"
    echo ""
    echo "🌐 URLs funcionais:"
    echo "- HTTP:  http://arpmanutencoes.com"
    echo "- HTTPS: https://arpmanutencoes.com"
    echo "- Dashboard: http://SEU_IP:8080"
else
    warning "SSL ainda não está funcionando"
    echo ""
    echo "🔍 Verificações adicionais:"
    echo "1. Confirme que o DNS está apontando para a VPS"
    echo "2. Verifique se a porta 80 está aberta"
    echo "3. Aguarde mais alguns minutos para o Let's Encrypt"
    echo ""
    echo "📋 Comandos úteis:"
    echo "- Ver logs: docker-compose logs -f traefik"
    echo "- Verificar DNS: nslookup arpmanutencoes.com"
    echo "- Testar HTTP: curl -I http://arpmanutencoes.com"
fi

echo ""
echo "🔧 Correção SSL concluída!"
