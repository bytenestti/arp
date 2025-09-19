#!/bin/bash

# Script para configurar arquivo .env para Docker

echo "🚀 Configurando arquivo .env para Docker..."

# Copiar arquivo de exemplo
cp env.docker .env

echo "✅ Arquivo .env criado com sucesso!"
echo ""
echo "📋 Próximos passos:"
echo "1. Edite o arquivo .env com suas configurações específicas"
echo "2. Configure as credenciais de email (SMTP_PASS)"
echo "3. Execute: npm run docker:prod"
echo ""
echo "🔧 Configurações importantes no .env:"
echo "- NEXT_PUBLIC_SITE_URL: URL do seu site"
echo "- NEXT_PUBLIC_PHONE: Telefone de contato"
echo "- NEXT_PUBLIC_EMAIL: Email de contato"
echo "- SMTP_PASS: Senha do email para formulário de contato"
echo ""
echo "⚠️  Lembre-se de:"
echo "- Nunca commitar o arquivo .env no Git"
echo "- Manter o .env seguro em produção"
echo "- Usar senhas de app para Gmail"
