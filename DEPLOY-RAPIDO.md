# 🚀 Deploy Rápido na VPS - Docker Já Instalado

Guia super rápido para fazer deploy quando o Docker já está instalado na VPS.

## ⚡ Deploy em 3 Passos

### **1. Conectar na VPS**
```bash
ssh root@SEU_IP_VPS
```

### **2. Preparar Ambiente**
```bash
# Criar diretório
mkdir -p /opt/arpmanutencoes
cd /opt/arpmanutencoes

# Clonar repositório (substitua pela sua URL)
git clone https://github.com/SEU_USUARIO/arpmanutencoes-front.git .

# Configurar ambiente
cp env.docker .env
nano .env  # Editar configurações
```

### **3. Deploy**
```bash
# Opção 1: Deploy completo com verificações
npm run deploy:vps-simple

# Opção 2: Deploy super rápido (apenas restart)
npm run deploy:quick
```

## 📋 Scripts Disponíveis

### **Deploy Completo**
```bash
npm run deploy:vps-simple
```
- ✅ Verifica Docker
- ✅ Configura ambiente
- ✅ Configura firewall
- ✅ Faz deploy completo
- ✅ Mostra status

### **Deploy Rápido**
```bash
npm run deploy:quick
```
- ⚡ Para quando já está tudo configurado
- ⚡ Apenas para e reinicia containers
- ⚡ Atualiza código se for git

### **Outros Scripts**
```bash
# Ver logs
npm run docker:logs

# Parar containers
npm run docker:down

# Monitorar
npm run deploy:monitor

# Backup
npm run deploy:backup
```

## 🔧 Configuração do .env

Edite o arquivo `.env` com suas configurações:

```bash
# Site
NEXT_PUBLIC_SITE_URL=https://arpmanutencoes.com
NEXT_PUBLIC_SITE_NAME=ARP Manutenções

# Contato
NEXT_PUBLIC_PHONE=(31) 99999-9999
NEXT_PUBLIC_EMAIL=contato@arpmanutencoes.com
NEXT_PUBLIC_WHATSAPP=5531999999999

# Email (para formulário)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=seu-email@gmail.com
SMTP_PASS=sua-senha-de-app
```

## 🌐 URLs Após Deploy

- **Site**: `https://arpmanutencoes.com`
- **Dashboard Traefik**: `http://SEU_IP:8080`
- **Logs**: `docker-compose logs -f`

## 🔍 Verificações

### **Status dos Containers**
```bash
docker-compose ps
```

### **Logs da Aplicação**
```bash
docker-compose logs -f app
```

### **Testar Site**
```bash
curl -I http://localhost:3000
```

### **Verificar SSL**
```bash
curl -I https://arpmanutencoes.com
```

## 🚨 Troubleshooting

### **Container não inicia**
```bash
# Ver logs
docker-compose logs app

# Reiniciar
docker-compose restart

# Rebuild
docker-compose up --build -d
```

### **SSL não funciona**
```bash
# Verificar DNS
nslookup arpmanutencoes.com

# Ver logs do Traefik
docker-compose logs traefik

# Aguardar alguns minutos para Let's Encrypt
```

### **Site não carrega**
```bash
# Verificar portas
netstat -tulpn | grep :80
netstat -tulpn | grep :443

# Verificar firewall
ufw status
```

## 📊 Comandos de Manutenção

### **Atualizar Aplicação**
```bash
cd /opt/arpmanutencoes
git pull origin main
npm run deploy:quick
```

### **Backup**
```bash
# Backup do código
tar -czf backup-$(date +%Y%m%d).tar.gz /opt/arpmanutencoes

# Backup dos volumes
docker run --rm -v arpmanutencoes_letsencrypt:/data -v $(pwd):/backup alpine tar czf /backup/letsencrypt-$(date +%Y%m%d).tar.gz -C /data .
```

### **Limpeza**
```bash
# Limpar imagens antigas
docker system prune -f

# Limpar volumes não utilizados
docker volume prune -f
```

## ✅ Checklist Rápido

- [ ] VPS com Docker instalado
- [ ] Domínio apontando para VPS
- [ ] Repositório clonado
- [ ] Arquivo .env configurado
- [ ] Deploy executado
- [ ] Site funcionando
- [ ] SSL funcionando

## 🎯 Resultado

Após seguir este guia, você terá:

- ✅ Site funcionando em `https://arpmanutencoes.com`
- ✅ SSL automático
- ✅ Deploy automatizado
- ✅ Monitoramento básico

## 💡 Dicas

1. **Primeiro deploy**: Use `npm run deploy:vps-simple`
2. **Atualizações**: Use `npm run deploy:quick`
3. **Problemas**: Verifique logs com `npm run docker:logs`
4. **SSL**: Aguarde alguns minutos após o primeiro deploy
5. **DNS**: Certifique-se que está apontando para a VPS

---

**🚀 Deploy em menos de 5 minutos!**
