#!/bin/bash

# Configurações
GITLAB_API_URL="https://gitlab.com/api/v4"
GITLAB_TOKEN="YOUR_GITLAB_TOKEN"
PROJECT_NAME="$1"
PROJECT_TYPE="$2"  # api-node, api-java, frontend, terraform

# Verificar se o nome do projeto e o tipo foram fornecidos
if [ -z "$PROJECT_NAME" ] || [ -z "$PROJECT_TYPE" ]; then
    echo "Uso: $0 <nome_do_projeto> <tipo_do_projeto>"
    exit 1
fi

# Criar o projeto no GitLab
curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
     --data "name=$PROJECT_NAME" \
     "$GITLAB_API_URL/projects"

# Obter o ID do projeto
PROJECT_ID=$(curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
                  "$GITLAB_API_URL/projects?search=$PROJECT_NAME" | jq -r '.[0].id')

# Configurar as branches dev e master
curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
     --data "name=dev" \
     --data "protected=true" \
     "$GITLAB_API_URL/projects/$PROJECT_ID/protected_branches"

curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
     --data "name=master" \
     --data "protected=true" \
     "$GITLAB_API_URL/projects/$PROJECT_ID/protected_branches"

# Copiar o modelo de projeto e .gitlab-ci.yml
case $PROJECT_TYPE in
    api-node)
        cp templates/api-node/.gitlab-ci.yml .
        ;;
    api-java)
        cp templates/api-java/.gitlab-ci.yml .
        ;;
    frontend)
        cp templates/frontend/.gitlab-ci.yml .
        ;;
    terraform)
        cp templates/terraform/.gitlab-ci.yml .
        ;;
    *)
        echo "Tipo de projeto não reconhecido: $PROJECT_TYPE"
        exit 1
        ;;
esac

echo "Projeto $PROJECT_NAME criado com sucesso!" 