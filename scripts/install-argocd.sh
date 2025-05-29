#!/bin/bash

# Script para instalar o ArgoCD no ambiente local
# Este script pode ser adaptado para outros clusters Kubernetes

# Verifica se o kubectl está instalado
if ! command -v kubectl &> /dev/null; then
    echo "kubectl não encontrado. Por favor, instale o kubectl primeiro."
    exit 1
fi

# Verifica se o cluster está acessível
if ! kubectl cluster-info &> /dev/null; then
    echo "Não foi possível conectar ao cluster Kubernetes. Verifique sua configuração."
    exit 1
fi

echo "Instalando ArgoCD no cluster..."

# Cria o namespace argocd se não existir
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Aplica o arquivo de instalação do ArgoCD
kubectl apply -f argo/bootstrap/argocd-install.yaml

# Aguarda os pods estarem prontos
echo "Aguardando os pods do ArgoCD estarem prontos..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Obtém a senha inicial do admin
echo "Obtendo a senha inicial do admin..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "ArgoCD instalado com sucesso!"
echo "Para acessar a interface web, execute: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "Acesse: https://localhost:8080"
echo "Usuário: admin"
echo "Senha: $ARGOCD_PASSWORD"
echo ""
echo "Para instalar o CLI do ArgoCD, execute:"
echo "curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"
echo "sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd"
echo "rm argocd-linux-amd64" 