# Estágio de construção
FROM node:18.18-alpine3.18 AS build

# Criando diretório de trabalho
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Copiando os arquivos de manifesto e instalando dependências
COPY package*.json ./
RUN npm install

# Copiando o restante dos arquivos da aplicação
COPY . .

# Construindo a aplicação
RUN npm run build

# Estágio de produção
FROM node:18.18-alpine3.18

# Criando diretório de trabalho
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Copiando apenas os arquivos necessários para produção
COPY --from=build /home/node/app .

# Expondo a porta que a aplicação irá rodar
EXPOSE 3000

# Comando para rodar a aplicação
CMD [ "npm", "start" ]
