#!/bin/bash

# Exemplo de configuração de variáveis de ambiente para uso local
# NÃO use este script em produção ou para armazenar dados reais

cat > .env << EOF
# GitLab Credentials
GITLAB_EMAIL=usuario@exemplo.com
GITLAB_USERNAME=usuarioexemplo
GITLAB_PASSWORD=senha_ficticia
GITLAB_TOKEN=glpat-xxxxxxxxxxxxxxxxxxxx

# Project Configuration
PROJECT_NAME=meuprojeto
PROJECT_VISIBILITY=private
EOF

echo "Arquivo .env de exemplo criado com dados fictícios. Edite conforme necessário para uso local." 