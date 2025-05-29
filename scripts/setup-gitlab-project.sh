#!/bin/bash

# Verifica se as variáveis de ambiente necessárias estão definidas
if [ -z "$GITLAB_TOKEN" ]; then
    echo "Por favor, defina a variável de ambiente GITLAB_TOKEN:"
    echo "export GITLAB_TOKEN='seu-token'"
    exit 1
fi

# Instala dependências necessárias
sudo apt-get update
sudo apt-get install -y curl jq

# Função para fazer requisições à API do GitLab
gitlab_api() {
    local method=$1
    local endpoint=$2
    local data=$3

    curl -s -X "$method" \
        -H "Content-Type: application/json" \
        -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        -d "$data" \
        "https://gitlab.com/api/v4$endpoint"
}

# 1. Verificar autenticação
echo "Verificando autenticação..."
user_response=$(gitlab_api "GET" "/user" "")

if echo "$user_response" | jq -e '.id' > /dev/null; then
    echo "Autenticação bem-sucedida!"
    username=$(echo "$user_response" | jq -r '.username')
    echo "Usuário: $username"
else
    echo "Erro na autenticação. Por favor, verifique seu token."
    exit 1
fi

# 2. Excluir projeto existente (se existir)
echo "Verificando projeto existente..."
project_response=$(gitlab_api "GET" "/projects/jofersonsodre%2Finfradevops" "")

if echo "$project_response" | jq -e '.id' > /dev/null; then
    echo "Projeto existente encontrado. Excluindo..."
    delete_response=$(gitlab_api "DELETE" "/projects/jofersonsodre%2Finfradevops" "")
    echo "Projeto excluído com sucesso!"
fi

# 3. Criar novo projeto
echo "Criando novo projeto..."
project_data="{\"name\":\"infradevops\",\"visibility\":\"private\",\"description\":\"Projeto de infraestrutura e DevOps utilizando Terraform, Helm, ArgoCD e CI/CD\"}"
project_response=$(gitlab_api "POST" "/projects" "$project_data")

# Verifica se o projeto foi criado com sucesso
if echo "$project_response" | jq -e '.id' > /dev/null; then
    echo "Projeto criado com sucesso!"
    project_id=$(echo "$project_response" | jq -r '.id')
    project_url=$(echo "$project_response" | jq -r '.http_url_to_repo')
    
    # 4. Configurar o remote do Git
    echo "Configurando remote do Git..."
    git remote add gitlab "$project_url"
    
    # 5. Obter token do runner
    echo "Obtendo token do runner..."
    runner_token=$(gitlab_api "GET" "/projects/$project_id/runners" "" | jq -r '.[0].token')
    
    # 6. Atualizar o arquivo config.toml
    sed -i "s/YOUR_RUNNER_TOKEN/$runner_token/" config.toml
    
    echo "Configuração concluída!"
    echo "URL do projeto: $project_url"
    echo "Token do runner: $runner_token"
else
    echo "Erro ao criar projeto:"
    echo "$project_response" | jq '.'
    exit 1
fi 