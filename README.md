# InfraDevOps

Projeto de infraestrutura e DevOps utilizando Terraform, Helm, ArgoCD e CI/CD.

## Estrutura do Projeto

```
.
├── argo/           # Configurações do ArgoCD
│   ├── apps/       # Aplicações gerenciadas pelo ArgoCD
│   └── bootstrap/  # Configurações iniciais do ArgoCD
├── ci/             # Configurações de CI/CD
├── docs/           # Documentação do projeto
├── helm/           # Charts Helm
│   └── addons/     # Addons e componentes adicionais
├── scripts/        # Scripts utilitários
├── src/            # Código fonte
└── terraform/      # Código Terraform
    ├── environments/ # Ambientes (dev, staging, prod)
    └── modules/     # Módulos reutilizáveis
```

## Requisitos

- Terraform >= 1.0.0
- Helm >= 3.0.0
- kubectl
- ArgoCD CLI

## Configuração do GitLab

### 1. Configuração do Ambiente

O projeto inclui um script para configurar as variáveis de ambiente necessárias:

```bash
# Execute o script de configuração
./scripts/setup-env.sh
```

O script irá:
1. Solicitar suas credenciais do GitLab
2. Criar um arquivo `.env` com as variáveis necessárias
3. Configurar o projeto com as credenciais fornecidas

**Importante**: O arquivo `.env` contém informações sensíveis e não deve ser versionado no Git.

### 2. Criação da Conta e Token de Acesso

1. Acesse https://gitlab.com/users/sign_up
2. Crie uma conta com seus dados
3. Após criar a conta, gere um token de acesso pessoal (PAT):
   - Acesse Settings > Access Tokens
   - Crie um novo token com as permissões necessárias
   - Guarde o token gerado em um local seguro

### 3. Criação do Projeto e Integração

1. O projeto é criado como privado usando o script `scripts/setup-gitlab-project.sh`
2. Configuração do remote do Git com autenticação via token:
   ```bash
   git remote set-url gitlab https://oauth2:${GITLAB_TOKEN}@gitlab.com/${GITLAB_USERNAME}/infradevops.git
   ```

3. Push inicial do código:
   ```bash
   git push -u gitlab master
   ```

### 4. Configuração do CI/CD

O projeto inclui um pipeline GitLab CI/CD configurado no arquivo `.gitlab-ci.yml` com os seguintes estágios:

- Validate: Validação do código Terraform
- Test: Testes de infraestrutura
- Build: Build de imagens Docker (se necessário)
- Deploy: Deploy para ambientes dev e prod
- Notify: Notificações de conclusão

### 5. Configuração do Runner

O projeto inclui configuração para GitLab Runner no arquivo `config.toml`. Para instalar e configurar o runner:

1. Execute o script de setup:
   ```bash
   ./scripts/setup-gitlab-runner.sh
   ```

2. Siga as instruções do script para registrar o runner com o token fornecido pelo GitLab

## Como Usar

[Instruções de uso serão adicionadas conforme o desenvolvimento do projeto]

## Contribuição

[Instruções de contribuição serão adicionadas conforme o desenvolvimento do projeto]

## Licença

[Informações de licença serão adicionadas conforme o desenvolvimento do projeto]
