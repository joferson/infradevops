#!/bin/bash

# Exemplo de script para criar variáveis no GitLab via API
# NÃO use este script com dados reais, apenas como referência

# Configurações
GITLAB_TOKEN="glpat-xxxxxxxxxxxxxxxxxxxx"
GITLAB_PROJECT_ID="12345678"  # Substitua pelo ID real do seu projeto
GITLAB_API_URL="https://gitlab.com/api/v4/projects/$GITLAB_PROJECT_ID/variables"

# Função para criar variável
create_variable() {
    local key="$1"
    local value="$2"
    local protected="$3"
    local masked="$4"

    echo "Criando variável: $key"
    curl --request POST "$GITLAB_API_URL" \
        --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        --form "key=$key" \
        --form "value=$value" \
        --form "protected=$protected" \
        --form "masked=$masked"
    echo -e "\n"
}

# Variáveis sensíveis (protegidas e mascaradas)
create_variable "GITLAB_EMAIL" "usuario@exemplo.com" "true" "true"
create_variable "GITLAB_USERNAME" "usuarioexemplo" "true" "true"
create_variable "GITLAB_PASSWORD" "senha_ficticia" "true" "true"
create_variable "GITLAB_TOKEN" "glpat-xxxxxxxxxxxxxxxxxxxx" "true" "true"

# Variáveis não sensíveis
create_variable "PROJECT_NAME" "meuprojeto" "false" "false"
create_variable "PROJECT_VISIBILITY" "private" "false" "false"

echo "Todas as variáveis foram criadas com sucesso!" 