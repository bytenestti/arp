# 🔒 Troubleshooting SSL - ARP Manutenções

Guia para resolver problemas de certificado SSL com Let's Encrypt.

## 🚨 Problemas Comuns

### **1. Erro "remote error: tls: no application protocol"**

**Causa:** Configuração incorreta do ACME challenge no Traefik.

**Solução:**
```bash
# Usar correção automática
npm run fix-ssl

# Ou correção manual:
docker-compose down
rm -rf ./letsencrypt
mkdir -p ./letsencrypt
chmod 600 ./letsencrypt
docker-compose --profile production up -d
```

### **2. Erro "Unable to obtain ACME certificate"**

**Causas possíveis:**
- DNS não configurado corretamente
- Porta 80 não acessível
- Rate limit do Let's Encrypt

**Solução:**
```bash
# 1. Verificar DNS
nslookup arpmanutencoes.com
nslookup www.arpmanutencoes.com

# 2. Verificar porta 80
netstat -tulpn | grep :80

# 3. Limpar e tentar novamente
npm run fix-ssl
```

### **3. Warning "version is obsolete"**

**Causa:** Docker Compose versão 3.8+ não precisa do campo `version`.

**Solução:** Já corrigido no `docker-compose.yml`.

## 🔧 Correções Implementadas

### **1. Docker Compose Corrigido**
- ✅ Removido campo `version` obsoleto
- ✅ Mudado de `tlschallenge` para `httpchallenge`
- ✅ Adicionado volume `letsencrypt`
- ✅ Configuração de rede melhorada

### **2. Configuração ACME Corrigida**
```yaml
# Antes (problemático)
- "--certificatesresolvers.myresolver.acme.tlschallenge=true"

# Depois (correto)
- "--certificatesresolvers.myresolver.acme.httpchallenge=true"
- "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web"
```

## 📋 Checklist de Verificação

### **Pré-requisitos:**
- [ ] DNS configurado (A record para VPS)
- [ ] Porta 80 acessível externamente
- [ ] Firewall configurado (portas 80, 443)
- [ ] Domínio apontando para IP da VPS

### **Verificações DNS:**
```bash
# Verificar se DNS está correto
nslookup arpmanutencoes.com
dig arpmanutencoes.com

# Deve retornar o IP da VPS
```

### **Verificações de Rede:**
```bash
# Verificar se portas estão abertas
netstat -tulpn | grep :80
netstat -tulpn | grep :443

# Testar conectividade externa
curl -I http://arpmanutencoes.com
```

## 🛠️ Comandos de Diagnóstico

### **1. Verificar Status dos Containers**
```bash
docker-compose ps
docker ps
```

### **2. Verificar Logs do Traefik**
```bash
# Logs em tempo real
docker-compose logs -f traefik

# Últimas 50 linhas
docker-compose logs --tail=50 traefik

# Filtrar erros
docker-compose logs traefik | grep -i error
```

### **3. Verificar Certificados**
```bash
# Verificar se diretório existe
ls -la ./letsencrypt/

# Verificar conteúdo do acme.json
cat ./letsencrypt/acme.json | jq .
```

### **4. Testar Conectividade**
```bash
# HTTP (deve funcionar)
curl -I http://arpmanutencoes.com

# HTTPS (pode falhar se certificado não foi gerado)
curl -I https://arpmanutencoes.com

# HTTPS ignorando certificado
curl -I -k https://arpmanutencoes.com
```

## 🚀 Soluções Rápidas

### **Solução 1: Correção Automática**
```bash
npm run fix-ssl
```

### **Solução 2: Reset Completo**
```bash
# Parar tudo
docker-compose down

# Limpar volumes
docker volume prune -f

# Limpar certificados
rm -rf ./letsencrypt

# Reiniciar
docker-compose --profile production up --build -d
```

### **Solução 3: Verificação Manual**
```bash
# 1. Verificar DNS
nslookup arpmanutencoes.com

# 2. Verificar logs
docker-compose logs traefik

# 3. Aguardar (até 2 minutos)
sleep 120

# 4. Testar
curl -I https://arpmanutencoes.com
```

## ⏱️ Tempos de Espera

- **DNS propagation:** 5-60 minutos
- **Let's Encrypt validation:** 1-2 minutos
- **Certificate generation:** 30-60 segundos
- **Traefik reload:** 10-30 segundos

## 🔍 Logs Importantes

### **Logs de Sucesso:**
```
traefik-1  | level=info msg="Certificate obtained for domains [arpmanutencoes.com www.arpmanutencoes.com]"
traefik-1  | level=info msg="Certificate obtained for domains [arpmanutencoes.com]"
```

### **Logs de Erro:**
```
traefik-1  | level=error msg="Unable to obtain ACME certificate"
traefik-1  | level=error msg="acme: error: 400"
```

## 📞 Suporte Adicional

Se os problemas persistirem:

1. **Verificar Rate Limits:**
   - Let's Encrypt tem limite de 50 certificados por domínio por semana
   - Use staging environment para testes: `--certificatesresolvers.myresolver.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory`

2. **Verificar Firewall:**
   ```bash
   # UFW
   ufw status
   ufw allow 80/tcp
   ufw allow 443/tcp
   
   # Firewalld
   firewall-cmd --list-ports
   firewall-cmd --add-port=80/tcp --permanent
   firewall-cmd --add-port=443/tcp --permanent
   ```

3. **Verificar Recursos:**
   ```bash
   # Memória
   free -h
   
   # Disco
   df -h
   
   # CPU
   top
   ```

---

**🎯 Com o script `npm run fix-ssl`, a maioria dos problemas de SSL são resolvidos automaticamente!**
