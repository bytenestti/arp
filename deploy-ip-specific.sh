#!/bin/bash

# Deploy Específico para VPS 177.153.51.81
# ARP Manutenções

set -e

echo "🚀 Deploy para VPS 177.153.51.81 - ARP Manutenções"
echo "================================================="

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

# 1. Verificar se estamos na VPS correta
log "1. Verificando IP da VPS..."
CURRENT_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip)
if [ "$CURRENT_IP" = "177.153.51.81" ]; then
    success "VPS confirmada: 177.153.51.81"
else
    warning "IP atual: $CURRENT_IP (esperado: 177.153.51.81)"
fi

# 2. Ir para diretório da aplicação
log "2. Navegando para diretório da aplicação..."
cd /opt/arpmanutencoes

# 3. Verificar se é um repositório git
if [ ! -d ".git" ]; then
    warning "Diretório não é um repositório git"
    echo "Execute: git clone SEU_REPOSITORIO ."
    read -p "Pressione Enter após clonar o repositório..."
fi

# 4. Atualizar código (se for repositório git)
if [ -d ".git" ]; then
    log "3. Atualizando código..."
    git pull origin main
    success "Código atualizado"
fi

# 5. Configurar .env
log "4. Configurando ambiente..."
if [ ! -f ".env" ]; then
    if [ -f "env.docker" ]; then
        cp env.docker .env
        success ".env criado a partir de env.docker"
        
        # Editar configurações específicas
        sed -i 's/NEXT_PUBLIC_SITE_URL=.*/NEXT_PUBLIC_SITE_URL=https:\/\/arpmanutencoes.com/' .env
        sed -i 's/NEXT_PUBLIC_PHONE=.*/NEXT_PUBLIC_PHONE=(31) 99999-9999/' .env
        sed -i 's/NEXT_PUBLIC_WHATSAPP=.*/NEXT_PUBLIC_WHATSAPP=5531999999999/' .env
        success "Configurações específicas aplicadas"
    else
        error "Arquivo env.docker não encontrado!"
        exit 1
    fi
else
    success ".env já existe"
fi

# 6. Parar containers
log "5. Parando containers existentes..."
docker-compose down 2>/dev/null || true
success "Containers parados"

# 7. Deploy
log "6. Fazendo deploy..."
docker-compose --profile production up --build -d
success "Deploy iniciado"

# 8. Aguardar inicialização
log "7. Aguardando inicialização..."
sleep 15

# 9. Verificar status
log "8. Verificando status..."
docker-compose ps

# 10. Testar conectividade
log "9. Testando conectividade..."
echo ""
echo "=== TESTES DE CONECTIVIDADE ==="

# Testar localhost:3000
if curl -f -s http://localhost:3000 > /dev/null 2>&1; then
    success "Aplicação responde em localhost:3000"
else
    warning "Aplicação não responde em localhost:3000"
fi

# Testar IP direto
if curl -f -s http://177.153.51.81:3000 > /dev/null 2>&1; then
    success "Aplicação responde em http://177.153.51.81:3000"
else
    warning "Aplicação não responde no IP direto"
fi

# Testar Traefik HTTP
if curl -f -s http://177.153.51.81 > /dev/null 2>&1; then
    success "Traefik responde em http://177.153.51.81"
else
    warning "Traefik não responde no IP direto"
fi

# Testar Dashboard Traefik
if curl -f -s http://177.153.51.81:8080 > /dev/null 2>&1; then
    success "Dashboard Traefik responde em http://177.153.51.81:8080"
else
    warning "Dashboard Traefik não responde"
fi

# 11. Verificar DNS (se configurado)
log "10. Verificando DNS..."
echo ""
echo "=== VERIFICAÇÃO DNS ==="
if nslookup arpmanutencoes.com > /dev/null 2>&1; then
    DNS_IP=$(nslookup arpmanutencoes.com | grep "Address:" | tail -1 | awk '{print $2}')
    if [ "$DNS_IP" = "177.153.51.81" ]; then
        success "DNS configurado corretamente: arpmanutencoes.com → 177.153.51.81"
    else
        warning "DNS configurado mas aponta para: $DNS_IP (esperado: 177.153.51.81)"
    fi
else
    warning "DNS não configurado para arpmanutencoes.com"
    echo "Configure o DNS:"
    echo "A     arpmanutencoes.com     → 177.153.51.81"
    echo "CNAME www.arpmanutencoes.com → arpmanutencoes.com"
fi

# 12. Aguardar SSL (se DNS configurado)
if nslookup arpmanutencoes.com > /dev/null 2>&1; then
    log "11. Aguardando geração do certificado SSL..."
    echo "Isso pode levar até 2 minutos..."
    
    for i in {1..12}; do
        echo -n "Tentativa $i/12... "
        
        if curl -f -s https://arpmanutencoes.com > /dev/null 2>&1; then
            success "✅ SSL funcionando! Site acessível em https://arpmanutencoes.com"
            break
        else
            echo "Aguardando SSL..."
            sleep 10
        fi
    done
fi

# 13. Mostrar informações finais
echo ""
echo "🎉 Deploy concluído!"
echo "==================="
echo ""
echo "📊 Status dos containers:"
docker-compose ps
echo ""
echo "🌐 URLs disponíveis:"
echo "- Aplicação direta: http://177.153.51.81:3000"
echo "- Traefik HTTP: http://177.153.51.81"
echo "- Dashboard Traefik: http://177.153.51.81:8080"
if nslookup arpmanutencoes.com > /dev/null 2>&1; then
    echo "- Site (HTTP): http://arpmanutencoes.com"
    echo "- Site (HTTPS): https://arpmanutencoes.com"
    echo "- Site (www): https://www.arpmanutencoes.com"
fi
echo ""
echo "📋 Comandos úteis:"
echo "- Ver logs: docker-compose logs -f"
echo "- Parar: docker-compose down"
echo "- Reiniciar: docker-compose restart"
echo "- Status: docker-compose ps"
echo ""
echo "🔍 Troubleshooting:"
echo "- Diagnóstico: npm run diagnose"
echo "- Correção SSL: npm run fix-ssl"
echo "- Correção conexão: npm run fix-connection"
echo ""
echo "✅ Deploy para VPS 177.153.51.81 concluído!"
