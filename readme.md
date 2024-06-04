# Docker Image CI/CD with GitHub Actions

Este repositório demonstra como configurar uma pipeline de CI/CD usando GitHub Actions para construir e enviar uma imagem Docker para o Docker Hub.

## Estrutura do Projeto

- `Dockerfile`: Arquivo que contém as instruções para construir a imagem Docker.
- `.github/workflows/docker-image.yml`: Workflow do GitHub Actions que automatiza a construção e envio da imagem Docker para o Docker Hub.

## Pré-requisitos

1. **Conta no Docker Hub**: Crie uma conta gratuita em [Docker Hub](https://hub.docker.com/).
2. **Repositório no GitHub**: Este repositório onde você está lendo este README.
3. **Git instalado**: Certifique-se de ter o Git instalado em sua máquina.

## Configuração

### Passo 1: Clonar o Repositório

Clone este repositório para sua máquina local:

```bash
git clone https://github.com/usuario/nome-do-repositorio.git
cd nome-do-repositorio
```
Passo 2: Adicionar o Dockerfile
Crie um arquivo Dockerfile com o seguinte conteúdo ou personalize conforme necessário:

dockerfile
Copiar código
# Use uma imagem base oficial do Node.js 14
FROM node:14

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie o package.json e o package-lock.json
COPY package*.json ./

# Instale as dependências do projeto
RUN npm install

# Copie o restante dos arquivos da aplicação
COPY . .

# Exponha a porta que a aplicação irá rodar
EXPOSE 8080

# Comando para iniciar a aplicação
CMD ["node", "app.js"]
Passo 3: Configurar GitHub Actions
Crie um arquivo de workflow do GitHub Actions em .github/workflows/docker-image.yml com o seguinte conteúdo:

yaml
Copiar código
name: Build and Push Docker Image

on:
push:
branches:
- main  # Defina a branch que irá disparar a ação

jobs:
build:
runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1

    - name: Log in to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build and push Docker image
      uses: docker/build-push-action@v2
      with:
        push: true
        tags: ${{ secrets.DOCKER_USERNAME }}/my-app:latest
Passo 4: Adicionar Segredos no GitHub
Adicione os seguintes segredos ao seu repositório no GitHub:

DOCKER_USERNAME: Seu nome de usuário do Docker Hub.
DOCKER_PASSWORD: Sua senha do Docker Hub.
Para adicionar segredos:

Vá até a aba Settings do seu repositório no GitHub.
No menu lateral, clique em Secrets and variables > Actions.
Clique em New repository secret e adicione os segredos DOCKER_USERNAME e DOCKER_PASSWORD.
Passo 5: Fazer Push das Mudanças
Commit e push dos arquivos Dockerfile e docker-image.yml para a branch main:

bash
Copiar código
git add .
git commit -m "Add Dockerfile and GitHub Actions workflow"
git push origin main
Verificando a Execução do Workflow
Vá até a aba Actions no seu repositório GitHub e verifique se o workflow foi executado com sucesso. Se houver algum erro, o GitHub Actions mostrará o log detalhado para ajudar na depuração.

Contribuições
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests para melhorias ou correções.

Licença
Este projeto está licenciado sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.