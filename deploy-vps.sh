#!/bin/bash

# Script de Deploy Rápido na VPS - ARP Manutenções
# Para VPS com Docker já instalado

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

# Verificar Docker
check_docker() {
    log "Verificando Docker..."
    if ! command -v docker &> /dev/null; then
        error "Docker não está instalado!"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        error "Docker Compose não está instalado!"
        exit 1
    fi
    
    success "Docker está funcionando"
}

# Configurar ambiente
setup_environment() {
    log "Configurando ambiente..."
    
    # Criar diretório se não existir
    mkdir -p /opt/arpmanutencoes
    cd /opt/arpmanutencoes
    
    # Verificar se é um repositório git
    if [ ! -d ".git" ]; then
        warning "Diretório não é um repositório git"
        echo "Execute: git clone SEU_REPOSITORIO ."
        read -p "Pressione Enter após clonar o repositório..."
    fi
    
    # Configurar .env
    if [ ! -f ".env" ]; then
        if [ -f "env.docker" ]; then
            log "Copiando env.docker para .env..."
            cp env.docker .env
            warning "Por favor, edite o arquivo .env com suas configurações!"
            echo "Execute: nano .env"
            read -p "Pressione Enter após editar o .env..."
        else
            error "Arquivo env.docker não encontrado!"
            exit 1
        fi
    fi
    
    success "Ambiente configurado"
}

# Configurar firewall (se necessário)
setup_firewall() {
    log "Verificando firewall..."
    
    # Verificar se UFW está instalado
    if command -v ufw &> /dev/null; then
        if ! ufw status | grep -q "80/tcp"; then
            log "Configurando firewall..."
            ufw allow 22/tcp    # SSH
            ufw allow 80/tcp    # HTTP
            ufw allow 443/tcp   # HTTPS
            ufw allow 8080/tcp  # Traefik Dashboard
            success "Firewall configurado"
        else
            success "Firewall já configurado"
        fi
    else
        warning "UFW não encontrado, configure o firewall manualmente"
    fi
}

# Deploy
deploy() {
    log "Iniciando deploy..."
    
    # Parar containers existentes
    log "Parando containers existentes..."
    docker-compose down 2>/dev/null || true
    
    # Build e start
    log "Construindo e iniciando containers..."
    docker-compose --profile production up --build -d
    
    # Aguardar containers iniciarem
    log "Aguardando containers iniciarem..."
    sleep 15
    
    # Verificar status
    log "Verificando status dos containers..."
    docker-compose ps
    
    # Verificar se aplicação está respondendo
    log "Testando aplicação..."
    if curl -f -s http://localhost:3000 > /dev/null 2>&1; then
        success "Aplicação está respondendo!"
    else
        warning "Aplicação pode não estar respondendo ainda..."
        log "Verifique os logs: docker-compose logs app"
    fi
}

# Mostrar informações
show_info() {
    echo ""
    echo "🎉 Deploy concluído!"
    echo "=================="
    echo ""
    echo "📋 Status dos containers:"
    docker-compose ps
    echo ""
    echo "🔗 URLs:"
    echo "- Aplicação: http://localhost:3000"
    echo "- Traefik Dashboard: http://SEU_IP:8080"
    echo "- Site (se DNS configurado): https://arpmanutencoes.com"
    echo ""
    echo "📊 Comandos úteis:"
    echo "- Ver logs: docker-compose logs -f"
    echo "- Parar: docker-compose down"
    echo "- Reiniciar: docker-compose restart"
    echo "- Status: docker-compose ps"
    echo ""
    echo "🔍 Verificar SSL:"
    echo "- Aguarde alguns minutos para o Let's Encrypt gerar o certificado"
    echo "- Verifique em: https://arpmanutencoes.com"
    echo ""
}

# Função principal
main() {
    echo "🚀 Deploy Rápido na VPS - ARP Manutenções"
    echo "========================================="
    
    check_docker
    setup_environment
    setup_firewall
    deploy
    show_info
}

# Executar
main "$@"
