#!/bin/bash

# Script de Configuração para VPS 177.153.51.81
# ARP Manutenções

set -e

echo "🚀 Configuração para VPS 177.153.51.81 - ARP Manutenções"
echo "======================================================"

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

# Verificar se é root
if [ "$EUID" -ne 0 ]; then
    error "Execute este script como root ou com sudo"
    exit 1
fi

# 1. Verificar IP da VPS
log "1. Verificando IP da VPS..."
CURRENT_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip)
if [ "$CURRENT_IP" = "177.153.51.81" ]; then
    success "IP da VPS confirmado: 177.153.51.81"
else
    warning "IP atual: $CURRENT_IP (esperado: 177.153.51.81)"
fi

# 2. Atualizar sistema
log "2. Atualizando sistema..."
apt update && apt upgrade -y
success "Sistema atualizado"

# 3. Instalar Docker (se não estiver instalado)
log "3. Verificando Docker..."
if ! command -v docker &> /dev/null; then
    log "Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    systemctl enable docker
    systemctl start docker
    success "Docker instalado"
else
    success "Docker já está instalado"
fi

# 4. Instalar Docker Compose (se não estiver instalado)
log "4. Verificando Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    log "Instalando Docker Compose..."
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    success "Docker Compose instalado"
else
    success "Docker Compose já está instalado"
fi

# 5. Configurar firewall
log "5. Configurando firewall..."
apt install -y ufw
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 8080/tcp  # Traefik Dashboard
ufw --force enable
success "Firewall configurado"

# 6. Configurar swap
log "6. Configurando swap..."
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    success "Swap configurado (2GB)"
else
    success "Swap já configurado"
fi

# 7. Criar diretório da aplicação
log "7. Criando diretório da aplicação..."
mkdir -p /opt/arpmanutencoes
success "Diretório criado: /opt/arpmanutencoes"

# 8. Configurar monitoramento
log "8. Configurando monitoramento..."
cat > /usr/local/bin/docker-monitor.sh << 'EOF'
#!/bin/bash
if ! docker ps | grep -q "Up"; then
    echo "$(date): Container down, restarting..." >> /var/log/docker-monitor.log
    if [ -f "/opt/arpmanutencoes/docker-compose.yml" ]; then
        cd /opt/arpmanutencoes && docker-compose restart
    fi
fi
EOF

chmod +x /usr/local/bin/docker-monitor.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/docker-monitor.sh") | crontab -
success "Monitoramento configurado"

# 9. Configurar logrotate
log "9. Configurando logrotate..."
cat > /etc/logrotate.d/docker-containers << 'EOF'
/var/lib/docker/containers/*/*.log {
    rotate 7
    daily
    compress
    size=1M
    missingok
    delaycompress
    copytruncate
}
EOF
success "Logrotate configurado"

# 10. Mostrar informações finais
echo ""
echo "🎉 Configuração da VPS 177.153.51.81 concluída!"
echo "=============================================="
echo ""
echo "📋 Próximos passos:"
echo "1. cd /opt/arpmanutencoes"
echo "2. git clone SEU_REPOSITORIO ."
echo "3. cp env.docker .env"
echo "4. nano .env  # Editar configurações"
echo "5. npm run deploy:vps-simple"
echo ""
echo "🌐 URLs após deploy:"
echo "- Site: https://arpmanutencoes.com"
echo "- Dashboard: http://177.153.51.81:8080"
echo ""
echo "📊 Comandos úteis:"
echo "- Ver containers: docker ps"
echo "- Ver logs: docker-compose logs -f"
echo "- Parar: docker-compose down"
echo "- Reiniciar: docker-compose restart"
echo ""
echo "🔒 Configurações de segurança:"
echo "- Firewall configurado (portas 22, 80, 443, 8080)"
echo "- Swap configurado (2GB)"
echo "- Logrotate configurado"
echo "- Monitoramento automático"
echo ""
echo "📋 DNS para configurar:"
echo "A     arpmanutencoes.com     → 177.153.51.81"
echo "CNAME www.arpmanutencoes.com → arpmanutencoes.com"
echo ""
echo "✅ VPS pronta para deploy!"
