#!/bin/bash

# Script de Deploy Automático - ARP Manutenções
# Uso: ./deploy.sh [ambiente]
# Exemplo: ./deploy.sh production

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log
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

# Verificar se Docker está instalado
check_docker() {
    log "Verificando Docker..."
    if ! command -v docker &> /dev/null; then
        error "Docker não está instalado!"
        echo "Execute: curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        error "Docker Compose não está instalado!"
        exit 1
    fi
    
    success "Docker e Docker Compose estão instalados"
}

# Verificar arquivo .env
check_env() {
    log "Verificando arquivo .env..."
    if [ ! -f ".env" ]; then
        warning "Arquivo .env não encontrado!"
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
    success "Arquivo .env encontrado"
}

# Verificar DNS
check_dns() {
    log "Verificando DNS..."
    if grep -q "arpmanutencoes.com" .env; then
        DOMAIN=$(grep "NEXT_PUBLIC_SITE_URL" .env | cut -d'=' -f2 | sed 's|https://||')
        if [ "$DOMAIN" != "localhost" ] && [ "$DOMAIN" != "127.0.0.1" ]; then
            if nslookup "$DOMAIN" &> /dev/null; then
                success "DNS configurado para $DOMAIN"
            else
                warning "DNS pode não estar configurado para $DOMAIN"
            fi
        fi
    fi
}

# Backup
backup() {
    log "Criando backup..."
    BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup do código
    tar -czf "$BACKUP_DIR/code.tar.gz" --exclude=node_modules --exclude=.git --exclude=backups .
    
    # Backup dos volumes Docker (se existirem)
    if docker volume ls | grep -q "arpmanutencoes"; then
        docker run --rm -v arpmanutencoes_letsencrypt:/data -v "$(pwd)/$BACKUP_DIR":/backup alpine tar czf /backup/letsencrypt.tar.gz -C /data . 2>/dev/null || true
    fi
    
    success "Backup criado em $BACKUP_DIR"
}

# Deploy
deploy() {
    local ENV=${1:-production}
    
    log "Iniciando deploy para ambiente: $ENV"
    
    # Parar containers existentes
    log "Parando containers existentes..."
    docker-compose down 2>/dev/null || true
    
    # Limpar imagens antigas (opcional)
    if [ "$CLEANUP" = "true" ]; then
        log "Limpando imagens antigas..."
        docker system prune -f
    fi
    
    # Build e start
    log "Construindo e iniciando containers..."
    if [ "$ENV" = "production" ]; then
        docker-compose --profile production up --build -d
    else
        docker-compose --profile dev up --build -d
    fi
    
    # Aguardar containers iniciarem
    log "Aguardando containers iniciarem..."
    sleep 10
    
    # Verificar status
    log "Verificando status dos containers..."
    docker-compose ps
    
    # Verificar se aplicação está respondendo
    log "Testando aplicação..."
    if curl -f -s http://localhost:3000 > /dev/null; then
        success "Aplicação está respondendo!"
    else
        error "Aplicação não está respondendo!"
        log "Logs da aplicação:"
        docker-compose logs app
        exit 1
    fi
}

# Monitoramento
monitor() {
    log "Iniciando monitoramento..."
    echo "Pressione Ctrl+C para parar"
    
    while true; do
        clear
        echo "=== STATUS DOS CONTAINERS ==="
        docker-compose ps
        echo ""
        echo "=== LOGS RECENTES ==="
        docker-compose logs --tail=10 app
        echo ""
        echo "=== RECURSOS ==="
        docker stats --no-stream
        sleep 5
    done
}

# Função principal
main() {
    echo "🚀 Deploy Automático - ARP Manutenções"
    echo "======================================"
    
    # Verificações
    check_docker
    check_env
    check_dns
    
    # Backup (se solicitado)
    if [ "$BACKUP" = "true" ]; then
        backup
    fi
    
    # Deploy
    deploy "$1"
    
    success "Deploy concluído com sucesso!"
    echo ""
    echo "📋 Próximos passos:"
    echo "1. Verificar se o site está funcionando"
    echo "2. Testar SSL (se configurado)"
    echo "3. Configurar monitoramento"
    echo ""
    echo "🔗 URLs:"
    echo "- Aplicação: http://localhost:3000"
    echo "- Traefik Dashboard: http://localhost:8080"
    echo ""
    echo "📊 Comandos úteis:"
    echo "- Ver logs: docker-compose logs -f"
    echo "- Parar: docker-compose down"
    echo "- Monitorar: ./deploy.sh monitor"
}

# Processar argumentos
case "${1:-production}" in
    "production"|"prod")
        main "production"
        ;;
    "development"|"dev")
        main "development"
        ;;
    "monitor")
        monitor
        ;;
    "backup")
        BACKUP=true
        main "production"
        ;;
    "clean")
        CLEANUP=true
        main "production"
        ;;
    "help"|"-h"|"--help")
        echo "Uso: $0 [comando]"
        echo ""
        echo "Comandos:"
        echo "  production, prod  - Deploy em produção (padrão)"
        echo "  development, dev  - Deploy em desenvolvimento"
        echo "  monitor          - Monitorar containers"
        echo "  backup           - Fazer backup antes do deploy"
        echo "  clean            - Limpar imagens antigas"
        echo "  help             - Mostrar esta ajuda"
        ;;
    *)
        error "Comando inválido: $1"
        echo "Use '$0 help' para ver os comandos disponíveis"
        exit 1
        ;;
esac
