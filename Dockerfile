# Estágio de construção
FROM node:18.18-alpine3.18 AS build

# Criando diretório de trabalho
WORKDIR /home/node/app

# Copiando os arquivos de manifesto e instalando dependências se o package.json existir
COPY package*.json ./

RUN if [ -f package.json ]; then npm install; fi

# Copiando o restante dos arquivos da aplicação
COPY . .

# Construindo a aplicação se houver um script build no package.json
RUN if [ -f package.json ]; then npm run build; fi

# Estágio de produção
FROM node:18.18-alpine3.18

# Criando diretório de trabalho
WORKDIR /home/node/app

# Copiando apenas os arquivos necessários para produção
COPY --from=build /home/node/app .

# Expondo a porta que a aplicação irá rodar
EXPOSE 3000

# Comando para rodar a aplicação se o package.json existir
CMD if [ -f package.json ]; then npm start; else echo "No package.json found, no npm start command to run"; fi
