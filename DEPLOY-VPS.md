# 🚀 Deploy na VPS - ARP Manutenções

Guia completo para fazer deploy da aplicação em uma VPS.

## 📋 Pré-requisitos

### **VPS/Server**
- ✅ Ubuntu 20.04+ ou CentOS 8+
- ✅ Mínimo 2GB RAM
- ✅ 20GB de espaço em disco
- ✅ Acesso root/sudo
- ✅ Domínio `arpmanutencoes.com` apontando para o IP da VPS

### **Ferramentas Necessárias**
- Docker
- Docker Compose
- Git
- Nginx (opcional, se não usar Traefik)

## 🔧 Configuração da VPS

### **1. Conectar na VPS**
```bash
ssh root@SEU_IP_VPS
# ou
ssh usuario@SEU_IP_VPS
```

### **2. Atualizar Sistema**
```bash
# Ubuntu/Debian
apt update && apt upgrade -y

# CentOS/RHEL
yum update -y
```

### **3. Instalar Docker**
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker
systemctl start docker

# CentOS/RHEL
yum install -y docker
systemctl enable docker
systemctl start docker
```

### **4. Instalar Docker Compose**
```bash
# Download da versão mais recente
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Tornar executável
chmod +x /usr/local/bin/docker-compose

# Verificar instalação
docker-compose --version
```

### **5. Configurar Firewall**
```bash
# UFW (Ubuntu)
ufw allow 22    # SSH
ufw allow 80    # HTTP
ufw allow 443   # HTTPS
ufw enable

# Firewall (CentOS)
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload
```

## 📦 Deploy da Aplicação

### **1. Clonar Repositório**
```bash
# Criar diretório para a aplicação
mkdir -p /opt/arpmanutencoes
cd /opt/arpmanutencoes

# Clonar repositório (substitua pela sua URL)
git clone https://github.com/seu-usuario/arpmanutencoes-front.git .
```

### **2. Configurar Ambiente**
```bash
# Copiar arquivo de ambiente
cp env.docker .env

# Editar configurações
nano .env
```

### **3. Configurações do .env**
```bash
# Editar as seguintes variáveis:
NEXT_PUBLIC_SITE_URL=https://arpmanutencoes.com
NEXT_PUBLIC_PHONE=(31) 99851-2887
NEXT_PUBLIC_WHATSAPP=553198512887
NEXT_PUBLIC_EMAIL=contato@arpmanutencoes.com

# Configurações de Email (para formulário)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=seu-email@gmail.com
SMTP_PASS=sua-senha-de-app
```

### **4. Executar Deploy**
```bash
# Build e start dos serviços
docker-compose --profile production up --build -d

# Verificar se está rodando
docker-compose ps
docker-compose logs -f app
```

## 🌐 Configuração DNS

### **Registros DNS Necessários**
```
A     arpmanutencoes.com     → IP_DA_VPS
CNAME www.arpmanutencoes.com → arpmanutencoes.com
```

### **Verificar DNS**
```bash
# Testar resolução DNS
nslookup arpmanutencoes.com
dig arpmanutencoes.com
```

## 🔒 SSL Automático

O Traefik automaticamente:
- ✅ Gera certificados SSL com Let's Encrypt
- ✅ Renova certificados automaticamente
- ✅ Redireciona HTTP para HTTPS
- ✅ Funciona para www e domínio principal

### **Verificar SSL**
```bash
# Testar SSL
curl -I https://arpmanutencoes.com
openssl s_client -connect arpmanutencoes.com:443 -servername arpmanutencoes.com
```

## 📊 Monitoramento

### **1. Verificar Status dos Containers**
```bash
# Status dos serviços
docker-compose ps

# Logs da aplicação
docker-compose logs -f app

# Logs do Traefik
docker-compose logs -f traefik
```

### **2. Dashboard do Traefik**
- URL: `http://SEU_IP_VPS:8080`
- Mostra status dos serviços e certificados SSL

