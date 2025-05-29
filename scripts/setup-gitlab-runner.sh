#!/bin/bash

# Instalar dependências
sudo apt-get update
sudo apt-get install -y curl

# Adicionar o repositório oficial do GitLab
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

# Instalar o GitLab Runner
sudo apt-get install -y gitlab-runner

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Adicionar o usuário gitlab-runner ao grupo docker
sudo usermod -aG docker gitlab-runner

# Configurar o runner
echo "Por favor, execute o seguinte comando para registrar o runner:"
echo "sudo gitlab-runner register"
echo ""
echo "Você precisará das seguintes informações do GitLab:"
echo "1. URL do GitLab (ex: https://gitlab.com/)"
echo "2. Token de registro do runner"
echo "3. Descrição do runner"
echo "4. Tags do runner (opcional)"
echo "5. Executor (recomendado: docker)"
echo "6. Imagem Docker padrão (recomendado: alpine:latest)" 