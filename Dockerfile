# Define a imagem base
FROM alpine:latest

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos do projeto para o diretório de trabalho
COPY . /app

# Instala as dependências do projeto (se necessário)
RUN npm install

# Define o comando de inicialização do container
CMD ["npm", "start"]