### **3. Monitoramento de Recursos**
```bash
# Uso de recursos
docker stats

# Espaço em disco
df -h

# Memória
free -h
```

## 🔄 Comandos de Manutenção

### **Atualizar Aplicação**
```bash
cd /opt/arpmanutencoes

# Parar serviços
docker-compose down

# Atualizar código
git pull origin main

# Rebuild e restart
docker-compose --profile production up --build -d
```

### **Backup**
```bash
# Backup do código
tar -czf backup-$(date +%Y%m%d).tar.gz /opt/arpmanutencoes

# Backup dos volumes Docker
docker run --rm -v arpmanutencoes_letsencrypt:/data -v $(pwd):/backup alpine tar czf /backup/letsencrypt-$(date +%Y%m%d).tar.gz -C /data .
```

### **Logs e Debug**
```bash
# Ver logs em tempo real
docker-compose logs -f

# Logs específicos
docker-compose logs app
docker-compose logs traefik

# Entrar no container
docker-compose exec app sh
```

## 🚨 Troubleshooting

### **Problemas Comuns**

#### **1. Container não inicia**
```bash
# Verificar logs
docker-compose logs app

# Verificar recursos
docker stats

# Reiniciar serviços
docker-compose restart
```

#### **2. SSL não funciona**
```bash
# Verificar DNS
nslookup arpmanutencoes.com

# Verificar portas
netstat -tulpn | grep :80
netstat -tulpn | grep :443

# Verificar logs do Traefik
docker-compose logs traefik
```

#### **3. Site não carrega**
```bash
# Verificar se containers estão rodando
docker-compose ps

# Testar conectividade
curl -I http://localhost:3000

# Verificar firewall
ufw status
```

#### **4. Problemas de Performance**
```bash
# Verificar recursos
htop
docker stats

# Limpar cache Docker
docker system prune -f

# Reiniciar containers
docker-compose restart
```

## 📈 Otimizações

### **1. Configurar Swap**
```bash
# Criar arquivo de swap
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Tornar permanente
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

### **2. Configurar Logrotate**
```bash
# Criar configuração para logs do Docker
cat > /etc/logrotate.d/docker-containers << EOF
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
```

### **3. Monitoramento Automático**
```bash
# Script de monitoramento
cat > /opt/arpmanutencoes/monitor.sh << 'EOF'
#!/bin/bash
if ! docker-compose ps | grep -q "Up"; then
    echo "Container down, restarting..."
    docker-compose restart
fi
EOF

chmod +x /opt/arpmanutencoes/monitor.sh

# Adicionar ao crontab
echo "*/5 * * * * /opt/arpmanutencoes/monitor.sh" | crontab -
```

## ✅ Checklist de Deploy

### **Antes do Deploy**
- [ ] VPS configurada com Docker
- [ ] Domínio apontando para VPS
- [ ] Firewall configurado
- [ ] Arquivo .env configurado

### **Durante o Deploy**
- [ ] Repositório clonado
- [ ] Containers iniciados
- [ ] SSL funcionando
- [ ] Site acessível

### **Após o Deploy**
- [ ] Testar todas as funcionalidades
- [ ] Configurar monitoramento
- [ ] Fazer backup inicial
- [ ] Documentar acesso

## 🎯 Resultado Final

Após seguir este guia, você terá:

- ✅ Site funcionando em `https://arpmanutencoes.com`
- ✅ SSL automático com Let's Encrypt
- ✅ Traefik como proxy reverso
- ✅ Deploy automatizado
- ✅ Monitoramento básico
- ✅ Backup configurado

## 📞 Suporte

Em caso de problemas:
1. Verificar logs: `docker-compose logs -f`
2. Verificar status: `docker-compose ps`
3. Reiniciar serviços: `docker-compose restart`
4. Verificar recursos: `htop`, `df -h`
