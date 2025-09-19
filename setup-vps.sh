#!/bin/bash

# Script de Configuração da VPS - ARP Manutenções
# Execute como root ou com sudo

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
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
check_root() {
    if [ "$EUID" -ne 0 ]; then
        error "Execute este script como root ou com sudo"
        exit 1
    fi
}

# Detectar sistema operacional
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VERSION=$VERSION_ID
    else
        error "Sistema operacional não suportado"
        exit 1
    fi
    
    log "Sistema detectado: $OS $VERSION"
}

# Atualizar sistema
update_system() {
    log "Atualizando sistema..."
    
    if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
        apt update && apt upgrade -y
        apt install -y curl wget git nano htop
    elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]]; then
        yum update -y
        yum install -y curl wget git nano htop
    else
        error "Sistema operacional não suportado: $OS"
        exit 1
    fi
    
    success "Sistema atualizado"
}

# Instalar Docker
install_docker() {
    log "Instalando Docker..."
    
    if command -v docker &> /dev/null; then
        warning "Docker já está instalado"
        return
    fi
    
    # Instalar Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    
    # Iniciar e habilitar Docker
    systemctl enable docker
    systemctl start docker
    
    # Adicionar usuário ao grupo docker (se não for root)
    if [ "$SUDO_USER" ]; then
        usermod -aG docker "$SUDO_USER"
    fi
    
    success "Docker instalado"
}

# Instalar Docker Compose
install_docker_compose() {
    log "Instalando Docker Compose..."
    
    if command -v docker-compose &> /dev/null; then
        warning "Docker Compose já está instalado"
        return
    fi
    
    # Download da versão mais recente
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # Tornar executável
    chmod +x /usr/local/bin/docker-compose
    
    # Criar link simbólico
    ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    
    success "Docker Compose instalado"
}

# Configurar firewall
setup_firewall() {
    log "Configurando firewall..."
    
    if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
        # UFW
        apt install -y ufw
        ufw --force reset
        ufw default deny incoming
        ufw default allow outgoing
        ufw allow 22/tcp    # SSH
        ufw allow 80/tcp    # HTTP
        ufw allow 443/tcp   # HTTPS
        ufw allow 8080/tcp  # Traefik Dashboard (opcional)
        ufw --force enable
        success "Firewall UFW configurado"
        
    elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]]; then
        # Firewalld
        systemctl enable firewalld
        systemctl start firewalld
        firewall-cmd --permanent --add-service=ssh
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --permanent --add-port=8080/tcp
        firewall-cmd --reload
        success "Firewall firewalld configurado"
    fi
}

# Configurar swap
setup_swap() {
    log "Configurando swap..."
    
    if [ -f /swapfile ]; then
        warning "Swap já configurado"
        return
    fi
    
    # Criar arquivo de swap (2GB)
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    
    # Tornar permanente
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    
    # Otimizar configurações de swap
    echo 'vm.swappiness=10' >> /etc/sysctl.conf
    echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf
    
    success "Swap configurado (2GB)"
}

# Configurar logrotate
setup_logrotate() {
    log "Configurando logrotate..."
    
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
}

# Configurar monitoramento
setup_monitoring() {
    log "Configurando monitoramento básico..."
    
    # Script de monitoramento
    cat > /usr/local/bin/docker-monitor.sh << 'EOF'
#!/bin/bash

# Verificar se containers estão rodando
if ! docker ps | grep -q "Up"; then
    echo "$(date): Container down, restarting..." >> /var/log/docker-monitor.log
    
    # Tentar reiniciar (se estiver no diretório correto)
    if [ -f "/opt/arpmanutencoes/docker-compose.yml" ]; then
        cd /opt/arpmanutencoes && docker-compose restart
    fi
fi
EOF
    
    chmod +x /usr/local/bin/docker-monitor.sh
    
    # Adicionar ao crontab
    (crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/docker-monitor.sh") | crontab -
    
    success "Monitoramento configurado"
}

# Criar diretório da aplicação
setup_app_directory() {
    log "Criando diretório da aplicação..."
    
    mkdir -p /opt/arpmanutencoes
    chown -R $(whoami):$(whoami) /opt/arpmanutencoes 2>/dev/null || true
    
    success "Diretório criado: /opt/arpmanutencoes"
}

# Configurar usuário não-root (opcional)
setup_user() {
    if [ "$SUDO_USER" ]; then
        log "Configurando usuário: $SUDO_USER"
        
        # Adicionar usuário ao grupo docker
        usermod -aG docker "$SUDO_USER"
        
        # Criar chave SSH se não existir
        if [ ! -f "/home/$SUDO_USER/.ssh/id_rsa" ]; then
            sudo -u "$SUDO_USER" ssh-keygen -t rsa -b 4096 -f "/home/$SUDO_USER/.ssh/id_rsa" -N ""
        fi
        
        success "Usuário $SUDO_USER configurado"
    fi
}

# Mostrar informações finais
show_info() {
    echo ""
    echo "🎉 Configuração da VPS concluída!"
    echo "================================="
    echo ""
    echo "📋 Próximos passos:"
    echo "1. cd /opt/arpmanutencoes"
    echo "2. git clone SEU_REPOSITORIO ."
    echo "3. cp env.docker .env"
    echo "4. nano .env  # Editar configurações"
    echo "5. ./deploy.sh production"
    echo ""
    echo "🔗 URLs após deploy:"
    echo "- Site: https://arpmanutencoes.com"
    echo "- Dashboard Traefik: http://SEU_IP:8080"
    echo ""
    echo "📊 Comandos úteis:"
    echo "- Ver containers: docker ps"
    echo "- Ver logs: docker-compose logs -f"
    echo "- Parar: docker-compose down"
    echo "- Reiniciar: docker-compose restart"
    echo ""
    echo "🔒 Segurança:"
    echo "- Firewall configurado (portas 22, 80, 443, 8080)"
    echo "- Swap configurado (2GB)"
    echo "- Logrotate configurado"
    echo "- Monitoramento automático"
    echo ""
    
    if [ "$SUDO_USER" ]; then
        echo "👤 Para usar com usuário não-root:"
        echo "- Faça logout e login novamente"
        echo "- Ou execute: newgrp docker"
    fi
}

# Função principal
main() {
    echo "🚀 Configuração da VPS - ARP Manutenções"
    echo "========================================"
    
    check_root
    detect_os
    update_system
    install_docker
    install_docker_compose
    setup_firewall
    setup_swap
    setup_logrotate
    setup_monitoring
    setup_app_directory
    setup_user
    show_info
}

# Executar
main "$@"
