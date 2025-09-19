# 🐳 Docker Setup - ARP Manutenções

Este projeto está configurado para ser executado com Docker usando Traefik como proxy reverso.

## 📋 Pré-requisitos

- Docker
- Docker Compose
- Domínio configurado (opcional, para produção)

## 🚀 Como Executar

### Configuração Inicial

```bash
# 1. Configurar arquivo de ambiente
npm run docker:setup

# 2. Editar arquivo .env com suas configurações
# - Telefone de contato
# - Email
# - Credenciais SMTP
# - URLs do site
```

### Desenvolvimento

```bash
# Executar em modo desenvolvimento
npm run docker:dev

# Ou diretamente com docker-compose
docker-compose --profile dev up --build
```

A aplicação estará disponível em: http://localhost:3001

### Produção

```bash
# Executar em modo produção com Traefik
npm run docker:prod

# Ou diretamente com docker-compose
docker-compose --profile production up --build -d
```

A aplicação estará disponível em:
- http://localhost:3000 (direto)
- http://localhost:8080 (dashboard do Traefik)

### Comandos Úteis

```bash
# Ver logs
npm run docker:logs

# Parar todos os serviços
npm run docker:down

# Limpar containers e volumes
npm run docker:clean

# Build apenas da imagem
npm run docker:build

# Executar container individual
npm run docker:run
```

## 🔧 Configuração do Traefik

### Variáveis de Ambiente

Edite o arquivo `docker-compose.yml` e ajuste:

- `contato@arpmanutencoes.com` - Email para certificados SSL
- `arpmanutencoes.com` - Seu domínio
- `www.arpmanutencoes.com` - Subdomínio www

### Certificados SSL

O Traefik automaticamente:
- ✅ Gera certificados SSL com Let's Encrypt
- ✅ Redireciona HTTP para HTTPS
- ✅ Renova certificados automaticamente

### Dashboard do Traefik

Acesse: http://localhost:8080

## 📁 Estrutura de Arquivos

```
├── Dockerfile              # Build para produção
├── Dockerfile.dev          # Build para desenvolvimento
├── docker-compose.yml      # Orquestração dos serviços
├── traefik.yml            # Configuração do Traefik
├── .dockerignore          # Arquivos ignorados no build
└── letsencrypt/           # Certificados SSL (criado automaticamente)
```

## 🌐 Configuração de Domínio

O site está configurado para o domínio: **arpmanutencoes.com**

### Configuração DNS

Configure o DNS apontando para seu servidor:
```
A     arpmanutencoes.com     → IP_DO_SERVIDOR
CNAME www.arpmanutencoes.com → arpmanutencoes.com
```

### SSL Automático

O Traefik automaticamente:
- ✅ Gera certificados SSL para `arpmanutencoes.com`
- ✅ Gera certificados SSL para `www.arpmanutencoes.com`
- ✅ Redireciona www para domínio principal
- ✅ Renova certificados automaticamente

### Deploy em Produção

```bash
# 1. Configure o arquivo .env
npm run docker:setup
# Edite o arquivo .env com suas configurações

# 2. Configure o DNS
# 3. Execute em produção
npm run docker:prod

# 4. Acesse o site
# https://arpmanutencoes.com
# https://www.arpmanutencoes.com
```

## 🔍 Troubleshooting

### Porta já em uso
```bash
# Verificar portas em uso
netstat -tulpn | grep :3000

# Parar serviços
npm run docker:down
```

### Problemas de build
```bash
# Limpar cache do Docker
docker system prune -a

# Rebuild sem cache
docker-compose build --no-cache
```

### Logs de erro
```bash
# Ver logs detalhados
docker-compose logs app
docker-compose logs traefik
```

## 📊 Monitoramento

- **Traefik Dashboard**: http://localhost:8080
- **Logs da aplicação**: `npm run docker:logs`
- **Métricas**: Configuradas no Traefik para Prometheus

## 🔒 Segurança

- ✅ Usuário não-root nos containers
- ✅ Certificados SSL automáticos
- ✅ Headers de segurança do Traefik
- ✅ Rede isolada entre serviços

## 📈 Escalabilidade

Para escalar horizontalmente:

```bash
# Escalar para 3 instâncias
docker-compose --profile production up --scale app=3 -d
```

O Traefik automaticamente fará load balancing entre as instâncias.
