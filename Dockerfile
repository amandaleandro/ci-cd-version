# Estágio de construção
FROM node:18.18-alpine3.18 as build

# Definindo o argumento de versão
ARG version
ENV version=${version}

# Definindo o usuário de trabalho
USER node

# Criando o diretório de trabalho
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Copiando os arquivos de manifesto e instalando dependências
COPY package*.json ./
RUN npm ci

# Copiando o restante dos arquivos da aplicação
COPY . .

# Construindo a aplicação
RUN npm run build

# Estágio de produção
FROM node:18.18-alpine3.18 as production

# Definindo o usuário de trabalho
USER node

# Criando o diretório de trabalho
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Copiando apenas os artefatos necessários da etapa de construção
COPY --from=build /home/node/app/package*.json ./
COPY --from=build /home/node/app/package-lock.json ./
COPY --from=build /home/node/app/dist ./dist

# Instalando apenas as dependências de produção
RUN npm ci --only=production

# Expondo a porta da aplicação
EXPOSE 3000

# Configurando o fuso horário e o ambiente Node.js
ENV TZ=America/Sao_Paulo
ENV NODE_ENV=prod

# Comando de execução da aplicação
CMD ./node_modules/.bin/ts-node ./node_modules/.bin/typeorm migration:run -d src/orm/config/ormconfig.prod.ts && npm run start:prod
